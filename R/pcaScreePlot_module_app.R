#' Create a standalone Shiny app for the pcaScreePlot module
#'
#' Generates a Shiny application with an object selector over the supplied
#' PCAtools `pca` objects, a read-only preview of the selected object's sample
#' metadata, and the scree plot with its settings.
#'
#' @param pca_list An optional named list of PCAtools `pca` objects. If `NULL`
#'   (the default), the bundled [example_pca] is used.
#' @return A Shiny app object.
#'
#' @seealso [sciVizModules::pcaScreePlotInputsUI()], [sciVizModules::pcaScreePlotOutputUI()],
#' [sciVizModules::pcaScreePlotServer()], [sciVizModules::example_pca]
#'
#' @export
#' @author Jared Andrews
#' @examples
#' library(sciVizModules)
#' app <- pcaScreePlotApp()
#' if (interactive()) shiny::runApp(app)
pcaScreePlotApp <- function(pca_list = NULL) {
    if (is.null(pca_list)) {
        pca_list <- list("example_pca" = .sci_example_data("example_pca"))
    }
    .pca_module_app(
        inputs_ui_fn = pcaScreePlotInputsUI,
        output_ui_fn = pcaScreePlotOutputUI,
        server_fn    = pcaScreePlotServer,
        pca_list     = pca_list,
        title        = "Modular PCA Scree Plot"
    )
}
