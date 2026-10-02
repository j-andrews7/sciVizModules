#' Input UI components for the forestPlot module
#'
#' This should be placed in the UI where the inputs should be shown, with an `id`
#' that matches the `id` used in the `forestPlotServer()` and
#' `forestPlotOutputUI()` functions.
#'
#' @details The user inputs for this module are separated from the outputs to allow for
#' more flexible UI design.
#'
#' The module fits a model to the raw data and draws each covariate's effect
#' estimate and confidence interval with [forestPlot()]: hazard ratios from a
#' Cox model ([survival::coxph()]), odds ratios from a logistic regression
#' ([stats::glm()]), or coefficients from a linear regression ([stats::lm()]).
#' The inputs are organized into tabs via [VizModules::organize_inputs()].
#'
#' @section Plot parameters and defaults:
#' The following parameters can be accessed via UI inputs and/or the `defaults` argument:
#'
#' - `model` - `"cox"`, `"logistic"` or `"linear"` (default: `"cox"`)
#' - `time` - Follow-up time column, Cox only (auto-detected as in [survivalCurveInputsUI()])
#' - `status` - Event column, Cox only (auto-detected as in [survivalCurveInputsUI()])
#' - `outcome` - Outcome column, logistic and linear only (default: the status column)
#' - `covariates` - Covariate columns (default: the first three other columns)
#' - `multivariable` - Fit all covariates in one model rather than one model each (default: TRUE)
#' - `conf.level` - Confidence level (default: 0.95)
#' - `show.reference` - Show a row for each factor's reference level (default: TRUE)
#' - `show.table` - Print estimate, interval and p-value beside each row (default: TRUE)
#' - `sort.by` - `"input"` order or by `"estimate"` (default: `"input"`)
#' - `digits` - Decimal places in the printed estimates (default: 2)
#' - `point.color`, `point.size`, `ci.color`, `ci.width` - Marker and interval styling
#' - `margin.r` - Right margin in pixels, which holds the estimate table (default: 260)
#'
#' The Axes, Lines and Plotly tabs carry the shared VizModules inputs. A forest
#' plot has no legend, so there is no Legend tab.
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
#' @importFrom colourpicker colourInput
#'
#' @export
#' @author Jared Andrews
#' @seealso [forestPlot()], [VizModules::organize_inputs()],
#' [sciVizModules::forestPlotOutputUI()], [sciVizModules::forestPlotServer()],
#' [sciVizModules::forestPlotApp()]
#' @examples
#' library(sciVizModules)
#' data(survival_lung)
#' forestPlotInputsUI("forest", survival_lung)
forestPlotInputsUI <- function(id, data, defaults = NULL, title = "Forest Plot Settings", columns = 2) {
    ns <- NS(id)
    defaults <- .forest_defaults(data, defaults)
    tip <- function(tag, text) tipify(tag, text, placement = "top", options = list(container = "body"))

    num.choices <- names(data)[vapply(data, is.numeric, logical(1))]

    inputs <- list(
        "Data" = tagList(
            tip(viz_select_input(ns("model"), "Model",
                choices = c("Cox (hazard ratio)" = "cox", "Logistic (odds ratio)" = "logistic",
                    "Linear (coefficient)" = "linear"),
                selected = get_default(defaults, "model", "cox")
            ), "Regression model fitted to the data."),
            tip(viz_select_input(ns("time"), "Time",
                choices = num.choices, selected = get_default(defaults, "time", NULL)
            ), "Numeric follow-up time column (Cox model)."),
            tip(viz_select_input(ns("status"), "Status (Event)",
                choices = names(data), selected = get_default(defaults, "status", NULL)
            ), paste(
                "Event indicator column (Cox model). Accepts 0/1 (1 = event), 1/2 (2 = event),",
                "logical, or a factor/character with an event label such as 'dead'."
            )),
            tip(viz_select_input(ns("outcome"), "Outcome",
                choices = names(data), selected = get_default(defaults, "outcome", NULL)
            ), paste(
                "Outcome column. Logistic: binary (0/1, logical, or two levels, the second being",
                "the event). Linear: numeric."
            )),
            tip(viz_select_input(ns("covariates"), "Covariates",
                choices = names(data), selected = get_default(defaults, "covariates", NULL),
                multiple = TRUE
            ), paste(
                "Covariates to estimate effects for. Factors get one row per level against the",
                "first (reference) level."
            )),
            tip(materialSwitch(ns("multivariable"), "Multivariable",
                value = get_default(defaults, "multivariable", TRUE, is.logical), status = "success"
            ), "On: one model with every covariate (adjusted estimates). Off: one model per covariate."),
            tip(numericInput(ns("conf.level"), "Confidence Level",
                value = get_default(defaults, "conf.level", 0.95, is.numeric), min = 0.5, max = 0.999,
                step = 0.01
            ), "Confidence level of the (Wald) intervals.")
        ),
        "Aesthetics" = tagList(
            tip(materialSwitch(ns("show.reference"), "Reference Rows",
                value = get_default(defaults, "show.reference", TRUE, is.logical), status = "success"
            ), "Show a row for each factor's reference level."),
            tip(materialSwitch(ns("show.table"), "Estimate Table",
                value = get_default(defaults, "show.table", TRUE, is.logical), status = "success"
            ), "Print the estimate, interval and p-value beside each row, in the right margin."),
            tip(viz_select_input(ns("sort.by"), "Row Order",
                choices = c("As entered" = "input", "By estimate" = "estimate"),
                selected = get_default(defaults, "sort.by", "input")
            ), "Order of the rows, top to bottom."),
            tip(numericInput(ns("digits"), "Decimal Places",
                value = get_default(defaults, "digits", 2, is.numeric), min = 0, max = 6, step = 1
            ), "Decimal places in the printed estimates."),
            tip(colourInput(ns("point.color"), "Point Color",
                value = get_default(defaults, "point.color", "#000000")
            ), "Colour of the estimate markers."),
            tip(numericInput(ns("point.size"), "Point Size",
                value = get_default(defaults, "point.size", 10, is.numeric), min = 1, step = 1
            ), "Size of the estimate markers."),
            tip(colourInput(ns("ci.color"), "Interval Color",
                value = get_default(defaults, "ci.color", "#000000")
            ), "Colour of the confidence interval lines."),
            tip(numericInput(ns("ci.width"), "Interval Width",
                value = get_default(defaults, "ci.width", 2, is.numeric), min = 0.5, step = 0.5
            ), "Line width of the confidence intervals.")
        ),
        "Axes" = uniform_axes_inputs_ui(ns, defaults),
        "Lines" = uniform_lines_inputs_ui(ns, defaults),
        "Plotly" = uniform_plotly_inputs_ui(ns, defaults)
    )

    organize_inputs(
        inputs,
        id = ns("forestPlotTabsetPanel"),
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


#' Output UI components for the forestPlot module
#'
#' This should be placed in the UI where the plot should be shown.
#'
#' @param id The ID for the Shiny module.
#' @param resizable Logical; when `TRUE` (the default) the plot output is
#'   wrapped in [shinyjqui::jqui_resizable()] so it can be resized by dragging.
#'
#' @return A Shiny plotlyOutput for the forest plot.
#'
#' @import shiny
#' @importFrom plotly plotlyOutput
#' @importFrom shinyjqui jqui_resizable
#'
#' @examples
#' forestPlotOutputUI("forest")
#' @export
#' @author Jared Andrews
forestPlotOutputUI <- function(id, resizable = TRUE) {
    ns <- NS(id)
    plot_output <- plotlyOutput(ns("forestPlot"))
    if (isTRUE(resizable)) {
        plot_output <- jqui_resizable(plot_output)
    }
    plot_output
}
