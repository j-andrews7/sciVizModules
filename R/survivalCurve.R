#' Create an interactive Kaplan-Meier survival curve
#'
#' Fits a Kaplan-Meier survival curve with [survival::survfit()] and draws it as
#' an interactive `plotly` figure. The curves and their confidence bands are drawn
#' by [VizModules::linePlot()] from the curve's step coordinates, so the band takes
#' its line's colour, sits underneath it and toggles with it from the legend.
#'
#' @details The input `data` should be in the "tidy" survival format: one row per
#' subject with a numeric follow-up `time` column and a `status` (event) indicator.
#' The status column may be numeric (`0`/`1` where `1` = event, or `1`/`2` where
#' `2` = event, following the [survival::Surv()] conventions), logical (`TRUE` =
#' event), or a two-level factor/character where the level containing
#' "dead"/"death"/"event"/"yes"/"true"/"1" is treated as the event.
#'
#' When `group.by` is supplied the curve is stratified by that column and the
#' log-rank test p-value (from [survival::survdiff()]) can be shown via `pval`.
#'
#' The figure is built natively in plotly rather than converted from a ggplot:
#' [plotly::ggplotly()] cannot draw the stepped confidence band survminer uses.
#'
#' @param data A data frame containing at least the `time` and `status` columns.
#' @param time The name of the numeric follow-up time column.
#' @param status The name of the event/status indicator column.
#' @param group.by Optional name of a categorical column to stratify the curves
#'   by. When `NULL` or `""` a single overall survival curve (named "All") is drawn.
#' @param conf.int Logical; draw a confidence band around each curve (default `TRUE`).
#' @param conf.level Confidence level of the band, between 0 and 1 (default 0.95),
#'   passed to [survival::survfit()] as its `conf.int`.
#' @param conf.type How the band is computed, one of `"log"` (the
#'   [survival::survfit()] default), `"log-log"` or `"plain"`.
#' @param conf.int.opacity Fill opacity of the band, between 0 and 1 (default 0.25).
#' @param pval Logical; display the log-rank test p-value. Only applied when
#'   `group.by` defines more than one group (default `TRUE`).
#' @param risk.table Logical; append a "number at risk" table beneath the curve
#'   (default `FALSE`).
#' @param censor Logical; draw censoring marks (default `TRUE`).
#' @param surv.median.line Character; draw median survival reference lines. One
#'   of `"none"`, `"hv"`, `"h"`, or `"v"` (default `"none"`). Drawn only for the
#'   survival probability and percentage curves.
#' @param fun Optional transformation of the survival curve. One of `NULL` or
#'   `"survival"` (survival probability), `"pct"` (survival percentage), `"event"`
#'   (cumulative events, `1 - S`), or `"cumhaz"` (cumulative hazard, `-log(S)`).
#'   The band is transformed with the curve.
#' @param palette.selection Optional vector of colors for the strata, named by
#'   stratum level (an unnamed vector is used in level order).
#' @param line.size Numeric width of the survival curves in pixels (default `2`).
#' @param break.time.by Optional numeric spacing between x-axis tick marks, which
#'   also sets the times the risk table counts at.
#' @param legend.title Legend title. Defaults to `group.by` when stratified.
#'
#' @return A [plotly::plot_ly()] object containing the interactive survival curve,
#'   with a per-stratum summary (subjects, events, median survival and its
#'   confidence interval, and the log-rank test) as attribute `"table"`.
#'
#' @importFrom survival Surv survfit survdiff
#' @importFrom stats as.formula
#' @import plotly
#'
#' @export
#' @author Jacob Martin, Jared Andrews
#' @seealso [survival::survfit()], [VizModules::linePlot()],
#' [sciVizModules::survivalCurveInputsUI()], [sciVizModules::survivalCurveServer()],
#' [sciVizModules::survivalCurveApp()]
#' @examples
#' library(sciVizModules)
#' data(survival_lung)
#' fig <- survivalCurve(survival_lung,
#'     time = "time", status = "status", group.by = "sex"
#' )
#' if (interactive()) fig
#'
#' # Cumulative events with a number-at-risk table.
#' fig2 <- survivalCurve(survival_lung,
#'     time = "time", status = "status", group.by = "sex",
#'     fun = "event", risk.table = TRUE
#' )
survivalCurve <- function(data,
                          time,
                          status,
                          group.by = NULL,
                          conf.int = TRUE,
                          conf.level = 0.95,
                          conf.type = c("log", "log-log", "plain"),
                          conf.int.opacity = 0.25,
                          pval = TRUE,
                          risk.table = FALSE,
                          censor = TRUE,
                          surv.median.line = "none",
                          fun = NULL,
                          palette.selection = NULL,
                          line.size = 2,
                          break.time.by = NULL,
                          legend.title = NULL) {
    conf.type <- match.arg(conf.type)
    stopifnot(is.data.frame(data))
    if (!time %in% names(data)) stop("Time column '", time, "' not found in data.")
    if (!status %in% names(data)) stop("Status column '", status, "' not found in data.")
    if (!is.numeric(conf.level) || length(conf.level) != 1 || is.na(conf.level) ||
        conf.level <= 0 || conf.level >= 1) {
        conf.level <- 0.95
    }
    if (is.null(fun) || identical(fun, "survival")) fun <- NULL

    df <- as.data.frame(data)

    # Standardize the time and status columns onto fixed names so the survival
    # formula does not have to deal with awkward user-supplied column names.
    df[[".surv_time"]] <- as.numeric(df[[time]])
    df[[".surv_status"]] <- .normalize_survival_status(df[[status]])

    has_group <- !is.null(group.by) && length(group.by) == 1 && nzchar(group.by) && group.by %in% names(df)
    df[[".stratum"]] <- if (has_group) as.character(df[[group.by]]) else "All"

    # Drop rows that cannot contribute to the fit.
    keep <- !is.na(df[[".surv_time"]]) & !is.na(df[[".surv_status"]]) & !is.na(df[[".stratum"]])
    df <- df[keep, , drop = FALSE]
    if (nrow(df) == 0) {
        stop("No non-missing time/status observations available to fit a survival curve.")
    }

    # Levels in the column's own order, keeping only those with subjects, so the
    # fit's strata line up with them one to one.
    lv <- .surv_levels(if (has_group) data[[group.by]] else df[[".stratum"]])
    lv <- lv[lv %in% df[[".stratum"]]]
    df[[".stratum"]] <- factor(df[[".stratum"]], levels = lv)
    fml <- stats::as.formula("survival::Surv(.surv_time, .surv_status) ~ .stratum")

    fit <- survival::survfit(fml, data = df, conf.int = conf.level, conf.type = conf.type)
    km <- .km_frame(fit, lv, fun)
    steps <- .km_steps(km)

    palette <- .km_palette(lv, palette.selection)
    if (is.null(legend.title)) {
        legend.title <- if (has_group) group.by else ""
    }

    fig <- VizModules::linePlot(
        steps,
        x = "time", y = "surv",
        palette.selection = palette,
        colour.group.by = ".stratum",
        plot.mode = "lines",
        x.title = "Time",
        y.title = .km_axis_title(fun),
        error.type = "columns",
        error.lower = "lower",
        error.upper = "upper",
        error.bar = FALSE,
        error.ribbon = isTRUE(conf.int),
        error.ribbon.opacity = conf.int.opacity
    )
    fig <- plotly::plotly_build(fig)

    # The curves (not their bands) take the line width, and every trace joins
    # its stratum's legend group, so one legend click toggles a curve, its band
    # and its censoring marks together.
    for (i in seq_along(fig$x$data)) {
        tr <- fig$x$data[[i]]
        if (is.null(tr$legendgroup) && !is.null(tr$name)) fig$x$data[[i]]$legendgroup <- tr$name
        if (!identical(tr$fill, "toself")) {
            fig$x$data[[i]]$line$width <- line.size
            fig$x$data[[i]]$hovertemplate <- paste0("%{x}, %{y:.3f}<extra>", tr$name, "</extra>")
        }
    }

    if (isTRUE(censor)) {
        fig$x$data <- c(fig$x$data, .km_censor_traces(km, palette))
    }
    if (is.null(fun) || identical(fun, "pct")) {
        med <- .km_median_trace(fit, lv, surv.median.line, y = if (is.null(fun)) 0.5 else 50)
        if (!is.null(med)) fig$x$data <- c(fig$x$data, list(med))
    }

    logrank <- if (has_group && length(lv) > 1) .km_logrank(df) else NULL
    if (isTRUE(pval) && !is.null(logrank)) {
        # Bottom left, clear of falling survival curves; top left for rising ones.
        rising <- isTRUE(fun %in% c("event", "cumhaz"))
        fig$x$layout$annotations <- c(fig$x$layout$annotations, list(list(
            x = 0.08, y = if (rising) 0.95 else 0.1, xref = "paper", yref = "paper",
            xanchor = "left", yanchor = if (rising) "top" else "bottom",
            text = .km_pvalue_text(logrank$p), showarrow = FALSE, font = list(size = 14, color = "black")
        )))
    }

    fig$x$layout$legend$title$text <- legend.title
    break.time.by <- if (is.numeric(break.time.by) && length(break.time.by) == 1 && isTRUE(break.time.by > 0)) {
        break.time.by
    }
    if (!is.null(break.time.by)) {
        fig$x$layout$xaxis$tick0 <- 0
        fig$x$layout$xaxis$dtick <- break.time.by
    }

    if (isTRUE(risk.table)) {
        fig <- .km_add_risk_table(fig, fit, lv, palette, km, break.time.by)
    }

    attr(fig, "table") <- .km_summary_table(fit, lv, logrank)
    fig
}


