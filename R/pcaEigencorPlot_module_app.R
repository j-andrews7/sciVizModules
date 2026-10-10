#' Create a standalone Shiny app for the pcaEigencorPlot module
#'
#' Generates a Shiny application with an object selector over the supplied
#' PCAtools `pca` objects, a read-only preview of the selected object's sample
#' metadata, and the PC-metadata correlation heatmap with its settings.
#'
#' @param pca_list An optional named list of PCAtools `pca` objects. If `NULL`
#'   (the default), the bundled [example_pca] is used.
#' @return A Shiny app object.
#'
#' @seealso [sciVizModules::pcaEigencorPlotInputsUI()], [sciVizModules::pcaEigencorPlotOutputUI()],
#' [sciVizModules::pcaEigencorPlotServer()], [sciVizModules::example_pca]
#'
#' @export
#' @author Jared Andrews
#' @examples
#' library(sciVizModules)
#' app <- pcaEigencorPlotApp()
#' if (interactive()) shiny::runApp(app)
pcaEigencorPlotApp <- function(pca_list = NULL) {
    if (is.null(pca_list)) {
        pca_list <- list("example_pca" = .sci_example_data("example_pca"))
    }
    .pca_module_app(
        inputs_ui_fn = pcaEigencorPlotInputsUI,
        output_ui_fn = pcaEigencorPlotOutputUI,
        server_fn    = pcaEigencorPlotServer,
        pca_list     = pca_list,
        title        = "Modular PCA-Metadata Correlation"
    )
}
