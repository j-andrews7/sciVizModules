#' Check whether an object is a dittoSeq-compatible object
#'
#' @param object An object to test.
#' @return `TRUE` when `object` is a `SingleCellExperiment`, `SummarizedExperiment`,
#'   or `Seurat` object, otherwise `FALSE`.
#'
#' @importFrom methods is
#' @importClassesFrom SingleCellExperiment SingleCellExperiment
#' @author Jacob Martin, Jared Andrews
#' @rdname INTERNAL_is_ditto_object
#' @keywords internal
.is_ditto_object <- function(object) {
    methods::is(object, "SingleCellExperiment") ||
        methods::is(object, "SummarizedExperiment") ||
        methods::is(object, "Seurat")
}

#' Stop when an object is not dittoSeq-compatible
#'
#' @param object An object to validate.
#' @param arg The argument name to report in the error message.
#' @return Invisibly `TRUE` when valid; otherwise throws an error.
#'
#' @author Jacob Martin, Jared Andrews
#' @rdname INTERNAL_assert_ditto_object
#' @keywords internal
.assert_ditto_object <- function(object, arg = "object") {
    if (!.is_ditto_object(object)) {
        stop(
            sprintf(
                "`%s` must be a SingleCellExperiment, SummarizedExperiment, or Seurat object.",
                arg
            ),
            call. = FALSE
        )
    }
    invisible(TRUE)
}


#' Safely list gene names in a dittoSeq object
#'
#' @param object A dittoSeq-compatible object.
#' @return A character vector of gene names, or `character(0)`.
#'
#' @author Jacob Martin, Jared Andrews
#' @rdname INTERNAL_ditto_genes
#' @keywords internal
.ditto_genes <- function(object) {
    if (!.is_ditto_object(object)) {
        return(character(0))
    }
    tryCatch(
        as.character(dittoSeq::getGenes(object)),
        error = function(e) character(0)
    )
}

#' Safely list metadata column names in a dittoSeq object
#'
#' @param object A dittoSeq-compatible object.
#' @return A character vector of metadata names, or `character(0)`.
#'
#' @author Jacob Martin, Jared Andrews
#' @rdname INTERNAL_ditto_metas
#' @keywords internal
.ditto_metas <- function(object) {
    if (!.is_ditto_object(object)) {
        return(character(0))
    }
    tryCatch(
        as.character(dittoSeq::getMetas(object)),
        error = function(e) character(0)
    )
}

#' Safely list dimensionality reduction names in a dittoSeq object
#'
#' @param object A dittoSeq-compatible object.
#' @return A character vector of reduction names, or `character(0)`.
#'
#' @author Jacob Martin, Jared Andrews
#' @rdname INTERNAL_ditto_reductions
#' @keywords internal
.ditto_reductions <- function(object) {
    if (!.is_ditto_object(object)) {
        return(character(0))
    }
    tryCatch(
        as.character(dittoSeq::getReductions(object)),
        error = function(e) character(0)
    )
}

#' Choose a default dimensional reduction for a dittoSeq object
#'
#' Returns the name of the reduction to use by default: the first available
#' reduction on the object, or an empty string when none are present.
#'
#' @param object A dittoSeq-compatible object.
#' @return A length-one character naming a reduction, or `""` when none exist.
#'
#' @author Jacob Martin, Jared Andrews
#' @rdname INTERNAL_get_default_reduction
#' @keywords internal
get_default_reduction <- function(object) {
    reds <- .ditto_reductions(object)
    if (length(reds)) reds[1] else ""
}

#' Fetch the values of a single metadata column
#'
#' @param object A dittoSeq-compatible object.
#' @param meta The name of a metadata column.
#' @return The metadata values, or `NULL` when unavailable.
#'
#' @author Jacob Martin, Jared Andrews
#' @rdname INTERNAL_ditto_meta_values
#' @keywords internal
.ditto_meta_values <- function(object, meta) {
    if (!.is_ditto_object(object) || is.null(meta) || !nzchar(meta)) {
        return(NULL)
    }
    tryCatch(
        dittoSeq::meta(meta, object),
        error = function(e) NULL
    )
}

#' Identify discrete metadata columns in a dittoSeq object
#'
#' Metadata are treated as discrete when they are logicals, numeric columns
#' with a small number of unique values (<= `max.levels`), or factors and
#' characters with fewer than `max.categories` levels. A character column of
#' cell barcodes is left out, since it would ask for one colour per cell.
#'
#' @param object A dittoSeq-compatible object.
#' @param max.levels Maximum number of unique values for a numeric column to be
#'   treated as discrete.
#' @param max.categories Factor and character columns with this many or more
#'   levels are left out. Passed to [VizModules::facet_check()].
#' @return A character vector of discrete metadata names.
#'
#' @author Jacob Martin, Jared Andrews
#' @rdname INTERNAL_ditto_discrete_metas
#' @keywords internal
.ditto_discrete_metas <- function(object, max.levels = 30, max.categories = 50) {
    metas <- .ditto_metas(object)
    if (length(metas) == 0) {
        return(character(0))
    }
    keep <- vapply(metas, function(m) {
        vals <- .ditto_meta_values(object, m)
        if (is.null(vals)) {
            return(FALSE)
        }
        if (is.factor(vals) || is.character(vals)) {
            return(length(facet_check(data.frame(v = vals), max.categories)) > 0)
        }
        is.logical(vals) || length(unique(stats::na.omit(vals))) <= max.levels
    }, logical(1))
    metas[keep]
}

