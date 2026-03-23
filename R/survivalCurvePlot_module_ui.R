#' Input UI components for the survivalCurvePlot module
#'
#' This should be placed in the UI where the inputs should be shown, with an `id`
#' that matches the `id` used in the `survivalCurvePlotServer()` and
#' `survivalCurvePlotOutputUI()` functions.
#'
#' @details The user inputs for this module are separated from the outputs to
#' allow for more flexible UI design.
#'
#' The inputs are organized into a tabset via [VizModules::organize_inputs()],
#' with `columns` controlling the number of columns in each tab's grid.
#'
#' This module wraps [VizModules::linePlotInputsUI()] and extends it with
#' survival-specific controls for column selection, confidence intervals, and
#' per-group colour picking.
#'
#' @section Survival-specific inputs:
#' \itemize{
#'   \item `time.col` - Column containing the time variable (auto-detected).
#'   \item `surv.col` - Column containing the survival probability (auto-detected).
#'   \item `group.col` - Optional column for grouping curves (auto-detected).
#'   \item `n.risk.col` - Column with the number at risk for the risk table (auto-detected).
#'   \item `lower.col` - Column for the lower 95\% CI bound (auto-detected).
#'   \item `upper.col` - Column for the upper 95\% CI bound (auto-detected).
#'   \item `show.ci` - Toggle to display the confidence interval ribbon.
#'   \item `title.text` - Main plot title (default: "Survival Curve").
#'   \item `line.type` - Plotly line dash style (default: "solid").
#'   \item `survival.colors` - Per-group colour picker (`multiColorPicker`).
#' }
#'
#' @param id The ID for the Shiny module.
#' @param data The data frame used for plot generation. Must contain at minimum
#'   a time column and a survival probability column.
#' @param defaults A named list of default values for the inputs. Recognised
#'   keys: `time.col`, `surv.col`, `group.col`, `n.risk.col`, `lower.col`,
#'   `upper.col`, `show.ci`, `title.text`, `line.type`.
#' @param title An optional title displayed above the tabset panel.
#' @param columns Number of columns for the UI grid layout.
#' @return A Shiny `tagList` containing the UI elements.
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

    # --- Auto-detect column names --------------------------------------------
    col_names <- names(data)
    num_cols  <- col_names[vapply(data, is.numeric, logical(1))]

    .detect <- function(candidates, pool = col_names, fallback = pool[1]) {
        found <- intersect(candidates, pool)
        if (length(found) > 0) found[1] else fallback
    }

    time_candidates   <- c("time", "Time", "TIME", "t", "days", "months", "years")
    surv_candidates   <- c("survival", "Survival", "surv", "S", "estimate", "prob")
    nrisk_candidates  <- c("n.risk", "n_risk", "nrisk", "at.risk", "N.risk")
    lower_candidates  <- c("lower", "lower_95", "lower.95", "conf.low",  "lower.CI", "lower 95% CI")
    upper_candidates  <- c("upper", "upper_95", "upper.95", "conf.high", "upper.CI", "upper 95% CI")
    group_candidates  <- c("group", "Group", "strata", "Strata", "arm",
                           "treatment", "Treatment", "cohort")

    if (!"time.col"   %in% names(defaults)) defaults$time.col   <- .detect(time_candidates,  col_names)
    if (!"surv.col"   %in% names(defaults)) defaults$surv.col   <- .detect(surv_candidates,  num_cols)
    if (!"n.risk.col" %in% names(defaults)) {
        found <- intersect(nrisk_candidates, col_names)
        defaults$n.risk.col <- if (length(found) > 0) found[1] else ""
    }
    if (!"lower.col"  %in% names(defaults)) {
        found <- intersect(lower_candidates, col_names)
        defaults$lower.col <- if (length(found) > 0) found[1] else ""
    }
    if (!"upper.col"  %in% names(defaults)) {
        found <- intersect(upper_candidates, col_names)
        defaults$upper.col <- if (length(found) > 0) found[1] else ""
    }
    if (!"group.col"  %in% names(defaults)) {
        found <- intersect(group_candidates, col_names)
        defaults$group.col <- if (length(found) > 0) found[1] else ""
    }
    if (!"show.ci"    %in% names(defaults)) defaults$show.ci    <- TRUE
    if (!"title.text" %in% names(defaults)) defaults$title.text <- "Survival Curve"
    if (!"line.type"  %in% names(defaults)) defaults$line.type  <- "solid"

    choices_all <- c("", col_names)
    choices_num <- c("", num_cols)

    # --- Tab: Survival -------------------------------------------------------
    survival_tab <- tagList(
        tipify(
            selectInput(ns("time.col"), "Time Column:",
                choices  = col_names,
                selected = defaults$time.col),
            "Column containing the time variable (x-axis).",
            placement = "top", options = list(container = "body")
        ),
        tipify(
            selectInput(ns("surv.col"), "Survival Column:",
                choices  = choices_num,
                selected = defaults$surv.col),
            "Column containing survival probabilities (0–1 scale; converted to % for display).",
            placement = "top", options = list(container = "body")
        ),
        tipify(
            selectInput(ns("group.col"), "Group Column (optional):",
                choices  = choices_all,
                selected = defaults$group.col),
            "Optional categorical column used to draw one curve per group.",
            placement = "top", options = list(container = "body")
        ),
        tipify(
            selectInput(ns("n.risk.col"), "Number at Risk Column:",
                choices  = choices_all,
                selected = defaults$n.risk.col),
            "Column with the number of subjects still at risk; used for the risk table.",
            placement = "top", options = list(container = "body")
        ),
        tipify(
            selectInput(ns("lower.col"), "Lower 95% CI Column:",
                choices  = choices_all,
                selected = defaults$lower.col),
            "Column with the lower bound of the 95% confidence interval.",
            placement = "top", options = list(container = "body")
        ),
        tipify(
            selectInput(ns("upper.col"), "Upper 95% CI Column:",
                choices  = choices_all,
                selected = defaults$upper.col),
            "Column with the upper bound of the 95% confidence interval.",
            placement = "top", options = list(container = "body")
        ),
        tipify(
            materialSwitch(ns("show.ci"), "Show Confidence Interval:",
                value  = defaults$show.ci,
                status = "success"),
            "Toggle the shaded confidence interval ribbon on/off.",
            placement = "top", options = list(container = "body")
        ),
        tipify(
            textInput(ns("title.text"), "Plot Title:",
                value = defaults$title.text),
            "Main title displayed above the plot.",
            placement = "top", options = list(container = "body")
        )
    )

    # --- Tab: Colors ---------------------------------------------------------
    colors_tab <- tagList(
        uiOutput(ns("palette.selection"))
    )

    # --- Tab: Aesthetics -----------------------------------------------------
    aesthetics_tab <- tagList(
        tipify(
            selectInput(ns("line.type"), "Line Type:",
                choices  = c("solid", "dot", "dash", "longdash",
                             "dashdot", "longdashdot"),
                selected = defaults$line.type),
            "Dash style for the survival curve lines.",
            placement = "top", options = list(container = "body")
        )
    )

    inputs <- list(
        "Survival"   = survival_tab,
        "Colors"     = colors_tab,
        "Aesthetics" = aesthetics_tab
    )

    organize_inputs(
        inputs,
        id      = ns("survivalPlotTabsetPanel"),
        title   = if (!is.null(title)) h3(title) else NULL,
        columns = columns
    )
}


