# Tests for the pkConcentrationTime module. The NCA parameters are checked
# against PKNCA where it is installed, and against hand calculations.

test_that("all pkConcentrationTime functions are exported", {
    for (name in c("pkConcentrationTime", "pkConcentrationTimeInputsUI", "pkConcentrationTimeOutputUI",
        "pkConcentrationTimeServer", "pkConcentrationTimeApp")) {
        expect_true(is.function(get0(name, envir = asNamespace("sciVizModules"))), info = name)
    }
})

test_that("NCA on a mono-exponential profile matches the hand calculation", {
    t <- c(0, 1, 2, 4, 8, 12)
    k <- 0.2
    c <- c(0, 10 * exp(-k * t[-1]))
    nca <- .pk_nca(t, c, dose = 100)
    expect_equal(nca$cmax, c[2])
    expect_identical(nca$tmax, 1)
    expect_equal(nca$lambda.z, k)
    expect_equal(nca$half.life, log(2) / k)
    # Linear up from 0 to 1 h, log down after, which is exact for an exponential.
    log_part <- sum(vapply(2:5, function(i) (c[i] - c[i + 1]) * (t[i + 1] - t[i]) / log(c[i] / c[i + 1]), 0))
    expect_equal(nca$auclast, c[2] / 2 + log_part)
    expect_equal(nca$aucinf, nca$auclast + c[6] / k)
    expect_equal(nca$cl.f, 100 / nca$aucinf)
    expect_equal(.pk_nca(t, c, auc.method = "linear")$auclast, sum(diff(t) * (head(c, -1) + tail(c, -1)) / 2))
})

test_that("NCA on Theoph matches PKNCA", {
    skip_if_not_installed("PKNCA")
    th <- .pk_example()
    ours <- .pk_nca_table(th, "Time", "conc", "Subject", dose = "Dose")
    conc <- PKNCA::PKNCAconc(th, conc ~ Time | Subject)
    dose <- PKNCA::PKNCAdose(th[!duplicated(th$Subject), c("Subject", "Dose", "Time")], Dose ~ Time | Subject)
    iv <- data.frame(start = 0, end = Inf, cmax = TRUE, tmax = TRUE, auclast = TRUE, half.life = TRUE,
        aucinf.obs = TRUE)
    res <- as.data.frame(as.data.frame(PKNCA::pk.nca(PKNCA::PKNCAdata(conc, dose, intervals = iv))))
    get <- function(s, code) res$PPORRES[res$Subject == s & res$PPTESTCD == code]
    for (s in ours$subject) {
        row <- ours[ours$subject == s, ]
        expect_equal(row$cmax, get(s, "cmax"), info = s)
        expect_equal(row$tmax, get(s, "tmax"), info = s)
        expect_equal(row$auclast, get(s, "auclast"), info = s)
        expect_equal(row$half.life, get(s, "half.life"), info = s)
        expect_equal(row$aucinf, get(s, "aucinf.obs"), info = s)
    }
})

test_that("nominal times align each subject's k-th sample", {
    time <- c(0, 0.27, 1.02, 0, 0.25, 0.98)
    subject <- rep(c("a", "b"), each = 3)
    expect_equal(.pk_nominal_time(time, subject), rep(c(0, 0.26, 1), 2))
    cols <- .pk_columns(.pk_example())
    expect_identical(c(cols$subject, cols$time, cols$conc, cols$dose), c("Subject", "Time", "conc", "Dose"))
})

test_that("the plot draws subjects or group means, with terminal fits on a log axis", {
    th <- .pk_example()
    fig <- pkConcentrationTime(th, "Time", "conc", "Subject", dose = "Dose", log.y = TRUE, show.lambda = TRUE)
    built <- plotly::plotly_build(fig)
    expect_identical(built$x$layout$yaxis$type, "log")
    # 12 subjects, each with a terminal fit.
    expect_length(built$x$data, 24)
    expect_identical(nrow(attr(fig, "table")), 12L)

    mean_fig <- plotly::plotly_build(pkConcentrationTime(th, "Time", "conc", "Subject", mode = "mean"))
    expect_length(mean_fig$x$data, 1)
    expect_true(length(mean_fig$x$data[[1]]$error_y$array) > 5)
    expect_error(pkConcentrationTime(th, "Time", "nope", "Subject"), "not in the data")
})

