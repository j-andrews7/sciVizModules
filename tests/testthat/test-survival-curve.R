# Unit and smoke tests for the survivalCurve module.
#
# The curve, its band and its statistics are checked against survival::survfit()
# and survival::survdiff(), which compute them independently of the plotting code.

lung_fit <- function(conf.int = 0.95, conf.type = "log") {
    data(survival_lung, package = "sciVizModules", envir = environment())
    df <- survival_lung
    df$.surv_time <- df$time
    df$.surv_status <- .normalize_survival_status(df$status)
    df$.stratum <- factor(as.character(df$sex), levels = .surv_levels(df$sex))
    list(
        df = df,
        fit = survival::survfit(survival::Surv(.surv_time, .surv_status) ~ .stratum,
            data = df, conf.int = conf.int, conf.type = conf.type),
        levels = levels(df$.stratum)
    )
}

traces_of <- function(fig) plotly::plotly_build(fig)$x$data
bands_of <- function(traces) Filter(function(t) identical(t$fill, "toself"), traces)
curves_of <- function(traces) {
    Filter(function(t) identical(t$mode, "lines") && is.null(t$fill) && !identical(t$name, "Median"), traces)
}

test_that("all survivalCurve functions are exported", {
    for (name in c(
        "survivalCurve", "survivalCurveInputsUI", "survivalCurveOutputUI",
        "survivalCurveServer", "survivalCurveApp"
    )) {
        expect_true(is.function(get0(name, envir = asNamespace("sciVizModules"))), info = name)
    }
})

test_that(".detect_time_col prefers an exact 'time' match", {
    df <- data.frame(age = 1, time = 2, surv_months = 3)
    num <- names(df)
    expect_identical(.detect_time_col(df, num), "time")

    # No recognizable name: fall back to the first numeric column.
    df2 <- data.frame(a = 1, b = 2)
    expect_identical(.detect_time_col(df2, names(df2)), "a")

    expect_null(.detect_time_col(df2, character(0)))
})

test_that(".detect_status_col prefers an exact 'status' match", {
    df <- data.frame(time = 1, status = 1, event_free = 0)
    expect_identical(.detect_status_col(df, names(df)), "status")

    # No named candidate: a 0/1 indicator column is taken instead.
    df2 <- data.frame(time = c(10, 20, 30), flag = c(0, 1, 1))
    expect_identical(.detect_status_col(df2, names(df2)), "flag")
})

test_that(".normalize_survival_status maps every supported encoding to 0/1", {
    expect_identical(.normalize_survival_status(c(TRUE, FALSE)), c(1L, 0L))
    # survival::Surv()'s 1/2 convention: 2 is the event.
    expect_identical(.normalize_survival_status(c(1, 2, 1)), c(0, 1, 0))
    # 0/1 is already correct and passes through.
    expect_identical(.normalize_survival_status(c(0, 1, 1)), c(0, 1, 1))
    expect_identical(.normalize_survival_status(c("Dead", "Alive")), c(1, 0))
    expect_identical(.normalize_survival_status(factor(c("yes", "no"))), c(1, 0))
    expect_true(is.na(.normalize_survival_status(c(NA_character_, "dead"))[1]))
})

test_that("survival_lung has the columns the module expects", {
    data(survival_lung, package = "sciVizModules")
    expect_s3_class(survival_lung, "data.frame")
    expect_true(all(c("time", "status", "age", "sex") %in% names(survival_lung)))
    expect_true(is.numeric(survival_lung$time))
    expect_setequal(unique(as.character(survival_lung$sex)), c("Male", "Female"))
})

test_that(".surv_levels keeps a factor's order and sorts anything else", {
    expect_identical(.surv_levels(factor(c("b", "a", "c"), levels = c("c", "b", "a", "z"))), c("c", "b", "a"))
    expect_identical(.surv_levels(c("b", NA, "a", "b")), c("a", "b"))
})

