#' Create a standalone Shiny app for the plateHeatmap module
#'
#' Generates a Shiny application with modular plate heatmap components, built
#' with [VizModules::createModuleApp()]: data import, a filterable data table,
#' and the plot with its settings.
#'
#' With the example data, the app opens on the settings the module gallery
#' ([sciModuleGalleryApp()]) opens this module on.
#'
#' @param data_list An optional named list of plate data frames (one row per
#'   well). If `NULL` (the default), the simulated [example_plate] screen is used.
#' @inheritParams volcanoPlotApp
#' @return A Shiny app object.
#'
#' @seealso [plateHeatmap()], [sciVizModules::plateHeatmapInputsUI()],
#' [sciVizModules::plateHeatmapOutputUI()], [sciVizModules::plateHeatmapServer()]
#'
#' @export
#' @author Jared Andrews
#' @examples
#' library(sciVizModules)
#' app <- plateHeatmapApp()
#' if (interactive()) shiny::runApp(app)
plateHeatmapApp <- function(data_list = NULL, defaults = NULL, hide.inputs = NULL, hide.tabs = NULL) {
    if (is.null(data_list)) {
        example <- .sci_module_example("plate", defaults)
        data_list <- example$data_list
        defaults <- example$defaults
    }
    stopifnot(is.list(data_list), length(data_list) >= 1)
    lapply(data_list, function(data) stopifnot(is.data.frame(data)))

    createModuleApp(
        inputs_ui_fn = plateHeatmapInputsUI,
        output_ui_fn = plateHeatmapOutputUI,
        server_fn    = plateHeatmapServer,
        data_list    = data_list,
        defaults     = defaults,
        hide.inputs  = hide.inputs,
        hide.tabs    = hide.tabs,
        title        = "Modular Plate Heatmap"
    )
}
