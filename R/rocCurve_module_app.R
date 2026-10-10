#' Create a standalone Shiny app for the rocCurve module
#'
#' Generates a Shiny application with modular ROC curve components, built with
#' [VizModules::createModuleApp()]: data import, a filterable data table, and
#' the plot with its settings.
#'
#' @param data_list An optional named list of data frames. If `NULL` (the
#'   default), the bundled [example_biomarkers] is used.
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
rocCurveApp <- function(data_list = NULL) {
    if (is.null(data_list)) {
        data_list <- list("example_biomarkers" = .sci_example_data("example_biomarkers"))
    }
    stopifnot(is.list(data_list), length(data_list) >= 1)
    lapply(data_list, function(data) stopifnot(is.data.frame(data)))

    createModuleApp(
        inputs_ui_fn = rocCurveInputsUI,
        output_ui_fn = rocCurveOutputUI,
        server_fn    = rocCurveServer,
        data_list    = data_list,
        title        = "Modular ROC Curve"
    )
}
