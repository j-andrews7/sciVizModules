#' Input UI components for the pcaPairsPlot module
#'
#' This should be placed in the UI where the inputs should be shown, with an `id`
#' that matches the `id` used in the `pcaPairsPlotServer()` and
#' `pcaPairsPlotOutputUI()` functions.
#'
#' @details The module draws [pcaPairsPlot()] for a PCAtools `pca` object: a
#' lower-triangle grid of sample scores for every pair of the chosen components.
#' The inputs are organised into tabs via [VizModules::organize_inputs()].
#'
#' @section Plot parameters and defaults:
#' The following parameters can be accessed via UI inputs and/or the `defaults` argument:
#'
#' - `components` - Components to pair (default: the first 4; PCAtools `components`)
#' - `color.by` - Metadata column to colour by (default: the first discrete
#'   column; PCAtools `colby`)
#' - `shape.by` - Metadata column to shape by (default: none; PCAtools `shape`)
#' - `palette.colours` - Named group colours (multiColorPicker; PCAtools `colkey`)
#' - `point.size` - Marker size (default: 8; PCAtools `pointSize`)
#' - `opacity` - Marker opacity (default: 1)
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
#'
#' @export
#' @author Jared Andrews
#' @seealso [pcaPairsPlot()], [PCAtools::pairsplot()], [sciVizModules::pcaPairsPlotOutputUI()],
#' [sciVizModules::pcaPairsPlotServer()], [sciVizModules::pcaPairsPlotApp()]
#' @examples
#' library(sciVizModules)
#' data(example_pca)
#' pcaPairsPlotInputsUI("pairs", example_pca)
pcaPairsPlotInputsUI <- function(id, data, defaults = NULL, title = "Pairs Plot Settings", columns = 2) {
    ns <- NS(id)
    .assert_pca(data)
    comps <- .pca_components(data)
    disc <- .pca_metadata_cols(data, "discrete")
    group.choices <- c("None" = "", stats::setNames(disc, disc))

    data_tab <- tagList(
        .sci_tip(viz_select_input(ns("components"), "Components",
            choices = comps, selected = get_default(defaults, "components", utils::head(comps, 4)),
            multiple = TRUE
        ), "Components to pair; every pair gets a panel. More than six makes the panels small."),
        .sci_tip(viz_select_input(ns("color.by"), "Color By",
            choices = group.choices, selected = get_default(defaults, "color.by", if (length(disc)) disc[1] else "")
        ), "Metadata column to colour the samples by."),
        .sci_tip(viz_select_input(ns("shape.by"), "Shape By",
            choices = group.choices, selected = get_default(defaults, "shape.by", "")
        ), "Metadata column to shape the samples by.")
    )
    aes_tab <- tagList(
        uiOutput(ns("palette.selection")),
        .sci_tip(numericInput(ns("point.size"), "Point Size",
            value = get_default(defaults, "point.size", 8, is.numeric), min = 1, step = 1), "Marker size."),
        .sci_tip(numericInput(ns("opacity"), "Opacity",
            value = get_default(defaults, "opacity", 1, is.numeric), min = 0.05, max = 1, step = 0.05),
            "Marker opacity.")
    )

    .sci_plot_inputs_ui(ns, "pcaPairsPlot", data_tab, aes_tab, defaults, title, columns)
}


#' Output UI components for the pcaPairsPlot module
#'
#' @param id The ID for the Shiny module.
#' @param resizable Logical; when `TRUE` (the default) the plot output can be resized by dragging.
#' @return A Shiny plotlyOutput for the pairs plot.
#'
#' @examples
#' pcaPairsPlotOutputUI("pairs")
#' @export
#' @author Jared Andrews
pcaPairsPlotOutputUI <- function(id, resizable = TRUE) {
    .sci_plot_output_ui(id, "pcaPairsPlot", resizable = resizable, height = "650px")
}
