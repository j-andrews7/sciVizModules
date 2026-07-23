#' Merge enrichment default mappings into a user-supplied defaults list
#'
#' User-supplied defaults take precedence over the auto-detected mappings.
#'
#' @param defaults A named list of user defaults (or `NULL`).
#' @param mapping The mapping list produced by [.prepare_enrichment()].
#' @return A named list of defaults keyed by DotPlot UI input IDs.
#'
#' @author Jacob Martin, Jared Andrews
#' @rdname INTERNAL_enrich_defaults
#' @keywords internal
.enrich_defaults <- function(defaults, mapping) {
    if (is.null(defaults)) defaults <- list()
    if (!is.null(mapping$y) && is.null(defaults[["y.data"]])) defaults[["y.data"]] <- mapping$y
    if (!is.null(mapping$x) && is.null(defaults[["x.data"]])) defaults[["x.data"]] <- mapping$x
    if (!is.null(mapping$size) && is.null(defaults[["size.by"]])) defaults[["size.by"]] <- mapping$size
    if (!is.null(mapping$fill) && is.null(defaults[["fill.by"]])) defaults[["fill.by"]] <- mapping$fill
    defaults
}

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
#' produced by common enrichment tools, shared by the sunburst fill detection
#' in [goFanPlot()] and the dot plot p-value detector
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
