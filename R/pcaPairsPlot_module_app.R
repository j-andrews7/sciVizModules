#' Create a standalone Shiny app for the pcaPairsPlot module
#'
#' Generates a Shiny application with an object selector over the supplied
#' PCAtools `pca` objects, a read-only preview of the selected object's sample
#' metadata, and the pairs plot with its settings.
#'
#' With the example data, the app opens on the settings the module gallery
#' ([sciModuleGalleryApp()]) opens this module on.
#'
#' @param pca_list An optional named list of PCAtools `pca` objects. If `NULL`
#'   (the default), the bundled [example_pca] is used.
#' @inheritParams volcanoPlotApp
#' @return A Shiny app object.
#'
#' @seealso [sciVizModules::pcaPairsPlotInputsUI()], [sciVizModules::pcaPairsPlotOutputUI()],
#' [sciVizModules::pcaPairsPlotServer()], [sciVizModules::example_pca]
#'
#' @export
#' @author Jared Andrews
#' @examples
#' library(sciVizModules)
#' app <- pcaPairsPlotApp()
#' if (interactive()) shiny::runApp(app)
pcaPairsPlotApp <- function(pca_list = NULL, defaults = NULL, hide.inputs = NULL, hide.tabs = NULL) {
    if (is.null(pca_list)) {
        example <- .sci_module_example("pcapairs", defaults)
        pca_list <- example$data_list
        defaults <- example$defaults
    }
    .pca_module_app(
        inputs_ui_fn = pcaPairsPlotInputsUI,
        output_ui_fn = pcaPairsPlotOutputUI,
        server_fn    = pcaPairsPlotServer,
        pca_list     = pca_list,
        defaults     = defaults,
        hide.inputs  = hide.inputs,
        hide.tabs    = hide.tabs,
        title        = "Modular PCA Pairs Plot"
    )
}
