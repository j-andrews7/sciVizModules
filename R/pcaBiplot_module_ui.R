#' Input UI components for the pcaBiplot module
#'
#' This should be placed in the UI where the inputs should be shown, with an `id`
#' that matches the `id` used in the `pcaBiplotServer()` and
#' `pcaBiplotOutputUI()` functions.
#'
#' @details The user inputs for this module are separated from the outputs to allow for
#' more flexible UI design.
#'
#' The module plots the sample scores of a PCAtools `pca` object (from
#' [PCAtools::pca()]), the interactive counterpart of [PCAtools::biplot()]. It
#' wraps [VizModules::dittoViz_scatterPlotInputsUI()] on a table of the scores
#' joined to the object's sample metadata, so colour, shape, faceting, ellipses,
#' point annotations and the rest of the scatter module's controls all apply.
#' Those inputs are documented there; only the biplot additions are listed here.
#'
#' When both axes show components and no axis adjustment is active, the axis
#' titles carry the variance each component explains, and the loading arrows
#' can be drawn.
#'
#' @section Plot parameters and defaults:
#' The following parameters can be accessed via UI inputs and/or the `defaults` argument:
#'
#' - `x.by`, `y.by` - Components on the axes (default: `"PC1"`, `"PC2"`)
#' - `color.by` - Colour column (default: the first discrete metadata column)
#' - `show.loadings` - Draw loading arrows (default: FALSE; PCAtools `showLoadings`)
#' - `n.top.loadings` - Variables with the largest absolute loading on each
#'   axis to draw (default: 5; PCAtools `ntopLoadings`)
#' - `loadings.length.factor` - Arrow length multiplier (default: 1.5;
#'   PCAtools `lengthLoadingsArrowsFactor`)
#' - `loadings.color` - Arrow and label colour (default: "#000000")
#' - `loadings.label.size` - Arrow label font size (default: 12)
#' - All other [VizModules::dittoViz_scatterPlotInputsUI()] parameters
#'
#' @param id The ID for the Shiny module.
#' @param data A PCAtools `pca` object.
#' @param defaults A named list of default values for the inputs.
#' @param title An optional title for the UI grid.
#' @param columns Number of columns for the UI grid.
#' @return A Shiny tagList containing the UI elements
#'
#' @import shiny
#' @importFrom shinyBS tipify
#' @importFrom shinyWidgets materialSwitch
#' @importFrom colourpicker colourInput
#' @importFrom VizModules dittoViz_scatterPlotInputsUI
#'
#' @export
#' @author Jared Andrews
#' @seealso [PCAtools::biplot()], [VizModules::dittoViz_scatterPlotInputsUI()],
#' [sciVizModules::pcaBiplotOutputUI()], [sciVizModules::pcaBiplotServer()],
#' [sciVizModules::pcaBiplotApp()]
#' @examples
#' library(sciVizModules)
#' data(example_pca)
#' pcaBiplotInputsUI("biplot", example_pca)
pcaBiplotInputsUI <- function(id, data, defaults = NULL, title = "PCA Biplot Settings", columns = 2) {
    ns <- NS(id)
    .assert_pca(data)
    defaults <- .pca_biplot_defaults(data, defaults)
    tip <- function(tag, text) tipify(tag, text, placement = "top", options = list(container = "body"))

    extras <- tagList(
        tip(materialSwitch(ns("show.loadings"), "Loading Arrows",
            value = get_default(defaults, "show.loadings", FALSE, is.logical), status = "success"
        ), paste(
            "Draw arrows for the variables loading most strongly on the two components.",
            "Shown when both axes are components and no axis adjustment is set."
        )),
        tip(numericInput(ns("n.top.loadings"), "Top Loadings per Axis",
            value = get_default(defaults, "n.top.loadings", 5, is.numeric), min = 1, step = 1
        ), "Number of variables with the largest absolute loading on each axis to draw."),
        tip(numericInput(ns("loadings.length.factor"), "Arrow Length Factor",
            value = get_default(defaults, "loadings.length.factor", 1.5, is.numeric), min = 0.1, step = 0.1
        ), "Multiplier on the arrow lengths after scaling the loadings to the scores."),
        tip(colourInput(ns("loadings.color"), "Arrow Color",
            value = get_default(defaults, "loadings.color", "#000000")
        ), "Colour of the loading arrows and their labels."),
        tip(numericInput(ns("loadings.label.size"), "Arrow Label Size",
            value = get_default(defaults, "loadings.label.size", 12, is.numeric), min = 4, step = 1
        ), "Font size of the loading arrow labels.")
    )

    tagList(
        organize_inputs(extras, columns = columns),
        dittoViz_scatterPlotInputsUI(
            id = id, data = .pca_scores_df(data), defaults = defaults,
            title = if (is.null(title) || inherits(title, c("shiny.tag", "shiny.tag.list"))) title else h3(title),
            columns = columns
        )
    )
}


#' Output UI components for the pcaBiplot module
#'
#' This should be placed in the UI where the plot should be shown.
#'
#' @param id The ID for the Shiny module.
#' @param resizable Logical, whether to wrap the output in a resizable container.
#'
#' @return A Shiny plotlyOutput for the biplot.
#'
#' @importFrom VizModules dittoViz_scatterPlotOutputUI
#'
#' @examples
#' pcaBiplotOutputUI("biplot")
#' @export
#' @author Jared Andrews
pcaBiplotOutputUI <- function(id, resizable = TRUE) {
    dittoViz_scatterPlotOutputUI(id, resizable = resizable)
}
