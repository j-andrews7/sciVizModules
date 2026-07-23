#' Detect the enrichment term column
#'
#' @param data A data frame of enrichment results.
#' @return The name of the column holding the enrichment term/description, or
#'   `NULL` when none is found.
#'
#' @author Jacob Martin, Jared Andrews
#' @rdname INTERNAL_enrich_term_col
#' @keywords internal
.enrich_term_col <- function(data) {
    .detect_column(data, c(
        "Description", "description", "Term", "term", "pathway", "Pathway",
        "name", "Name", "geneSet", "ID", "id"
    ))
}

#' Detect a categorical grouping column for the enrichment x-axis
#'
#' @param data A data frame of enrichment results.
#' @param exclude Column names to ignore (e.g. the term column).
#' @return The name of a discrete grouping column, or `NULL` when none is found.
#'
#' @author Jacob Martin, Jared Andrews
#' @rdname INTERNAL_enrich_group_col
#' @keywords internal
.enrich_group_col <- function(data, exclude = NULL) {
    candidates <- c(
        "Cluster", "cluster", "group", "Group", "comparison", "Comparison",
        "contrast", "Contrast", "Direction", "direction", "sign", "Sign",
        "geneset", "GeneSet", "gene_set", "ONTOLOGY", "Ontology", "ontology",
        "category", "Category", "database", "Database", "source", "Source",
        "Type", "type"
    )
    candidates <- setdiff(candidates, exclude)
    for (nm in candidates) {
        if (nm %in% names(data) && !is.numeric(data[[nm]])) {
            return(nm)
        }
    }
    NULL
}

#' Detect a ratio-like column for the enrichment dot size
#'
#' @param data A data frame of enrichment results.
#' @return The name of a numeric ratio-like column, or `NULL` when none is found.
#'
#' @author Jacob Martin, Jared Andrews
#' @rdname INTERNAL_enrich_ratio_col
#' @keywords internal
.enrich_ratio_col <- function(data) {
    candidates <- c(
        "GeneRatio", "generatio", "Ratio", "richFactor", "RichFactor",
        "rich_factor", "FoldEnrichment", "fold_enrichment", "foldEnrichment",
        "NES", "Count", "count"
    )
    for (nm in candidates) {
        if (nm %in% names(data) && is.numeric(data[[nm]])) {
            return(nm)
        }
    }
    NULL
}

#' Detect a p-value column for the enrichment dot color
#'
#' @param data A data frame of enrichment results.
#' @return The name of a numeric p-value column, or `NULL` when none is found.
#'
#' @author Jacob Martin, Jared Andrews
#' @rdname INTERNAL_enrich_pval_col
#' @keywords internal
.enrich_pval_col <- function(data) {
    candidates <- c(
        "p.adjust", "padj", "p_adjust", "FDR", "fdr", "qvalue", "qvalues",
        "pvalue", "pval", "p.value", "PValue", "P.Value", "p"
    )
    for (nm in candidates) {
        if (nm %in% names(data) && is.numeric(data[[nm]])) {
            return(nm)
        }
    }
    NULL
}

#' Parse a "GeneRatio"-style fraction string to a numeric ratio
#'
#' Converts values such as `"8/196"` to `8 / 196`. Values that are already
#' numeric are returned unchanged; anything that cannot be parsed becomes `NA`.
#'
#' @param x A character or numeric vector.
#' @return A numeric vector of ratios.
#'
#' @author Jacob Martin, Jared Andrews
#' @rdname INTERNAL_parse_ratio
#' @keywords internal
.parse_ratio <- function(x) {
    if (is.numeric(x)) {
        return(x)
    }
    x <- as.character(x)
    parts <- strsplit(x, "/", fixed = TRUE)
    vapply(parts, function(p) {
        if (length(p) == 2) {
            num <- suppressWarnings(as.numeric(p[1]))
            den <- suppressWarnings(as.numeric(p[2]))
            if (!is.na(num) && !is.na(den) && den != 0) {
                return(num / den)
            }
            return(NA_real_)
        }
        suppressWarnings(as.numeric(p[1]))
    }, numeric(1))
}

#' Prepare enrichment data and default mappings for the dot plot module
#'
#' Augments an enrichment results table with a numeric `GeneRatio` column and a
#' `neg_log10_pvalue` column, guarantees a categorical grouping column for the
#' x-axis, and returns sensible default UI mappings for [plotthis::DotPlot()].
#'
#' @param data A data frame of enrichment results.
#' @return A list with elements `data` (the augmented data frame) and `mapping`
#'   (a named list with `x`, `y`, `size`, and `fill` column names).
#'
#' @author Jacob Martin, Jared Andrews
#' @rdname INTERNAL_prepare_enrichment
#' @keywords internal
.prepare_enrichment <- function(data) {
    data <- as.data.frame(data)

    term_col <- .enrich_term_col(data)
    group_col <- .enrich_group_col(data, exclude = term_col)

    # Guarantee a categorical x-axis grouping column.
    if (is.null(group_col)) {
        group_col <- "Group"
        data[[group_col]] <- factor("Enrichment")
    }

    # Numeric GeneRatio for dot size. Parse fraction strings when needed.
    size_col <- NULL
    if ("GeneRatio" %in% names(data)) {
        data[["GeneRatio"]] <- .parse_ratio(data[["GeneRatio"]])
        size_col <- "GeneRatio"
    } else {
        ratio <- .enrich_ratio_col(data)
        if (!is.null(ratio)) size_col <- ratio
    }

    # -log10 transformed p-value for dot color.
    fill_col <- NULL
    pval_col <- .enrich_pval_col(data)
    if (!is.null(pval_col)) {
        p <- suppressWarnings(as.numeric(data[[pval_col]]))
        p[is.na(p) | p <= 0] <- NA_real_
        data[["neg_log10_pvalue"]] <- -log10(p)
        fill_col <- "neg_log10_pvalue"
    }

    list(
        data = data,
        mapping = list(
            x = group_col,
            y = term_col,
            size = size_col,
            fill = fill_col
        )
    )
}

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
