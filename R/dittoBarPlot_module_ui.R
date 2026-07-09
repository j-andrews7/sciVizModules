#' Input UI components for the dittoBarPlot module
#'
#' This should be placed in the UI where the inputs should be shown, with an `id`
#' that matches the `id` used in the `dittoBarPlotServer()` and
#' `dittoBarPlotOutputUI()` functions.
#'
#' @details The user inputs for this module are separated from the outputs to allow for
#' more flexible UI design.
#'
#' This module wraps [dittoSeq::dittoBarPlot()], showing the composition (counts
#' or percentages) of a discrete `var` across discrete `group.by` groups as a
#' stacked bar plot. The resulting `ggplot` is converted to an interactive
#' `plotly` figure.
#'
#' @section Plot parameters and defaults:
#' The following parameters can be accessed via UI inputs and/or the \code{defaults} argument:
#' \itemize{
#'   \item \code{var} - Discrete metadata to quantify within each group
#'   \item \code{group.by} - Discrete metadata used for the x-axis groups
#'   \item \code{scale} - "percent" or "count" (default: "percent")
#'   \item \code{split.by} - Discrete metadata to facet by (default: none)
#'   \item \code{split.nrow}, \code{split.ncol} - Number of rows/columns for the facet
#'     layout when \code{split.by} is set (default: automatic)
#'   \item \code{x.labels.rotate} - Rotate x-axis labels (default: TRUE)
#'   \item \code{palette.selection} - Colors for the `var` levels (multiColorPicker)
#' }
#'
#' @param id The ID for the Shiny module.
#' @param data A `SingleCellExperiment`, `Seurat`, or `SummarizedExperiment` object
#'   used to populate the input choices.
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
#' @author Jared Andrews
#' @seealso [dittoSeq::dittoBarPlot()], [VizModules::organize_inputs()],
#' [sciVizModules::dittoBarPlotOutputUI()], [sciVizModules::dittoBarPlotServer()],
#' [sciVizModules::dittoBarPlotApp()]
#' @examples
#' library(sciVizModules)
#' data(example_sce)
#' dittoBarPlotInputsUI("dittoBarPlot", example_sce)
dittoBarPlotInputsUI <- function(id, data, defaults = NULL, title = "BarPlot Settings", columns = 2) {
    ns <- NS(id)
    .assert_ditto_object(data, "data")

    if (is.null(defaults)) defaults <- list()

    disc <- .ditto_discrete_metas(data)
    var.choices <- stats::setNames(disc, disc)
    group.choices <- stats::setNames(disc, disc)
    split.choices <- c("None" = "", stats::setNames(disc, disc))

    default.var <- .ditto_default(defaults, "var", if (length(disc)) disc[1] else "")
    default.group <- .ditto_default(defaults, "group.by",
        if (length(disc) >= 2) disc[2] else if (length(disc)) disc[1] else "")

    inputs <- list(
        "Data" = tagList(
            tipify(selectInput(ns("var"), "Variable",
                choices = var.choices,
                selected = default.var, selectize = FALSE
            ), "Discrete metadata whose composition is quantified within each group.",
                placement = "top", options = list(container = "body")),
            tipify(selectInput(ns("group.by"), "Group By",
                choices = group.choices,
                selected = default.group, selectize = FALSE
            ), "Discrete metadata used to separate the data into x-axis groups.",
                placement = "top", options = list(container = "body")),
            tipify(selectInput(ns("scale"), "Scale",
                choices = c("Percent" = "percent", "Count" = "count"),
                selected = .ditto_default(defaults, "scale", "percent"), selectize = FALSE
            ), "Show composition as a percentage or as raw counts.",
                placement = "top", options = list(container = "body")),
            tipify(selectInput(ns("split.by"), "Split By (facet)",
                choices = split.choices,
                selected = .ditto_default(defaults, "split.by", ""), selectize = FALSE
            ), "Discrete metadata to split the plot into facets.",
                placement = "top", options = list(container = "body")),
            tipify(numericInput(ns("split.nrow"), "Facet Rows",
                value = .ditto_default(defaults, "split.nrow", NA), min = 1, step = 1),
                "Number of rows for the facet layout (leave blank for automatic).",
                placement = "top", options = list(container = "body")),
            tipify(numericInput(ns("split.ncol"), "Facet Columns",
                value = .ditto_default(defaults, "split.ncol", NA), min = 1, step = 1),
                "Number of columns for the facet layout (leave blank for automatic).",
                placement = "top", options = list(container = "body"))
        ),
        "Aesthetics" = tagList(
            uiOutput(ns("palette.selection")),
            tipify(materialSwitch(ns("x.labels.rotate"), "Rotate X Labels",
                value = .ditto_default(defaults, "x.labels.rotate", TRUE), status = "success"),
                "Rotate the x-axis group labels by 45 degrees.",
                placement = "top", options = list(container = "body")),
            tipify(materialSwitch(ns("retain.factor.levels"), "Retain Factor Levels",
                value = .ditto_default(defaults, "retain.factor.levels", FALSE), status = "success"),
                "Respect factor level ordering of the var and grouping data.",
                placement = "top", options = list(container = "body"))
        ),
        "Plotly" = uniform_plotly_inputs_ui(ns, defaults),
        "Axes" = uniform_axes_inputs_ui(ns, defaults, include.rotate = TRUE),
        "Legend" = uniform_legend_inputs_ui(ns, defaults),
        "Lines" = uniform_lines_inputs_ui(ns, defaults)
    )

    organize_inputs(
        inputs,
        id = ns("dittoBarPlotTabsetPanel"),
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


#' Output UI components for the dittoBarPlot module
#'
#' This should be placed in the UI where the plot should be shown.
#'
#' @param id The ID for the Shiny module.
#' @param resizable Logical; when \code{TRUE} (the default) the plot output is
#'   wrapped in [shinyjqui::jqui_resizable()] so it can be resized by dragging.
#'
#' @return A Shiny plotlyOutput for the bar plot.
#'
#' @import shiny
#' @import plotly
#' @importFrom shinyjqui jqui_resizable
#'
#' @export
#' @author Jared Andrews
dittoBarPlotOutputUI <- function(id, resizable = TRUE) {
    ns <- NS(id)
    plot_output <- plotlyOutput(ns("dittoBarPlot"))
    if (isTRUE(resizable)) {
        plot_output <- shinyjqui::jqui_resizable(plot_output)
    }
    plot_output
}
