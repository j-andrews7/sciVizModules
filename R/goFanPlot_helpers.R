#' Detect the GO identifier column
#'
#' Finds the first column whose values look like GO identifiers (`"GO:0006955"`).
#' Falls back to a column literally named `"ID"` when no GO-like values are
#' found.
#'
#' @param data A data frame of enrichment results.
#' @return The name of the GO ID column, or `NULL` when none is found.
#'
#' @author Jacob Martin, Jared Andrews
#' @rdname INTERNAL_gofan_id_col
#' @keywords internal
.gofan_id_col <- function(data) {
    for (nm in names(data)) {
        vals <- as.character(data[[nm]])
        vals <- vals[!is.na(vals)]
        if (length(vals) && any(grepl("^GO:[0-9]+$", vals))) {
            return(nm)
        }
    }
    if ("ID" %in% names(data)) "ID" else NULL
}

#' Detect the GO ontology category
#'
#' Inspects a `ONTOLOGY`-style column (when present) and returns the most common
#' of `"BP"`, `"CC"`, or `"MF"`. Defaults to `"BP"` when no such column exists.
#'
#' @param data A data frame of enrichment results.
#' @return A length-one character: one of `"BP"`, `"CC"`, or `"MF"`.
#'
#' @author Jacob Martin, Jared Andrews
#' @rdname INTERNAL_gofan_onto
#' @keywords internal
.gofan_onto <- function(data) {
    onto_cols <- intersect(
        c("ONTOLOGY", "Ontology", "ontology", "onto", "Onto", "ont"),
        names(data)
    )
    if (length(onto_cols)) {
        v <- toupper(as.character(data[[onto_cols[1]]]))
        v <- v[v %in% c("BP", "CC", "MF")]
        if (length(v)) {
            return(names(sort(table(v), decreasing = TRUE))[1])
        }
    }
    "BP"
}

#' Detect a fill (colour) column for the sunburst plot
#'
#' Prefers significance columns in the order used by [GOfan::sunburstGO()]
#' (`qvalue` first). Falls back to the first numeric column when none of the
#' known significance columns are present.
#'
#' @param data A data frame of enrichment results.
#' @return The name of a numeric column, or `NULL` when none is found.
#'
#' @author Jacob Martin, Jared Andrews
#' @rdname INTERNAL_gofan_fill_col
#' @keywords internal
.gofan_fill_col <- function(data) {
    candidates <- c(
        "qvalue", "qvalues", "p.adjust", "padj", "FDR", "fdr",
        "pvalue", "pval", "p.value"
    )
    for (nm in candidates) {
        if (nm %in% names(data) && is.numeric(data[[nm]])) {
            return(nm)
        }
    }
    num <- names(data)[vapply(data, is.numeric, logical(1))]
    if (length(num)) num[1] else NULL
}

#' Detect a sub-rectangle (proportional area) column for the sunburst plot
#'
#' Prefers a `Count` column (converted to a proportion by [GOfan::sunburstGO()]).
#'
#' @param data A data frame of enrichment results.
#' @return The name of a numeric column, or `NULL` when none is found.
#'
#' @author Jacob Martin, Jared Andrews
#' @rdname INTERNAL_gofan_subrect_col
#' @keywords internal
.gofan_subrect_col <- function(data) {
    for (nm in c("Count", "count")) {
        if (nm %in% names(data) && is.numeric(data[[nm]])) {
            return(nm)
        }
    }
    NULL
}
