#' Auto-detect a follow-up time column
#'
#' @param data A data frame.
#' @param num.choices Character vector of numeric column names in `data`.
#' @return The name of the best-guess time column, or `NULL`.
#'
#' @author Jacob Martin
#' @rdname INTERNAL_detect_time_col
#' @keywords internal
.detect_time_col <- function(data, num.choices) {
    if (length(num.choices) == 0) {
        return(NULL)
    }
    patterns <- c("^time$", "^os$", "^os_time$", "^pfs$", "^fu", "time", "surv")
    for (p in patterns) {
        hit <- grep(p, num.choices, ignore.case = TRUE, value = TRUE)
        if (length(hit) > 0) {
            return(hit[1])
        }
    }
    num.choices[1]
}
#' Auto-detect an event/status column
#'
#' @param data A data frame.
#' @param num.choices Character vector of numeric column names in `data`.
#' @return The name of the best-guess status column, or `NULL`.
#'
#' @author Jacob Martin
#' @rdname INTERNAL_detect_status_col
#' @keywords internal
.detect_status_col <- function(data, num.choices) {
    patterns <- c("^status$", "^event$", "^vital", "^dead$", "censor", "status", "event")
    for (p in patterns) {
        hit <- grep(p, names(data), ignore.case = TRUE, value = TRUE)
        if (length(hit) > 0) {
            return(hit[1])
        }
    }
    # Fall back to a numeric column that looks like a 0/1 or 1/2 indicator.
    for (nm in num.choices) {
        vals <- unique(stats::na.omit(data[[nm]]))
        if (length(vals) > 0 && length(vals) <= 2 && all(vals %in% c(0, 1, 2))) {
            return(nm)
        }
    }
    if (length(num.choices) > 1) num.choices[2] else if (length(num.choices)) num.choices[1] else NULL
}


#' Default inputs for the survivalCurve module
#'
#' Shared by [survivalCurveInputsUI()] and the module's Reset, so the two cannot
#' drift. The time and status columns are detected from the data unless given.
#'
#' @param data The survival data frame.
#' @param defaults A named list of user defaults, or `NULL`.
#' @return A named list of defaults.
#'
#' @author Jared Andrews
#' @rdname INTERNAL_surv_defaults
#' @keywords internal
.surv_defaults <- function(data, defaults = NULL) {
    data <- as.data.frame(data)
    num <- names(data)[vapply(data, is.numeric, logical(1))]
    base <- list(
        time = .detect_time_col(data, num),
        status = .detect_status_col(data, num),
        group.by = "",
        conf.int = TRUE,
        conf.int.opacity = 0.25,
        conf.level = 0.95,
        conf.type = "log",
        pval = TRUE,
        risk.table = FALSE,
        censor = TRUE,
        surv.median.line = "none",
        fun = "survival",
        line.size = 2,
        break.time.by = NA,
        pairwise = FALSE,
        stat.p.adjust = "holm"
    )
    lapply(stats::setNames(names(base), names(base)), function(k) get_default(defaults, k, base[[k]]))
}

#' Strata of a survival grouping column, in drawing order
#'
#' A factor's level order, otherwise sorted, keeping only the values present.
#' Shared by [survivalCurve()] and the module's colour picker, so both list the
#' strata in the same order.
#'
#' @param x The grouping column.
#' @return A character vector.
#'
#' @author Jared Andrews
#' @rdname INTERNAL_surv_levels
#' @keywords internal
.surv_levels <- function(x) {
    present <- unique(stats::na.omit(as.character(x)))
    lv <- if (is.factor(x)) levels(x) else sort(present)
    lv[lv %in% present]
}

# The band controls, shown only while the band is drawn.
.surv_band_inputs <- c("conf.int.opacity", "conf.level", "conf.type")

# The pairwise comparison controls, shown only while comparisons are on.
.surv_pairwise_inputs <- c("stat.pairs", "stat.p.adjust")

#' Comparisons offered for a set of strata
#'
#' Shared by [survivalCurveInputsUI()] and the module server, which refills the
#' Comparisons select when the grouping changes.
#'
#' @param levels The strata, as from [.surv_levels()].
#' @return `"A vs B"` strings for every pair, in level order, or `character(0)`
#'   for fewer than three strata, where the one comparison is the global test.
#'
#' @author Jared Andrews
#' @rdname INTERNAL_surv_pair_choices
#' @keywords internal
.surv_pair_choices <- function(levels) {
    if (length(levels) < 3) {
        return(character(0))
    }
    generate_pair_strings(data.frame(stratum = levels), "stratum")
}

