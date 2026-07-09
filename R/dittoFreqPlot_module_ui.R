#' Input UI components for the dittoFreqPlot module
#'
#' This should be placed in the UI where the inputs should be shown, with an `id`
#' that matches the `id` used in the `dittoFreqPlotServer()` and
#' `dittoFreqPlotOutputUI()` functions.
#'
#' @details The user inputs for this module are separated from the outputs to allow for
#' more flexible UI design.
#'
#' This module wraps [dittoSeq::dittoFreqPlot()], which computes the per-sample
#' frequency (or count) of each level of a discrete `var` and plots those
#' frequencies across groups as jitter/box/violin/ridge representations. The
#' resulting `ggplot` is converted to an interactive `plotly` figure.
#'
#' @section Plot parameters and defaults:
#' The following parameters can be accessed via UI inputs and/or the \code{defaults} argument:
#' \itemize{
#'   \item \code{var} - Discrete metadata whose frequencies are computed
#'   \item \code{sample.by} - Discrete metadata identifying individual samples
#'   \item \code{group.by} - Discrete metadata used for the x-axis groups
#'   \item \code{color.by} - Discrete metadata used for fill colors (default: `group.by`)
#'   \item \code{scale} - "percent" or "count" (default: "percent")
#'   \item \code{plots} - Representations to draw (default: c("boxplot", "jitter"))
#'   \item \code{max.normalize} - Scale each facet to its own max (default: FALSE)
#'   \item \code{jitter.size} - Jitter point size (default: 1)
#'   \item \code{jitter.width} - Horizontal spread of the jitter points (default: 0.2)
#'   \item \code{boxplot.width} - Width of the boxplots (default: 0.4)
#'   \item \code{vlnplot.width} - Relative width of the violins (default: 1)
#'   \item \code{palette.selection} - Colors for discrete groups (multiColorPicker)
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
#' @seealso [dittoSeq::dittoFreqPlot()], [VizModules::organize_inputs()],
#' [sciVizModules::dittoFreqPlotOutputUI()], [sciVizModules::dittoFreqPlotServer()],
#' [sciVizModules::dittoFreqPlotApp()]
#' @examples
#' library(sciVizModules)
#' data(example_sce)
#' dittoFreqPlotInputsUI("dittoFreqPlot", example_sce)
dittoFreqPlotInputsUI <- function(id, data, defaults = NULL, title = "FreqPlot Settings", columns = 2) {
    ns <- NS(id)
    .assert_ditto_object(data, "data")

    if (is.null(defaults)) defaults <- list()

    disc <- .ditto_discrete_metas(data)
    var.choices <- stats::setNames(disc, disc)
    group.choices <- stats::setNames(disc, disc)
    sample.choices <- c("None" = "", stats::setNames(disc, disc))
    color.choices <- c("Same as Group" = "", stats::setNames(disc, disc))

    default.var <- .ditto_default(defaults, "var", if (length(disc)) disc[1] else "")
    default.group <- .ditto_default(defaults, "group.by",
        if (length(disc) >= 2) disc[2] else if (length(disc)) disc[1] else "")

    inputs <- list(
        "Data" = tagList(
            tipify(selectInput(ns("var"), "Variable",
                choices = var.choices,
                selected = default.var, selectize = FALSE
            ), "Discrete metadata whose per-sample frequencies are computed.",
                placement = "top", options = list(container = "body")),
            tipify(selectInput(ns("sample.by"), "Sample By",
                choices = sample.choices,
                selected = .ditto_default(defaults, "sample.by", ""), selectize = FALSE
            ), "Discrete metadata identifying individual samples (one frequency per sample).",
                placement = "top", options = list(container = "body")),
            tipify(selectInput(ns("group.by"), "Group By",
                choices = group.choices,
                selected = default.group, selectize = FALSE
            ), "Discrete metadata used to separate the samples into x-axis groups.",
                placement = "top", options = list(container = "body")),
            tipify(selectInput(ns("color.by"), "Color By",
                choices = color.choices,
                selected = .ditto_default(defaults, "color.by", ""), selectize = FALSE
            ), "Discrete metadata used for fill colors. Defaults to the grouping.",
                placement = "top", options = list(container = "body")),
            tipify(selectInput(ns("scale"), "Scale",
                choices = c("Percent" = "percent", "Count" = "count"),
                selected = .ditto_default(defaults, "scale", "percent"), selectize = FALSE
            ), "Show frequencies as a percentage or as raw counts.",
                placement = "top", options = list(container = "body")),
            tipify(checkboxGroupInput(ns("plots"), "Representations",
                choices = c("Jitter" = "jitter", "Box" = "boxplot",
                    "Violin" = "vlnplot", "Ridge" = "ridgeplot"),
                selected = .ditto_default(defaults, "plots", c("boxplot", "jitter"))
            ), "Data representations to draw, from back to front.",
                placement = "top", options = list(container = "body"))
        ),
        "Aesthetics" = tagList(
            uiOutput(ns("palette.selection")),
            tipify(materialSwitch(ns("max.normalize"), "Max Normalize",
                value = .ditto_default(defaults, "max.normalize", FALSE), status = "success"),
                "Scale each var-level's frequencies to its own maximum.",
                placement = "top", options = list(container = "body")),
            tipify(numericInput(ns("jitter.size"), "Jitter Size",
                value = .ditto_default(defaults, "jitter.size", 1), min = 0.1, step = 0.1),
                "Size of the jitter points.",
                placement = "top", options = list(container = "body")),
            tipify(numericInput(ns("jitter.width"), "Jitter Width",
                value = .ditto_default(defaults, "jitter.width", 0.2), min = 0, step = 0.05),
                "Horizontal spread of the jitter points.",
                placement = "top", options = list(container = "body")),
            tipify(numericInput(ns("boxplot.width"), "Box Width",
                value = .ditto_default(defaults, "boxplot.width", 0.4), min = 0, step = 0.05),
                "Width of the boxplots.",
                placement = "top", options = list(container = "body")),
            tipify(numericInput(ns("vlnplot.width"), "Violin Width",
                value = .ditto_default(defaults, "vlnplot.width", 1), min = 0, step = 0.05),
                "Relative width of the violins.",
                placement = "top", options = list(container = "body"))
        ),
        "Plotly" = uniform_plotly_inputs_ui(ns, defaults),
        "Axes" = uniform_axes_inputs_ui(ns, defaults, include.rotate = TRUE),
        "Legend" = uniform_legend_inputs_ui(ns, defaults),
        "Lines" = uniform_lines_inputs_ui(ns, defaults)
    )

    organize_inputs(
        inputs,
        id = ns("dittoFreqPlotTabsetPanel"),
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


#' Output UI components for the dittoFreqPlot module
#'
#' This should be placed in the UI where the plot should be shown.
#'
#' @param id The ID for the Shiny module.
#' @param resizable Logical; when \code{TRUE} (the default) the plot output is
#'   wrapped in [shinyjqui::jqui_resizable()] so it can be resized by dragging.
#'
#' @return A Shiny plotlyOutput for the frequency plot.
#'
#' @import shiny
#' @import plotly
#' @importFrom shinyjqui jqui_resizable
#'
#' @export
#' @author Jared Andrews
dittoFreqPlotOutputUI <- function(id, resizable = TRUE) {
    ns <- NS(id)
    plot_output <- plotlyOutput(ns("dittoFreqPlot"))
    if (isTRUE(resizable)) {
        plot_output <- shinyjqui::jqui_resizable(plot_output)
    }
    plot_output
}
