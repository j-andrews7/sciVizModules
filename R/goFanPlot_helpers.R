#' Detect the GO identifier column
#'
#' Finds the first column whose values contain GO identifiers matching
#' `GO:[0-9]+` (either exactly, e.g. `"GO:0006955"`, or embedded in free
#' text, e.g. `"immune response (GO:0006955)"`). Falls back to a column
#' literally named `"ID"` when no GO-like values are found.
#'
#' @param data A data frame of enrichment results.
#' @return The name of the GO ID column, or `NULL` when none is found.
#'
#' @author Jacob Martin
#' @rdname INTERNAL_gofan_id_col
#' @keywords internal
.gofan_id_col <- function(data) {
    for (nm in names(data)) {
        vals <- as.character(data[[nm]])
        vals <- vals[!is.na(vals)]
        if (length(vals) && any(grepl("GO:[0-9]+", vals))) {
            return(nm)
        }
    }
    if ("ID" %in% names(data)) "ID" else NULL
}

#' Extract GO IDs from a vector of possibly-messy strings
#'
#' Pulls the first `GO:[0-9]+` token out of each element and returns a
#' character vector of the same length. Elements with no match become
#' `NA`. Accepts factors and one-column tibble subsets as input.
#'
#' @param x A vector (character, factor, or coercible) that may contain
#'   GO identifiers embedded in free text.
#' @return A character vector of GO IDs, with `NA` where no ID was found.
#'
#' @author Jacob Martin,
#' @rdname INTERNAL_extract_go_id
#' @keywords internal
.extract_go_id <- function(x) {
    if (is.data.frame(x)) x <- x[[1]]
    x <- as.character(x)
    out <- rep(NA_character_, length(x))
    pos <- regexpr("GO:[0-9]+", x)
    hit <- !is.na(pos) & pos != -1
    if (any(hit)) {
        out[hit] <- regmatches(x[hit], regexpr("GO:[0-9]+", x[hit]))
    }
    out
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
#' @author Jacob Martin
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
#' @author Jacob Martin
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