test_that(".km_frame starts each stratum at survival 1 and matches survfit", {
    lf <- lung_fit()
    km <- .km_frame(lf$fit, lf$levels)
    for (g in lf$levels) {
        d <- km[km$stratum == g, ]
        expect_identical(unlist(d[1, c("time", "surv", "lower", "upper")], use.names = FALSE), c(0, 1, 1, 1))
        s <- summary(lf$fit[paste0(".stratum=", g)], censored = TRUE)
        expect_equal(d$surv[-1], s$surv)
        expect_equal(d$lower[-1], s$lower)
        expect_equal(d$upper[-1], s$upper)
        expect_equal(d$n.censor[-1], s$n.censor)
    }

    # Reversing transformations keep lower <= upper; -log(0) has no value.
    for (fun in c("event", "cumhaz")) {
        tf <- .km_frame(lf$fit, lf$levels, fun)
        ok <- !is.na(tf$lower) & !is.na(tf$upper)
        expect_true(all(tf$lower[ok] <= tf$upper[ok]), info = fun)
    }
    expect_equal(.km_frame(lf$fit, lf$levels, "event")$surv, 1 - km$surv)
    expect_equal(.km_frame(lf$fit, lf$levels, "pct")$surv, 100 * km$surv)
})

test_that(".km_steps holds each estimate until the next time", {
    km <- data.frame(
        stratum = factor(rep("A", 3)), time = c(0, 2, 5), surv = c(1, 0.6, 0.2),
        lower = c(1, 0.4, NA), upper = c(1, 0.8, NA)
    )
    st <- .km_steps(km)
    expect_identical(st$time, c(0, 2, 2, 5, 5))
    expect_identical(st$surv, c(1, 1, 0.6, 0.6, 0.2))
    expect_identical(st$lower, c(1, 1, 0.4, 0.4, NA))
    expect_identical(names(st), c(".stratum", "time", "surv", "lower", "upper"))
})

test_that("survivalCurve() draws a band per curve that toggles with it", {
    data(survival_lung, package = "sciVizModules")
    expect_no_warning(fig <- survivalCurve(survival_lung, time = "time", status = "status", group.by = "sex"))
    expect_s3_class(fig, "plotly")
    traces <- traces_of(fig)

    curves <- curves_of(traces)
    bands <- bands_of(traces)
    expect_setequal(vapply(curves, function(t) t$name, ""), c("Male", "Female"))
    expect_length(bands, 2)
    for (b in bands) {
        line <- Filter(function(t) identical(t$name, b$name), curves)[[1]]
        expect_identical(b$legendgroup, line$legendgroup)
        expect_false(isTRUE(b$showlegend))
    }
    expect_identical(plotly::plotly_build(fig)$x$layout$legend$title$text, "sex")

    no_band <- traces_of(survivalCurve(survival_lung, time = "time", status = "status", group.by = "sex",
        conf.int = FALSE))
    expect_length(bands_of(no_band), 0)
})

test_that("a lower confidence level gives a narrower band", {
    data(survival_lung, package = "sciVizModules")
    width_of <- function(level) {
        lf <- lung_fit(conf.int = level)
        km <- .km_frame(lf$fit, lf$levels)
        mean(km$upper - km$lower, na.rm = TRUE)
    }
    expect_lt(width_of(0.9), width_of(0.95))

    plain <- lung_fit(conf.type = "plain")
    expect_false(isTRUE(all.equal(plain$fit$lower, lung_fit()$fit$lower)))
})

test_that("censoring marks sit at every censored time, in their curve's colour", {
    data(survival_lung, package = "sciVizModules")
    lf <- lung_fit()
    pal <- c(Female = "#112233", Male = "#445566")
    fig <- survivalCurve(survival_lung, time = "time", status = "status", group.by = "sex", palette.selection = pal)
    marks <- Filter(function(t) identical(t$mode, "markers"), traces_of(fig))
    for (m in marks) {
        s <- summary(lf$fit[paste0(".stratum=", m$name)], censored = TRUE)
        expect_equal(as.numeric(m$x), s$time[s$n.censor > 0])
        expect_identical(m$marker$color, pal[[m$name]])
        expect_identical(m$legendgroup, m$name)
    }

    none <- traces_of(survivalCurve(survival_lung, time = "time", status = "status", censor = FALSE))
    expect_length(Filter(function(t) identical(t$mode, "markers"), none), 0)
})