#' Identify continuous metadata columns in a dittoSeq object
#'
#' @param object A dittoSeq-compatible object.
#' @param max.levels Numeric columns with more than this many unique values are
#'   treated as continuous.
#' @return A character vector of continuous metadata names.
#'
#' @author Jacob Martin, Jared Andrews
#' @rdname INTERNAL_ditto_continuous_metas
#' @keywords internal
.ditto_continuous_metas <- function(object, max.levels = 30) {
    metas <- .ditto_metas(object)
    if (length(metas) == 0) {
        return(character(0))
    }
    keep <- vapply(metas, function(m) {
        vals <- .ditto_meta_values(object, m)
        if (is.null(vals)) {
            return(FALSE)
        }
        is.numeric(vals) && length(unique(stats::na.omit(vals))) > max.levels
    }, logical(1))
    metas[keep]
}

#' Build the choices for a "color/var" selector (metadata + genes)
#'
#' @param object A dittoSeq-compatible object.
#' @param include.blank Whether to prepend an empty choice.
#' @return A named character vector suitable for `VizModules::viz_select_input()` choices.
#'
#' @author Jacob Martin, Jared Andrews
#' @rdname INTERNAL_ditto_var_choices
#' @keywords internal
.ditto_var_choices <- function(object, include.blank = TRUE) {
    # Discrete metadata with too many levels to colour by are left out.
    metas <- .ditto_metas(object)
    metas <- metas[metas %in% c(.ditto_discrete_metas(object), .ditto_continuous_metas(object))]
    genes <- .ditto_genes(object)
    choices <- list()
    if (length(metas) > 0) choices[["Metadata"]] <- metas
    if (length(genes) > 0) choices[["Genes"]] <- genes
    if (include.blank) {
        choices <- c(list(" " = ""), choices)
    }
    choices
}

#' Build the choices for a continuous selector (numeric metadata + genes)
#'
#' @param object A dittoSeq-compatible object.
#' @param include.blank Whether to prepend an empty choice.
#' @return A named character vector suitable for `VizModules::viz_select_input()` choices.
#'
#' @author Jacob Martin, Jared Andrews
#' @rdname INTERNAL_ditto_continuous_choices
#' @keywords internal
.ditto_continuous_choices <- function(object, include.blank = TRUE) {
    metas <- .ditto_continuous_metas(object)
    genes <- .ditto_genes(object)
    choices <- list()
    if (length(metas) > 0) choices[["Metadata"]] <- metas
    if (length(genes) > 0) choices[["Genes"]] <- genes
    if (include.blank) {
        choices <- c(list(" " = ""), choices)
    }
    choices
}

#' Choose a sensible default dimensionality reduction
#'
#' @param object A dittoSeq-compatible object.
#' @return The name of the best-guess reduction (priority UMAP > t-SNE > PCA),
#'   or `NULL` when none exist.
#'
#' @author Jacob Martin, Jared Andrews
#' @rdname INTERNAL_ditto_default_reduction
#' @keywords internal
.ditto_default_reduction <- function(object) {
    reds <- .ditto_reductions(object)
    if (length(reds) == 0) {
        return(NULL)
    }
    for (p in c("umap", "tsne", "pca")) {
        hit <- grep(p, reds, ignore.case = TRUE, value = TRUE)
        if (length(hit) > 0) {
            return(hit[1])
        }
    }
    reds[1]
}

#' Discrete levels of a metadata column, for palette groups
#'
#' @param object A dittoSeq-compatible object.
#' @param meta The name of a metadata column.
#' @return A character vector of levels, or `character(0)`.
#'
#' @author Jacob Martin, Jared Andrews
#' @rdname INTERNAL_ditto_group_levels
#' @keywords internal
.ditto_group_levels <- function(object, meta) {
    if (!.is_ditto_object(object) || is.null(meta) || !nzchar(meta)) {
        return(character(0))
    }
    lv <- tryCatch(dittoSeq::metaLevels(meta, object), error = function(e) NULL)
    if (is.null(lv)) {
        vals <- .ditto_meta_values(object, meta)
        if (is.null(vals)) {
            return(character(0))
        }
        lv <- levels(as.factor(as.character(vals)))
    }
    as.character(lv)
}

#' Build the module reset handler shared by dittoSeq modules
#'
#' Resets the uniform Plotly/Axes/Legend/Lines tabs to their defaults. Individual
#' modules add their own data-tab resets on top of this.
#'
#' @param session The Shiny module session.
#' @param defaults A named list of default input values (may be `NULL`).
#' @return Invisibly `NULL`.
#'
#' @import shiny
#' @author Jacob Martin, Jared Andrews
#' @rdname INTERNAL_ditto_reset_uniform
#' @keywords internal
.ditto_reset_uniform <- function(session, defaults = NULL) {
    reset_lines_inputs(session, defaults = defaults)
    reset_axes_inputs(session, defaults)
    reset_plotly_inputs(session, defaults)
    reset_legend_inputs(session, defaults)
    invisible(NULL)
}
