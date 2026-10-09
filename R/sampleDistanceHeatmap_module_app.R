#' Create a standalone Shiny app for the sampleDistanceHeatmap module
#'
#' Generates a Shiny application with a selector over the supplied experiments,
#' a read-only preview of the selected experiment's sample metadata, and the
#' interactive distance heatmap with its settings. Needs ComplexHeatmap,
#' InteractiveComplexHeatmap and circlize.
#'
#' When `object_list` is not provided (or `NULL`), the app launches with the
#' airway RNA-seq counts from the airway package (needs airway).
#'
#' @param object_list An optional named list of `SummarizedExperiment` objects.
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
sampleDistanceHeatmapApp <- function(object_list = NULL) {
    .assert_heatmap_packages()
    if (is.null(object_list)) {
        object_list <- list("airway" = .se_example())
    }
    .se_module_app(sampleDistanceHeatmapInputsUI, sampleDistanceHeatmapOutputUI, sampleDistanceHeatmapServer,
        object_list, "Sample Distance Heatmap")
}