test_that("colours follow the strata by name, not position", {
    data(survival_lung, package = "sciVizModules")
    pal <- c(Male = "#0000FF", Female = "#FF0000")
    curves <- curves_of(traces_of(survivalCurve(survival_lung, time = "time", status = "status",
        group.by = "sex", palette.selection = pal)))
    for (t in curves) {
        expect_identical(as.character(t$line$color), plotly::toRGB(pal[[t$name]]))
    }
})

test_that("the p-value, medians and risk table match the survival package", {
    data(survival_lung, package = "sciVizModules")
    lf <- lung_fit()
    sd <- survival::survdiff(survival::Surv(.surv_time, .surv_status) ~ .stratum, data = lf$df)
    p <- stats::pchisq(sd$chisq, length(sd$n) - 1, lower.tail = FALSE)

    fig <- survivalCurve(survival_lung, time = "time", status = "status", group.by = "sex",
        surv.median.line = "hv", risk.table = TRUE, break.time.by = 250)
    tab <- attr(fig, "table")
    expect_equal(tab$logrank.p[1], p)
    expect_equal(tab$median, unname(summary(lf$fit)$table[, "median"]))
    expect_identical(tab$stratum, lf$levels)

    built <- plotly::plotly_build(fig)
    texts <- vapply(built$x$layout$annotations, function(a) as.character(a$text), "")
    expect_true(.km_pvalue_text(p) %in% texts)

    median_line <- Filter(function(t) identical(t$name, "Median"), built$x$data)[[1]]
    expect_true(all(stats::na.omit(as.numeric(median_line$x)) %in% c(0, tab$median)))

    risk <- Filter(function(t) identical(t$mode, "text"), built$x$data)
    expect_length(risk, 2)
    s <- summary(lf$fit, times = seq(0, 1000, by = 250), extend = TRUE)
    for (r in risk) {
        expect_equal(as.numeric(r$text), s$n.risk[s$strata == paste0(".stratum=", r$name)])
        expect_identical(r$yaxis, "y2")
        # Black, and drawn whole at the ends of the time axis.
        expect_identical(r$textfont$color, "#000000")
        expect_false(r$cliponaxis)
    }

    # The table has a time axis of its own, zoomed with the curve's, so the
    # curve keeps its own border and the table takes none of its gridlines.
    lay <- built$x$layout
    expect_identical(lay$xaxis$anchor, "y")
    expect_identical(lay$xaxis2$matches, "x")
    expect_false(lay$xaxis$showticklabels)
    expect_identical(lay$xaxis2$title$text, "Time")
    expect_identical(lay$xaxis$title$text, "")
    expect_equal(c(lay$xaxis$dtick, lay$xaxis2$dtick), c(250, 250))
    # Half a row of room around the rows, which stay put on zoom.
    expect_equal(lay$yaxis2$range, c(-0.5, 1.5))
    expect_true(lay$yaxis2$fixedrange)
    expect_false(lay$xaxis2$showgrid)
    expect_false(lay$yaxis2$showgrid)
    expect_named(attr(fig, "fixed.axes"), c("xaxis2", "yaxis2"))

    # One stratum: no p-value.
    single <- survivalCurve(survival_lung, time = "time", status = "status")
    expect_true(all(is.na(attr(single, "table")$logrank.p)))
    expect_length(plotly::plotly_build(single)$x$layout$annotations, 0)
})

test_that(".km_pvalue_text rounds and floors as survminer did", {
    expect_identical(.km_pvalue_text(0.001311165), "p = 0.0013")
    expect_identical(.km_pvalue_text(0.12), "p = 0.12")
    expect_identical(.km_pvalue_text(1e-6), "p < 0.0001")
})

test_that("OutputUI builds a plotly container and honours resizable", {
    ui <- survivalCurveOutputUI("test")
    expect_true(inherits(ui, c("shiny.tag", "shiny.tag.list", "shiny.tag.function")))
    expect_true("resizable" %in% names(formals(survivalCurveOutputUI)))
    expect_true(inherits(
        survivalCurveOutputUI("test", resizable = FALSE),
        c("shiny.tag", "shiny.tag.list", "shiny.tag.function")
    ))
})

