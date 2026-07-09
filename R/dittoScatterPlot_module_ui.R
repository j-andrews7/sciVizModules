#' Input UI components for the dittoScatterPlot module
#'
#' This should be placed in the UI where the inputs should be shown, with an `id`
#' that matches the `id` used in the `dittoScatterPlotServer()` and
#' `dittoScatterPlotOutputUI()` functions.
#'
#' @details The user inputs for this module are separated from the outputs to allow for
#' more flexible UI design.
#'
#' This module wraps [dittoSeq::dittoScatterPlot()], plotting any two continuous
#' variables (genes or numeric metadata) from a `SingleCellExperiment`, `Seurat`,
#' or `SummarizedExperiment` object against one another, optionally colored by a
#' third gene/metadata. The resulting `ggplot` is converted to an interactive
#' `plotly` figure.
#'
#' @section Plot parameters and defaults:
#' The following parameters can be accessed via UI inputs and/or the \code{defaults} argument:
#' \itemize{
#'   \item \code{x.var} - Continuous variable on the x-axis (gene or numeric metadata)
#'   \item \code{y.var} - Continuous variable on the y-axis (gene or numeric metadata)
#'   \item \code{color.var} - Gene or metadata used for coloring (default: none)
#'   \item \code{shape.by} - Discrete metadata mapped to point shape (default: none)
#'   \item \code{split.by} - Discrete metadata to facet by (default: none)
#'   \item \code{size} - Point size (default: 1)
#'   \item \code{opacity} - Point opacity (default: 1)
#'   \item \code{order} - Point plotting order (default: "unordered")
#'   \item \code{do.label} - Draw group labels at group centers (default: FALSE)
#'   \item \code{labels.size} - Text size of the group labels (default: 5)
#'   \item \code{labels.highlight} - White box behind group labels (default: TRUE)
#'   \item \code{do.ellipse} - Draw grouping ellipses (default: FALSE)
#'   \item \code{do.contour} - Overlay kernel-density contour lines (default: FALSE)
#'   \item \code{min.color}, \code{max.color} - Colors for continuous color scales
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
#' @importFrom colourpicker colourInput
#'
#' @export
#' @author Jared Andrews
#' @seealso [dittoSeq::dittoScatterPlot()], [VizModules::organize_inputs()],
#' [sciVizModules::dittoScatterPlotOutputUI()], [sciVizModules::dittoScatterPlotServer()],
#' [sciVizModules::dittoScatterPlotApp()]
#' @examples
#' library(sciVizModules)
#' data(example_sce)
#' dittoScatterPlotInputsUI("dittoScatterPlot", example_sce)
dittoScatterPlotInputsUI <- function(id, data, defaults = NULL, title = "ScatterPlot Settings", columns = 2) {
    ns <- NS(id)
    .assert_ditto_object(data, "data")

    if (is.null(defaults)) defaults <- list()

    cont.choices <- .ditto_continuous_choices(data, include.blank = FALSE)
    cont.flat <- unlist(cont.choices, use.names = FALSE)
    var.choices <- .ditto_var_choices(data, include.blank = TRUE)
    disc.choices <- c("None" = "", stats::setNames(
        .ditto_discrete_metas(data), .ditto_discrete_metas(data)
    ))

    default.x <- .ditto_default(defaults, "x.var", if (length(cont.flat) >= 1) cont.flat[1] else "")
    default.y <- .ditto_default(defaults, "y.var", if (length(cont.flat) >= 2) cont.flat[2] else default.x)

    inputs <- list(
        "Data" = tagList(
            tipify(selectInput(ns("x.var"), "X Variable",
                choices = cont.choices,
                selected = default.x, selectize = FALSE
            ), "Continuous gene or metadata for the x-axis.",
                placement = "top", options = list(container = "body")),
            tipify(selectInput(ns("y.var"), "Y Variable",
                choices = cont.choices,
                selected = default.y, selectize = FALSE
            ), "Continuous gene or metadata for the y-axis.",
                placement = "top", options = list(container = "body")),
            tipify(selectInput(ns("color.var"), "Color By",
                choices = var.choices,
                selected = .ditto_default(defaults, "color.var", ""), selectize = FALSE
            ), "Gene or metadata used to color the points.",
                placement = "top", options = list(container = "body")),
            tipify(selectInput(ns("shape.by"), "Shape By",
                choices = disc.choices,
                selected = .ditto_default(defaults, "shape.by", ""), selectize = FALSE
            ), "Discrete metadata mapped to point shape.",
                placement = "top", options = list(container = "body")),
            tipify(selectInput(ns("split.by"), "Split By (facet)",
                choices = disc.choices,
                selected = .ditto_default(defaults, "split.by", ""), selectize = FALSE
            ), "Discrete metadata to split the plot into facets.",
                placement = "top", options = list(container = "body"))
        ),
        "Aesthetics" = tagList(
            uiOutput(ns("palette.selection")),
            tipify(colourInput(ns("min.color"), "Min Color",
                value = .ditto_default(defaults, "min.color", "#F0E442")),
                "Low end of the color scale for continuous coloring.",
                placement = "top", options = list(container = "body")),
            tipify(colourInput(ns("max.color"), "Max Color",
                value = .ditto_default(defaults, "max.color", "#0072B2")),
                "High end of the color scale for continuous coloring.",
                placement = "top", options = list(container = "body")),
            tipify(selectInput(ns("order"), "Point Order",
                choices = c("unordered", "increasing", "decreasing", "randomize"),
                selected = .ditto_default(defaults, "order", "unordered"), selectize = FALSE
            ), "Order in which points are drawn.",
                placement = "top", options = list(container = "body")),
            tipify(numericInput(ns("size"), "Point Size",
                value = .ditto_default(defaults, "size", 1), min = 0.1, step = 0.1),
                "Size of the plotted points.",
                placement = "top", options = list(container = "body")),
            tipify(numericInput(ns("opacity"), "Point Opacity",
                value = .ditto_default(defaults, "opacity", 1), min = 0, max = 1, step = 0.05),
                "Opacity of the plotted points.",
                placement = "top", options = list(container = "body")),
            tipify(materialSwitch(ns("do.label"), "Label Groups",
                value = .ditto_default(defaults, "do.label", FALSE), status = "success"),
                "Overlay text labels at the center of each discrete color group.",
                placement = "top", options = list(container = "body")),
            tipify(numericInput(ns("labels.size"), "Label Size",
                value = .ditto_default(defaults, "labels.size", 5), min = 1, step = 0.5),
                "Text size of the group labels (used when 'Label Groups' is on).",
                placement = "top", options = list(container = "body")),
            tipify(materialSwitch(ns("labels.highlight"), "Label Highlight",
                value = .ditto_default(defaults, "labels.highlight", TRUE), status = "success"),
                "Draw a white box behind each group label for readability.",
                placement = "top", options = list(container = "body")),
            tipify(materialSwitch(ns("do.ellipse"), "Group Ellipses",
                value = .ditto_default(defaults, "do.ellipse", FALSE), status = "success"),
                "Draw a covariance ellipse around each discrete color group.",
                placement = "top", options = list(container = "body")),
            tipify(materialSwitch(ns("do.contour"), "Density Contours",
                value = .ditto_default(defaults, "do.contour", FALSE), status = "success"),
                "Overlay kernel-density contour lines over the points.",
                placement = "top", options = list(container = "body"))
        ),
        "Plotly" = uniform_plotly_inputs_ui(ns, defaults),
        "Axes" = uniform_axes_inputs_ui(ns, defaults, include.rotate = TRUE),
        "Legend" = uniform_legend_inputs_ui(ns, defaults),
        "Lines" = uniform_lines_inputs_ui(ns, defaults)
    )

    organize_inputs(
        inputs,
        id = ns("dittoScatterPlotTabsetPanel"),
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


#' Output UI components for the dittoScatterPlot module
#'
#' This should be placed in the UI where the plot should be shown.
#'
#' @param id The ID for the Shiny module.
#' @param resizable Logical; when \code{TRUE} (the default) the plot output is
#'   wrapped in [shinyjqui::jqui_resizable()] so it can be resized by dragging.
#'
#' @return A Shiny plotlyOutput for the scatter plot.
#'
#' @import shiny
#' @import plotly
#' @importFrom shinyjqui jqui_resizable
#'
#' @export
#' @author Jared Andrews
dittoScatterPlotOutputUI <- function(id, resizable = TRUE) {
    ns <- NS(id)
    plot_output <- plotlyOutput(ns("dittoScatterPlot"))
    if (isTRUE(resizable)) {
        plot_output <- shinyjqui::jqui_resizable(plot_output)
    }
    plot_output
}
