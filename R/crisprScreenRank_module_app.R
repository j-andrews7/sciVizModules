#' Create a standalone Shiny app for the crisprScreenRank module
#'
#' Generates a Shiny application with modular CRISPR screen rank plot
#' components, built with [VizModules::createModuleApp()]: data import, a
#' filterable data table, and the plot with its settings.
#'
#' When `data_list` is not provided (or `NULL`), the app launches with the
#' bundled simulated MAGeCK gene summaries, one from `mageck test` (RRA) and
#' one from `mageck mle`, read with [read_mageck()].
#'
#' @param data_list An optional named list of MAGeCK RRA or MLE gene summaries
#'   (data frames from [read_mageck()]).
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
crisprScreenRankApp <- function(data_list = NULL) {
    if (is.null(data_list)) {
        data_list <- list("example_mageck" = .crispr_example("rra"), "example_mageck_mle" = .crispr_example("mle"))
    }
    stopifnot(is.list(data_list), length(data_list) >= 1)
    lapply(data_list, function(data) stopifnot(is.data.frame(data)))

    createModuleApp(
        inputs_ui_fn = crisprScreenRankInputsUI,
        output_ui_fn = crisprScreenRankOutputUI,
        server_fn    = crisprScreenRankServer,
        data_list    = data_list,
        title        = "Modular CRISPR Screen Rank Plot"
    )
}