# The `conf.type` and `fun` choices survivalCurve() accepts; the names are what
# the module's selects display.
.surv_conf_type_choices <- c("Log" = "log", "Log-log" = "log-log", "Plain" = "plain")
.surv_fun_choices <- c(
    "Survival probability" = "survival",
    "Survival percentage" = "pct",
    "Cumulative events" = "event",
    "Cumulative hazard" = "cumhaz"
)


#' Kaplan-Meier estimates of a survival fit, one row per time
#'
#' Unpacks a [survival::survfit()] fit into a frame per stratum, with a row at
#' time 0 (survival 1) leading each stratum, and applies a curve transformation to
#' the estimate and its bounds as survminer does. A transformation that reverses
#' the scale (`"event"`, `"cumhaz"`) swaps the bounds back so `lower <= upper`,
#' and a value it cannot represent (`-log(0)`) becomes `NA`.
#'
#' @param fit A `survfit` object fitted with one stratum per level of `levels`.
#' @param levels The strata, in the fit's order.
#' @param fun `NULL` (survival probability), `"pct"`, `"event"` or `"cumhaz"`.
#' @return A data frame with columns `stratum` (a factor), `time`, `surv`,
#'   `lower`, `upper`, `n.risk`, `n.event` and `n.censor`.
#'
#' @author Jared Andrews
#' @rdname INTERNAL_km_frame
#' @keywords internal
.km_frame <- function(fit, levels, fun = NULL) {
    counts <- if (is.null(fit$strata)) length(fit$time) else as.integer(fit$strata)
    stopifnot(length(counts) == length(levels))
    frame <- data.frame(
        stratum = rep(levels, counts), time = fit$time, surv = fit$surv,
        lower = fit$lower, upper = fit$upper,
        n.risk = fit$n.risk, n.event = fit$n.event, n.censor = fit$n.censor,
        stringsAsFactors = FALSE
    )
    start <- data.frame(
        stratum = levels, time = 0, surv = 1, lower = 1, upper = 1,
        n.risk = fit$n, n.event = 0, n.censor = 0,
        stringsAsFactors = FALSE
    )
    frame <- rbind(start, frame)
    frame$stratum <- factor(frame$stratum, levels = levels)
    # order() is stable, so each stratum's time-0 row stays first.
    frame <- frame[order(frame$stratum), , drop = FALSE]
    rownames(frame) <- NULL

    transform <- switch(fun %||% "survival",
        survival = function(y) y,
        pct = function(y) 100 * y,
        event = function(y) 1 - y,
        cumhaz = function(y) -log(y),
        stop("Unrecognized survival curve transformation: ", fun, call. = FALSE)
    )
    for (col in c("surv", "lower", "upper")) {
        v <- transform(frame[[col]])
        v[!is.finite(v)] <- NA_real_
        frame[[col]] <- v
    }
    lo <- pmin(frame$lower, frame$upper)
    frame$upper <- pmax(frame$lower, frame$upper)
    frame$lower <- lo
    frame
}


#' Step coordinates of a Kaplan-Meier curve
#'
#' A survival curve holds each estimate until the next time, so it is drawn as
#' steps. Each time after the first gets two rows, the previous estimate and then
#' its own, so straight segments through the rows draw the steps exactly, for the
#' curve and for both bounds of its band. A missing bound (where the curve reaches
#' zero, say) leaves a gap in the band from that time on.
#'
#' @param km A frame from [.km_frame()].
#' @return A data frame with columns `.stratum`, `time`, `surv`, `lower` and
#'   `upper`, each stratum's rows in drawing order.
#'
#' @author Jared Andrews
#' @rdname INTERNAL_km_steps
#' @keywords internal
.km_steps <- function(km) {
    cols <- c("stratum", "time", "surv", "lower", "upper")
    parts <- lapply(split(km, km$stratum, drop = TRUE), function(d) {
        n <- nrow(d)
        if (n < 2) {
            return(d[, cols, drop = FALSE])
        }
        at <- c(1L, rep(seq.int(2L, n), each = 2L))
        held <- c(1L, as.vector(rbind(seq_len(n - 1L), seq.int(2L, n))))
        data.frame(
            stratum = d$stratum[at], time = d$time[at],
            surv = d$surv[held], lower = d$lower[held], upper = d$upper[held]
        )
    })
    out <- do.call(rbind, parts)
    rownames(out) <- NULL
    names(out)[1] <- ".stratum"
    out
}


