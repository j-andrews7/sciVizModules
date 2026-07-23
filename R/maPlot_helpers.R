#' Default UI values for the MA plot module
#'
#' Computes the MA-specific defaults shared by the MA UI and the underlying
#' [VizModules::dittoViz_scatterPlotServer()]: mean abundance on the x-axis (on a
#' log10 scale for DESeq2's `baseMean`), log fold change on the y-axis, the
#' significance column used for grouping, the auto-generated `group` colouring,
#' and the significance / fold-change thresholds. Sharing this between the UI and
#' server keeps the initial state and the reset state identical.
#'
#' User-supplied `defaults` take precedence over the auto-detected values.
#'
#' @param data A differential-expression results data frame.
#' @param defaults An optional named list of user overrides.
#' @return A named list of scatter plot module defaults.
#'
#' @author Jacob Martin
#' @rdname INTERNAL_ma_defaults
#' @keywords internal
.ma_defaults <- function(data, defaults = NULL) {
    if (is.null(defaults)) defaults <- list()

    # Mean abundance ("A"): baseMean (DESeq2), logCPM (edgeR), AveExpr (limma-voom).
    abundance_names <- c("baseMean", "logCPM", "AveExpr", "logConc", "abundance", "AvgExpr")
    # Log fold change ("M"): log2FoldChange (DESeq2), logFC (edgeR/limma).
    lfc_names <- c("log2FoldChange", "logFC", "LFC")
    # Significance columns used for grouping only (not an axis).
    p_names <- c("padj", "FDR", "adj.P.Val", "svalue", "pvalue", "PValue", "P.Value", "pval", "p")

    if (!"x.by" %in% names(defaults)) {
        found_abundance <- .detect_column(data, abundance_names)
        if (!is.null(found_abundance)) {
            defaults$x.by <- found_abundance
        } else {
            stop("Could not find a mean abundance column (e.g. 'baseMean', 'logCPM', 'AveExpr'). Please specify one in defaults$x.by.")
        }
    }

    if (!"y.by" %in% names(defaults)) {
        found_lfc <- .detect_column(data, lfc_names)
        if (!is.null(found_lfc)) {
            defaults$y.by <- found_lfc
        } else {
            stop("Could not find an effect size column (e.g. 'log2FoldChange', 'logFC', 'LFC'). Please specify one in defaults$y.by.")
        }
    }

    if (!"sig.by" %in% names(defaults)) {
        found_p <- .detect_column(data, p_names)
        if (!is.null(found_p)) {
            defaults$sig.by <- found_p
        } else {
            stop("Could not find a significance column (e.g. 'padj', 'FDR', 'adj.P.Val'). Please specify one in defaults$sig.by.")
        }
    }

    if (!"color.by" %in% names(defaults)) defaults$color.by <- "group"
    # DESeq2 baseMean is conventionally shown on a log10 x-axis; edgeR/limma
    # abundance columns are already log-scaled, so only default to log10 for baseMean.
    if (!"x.adj.fxn" %in% names(defaults)) {
        defaults$x.adj.fxn <- if (identical(defaults$x.by, "baseMean")) "log10" else "identity"
    }
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