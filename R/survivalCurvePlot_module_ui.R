#' Input UI components for the survivalCurvePlot module
#'
#' Wraps [VizModules::linePlotInputsUI()] following the same design pattern as
#' [volcanoPlotInputsUI()].  Survival-specific controls (censor column selector
#' and censor marker shape) are prepended above the standard linePlot tabset.
#'
#' Default column selections use the **first two columns** of the data frame:
#' column 1 → x (time), column 2 → y (survival).  Irrelevant linePlot inputs
#' (`group.by`, `errorBar`, `order.by`, etc.) and the Facet tab are hidden by
#' [survivalCurvePlotServer()].
#'
#' @param id The ID for the Shiny module.
#' @param data The data frame used for plot generation.
#' @param defaults A named list of default values passed to
#'   [VizModules::linePlotInputsUI()].  Key overrides: `x.value` (time column)
#'   and `y.value` (survival column).
#' @param title An optional title displayed above the tabset panel.
#' @param columns Number of columns for the UI grid layout.
#' @return A Shiny `tagList` with survival-specific extras above the linePlot
#'   tabset.
#'
#' @import shiny
#' @importFrom shinyBS tipify
#' @importFrom VizModules linePlotInputsUI
#'
#' @export
#' @author Jacob Martin, Jared Andrews
#' @seealso [survivalCurvePlotOutputUI()], [survivalCurvePlotServer()],
#'   [survivalCurvePlotApp()], [VizModules::linePlotInputsUI()]
#' @examples
#' library(sciVizModules)
#' data(km_survival_groups)
#' survivalCurvePlotInputsUI("survivalPlot", km_survival_groups)
survivalCurvePlotInputsUI <- function(id, data,
                                      defaults = NULL,
                                      title = "Survival Curve Settings",
                                      columns = 2) {
    ns <- NS(id)
    if (is.null(defaults)) defaults <- list()

    col_names <- names(data)

    # --- Position-based column defaults: col[1] = time, col[2] = survival ----
    if (!"x.value" %in% names(defaults)) {
        defaults$x.value <- col_names[1]
    }
    if (!"y.value" %in% names(defaults)) {
        defaults$y.value <- if (length(col_names) >= 2) col_names[2] else col_names[1]
    }
    # Force plot mode to lines (step-function)
    if (!"plot.type" %in% names(defaults)) defaults$plot.type <- "lines"

    # --- Survival-specific extras (censor column + marker shape) -------------
    extras <- tagList(
        tipify(
            selectInput(ns("censor.col"), "Censor Column:",
                choices  = c("None" = "", col_names),
                selected = ""),
            paste("Select a column whose non-zero values mark censoring events.",
                  "Leave blank for no censor markers."),
            placement = "top", options = list(container = "body")
        ),
        tipify(
            selectInput(ns("marker.symbol"), "Censor Marker Shape:",
                choices  = c("x", "cross", "circle", "square", "diamond",
                             "triangle-up", "triangle-down", "star"),
                selected = "x"),
            "Shape of the mark placed at each censoring event time point.",
            placement = "top", options = list(container = "body")
        )
    )
    extras_grid <- organize_inputs(extras, columns = columns)

    # --- Base: full linePlot UI (Axes, Lines, module_tack_ui, etc.) ----------
    base_ui <- linePlotInputsUI(
        id       = id,
        data     = data,
        defaults = defaults,
        title    = h3(title),
        columns  = columns
    )

    tagList(extras_grid, base_ui)
}


#' Output UI components for the survivalCurvePlot module
#'
#' Delegates to [VizModules::linePlotOutputUI()], creating a resizable plotly
#' output.
#'
#' @param id The ID for the Shiny module.
#' @return A resizable [plotly::plotlyOutput()] widget.
#'
#' @importFrom VizModules linePlotOutputUI
#'
#' @export
#' @author Jacob Martin, Jared Andrews
#' @seealso [survivalCurvePlotInputsUI()], [survivalCurvePlotServer()],
#'   [survivalCurvePlotApp()]
survivalCurvePlotOutputUI <- function(id) {
    linePlotOutputUI(id)
}
