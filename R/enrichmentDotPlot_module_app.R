#' Create a standalone Shiny app for the enrichmentDotPlot module
#'
#' This function generates a Shiny application with modular enrichment dot-plot
#' components. The app features a **Data Import** section for uploading data
#' files, a **Data Table** for filtering the active dataset, and a **Plot** area
#' for configuring and displaying an interactive enrichment dot plot built on
#' [plotthis::DotPlot()].
#'
#' When `data_list` is not provided (or `NULL`), the app launches with the
#' bundled `example_enrichment` dataset. Uploaded files are added to the
#' available datasets and can be selected for plotting. If an uploaded file
#' shares a name with an existing dataset, the existing one is overwritten with
#' a warning.
#'
#' This is a convenience wrapper around [VizModules::createModuleApp()].
#'
#' @param data_list An optional named list of enrichment results data frames. If
#'   `NULL` (the default), `list("example_enrichment" = example_enrichment)` is
#'   used as example data. Each data frame should contain enrichment terms and,
#'   ideally, `GeneRatio` and p-value columns.
#' @return A Shiny app object.
#'
#' @importFrom VizModules createModuleApp
#'
#' @seealso [sciVizModules::enrichmentDotPlotInputsUI()], [sciVizModules::enrichmentDotPlotOutputUI()],
#' [sciVizModules::enrichmentDotPlotServer()], [sciVizModules::example_enrichment]
#'
#' @export
#' @author Jacob Martin, Jared Andrews
#' @examples
#' library(sciVizModules)
#' # Launch with default example data:
#' app <- enrichmentDotPlotApp()
#' if (interactive()) shiny::runApp(app)
#'
#' # Launch with custom data:
#' data(example_enrichment)
#' app2 <- enrichmentDotPlotApp(list("enrichment" = example_enrichment))
#' if (interactive()) shiny::runApp(app2)
enrichmentDotPlotApp <- function(data_list = NULL) {
    if (is.null(data_list)) {
        data_list <- list("example_enrichment" = example_enrichment)
    }

    stopifnot(is.list(data_list), length(data_list) >= 1)
    lapply(data_list, function(data) {
        stopifnot(is.data.frame(data))
    })

    createModuleApp(
        inputs_ui_fn = enrichmentDotPlotInputsUI,
        output_ui_fn = enrichmentDotPlotOutputUI,
        server_fn    = enrichmentDotPlotServer,
        data_list    = data_list,
        title        = "Modular Enrichment DotPlot"
    )
}
