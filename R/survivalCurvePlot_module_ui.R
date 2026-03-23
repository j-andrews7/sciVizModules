#' Input UI components for the survivalCurvePlot module
#'
#' This should be placed in the UI where the inputs should be shown, with an
#' `id` that matches the `id` used in `survivalCurvePlotServer()` and
#' `survivalCurvePlotOutputUI()`.
#'
#' @details The user inputs for this module are separated from the outputs to
#' allow for more flexible UI design.  Inputs are organized into a tabset via
#' [VizModules::organize_inputs()].
#'
#' Column auto-detection uses `grep()` on column names so it works with a wide
#' variety of naming conventions without requiring an exact-match candidate list.
#'
#' @section Available tabs and inputs:
#' \itemize{
#'   \item **Data** — `time.col` (time variable) and `surv.col` (survival
#'     probability, 0–1 scale).
#'   \item **Colors** — per-group colour picker (`multiColorPicker`).
#'   \item **Aesthetics** — `line.type` (dash style) and `marker.symbol`
#'     (marker shape for original data points).
#'   \item **Axes** — full axis-styling controls provided by
#'     `VizModules:::.uniform_axes_inputs_ui()`.
#'   \item **Lines** — reference line controls (h/v/ablines) from
#'     `VizModules:::.uniform_lines_inputs_ui()`.
#' }
#'
#' The **Reset / Auto Update / Save** buttons are added via
#' [VizModules::module_tack_ui()].
#'
#' @param id The ID for the Shiny module.
#' @param data The data frame used for plot generation.  Must contain at
#'   minimum a time column and a survival probability column.
#' @param defaults A named list of default values.  Recognised keys:
#'   `time.col`, `surv.col`, `line.type`, `marker.symbol`.
#' @param title An optional title displayed above the tabset panel.
#' @param columns Number of columns for the UI grid layout.
#' @return A Shiny `tagList` containing all UI elements.
#'
#' @import shiny
#' @importFrom shinyBS tipify
#' @importFrom shinyWidgets materialSwitch
#'
#' @export
#' @author Jacob Martin, Jared Andrews
#' @seealso [survivalCurvePlotOutputUI()],
#'   [survivalCurvePlotServer()],
#'   [survivalCurvePlotApp()]
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

    # --- grep-based column auto-detection ------------------------------------
    if (!"time.col" %in% names(defaults)) {
        found <- grep("^time$|^days$|^months$|^years$|^t$",
                      col_names, value = TRUE, ignore.case = TRUE)
        defaults$time.col <- if (length(found) > 0) found[1] else col_names[1]
    }
    if (!"surv.col" %in% names(defaults)) {
        found <- grep("surv|survival|^prob$|^estimate$|^s$",
                      num_cols, value = TRUE, ignore.case = TRUE)
        defaults$surv.col <- if (length(found) > 0) found[1] else
            (if (length(num_cols) > 0) num_cols[1] else col_names[1])
    }
    if (!"line.type"     %in% names(defaults)) defaults$line.type     <- "solid"
    if (!"marker.symbol" %in% names(defaults)) defaults$marker.symbol <- "circle"

    marker_choices <- c(
        "circle", "square", "diamond", "cross", "x",
        "triangle-up", "triangle-down", "star", "pentagon"
    )
    line_choices <- c("solid", "dot", "dash", "longdash", "dashdot", "longdashdot")

    # --- Tab: Data -----------------------------------------------------------
    data_tab <- tagList(
        tipify(
            selectInput(ns("time.col"), "Time Column:",
                choices  = col_names,
                selected = defaults$time.col),
            "Column containing the time variable plotted on the x-axis.",
            placement = "top", options = list(container = "body")
        ),
        tipify(
            selectInput(ns("surv.col"), "Survival Column:",
                choices  = c("", num_cols),
                selected = defaults$surv.col),
            "Column with survival probabilities on the 0-1 scale (displayed as %).",
            placement = "top", options = list(container = "body")
        )
    )

    # --- Tab: Colors ---------------------------------------------------------
    colors_tab <- tagList(uiOutput(ns("palette.selection")))

    # --- Tab: Aesthetics -----------------------------------------------------
    aesthetics_tab <- tagList(
        tipify(
            selectInput(ns("line.type"), "Line Type:",
                choices  = line_choices,
                selected = defaults$line.type),
            "Dash style for the survival curve lines.",
            placement = "top", options = list(container = "body")
        ),
        tipify(
            materialSwitch(ns("show.markers"), "Show Data Points:",
                value  = TRUE,
                status = "success"),
            "Overlay marker symbols at the original (non-interpolated) data points.",
            placement = "top", options = list(container = "body")
        ),
        tipify(
            selectInput(ns("marker.symbol"), "Marker Shape:",
                choices  = marker_choices,
                selected = defaults$marker.symbol),
            "Shape of the marker placed at each observed time point.",
            placement = "top", options = list(container = "body")
        )
    )

    inputs <- list(
        "Data"       = data_tab,
        "Colors"     = colors_tab,
        "Aesthetics" = aesthetics_tab,
        "Axes"       = VizModules:::.uniform_axes_inputs_ui(
                           ns, defaults, include.rotate = FALSE, include.flip = FALSE),
        "Lines"      = VizModules:::.uniform_lines_inputs_ui(ns, defaults)
    )

    organize_inputs(
        inputs,
        id      = ns("survivalPlotTabsetPanel"),
        title   = if (!is.null(title)) h3(title) else NULL,
        tack    = module_tack_ui(ns, defaults = defaults),
        columns = columns
    )
}


#' Output UI components for the survivalCurvePlot module
#'
#' This should be placed in the UI where the plot should be shown, with an `id`
#' that matches the `id` used in `survivalCurvePlotServer()` and
#' `survivalCurvePlotInputsUI()`.
#'
#' The output is a single resizable plotly figure.  When the input data
#' contains an `n.risk` column (or similar), a **Number at risk** table is
#' rendered as plotly annotations embedded directly below the x-axis of the
#' same figure.
#'
#' @param id The ID for the Shiny module.
#' @return A resizable [plotly::plotlyOutput()] widget.
#'
#' @import shiny
#' @importFrom shinyjqui jqui_resizable
#'
#' @export
#' @author Jacob Martin, Jared Andrews
#' @seealso [survivalCurvePlotInputsUI()],
#'   [survivalCurvePlotServer()],
#'   [survivalCurvePlotApp()]
survivalCurvePlotOutputUI <- function(id) {
    ns <- NS(id)
    jqui_resizable(
        plotlyOutput(ns("survivalPlot"))
    )
}
