#' Create a standalone Shiny app for the gwasQQPlot module
#'
#' Generates a Shiny application with modular GWAS QQ plot components, built
#' with [VizModules::createModuleApp()]: data import, a filterable data table,
#' and the plot with its settings.
#'
#' With the example data, the app opens on the settings the module gallery
#' ([sciModuleGalleryApp()]) opens this module on.
#'
#' @param data_list An optional named list of data frames of GWAS summary
#'   statistics. If `NULL` (the default), the bundled [example_gwas] is used.
#' @inheritParams volcanoPlotApp
#' @return A Shiny app object.
#'
#' @seealso [sciVizModules::gwasQQPlotInputsUI()], [sciVizModules::gwasQQPlotOutputUI()],
#' [sciVizModules::gwasQQPlotServer()], [sciVizModules::example_gwas]
#'
#' @export
#' @author Jared Andrews
#' @examples
#' library(sciVizModules)
#' app <- gwasQQPlotApp()
#' if (interactive()) shiny::runApp(app)
gwasQQPlotApp <- function(data_list = NULL, defaults = NULL, hide.inputs = NULL, hide.tabs = NULL) {
    if (is.null(data_list)) {
        example <- .sci_module_example("gwasqq", defaults)
        data_list <- example$data_list
        defaults <- example$defaults
    }
    stopifnot(is.list(data_list), length(data_list) >= 1)
    lapply(data_list, function(data) stopifnot(is.data.frame(data)))

    createModuleApp(
        inputs_ui_fn = gwasQQPlotInputsUI,
        output_ui_fn = gwasQQPlotOutputUI,
        server_fn    = gwasQQPlotServer,
        data_list    = data_list,
        defaults     = defaults,
        hide.inputs  = hide.inputs,
        hide.tabs    = hide.tabs,
        title        = "Modular GWAS QQ Plot"
    )
}