test_that("group means take their interval from error_bar_halfwidth(), as bars or a ribbon", {
    th <- .pk_example()
    plotted <- data.frame(.group = "All", .subject = as.character(th$Subject), .time = th$Time, .conc = th$conc)
    plotted$.nominal <- .pk_nominal_time(plotted$.time, plotted$.subject)
    summ <- .pk_mean_summary(plotted, "ci95", "t")
    first <- plotted$.conc[plotted$.nominal == summ$time[2]]
    expect_equal(summ$upper[2] - summ$mean[2], VizModules::error_bar_halfwidth(first, "ci95", "t"))
    expect_equal(summ$mean - summ$lower, summ$upper - summ$mean)

    # On a log axis, no lower bound reaches zero or below.
    sd_log <- .pk_mean_summary(plotted[plotted$.conc > 0, ], "sd", "t", log.y = TRUE)
    expect_true(all(sd_log$lower > 0, na.rm = TRUE))
    expect_true(any(.pk_mean_summary(plotted, "sd")$lower <= 0, na.rm = TRUE))

    # A single sample has no interval.
    one <- .pk_mean_summary(data.frame(.group = "A", .nominal = c(1, 2, 2), .conc = c(5, 4, 6)), "sd")
    expect_true(is.na(one$halfwidth[1]))

    ribbon <- plotly::plotly_build(pkConcentrationTime(th, "Time", "conc", "Subject", mode = "mean",
        error.type = "sem", error.bar = FALSE, error.ribbon = TRUE, error.ribbon.opacity = 0.3))
    band <- Filter(function(t) identical(t$fill, "toself"), ribbon$x$data)
    line <- Filter(function(t) !identical(t$fill, "toself"), ribbon$x$data)
    expect_length(band, 1)
    expect_identical(band[[1]]$legendgroup, line[[1]]$legendgroup)
    expect_match(band[[1]]$fillcolor, ",0.3\\)$")
    expect_null(line[[1]]$error_y$array)
    expect_true(all(grepl("SEM .* to .*\\(n = 12\\)|no interval", line[[1]]$text)))
})

test_that("the server builds, finishes and exports the NCA table", {
    th <- .pk_example()
    shiny::testServer(
        pkConcentrationTimeServer,
        args = list(data = shiny::reactive(th)),
        expr = {
            do.call(session$setInputs, c(
                list(auto.update = TRUE, subject.col = "Subject", time.col = "Time", conc.col = "conc",
                    group.col = "", dose.col = "Dose", mode = "individual", log.y = TRUE, show.lambda = FALSE,
                    auc.method = "lin up/log down", download.format = "png"),
                test_axes_inputs(), test_legend_inputs()
            ))
            built <- plotly::plotly_build(generate_plot())
            expect_identical(built$x$layout$yaxis$type, "log")
            expect_identical(nrow(plot_source_reactive()$stats), 12L)

            session$setInputs(mode = "mean", error.bar = TRUE, error.ribbon = TRUE, error.bar.type = "ci95",
                error.bar.ci.method = "normal", error.ribbon.opacity = 0.5)
            built <- plotly::plotly_build(generate_plot())
            expect_length(Filter(function(t) identical(t$fill, "toself"), built$x$data), 1)
            expect_true(any(grepl("95% CI", unlist(lapply(built$x$data, function(t) t$text)))))
        }
    )
    expect_true(inherits(pkConcentrationTimeInputsUI("p", th), c("shiny.tag", "shiny.tag.list")))
})

test_that("Group Column offers small numeric dose groups but not wide columns", {
    df <- data.frame(
        Subject = rep(paste0("s", seq_len(60)), each = 2),
        time = rep(c(0, 1), 60),
        conc = seq_len(120) / 10,
        dose = rep(c(10, 20), each = 60),
        sample.id = paste0("x", seq_len(120)),
        stringsAsFactors = FALSE
    )
    choices_of <- function(html, id) {
        config <- regmatches(html, regexpr(paste0("data-for=\"", id, "\">.*?</script>"), html))
        opts <- jsonlite::fromJSON(sub("</script>$", "", sub("^data-for=\"[^\"]+\">", "", config)))$options
        unlist(opts$choices$value %||% lapply(opts$choices, function(g) g$value))
    }

    groups <- choices_of(as.character(pkConcentrationTimeInputsUI("pk", df)), "pk-group.col")
    expect_true("dose" %in% groups)
    expect_false(any(c("sample.id", "conc", "Subject") %in% groups))
})
