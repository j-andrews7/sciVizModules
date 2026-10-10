#' Input UI components for the survivalCurve module
#'
#' This should be placed in the UI where the inputs should be shown, with an `id`
#' that matches the `id` used in the `survivalCurveServer()` and
#' `survivalCurveOutputUI()` functions.
#'
#' @details The user inputs for this module are separated from the outputs to allow for
#' more flexible UI design.
#'
#' The inputs are organized into tabs via the [VizModules::organize_inputs()] function,
#' with `columns` controlling the number of columns in each tab's grid.
#'
#' Defaults can be set for each input by providing a named list of values to the
#' `defaults` argument. The module fits Kaplan-Meier survival curves with
#' [survival::survfit()] and draws them with [survivalCurve()], so it expects a "tidy"
#' survival data frame with a numeric follow-up `time` column and an event `status`
#' column (and, optionally, a categorical column to stratify by).
#'
#' @section Plot parameters and defaults:
#' The following parameters can be accessed via UI inputs and/or the `defaults` argument:
#'
#' - `time` - Follow-up time column (auto-detected from columns named
#'   time/os/pfs/fu, else first numeric column)
#' - `status` - Event/status column (auto-detected from columns named
#'   status/event/vital/dead/censor, else a numeric 0/1 or 1/2 column)
#' - `group.by` - Optional stratification column (default: none)
#' - `conf.int` - Show a confidence band around each curve (UI: "Confidence Band", default: TRUE)
#' - `conf.int.opacity` - Fill opacity of the band, 0 to 1 (UI: "Band Opacity", default: 0.25; shown while
#'   the band is on)
#' - `conf.level` - Confidence level of the band (UI: "Confidence Level", default: 0.95; shown while the band
#'   is on)
#' - `conf.type` - How the band is computed: "log", "log-log" or "plain" (UI: "CI Transform", default: "log",
#'   the [survival::survfit()] default; shown while the band is on)
#' - `pval` - Show log-rank p-value (default: TRUE; only when stratified)
#' - `risk.table` - Show "number at risk" table (default: FALSE)
#' - `censor` - Show censoring marks (default: TRUE)
#' - `surv.median.line` - Median survival reference lines (default: "none")
#' - `fun` - Curve transformation: survival probability, "pct", "event",
#'   or "cumhaz" (default: survival probability)
#' - `line.size` - Line width in pixels (default: 2)
#' - `palette.colours` - Colors for the strata (multiColorPicker), a named character vector mapping
#'   stratum to color
#' - `break.time.by` - Spacing between x-axis ticks and risk table times (default: blank/auto)
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
#' @importFrom shinyWidgets materialSwitch
#'
#' @export
#' @author Jacob Martin
#' @seealso [survival::survfit()], [VizModules::organize_inputs()],
#' [sciVizModules::survivalCurveOutputUI()], [sciVizModules::survivalCurveServer()],
#' [sciVizModules::survivalCurveApp()]
#' @examples
#' library(sciVizModules)
#' data(survival_lung)
#' survivalCurveInputsUI("survivalCurve", survival_lung)
survivalCurveInputsUI <- function(id, data, defaults = NULL, title = "Survival Curve Settings", columns = 2) {
    ns <- NS(id)
    d <- .surv_defaults(data, defaults)
    if (is.null(defaults)) {
        defaults <- list()
    }

    num.choices <- names(data)[vapply(data, is.numeric, logical(1))]
    # Strata with too many levels to draw (an ID column) are left out.
    cat.choices <- .sci_discrete_cols(data)
    group.choices <- c("None" = "", stats::setNames(cat.choices, cat.choices))

    inputs <- list(
        "Data" = tagList(
            .sci_tip(viz_select_input(ns("time"), "Time", choices = num.choices, selected = d$time),
                "Numeric follow-up time column."),
            .sci_tip(viz_select_input(ns("status"), "Status (Event)", choices = names(data), selected = d$status),
                paste(
                    "Event indicator column. Accepts 0/1 (1 = event), 1/2 (2 = event),",
                    "logical, or a two-level factor/character."
                )),
            .sci_tip(viz_select_input(ns("group.by"), "Group By", choices = group.choices, selected = d$group.by),
                "Optional categorical column to stratify the curves by.")
        ),
        "Statistics" = tagList(
            .sci_tip(materialSwitch(ns("conf.int"), "Confidence Band",
                value = isTRUE(d$conf.int), status = "success"),
                "Shade the confidence interval of each curve, in its colour."),
            .sci_tip(numericInput(ns("conf.level"), "Confidence Level",
                value = d$conf.level, min = 0.5, max = 0.999, step = 0.01),
                "Confidence level of the band."),
            .sci_tip(viz_select_input(ns("conf.type"), "CI Transform",
                choices = .surv_conf_type_choices, selected = d$conf.type),
                paste(
                    "Scale the interval is computed on. Log (the survival package default) and log-log",
                    "keep the band within 0 and 1; plain is the symmetric Greenwood interval."
                )),
            .sci_tip(numericInput(ns("conf.int.opacity"), "Band Opacity",
                value = d$conf.int.opacity, min = 0, max = 1, step = 0.05),
                "Fill opacity of the confidence band."),
            .sci_tip(materialSwitch(ns("pval"), "Log-rank p-value", value = isTRUE(d$pval), status = "success"),
                "Show the log-rank test p-value (only shown when stratified by a group)."),
            .sci_tip(materialSwitch(ns("risk.table"), "Risk Table", value = isTRUE(d$risk.table), status = "success"),
                "Append a 'number at risk' table beneath the curve."),
            .sci_tip(materialSwitch(ns("censor"), "Censoring Marks", value = isTRUE(d$censor), status = "success"),
                "Draw marks where observations were censored."),
            .sci_tip(viz_select_input(ns("surv.median.line"), "Median Survival Line",
                choices = c("none", "hv", "h", "v"), selected = d$surv.median.line),
                "Draw reference lines at the median survival time (survival probability or percentage curves).")
        ),
        "Aesthetics" = tagList(
            .sci_tip(viz_select_input(ns("fun"), "Curve Type",
                choices = .surv_fun_choices, selected = d$fun),
                "Transformation applied to the survival curve and its band."),
            uiOutput(ns("palette.selection")),
            .sci_tip(numericInput(ns("line.size"), "Line Width",
                value = d$line.size, min = 0.1, step = 0.5),
                "Width of the survival curve lines, in pixels."),
            .sci_tip(numericInput(ns("break.time.by"), "Time Axis Spacing",
                value = d$break.time.by, min = 0),
                "Spacing between time axis ticks, which the risk table also counts at. Blank for automatic.")
        ),
        "Plotly" = uniform_plotly_inputs_ui(ns, defaults),
        "Axes" = uniform_axes_inputs_ui(ns, defaults, include.rotate = FALSE),
        "Legend" = uniform_legend_inputs_ui(ns, defaults),
        "Lines" = uniform_lines_inputs_ui(ns, defaults)
    )

    organize_inputs(
        inputs,
        id = ns("survivalCurveTabsetPanel"),
        title = if (is.null(title)) {
            NULL
        } else if (inherits(title, "shiny.tag") || inherits(title, "shiny.tag.list")) {
            title
        } else {
            h3(title)
        },
        tack = module_tack_ui(ns, defaults = defaults),
        columns = columns
    )
}


#' Output UI components for the survivalCurve module
#'
#' This should be placed in the UI where the plot should be shown.
#'
#' @param id The ID for the Shiny module.
#' @param resizable Logical; when `TRUE` (the default) the plot output is
#'   wrapped in [shinyjqui::jqui_resizable()] so it can be resized by dragging.
#'
#' @return A Shiny plotlyOutput for the survival curve
#'
#' @import shiny
#' @import plotly
#' @importFrom shinyjqui jqui_resizable
#'
#'
#' @examples
#' survivalCurveOutputUI("plot")
#' @export
#' @author Jacob Martin
survivalCurveOutputUI <- function(id, resizable = TRUE) {
    ns <- NS(id)
    plot_output <- plotlyOutput(ns("survivalCurve"))
    if (isTRUE(resizable)) {
        plot_output <- shinyjqui::jqui_resizable(plot_output)
    }
    plot_output
}
