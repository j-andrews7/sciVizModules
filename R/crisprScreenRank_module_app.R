#' Create a standalone Shiny app for the crisprScreenRank module
#'
#' Generates a Shiny application with modular CRISPR screen rank plot
#' components, built with [VizModules::createModuleApp()]: data import, a
#' filterable data table, and the plot with its settings.
#'
#' When `data_list` is not provided (or `NULL`), the app launches with the
#' bundled simulated MAGeCK gene summaries, one from `mageck test` (RRA) and
#' one from `mageck mle`, read with [read_mageck()]. The RRA summary opens on
#' the settings the module gallery ([sciModuleGalleryApp()]) shows it with:
#' genes ranked by FDR, with the strongest hits labelled.
#'
#' @param data_list An optional named list of MAGeCK RRA or MLE gene summaries
#'   (data frames from [read_mageck()]).
#' @inheritParams volcanoPlotApp
#' @return A Shiny app object.
#'
#' @seealso [read_mageck()], [sciVizModules::crisprScreenRankInputsUI()],
#' [sciVizModules::crisprScreenRankOutputUI()], [sciVizModules::crisprScreenRankServer()]
#'
#' @export
#' @author Jared Andrews
#' @examples
#' library(sciVizModules)
#' app <- crisprScreenRankApp()
#' if (interactive()) shiny::runApp(app)
crisprScreenRankApp <- function(data_list = NULL, defaults = NULL, hide.inputs = NULL, hide.tabs = NULL) {
    if (is.null(data_list)) {
        example <- .sci_module_example("crispr", defaults)
        data_list <- example$data_list
        defaults <- example$defaults
    }
    stopifnot(is.list(data_list), length(data_list) >= 1)
    lapply(data_list, function(data) stopifnot(is.data.frame(data)))

    createModuleApp(
        inputs_ui_fn = crisprScreenRankInputsUI,
        output_ui_fn = crisprScreenRankOutputUI,
        server_fn    = crisprScreenRankServer,
        data_list    = data_list,
        defaults     = defaults,
        hide.inputs  = hide.inputs,
        hide.tabs    = hide.tabs,
        title        = "Modular CRISPR Screen Rank Plot"
    )
}
