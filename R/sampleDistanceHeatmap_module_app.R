#' Create a standalone Shiny app for the sampleDistanceHeatmap module
#'
#' Generates a Shiny application with a selector over the supplied experiments,
#' a read-only preview of the selected experiment's sample metadata, and the
#' interactive distance heatmap with its settings. Needs ComplexHeatmap,
#' InteractiveComplexHeatmap and circlize.
#'
#' When `object_list` is not provided (or `NULL`), the app launches with the
#' airway RNA-seq counts from the airway package (needs airway), on the
#' settings the module gallery ([sciModuleGalleryApp()]) opens this module on.
#'
#' @param object_list An optional named list of `SummarizedExperiment` objects.
#' @inheritParams volcanoPlotApp
#' @return A Shiny app object.
#'
#' @seealso [sciVizModules::sampleDistanceHeatmapInputsUI()],
#' [sciVizModules::sampleDistanceHeatmapOutputUI()], [sciVizModules::sampleDistanceHeatmapServer()]
#'
#' @export
#' @author Jared Andrews
#' @examples
#' library(sciVizModules)
#' if (requireNamespace("InteractiveComplexHeatmap", quietly = TRUE) &&
#'     requireNamespace("circlize", quietly = TRUE) &&
#'     requireNamespace("airway", quietly = TRUE)) {
#'     app <- sampleDistanceHeatmapApp()
#'     if (interactive()) shiny::runApp(app)
#' }
sampleDistanceHeatmapApp <- function(object_list = NULL, defaults = NULL, hide.inputs = NULL, hide.tabs = NULL) {
    .assert_heatmap_packages()
    if (is.null(object_list)) {
        example <- .sci_module_example("sampledist", defaults)
        object_list <- example$data_list
        defaults <- example$defaults
    }
    .se_module_app(
        sampleDistanceHeatmapInputsUI, sampleDistanceHeatmapOutputUI, sampleDistanceHeatmapServer,
        object_list, "Sample Distance Heatmap",
        defaults = defaults, hide.inputs = hide.inputs, hide.tabs = hide.tabs
    )
}