#' Colours of the survival curves
#'
#' @param levels The strata.
#' @param palette.selection Colours named by stratum, or an unnamed vector used in
#'   level order, or `NULL` for the dittoColors defaults.
#' @return A character vector of colours named by stratum.
#'
#' @author Jared Andrews
#' @rdname INTERNAL_km_palette
#' @keywords internal
.km_palette <- function(levels, palette.selection = NULL) {
    fallback <- default_palettes()[["choices"]][["Defaults"]][["dittoColors"]]
    resolve_palette(levels, NULL, fallback, if (length(palette.selection)) palette.selection)
}


#' Y-axis title of a survival curve
#'
#' @param fun The curve transformation, as for [.km_frame()].
#' @return A string.
#'
#' @author Jared Andrews
#' @rdname INTERNAL_km_axis_title
#' @keywords internal
.km_axis_title <- function(fun = NULL) {
    switch(fun %||% "survival",
        survival = "Survival probability",
        pct = "Survival (%)",
        event = "Cumulative event",
        cumhaz = "Cumulative hazard"
    )
}


#' Censoring mark traces of a survival curve
#'
#' One trace per stratum with censored subjects: a tick on the curve at each time
#' a subject was censored, in the stratum's colour and legend group.
#'
#' @param km A frame from [.km_frame()].
#' @param palette Colours named by stratum.
#' @return A list of plotly trace lists, for a built figure's `x$data`.
#'
#' @author Jared Andrews
#' @rdname INTERNAL_km_censor_traces
#' @keywords internal
.km_censor_traces <- function(km, palette) {
    cens <- km[km$n.censor > 0 & !is.na(km$surv), , drop = FALSE]
    groups <- levels(km$stratum)[levels(km$stratum) %in% cens$stratum]
    lapply(groups, function(g) {
        d <- cens[cens$stratum == g, , drop = FALSE]
        list(
            type = "scatter", mode = "markers",
            x = I(d$time), y = I(d$surv),
            name = g, legendgroup = g, showlegend = FALSE,
            marker = list(
                symbol = "line-ns-open", size = 8, color = palette[[g]],
                line = list(color = palette[[g]], width = 1.5)
            ),
            text = I(sprintf("%s<br>%d censored at %s", g, d$n.censor, format(d$time))),
            hoverinfo = "text", xaxis = "x", yaxis = "y"
        )
    })
}


#' Median survival lines of a survival curve
#'
#' As survminer draws them: `"h"` a horizontal line at the median level from 0 to
#' the longest median, `"v"` a vertical line from 0 up to each stratum's median, and
#' `"hv"` both. A stratum whose curve never reaches the median gets none.
#'
#' @param fit The `survfit` object.
#' @param levels The strata, in the fit's order.
#' @param type `"none"`, `"h"`, `"v"` or `"hv"`.
#' @param y The median level on the plotted scale (0.5, or 50 for a percentage).
#' @return A plotly trace list, or `NULL` if there is nothing to draw.
#'
#' @author Jared Andrews
#' @rdname INTERNAL_km_median_trace
#' @keywords internal
.km_median_trace <- function(fit, levels, type = "none", y = 0.5) {
    if (!isTRUE(type %in% c("h", "v", "hv"))) {
        return(NULL)
    }
    med <- stats::setNames(.km_fit_table(fit)[, "median"], levels)
    med <- med[is.finite(med)]
    if (length(med) == 0) {
        return(NULL)
    }

    x <- numeric(0)
    yy <- numeric(0)
    text <- character(0)
    if (type %in% c("h", "hv")) {
        x <- c(0, max(med), NA)
        yy <- c(y, y, NA)
        text <- c("Median", "Median", NA)
    }
    if (type %in% c("v", "hv")) {
        for (g in names(med)) {
            label <- sprintf("%s median: %s", g, format(signif(med[[g]], 4)))
            x <- c(x, med[[g]], med[[g]], NA)
            yy <- c(yy, 0, y, NA)
            text <- c(text, label, label, NA)
        }
    }
    list(
        type = "scatter", mode = "lines", x = I(x), y = I(yy), text = I(text),
        hoverinfo = "text", name = "Median", showlegend = FALSE, connectgaps = FALSE,
        line = list(color = "#000000", width = 1, dash = "dash"), xaxis = "x", yaxis = "y"
    )
}


