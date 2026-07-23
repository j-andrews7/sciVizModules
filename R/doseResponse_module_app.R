#' Create a standalone Shiny app for the dose-response module
#'
#' Convenience wrapper around [VizModules::createModuleApp()] that launches the
#' dose-response module: a scatter plot of response versus dose (log10 x-axis)
#' with a \pkg{drc} log-logistic model fitted as the curve. Irrelevant scatter
#' plot tabs and inputs are hidden.
#'
#' When `data_list` is not provided, the app launches with the bundled
#' [dose_response] example data.
#'
#' @param data_list An optional named list of dose-response data frames. If
#'   `NULL` (the default), `list("dose_response" = dose_response)` is used.
#' @param defaults A named list of default values, merged over the module's
#'   dose-response defaults (user values win).
#' @return A Shiny app object.
#'
#' @importFrom VizModules createModuleApp
#'
#' @seealso [sciVizModules::doseResponseInputsUI()],
#' [sciVizModules::doseResponseOutputUI()], [sciVizModules::doseResponseServer()],
#' [sciVizModules::dose_response]
#'
#' @export
#' @author Jacob Martin
#' @examples
#' library(sciVizModules)
#' # Launch with the bundled example dose-response data:
#' app <- doseResponseApp()
#' if (interactive()) shiny::runApp(app)
doseResponseApp <- function(data_list = NULL, defaults = NULL) {
    if (is.null(data_list)) {
        data_list <- list("dose_response" = dose_response)
    }

    stopifnot(is.list(data_list), length(data_list) >= 1)
    lapply(data_list, function(data) {
        stopifnot(is.data.frame(data))
    })

    createModuleApp(
        inputs_ui_fn = doseResponseInputsUI,
        output_ui_fn = doseResponseOutputUI,
        server_fn    = doseResponseServer,
        data_list    = data_list,
        defaults     = defaults,
        title        = "Modular Dose-Response Curves"
    )
}
