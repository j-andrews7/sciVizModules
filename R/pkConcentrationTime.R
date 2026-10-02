#' Pharmacokinetic concentration-time plot
#'
#' Plots plasma (or tissue) concentration against time, either one line per
#' subject or the mean +/- SD per group at each nominal sampling time, on a
#' linear or log axis, with each subject's non-compartmental parameters (Cmax,
#' Tmax, AUC, terminal half-life and, given a dose, CL/F and Vz/F) computed as
#' PKNCA computes them by default. The terminal elimination fit can be drawn on
#' each subject's curve.
#'
#' @param data A data frame with one row per sample.
#' @param time,conc,subject Column names of the sampling time, concentration and
#'   subject.
#' @param group Column of treatment groups, or `NULL`.
#' @param dose Column of doses (one per subject), or `NULL`.
#' @param mode `"individual"` (a line per subject) or `"mean"` (mean +/- SD per
#'   group at each nominal time).
#' @param log.y Logical; log concentration axis.
#' @param show.lambda Logical; draw each subject's terminal elimination fit
#'   (individual mode).
#' @param auc.method `"lin up/log down"` or `"linear"`.
#' @param colors Named vector of colours for the subjects (individual mode) or
#'   groups (mean mode).
#' @param main Optional plot title.
#'
#' @return A `plotly` object, with the per-subject NCA table as attribute `"table"`.
#'
#' @import plotly
#' @seealso [pkConcentrationTimeServer()]
#' @export
#' @author Jared Andrews
#' @examples
#' pkConcentrationTime(datasets::Theoph, time = "Time", conc = "conc", subject = "Subject",
#'     dose = "Dose", log.y = TRUE, show.lambda = TRUE)
pkConcentrationTime <- function(data, time, conc, subject, group = NULL, dose = NULL, mode = "individual",
                                log.y = FALSE, show.lambda = FALSE, auc.method = "lin up/log down", colors = NULL,
                                main = NULL) {
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
        summ <- do.call(rbind, lapply(split(plotted, list(plotted$.group, plotted$.nominal), drop = TRUE), function(d) {
            data.frame(group = d$.group[1], time = d$.nominal[1], mean = mean(d$.conc),
                sd = if (nrow(d) > 1) stats::sd(d$.conc) else 0, n = nrow(d), stringsAsFactors = FALSE)
        }))
        summ <- summ[order(summ$group, summ$time), , drop = FALSE]
        for (g in groups) {
            s <- summ[summ$group == g, , drop = FALSE]
            fig <- add_trace(fig, x = s$time, y = s$mean, type = "scatter", mode = "lines+markers", name = g,
                legendgroup = g, line = list(color = palette[[g]]), marker = list(color = palette[[g]], size = 7),
                error_y = list(type = "data", array = s$sd, color = palette[[g]], thickness = 1),
                text = sprintf("%s<br>time %s<br>mean %s (SD %s, n = %d)", g, fmt(s$time), fmt(s$mean), fmt(s$sd), s$n),
                hoverinfo = "text")
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
