#' Create a standalone Shiny app for the manhattanPlot module
#'
#' Generates a Shiny application with modular Manhattan plot components, built
#' with [VizModules::createModuleApp()]: data import, a filterable data table,
#' and the plot with its settings.
#'
#' @param data_list An optional named list of data frames of GWAS summary
#'   statistics. If `NULL` (the default), the bundled [example_gwas] is used.
#' @return A Shiny app object.
#'
#' @seealso [sciVizModules::manhattanPlotInputsUI()], [sciVizModules::manhattanPlotOutputUI()],
#' [sciVizModules::manhattanPlotServer()], [sciVizModules::example_gwas]
#'
#' @export
#' @author Jared Andrews
#' @examples
#' library(sciVizModules)
#' app <- manhattanPlotApp()
#' if (interactive()) shiny::runApp(app)
manhattanPlotApp <- function(data_list = NULL) {
    if (is.null(data_list)) {
        data_list <- list("example_gwas" = .sci_example_data("example_gwas"))
    }
    stopifnot(is.list(data_list), length(data_list) >= 1)
    lapply(data_list, function(data) stopifnot(is.data.frame(data)))

    createModuleApp(
        inputs_ui_fn = manhattanPlotInputsUI,
        output_ui_fn = manhattanPlotOutputUI,
        server_fn    = manhattanPlotServer,
        data_list    = data_list,
        title        = "Modular Manhattan Plot"
    )
}
