#' Create a standalone Shiny app for the dittoHeatmap module
#'
#' Generates a Shiny application with a selector over the provided objects, a
#' read-only **Metadata Preview**, and the interactive heatmap with its
#' settings. Needs ComplexHeatmap, InteractiveComplexHeatmap and circlize.
#'
#' When `object_list` is not provided (or `NULL`), the app launches with the
#' bundled `example_sce` dataset.
#'
#' @param object_list An optional named list of `SingleCellExperiment`, `Seurat`,
#'   or `SummarizedExperiment` objects. If `NULL` (the default),
#'   `list("example_sce" = example_sce)` is used as example data.
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
dittoHeatmapApp <- function(object_list = NULL) {
    .assert_heatmap_packages()
    if (is.null(object_list)) {
        object_list <- list("example_sce" = .sci_example_data("example_sce"))
    }
    .ditto_module_app(
        inputs_ui_fn = dittoHeatmapInputsUI,
        output_ui_fn = dittoHeatmapOutputUI,
        server_fn    = dittoHeatmapServer,
        object_list  = object_list,
        title        = "Modular dittoHeatmap"
    )
}
