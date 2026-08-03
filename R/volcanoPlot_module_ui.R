#' Input UI components for the volcanoPlot module
#'
#' This should be placed in the UI where the inputs should be shown, with an `id`
#' that matches the `id` used in the `volcanoPlotServer()` and `volcanoPlotOutputUI()` functions.
#'
#' @details The user inputs for this module are separated from the outputs to allow for
#' more flexible UI design.
#'
#' The inputs will automatically be organized into a grid layout via the [VizModules::organize_inputs()] function,
#' with `columns` controlling the number of columns in the grid.
#'
#' Defaults can be set for each input by providing a named list of values to the `defaults` argument.
#' This module wraps [VizModules::dittoViz_scatterPlotInputsUI()] and adds volcano-specific controls.
#' The base scatter plot UI components and their input IDs (e.g. `x.by`, `y.by`,
#' `color.by`, `hover.data`) are documented in [VizModules::dittoViz_scatterPlotInputsUI()];
#' only the volcano-specific additions are described here.
#'
#' Additional inputs specific to volcano plots are added to control significance thresholds and colors:
#'
#' - `sig.thresh`: Significance threshold (default 0.05)
#' - `fc.thresh`: Log2 fold change threshold (default 0)
#' - `volcano.colors`: A multiColorPicker for Up/Down/n.s. group colors
#'   (defaults: Up="red", Down="blue", n.s.="lightgray")
#'
#' @section Plot parameters and defaults:
#' The following parameters can be accessed via UI inputs and/or the `defaults` argument:
#'
#' - `x.by` - X-axis variable (auto-detected from effect size columns: log2FoldChange, LFC, logFC)
#' - `y.by` - Y-axis variable (auto-detected from significance columns: padj, pval, adj.p, svalue, FDR, p)
#' - `color.by` - Coloring variable (default: "group", auto-generated from thresholds)
#' - `y.adj.fxn` - Y adjustment function (default: "neg_log10" for -log10(p-value))
#' - `show.others` - Show others (default: FALSE)
#' - `hover.data` - Hover data columns (default: c("symbol", x.by, y.by))
#' - `sig.thresh` - Significance threshold (UI: "Significance Threshold", default: 0.05)
#' - `fc.thresh` - Log2 fold change threshold (UI: "LFC Threshold (log2)", default: 0)
#' - All other [dittoViz::scatterPlot()] parameters are also available via the wrapped UI
#'
#' @section Parameters controlling additional functionality:
#' The following parameters implementing volcano-specific features are also available:
#'
#' - `volcano.colors` - Named color vector for Up/Down/n.s. groups (UI: "Group Colors" multiColorPicker)
#' - `group` - Auto-generated grouping column based on sig.thresh and fc.thresh
#'
#' @param id The ID for the Shiny module.
#' @param data The data frame used for plot generation.
#' @param defaults A named list of default values for the inputs.
#' @param title An optional title for the UI grid.
#' @param columns Number of columns for the UI grid.
#' @return A Shiny tagList containing the UI elements
#'
#' @import shiny
#' @importFrom shinyBS tipify
#' @importFrom VizModules dittoViz_scatterPlotInputsUI
#'
#' @export
#' @author Jared Andrews
#' @seealso [dittoViz::scatterPlot()], [VizModules::dittoViz_scatterPlotInputsUI()],
#' [sciVizModules::volcanoPlotOutputUI()], [sciVizModules::volcanoPlotServer()],
#' [sciVizModules::volcanoPlotApp()]
#' @examples
#' library(sciVizModules)
#' data(airway_deseq2)
#' volcanoPlotInputsUI("volcanoPlot", airway_deseq2)
volcanoPlotInputsUI <- function(id, data, defaults = NULL, title = "Volcano Settings", columns = 2) {
    # Add a few extra inputs to control the DE thresholds
    ns <- NS(id)

    if (is.null(defaults)) {
        defaults <- list()
    }

    # Compute volcano defaults (shared with volcanoPlotServer so the initial
    # state and the reset state stay in sync).
    defaults <- .volcano_defaults(data, defaults)

    # Build initial colors from defaults or use standard volcano colors
    initial_colors <- .de_group_colors(defaults)

    extras <- tagList(
        tipify(numericInput(ns("sig.thresh"), "Significance Threshold:",
            value = defaults[["sig.thresh"]],
            max = 1,
            min = 0,
            step = 0.01
        ), "Significance threshold for grouping genes as Up/Down/n.s.",
            placement = "top", options = list(container = "body")),
        tipify(numericInput(ns("fc.thresh"), "LFC Threshold (log2):",
            value = defaults[["fc.thresh"]],
            min = 0,
            step = 0.25
        ), "Log2 fold change threshold for grouping genes as Up/Down/n.s.",
            placement = "top", options = list(container = "body")),
        tipify(multiColorPicker(
            inputId = ns("volcano.colors"),
            label = "Group Colors",
            groups = c("Up", "Down", "n.s."),
            colors = initial_colors,
            palette_options = default_palettes()[["choices"]],
            compact = TRUE
        ), "Select colors for each significance group (Up-regulated, Down-regulated, and non-significant)",
            placement = "top", options = list(container = "body"))
    )

    extras <- organize_inputs(extras, columns = columns)

    # Ensure 'group' is in the data so it appears in the choices for dittoViz_ScatterPlotInputsUI
    # This allows the default selected="group" for color.by to work correctly
    if (!"group" %in% names(data)) {
        data$group <- "dummy"
    }

    outs <- dittoViz_scatterPlotInputsUI(id = id, data = data, defaults = defaults, title = h3(title), columns = columns)

    tagList(extras, outs)
}


#' Output UI components for the volcanoPlot module
#'
#' This should be placed in the UI where the plot should be shown.
#'
#' @param id The ID for the Shiny module.
#'
#' @return A Shiny plotlyOutput for the volcano plot
#' 
#' @import shiny
#' @importFrom VizModules dittoViz_scatterPlotOutputUI
#'
#' @examples
#' volcanoPlotOutputUI("plot")
#' @export
#' @author Jared Andrews
volcanoPlotOutputUI <- function(id) {
    dittoViz_scatterPlotOutputUI(id)
}