#' Per-stratum summary table of a survival fit
#'
#' `summary(fit)$table`, always as a matrix (one row per stratum), which a
#' single-stratum fit returns as a vector.
#'
#' @param fit The `survfit` object.
#' @return A numeric matrix.
#'
#' @author Jared Andrews
#' @rdname INTERNAL_km_fit_table
#' @keywords internal
.km_fit_table <- function(fit) {
    tab <- summary(fit)$table
    if (is.null(dim(tab))) tab <- t(as.matrix(tab))
    tab
}


#' Log-rank test across the strata
#'
#' @param df The fitted data, with `.surv_time`, `.surv_status` and `.stratum`.
#' @return A list with `chisq`, `df` and `p`.
#'
#' @author Jared Andrews
#' @rdname INTERNAL_km_logrank
#' @keywords internal
.km_logrank <- function(df) {
    sd <- survival::survdiff(survival::Surv(.surv_time, .surv_status) ~ .stratum, data = df)
    dfree <- length(sd$n) - 1L
    list(chisq = sd$chisq, df = dfree, p = stats::pchisq(sd$chisq, dfree, lower.tail = FALSE))
}


#' Format a log-rank p-value for display
#'
#' @param p The p-value.
#' @return A string such as `"p = 0.0013"` or `"p < 0.0001"`.
#'
#' @author Jared Andrews
#' @rdname INTERNAL_km_pvalue_text
#' @keywords internal
.km_pvalue_text <- function(p) {
    if (p < 1e-4) "p < 0.0001" else paste0("p = ", format(signif(p, 2), scientific = FALSE))
}


#' Pairwise log-rank tests between strata
#'
#' Each pair of strata is compared on its own subjects, as survminer's
#' `pairwise_survdiff()` does: a log-rank test, its p-value adjusted across the
#' comparisons made. Each pair also gets the hazard ratio of its second group
#' against its first, from a Cox model of the pair, with a 95% Wald interval.
#' The hazard ratio is `NA` when either group has no events, or when the
#' model's estimate runs off to infinity (a tiny group whose events all come
#' first, say), since there is no finite estimate to report.
#'
#' @param df The fitted data, with `.surv_time`, `.surv_status` and `.stratum`.
#' @param levels The strata, in the fit's order.
#' @param pairs A list of length-2 character vectors naming the pairs to test,
#'   or `NULL` for every pair, in level order. A pair naming a stratum not in
#'   `levels`, or repeating another in either order, is dropped.
#' @param p.adjust.method A [stats::p.adjust()] method.
#' @return A data frame with one row per pair: `group1`, `group2`, `n1`, `n2`,
#'   `events1`, `events2`, `test`, `chisq`, `p.value`, `p.adj`,
#'   `p.adjust.method`, `hr` (`group2` relative to `group1`), `hr.lower` and
#'   `hr.upper`. `NULL` when there is no pair to test.
#'
#' @author Jared Andrews
#' @rdname INTERNAL_km_pairwise
#' @keywords internal
.km_pairwise <- function(df, levels, pairs = NULL, p.adjust.method = "holm") {
    if (is.null(pairs)) {
        pairs <- if (length(levels) >= 2) utils::combn(levels, 2, simplify = FALSE) else list()
    }
    pairs <- Filter(function(p) length(p) == 2 && all(p %in% levels) && p[1] != p[2], lapply(pairs, as.character))
    pairs <- pairs[!duplicated(lapply(pairs, sort))]
    if (length(pairs) == 0) {
        return(NULL)
    }

    rows <- lapply(pairs, function(p) {
        d <- df[as.character(df$.stratum) %in% p, , drop = FALSE]
        d$.stratum <- factor(as.character(d$.stratum), levels = p)
        n <- as.vector(table(d$.stratum))
        events <- as.vector(tapply(d$.surv_status, d$.stratum, sum))
        lr <- tryCatch(.km_logrank(d), error = function(e) list(chisq = NA_real_, p = NA_real_))
        hr <- if (all(events > 0)) .km_pair_hr(d) else rep(NA_real_, 3)
        data.frame(
            group1 = p[1], group2 = p[2], n1 = n[1], n2 = n[2], events1 = events[1], events2 = events[2],
            test = "log-rank", chisq = lr$chisq, p.value = lr$p, hr = hr[1], hr.lower = hr[2], hr.upper = hr[3],
            stringsAsFactors = FALSE
        )
    })
    out <- do.call(rbind, rows)
    out$p.adj <- stats::p.adjust(out$p.value, method = p.adjust.method)
    out$p.adjust.method <- p.adjust.method
    out[, c("group1", "group2", "n1", "n2", "events1", "events2", "test", "chisq", "p.value", "p.adj",
        "p.adjust.method", "hr", "hr.lower", "hr.upper")]
}


