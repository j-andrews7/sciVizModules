#' Input UI components for the sampleDistanceHeatmap module
#'
#' This should be placed in the UI where the inputs should be shown, with an `id`
#' that matches the `id` used in the `sampleDistanceHeatmapServer()` and
#' `sampleDistanceHeatmapOutputUI()` functions.
#'
#' @details The user inputs for this module are separated from the outputs to allow for
#' more flexible UI design.
#'
#' The module draws the sample-to-sample distance heatmap of a bulk expression
#' experiment, the quality check of the DESeq2 vignette: the counts of a
#' `SummarizedExperiment` are transformed, the most variable genes kept, and the
#' Euclidean distances (or Pearson or Spearman correlations) between samples
#' drawn, with the samples ordered by hierarchical clustering (complete linkage)
#' of those distances. Replicates should sit together; an outlier stands apart.
#'
#' The heatmap is drawn by [VizModules::ComplexHeatmap_HeatmapInputsUI()], so
#' its colour, label and annotation controls all apply; those inputs are
#' documented there. Every `colData` column is available as a row and a column
#' annotation; the sample identifier is the `sample` column (the column key).
#' The base module's own clustering is off, since it would re-cluster the rows
#' of the distance matrix by their Euclidean distance rather than use the
#' distances themselves.
#'
#' **This module is not plotly.** It renders through InteractiveComplexHeatmap,
#' so the shared plotly tabs do not apply, and it needs ComplexHeatmap,
#' InteractiveComplexHeatmap and circlize.
#'
#' @section Plot parameters and defaults:
#' The following parameters can be accessed via UI inputs and/or the `defaults` argument:
#'
#' - `sd.assay` - Assay (UI: "Assay", default: `"counts"` when present)
#' - `sd.transform` - Transformation (UI: "Transformation", default: `"vst"`,
#'   DESeq2's variance-stabilising transformation, when DESeq2 is installed,
#'   otherwise `"log2cpm"`; also `"log2"` and `"none"`)
#' - `sd.ntop` - Most variable genes used (UI: "Top Variable Genes", default: 500)
#' - `sd.method` - `"euclidean"`, `"pearson"` or `"spearman"` (UI: "Measure",
#'   default: `"euclidean"`)
#' - `sd.order` - `"cluster"` (hierarchical clustering of the distances) or
#'   `"data"` (the object's order) (UI: "Sample Order", default: `"cluster"`)
#' - Wrapped heatmap defaults set here: `scale = "None"`, clustering off, the
#'   first two `colData` columns that group samples as column annotations, and a blue
#'   ramp, dark where samples are close (`low_color`, `mid_color`,
#'   `high_color`), with the legend titled by the measure (`name`). The legend
#'   title and ramp follow the measure.
#' - All other [VizModules::ComplexHeatmap_HeatmapInputsUI()] parameters, except
#'   `matrix.cols` and `rowname.col`, which the module sets
#'
#' @param id The ID for the Shiny module.
#' @param data A `SummarizedExperiment` of counts (a `DESeqDataSet` will do).
#' @param defaults A named list of default values for the inputs.
#' @param title An optional title for the UI grid.
#' @param columns Number of columns for the UI grid.
#' @return A Shiny tagList containing the UI elements
#'
#' @import shiny
#'
#' @export
#' @author Jared Andrews
#' @seealso [sample_pca()], [VizModules::ComplexHeatmap_HeatmapInputsUI()],
#' [sciVizModules::sampleDistanceHeatmapOutputUI()], [sciVizModules::sampleDistanceHeatmapServer()],
#' [sciVizModules::sampleDistanceHeatmapApp()]
#' @examples
#' library(sciVizModules)
#' if (requireNamespace("ComplexHeatmap", quietly = TRUE) &&
#'     requireNamespace("airway", quietly = TRUE)) {
#'     data("airway", package = "airway")
#'     sampleDistanceHeatmapInputsUI("dist", airway, defaults = list(sd.transform = "log2cpm"))
#' }
sampleDistanceHeatmapInputsUI <- function(id, data, defaults = NULL, title = "Sample Distance Settings",
                                          columns = 2) {
    ns <- NS(id)
    .assert_se(data)
    d <- .sd_defaults(data, defaults)
    frame <- .sample_distance_data(.se_stage(data, d$sd.assay, d$sd.transform), d$sd.ntop, d$sd.method, d$sd.order)

    extras <- tagList(
        .sci_tip(viz_select_input(ns("sd.assay"), "Assay", choices = .se_assays(data), selected = d$sd.assay),
            "The assay the distances are computed from."),
        .sci_tip(viz_select_input(ns("sd.transform"), "Transformation",
            choices = .se_transform_choices(), selected = d$sd.transform
        ), paste("How counts are transformed first. Variance stabilisation (DESeq2) or log2 CPM for raw counts;",
            "None for an assay that is already on a log scale.")),
        .sci_tip(numericInput(ns("sd.ntop"), "Top Variable Genes", value = d$sd.ntop, min = 2, step = 50),
            "The most variable genes the distances are computed from."),
        .sci_tip(viz_select_input(ns("sd.method"), "Measure", choices = .sd_methods, selected = d$sd.method),
            "Euclidean distance, or the Pearson or Spearman correlation, between samples."),
        .sci_tip(viz_select_input(ns("sd.order"), "Sample Order",
            choices = c("Clustered" = "cluster", "As in the data" = "data"), selected = d$sd.order
        ), "Order the samples by hierarchical clustering (complete linkage) of the distances, or keep their order.")
    )

    .heatmap_wrapper_inputs_ui(id, extras, frame, .sd_heat_defaults(frame, d, defaults), title, columns)
}


#' Output UI components for the sampleDistanceHeatmap module
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
#'     sampleDistanceHeatmapOutputUI("dist")
#' }
#' @export
#' @author Jared Andrews
sampleDistanceHeatmapOutputUI <- function(id, resizable = TRUE, ...) {
    .heatmap_wrapper_output_ui(id, resizable = resizable, ...)
}
