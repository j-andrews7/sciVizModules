#' Input UI components for the pcaScreePlot module
#'
#' This should be placed in the UI where the inputs should be shown, with an `id`
#' that matches the `id` used in the `pcaScreePlotServer()` and
#' `pcaScreePlotOutputUI()` functions.
#'
#' @details The module draws [pcaScreePlot()] for a PCAtools `pca` object: the
#' variance each component explains, the cumulative variance, and markers for
#' the elbow and any components you name. The inputs are organised into tabs via
#' [VizModules::organize_inputs()].
#'
#' @section Plot parameters and defaults:
#' The following parameters can be accessed via UI inputs and/or the `defaults` argument:
#'
#' - `components` - Components to show (default: the first 10; PCAtools `components`)
#' - `show.cumulative` - Draw the cumulative line (default: TRUE; PCAtools `drawCumulativeSumLine`)
#' - `show.elbow` - Mark the elbow (default: TRUE; needs PCAtools installed)
#' - `mark.components` - Further components to mark, e.g. `"4"` from
#'   [PCAtools::parallelPCA()] (default: none; PCAtools `vline`)
#' - `bar.color` - Bar colour (default: "#1E90FF"; PCAtools `colBar`)
#' - `line.color` - Cumulative line colour (default: "#CD2626"; PCAtools `colCumulativeSumLine`)
#'
#' The Legend, Axes, Lines and Plotly tabs carry the shared VizModules inputs.
#'
#' @param id The ID for the Shiny module.
#' @param data A PCAtools `pca` object.
#' @param defaults A named list of default values for the inputs.
#' @param title An optional title for the UI grid.
#' @param columns Number of columns for the UI grid.
#' @return A Shiny tagList containing the UI elements
#'
#' @import shiny
#' @importFrom shinyWidgets materialSwitch
#' @importFrom colourpicker colourInput
#'
#' @export
#' @author Jared Andrews
#' @seealso [pcaScreePlot()], [PCAtools::screeplot()], [sciVizModules::pcaScreePlotOutputUI()],
#' [sciVizModules::pcaScreePlotServer()], [sciVizModules::pcaScreePlotApp()]
#' @examples
#' library(sciVizModules)
#' data(example_pca)
#' pcaScreePlotInputsUI("scree", example_pca)
pcaScreePlotInputsUI <- function(id, data, defaults = NULL, title = "Scree Plot Settings", columns = 2) {
    ns <- NS(id)
    .assert_pca(data)
    comps <- .pca_components(data)

    data_tab <- tagList(
        .sci_tip(viz_select_input(ns("components"), "Components",
            choices = comps, selected = get_default(defaults, "components", utils::head(comps, 10)),
            multiple = TRUE
        ), "Components to show, in order."),
        .sci_tip(materialSwitch(ns("show.cumulative"), "Cumulative Line",
            value = get_default(defaults, "show.cumulative", TRUE, is.logical), status = "success"
        ), "Draw the cumulative percentage of variance explained."),
        .sci_tip(materialSwitch(ns("show.elbow"), "Mark Elbow",
            value = get_default(defaults, "show.elbow", TRUE, is.logical), status = "success"
        ), "Mark the elbow of the curve (PCAtools::findElbowPoint; needs PCAtools installed)."),
        .sci_tip(textInput(ns("mark.components"), "Mark Components",
            value = get_default(defaults, "mark.components", "")
        ), paste(
            "Further components to mark, by number or name (e.g. '4' or 'PC4, PC7'), such as",
            "the number retained by PCAtools::parallelPCA() on the original data."
        ))
    )
    aes_tab <- tagList(
        .sci_tip(colourInput(ns("bar.color"), "Bar Color", value = get_default(defaults, "bar.color", "#1E90FF")),
            "Colour of the explained-variance bars."),
        .sci_tip(colourInput(ns("line.color"), "Cumulative Line Color",
            value = get_default(defaults, "line.color", "#CD2626")), "Colour of the cumulative line.")
    )

    .sci_plot_inputs_ui(ns, "pcaScreePlot", data_tab, aes_tab, defaults, title, columns)
}


#' Output UI components for the pcaScreePlot module
#'
#' @param id The ID for the Shiny module.
#' @param resizable Logical; when `TRUE` (the default) the plot output can be resized by dragging.
#' @return A Shiny plotlyOutput for the scree plot.
#'
#' @examples
#' pcaScreePlotOutputUI("scree")
#' @export
#' @author Jared Andrews
pcaScreePlotOutputUI <- function(id, resizable = TRUE) {
    .sci_plot_output_ui(id, "pcaScreePlot", resizable = resizable)
}
