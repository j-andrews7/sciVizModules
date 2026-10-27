#' Create a standalone Shiny app for the survivalCurve module
#'
#' This function generates a Shiny application with modular survival curve
#' components. The app features a **Data Import** section for uploading data
#' files, a **Data Table** for filtering the active dataset, and a **Plot** area
#' for configuring and displaying an interactive Kaplan-Meier survival curve.
#'
#' When `data_list` is not provided (or `NULL`), the app launches with
#' `survival_lung` as an example dataset, on the settings the module gallery
#' ([sciModuleGalleryApp()]) opens this module on: curves grouped by `sex`, with
#' median survival marked and a risk table. Uploaded files are added to the
#' available datasets and can be selected for plotting.
#'
#' This is a convenience wrapper around [VizModules::createModuleApp()].
#'
#' @param data_list An optional named list of data frames. If `NULL` (the default),
#'   `list("survival_lung" = survival_lung)` is used as example data. Each data frame
#'   must contain a numeric follow-up time column and an event/status column.
#' @inheritParams volcanoPlotApp
#' @return A Shiny app object.
#'
#' @importFrom VizModules createModuleApp
#'
#' @seealso [sciVizModules::survivalCurveInputsUI()], [sciVizModules::survivalCurveOutputUI()],
#' [sciVizModules::survivalCurveServer()], [sciVizModules::survival_lung]
#'
#' @export
#' @author Jacob Martin
#' @examples
#' library(sciVizModules)
#' # Launch with default example data:
#' app <- survivalCurveApp()
#' if (interactive()) shiny::runApp(app)
#'
#' # Launch with custom data:
#' data(survival_lung)
#' app2 <- survivalCurveApp(list("lung" = survival_lung))
#' if (interactive()) shiny::runApp(app2)
survivalCurveApp <- function(data_list = NULL, defaults = NULL, hide.inputs = NULL, hide.tabs = NULL) {
    if (is.null(data_list)) {
        example <- .sci_module_example("survival", defaults)
        data_list <- example$data_list
        defaults <- example$defaults
    }

    stopifnot(is.list(data_list), length(data_list) >= 1)
    lapply(data_list, function(data) {
        stopifnot(is.data.frame(data))
    })

    createModuleApp(
        inputs_ui_fn = survivalCurveInputsUI,
        output_ui_fn = survivalCurveOutputUI,
        server_fn    = survivalCurveServer,
        data_list    = data_list,
        defaults     = defaults,
        hide.inputs  = hide.inputs,
        hide.tabs    = hide.tabs,
        title        = "Modular Survival Curve"
    )
}
