#' Server logic for the pcaScreePlot module
#'
#' Renders [pcaScreePlot()] for a PCAtools `pca` object. The variance table is
#' included in the source-data download as the statistics table.
#'
#' @param id The ID for the Shiny module.
#' @param data A `reactive` returning a PCAtools `pca` object.
#' @param hide.inputs A character vector of input IDs to hide.
#' @param hide.tabs A character vector of tab names to hide.
#' @param defaults A named list of default values used when resetting the inputs.
#'   Typically the same list passed to [pcaScreePlotInputsUI()].
#' @return A `reactive` returning the source-data list.
#'
#' @import shiny
#' @importFrom shinyWidgets updateMaterialSwitch
#' @importFrom colourpicker updateColourInput
#'
#' @seealso [pcaScreePlot()], [sciVizModules::pcaScreePlotInputsUI()],
#' [sciVizModules::pcaScreePlotOutputUI()], [sciVizModules::pcaScreePlotApp()]
#' @examples
#' library(sciVizModules)
#' if (interactive()) pcaScreePlotApp()
#' @export
#' @author Jared Andrews
pcaScreePlotServer <- function(id, data, hide.inputs = NULL, hide.tabs = NULL, defaults = NULL) {
    .sci_plot_server(
        id, data, hide.inputs, hide.tabs, defaults,
        name = "pcaScreePlot",
        validate = .assert_pca,
        # "Mark Components" is free text; debounce it so typing "PC12" does not
        # redraw at "P", "PC" and "PC1".
        setup = function(input, output, session, pca_data, params) {
            list(marks = .sci_debounced_input(input, "mark.components", params))
        },
        build = function(p, input, isolate_fn, state) {
            pcaScreePlot(
                p,
                components = isolate_fn(input$components),
                show.cumulative = isTRUE(isolate_fn(input$show.cumulative)),
                show.elbow = isTRUE(isolate_fn(input$show.elbow)),
                mark.components = .pca_parse_components(isolate_fn(state$marks()), length(.pca_components(p))),
                bar.color = isolate_fn(input$bar.color) %||% "#1E90FF",
                line.color = isolate_fn(input$line.color) %||% "#CD2626"
            )
        },
        reset = function(session, p, defaults, state) {
            update_viz_select(session, "components",
                selected = get_default(defaults, "components", utils::head(.pca_components(p), 10)))
            updateMaterialSwitch(session, "show.cumulative", value = get_default(defaults, "show.cumulative", TRUE))
            updateMaterialSwitch(session, "show.elbow", value = get_default(defaults, "show.elbow", TRUE))
            updateTextInput(session, "mark.components", value = get_default(defaults, "mark.components", ""))
            updateColourInput(session, "bar.color", value = get_default(defaults, "bar.color", "#1E90FF"))
            updateColourInput(session, "line.color", value = get_default(defaults, "line.color", "#CD2626"))
        }
    )
}
