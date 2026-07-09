#' Input UI components for the dittoDimHex module
#'
#' This should be placed in the UI where the inputs should be shown, with an `id`
#' that matches the `id` used in the `dittoDimHexServer()` and
#' `dittoDimHexOutputUI()` functions.
#'
#' @details The user inputs for this module are separated from the outputs to allow for
#' more flexible UI design.
#'
#' This module wraps [dittoSeq::dittoDimHex()], which bins the cells/samples of a
#' dimensionality reduction embedding into hexagons and (optionally) summarizes a
#' gene/metadata within each bin. The resulting `ggplot` is converted to an
#' interactive `plotly` figure.
#'
#' @section Plot parameters and defaults:
#' The following parameters can be accessed via UI inputs and/or the \code{defaults} argument:
#' \itemize{
#'   \item \code{color.var} - Gene or metadata summarized within each hex (default: density only)
#'   \item \code{reduction.use} - Dimensionality reduction to plot (default: auto-detected)
#'   \item \code{dim.1}, \code{dim.2} - Which dimensions to plot on x/y (default: 1 and 2)
#'   \item \code{bins} - Number of hexagonal bins (default: 30)
#'   \item \code{color.method} - Summary method for discrete \code{color.var} ("max.prop" or a
#'     metadata level) or for continuous data ("median", "mean", etc.)
#'   \item \code{split.by} - Discrete metadata to facet by (default: none)
#'   \item \code{min.color}, \code{max.color} - Colors for the continuous color scale
#'   \item \code{do.contour} - Overlay kernel-density contour lines (default: FALSE)
#'   \item \code{do.label} - Draw group labels for a discrete \code{color.var} (default: FALSE)
#'   \item \code{labels.size} - Text size of the group labels (default: 5)
#'   \item \code{do.ellipse} - Draw ellipses for a discrete \code{color.var} (default: FALSE)
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
#' @seealso [dittoSeq::dittoDimHex()], [VizModules::organize_inputs()],
#' [sciVizModules::dittoDimHexOutputUI()], [sciVizModules::dittoDimHexServer()],
#' [sciVizModules::dittoDimHexApp()]
#' @examples
#' library(sciVizModules)
#' data(example_sce)
#' dittoDimHexInputsUI("dittoDimHex", example_sce)
dittoDimHexInputsUI <- function(id, data, defaults = NULL, title = "DimHex Settings", columns = 2) {
    ns <- NS(id)
    .assert_ditto_object(data, "data")

    if (is.null(defaults)) defaults <- list()

    var.choices <- .ditto_var_choices(data, include.blank = TRUE)
    disc.choices <- c("None" = "", stats::setNames(
        .ditto_discrete_metas(data), .ditto_discrete_metas(data)
    ))
    red.choices <- .ditto_reductions(data)
    default.red <- .ditto_default(defaults, "reduction.use", .ditto_default_reduction(data))

    inputs <- list(
        "Data" = tagList(
            tipify(selectInput(ns("color.var"), "Color By (gene / metadata)",
                choices = var.choices,
                selected = .ditto_default(defaults, "color.var", ""), selectize = FALSE
            ), "Gene or metadata summarized within each hexagonal bin. Leave blank to show density.",
                placement = "top", options = list(container = "body")),
            tipify(selectInput(ns("reduction.use"), "Reduction",
                choices = red.choices,
                selected = default.red, selectize = FALSE
            ), "Dimensionality reduction embedding to plot.",
                placement = "top", options = list(container = "body")),
            tipify(numericInput(ns("dim.1"), "X Dimension",
                value = .ditto_default(defaults, "dim.1", 1), min = 1, step = 1),
                "Which dimension of the reduction to plot on the x-axis.",
                placement = "top", options = list(container = "body")),
            tipify(numericInput(ns("dim.2"), "Y Dimension",
                value = .ditto_default(defaults, "dim.2", 2), min = 1, step = 1),
                "Which dimension of the reduction to plot on the y-axis.",
                placement = "top", options = list(container = "body")),
            tipify(numericInput(ns("bins"), "Hex Bins",
                value = .ditto_default(defaults, "bins", 30), min = 2, step = 1),
                "Number of hexagonal bins across the plotting area.",
                placement = "top", options = list(container = "body")),
            tipify(textInput(ns("color.method"), "Color Method",
                value = .ditto_default(defaults, "color.method", "")),
                paste("Summary method for the color variable. For continuous data:",
                    "'median' (default), 'mean', 'max', 'min', or 'sd'.",
                    "For discrete data: 'max' (default), 'max.prop', or a specific level."),
                placement = "top", options = list(container = "body")),
            tipify(selectInput(ns("split.by"), "Split By (facet)",
                choices = disc.choices,
                selected = .ditto_default(defaults, "split.by", ""), selectize = FALSE
            ), "Discrete metadata to split the plot into facets.",
                placement = "top", options = list(container = "body"))
        ),
        "Aesthetics" = tagList(
            tipify(colourInput(ns("min.color"), "Min Color",
                value = .ditto_default(defaults, "min.color", "#F0E442")),
                "Low end of the color scale.",
                placement = "top", options = list(container = "body")),
            tipify(colourInput(ns("max.color"), "Max Color",
                value = .ditto_default(defaults, "max.color", "#0072B2")),
                "High end of the color scale.",
                placement = "top", options = list(container = "body")),
            tipify(numericInput(ns("min.opacity"), "Min Opacity",
                value = .ditto_default(defaults, "min.opacity", 0.2), min = 0, max = 1, step = 0.05),
                "Opacity of the least-dense hexagons.",
                placement = "top", options = list(container = "body")),
            tipify(numericInput(ns("max.opacity"), "Max Opacity",
                value = .ditto_default(defaults, "max.opacity", 1), min = 0, max = 1, step = 0.05),
                "Opacity of the most-dense hexagons.",
                placement = "top", options = list(container = "body")),
            tipify(materialSwitch(ns("do.contour"), "Density Contours",
                value = .ditto_default(defaults, "do.contour", FALSE), status = "success"),
                "Overlay kernel-density contour lines over the hexagons.",
                placement = "top", options = list(container = "body")),
            tipify(materialSwitch(ns("do.label"), "Label Groups",
                value = .ditto_default(defaults, "do.label", FALSE), status = "success"),
                "Overlay text labels at the center of each group (discrete color variable only).",
                placement = "top", options = list(container = "body")),
            tipify(numericInput(ns("labels.size"), "Label Size",
                value = .ditto_default(defaults, "labels.size", 5), min = 1, step = 0.5),
                "Text size of the group labels (used when 'Label Groups' is on).",
                placement = "top", options = list(container = "body")),
            tipify(materialSwitch(ns("do.ellipse"), "Group Ellipses",
                value = .ditto_default(defaults, "do.ellipse", FALSE), status = "success"),
                "Draw a covariance ellipse around each group (discrete color variable only).",
                placement = "top", options = list(container = "body"))
        ),
        "Plotly" = uniform_plotly_inputs_ui(ns, defaults),
        "Axes" = uniform_axes_inputs_ui(ns, defaults, include.rotate = TRUE),
        "Legend" = uniform_legend_inputs_ui(ns, defaults),
        "Lines" = uniform_lines_inputs_ui(ns, defaults)
    )

    organize_inputs(
        inputs,
        id = ns("dittoDimHexTabsetPanel"),
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


#' Output UI components for the dittoDimHex module
#'
#' This should be placed in the UI where the plot should be shown.
#'
#' @param id The ID for the Shiny module.
#' @param resizable Logical; when \code{TRUE} (the default) the plot output is
#'   wrapped in [shinyjqui::jqui_resizable()] so it can be resized by dragging.
#'
#' @return A Shiny plotlyOutput for the hex plot.
#'
#' @import shiny
#' @import plotly
#' @importFrom shinyjqui jqui_resizable
#'
#' @export
#' @author Jared Andrews
dittoDimHexOutputUI <- function(id, resizable = TRUE) {
    ns <- NS(id)
    plot_output <- plotlyOutput(ns("dittoDimHex"))
    if (isTRUE(resizable)) {
        plot_output <- shinyjqui::jqui_resizable(plot_output)
    }
    plot_output
}
