#' Create a standalone Shiny app for the dittoHeatmap module
#'
#' Generates a Shiny application with a selector over the provided objects, a
#' read-only **Metadata Preview**, and the interactive heatmap with its
#' settings. Needs ComplexHeatmap, InteractiveComplexHeatmap and circlize.
#'
#' When `object_list` is not provided (or `NULL`), the app launches with the
#' bundled `example_sce` dataset.
#'
#' With the example data, the app opens on the settings the module gallery
#' ([sciModuleGalleryApp()]) opens this module on.
#'
#' @param object_list An optional named list of `SingleCellExperiment`, `Seurat`,
#'   or `SummarizedExperiment` objects. If `NULL` (the default),
#'   `list("example_sce" = example_sce)` is used as example data.
#' @inheritParams volcanoPlotApp
#' @return A Shiny app object.
#'
#' @seealso [sciVizModules::dittoHeatmapInputsUI()], [sciVizModules::dittoHeatmapOutputUI()],
#' [sciVizModules::dittoHeatmapServer()], [sciVizModules::example_sce]
#'
#' @export
#' @author Jared Andrews
#' @examples
#' library(sciVizModules)
#' if (requireNamespace("InteractiveComplexHeatmap", quietly = TRUE) &&
#'     requireNamespace("circlize", quietly = TRUE)) {
#'     app <- dittoHeatmapApp()
#'     if (interactive()) shiny::runApp(app)
#' }
dittoHeatmapApp <- function(object_list = NULL, defaults = NULL, hide.inputs = NULL, hide.tabs = NULL) {
    .assert_heatmap_packages()
    if (is.null(object_list)) {
        example <- .sci_module_example("dittoheatmap", defaults)
        object_list <- example$data_list
        defaults <- example$defaults
    }
    .ditto_module_app(
        inputs_ui_fn = dittoHeatmapInputsUI,
        output_ui_fn = dittoHeatmapOutputUI,
        server_fn    = dittoHeatmapServer,
        object_list  = object_list,
        defaults     = defaults,
        hide.inputs  = hide.inputs,
        hide.tabs    = hide.tabs,
        title        = "Modular dittoHeatmap"
    )
}
