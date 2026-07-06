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
#' `defaults` argument. The module builds Kaplan-Meier survival curves with the
#' [survminer::ggsurvplot()] engine, so it expects a "tidy" survival data frame with a
#' numeric follow-up `time` column and an event `status` column (and, optionally, a
#' categorical column to stratify by).
#'
#' @section Plot parameters and defaults:
#' The following parameters can be accessed via UI inputs and/or the \code{defaults} argument:
#' \itemize{
#'   \item \code{time} - Follow-up time column (auto-detected from columns named
#'     time/os/pfs/fu, else first numeric column)
#'   \item \code{status} - Event/status column (auto-detected from columns named
#'     status/event/vital/dead/censor, else a numeric 0/1 or 1/2 column)
#'   \item \code{group.by} - Optional stratification column (default: none)
#'   \item \code{conf.int} - Show confidence interval ribbons (default: TRUE)
#'   \item \code{pval} - Show log-rank p-value (default: TRUE; only when stratified)
#'   \item \code{pval.size} - Font size (px) of the p-value annotation (default: 14)
#'   \item \code{pval.color} - Color of the p-value annotation (default: "black")
#'   \item \code{risk.table} - Show "number at risk" table (default: FALSE)
#'   \item \code{censor} - Show censoring marks (default: TRUE)
#'   \item \code{surv.median.line} - Median survival reference lines (default: "none")
#'   \item \code{fun} - Curve transformation: survival probability, "pct", "event",
#'     or "cumhaz" (default: survival probability)
#'   \item \code{line.size} - Line width (default: 1)
#'   \item \code{palette.selection} - Colors for the strata (multiColorPicker)
#'   \item \code{title}, \code{xlab}, \code{ylab}, \code{legend.title} - Text labels
#'   \item \code{break.time.by} - Spacing between x-axis ticks (default: blank/auto)
#'   \item \code{xlim.min}, \code{xlim.max} - X-axis limits (default: blank/auto)
#' }
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
#' @author Jacob Martin
#' @seealso [survminer::ggsurvplot()], [VizModules::organize_inputs()],
#' [sciVizModules::survivalCurveOutputUI()], [sciVizModules::survivalCurveServer()],
#' [sciVizModules::survivalCurveApp()]
#' @examples
#' library(sciVizModules)
#' data(survival_lung)
#' survivalCurveInputsUI("survivalCurve", survival_lung)
survivalCurveInputsUI <- function(id, data, defaults = NULL, title = "Survival Curve Settings", columns = 2) {
    ns <- NS(id)

    if (is.null(defaults)) {
        defaults <- list()
    }

    num.choices <- names(data)[vapply(data, is.numeric, logical(1))]
    cat.choices <- names(data)[vapply(data, function(x) !is.numeric(x), logical(1))]

    # Auto-detect sensible defaults for the survival-specific columns.
    if (!"time" %in% names(defaults)) defaults$time <- .detect_time_col(data, num.choices)
    if (!"status" %in% names(defaults)) defaults$status <- .detect_status_col(data, num.choices)
    if (!"group.by" %in% names(defaults)) defaults$group.by <- ""

    group.choices <- c("None" = "", stats::setNames(cat.choices, cat.choices))

    inputs <- list(
        "Data" = tagList(
            tipify(selectInput(ns("time"), "Time",
                choices = num.choices,
                selected = .sv_default(defaults, "time", if (length(num.choices)) num.choices[1] else NULL),
                selectize = FALSE
            ), "Numeric follow-up time column.", placement = "top", options = list(container = "body")),
            tipify(selectInput(ns("status"), "Status (Event)",
                choices = names(data),
                selected = .sv_default(defaults, "status", NULL),
                selectize = FALSE
            ), paste(
                "Event indicator column. Accepts 0/1 (1 = event), 1/2 (2 = event),",
                "logical, or a two-level factor/character."
            ), placement = "top", options = list(container = "body")),
            tipify(selectInput(ns("group.by"), "Group By",
                choices = group.choices,
                selected = .sv_default(defaults, "group.by", ""),
                selectize = FALSE
            ), "Optional categorical column to stratify the curves by.",
                placement = "top", options = list(container = "body"))
        ),
        "Statistics" = tagList(
            tipify(materialSwitch(ns("pval"), "Log-rank p-value",
                value = .sv_default(defaults, "pval", TRUE), status = "success"),
                "Show the log-rank test p-value (only shown when stratified by a group).",
                placement = "top", options = list(container = "body")),
            tipify(numericInput(ns("pval.size"), "P-value Text Size",
                value = .sv_default(defaults, "pval.size", 14), min = 1, step = 1),
                "Font size (px) of the p-value annotation. Drag the annotation to reposition it.",
                placement = "top", options = list(container = "body")),
            tipify(colourpicker::colourInput(ns("pval.color"), "P-value Text Color",
                value = .sv_default(defaults, "pval.color", "black")),
                "Color of the p-value annotation.",
                placement = "top", options = list(container = "body")),
            tipify(materialSwitch(ns("risk.table"), "Risk Table",
                value = .sv_default(defaults, "risk.table", FALSE), status = "success"),
                "Append a 'number at risk' table beneath the curve.",
                placement = "top", options = list(container = "body")),
            tipify(materialSwitch(ns("censor"), "Censoring Marks",
                value = .sv_default(defaults, "censor", TRUE), status = "success"),
                "Draw marks where observations were censored.",
                placement = "top", options = list(container = "body")),
            tipify(selectInput(ns("surv.median.line"), "Median Survival Line",
                choices = c("none", "hv", "h", "v"),
                selected = .sv_default(defaults, "surv.median.line", "none"), selectize = FALSE
            ), "Draw reference lines at the median survival time.",
                placement = "top", options = list(container = "body"))
        ),
        "Aesthetics" = tagList(
            tipify(selectInput(ns("fun"), "Curve Type",
                choices = c(
                    "Survival probability" = "survival",
                    "Survival percentage" = "pct",
                    "Cumulative events" = "event",
                    "Cumulative hazard" = "cumhaz"
                ),
                selected = .sv_default(defaults, "fun", "survival"), selectize = FALSE
            ), "Transformation applied to the survival curve.",
                placement = "top", options = list(container = "body")),
            uiOutput(ns("palette.selection")),
            tipify(numericInput(ns("line.size"), "Line Width",
                value = .sv_default(defaults, "line.size", 1), min = 0.1, step = 0.1),
                "Width of the survival curve lines.",
                placement = "top", options = list(container = "body"))
        ),
        "Labels" = tagList(
            tipify(textInput(ns("title"), "Title",
                value = .sv_default(defaults, "title", "")),
                "Plot title.", placement = "top", options = list(container = "body")),
            tipify(textInput(ns("xlab"), "X-axis Label",
                value = .sv_default(defaults, "xlab", "Time")),
                "X-axis title.", placement = "top", options = list(container = "body")),
            tipify(textInput(ns("ylab"), "Y-axis Label",
                value = .sv_default(defaults, "ylab", "Survival probability")),
                "Y-axis title.", placement = "top", options = list(container = "body")),
            tipify(textInput(ns("legend.title"), "Legend Title",
                value = .sv_default(defaults, "legend.title", "")),
                "Legend title (defaults to the grouping column when stratified).",
                placement = "top", options = list(container = "body")),
            tipify(numericInput(ns("break.time.by"), "Time Axis Interval",
                value = .sv_default(defaults, "break.time.by", NA), min = 0),
                "Spacing between x-axis tick marks. Leave blank to auto-compute.",
                placement = "top", options = list(container = "body")),
            tipify(numericInput(ns("xlim.min"), "X Min",
                value = .sv_default(defaults, "xlim.min", NA)),
                "Lower x-axis limit. Leave blank to auto-compute.",
                placement = "top", options = list(container = "body")),
            tipify(numericInput(ns("xlim.max"), "X Max",
                value = .sv_default(defaults, "xlim.max", NA)),
                "Upper x-axis limit. Leave blank to auto-compute.",
                placement = "top", options = list(container = "body"))
        ),
        "Plotly" = uniform_plotly_inputs_ui(ns, defaults),
        "Axes" = uniform_axes_inputs_ui(ns, defaults, include.rotate = TRUE),
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
#' @param resizable Logical; when \code{TRUE} (the default) the plot output is
#'   wrapped in [shinyjqui::jqui_resizable()] so it can be resized by dragging.
#'
#' @return A Shiny plotlyOutput for the survival curve
#'
#' @import shiny
#' @import plotly
#' @importFrom shinyjqui jqui_resizable
#'
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