#' Output UI components for the survivalCurvePlot module
#'
#' This should be placed in the UI where the plot and risk table should be shown,
#' with an `id` that matches the `id` used in `survivalCurvePlotServer()` and
#' `survivalCurvePlotInputsUI()`.
#'
#' The output contains two components:
#' \enumerate{
#'   \item An interactive plotly survival curve (resizable).
#'   \item A **Survival Summary Table** below the plot showing the number at
#'     risk and other summary statistics at each time point.
#' }
#'
#' @param id The ID for the Shiny module.
#' @return A Shiny `tagList` containing a resizable plotly output and a DT table.
#'
#' @import shiny
#' @importFrom shinyjqui jqui_resizable
#' @importFrom DT DTOutput
#'
#' @export
#' @author Jacob Martin, Jared Andrews
#' @seealso [sciVizModules::survivalCurvePlotInputsUI()],
#'   [sciVizModules::survivalCurvePlotServer()],
#'   [sciVizModules::survivalCurvePlotApp()]
survivalCurvePlotOutputUI <- function(id) {
    ns <- NS(id)
    tagList(
        jqui_resizable(
            plotlyOutput(ns("survivalPlot"))
        ),
        hr(),
        h4("Survival Summary Table"),
        DT::DTOutput(ns("riskTable"))
    )
}
