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
#' @param risk.table Logical; append a "number at risk" table beneath the curve
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
#' @param xlab X-axis title (default `"Time"`).
#' @param ylab Y-axis title (default `"Survival probability"`).
#' @param legend.title Legend title. Defaults to `group.by` when stratified.
#' @param legend.position Position of the legend. One of `"right"` (the default,
#'   drawn vertically to the right of the plot), `"top"`, `"bottom"`, `"left"`,
#'   or `"none"`.
#' @param pval.size Numeric font size (in pixels) for the log-rank p-value
#'   annotation (default `14`).
#' @param pval.color Color for the log-rank p-value annotation (default
#'   `"black"`).
#' @param rotate Logical; when `TRUE` the x and y axes are swapped via
#'   [ggplot2::coord_flip()] (default `FALSE`).
#' @param break.time.by Optional numeric spacing between x-axis tick marks.

#'
#' @return A [plotly::plot_ly()] object containing the interactive survival curve.
#'
#' @importFrom survival Surv
#' @importFrom stats as.formula
#' @importFrom ggplot2 coord_flip
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
                          xlab = "Time",
                          ylab = "Survival probability",
                          legend.title = NULL,
                          legend.position = "right",
                          pval.size = 14,
                          pval.color = "black",
                          rotate = FALSE,
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

    # Compute the log-rank p-value ourselves so it can be rendered as a
    # customizable, draggable plotly annotation rather than baked into the
    # ggplot (which would not be stylable/movable after conversion).
    pval_txt <- NULL
    if (show_pval) {
        pval_txt <- tryCatch(
            survminer::surv_pvalue(fit, data = df)$pval.txt,
            error = function(e) NULL
        )
    }

    if (is.null(legend.title)) {
        legend.title <- if (has_group) group.by else ""
    }

    gg_args <- list(
        fit = fit,
        data = df,
        conf.int = isTRUE(conf.int),
        pval = FALSE,
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

    # Swap the x and y axes when requested. Done at the ggplot level so the
    # underlying data (not just the axis styling) is actually rotated.
    if (isTRUE(rotate)) {
        gg$plot <- gg$plot + ggplot2::coord_flip()
    }

    fig <- plotly::ggplotly(gg$plot)

    # Optionally stack the "number at risk" table beneath the curve. This is
    # wrapped defensively so a conversion failure never breaks the main plot.
    if (isTRUE(risk.table) && !is.null(gg$table)) {
        tbl <- tryCatch(plotly::ggplotly(gg$table), error = function(e) NULL)
        if (!is.null(tbl)) {
            fig <- tryCatch(
                plotly::subplot(fig, tbl,
                    nrows = 2, heights = c(0.75, 0.25),
                    shareX = TRUE, titleX = TRUE, titleY = TRUE, margin = 0.05
                ),
                error = function(e) fig
            )
        }
    }

    # Add the log-rank p-value as a draggable annotation with a customizable
    # font. The module config enables `annotationPosition`, so users can drag it.
    if (show_pval && !is.null(pval_txt) && nzchar(pval_txt)) {
        fig <- plotly::add_annotations(fig,
            text = pval_txt,
            xref = "paper", yref = "paper",
            x = 0.05, y = 0.05,
            xanchor = "left", yanchor = "bottom",
            showarrow = FALSE,
            font = list(size = pval.size, color = pval.color)
        )
    }

    # Position the legend. survminer draws it horizontally on top; by default we
    # place it vertically to the right of the plot.
    fig <- .apply_survival_legend(fig, legend.position, legend.title)

    if (!is.null(title) && nzchar(title)) {
        fig <- plotly::layout(fig, title = list(text = title))
    }
    
    fig
}


#' Apply legend positioning to a survival curve figure
#'
#' @param fig A `plotly` figure.
#' @param position One of `"right"`, `"top"`, `"bottom"`, `"left"`, or `"none"`.
#' @param legend.title Legend title text.
#' @return The `plotly` figure with the legend repositioned.
#'
#' @author Jacob Martin
#' @rdname INTERNAL_apply_survival_legend
#' @keywords internal
.apply_survival_legend <- function(fig, position = "right", legend.title = NULL) {
    position <- match.arg(position, c("right", "top", "bottom", "left", "none"))
    if (identical(position, "none")) {
        return(plotly::layout(fig, showlegend = FALSE))
    }

    legend <- switch(position,
        right = list(orientation = "v", x = 1.02, xanchor = "left", y = 1, yanchor = "top"),
        left = list(orientation = "v", x = -0.15, xanchor = "right", y = 1, yanchor = "top"),
        top = list(orientation = "h", x = 0.5, xanchor = "center", y = 1.1, yanchor = "bottom"),
        bottom = list(orientation = "h", x = 0.5, xanchor = "center", y = -0.2, yanchor = "top")
    )
    if (!is.null(legend.title) && nzchar(legend.title)) {
        legend$title <- list(text = legend.title)
    }
    plotly::layout(fig, showlegend = TRUE, legend = legend)
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