#' Hazard ratio of a pair of strata
#'
#' @param d One pair's subjects, `.stratum` a factor with the reference first.
#' @return The hazard ratio of the second level against the first and its 95%
#'   Wald interval, or three `NA`s when the Cox model has no finite estimate.
#'
#' @author Jared Andrews
#' @rdname INTERNAL_km_pair_hr
#' @keywords internal
.km_pair_hr <- function(d) {
    infinite <- FALSE
    fit <- tryCatch(
        withCallingHandlers(
            survival::coxph(survival::Surv(.surv_time, .surv_status) ~ .stratum, data = d),
            # coxph()'s "coefficient may be infinite" or "did not converge":
            # the estimate diverged.
            warning = function(w) {
                if (grepl("infinite|did not converge", conditionMessage(w))) {
                    infinite <<- TRUE
                    invokeRestart("muffleWarning")
                }
            }
        ),
        error = function(e) NULL
    )
    if (is.null(fit) || infinite) {
        return(rep(NA_real_, 3))
    }
    unname(exp(c(stats::coef(fit), stats::confint(fit, level = 0.95))))
}


# Comparisons beyond this many are left to the statistics table, not listed on the plot.
.km_pairwise_max_lines <- 10

#' On-plot lines and hover text of the pairwise comparisons
#'
#' @param pw A table from [.km_pairwise()].
#' @param max.lines Most comparisons to list on the plot; more are summarised in
#'   one line pointing to the statistics table.
#' @return `.km_pairwise_text()`: a character vector, a header and then a line
#'   per comparison. `.km_pairwise_hover()`: one string, a line per comparison
#'   with its hazard ratio, p-values, subjects and events.
#'
#' @author Jared Andrews
#' @rdname INTERNAL_km_pairwise_text
#' @keywords internal
.km_pairwise_text <- function(pw, max.lines = .km_pairwise_max_lines) {
    method <- pw$p.adjust.method[1]
    header <- if (identical(method, "none")) {
        "Pairwise log-rank (unadjusted):"
    } else {
        paste0("Pairwise log-rank, ", .km_adjust_label(method), "-adjusted:")
    }
    if (nrow(pw) > max.lines) {
        return(c(header, sprintf("%d comparisons: see the statistics table", nrow(pw))))
    }
    p <- vapply(pw$p.adj, function(v) if (is.na(v)) "p = NA" else .km_pvalue_text(v), "")
    c(header, paste0(pw$group1, " vs ", pw$group2, ": ", p))
}

#' @rdname INTERNAL_km_pairwise_text
.km_pairwise_hover <- function(pw) {
    num <- function(x) ifelse(is.na(x), "NA", trimws(formatC(x, digits = 3, format = "g")))
    hr <- ifelse(is.na(pw$hr), "HR not estimable",
        sprintf("HR (%s / %s) %s, 95%% CI %s to %s", pw$group2, pw$group1, num(pw$hr), num(pw$hr.lower),
            num(pw$hr.upper)))
    paste(sprintf("%s vs %s: %s; p = %s, adjusted %s; n %d / %d, events %d / %d",
        pw$group1, pw$group2, hr, num(pw$p.value), num(pw$p.adj), as.integer(pw$n1), as.integer(pw$n2),
        as.integer(pw$events1), as.integer(pw$events2)), collapse = "<br>")
}


#' Display name of a p-value adjustment method
#'
#' @param method A [stats::p.adjust()] method.
#' @return A short name, such as `"Holm"` or `"BH"`.
#'
#' @author Jared Andrews
#' @rdname INTERNAL_km_adjust_label
#' @keywords internal
.km_adjust_label <- function(method) {
    switch(method,
        holm = "Holm", hochberg = "Hochberg", hommel = "Hommel", bonferroni = "Bonferroni",
        BH = , fdr = "BH", BY = "BY",
        method
    )
}


#' Number at risk in each stratum at given times
#'
#' @param fit The `survfit` object.
#' @param levels The strata, in the fit's order.
#' @param times The times to count at.
#' @return A data frame with columns `stratum`, `time` and `n.risk`.
#'
#' @author Jared Andrews
#' @rdname INTERNAL_km_risk_table
#' @keywords internal
.km_risk_table <- function(fit, levels, times) {
    s <- summary(fit, times = times, extend = TRUE)
    stratum <- if (is.null(s$strata)) rep(levels[1], length(s$time)) else levels[as.integer(s$strata)]
    data.frame(stratum = factor(stratum, levels = levels), time = s$time, n.risk = s$n.risk)
}


