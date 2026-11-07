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

# The Annotate By choice standing for each cell's own name.
.ditto_cell_id <- "cell.id"


#' The Annotate By choices of a dittoSeq object
#'
#' @param object A dittoSeq-compatible object.
#' @return The cells' metadata columns, the cell names and a blank.
#'
#' @author Jared Andrews
#' @rdname INTERNAL_ditto_annotation_choices
#' @keywords internal
.ditto_annotation_choices <- function(object) {
    unique(c("", .ditto_cell_id, .ditto_metas(object)))
}


#' The Annotations tab of a dittoSeq module
#'
#' @param ns The module's namespace function.
#' @param defaults The module's defaults.
#' @param object The dittoSeq-compatible object.
#' @param note Optional further text for the Annotate By tooltip.
#' @return The inputs of [VizModules::uniform_annotation_inputs_ui()].
#'
#' @author Jared Andrews
#' @rdname INTERNAL_ditto_annotation_inputs_ui
#' @keywords internal
.ditto_annotation_inputs_ui <- function(ns, defaults, object, note = NULL) {
    uniform_annotation_inputs_ui(ns, defaults, .ditto_annotation_choices(object),
        annotate.note = c("Use cell.id for the cells' own names", note)
    )
}


#' What a dittoSeq module's Annotations tab labels
#'
#' Call once in the server body. The cells picked with the lasso or box tools add
#' up until Clear Annotations, or until `redrawn()` changes: plotly reports each
#' by its place in its trace, so a plot grouped differently would have them label
#' other cells. Nothing is recorded without an Annotate By column, so a selection
#' then does not redraw the plot. Both values are reactives the draw step reads,
#' so both belong in its `extra`.
#'
#' @param input The module's input.
#' @param plot_source The event source from [VizModules::setup_manual_edits()].
#' @param params The reactive-defaults store, or `NULL`.
#' @param redrawn A function reading whatever regroups the module's traces.
#' @return A list of `highlights`, the debounced Points to Highlight text (free
#'   text, see [.sci_debounced_input()]), and `selected`, the picked cells.
#'
#' @import shiny
#' @import plotly
#' @author Jared Andrews
#' @rdname INTERNAL_ditto_annotation_state
#' @keywords internal
.ditto_annotation_state <- function(input, plot_source, params, redrawn) {
    selected <- reactiveVal()
    observeEvent(event_data("plotly_selected", source = plot_source), {
        req(nz_value(input$annotate.by))
        picked <- rbind(selected(), event_data("plotly_selected", source = plot_source))
        picked <- picked[!duplicated(picked), ]
        selected(if (nrow(picked) > 0) picked)
    })
    observeEvent(input$annotation.clear, selected(NULL))
    observeEvent(redrawn(), selected(NULL), ignoreInit = TRUE, priority = 1000)
    list(highlights = .sci_debounced_input(input, "highlight.points", params), selected = selected)
}


#' Reset a dittoSeq module's Annotations tab
#'
#' @param session The module's session.
#' @param defaults The module's defaults.
#' @param object The dittoSeq-compatible object.
#' @param annotations The list from [.ditto_annotation_state()].
#' @return Invisibly `NULL`.
#'
#' @author Jared Andrews
#' @rdname INTERNAL_ditto_reset_annotations
#' @keywords internal
.ditto_reset_annotations <- function(session, defaults, object, annotations) {
    reset_annotation_inputs(session, defaults, .ditto_annotation_choices(object))
    annotations$selected(NULL)
    invisible(NULL)
}


#' Add the cell names to an object's metadata
#'
#' dittoSeq draws its hover text from metadata, so this is how the cells' own
#' names reach it. A `cell.id` column the object already has is left alone.
#'
#' @param object A dittoSeq-compatible object.
#' @return The object, with a `cell.id` metadata column.
#'
#' @author Jared Andrews
#' @rdname INTERNAL_ditto_with_cell_ids
#' @keywords internal
.ditto_with_cell_ids <- function(object) {
    if (!.ditto_cell_id %in% .ditto_metas(object)) object$cell.id <- colnames(object)
    object
}


#' Highlight and label the cells the Annotations tab names
#'
#' The VizModules helpers match a point on its `annotate.by` line of hover text,
#' so the figure must have been drawn with that field, and only its marker
#' traces are looked at (an ellipse or contour comes from the same data).
#'
#' @param fig A built plotly figure.
#' @param object The object it was drawn from.
#' @param annotate.by The Annotate By column, or `NULL`, which leaves `fig` alone.
#' @param highlights The Points to Highlight text.
#' @param selected The cells picked on the plot, as `event_data()` reports them.
#' @param input,isolate_fn The module's input and isolation helper.
#' @param size The plot's point size.
#' @return The figure, with its highlighted points restyled and the labels
#'   appended to its annotations.
#'
#' @author Jared Andrews
#' @rdname INTERNAL_ditto_annotate
#' @keywords internal
.ditto_annotate <- function(fig, object, annotate.by, highlights, selected, input, isolate_fn, size) {
    if (is.null(annotate.by)) {
        return(fig)
    }
    values <- as.character(.ditto_meta_values(object, annotate.by))
    highlighted <- parse_highlight_values(highlights, values)
    if (length(highlighted) > 0) {
        fig <- apply_highlight_styling(fig, annotate.by, highlighted,
            style = list(
                color = isolate_fn(input$highlight.color),
                size = isolate_fn(input$highlight.size),
                border.color = isolate_fn(input$highlight.border.color),
                border.width = isolate_fn(input$highlight.border.width)
            ),
            default.size = size, require.markers = TRUE
        )
    }

    style <- list(
        ax = isolate_fn(input$annotation.ax),
        ay = isolate_fn(input$annotation.ay),
        showarrow = isolate_fn(input$annotation.showarrow),
        arrowcolor = isolate_fn(input$annotation.arrowcolor),
        arrowhead = isolate_fn(input$annotation.arrowhead),
        arrowwidth = isolate_fn(input$annotation.arrowwidth),
        size = isolate_fn(input$annotation.size),
        color = isolate_fn(input$annotation.color)
    )
    labels <- create_selected_annotations(selected, fig, annotate.by, style, require.markers = TRUE)
    if (length(highlighted) > 0 && isTRUE(isolate_fn(input$highlight.auto.annotate))) {
        labels <- merge_annotation_sets(labels, create_highlight_annotations(
            stats::setNames(data.frame(values), annotate.by), fig, annotate.by, highlighted,
            x_col = NULL, y_col = NULL, annotation_params = style, require.markers = TRUE
        ))
    }
    fig$x$layout$annotations <- c(fig$x$layout$annotations, labels)
    fig
}


#' Build the module reset handler shared by dittoSeq modules
#'
#' Resets the uniform Plotly/Axes/Legend/Lines tabs to their defaults, and drops
#' any manual edits to the plot. Individual modules add their own data-tab resets
#' on top of this.
#'
#' @param session The Shiny module session.
#' @param defaults A named list of default input values (may be `NULL`).
#' @param edit_store The store from [VizModules::setup_manual_edits()].
#' @return Invisibly `NULL`.
#'
#' @import shiny
#' @author Jacob Martin, Jared Andrews
#' @rdname INTERNAL_ditto_reset_uniform
#' @keywords internal
.ditto_reset_uniform <- function(session, defaults = NULL, edit_store = NULL) {
    reset_lines_inputs(session, defaults = defaults)
    reset_axes_inputs(session, defaults)
    reset_plotly_inputs(session, defaults)
    reset_legend_inputs(session, defaults)
    if (!is.null(edit_store)) reset_manual_edits(edit_store)
    invisible(NULL)
}
