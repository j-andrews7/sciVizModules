#' Fetch a default value for a survivalCurve input
#'
#' @param defaults A named list of defaults (may be `NULL`).
#' @param key The default name to look up.
#' @param fallback The value to return when `key` is absent.
#' @return The stored default or `fallback`.
#'
#' @author Jacob Martin
#' @rdname INTERNAL_sv_default
#' @keywords internal
.sv_default <- function(defaults, key, fallback = NULL) {
    if (!is.null(defaults) && key %in% names(defaults)) {
        return(defaults[[key]])
    }
    fallback
}
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
#' Move a p-value text trace into an editable Plotly annotation
#'
#' This function searches a Plotly figure for a text trace whose label looks
#' like a p-value (for example, `"p = 0.0013"`), removes that trace from
#' `fig$x$data`, and appends a new paper-positioned annotation to
#' `fig$x$layout$annotations`.
#'
#' The added annotation is placed at `x = 0.1`, `y = 0.1` in paper
#' coordinates, which makes it relative to the plotting area rather than the
#' underlying data values. When combined with `plotly::config(editable = TRUE,
#' edits = list(annotationPosition = TRUE))`, the annotation can be dragged by
#' the user in the browser.
#'
#' @param fig A Plotly figure object.
#' @return The modified Plotly figure with the p-value text trace replaced by
#'   an annotation.
#'
#' @author Jacob Martin
#' @keywords internal
.stats_annotation <- function(fig) {
  existing_annotations <- fig$x$layout$annotations
  if (is.null(existing_annotations)) existing_annotations <- list()

  for (x in seq_along(fig$x$data)) {
    text <- fig$x$data[[x]]$text

    if (!is.null(text) && any(grepl("p = ", text, fixed = TRUE)) | any(grepl("p > ", text, fixed = TRUE)) | any(grepl("p < ", text, fixed = TRUE))) {
      stat_anno <- text[grep("p ", text, fixed = TRUE)[1]]

      fig$x$data[[x]] <- NULL

      new_annotation <- list(
        x = 0.08,
        y = 0.1,
        xref = "paper",
        yref = "paper",
        text = stat_anno,
        showarrow = FALSE,
        xanchor = "left",
        yanchor = "bottom",
        font = list(size = 14, color = "black")
      )

      fig <- plotly::layout(
        fig,
        annotations = c(existing_annotations, list(new_annotation))
      )

      break
    }
  }

  fig
}
