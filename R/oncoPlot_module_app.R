#' Create a standalone Shiny app for the oncoPlot module
#'
#' This function generates a Shiny application with modular oncoprint
#' (mutation-landscape) components. The app features a **Data Import** section
#' for uploading data files, a **Data Table** for filtering the active dataset,
#' and a **Plot** area for configuring and displaying an interactive oncoprint
#' built on [ComplexHeatmap::oncoPrint()] and made interactive with
#' [InteractiveComplexHeatmap::makeInteractiveComplexHeatmap()].
#'
#' When `data_list` is not provided (or `NULL`), the app launches with the
#' bundled `example_mutations` dataset. Uploaded files are added to the
#' available datasets and can be selected for plotting. If an uploaded file
#' shares a name with an existing dataset, the existing one is overwritten with
#' a warning.
#'
#' This is a convenience wrapper around [VizModules::createModuleApp()].
#'
#' @note Rendering the plot requires the **ComplexHeatmap** and
#'   **InteractiveComplexHeatmap** packages to be installed.
#'
#' @param data_list An optional named list of tidy (long) mutation data frames.
#'   If `NULL` (the default), `list("example_mutations" = example_mutations)` is
#'   used as example data. Each data frame should contain a sample column, a
#'   gene column, and an alteration-type column.
#' @return A Shiny app object.
#'
#' @importFrom VizModules createModuleApp
#'
#' @seealso [sciVizModules::oncoPlotInputsUI()], [sciVizModules::oncoPlotOutputUI()],
#' [sciVizModules::oncoPlotServer()], [sciVizModules::example_mutations]
#'
#' @export
#' @author Jacob Martin, Jared Andrews
#' @examples
#' library(sciVizModules)
#' # Launch with default example data:
#' app <- oncoPlotApp()
#' if (interactive()) shiny::runApp(app)
#'
#' # Launch with custom data:
#' data(example_mutations)
#' app2 <- oncoPlotApp(list("mutations" = example_mutations))
#' if (interactive()) shiny::runApp(app2)
oncoPlotApp <- function(data_list = NULL) {
    if (is.null(data_list)) {
        data_list <- list("example_mutations" = example_mutations)
    }

    stopifnot(is.list(data_list), length(data_list) >= 1)
    lapply(data_list, function(data) {
        stopifnot(is.data.frame(data))
    })

    createModuleApp(
        inputs_ui_fn = oncoPlotInputsUI,
        output_ui_fn = oncoPlotOutputUI,
        server_fn    = oncoPlotServer,
        data_list    = data_list,
        title        = "Modular Oncoplot"
    )
}
