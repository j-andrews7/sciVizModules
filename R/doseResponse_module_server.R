#' Server logic for the dose-response module
#'
#' Dose-response curve fitting built on the VizModules scatter plot module
#' ([VizModules::dittoViz_scatterPlotServer()]). The module registers a
#' **drc** `"drm"` model backend and delegates to the scatter plot server
#' with dose-response defaults (dose on a log10 x-axis, response on the y-axis,
#' and a `drc` log-logistic model drawn as the fitted curve). Tabs and inputs
#' that are not relevant to a single dose-response curve are hidden.
#'
#' @param id The ID for the Shiny module.
#' @param data A `reactive` returning the dose-response data frame.
#' @param hide.inputs Additional input IDs to hide, on top of the module's
#'   built-in dose-response hidden set.
#' @param hide.tabs Additional tab names to hide, on top of the module's
#'   built-in dose-response hidden set.
#' @param defaults A named list of default values. Merged over the module's
#'   dose-response defaults (user values win).
#' @return The value returned by [VizModules::dittoViz_scatterPlotServer()].
#'
#' @importFrom VizModules dittoViz_scatterPlotServer
#'
#' @seealso [sciVizModules::doseResponseInputsUI()],
#' [sciVizModules::doseResponseOutputUI()], [sciVizModules::doseResponseApp()]
#'
#'
#' @examples
#' library(sciVizModules)
#' if (interactive()) doseResponseApp()
#' @export
#' @author Jacob Martin
doseResponseServer <- function(id, data, hide.inputs = NULL, hide.tabs = NULL,
                               defaults = NULL) {
    stopifnot(is.reactive(data))

    # Tabs and inputs that are not relevant to a single dose-response curve.
    dose_response_hidden_tabs <- c(
        "Adjustments", "Facet", "Annotations", "Trajectory", "Extras"
    )
    dose_response_hidden_inputs <- c(
        "color.by", "shape.by", "split.by",
        "show.others", "split.show.all.others", "shape.panel"
    )

    dr_defaults <- .dose_response_defaults(
        tryCatch(shiny::isolate(data()), error = function(e) data()),
        defaults
    )

    dittoViz_scatterPlotServer(
        id,
        data = data,
        hide.inputs = union(dose_response_hidden_inputs, hide.inputs),
        hide.tabs = union(dose_response_hidden_tabs, hide.tabs),
        defaults = dr_defaults
    )
}
