#' Pharmacokinetic concentration-time plot
#'
#' Plots plasma (or tissue) concentration against time, either one line per
#' subject or each group's mean at each nominal sampling time with an interval
#' around it, on a linear or log axis, with each subject's non-compartmental
#' parameters (Cmax, Tmax, AUC, terminal half-life and, given a dose, CL/F and
#' Vz/F) computed as PKNCA computes them by default. The terminal elimination fit
#' can be drawn on each subject's curve.
#'
#' The group means are drawn by [VizModules::linePlot()], so the interval can be
#' error bars, a shaded ribbon in each group's colour, or both, as in the
#' VizModules line plot module. Its half-width is
#' [VizModules::error_bar_halfwidth()] of the concentrations at that time. A time
#' with a single sample has no spread and is drawn without an interval.
#'
#' @param data A data frame with one row per sample.
#' @param time,conc,subject Column names of the sampling time, concentration and
#'   subject.
#' @param group Column of treatment groups, or `NULL`.
#' @param dose Column of doses (one per subject), or `NULL`.
#' @param mode `"individual"` (a line per subject) or `"mean"` (each group's mean
#'   at each nominal time, with the interval `error.type` selects).
#' @param log.y Logical; log concentration axis. In mean mode, a lower bound at or
#'   below zero, which a log axis cannot show, is drawn at the smallest
#'   concentration plotted instead.
#' @param show.lambda Logical; draw each subject's terminal elimination fit
#'   (individual mode).
#' @param auc.method `"lin up/log down"` or `"linear"`.
#' @param colors Named vector of colours for the subjects (individual mode) or
#'   groups (mean mode).
#' @param main Optional plot title.
#' @param error.type The interval around each mean (mean mode): `"sd"` (one
#'   standard deviation), `"sem"` (one standard error of the mean) or `"ci95"` (a
#'   95% confidence interval for the mean).
#' @param error.ci.method How a `"ci95"` interval is computed: `"t"` (the t
#'   distribution on `n - 1` degrees of freedom, the default, which suits the
#'   small groups of a PK study) or `"normal"` (1.96 standard errors).
#' @param error.bar Logical; draw the interval as error bars (mean mode).
#' @param error.ribbon Logical; draw the interval as a shaded band behind each
#'   group's line (mean mode).
#' @param error.ribbon.opacity Fill opacity of the band, between 0 and 1.
#'
#' @return A `plotly` object, with the per-subject NCA table as attribute `"table"`.
#'
#' @import plotly
#' @seealso [pkConcentrationTimeServer()], [VizModules::linePlot()]
#' @export
#' @author Jared Andrews
#' @examples
#' pkConcentrationTime(datasets::Theoph, time = "Time", conc = "conc", subject = "Subject",
#'     dose = "Dose", log.y = TRUE, show.lambda = TRUE)
#'
#' # Group means with a 95% confidence band.
#' pkConcentrationTime(datasets::Theoph, time = "Time", conc = "conc", subject = "Subject",
#'     mode = "mean", error.type = "ci95", error.bar = FALSE, error.ribbon = TRUE)
pkConcentrationTime <- function(data, time, conc, subject, group = NULL, dose = NULL, mode = "individual",
                                log.y = FALSE, show.lambda = FALSE, auc.method = "lin up/log down", colors = NULL,
                                main = NULL, error.type = c("sd", "sem", "ci95"), error.ci.method = c("t", "normal"),
                                error.bar = TRUE, error.ribbon = FALSE, error.ribbon.opacity = 0.25) {
    error.type <- match.arg(error.type)
    error.ci.method <- match.arg(error.ci.method)
    data <- as.data.frame(data)
    missing <- setdiff(c(time, conc, subject), names(data))
    if (length(missing)) stop("Column(s) not in the data: ", paste(missing, collapse = ", "), call. = FALSE)
    group <- if (nz_value(group) && group %in% names(data)) group else NULL
    dose <- if (nz_value(dose) && dose %in% names(data)) dose else NULL

    data$.subject <- as.character(data[[subject]])
    data$.time <- as.numeric(data[[time]])
    data$.conc <- as.numeric(data[[conc]])
    data$.group <- if (is.null(group)) "All" else as.character(data[[group]])
    data <- data[is.finite(data$.time) & is.finite(data$.conc), , drop = FALSE]
    if (nrow(data) == 0) stop("No finite concentrations to plot.", call. = FALSE)

    nca <- .pk_nca_table(data, ".time", ".conc", ".subject", dose = dose, group = if (is.null(group)) NULL else ".group",
        auc.method = auc.method)
    defaults <- default_palettes()[["choices"]][["Defaults"]][["dittoColors"]]
    fmt <- function(v) ifelse(is.na(v), "NA", formatC(v, digits = 3, format = "g"))
    plotted <- if (isTRUE(log.y)) data[data$.conc > 0, , drop = FALSE] else data

    fig <- plot_ly()
    if (identical(mode, "mean")) {
        plotted$.nominal <- .pk_nominal_time(plotted$.time, plotted$.subject)
        groups <- unique(plotted$.group)
        palette <- resolve_palette(groups, NULL, defaults, colors)
        summ <- .pk_mean_summary(plotted, error.type, error.ci.method, log.y)
        summ$group <- factor(summ$group, levels = groups)

        fig <- plotly_build(VizModules::linePlot(
            summ,
            x = "time", y = "mean",
            palette.selection = palette,
            colour.group.by = "group",
            plot.mode = "lines+markers",
            error.type = "columns", error.lower = "lower", error.upper = "upper",
            error.bar = isTRUE(error.bar), error.width = 1,
            error.ribbon = isTRUE(error.ribbon), error.ribbon.opacity = error.ribbon.opacity
        ))

        # linePlot draws each group's line in its own row order, so the hover
        # text is matched to the points by group and time.
        label <- c(sd = "SD", sem = "SEM", ci95 = "95% CI")[[error.type]]
        for (i in seq_along(fig$x$data)) {
            tr <- fig$x$data[[i]]
            if (identical(tr$fill, "toself") || is.null(tr$name)) next
            s <- summ[summ$group == tr$name, , drop = FALSE]
            s <- s[match(as.numeric(tr$x), s$time), , drop = FALSE]
            interval <- ifelse(is.na(s$halfwidth), "no interval",
                sprintf("%s %s to %s", label, fmt(s$lower), fmt(s$upper)))
            fig$x$data[[i]]$text <- sprintf("%s<br>time %s<br>mean %s<br>%s (n = %d)",
                tr$name, fmt(s$time), fmt(s$mean), interval, s$n)
            fig$x$data[[i]]$hoverinfo <- "text"
            fig$x$data[[i]]$marker$size <- 7
        }
    } else {
        subjects <- unique(plotted$.subject)
        palette <- resolve_palette(subjects, NULL, defaults, colors)
        for (s in subjects) {
            d <- plotted[plotted$.subject == s, , drop = FALSE]
            d <- d[order(d$.time), , drop = FALSE]
            p <- nca[nca$subject == s, , drop = FALSE]
            fig <- add_trace(fig, x = d$.time, y = d$.conc, type = "scatter", mode = "lines+markers", name = s,
                legendgroup = s, line = list(color = palette[[s]], width = 1.5), marker = list(color = palette[[s]], size = 6),
                text = sprintf("Subject %s<br>time %s<br>conc %s<br>Cmax %s at %s<br>t1/2 %s", s, fmt(d$.time),
                    fmt(d$.conc), fmt(p$cmax), fmt(p$tmax), fmt(p$half.life)),
                hoverinfo = "text")
            if (isTRUE(show.lambda) && is.finite(p$lambda.z)) {
                tt <- seq(p$lambda.z.time.first, p$tlast, length.out = 20)
                fig <- add_trace(fig, x = tt, y = exp(p$lambda.z.intercept - p$lambda.z * tt), type = "scatter",
                    mode = "lines", legendgroup = s, showlegend = FALSE,
                    line = list(color = palette[[s]], dash = "dash", width = 1),
                    text = sprintf("Subject %s terminal fit<br>t1/2 %s (%d points, adj. R2 %.3f)", s, fmt(p$half.life),
                        p$lambda.z.points, p$r.squared.adj),
                    hoverinfo = "text")
            }
        }
    }

    fig <- layout(fig,
        title = list(text = main %||% ""),
        xaxis = list(title = list(text = time)),
        yaxis = list(title = list(text = conc), type = if (isTRUE(log.y)) "log" else "linear")
    )
    attr(fig, "table") <- nca[, setdiff(names(nca), c("lambda.z.intercept")), drop = FALSE]
    fig
}
