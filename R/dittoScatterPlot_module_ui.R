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
#' The following parameters can be accessed via UI inputs and/or the `defaults` argument:
#'
#' - `x.var` - Continuous variable on the x-axis (gene or numeric metadata)
#' - `y.var` - Continuous variable on the y-axis (gene or numeric metadata)
#' - `color.var` - Gene or metadata used for coloring (default: none)
#' - `shape.by` - Discrete metadata mapped to point shape (default: none)
#' - `split.by` - Discrete metadata to facet by (default: none)
#' - `size` - Point size (default: 1)
#' - `opacity` - Point opacity (default: 1)
#' - `order` - Point plotting order (default: "unordered")
#' - `do.label` - Draw group labels at group centers (default: FALSE)
#' - `labels.size` - Text size of the group labels (default: 5)
#' - `do.ellipse` - Draw grouping ellipses (default: FALSE)
#' - `do.contour` - Overlay kernel-density contour lines (default: FALSE)
#' - `min.color`, `max.color` - Colors for continuous color scales
#' - `palette.selection` - Colors for discrete groups (multiColorPicker)
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
#' @author Jacob Martin, Jared Andrews
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

    selected <- list(
        "x.var", "y.var", "color.var",
        "shape.by", "split.by",
        "min.color", "max.color",
        "order", "size", "opacity",
        "do.label", "labels.size",
        "do.ellipse", "do.contour"
    )

    documentParameters <- get_documentation(
        package_name = "dittoSeq::dittoScatterPlot", type = "param",
        selected = selected, cap = TRUE
    )

    cont.choices <- .ditto_continuous_choices(data, include.blank = FALSE)
    cont.flat <- unlist(cont.choices, use.names = FALSE)
    var.choices <- .ditto_var_choices(data, include.blank = TRUE)
    disc.choices <- c("None" = "", stats::setNames(
        .ditto_discrete_metas(data), .ditto_discrete_metas(data)
    ))

    default.x <- get_default(defaults, "x.var", if (length(cont.flat) >= 1) cont.flat[1] else "")
    default.y <- get_default(defaults, "y.var", if (length(cont.flat) >= 2) cont.flat[2] else default.x)

    inputs <- list(
        "Data" = tagList(
            tipify(selectInput(ns("x.var"), "X Variable",
                choices = cont.choices,
                selected = default.x, selectize = FALSE
            ), documentParameters$x.var,
                placement = "top", options = list(container = "body")),
            tipify(selectInput(ns("y.var"), "Y Variable",
                choices = cont.choices,
                selected = default.y, selectize = FALSE
            ), documentParameters$y.var,
                placement = "top", options = list(container = "body")),
            tipify(selectInput(ns("color.var"), "Color By",
                choices = var.choices,
                selected = get_default(defaults, "color.var", ""), selectize = FALSE
            ), documentParameters$color.var,
                placement = "top", options = list(container = "body")),
            tipify(selectInput(ns("shape.by"), "Shape By",
                choices = disc.choices,
                selected = get_default(defaults, "shape.by", ""), selectize = FALSE
            ), documentParameters$shape.by,
                placement = "top", options = list(container = "body")),
            tipify(selectInput(ns("split.by"), "Split By (facet)",
                choices = disc.choices,
                selected = get_default(defaults, "split.by", ""), selectize = FALSE
            ), documentParameters$split.by,
                placement = "top", options = list(container = "body"))
        ),
        "Aesthetics" = tagList(
            uiOutput(ns("palette.selection")),
            tipify(colourInput(ns("min.color"), "Min Color",
                value = get_default(defaults, "min.color", "#F0E442")),
                documentParameters$min.color,
                placement = "top", options = list(container = "body")),
            tipify(colourInput(ns("max.color"), "Max Color",
                value = get_default(defaults, "max.color", "#0072B2")),
                documentParameters$max.color,
                placement = "top", options = list(container = "body")),
            tipify(selectInput(ns("order"), "Point Order",
                choices = c("unordered", "increasing", "decreasing", "randomize"),
                selected = get_default(defaults, "order", "unordered"), selectize = FALSE
            ), documentParameters$order,
                placement = "top", options = list(container = "body")),
            tipify(numericInput(ns("size"), "Point Size",
                value = get_default(defaults, "size", 1), min = 0.1, step = 0.1),
                documentParameters$size,
                placement = "top", options = list(container = "body")),
            tipify(numericInput(ns("opacity"), "Point Opacity",
                value = get_default(defaults, "opacity", 1), min = 0, max = 1, step = 0.05),
                documentParameters$opacity,
                placement = "top", options = list(container = "body")),
            tipify(materialSwitch(ns("do.label"), "Label Groups",
                value = get_default(defaults, "do.label", FALSE), status = "success"),
                documentParameters$do.label,
                placement = "top", options = list(container = "body")),
            tipify(numericInput(ns("labels.size"), "Label Size",
                value = get_default(defaults, "labels.size", 5), min = 1, step = 0.5),
                documentParameters$labels.size,
                placement = "top", options = list(container = "body")),
            tipify(materialSwitch(ns("do.ellipse"), "Group Ellipses",
                value = get_default(defaults, "do.ellipse", FALSE), status = "success"),
                documentParameters$do.ellipse,
                placement = "top", options = list(container = "body")),
            tipify(materialSwitch(ns("do.contour"), "Density Contours",
                value = get_default(defaults, "do.contour", FALSE), status = "success"),
                documentParameters$do.contour,
                placement = "top", options = list(container = "body"))
        ),
        "Plotly" = uniform_plotly_inputs_ui(ns, defaults),
        "Axes" = uniform_axes_inputs_ui(ns, defaults, include.rotate = FALSE),
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
#' @param resizable Logical; when `TRUE` (the default) the plot output is
#'   wrapped in [shinyjqui::jqui_resizable()] so it can be resized by dragging.
#'
#' @return A Shiny plotlyOutput for the scatter plot.
#'
#' @import shiny
#' @import plotly
#' @importFrom shinyjqui jqui_resizable
#'
#'
#' @examples
#' dittoScatterPlotOutputUI("plot")
#' @export
#' @author Jacob Martin, Jared Andrews
dittoScatterPlotOutputUI <- function(id, resizable = TRUE) {
    ns <- NS(id)
    plot_output <- plotlyOutput(ns("dittoScatterPlot"))
    if (isTRUE(resizable)) {
        plot_output <- shinyjqui::jqui_resizable(plot_output)
    }
    plot_output
}
