#' Input UI components for the dittoPlot module
#'
#' This should be placed in the UI where the inputs should be shown, with an `id`
#' that matches the `id` used in the `dittoPlotServer()` and
#' `dittoPlotOutputUI()` functions.
#'
#' @details The user inputs for this module are separated from the outputs to allow for
#' more flexible UI design.
#'
#' This module wraps [dittoSeq::dittoPlot()], plotting continuous data (gene
#' expression or numeric metadata) per discrete group as any combination of
#' jitter, violin, box, and ridge representations. The resulting `ggplot` is
#' converted to an interactive `plotly` figure.
#'
#' @section Plot parameters and defaults:
#' The following parameters can be accessed via UI inputs and/or the \code{defaults} argument:
#' \itemize{
#'   \item \code{var} - Continuous variable to plot (gene or numeric metadata)
#'   \item \code{group.by} - Discrete metadata used for the x-axis groups
#'   \item \code{color.by} - Discrete metadata used for fill colors (default: `group.by`)
#'   \item \code{plots} - Representations to draw (default: c("jitter", "vlnplot"))
#'   \item \code{split.by} - Discrete metadata to facet by (default: none)
#'   \item \code{jitter.size} - Jitter point size (default: 1)
#'   \item \code{vlnplot.width} - Width of the violins (default: 1)
#'   \item \code{vlnplot.scaling} - Violin scaling method: "area", "count", or "width"
#'     (default: "area")
#'   \item \code{boxplot.lineweight} - Line weight of the boxplot outlines (default: 1)
#'   \item \code{ridgeplot.scale} - Ridge overlap scale (default: 1.25)
#'   \item \code{ridgeplot.lineweight} - Line weight of the ridge outlines (default: 1)
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
#'
#' @export
#' @author Jared Andrews
#' @seealso [dittoSeq::dittoPlot()], [VizModules::organize_inputs()],
#' [sciVizModules::dittoPlotOutputUI()], [sciVizModules::dittoPlotServer()],
#' [sciVizModules::dittoPlotApp()]
#' @examples
#' library(sciVizModules)
#' data(example_sce)
#' dittoPlotInputsUI("dittoPlot", example_sce)
dittoPlotInputsUI <- function(id, data, defaults = NULL, title = "dittoPlot Settings", columns = 2) {
    ns <- NS(id)
    .assert_ditto_object(data, "data")

    if (is.null(defaults)) defaults <- list()

    cont.choices <- .ditto_continuous_choices(data, include.blank = FALSE)
    cont.flat <- unlist(cont.choices, use.names = FALSE)
    disc <- .ditto_discrete_metas(data)
    group.choices <- stats::setNames(disc, disc)
    color.choices <- c("Same as Group" = "", stats::setNames(disc, disc))

    default.var <- .ditto_default(defaults, "var", if (length(cont.flat)) cont.flat[1] else "")
    default.group <- .ditto_default(defaults, "group.by", if (length(disc)) disc[1] else "")

    inputs <- list(
        "Data" = tagList(
            tipify(selectInput(ns("var"), "Variable (gene / metadata)",
                choices = cont.choices,
                selected = default.var, selectize = FALSE
            ), "Continuous gene or metadata plotted on the y-axis.",
                placement = "top", options = list(container = "body")),
            tipify(selectInput(ns("group.by"), "Group By",
                choices = group.choices,
                selected = default.group, selectize = FALSE
            ), "Discrete metadata used to separate the data into x-axis groups.",
                placement = "top", options = list(container = "body")),
            tipify(selectInput(ns("color.by"), "Color By",
                choices = color.choices,
                selected = .ditto_default(defaults, "color.by", ""), selectize = FALSE
            ), "Discrete metadata used for fill colors. Defaults to the grouping.",
                placement = "top", options = list(container = "body")),
            tipify(checkboxGroupInput(ns("plots"), "Representations",
                choices = c("Jitter" = "jitter", "Violin" = "vlnplot",
                    "Box" = "boxplot", "Ridge" = "ridgeplot"),
                selected = .ditto_default(defaults, "plots", c("jitter", "vlnplot"))
            ), "Data representations to draw, from back to front.",
                placement = "top", options = list(container = "body")),
            tipify(selectInput(ns("split.by"), "Split By (facet)",
                choices = color.choices,
                selected = .ditto_default(defaults, "split.by", ""), selectize = FALSE
            ), "Discrete metadata to split the plot into facets.",
                placement = "top", options = list(container = "body"))
        ),
        "Aesthetics" = tagList(
            uiOutput(ns("palette.selection")),
            tipify(numericInput(ns("jitter.size"), "Jitter Size",
                value = .ditto_default(defaults, "jitter.size", 1), min = 0.1, step = 0.1),
                "Size of the jitter points.",
                placement = "top", options = list(container = "body")),
            tipify(numericInput(ns("jitter.width"), "Jitter Width",
                value = .ditto_default(defaults, "jitter.width", 0.2), min = 0, step = 0.05),
                "Horizontal spread of the jitter points.",
                placement = "top", options = list(container = "body")),
            tipify(numericInput(ns("vlnplot.lineweight"), "Violin Line Weight",
                value = .ditto_default(defaults, "vlnplot.lineweight", 1), min = 0, step = 0.1),
                "Line weight of the violin outlines.",
                placement = "top", options = list(container = "body")),
            tipify(numericInput(ns("boxplot.width"), "Box Width",
                value = .ditto_default(defaults, "boxplot.width", 0.2), min = 0, step = 0.05),
                "Width of the boxplots.",
                placement = "top", options = list(container = "body")),
            tipify(numericInput(ns("boxplot.lineweight"), "Box Line Weight",
                value = .ditto_default(defaults, "boxplot.lineweight", 1), min = 0, step = 0.1),
                "Line weight of the boxplot outlines.",
                placement = "top", options = list(container = "body")),
            tipify(numericInput(ns("vlnplot.width"), "Violin Width",
                value = .ditto_default(defaults, "vlnplot.width", 1), min = 0, step = 0.05),
                "Relative width of the violins.",
                placement = "top", options = list(container = "body")),
            tipify(selectInput(ns("vlnplot.scaling"), "Violin Scaling",
                choices = c("Area" = "area", "Count" = "count", "Width" = "width"),
                selected = .ditto_default(defaults, "vlnplot.scaling", "area"), selectize = FALSE
            ), "How violin areas are scaled relative to each other.",
                placement = "top", options = list(container = "body")),
            tipify(numericInput(ns("ridgeplot.scale"), "Ridge Scale (overlap)",
                value = .ditto_default(defaults, "ridgeplot.scale", 1.25), min = 0.1, step = 0.05),
                "Vertical scaling of the ridges; larger values increase overlap.",
                placement = "top", options = list(container = "body")),
            tipify(numericInput(ns("ridgeplot.lineweight"), "Ridge Line Weight",
                value = .ditto_default(defaults, "ridgeplot.lineweight", 1), min = 0, step = 0.1),
                "Line weight of the ridge outlines.",
                placement = "top", options = list(container = "body"))
        ),
        "Plotly" = uniform_plotly_inputs_ui(ns, defaults),
        "Axes" = uniform_axes_inputs_ui(ns, defaults, include.rotate = FALSE),
        "Legend" = uniform_legend_inputs_ui(ns, defaults),
        "Lines" = uniform_lines_inputs_ui(ns, defaults)
    )

    organize_inputs(
        inputs,
        id = ns("dittoPlotTabsetPanel"),
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


#' Output UI components for the dittoPlot module
#'
#' This should be placed in the UI where the plot should be shown.
#'
#' @param id The ID for the Shiny module.
#' @param resizable Logical; when \code{TRUE} (the default) the plot output is
#'   wrapped in [shinyjqui::jqui_resizable()] so it can be resized by dragging.
#'
#' @return A Shiny plotlyOutput for the plot.
#'
#' @import shiny
#' @import plotly
#' @importFrom shinyjqui jqui_resizable
#'
#' @export
#' @author Jared Andrews
dittoPlotOutputUI <- function(id, resizable = TRUE) {
    ns <- NS(id)
    plot_output <- plotlyOutput(ns("dittoPlot"))
    if (isTRUE(resizable)) {
        plot_output <- shinyjqui::jqui_resizable(plot_output)
    }
    plot_output
}