#' Normalize a survival status/event indicator to 0/1
#'
#' Coerces a variety of status encodings to a numeric 0 (censored) / 1 (event)
#' vector suitable for [survival::Surv()].
#'
#' @param x A status vector: numeric (`0`/`1` or `1`/`2`), logical, or a
#'   two-level factor/character.
#' @return A numeric vector of 0 (censored) and 1 (event) values.
#'
#' @author Jacob Martin
#' @rdname INTERNAL_normalize_survival_status
#' @keywords internal
.normalize_survival_status <- function(x) {
    if (is.logical(x)) {
        return(as.integer(x))
    }

    if (is.numeric(x)) {
        vals <- unique(stats::na.omit(x))
        # 1/2 coding (2 = event) is remapped to 0/1; 0/1 is already correct.
        if (length(vals) > 0 && all(vals %in% c(1, 2))) {
            return(as.numeric(x) - 1)
        }
        return(as.numeric(x))
    }

    # Factor/character: treat recognizable "event" labels as 1, everything else 0.
    chr <- tolower(trimws(as.character(x)))
    event_tokens <- c("dead", "death", "event", "deceased", "yes", "true", "1")
    out <- ifelse(chr %in% event_tokens, 1, 0)
    out[is.na(chr)] <- NA
    as.numeric(out)
}
