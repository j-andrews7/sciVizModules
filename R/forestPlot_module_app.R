#' Create a standalone Shiny app for the forestPlot module
#'
#' Generates a Shiny application with modular forest plot components, built with
#' [VizModules::createModuleApp()]: data import, a filterable data table, and the
#' plot with its settings.
#'
#' When `data_list` is not provided (or `NULL`), the app launches with the
#' bundled `survival_lung` dataset.
#'
#' @param data_list An optional named list of data frames. If `NULL` (the default),
#'   `list("survival_lung" = survival_lung)` is used as example data.
#' @return A Shiny app object.
#'
#' @seealso [sciVizModules::forestPlotInputsUI()], [sciVizModules::forestPlotOutputUI()],
#' [sciVizModules::forestPlotServer()], [sciVizModules::forestPlot()],
#' [sciVizModules::survival_lung]
#'
#' @export
#' @author Jared Andrews
#' @examples
#' library(sciVizModules)
#' app <- forestPlotApp()
#' if (interactive()) shiny::runApp(app)
forestPlotApp <- function(data_list = NULL) {
    if (is.null(data_list)) {
        data_list <- list("survival_lung" = .sci_example_data("survival_lung"))
    }

    stopifnot(is.list(data_list), length(data_list) >= 1)
    lapply(data_list, function(data) {
        stopifnot(is.data.frame(data))
    })

    createModuleApp(
        inputs_ui_fn = forestPlotInputsUI,
        output_ui_fn = forestPlotOutputUI,
        server_fn    = forestPlotServer,
        data_list    = data_list,
        title        = "Modular Forest Plot"
    )
}
