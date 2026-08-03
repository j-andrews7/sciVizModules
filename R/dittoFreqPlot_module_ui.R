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
#' The following parameters can be accessed via UI inputs and/or the `defaults` argument:
#'
#' - `var` - Discrete metadata whose frequencies are computed
#' - `sample.by` - Discrete metadata identifying individual samples
#' - `group.by` - Discrete metadata used for the x-axis groups
#' - `color.by` - Discrete metadata used for fill colors (default: `group.by`)
#' - `scale` - "percent" or "count" (default: "percent")
#' - `plots` - Representations to draw (default: c("boxplot", "jitter"))
#' - `max.normalize` - Scale each facet to its own max (default: FALSE)
#' - `jitter.size` - Jitter point size (default: 1)
#' - `jitter.width` - Horizontal spread of the jitter points (default: 0.2)
#' - `jitter.color` - Color of the jitter points (default: "#000000")
#' - `boxplot.width` - Width of the boxplots (default: 0.4)
#' - `vlnplot.width` - Relative width of the violins (default: 1)
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

    selected <- list(
        "var", "sample.by", "group.by", "color.by",
        "scale", "plots", "max.normalize",
        c("jitter.size", "jitter.width", "jitter.color"),
        c("boxplot.width", "vlnplot.width")
    )

    documentParameters <- get_documentation(
        package_name = "dittoSeq::dittoFreqPlot", type = "param",
        selected = selected, cap = TRUE
    )

    disc <- .ditto_discrete_metas(data)
    var.choices <- stats::setNames(disc, disc)
    group.choices <- stats::setNames(disc, disc)
    sample.choices <- c("None" = "", stats::setNames(disc, disc))
    color.choices <- c("Same as Group" = "", stats::setNames(disc, disc))

    default.var <- get_default(defaults, "var", if (length(disc)) disc[1] else "")
    default.group <- get_default(defaults, "group.by",
        if (length(disc) >= 2) disc[2] else if (length(disc)) disc[1] else "")

    inputs <- list(
        "Data" = tagList(
            tipify(selectInput(ns("var"), "Variable",
                choices = var.choices,
                selected = default.var, selectize = FALSE
            ), documentParameters$var,
                placement = "top", options = list(container = "body")),
            tipify(selectInput(ns("sample.by"), "Sample By",
                choices = sample.choices,
                selected = get_default(defaults, "sample.by", ""), selectize = FALSE
            ), documentParameters$sample.by,
                placement = "top", options = list(container = "body")),
            tipify(selectInput(ns("group.by"), "Group By",
                choices = group.choices,
                selected = default.group, selectize = FALSE
            ), documentParameters$group.by,
                placement = "top", options = list(container = "body")),
            tipify(selectInput(ns("color.by"), "Color By",
                choices = color.choices,
                selected = get_default(defaults, "color.by", ""), selectize = FALSE
            ), documentParameters$color.by,
                placement = "top", options = list(container = "body")),
            tipify(selectInput(ns("scale"), "Scale",
                choices = c("Percent" = "percent", "Count" = "count"),
                selected = get_default(defaults, "scale", "percent"), selectize = FALSE
            ), documentParameters$scale,
                placement = "top", options = list(container = "body")),
            tipify(selectInput(
                ns("plots"),
                "Plots",
                choices = c("Violin" = "vlnplot", "Box" = "boxplot", "Jitter" = "jitter", "Ridge" = "ridgeplot"),
                selected = get_default(
                    defaults, "plots", c("boxplot", "jitter"),
                    function(x) all(x %in% c("vlnplot", "boxplot", "jitter", "ridgeplot"))
                ),
                multiple = TRUE, selectize = TRUE
                ), documentParameters$plots, placement = "top", options = list(container = "body")),
                helpText("Order not currently respected")
        ),
        "Aesthetics" = tagList(
            uiOutput(ns("palette.selection")),
            tipify(materialSwitch(ns("max.normalize"), "Max Normalize",
                value = get_default(defaults, "max.normalize", FALSE), status = "success"),
                documentParameters$max.normalize,
                placement = "top", options = list(container = "body")),
            tipify(numericInput(ns("jitter.size"), "Jitter Size",
                value = get_default(defaults, "jitter.size", 1), min = 0.1, step = 0.1),
                documentParameters$jitter.size,
                placement = "top", options = list(container = "body")),
            tipify(numericInput(ns("jitter.width"), "Jitter Width",
                value = get_default(defaults, "jitter.width", 0.2), min = 0, step = 0.05),
                documentParameters$jitter.width,
                placement = "top", options = list(container = "body")),
            tipify(colourInput(ns("jitter.color"), "Jitter Point Color",
                value = get_default(defaults, "jitter.color", "#000000")),
                documentParameters$jitter.color,
                placement = "top", options = list(container = "body")),
            tipify(numericInput(ns("boxplot.width"), "Box Width",
                value = get_default(defaults, "boxplot.width", 0.4), min = 0, step = 0.05),
                documentParameters$boxplot.width,
                placement = "top", options = list(container = "body")),
            tipify(numericInput(ns("vlnplot.width"), "Violin Width",
                value = get_default(defaults, "vlnplot.width", 1), min = 0, step = 0.05),
                documentParameters$vlnplot.width,
                placement = "top", options = list(container = "body"))
        ),
        "Plotly" = uniform_plotly_inputs_ui(ns, defaults),
        "Axes" = uniform_axes_inputs_ui(ns, defaults, include.rotate = FALSE),
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
#' @param resizable Logical; when `TRUE` (the default) the plot output is
#'   wrapped in [shinyjqui::jqui_resizable()] so it can be resized by dragging.
#'
#' @return A Shiny plotlyOutput for the frequency plot.
#'
#' @import shiny
#' @import plotly
#' @importFrom shinyjqui jqui_resizable
#'
#'
#' @examples
#' dittoFreqPlotOutputUI("plot")
#' @export
#' @author Jacob Martin, Jared Andrews
dittoFreqPlotOutputUI <- function(id, resizable = TRUE) {
    ns <- NS(id)
    plot_output <- plotlyOutput(ns("dittoFreqPlot"))
    if (isTRUE(resizable)) {
        plot_output <- shinyjqui::jqui_resizable(plot_output)
    }
    plot_output
}
