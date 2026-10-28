#' Create a standalone Shiny app for the pcaLoadingsPlot module
#'
#' Generates a Shiny application with an object selector over the supplied
#' PCAtools `pca` objects, a read-only preview of the selected object's sample
#' metadata, and the loadings plot with its settings.
#'
#' With the example data, the app opens on the settings the module gallery
#' ([sciModuleGalleryApp()]) opens this module on.
#'
#' @param pca_list An optional named list of PCAtools `pca` objects. If `NULL`
#'   (the default), the bundled [example_pca] is used.
#' @inheritParams volcanoPlotApp
#' @return A Shiny app object.
#'
#' @seealso [sciVizModules::pcaLoadingsPlotInputsUI()], [sciVizModules::pcaLoadingsPlotOutputUI()],
#' [sciVizModules::pcaLoadingsPlotServer()], [sciVizModules::example_pca]
#'
#' @export
#' @author Jared Andrews
#' @examples
#' library(sciVizModules)
#' app <- pcaLoadingsPlotApp()
#' if (interactive()) shiny::runApp(app)
pcaLoadingsPlotApp <- function(pca_list = NULL, defaults = NULL, hide.inputs = NULL, hide.tabs = NULL) {
    if (is.null(pca_list)) {
        example <- .sci_module_example("pcaloadings", defaults)
        pca_list <- example$data_list
        defaults <- example$defaults
    }
    .pca_module_app(
        inputs_ui_fn = pcaLoadingsPlotInputsUI,
        output_ui_fn = pcaLoadingsPlotOutputUI,
        server_fn    = pcaLoadingsPlotServer,
        pca_list     = pca_list,
        defaults     = defaults,
        hide.inputs  = hide.inputs,
        hide.tabs    = hide.tabs,
        title        = "Modular PCA Loadings Plot"
    )
}
