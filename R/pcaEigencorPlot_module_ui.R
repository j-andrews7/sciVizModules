#' Input UI components for the pcaEigencorPlot module
#'
#' This should be placed in the UI where the inputs should be shown, with an `id`
#' that matches the `id` used in the `pcaEigencorPlotServer()` and
#' `pcaEigencorPlotOutputUI()` functions.
#'
#' @details The module draws [pcaEigencorPlot()] for a PCAtools `pca` object:
#' the correlation of each component with each sample metadata variable, to see
#' which components track which covariates (treatment, batch, sequencing depth).
#' The inputs are organised into tabs via [VizModules::organize_inputs()].
#'
#' @section Plot parameters and defaults:
#' The following parameters can be accessed via UI inputs and/or the `defaults` argument:
#'
#' - `components` - Components to correlate (default: the first 10; PCAtools `components`)
#' - `metavars` - Metadata variables (default: all; PCAtools `metavars`).
#'   Non-numeric ones are converted to integer codes.
#' - `cor.method` - `"pearson"`, `"spearman"` or `"kendall"` (default:
#'   `"pearson"`; PCAtools `corFUN`)
#' - `p.adjust.method` - Multiple-testing correction across all cells (default:
#'   `"none"`; PCAtools `corMultipleTestCorrection`)
#' - `plot.rsquared` - Show R-squared rather than r (default: FALSE; PCAtools `plotRsquared`)
#' - `low.color`, `mid.color`, `high.color` - Colour scale (defaults: dark blue,
#'   white, dark red; PCAtools `col`)
#' - `show.values` - Print values and significance stars in the cells (default: TRUE)
#' - `digits` - Decimal places of the printed values (default: 2)
#'
#' The Legend, Axes and Plotly tabs carry the shared VizModules inputs.
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
#' @importFrom stats p.adjust.methods
#'
#' @export
#' @author Jared Andrews
#' @seealso [pcaEigencorPlot()], [PCAtools::eigencorplot()], [sciVizModules::pcaEigencorPlotOutputUI()],
#' [sciVizModules::pcaEigencorPlotServer()], [sciVizModules::pcaEigencorPlotApp()]
#' @examples
#' library(sciVizModules)
#' data(example_pca)
#' pcaEigencorPlotInputsUI("eigencor", example_pca)
pcaEigencorPlotInputsUI <- function(id, data, defaults = NULL, title = "PC-Metadata Correlation Settings",
                                    columns = 2) {
    ns <- NS(id)
    .assert_pca(data)
    comps <- .pca_components(data)
    metas <- names(as.data.frame(data$metadata %||% data.frame()))

    data_tab <- tagList(
        .sci_tip(viz_select_input(ns("components"), "Components",
            choices = comps, selected = get_default(defaults, "components", utils::head(comps, 10)),
            multiple = TRUE
        ), "Components to correlate with the metadata."),
        .sci_tip(viz_select_input(ns("metavars"), "Metadata Variables",
            choices = metas, selected = get_default(defaults, "metavars", metas), multiple = TRUE
        ), "Metadata variables to correlate. Non-numeric variables are converted to integer codes."),
        .sci_tip(viz_select_input(ns("cor.method"), "Correlation",
            choices = c("Pearson" = "pearson", "Spearman" = "spearman", "Kendall" = "kendall"),
            selected = get_default(defaults, "cor.method", "pearson")
        ), "Correlation coefficient."),
        .sci_tip(viz_select_input(ns("p.adjust.method"), "P-value Adjustment",
            choices = stats::p.adjust.methods, selected = get_default(defaults, "p.adjust.method", "none")
        ), "Multiple-testing correction, applied across every cell."),
        .sci_tip(materialSwitch(ns("plot.rsquared"), "R-squared",
            value = get_default(defaults, "plot.rsquared", FALSE, is.logical), status = "success"
        ), "Show R-squared rather than the signed coefficient.")
    )
    aes_tab <- tagList(
        .sci_tip(colourInput(ns("low.color"), "Low Color", value = get_default(defaults, "low.color", "#00008B")),
            "Colour of the strongest negative correlations."),
        .sci_tip(colourInput(ns("mid.color"), "Mid Color", value = get_default(defaults, "mid.color", "#FFFFFF")),
            "Colour of no correlation."),
        .sci_tip(colourInput(ns("high.color"), "High Color", value = get_default(defaults, "high.color", "#8B0000")),
            "Colour of the strongest positive correlations."),
        .sci_tip(materialSwitch(ns("show.values"), "Cell Values",
            value = get_default(defaults, "show.values", TRUE, is.logical), status = "success"
        ), "Print the value and significance stars (* < 0.05, ** < 0.01, *** < 0.001) in each cell."),
        .sci_tip(numericInput(ns("digits"), "Decimal Places",
            value = get_default(defaults, "digits", 2, is.numeric), min = 0, max = 4, step = 1),
            "Decimal places of the printed values.")
    )

    .sci_plot_inputs_ui(ns, "pcaEigencorPlot", data_tab, aes_tab, defaults, title, columns, lines = FALSE)
}


#' Output UI components for the pcaEigencorPlot module
#'
#' @param id The ID for the Shiny module.
#' @param resizable Logical; when `TRUE` (the default) the plot output can be resized by dragging.
#' @return A Shiny plotlyOutput for the correlation heatmap.
#'
#' @examples
#' pcaEigencorPlotOutputUI("eigencor")
#' @export
#' @author Jared Andrews
pcaEigencorPlotOutputUI <- function(id, resizable = TRUE) {
    .sci_plot_output_ui(id, "pcaEigencorPlot", resizable = resizable)
}
