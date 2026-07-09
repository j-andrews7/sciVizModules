#' Check whether an object is a dittoSeq-compatible object
#'
#' @param object An object to test.
#' @return `TRUE` when `object` is a `SingleCellExperiment`, `SummarizedExperiment`,
#'   or `Seurat` object, otherwise `FALSE`.
#'
#' @importFrom methods is
#' @author Jared Andrews
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
#' @author Jared Andrews
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

#' Fetch a default value for a dittoSeq module input
#'
#' @param defaults A named list of defaults (may be `NULL`).
#' @param key The default name to look up.
#' @param fallback The value to return when `key` is absent.
#' @return The stored default or `fallback`.
#'
#' @author Jared Andrews
#' @rdname INTERNAL_ditto_default
#' @keywords internal
.ditto_default <- function(defaults, key, fallback = NULL) {
    if (!is.null(defaults) && key %in% names(defaults)) {
        return(defaults[[key]])
    }
    fallback
}

#' Safely list gene names in a dittoSeq object
#'
#' @param object A dittoSeq-compatible object.
#' @return A character vector of gene names, or `character(0)`.
#'
#' @author Jared Andrews
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
#' @author Jared Andrews
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
#' @author Jared Andrews
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

#' Fetch the values of a single metadata column
#'
#' @param object A dittoSeq-compatible object.
#' @param meta The name of a metadata column.
#' @return The metadata values, or `NULL` when unavailable.
#'
#' @author Jared Andrews
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
#' Metadata are treated as discrete when they are factors, characters, logicals,
#' or numeric columns with a small number of unique values (<= `max.levels`).
#'
#' @param object A dittoSeq-compatible object.
#' @param max.levels Maximum number of unique values for a numeric column to be
#'   treated as discrete.
#' @return A character vector of discrete metadata names.
#'
#' @author Jared Andrews
#' @rdname INTERNAL_ditto_discrete_metas
#' @keywords internal
.ditto_discrete_metas <- function(object, max.levels = 30) {
    metas <- .ditto_metas(object)
    if (length(metas) == 0) {
        return(character(0))
    }
    keep <- vapply(metas, function(m) {
        vals <- .ditto_meta_values(object, m)
        if (is.null(vals)) {
            return(FALSE)
        }
        is.factor(vals) || is.character(vals) || is.logical(vals) ||
            length(unique(stats::na.omit(vals))) <= max.levels
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
#' @author Jared Andrews
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
#' @return A named character vector suitable for `selectInput()` choices.
#'
#' @author Jared Andrews
#' @rdname INTERNAL_ditto_var_choices
#' @keywords internal
.ditto_var_choices <- function(object, include.blank = TRUE) {
    metas <- .ditto_metas(object)
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
#' @return A named character vector suitable for `selectInput()` choices.
#'
#' @author Jared Andrews
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
#' @author Jared Andrews
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
#' @author Jared Andrews
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

#' Apply the shared VizModules plotly styling stack to a dittoSeq figure
#'
#' Applies the title, axis, legend, reference-line, config, and annotation
#' post-processing used across the sciVizModules dittoSeq modules so that the
#' plotly figure produced from a `dittoSeq` `ggplot` respects the module's UI
#' controls. Mirrors the styling stack used by [survivalCurveServer()].
#'
#' @param fig A `plotly` figure (typically from [plotly::ggplotly()]).
#' @param input The Shiny module `input` object.
#' @param isolate_fn The isolation helper returned by
#'   [VizModules::setup_auto_update_logic()].
#' @return The styled `plotly` figure.
#'
#' @import plotly
#' @author Jared Andrews
#' @rdname INTERNAL_ditto_finalize_plotly
#' @keywords internal
.ditto_finalize_plotly <- function(fig, input, isolate_fn) {
    fig <- VizModules::apply_title_layout(
        fig, input, isolate_fn,
        title_y = 0.95,
        title_x = isolate_fn(input$axis.title.horizontal.position)
    )
    xaxis_style <- VizModules::create_axis_styles(
        input,
        axis_side = "x", isolate_fn = isolate_fn, ggplot.axis.styling = FALSE
    )
    yaxis_style <- VizModules::create_axis_styles(
        input,
        axis_side = "y", isolate_fn = isolate_fn, ggplot.axis.styling = FALSE
    )
    fig <- VizModules::apply_subplot_axis_styling(fig, xaxis_style, yaxis_style)

    fig <- VizModules::add_reference_lines(fig,
        hline.intercepts = isolate_fn(input$hline.intercepts),
        hline.colors = isolate_fn(input$hline.colors),
        hline.widths = isolate_fn(input$hline.widths),
        hline.linetypes = isolate_fn(input$hline.linetypes),
        hline.opacities = isolate_fn(input$hline.opacities),
        vline.intercepts = isolate_fn(input$vline.intercepts),
        vline.colors = isolate_fn(input$vline.colors),
        vline.widths = isolate_fn(input$vline.widths),
        vline.linetypes = isolate_fn(input$vline.linetypes),
        vline.opacities = isolate_fn(input$vline.opacities),
        abline.slopes = isolate_fn(input$abline.slopes),
        abline.intercepts = isolate_fn(input$abline.intercepts),
        abline.colors = isolate_fn(input$abline.colors),
        abline.widths = isolate_fn(input$abline.widths),
        abline.linetypes = isolate_fn(input$abline.linetypes),
        abline.opacities = isolate_fn(input$abline.opacities)
    )

    config_list <- add_plot_config(
        download.format = isolate_fn(input$download.format),
        include.modebar.buttons = TRUE, facet.by = NULL
    )
    fig <- do.call(config, c(list(p = fig), config_list))
    fig <- apply_plotly_newshape(fig, input, isolate_fn)

    fig <- apply_legend_styling(
        fig,
        title.size = isolate_fn(input$legend.title.size),
        text.size = isolate_fn(input$legend.text.size),
        position = c(1.02, "left", "v")
    )
    fig <- axis_titles_as_annotations(fig)
    fig
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
#' @author Jared Andrews
#' @rdname INTERNAL_ditto_reset_uniform
#' @keywords internal
.ditto_reset_uniform <- function(session, defaults = NULL) {
    reset_lines_inputs(session, defaults = defaults)
    reset_axes_inputs(session, defaults)
    reset_plotly_inputs(session, defaults)
    reset_legend_inputs(session, defaults)
    invisible(NULL)
}