test_that("InputsUI builds from survival_lung with detected defaults", {
    data(survival_lung, package = "sciVizModules")
    ui <- survivalCurveInputsUI("surv", survival_lung)
    expect_true(inherits(ui, c("shiny.tag", "shiny.tag.list")))

    html <- as.character(ui)
    for (key in c("surv-time", "surv-status", "surv-group.by", "surv-fun", "surv-conf.int", "surv-conf.level",
        "surv-conf.type", "surv-conf.int.opacity", "surv-break.time.by")) {
        expect_true(grepl(key, html, fixed = TRUE), info = key)
    }
    d <- .surv_defaults(survival_lung)
    expect_identical(d$time, "time")
    expect_identical(d$status, "status")
    expect_false(.surv_defaults(survival_lung, list(conf.int = FALSE))$conf.int)
})

test_that("the server applies the band inputs and every Legend tab control", {
    data(survival_lung, package = "sciVizModules")

    shiny::testServer(
        survivalCurveServer,
        args = list(data = shiny::reactive(survival_lung)),
        expr = {
            do.call(session$setInputs, c(
                list(auto.update = TRUE, time = "time", status = "status", group.by = "sex",
                     conf.int = TRUE, conf.level = 0.9, conf.type = "log-log", conf.int.opacity = 0.4,
                     download.format = "png"),
                test_axes_inputs(), test_legend_inputs()
            ))
            built <- plotly::plotly_build(generate_plot())
            expect_false(built$x$layout$showlegend)
            expect_identical(built$x$layout$legend$font$family, "Courier New")
            expect_identical(built$x$layout$legend$font$color, "#123456")
            bands <- bands_of(built$x$data)
            expect_length(bands, 2)
            expect_true(all(grepl(",0.4)$", vapply(bands, function(b) b$fillcolor, ""))))
            expect_identical(nrow(plot_source_reactive()$stats), 2L)

            session$setInputs(conf.int = FALSE)
            expect_length(bands_of(plotly::plotly_build(generate_plot())$x$data), 0)
        }
    )
})

test_that("the risk table stays gridless and the curve boxed under the Axes tab", {
    data(survival_lung, package = "sciVizModules")

    shiny::testServer(
        survivalCurveServer,
        args = list(data = shiny::reactive(survival_lung)),
        expr = {
            axes <- utils::modifyList(test_axes_inputs(), list(show.grid.x = TRUE, show.grid.y = TRUE))
            do.call(session$setInputs, c(
                list(auto.update = TRUE, time = "time", status = "status", group.by = "sex", risk.table = TRUE,
                     download.format = "png"),
                axes, test_legend_inputs()
            ))
            # As renderPlotly() draws it, margins and all.
            lay <- plotly::plotly_build(apply_render_margins(generate_plot(), input))$x$layout
            expect_true(lay$xaxis$showgrid)
            expect_true(lay$yaxis$showgrid)
            expect_false(lay$xaxis2$showgrid)
            expect_false(lay$yaxis2$showgrid)
            # Each panel is boxed by its own axis lines, so no border shapes.
            expect_true(lay$xaxis$mirror)
            expect_true(lay$xaxis$showline)
            expect_identical(lay$xaxis$anchor, "y")
            expect_length(lay$shapes, 0)
        }
    )
})

test_that("a colour mapping in defaults reaches the curves before the picker is drawn", {
    data(survival_lung, package = "sciVizModules")
    pal <- c(Male = "#111111", Female = "#222222")
    shiny::testServer(
        survivalCurveServer,
        args = list(data = shiny::reactive(survival_lung), defaults = list(palette.colours = pal)),
        expr = {
            do.call(session$setInputs, c(
                list(auto.update = TRUE, time = "time", status = "status", group.by = "sex", download.format = "png"),
                test_axes_inputs(), test_legend_inputs()
            ))
            expect_identical(state$palette_store()[c("Male", "Female")], pal)
            curves <- curves_of(plotly::plotly_build(generate_plot())$x$data)
            for (t in curves) expect_identical(as.character(t$line$color), plotly::toRGB(pal[[t$name]]))
        }
    )
})

