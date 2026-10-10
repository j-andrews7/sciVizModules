#' Server logic for the pcaEigencorPlot module
#'
#' Renders [pcaEigencorPlot()] for a PCAtools `pca` object. The correlation
#' table (coefficients, p-values and adjusted p-values) is included in the
#' source-data download as the statistics table.
#'
#' @param id The ID for the Shiny module.
#' @param data A `reactive` returning a PCAtools `pca` object.
#' @param hide.inputs A character vector of input IDs to hide.
#' @param hide.tabs A character vector of tab names to hide.
#' @param defaults A named list of default values used when resetting the inputs.
#'   Typically the same list passed to [pcaEigencorPlotInputsUI()].
#' @return A `reactive` returning the source-data list.
#'
#' @import shiny
#' @importFrom shinyWidgets updateMaterialSwitch
#' @importFrom colourpicker updateColourInput
#'
#' @seealso [pcaEigencorPlot()], [sciVizModules::pcaEigencorPlotInputsUI()],
#' [sciVizModules::pcaEigencorPlotOutputUI()], [sciVizModules::pcaEigencorPlotApp()]
#' @examples
#' library(sciVizModules)
#' if (interactive()) pcaEigencorPlotApp()
#' @export
#' @author Jared Andrews
pcaEigencorPlotServer <- function(id, data, hide.inputs = NULL, hide.tabs = NULL, defaults = NULL) {
    .sci_plot_server(
        id, data, hide.inputs, hide.tabs, defaults,
        name = "pcaEigencorPlot",
        validate = .assert_pca,
        build = function(p, input, isolate_fn, state) {
            pcaEigencorPlot(
                p,
                components = isolate_fn(input$components),
                metavars = isolate_fn(input$metavars),
                cor.method = isolate_fn(input$cor.method) %||% "pearson",
                p.adjust.method = isolate_fn(input$p.adjust.method) %||% "none",
                plot.rsquared = isTRUE(isolate_fn(input$plot.rsquared)),
                low.color = isolate_fn(input$low.color) %||% "#00008B",
                mid.color = isolate_fn(input$mid.color) %||% "#FFFFFF",
                high.color = isolate_fn(input$high.color) %||% "#8B0000",
                show.values = isTRUE(isolate_fn(input$show.values)),
                digits = isolate_fn(input$digits) %||% 2
            )
        },
        reset = function(session, p, defaults, state) {
            metas <- names(as.data.frame(p$metadata %||% data.frame()))
            update_viz_select(session, "components",
                selected = get_default(defaults, "components", utils::head(.pca_components(p), 10)))
            update_viz_select(session, "metavars", selected = get_default(defaults, "metavars", metas))
            update_viz_select(session, "cor.method", selected = get_default(defaults, "cor.method", "pearson"))
            update_viz_select(session, "p.adjust.method", selected = get_default(defaults, "p.adjust.method", "none"))
            updateMaterialSwitch(session, "plot.rsquared", value = get_default(defaults, "plot.rsquared", FALSE))
            updateColourInput(session, "low.color", value = get_default(defaults, "low.color", "#00008B"))
            updateColourInput(session, "mid.color", value = get_default(defaults, "mid.color", "#FFFFFF"))
            updateColourInput(session, "high.color", value = get_default(defaults, "high.color", "#8B0000"))
            updateMaterialSwitch(session, "show.values", value = get_default(defaults, "show.values", TRUE))
            updateNumericInput(session, "digits", value = get_default(defaults, "digits", 2))
        }
    )
}
