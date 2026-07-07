#' Create an interactive Kaplan-Meier survival curve
#'
#' Builds a Kaplan-Meier survival curve from a survival-style data frame and
#' returns an interactive `plotly` figure. The statistical fit and the base plot
#' are produced with the [survminer](https://cran.r-project.org/package=survminer)
#' package (via [survminer::surv_fit()] and [survminer::ggsurvplot()]); the
#' resulting `ggplot` is then converted to `plotly` with [plotly::ggplotly()] to
#' provide the interactivity-first experience shared by all VizModules modules.
#'
#' @details The input `data` should be in the "tidy" survival format expected by
#' survminer: one row per subject with a numeric follow-up `time` column and a
#' `status` (event) indicator. The status column may be numeric (`0`/`1` where
#' `1` = event, or `1`/`2` where `2` = event, following the
#' [survival::Surv()] conventions), logical (`TRUE` = event), or a two-level
#' factor/character where the level containing "dead"/"death"/"event"/"yes"/
#' "true"/"1" is treated as the event.
#'
#' When `group.by` is supplied the curve is stratified by that column and a
#' log-rank p-value can be shown via `pval`.
#'
#' @param data A data frame containing at least the `time` and `status` columns.
#' @param time The name of the numeric follow-up time column.
#' @param status The name of the event/status indicator column.
#' @param group.by Optional name of a categorical column to stratify the curves
#'   by. When `NULL` or `""` a single overall survival curve is drawn.
#' @param legend.title Legend title. Defaults to `group.by` when stratified.
#' @param conf.int Logical; draw confidence interval ribbons (default `TRUE`).
#' @param pval Logical; display the log-rank test p-value. Only applied when
#'   `group.by` defines more than one group (default `TRUE`).
#' @param risk.table Logical; show a "number at risk" table alongside the curve.
#'   The table is returned as a standalone figure attached to the result via the
#'   `"risk_table"` attribute (rather than stacked onto the curve) so it can be
#'   rendered separately without sharing axes/grid lines with the main plot
#'   (default `FALSE`).
#' @param censor Logical; draw censoring marks (default `TRUE`).
#' @param surv.median.line Character; draw median survival reference lines. One
#'   of `"none"`, `"hv"`, `"h"`, or `"v"` (default `"none"`).
#' @param fun Optional transformation of the survival curve passed to
#'   [survminer::ggsurvplot()]. One of `NULL` (survival probability), `"pct"`
#'   (survival percentage), `"event"` (cumulative events), or `"cumhaz"`
#'   (cumulative hazard).
#' @param palette.selection Optional vector of colors used for the strata. Passed
#'   through to the `palette` argument of [survminer::ggsurvplot()].
#' @param line.size Numeric line width for the survival curves (default `1`).
#' @param break.time.by Optional numeric spacing between x-axis tick marks.

#'
#' @return A [plotly::plot_ly()] object containing the interactive survival curve.
#'   When `risk.table = TRUE` the accompanying "number at risk" table is attached
#'   as a standalone [plotly::plot_ly()] figure in the `"risk_table"` attribute
#'   of the returned object.
#'
#' @importFrom survival Surv
#' @importFrom stats as.formula
#' @import plotly
#'
#' @export
#' @author Jacob Martin
#' @seealso [survminer::ggsurvplot()], [survival::survfit()],
#' [sciVizModules::survivalCurveInputsUI()], [sciVizModules::survivalCurveServer()],
#' [sciVizModules::survivalCurveApp()]
#' @examples
#' library(sciVizModules)
#' data(survival_lung)
#' fig <- survivalCurve(survival_lung,
#'     time = "time", status = "status", group.by = "sex"
#' )
#' if (interactive()) fig
survivalCurve <- function(data,
                          time,
                          status,
                          group.by = NULL,
                          conf.int = TRUE,
                          pval = TRUE,
                          risk.table = FALSE,
                          censor = TRUE,
                          surv.median.line = "none",
                          fun = NULL,
                          palette.selection = NULL,
                          line.size = 1,
                          break.time.by = NULL,
                          legend.title = NULL
                        ) {
    if (!requireNamespace("survminer", quietly = TRUE)) {
        stop("The 'survminer' package is required for survivalCurve(). Please install it.")
    }

    stopifnot(is.data.frame(data))
    if (!time %in% names(data)) stop("Time column '", time, "' not found in data.")
    if (!status %in% names(data)) stop("Status column '", status, "' not found in data.")

    df <- as.data.frame(data)

    # Standardize the time and status columns onto fixed names so the survival
    # formula does not have to deal with awkward user-supplied column names.
    df[[".surv_time"]] <- as.numeric(df[[time]])
    df[[".surv_status"]] <- .normalize_survival_status(df[[status]])

    # Drop rows that cannot contribute to the fit.
    keep <- !is.na(df[[".surv_time"]]) & !is.na(df[[".surv_status"]])
    df <- df[keep, , drop = FALSE]
    if (nrow(df) == 0) {
        stop("No non-missing time/status observations available to fit a survival curve.")
    }

    # Build the survival formula, stratifying by group.by when supplied.
    has_group <- !is.null(group.by) && length(group.by) == 1 && nzchar(group.by) && group.by %in% names(df)
    if (has_group) {
        df[[group.by]] <- as.factor(df[[group.by]])
        fml <- stats::as.formula(paste0("survival::Surv(.surv_time, .surv_status) ~ `", group.by, "`"))
    } else {
        fml <- stats::as.formula("survival::Surv(.surv_time, .surv_status) ~ 1")
    }

    fit <- survminer::surv_fit(fml, data = df)

    # A log-rank p-value is only meaningful when there is more than one stratum.
    show_pval <- isTRUE(pval) && has_group

    if (is.null(legend.title)) {
        legend.title <- if (has_group) group.by else ""
    }

    gg_args <- list(
        fit = fit,
        data = df,
        conf.int = isTRUE(conf.int),
        pval = show_pval,
        risk.table = isTRUE(risk.table),
        censor = isTRUE(censor),
        surv.median.line = surv.median.line,
        size = line.size,
        ggtheme = survminer::theme_survminer(legend = "right"),
        legend.title = legend.title
        
    )

    if (!is.null(fun)) gg_args$fun <- fun
    if (!is.null(palette.selection) && length(palette.selection) > 0) {
        gg_args$palette <- unname(palette.selection)
    }
    if (!is.null(break.time.by) && is.numeric(break.time.by) && break.time.by > 0) {
        gg_args$break.time.by <- break.time.by
    }

    gg <- do.call(survminer::ggsurvplot, gg_args)

    fig <- plotly::ggplotly(gg$plot)

    # Optionally build the "number at risk" table as a *standalone* interactive
    # figure. Previously it was stacked beneath the curve with
    # `plotly::subplot(shareX = TRUE)`, but sharing the x-axis forced shared grid
    # lines onto the survival curve and interfered with the draggable
    # title/axis-title annotations added downstream. Instead, the table is
    # returned as an attribute on the main figure so callers (e.g. the Shiny
    # module) can render it in a separate output, fully decoupled from the main
    # plot's layout. The conversion is wrapped defensively so a failure never
    # breaks the main plot.
    if (isTRUE(risk.table) && !is.null(gg$table)) {
        tbl <- tryCatch(
            plotly::layout(plotly::ggplotly(gg$table), showlegend = FALSE),
            error = function(e) NULL
        )
        if (!is.null(tbl)) {
            attr(fig, "risk_table") <- tbl
        }
    }

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
