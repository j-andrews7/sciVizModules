#' Create a standalone Shiny app for the rocCurve module
#'
#' Generates a Shiny application with modular ROC curve components, built with
#' [VizModules::createModuleApp()]: data import, a filterable data table, and
#' the plot with its settings.
#'
#' With the example data, the app opens on the settings the module gallery
#' ([sciModuleGalleryApp()]) opens this module on.
#'
#' @param data_list An optional named list of data frames. If `NULL` (the
#'   default), the bundled [example_biomarkers] is used.
#' @inheritParams volcanoPlotApp
#' @return A Shiny app object.
#'
#' @seealso [rocCurve()], [sciVizModules::rocCurveInputsUI()], [sciVizModules::rocCurveOutputUI()],
#' [sciVizModules::rocCurveServer()], [sciVizModules::example_biomarkers]
#'
#' @export
#' @author Jared Andrews
#' @examples
#' library(sciVizModules)
#' app <- rocCurveApp()
#' if (interactive()) shiny::runApp(app)
rocCurveApp <- function(data_list = NULL, defaults = NULL, hide.inputs = NULL, hide.tabs = NULL) {
    if (is.null(data_list)) {
        example <- .sci_module_example("roc", defaults)
        data_list <- example$data_list
        defaults <- example$defaults
    }
    stopifnot(is.list(data_list), length(data_list) >= 1)
    lapply(data_list, function(data) stopifnot(is.data.frame(data)))

    createModuleApp(
        inputs_ui_fn = rocCurveInputsUI,
        output_ui_fn = rocCurveOutputUI,
        server_fn    = rocCurveServer,
        data_list    = data_list,
        defaults     = defaults,
        hide.inputs  = hide.inputs,
        hide.tabs    = hide.tabs,
        title        = "Modular ROC Curve"
    )
}
