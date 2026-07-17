#' Input UI components for the dittoRidgeJitter module
#'
#' This should be placed in the UI where the inputs should be shown, with an `id`
#' that matches the `id` used in the `dittoRidgeJitterServer()` and
#' `dittoRidgeJitterOutputUI()` functions.
#'
#' @details The user inputs for this module are separated from the outputs to allow for
#' more flexible UI design.
#'
#' This module wraps [dittoSeq::dittoRidgeJitter()] (a convenience wrapper of
#' [dittoSeq::dittoPlot()] with `plots = c("ridgeplot", "jitter")`), drawing a
#' ridgeline density with overlaid jitter points for continuous data (gene
#' expression or numeric metadata) per discrete group. The resulting `ggplot` is
#' converted to an interactive `plotly` figure.
#'
#' @section Plot parameters and defaults:
#' The following parameters can be accessed via UI inputs and/or the \code{defaults} argument:
#' \itemize{
#'   \item \code{var} - Continuous variable to plot (gene or numeric metadata)
#'   \item \code{group.by} - Discrete metadata used for the ridge groups
#'   \item \code{color.by} - Discrete metadata used for fill colors (default: `group.by`)
#'   \item \code{split.by} - Discrete metadata to facet by (default: none)
#'   \item \code{ridgeplot.scale} - Ridge overlap scale (default: 1.25)
#'   \item \code{ridgeplot.shape} - Ridge shape: "smooth" density or "hist" (default: "smooth")
#'   \item \code{ridgeplot.bins} - Number of bins when \code{ridgeplot.shape} is "hist" (default: 30)
#'   \item \code{jitter.size} - Jitter point size (default: 1)
#'   \item \code{jitter.color} - Color of the jitter points (default: "#000000")
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
#' @importFrom colourpicker colourInput
#'
#' @export
#' @author Jacob Martin, Jared Andrews
#' @seealso [dittoSeq::dittoRidgeJitter()], [VizModules::organize_inputs()],
#' [sciVizModules::dittoRidgeJitterOutputUI()], [sciVizModules::dittoRidgeJitterServer()],
#' [sciVizModules::dittoRidgeJitterApp()]
#' @examples
#' library(sciVizModules)
#' data(example_sce)
#' dittoRidgeJitterInputsUI("dittoRidgeJitter", example_sce)
dittoRidgeJitterInputsUI <- function(id, data, defaults = NULL, title = "RidgeJitter Settings", columns = 2) {
    ns <- NS(id)
    .assert_ditto_object(data, "data")

    if (is.null(defaults)) defaults <- list()

    selected <- list(
        "var", "group.by", "color.by", "split.by",
        c("ridgeplot.scale", "ridgeplot.lineweight"),
        c("ridgeplot.shape", "ridgeplot.bins"),
        c("jitter.size", "jitter.width", "jitter.color")
    )

    documentParameters <- get_documentation(
        package_name = "dittoSeq::dittoRidgeJitter", type = "param",
        selected = selected, cap = TRUE
    )

    cont.choices <- .ditto_continuous_choices(data, include.blank = FALSE)
    cont.flat <- unlist(cont.choices, use.names = FALSE)
    disc <- .ditto_discrete_metas(data)
    group.choices <- stats::setNames(disc, disc)
    color.choices <- c("Same as Group" = "", stats::setNames(disc, disc))

    default.var <- get_default(defaults, "var", if (length(cont.flat)) cont.flat[1] else "")
    default.group <- get_default(defaults, "group.by", if (length(disc)) disc[1] else "")

    inputs <- list(
        "Data" = tagList(
            tipify(selectInput(ns("var"), "Variable (gene / metadata)",
                choices = cont.choices,
                selected = default.var, selectize = FALSE
            ), documentParameters$var,
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
            tipify(selectInput(ns("split.by"), "Split By (facet)",
                choices = color.choices,
                selected = get_default(defaults, "split.by", ""), selectize = FALSE
            ), documentParameters$split.by,
                placement = "top", options = list(container = "body"))
        ),
        "Aesthetics" = tagList(
            uiOutput(ns("palette.selection")),
            tipify(numericInput(ns("ridgeplot.scale"), "Ridge Scale (overlap)",
                value = get_default(defaults, "ridgeplot.scale", 1.25), min = 0.1, step = 0.05),
                documentParameters$ridgeplot.scale,
                placement = "top", options = list(container = "body")),
            tipify(numericInput(ns("ridgeplot.lineweight"), "Ridge Line Weight",
                value = get_default(defaults, "ridgeplot.lineweight", 1), min = 0, step = 0.1),
                documentParameters$ridgeplot.lineweight,
                placement = "top", options = list(container = "body")),
            tipify(selectInput(ns("ridgeplot.shape"), "Ridge Shape",
                choices = c("Smooth" = "smooth", "Histogram" = "hist"),
                selected = get_default(defaults, "ridgeplot.shape", "smooth"), selectize = FALSE
            ), documentParameters$ridgeplot.shape,
                placement = "top", options = list(container = "body")),
            tipify(numericInput(ns("ridgeplot.bins"), "Ridge Bins",
                value = get_default(defaults, "ridgeplot.bins", 30), min = 2, step = 1),
                documentParameters$ridgeplot.bins,
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
                placement = "top", options = list(container = "body"))
        ),
        "Plotly" = uniform_plotly_inputs_ui(ns, defaults),
        "Axes" = uniform_axes_inputs_ui(ns, defaults, include.rotate = FALSE),
        "Legend" = uniform_legend_inputs_ui(ns, defaults),
        "Lines" = uniform_lines_inputs_ui(ns, defaults)
    )

    organize_inputs(
        inputs,
        id = ns("dittoRidgeJitterTabsetPanel"),
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


#' Output UI components for the dittoRidgeJitter module
#'
#' This should be placed in the UI where the plot should be shown.
#'
#' @param id The ID for the Shiny module.
#' @param resizable Logical; when \code{TRUE} (the default) the plot output is
#'   wrapped in [shinyjqui::jqui_resizable()] so it can be resized by dragging.
#'
#' @return A Shiny plotlyOutput for the ridge/jitter plot.
#'
#' @import shiny
#' @import plotly
#' @importFrom shinyjqui jqui_resizable
#'
#' @export
#' @author Jacob Martin, Jared Andrews
dittoRidgeJitterOutputUI <- function(id, resizable = TRUE) {
    ns <- NS(id)
    plot_output <- plotlyOutput(ns("dittoRidgeJitter"))
    if (isTRUE(resizable)) {
        plot_output <- shinyjqui::jqui_resizable(plot_output)
    }
    plot_output
}
