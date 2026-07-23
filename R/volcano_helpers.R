#' Default UI values for the volcano plot module
#'
#' Computes the volcano-specific defaults handed to both the volcano UI and the
#' underlying [VizModules::dittoViz_scatterPlotServer()]: the effect-size column
#' on the x-axis, the significance column on the y-axis (drawn as -log10), the
#' auto-generated `group` colouring, and the significance / fold-change
#' thresholds. Sharing this between the UI and server keeps the initial state and
#' the reset state identical.
#'
#' User-supplied `defaults` take precedence over the auto-detected values.
#'
#' @param data A differential-expression results data frame.
#' @param defaults An optional named list of user overrides.
#' @return A named list of scatter plot module defaults.
#'
#' @author Jacob Martin
#' @rdname INTERNAL_volcano_defaults
#' @keywords internal
.volcano_defaults <- function(data, defaults = NULL) {
    if (is.null(defaults)) defaults <- list()

    lfc_names <- c("log2FoldChange", "LFC", "logFC")
    p_names <- c("padj", "pval", "adj.p", "svalue", "FDR", "p")

    if (!"x.by" %in% names(defaults)) {
        found_lfc <- .detect_column(data, lfc_names)
        if (!is.null(found_lfc)) {
            defaults$x.by <- found_lfc
        } else {
            stop("Could not find an effect size column (e.g. 'log2FoldChange', 'LFC', 'logFC'). Please specify one in defaults$x.by.")
        }
    }

    if (!"y.by" %in% names(defaults)) {
        found_p <- .detect_column(data, p_names)
        if (!is.null(found_p)) {
            defaults$y.by <- found_p
        } else {
            stop("Could not find a significance column (e.g. 'padj', 'adj.p', 'FDR'). Please specify one in defaults$y.by.")
        }
    }

    if (!"color.by" %in% names(defaults)) defaults$color.by <- "group"
    if (!"y.adj.fxn" %in% names(defaults)) defaults$y.adj.fxn <- "neg_log10"
    if (!"show.others" %in% names(defaults)) defaults$show.others <- FALSE
    if (!"hover.data" %in% names(defaults)) {
        defaults$hover.data <- c("symbol", defaults$x.by, defaults$y.by)
    }

    if (!"sig.thresh" %in% names(defaults)) defaults$sig.thresh <- 0.05
    if (!"fc.thresh" %in% names(defaults)) defaults$fc.thresh <- 0

    if (!"color.up" %in% names(defaults)) defaults$color.up <- "red"
    if (!"color.down" %in% names(defaults)) defaults$color.down <- "blue"
    if (!"color.ns" %in% names(defaults)) defaults$color.ns <- "lightgray"

    defaults
}

#' Named Up/Down/n.s. colour vector from a volcano/MA defaults list
#'
#' @param defaults A defaults list as returned by `.volcano_defaults()` or
#'   `.ma_defaults()`.
#' @return A named character vector with `Up`, `Down`, and `n.s.` entries.
#'
#' @author Jacob Martin
#' @rdname INTERNAL_de_group_colors
#' @keywords internal
.de_group_colors <- function(defaults) {
    c(
        "Up" = if ("color.up" %in% names(defaults)) defaults[["color.up"]] else "red",
        "Down" = if ("color.down" %in% names(defaults)) defaults[["color.down"]] else "blue",
        "n.s." = if ("color.ns" %in% names(defaults)) defaults[["color.ns"]] else "lightgray"
    )
}

