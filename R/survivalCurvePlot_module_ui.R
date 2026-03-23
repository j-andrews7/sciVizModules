#' Input UI components for the survivalCurvePlot module
#'
#' This should be placed in the UI where the inputs should be shown, with an
#' `id` that matches the `id` used in `survivalCurvePlotServer()` and
#' `survivalCurvePlotOutputUI()`.
#'
#' @details This module wraps [VizModules::linePlotInputsUI()] and prepends
#' survival-specific controls (marker toggle and marker shape selector) above
#' the standard tabset, following the same design pattern as
#' [volcanoPlotInputsUI()].
#'
#' The standard `linePlotInputsUI` tabset provides:
#' \itemize{
#'   \item **Data** — `x.value` (time column, auto-detected) and
#'     `y.value` (survival column, auto-detected).
#'   \item **Aesthetics** — `line.type`, `plot.type`, and a colour picker
#'     (`palette.colours`) whose groups are driven by the auto-detected group
#'     column in the data.
#'   \item **Axes** — full axis-styling controls.
#'   \item **Lines** — reference line controls.
#' }
#'
#' Column auto-detection uses `grep()` on column names.  The detected columns
#' become the default selection for `x.value` / `y.value`.  Irrelevant
#' linePlot inputs (`group.by`, `errorBar`, `order.by`, etc.) are hidden by
#' `survivalCurvePlotServer()`.
#'
#' @param id The ID for the Shiny module.
#' @param data The data frame used for plot generation.  Must contain at
#'   minimum a time column and a survival probability column (0-1 scale).
#' @param defaults A named list of default values.  Passed through to
#'   [VizModules::linePlotInputsUI()].  Recognised survival-specific keys:
#'   `x.value` (time col override) and `y.value` (survival col override).
#' @param title An optional title displayed above the tabset panel.
#' @param columns Number of columns for the UI grid layout.
#' @return A Shiny `tagList` containing survival-specific inputs above
#'   the standard linePlot tabset.
#'
#' @import shiny
#' @importFrom shinyBS tipify
#' @importFrom shinyWidgets materialSwitch
#' @importFrom VizModules linePlotInputsUI
#'
#' @export
#' @author Jacob Martin, Jared Andrews
#' @seealso [survivalCurvePlotOutputUI()],
#'   [survivalCurvePlotServer()],
#'   [survivalCurvePlotApp()],
#'   [VizModules::linePlotInputsUI()]
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
    num_cols  <- col_names[vapply(data, is.numeric, logical(1))]

    # --- grep-based column auto-detection for linePlotInputsUI defaults ------
    if (!"x.value" %in% names(defaults)) {
        found <- grep("^time$|^days$|^months$|^years$|^t$",
                      col_names, value = TRUE, ignore.case = TRUE)
        defaults$x.value <- if (length(found) > 0) found[1] else col_names[1]
    }
    if (!"y.value" %in% names(defaults)) {
        found <- grep("surv|survival|^prob$|^estimate$|^s$",
                      num_cols, value = TRUE, ignore.case = TRUE)
        defaults$y.value <- if (length(found) > 0) found[1] else
            (if (length(num_cols) > 0) num_cols[1] else col_names[1])
    }
    # Force plot mode to lines (step-function)
    if (!"plot.type" %in% names(defaults)) defaults$plot.type <- "lines"

    # --- Survival-specific extra inputs (prepended before the tabset) --------
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
        )
    )
    extras_grid <- organize_inputs(extras, columns = columns)

    # --- Base: full linePlot UI (provides Axes, Lines, module_tack_ui) -------
    base_ui <- linePlotInputsUI(
        id      = id,
        data    = data,
        defaults = defaults,
        title   = h3(title),
        columns = columns
    )

    tagList(extras_grid, base_ui)
}


#' Output UI components for the survivalCurvePlot module
#'
#' This should be placed in the UI where the plot should be shown, with an
#' `id` matching the `id` used in `survivalCurvePlotServer()` and
#' `survivalCurvePlotInputsUI()`.
#'
#' Delegates to [VizModules::linePlotOutputUI()] which creates a resizable
#' plotly output.  When the data contains an `n.risk` column the server
#' embeds a "Number at risk" table as plotly annotations below the x-axis.
#'
#' @param id The ID for the Shiny module.
#' @return A resizable [plotly::plotlyOutput()] widget.
#'
#' @importFrom VizModules linePlotOutputUI
#'
#' @export
#' @author Jacob Martin, Jared Andrews
#' @seealso [survivalCurvePlotInputsUI()],
#'   [survivalCurvePlotServer()],
#'   [survivalCurvePlotApp()]
survivalCurvePlotOutputUI <- function(id) {
    linePlotOutputUI(id)
}
