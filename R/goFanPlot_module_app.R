#' Create a standalone Shiny app for the goFanPlot module
#'
#' This function generates a Shiny application with modular GO enrichment
#' sunburst ("fan") plot components. The app features a **Data Import** section
#' for uploading data files, a **Data Table** for filtering the active dataset,
#' and a **Plot** area for configuring and displaying an interactive sunburst
#' plot built on [GOfan::sunburstGO()].
#'
#' When `data_list` is not provided (or `NULL`), the app launches with the
#' bundled `example_enrichment` dataset, on the settings the module gallery
#' ([sciModuleGalleryApp()]) opens this module on. Uploaded files are added to
#' the available datasets and can be selected for plotting. If an uploaded file
#' shares a name with an existing dataset, the existing one is overwritten with
#' a warning.
#'
#' This is a convenience wrapper around [VizModules::createModuleApp()].
#'
#' @note Rendering the plot requires the **GOfan** package and the relevant
#'   organism annotation (`OrgDb`) package (e.g. `org.Hs.eg.db`) to be installed.
#'
#' @param data_list An optional named list of enrichment results data frames. If
#'   `NULL` (the default), `list("example_enrichment" = example_enrichment)` is
#'   used as example data. Each data frame should contain a column of GO
#'   identifiers and a numeric column (e.g. `qvalue`) to colour by.
#' @inheritParams volcanoPlotApp
#' @return A Shiny app object.
#'
#' @importFrom VizModules createModuleApp
#'
#' @seealso [sciVizModules::goFanPlotInputsUI()], [sciVizModules::goFanPlotOutputUI()],
#' [sciVizModules::goFanPlotServer()], [sciVizModules::example_enrichment]
#'
#' @export
#' @author Jacob Martin, Jared Andrews
#' @examples
#' library(sciVizModules)
#' # Launch with default example data:
#' app <- goFanPlotApp()
#' if (interactive()) shiny::runApp(app)
#'
#' # Launch with custom data:
#' data(example_enrichment)
#' app2 <- goFanPlotApp(list("enrichment" = example_enrichment))
#' if (interactive()) shiny::runApp(app2)
goFanPlotApp <- function(data_list = NULL, defaults = NULL, hide.inputs = NULL, hide.tabs = NULL) {
    if (is.null(data_list)) {
        example <- .sci_module_example("gofan", defaults)
        data_list <- example$data_list
        defaults <- example$defaults
    }

    stopifnot(is.list(data_list), length(data_list) >= 1)
    lapply(data_list, function(data) {
        stopifnot(is.data.frame(data))
    })

    createModuleApp(
        inputs_ui_fn = goFanPlotInputsUI,
        output_ui_fn = goFanPlotOutputUI,
        server_fn    = goFanPlotServer,
        data_list    = data_list,
        defaults     = defaults,
        hide.inputs  = hide.inputs,
        hide.tabs    = hide.tabs,
        title        = "Modular GO Sunburst Plot"
    )
}
