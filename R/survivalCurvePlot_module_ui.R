#' Input UI components for the survivalCurvePlot module
#'
#' Wraps [VizModules::linePlotInputsUI()] following the same design pattern as
#' [volcanoPlotInputsUI()].  Survival-specific controls (marker toggle,
#' marker shape selector, group column selector, and number-at-risk column
#' selector) are prepended above the standard linePlot tabset.
#'
#' Default column selections use the **first two columns** of the data frame:
#' column 1 → x (time), column 2 → y (survival).  The group and n.risk columns
#' must be selected explicitly via the provided dropdowns; there is no
#' auto-detection.  Irrelevant linePlot inputs (`group.by`, `errorBar`,
#' `order.by`, etc.) and the Facet tab are hidden by
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
#' @importFrom shinyWidgets materialSwitch
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

    # Columns available for group-by: all non-numeric first, then the rest
    non_num_cols <- names(data)[vapply(data, function(x) !is.numeric(x), logical(1))]
    num_cols     <- names(data)[vapply(data, is.numeric, logical(1))]
    group_default <- if (length(non_num_cols) > 0) non_num_cols[1] else "None"

    # --- Simple position-based column defaults (first col = time, second = surv)
    if (!"x.value" %in% names(defaults)) {
        defaults$x.value <- col_names[1]
    }
    if (!"y.value" %in% names(defaults)) {
        defaults$y.value <- if (length(col_names) >= 2) col_names[2] else col_names[1]
    }
    # Force plot mode to lines (step-function)
    if (!"plot.type" %in% names(defaults)) defaults$plot.type <- "lines"

    # --- Survival-specific extras (marker toggle + shape + column selectors) --
    extras <- tagList(
        tipify(
            materialSwitch(ns("show.markers"), "Show Data Points:",
                value  = TRUE,
                status = "success"),
            "Overlay marker symbols at the original (non-interpolated) time points.",
            placement = "top", options = list(container = "body")
        ),
        tipify(
            selectInput(ns("marker.symbol"), "Marker Shape:",
                choices  = c("circle", "square", "diamond", "cross", "x",
                             "triangle-up", "triangle-down", "star", "pentagon"),
                selected = "circle"),
            "Shape of the marker placed at each observed time point.",
            placement = "top", options = list(container = "body")
        ),
        tipify(
            selectInput(ns("group.by.col"), "Group By Column:",
                choices  = c("None", non_num_cols, num_cols),
                selected = group_default),
            "Column used to color and stratify the KM curves. Select 'None' for a single overall curve.",
            placement = "top", options = list(container = "body")
        ),
        tipify(
            selectInput(ns("nrisk.col"), "Number at Risk Column:",
                choices  = c("None", num_cols),
                selected = "None"),
            "Numeric column containing the number-at-risk counts for the risk table below the plot. Select 'None' to hide the table.",
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
#' output.  When the data contains an `n.risk` column, the server embeds a
#' "Number at risk" table as a second subplot below the KM curve.
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