test_that("Group By leaves out columns with too many levels to draw a curve each", {
    df <- data.frame(
        time = seq_len(60),
        status = rep(c(0, 1), 30),
        patient = paste0("p", seq_len(60)),
        arm = rep(c("A", "B"), 30),
        stringsAsFactors = FALSE
    )
    choices_of <- function(html, id) {
        config <- regmatches(html, regexpr(paste0("data-for=\"", id, "\">.*?</script>"), html))
        opts <- jsonlite::fromJSON(sub("</script>$", "", sub("^data-for=\"[^\"]+\">", "", config)))$options
        unlist(opts$choices$value %||% lapply(opts$choices, function(g) g$value))
    }

    groups <- choices_of(as.character(survivalCurveInputsUI("surv", df)), "surv-group.by")
    expect_true("arm" %in% groups)
    expect_false("patient" %in% groups)
})

# The fitted frame survivalCurve() builds, stratified by ph.ecog (four groups,
# one of them a single subject).
ecog_frame <- function() {
    data(survival_lung, package = "sciVizModules", envir = environment())
    df <- survival_lung[!is.na(survival_lung$ph.ecog), ]
    df$.surv_time <- df$time
    df$.surv_status <- .normalize_survival_status(df$status)
    df$.stratum <- factor(as.character(df$ph.ecog), levels = .surv_levels(df$ph.ecog))
    df
}

test_that("pairwise log-rank tests match the survival package and survminer", {
    df <- ecog_frame()
    lv <- levels(df$.stratum)
    for (method in c("holm", "BH")) {
        pw <- .km_pairwise(df, lv, p.adjust.method = method)
        expect_identical(nrow(pw), 6L)
        # Each pair is tested on its own subjects.
        ref <- vapply(seq_len(nrow(pw)), function(i) {
            s <- df[df$.stratum %in% c(pw$group1[i], pw$group2[i]), ]
            sd <- survival::survdiff(survival::Surv(.surv_time, .surv_status) ~ droplevels(.stratum), data = s)
            stats::pchisq(sd$chisq, 1, lower.tail = FALSE)
        }, numeric(1))
        expect_equal(pw$p.value, ref)
        expect_equal(pw$p.adj, stats::p.adjust(ref, method))
        expect_identical(unique(pw$p.adjust.method), method)
    }

    # The hazard ratio is group2 relative to group1, from a Cox model of the pair.
    s <- df[df$.stratum %in% c("Asymptomatic", "Symptomatic"), ]
    s$.stratum <- factor(as.character(s$.stratum), levels = c("Asymptomatic", "Symptomatic"))
    fit <- survival::coxph(survival::Surv(.surv_time, .surv_status) ~ .stratum, data = s)
    expect_identical(c(pw$group1[1], pw$group2[1]), c("Asymptomatic", "Symptomatic"))
    expect_equal(pw$hr[1], unname(exp(stats::coef(fit))))
    expect_equal(c(pw$hr.lower[1], pw$hr.upper[1]), unname(exp(stats::confint(fit))[1, ]))
    expect_identical(c(pw$n1[1], pw$n2[1], pw$events1[1], pw$events2[1]), c(63L, 113L, 37, 82))

    skip_if_not_installed("survminer")
    sm <- survminer::pairwise_survdiff(survival::Surv(time, status) ~ ph.ecog, data = df, p.adjust.method = "BH")
    expect_equal(.km_pairwise(df, lv, p.adjust.method = "BH")$p.adj,
        as.vector(sm$p.value[lower.tri(sm$p.value, diag = TRUE)]))
})

test_that("pairwise tests take only the chosen pairs, and no hazard ratio without a finite estimate", {
    df <- ecog_frame()
    lv <- levels(df$.stratum)
    # A repeat in the other order and a pair naming no stratum are dropped, and
    # the adjustment covers only the pairs tested.
    pw <- .km_pairwise(df, lv, pairs = list(c("Symptomatic", "Asymptomatic"), c("Asymptomatic", "Symptomatic"),
        c("Asymptomatic", "Nope"), c("Asymptomatic", "In bed <50%")), p.adjust.method = "bonferroni")
    expect_identical(pw$group1, c("Symptomatic", "Asymptomatic"))
    expect_identical(pw$group2, c("Asymptomatic", "In bed <50%"))
    expect_equal(pw$p.adj, pmin(1, 2 * pw$p.value))
    expect_null(.km_pairwise(df, lv, pairs = list(c("Nope", "Asymptomatic"))))

    # A group without events still gets its log-rank test, but no hazard ratio.
    toy <- data.frame(
        .surv_time = c(2, 4, 6, 3, 5, 7, 8, 9, 10),
        .surv_status = c(1, 1, 0, 1, 0, 1, 0, 0, 0),
        .stratum = factor(rep(c("A", "B", "C"), each = 3))
    )
    pw <- .km_pairwise(toy, c("A", "B", "C"))
    expect_false(anyNA(pw$p.value))
    expect_true(all(is.na(pw$hr[pw$group2 == "C"])))
    expect_false(is.na(pw$hr[pw$group2 == "B"]))

    # Every event in one group before any in the other: the estimate diverges.
    mono <- data.frame(.surv_time = c(1, 2, 5, 6), .surv_status = 1, .stratum = factor(c("A", "A", "B", "B")))
    expect_no_warning(hr <- .km_pair_hr(mono))
    expect_true(all(is.na(hr)))
})

