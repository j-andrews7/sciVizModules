#' Input UI components for the dittoHeatmap module
#'
#' This should be placed in the UI where the inputs should be shown, with an `id`
#' that matches the `id` used in the `dittoHeatmapServer()` and
#' `dittoHeatmapOutputUI()` functions.
#'
#' @details The user inputs for this module are separated from the outputs to allow for
#' more flexible UI design.
#'
#' The module is the interactive counterpart of [dittoSeq::dittoHeatmap()]: the
#' expression of chosen genes across the cells (or samples) of a
#' `SingleCellExperiment`, `SummarizedExperiment` or `Seurat` object, with cell
#' metadata as annotation tracks. The expression matrix is pulled with
#' `dittoHeatmap(data.out = TRUE)` and drawn by
#' [VizModules::ComplexHeatmap_HeatmapInputsUI()], so its scaling, clustering,
#' splitting, colour, label and annotation controls all apply; those inputs
#' are documented there. Every metadata column is available as a column
#' annotation; the cell identifier is the `cell` column (the column key).
#'
#' **This module is not plotly.** It renders through InteractiveComplexHeatmap
#' (hover, click and brush a region for a sub-heatmap), so the shared plotly
#' tabs (Axes, Legend, Lines, Plotly) do not apply, and it needs ComplexHeatmap,
#' InteractiveComplexHeatmap and circlize. Genes that do not vary across the
#' cells are dropped, since they cannot be scaled or clustered.
#'
#' @section Plot parameters not implemented or with altered functionality:
#' The following [dittoSeq::dittoHeatmap()] parameters are not available via UI inputs:
#'
#' - `scale`, `scaled.to.max` - Scaling is the wrapped module's `scale` input
#'   ("None", "Rows" for a per-gene z-score, "Columns")
#' - `heatmap.colors`, `heatmap.colors.max.scaled` - The wrapped module's
#'   `low_color`, `mid_color` and `high_color`
#' - `annotation_col`, `annotation_colors` - Annotation tracks and their colours
#'   are set on the wrapped module's Annotations tab
#' - `cells.use` - Use the wrapped module's Column Filter, an expression over the
#'   cell metadata (e.g. `celltype == "T cell"`)
#' - `cluster_cols`, `show_colnames`, `show_rownames`, `main` - The wrapped
#'   module's Clustering and Labels tabs
#' - `metas`, `highlight.features`, `cell.names.meta`, `swap.rownames`, `slot`,
#'   `complex`, `data.out` - Not exposed
#'
#' @section Plot parameters and defaults:
#' The following parameters can be accessed via UI inputs and/or the `defaults` argument:
#'
#' - `dh.genes` - Genes to show (UI: "Genes", default: the 20 most variable genes;
#'   dittoSeq `genes`)
#' - `dh.assay` - Assay (UI: "Assay", default: dittoSeq's default, `logcounts`
#'   when present; dittoSeq `assay`)
#' - `dh.order.by` - Metadata column the cells are ordered by, or `""` for the
#'   object's order (UI: "Order Cells By", default: the first discrete metadata
#'   column; dittoSeq `order.by`)
#' - `annot.by` - Metadata columns shown as column annotations when the module
#'   opens (default: the first discrete metadata column; dittoSeq `annot.by`).
#'   Not an input: further tracks are added on the Annotations tab.
#' - Wrapped heatmap defaults set here: `scale = "Rows"`, `cluster_columns =
#'   FALSE`, `show_column_dend = FALSE`, `show_column_names` (only for 50 or
#'   fewer cells), `name = "Expression"`
#' - All other [VizModules::ComplexHeatmap_HeatmapInputsUI()] parameters, except
#'   `matrix.cols` and `rowname.col`, which the module sets
#'
#' @section Parameters controlling additional functionality:
#' Annotation colours can be seeded with a `defaults` entry named after the
#' metadata column, e.g. `celltype = c("B cell" = "#E69F00")`; by default they
#' are dittoSeq's annotation colours.
#'
#' @param id The ID for the Shiny module.
#' @param data A `SingleCellExperiment`, `SummarizedExperiment` or `Seurat`
#'   object used to populate the input choices.
#' @param defaults A named list of default values for the inputs.
#' @param title An optional title for the UI grid.
#' @param columns Number of columns for the UI grid.
#' @return A Shiny tagList containing the UI elements
#'
#' @import shiny
#'
#' @export
#' @author Jared Andrews
#' @seealso [dittoSeq::dittoHeatmap()], [VizModules::ComplexHeatmap_HeatmapInputsUI()],
#' [sciVizModules::dittoHeatmapOutputUI()], [sciVizModules::dittoHeatmapServer()],
#' [sciVizModules::dittoHeatmapApp()]
#' @examples
#' library(sciVizModules)
#' data(example_sce)
#' if (requireNamespace("ComplexHeatmap", quietly = TRUE)) {
#'     dittoHeatmapInputsUI("heatmap", example_sce)
#' }
dittoHeatmapInputsUI <- function(id, data, defaults = NULL, title = "dittoHeatmap Settings", columns = 2) {
    ns <- NS(id)
    .assert_ditto_object(data, "data")
    d <- .dh_defaults(data, defaults)
    frame <- .ditto_heatmap_data(data, d$dh.genes, blank_to_null(d$dh.assay), d$dh.order.by)
    assays <- .ditto_assays(data)
    disc <- .ditto_discrete_metas(data)

    extras <- tagList(
        .sci_tip(viz_select_input(ns("dh.genes"), "Genes",
            choices = .ditto_genes(data), selected = d$dh.genes, multiple = TRUE
        ), "Genes to show, one row each. Genes that do not vary across the cells are dropped."),
        if (length(assays)) {
            .sci_tip(viz_select_input(ns("dh.assay"), "Assay", choices = assays, selected = d$dh.assay),
                "The assay the expression values are taken from.")
        },
        .sci_tip(viz_select_input(ns("dh.order.by"), "Order Cells By",
            choices = c("Object order" = "", stats::setNames(disc, disc)), selected = d$dh.order.by
        ), "Metadata the cells are ordered by. Turn column clustering off to keep this order.")
    )

    .heatmap_wrapper_inputs_ui(id, extras, frame, .dh_heat_defaults(frame, data, d, defaults), title, columns)
}


#' Output UI components for the dittoHeatmap module
#'
#' This should be placed in the UI where the plot should be shown. The heatmap
#' is an InteractiveComplexHeatmap widget, not a plotly figure.
#'
#' @param id The ID for the Shiny module.
#' @param resizable Accepted for consistency with the other modules; the
#'   widget sizes itself to its container.
#' @param ... Passed to [VizModules::ComplexHeatmap_HeatmapOutputUI()], e.g.
#'   `layout` or `compact`.
#' @return A Shiny tagList with the heatmap widget.
#'
#' @examples
#' if (requireNamespace("InteractiveComplexHeatmap", quietly = TRUE)) {
#'     dittoHeatmapOutputUI("heatmap")
#' }
#' @export
#' @author Jared Andrews
dittoHeatmapOutputUI <- function(id, resizable = TRUE, ...) {
    .heatmap_wrapper_output_ui(id, resizable = resizable, ...)
}
