#' Server logic for the pcaLoadingsPlot module
#'
#' Renders [pcaLoadingsPlot()] for a PCAtools `pca` object. The retained
#' loadings are included in the source-data download as the statistics table.
#'
#' @param id The ID for the Shiny module.
#' @param data A `reactive` returning a PCAtools `pca` object.
#' @param hide.inputs A character vector of input IDs to hide.
#' @param hide.tabs A character vector of tab names to hide.
#' @param defaults A named list of default values used when resetting the inputs.
#'   Typically the same list passed to [pcaLoadingsPlotInputsUI()].
#' @return A `reactive` returning the source-data list.
#'
#' @import shiny
#' @importFrom shinyWidgets updateMaterialSwitch
#' @importFrom colourpicker updateColourInput
#'
#' @seealso [pcaLoadingsPlot()], [sciVizModules::pcaLoadingsPlotInputsUI()],
#' [sciVizModules::pcaLoadingsPlotOutputUI()], [sciVizModules::pcaLoadingsPlotApp()]
#' @examples
#' library(sciVizModules)
#' if (interactive()) pcaLoadingsPlotApp()
#' @export
#' @author Jared Andrews
pcaLoadingsPlotServer <- function(id, data, hide.inputs = NULL, hide.tabs = NULL, defaults = NULL) {
    .sci_plot_server(
        id, data, hide.inputs, hide.tabs, defaults,
        name = "pcaLoadingsPlot",
        validate = .assert_pca,
        build = function(p, input, isolate_fn, state) {
            pcaLoadingsPlot(
                p,
                components = isolate_fn(input$components),
                range.retain = isolate_fn(input$range.retain) %||% 0.05,
                absolute = isTRUE(isolate_fn(input$absolute)),
                low.color = isolate_fn(input$low.color) %||% "#FFD700",
                mid.color = isolate_fn(input$mid.color) %||% "#FFFFFF",
                high.color = isolate_fn(input$high.color) %||% "#4169E1",
                point.size = isolate_fn(input$point.size) %||% 12,
                show.labels = isTRUE(isolate_fn(input$show.labels)),
                label.size = isolate_fn(input$label.size) %||% 10
            )
        },
        reset = function(session, p, defaults, state) {
            update_viz_select(session, "components",
                selected = get_default(defaults, "components", utils::head(.pca_components(p), 5)))
            updateNumericInput(session, "range.retain", value = get_default(defaults, "range.retain", 0.05))
            updateMaterialSwitch(session, "absolute", value = get_default(defaults, "absolute", FALSE))
            updateColourInput(session, "low.color", value = get_default(defaults, "low.color", "#FFD700"))
            updateColourInput(session, "mid.color", value = get_default(defaults, "mid.color", "#FFFFFF"))
            updateColourInput(session, "high.color", value = get_default(defaults, "high.color", "#4169E1"))
            updateNumericInput(session, "point.size", value = get_default(defaults, "point.size", 12))
            updateMaterialSwitch(session, "show.labels", value = get_default(defaults, "show.labels", TRUE))
            updateNumericInput(session, "label.size", value = get_default(defaults, "label.size", 10))
        }
    )
}
