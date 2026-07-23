#' Detect a column by matching a list of candidate names
#'
#' Shared column-detection primitive used by the GO enrichment sunburst
#' ([goFanPlot()]) and dot plot ([enrichmentDotPlot module][.prepare_enrichment])
#' helpers. Returns the first candidate that is present in `names(data)`,
#' optionally requiring the column to be numeric.
#'
#' @param data A data frame.
#' @param candidates A character vector of candidate column names, in priority
#'   order.
#' @param numeric Logical; when `TRUE`, only numeric columns are considered.
#' @param exclude Column names to ignore.
#' @return The name of the first matching column, or `NULL` when none match.
#'
#' @author Jacob Martin, Jared Andrews
#' @rdname INTERNAL_detect_column
#' @keywords internal
.detect_column <- function(data, candidates, numeric = FALSE, exclude = NULL) {
    candidates <- setdiff(candidates, exclude)
    for (nm in candidates) {
        if (nm %in% names(data) && (!numeric || is.numeric(data[[nm]]))) {
            return(nm)
        }
    }
    NULL
}

#' Candidate significance / p-value column names for enrichment data
#'
#' A single canonical, priority-ordered vector of the significance columns
#' produced by common enrichment tools, shared by the sunburst fill detector
#' ([.gofan_fill_col()]) and the dot plot p-value detector
#' ([.enrich_pval_col()]) so the two modules agree on what counts as a
#' significance column.
#'
#' @author Jacob Martin, Jared Andrews
#' @rdname INTERNAL_enrichment_pval_candidates
#' @keywords internal
.enrichment_pval_candidates <- c(
    "qvalue", "qvalues", "p.adjust", "padj", "p_adjust", "FDR", "fdr",
    "pvalue", "pval", "p.value", "PValue", "P.Value", "p"
)
