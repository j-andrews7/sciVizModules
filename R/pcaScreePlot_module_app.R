#' Create a standalone Shiny app for the pcaScreePlot module
#'
#' Generates a Shiny application with an object selector over the supplied
#' PCAtools `pca` objects, a read-only preview of the selected object's sample
#' metadata, and the scree plot with its settings.
#'
#' With the example data, the app opens on the settings the module gallery
#' ([sciModuleGalleryApp()]) opens this module on.
#'
#' @param pca_list An optional named list of PCAtools `pca` objects. If `NULL`
#'   (the default), the bundled [example_pca] is used.
#' @inheritParams volcanoPlotApp
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
pcaScreePlotApp <- function(pca_list = NULL, defaults = NULL, hide.inputs = NULL, hide.tabs = NULL) {
    if (is.null(pca_list)) {
        example <- .sci_module_example("pcascree", defaults)
        pca_list <- example$data_list
        defaults <- example$defaults
    }
    .pca_module_app(
        inputs_ui_fn = pcaScreePlotInputsUI,
        output_ui_fn = pcaScreePlotOutputUI,
        server_fn    = pcaScreePlotServer,
        pca_list     = pca_list,
        defaults     = defaults,
        hide.inputs  = hide.inputs,
        hide.tabs    = hide.tabs,
        title        = "Modular PCA Scree Plot"
    )
}
