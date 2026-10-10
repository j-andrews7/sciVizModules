#' Input UI components for the pcaLoadingsPlot module
#'
#' This should be placed in the UI where the inputs should be shown, with an `id`
#' that matches the `id` used in the `pcaLoadingsPlotServer()` and
#' `pcaLoadingsPlotOutputUI()` functions.
#'
#' @details The module draws [pcaLoadingsPlot()] for a PCAtools `pca` object:
#' the variables loading most strongly on each chosen component, and their
#' loadings across all of them. The inputs are organised into tabs via
#' [VizModules::organize_inputs()].
#'
#' @section Plot parameters and defaults:
#' The following parameters can be accessed via UI inputs and/or the `defaults` argument:
#'
#' - `components` - Components to show (default: the first 5; PCAtools `components`)
#' - `range.retain` - Fraction of each component's loading range, at either end,
#'   within which variables are kept (default: 0.05; PCAtools `rangeRetain`)
#' - `absolute` - Plot absolute loadings (default: FALSE; PCAtools `absolute`)
#' - `low.color`, `mid.color`, `high.color` - Colour scale (defaults: gold, white,
#'   royal blue; PCAtools `col`)
#' - `point.size` - Marker size (default: 12)
#' - `show.labels` - Label points with variable names (default: TRUE)
#' - `label.size` - Label font size (default: 10; PCAtools `labSize`)
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
#' @seealso [pcaLoadingsPlot()], [PCAtools::plotloadings()], [sciVizModules::pcaLoadingsPlotOutputUI()],
#' [sciVizModules::pcaLoadingsPlotServer()], [sciVizModules::pcaLoadingsPlotApp()]
#' @examples
#' library(sciVizModules)
#' data(example_pca)
#' pcaLoadingsPlotInputsUI("loadings", example_pca)
pcaLoadingsPlotInputsUI <- function(id, data, defaults = NULL, title = "Loadings Plot Settings", columns = 2) {
    ns <- NS(id)
    .assert_pca(data)
    comps <- .pca_components(data)

    data_tab <- tagList(
        .sci_tip(viz_select_input(ns("components"), "Components",
            choices = comps, selected = get_default(defaults, "components", utils::head(comps, 5)),
            multiple = TRUE
        ), "Components to show, in order."),
        .sci_tip(numericInput(ns("range.retain"), "Range Retained",
            value = get_default(defaults, "range.retain", 0.05, is.numeric), min = 0, max = 0.5, step = 0.01
        ), paste(
            "For each component, keep the variables whose loading lies within this fraction of the",
            "loading range from either end (PCAtools rangeRetain)."
        )),
        .sci_tip(materialSwitch(ns("absolute"), "Absolute Loadings",
            value = get_default(defaults, "absolute", FALSE, is.logical), status = "success"
        ), "Plot the absolute value of each loading.")
    )
    aes_tab <- tagList(
        .sci_tip(colourInput(ns("low.color"), "Low Color", value = get_default(defaults, "low.color", "#FFD700")),
            "Colour of the most negative loadings."),
        .sci_tip(colourInput(ns("mid.color"), "Mid Color", value = get_default(defaults, "mid.color", "#FFFFFF")),
            "Colour of loadings near zero."),
        .sci_tip(colourInput(ns("high.color"), "High Color", value = get_default(defaults, "high.color", "#4169E1")),
            "Colour of the most positive loadings."),
        .sci_tip(numericInput(ns("point.size"), "Point Size",
            value = get_default(defaults, "point.size", 12, is.numeric), min = 1, step = 1), "Marker size."),
        .sci_tip(materialSwitch(ns("show.labels"), "Labels",
            value = get_default(defaults, "show.labels", TRUE, is.logical), status = "success"
        ), "Label each point with its variable name."),
        .sci_tip(numericInput(ns("label.size"), "Label Size",
            value = get_default(defaults, "label.size", 10, is.numeric), min = 4, step = 1), "Label font size.")
    )

    .sci_plot_inputs_ui(ns, "pcaLoadingsPlot", data_tab, aes_tab, defaults, title, columns)
}


#' Output UI components for the pcaLoadingsPlot module
#'
#' @param id The ID for the Shiny module.
#' @param resizable Logical; when `TRUE` (the default) the plot output can be resized by dragging.
#' @return A Shiny plotlyOutput for the loadings plot.
#'
#' @examples
#' pcaLoadingsPlotOutputUI("loadings")
#' @export
#' @author Jared Andrews
pcaLoadingsPlotOutputUI <- function(id, resizable = TRUE) {
    .sci_plot_output_ui(id, "pcaLoadingsPlot", resizable = resizable, height = "500px")
}