test_that("pairwise comparisons are listed on the plot and returned beside the summary", {
    data(survival_lung, package = "sciVizModules")
    fig <- survivalCurve(survival_lung, time = "time", status = "status", group.by = "ph.ecog", pairwise = TRUE)
    pw <- attr(fig, "pairwise")
    expect_identical(nrow(pw), 6L)
    # The standalone summary keeps its shape.
    expect_s3_class(attr(fig, "table"), "data.frame")
    expect_identical(nrow(attr(fig, "table")), 4L)

    anns <- plotly::plotly_build(fig)$x$layout$annotations
    ann <- anns[[length(anns)]]
    lines <- strsplit(ann$text, "<br>", fixed = TRUE)[[1]]
    expect_length(lines, 8)
    expect_match(lines[1], "^Log-rank p")
    expect_identical(lines[2], "Pairwise log-rank, Holm-adjusted:")
    expect_identical(lines[3], paste0("Asymptomatic vs Symptomatic: ", .km_pvalue_text(pw$p.adj[1])))
    expect_identical(ann$align, "left")
    expect_match(ann$hovertext, "HR (Symptomatic / Asymptomatic) 1.44, 95% CI", fixed = TRUE)
    expect_match(ann$hovertext, "n 63 / 1, events 37 / 1", fixed = TRUE)

    # Without the global p-value, only the comparisons.
    alone <- plotly::plotly_build(survivalCurve(survival_lung, time = "time", status = "status",
        group.by = "ph.ecog", pairwise = TRUE, pval = FALSE, p.adjust.method = "none"))$x$layout$annotations
    expect_true(startsWith(alone[[length(alone)]]$text, "Pairwise log-rank (unadjusted):<br>"))
    # Too many to list: pointed to the table.
    expect_identical(.km_pairwise_text(pw, max.lines = 3), c("Pairwise log-rank, Holm-adjusted:",
        "6 comparisons: see the statistics table"))

    # With two groups the one comparison is the global test.
    two <- survivalCurve(survival_lung, time = "time", status = "status", group.by = "sex", pairwise = TRUE)
    expect_null(attr(two, "pairwise"))
})

test_that("the server exports the pairwise table beside the strata summary", {
    data(survival_lung, package = "sciVizModules")
    shiny::testServer(
        survivalCurveServer,
        args = list(data = shiny::reactive(survival_lung)),
        expr = {
            do.call(session$setInputs, c(
                list(auto.update = TRUE, time = "time", status = "status", group.by = "ph.ecog", pairwise = TRUE,
                     stat.pairs = "", stat.p.adjust = "BH", download.format = "png"),
                test_axes_inputs(), test_legend_inputs()
            ))
            expect_identical(state$pair_choices()[1], "Asymptomatic vs Symptomatic")
            stats <- plot_source_reactive()$stats
            expect_named(stats, c("strata", "pairwise"))
            expect_identical(nrow(stats$strata), 4L)
            expect_identical(nrow(stats$pairwise), 6L)
            expect_identical(unique(stats$pairwise$p.adjust.method), "BH")

            session$setInputs(stat.pairs = c("Asymptomatic vs Symptomatic", "Asymptomatic vs In bed <50%"))
            expect_identical(nrow(plot_source_reactive()$stats$pairwise), 2L)

            session$setInputs(pairwise = FALSE)
            expect_s3_class(plot_source_reactive()$stats, "data.frame")
        }
    )
})