#' Stack a number-at-risk table beneath a survival curve
#'
#' The table gets an x axis of its own, matched to the curve's so the two zoom
#' together: a shared axis would draw the curve's gridlines through the table
#' and its border lines around the table only. The table's gridlines are kept
#' off through the figure's `"fixed.axes"` attribute (see
#' [.sci_finalize_plotly()]).
#'
#' @param fig The built survival curve figure.
#' @param fit The `survfit` object.
#' @param levels The strata, in the fit's order.
#' @param km A frame from [.km_frame()], for the time range.
#' @param break.time.by Spacing of the counting times, or `NULL` for pretty breaks.
#' @return The two-panel figure.
#'
#' @import plotly
#' @author Jared Andrews
#' @rdname INTERNAL_km_add_risk_table
#' @keywords internal
.km_add_risk_table <- function(fig, fit, levels, km, break.time.by = NULL) {
    tmax <- max(km$time, na.rm = TRUE)
    times <- if (!is.null(break.time.by)) {
        seq(0, tmax, by = break.time.by)
    } else {
        b <- pretty(c(0, tmax))
        b[b <= tmax]
    }
    rt <- .km_risk_table(fit, levels, times)

    tbl <- plot_ly()
    for (g in levels) {
        r <- rt[rt$stratum == g, , drop = FALSE]
        # Unclipped, so a count at either end of the time axis is drawn whole.
        tbl <- add_trace(tbl,
            x = r$time, y = rep(g, nrow(r)), text = r$n.risk,
            type = "scatter", mode = "text", textfont = list(color = "#000000", size = 12), cliponaxis = FALSE,
            name = g, legendgroup = g, showlegend = FALSE,
            hovertemplate = paste0(g, ": %{text} at risk at %{x}<extra></extra>")
        )
    }
    nogrid <- list(showgrid = FALSE, zeroline = FALSE)
    # Half a row of room above and below, which a text-only trace does not pad.
    tbl <- layout(tbl, yaxis = c(list(
        type = "category", categoryorder = "array", categoryarray = rev(levels),
        range = c(-0.5, length(levels) - 0.5), fixedrange = TRUE, title = list(text = "At risk")
    ), nogrid))
    fig <- subplot(fig, tbl,
        nrows = 2, heights = c(0.75, 0.25), shareX = FALSE, titleX = TRUE, titleY = TRUE, margin = 0.05
    )

    # The table carries the time axis's labels and title, as a shared axis would.
    lay <- fig$x$layout
    lay$xaxis2 <- utils::modifyList(lay$xaxis2 %||% list(), c(list(
        matches = "x", title = lay$xaxis$title %||% list(text = "Time"),
        tick0 = lay$xaxis$tick0, dtick = lay$xaxis$dtick
    ), nogrid))
    lay$xaxis$title <- list(text = "")
    lay$xaxis$showticklabels <- FALSE
    fig$x$layout <- lay
    attr(fig, "fixed.axes") <- list(xaxis2 = nogrid, yaxis2 = nogrid)
    fig
}


#' Per-stratum summary of a survival fit
#'
#' The statistics table [survivalCurve()] attaches to its figure: subjects,
#' events, median survival and its confidence interval for each stratum, and the
#' log-rank test across them.
#'
#' @param fit The `survfit` object.
#' @param levels The strata, in the fit's order.
#' @param logrank The result of [.km_logrank()], or `NULL`.
#' @return A data frame with one row per stratum.
#'
#' @author Jared Andrews
#' @rdname INTERNAL_km_summary_table
#' @keywords internal
.km_summary_table <- function(fit, levels, logrank = NULL) {
    tab <- .km_fit_table(fit)
    lcl <- grep("LCL$", colnames(tab), value = TRUE)[1]
    ucl <- grep("UCL$", colnames(tab), value = TRUE)[1]
    data.frame(
        stratum = levels,
        n = unname(tab[, "records"]),
        events = unname(tab[, "events"]),
        median = unname(tab[, "median"]),
        median.lower = unname(tab[, lcl]),
        median.upper = unname(tab[, ucl]),
        logrank.chisq = if (is.null(logrank)) NA_real_ else logrank$chisq,
        logrank.df = if (is.null(logrank)) NA_integer_ else logrank$df,
        logrank.p = if (is.null(logrank)) NA_real_ else logrank$p,
        stringsAsFactors = FALSE
    )
}
