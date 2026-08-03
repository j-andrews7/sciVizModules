#' Input UI components for the dose-response module
#'
#' Thin wrapper over [VizModules::dittoViz_scatterPlotInputsUI()] that applies
#' dose-response defaults (dose on a log10 x-axis, response on the y-axis, and
#' a **drc** log-logistic model enabled as the fitted curve). Tabs and inputs
#' that are irrelevant to a single dose-response curve are hidden by
#' [doseResponseServer()].
#'
#' @param id The ID for the Shiny module.
#' @param data The dose-response data frame used to populate the input choices.
#' @param defaults A named list of default values, merged over the module's
#'   dose-response defaults (user values win).
#' @param title An optional title for the UI grid.
#' @param columns Number of columns for the UI grid.
#' @return A Shiny tagList containing the UI elements.
#'
#' @importFrom VizModules dittoViz_scatterPlotInputsUI
#'
#' @examples
#' library(sciVizModules)
#' doseResponseInputsUI("dose", dose_response)
#' @export
#' @author Jacob Martin
#' @seealso [sciVizModules::doseResponseServer()],
#' [sciVizModules::doseResponseOutputUI()], [sciVizModules::doseResponseApp()]
doseResponseInputsUI <- function(id, data, defaults = NULL, title = NULL, columns = 2) {
    stopifnot(is.data.frame(data))
    dittoViz_scatterPlotInputsUI(
        id, data,
        defaults = .dose_response_defaults(data, defaults),
        title = title, columns = columns
    )
}

#' Output UI components for the dose-response module
#'
#' Thin wrapper over [VizModules::dittoViz_scatterPlotOutputUI()].
#'
#' @param id The ID for the Shiny module.
#' @param resizable Logical; when `TRUE` (the default) the plot output is
#'   resizable.
#' @return A Shiny plot output for the dose-response curve.
#'
#' @importFrom VizModules dittoViz_scatterPlotOutputUI
#'
#' @examples
#' doseResponseOutputUI("dose")
#' @export
#' @author Jacob Martin
doseResponseOutputUI <- function(id, resizable = TRUE) {
    dittoViz_scatterPlotOutputUI(id, resizable = resizable)
}
