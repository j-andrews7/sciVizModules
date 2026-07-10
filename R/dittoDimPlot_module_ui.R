#' Input UI components for the dittoDimPlot module
#'
#' This should be placed in the UI where the inputs should be shown, with an `id`
#' that matches the `id` used in the `dittoDimPlotServer()` and
#' `dittoDimPlotOutputUI()` functions.
#'
#' @details The user inputs for this module are separated from the outputs to allow for
#' more flexible UI design.
#'
#' The inputs are organized into tabs via the [VizModules::organize_inputs()] function,
#' with `columns` controlling the number of columns in each tab's grid.
#'
#' This module wraps [dittoSeq::dittoDimPlot()], which displays gene expression or
#' metadata overlaid on a dimensionality reduction (e.g. UMAP, t-SNE, PCA)
#' embedding stored in a `SingleCellExperiment`, `Seurat`, or `SummarizedExperiment`
#' object. The resulting `ggplot` is converted to an interactive `plotly` figure.
#'
#' @section Plot parameters and defaults:
#' The following parameters can be accessed via UI inputs and/or the \code{defaults} argument:
#' \itemize{
#'   \item \code{var} - Gene or metadata to color by (default: first metadata column)
#'   \item \code{reduction.use} - Dimensionality reduction to plot (default: auto-detected,
#'     priority UMAP > t-SNE > PCA)
#'   \item \code{dim.1}, \code{dim.2} - Which dimensions to plot on x/y (default: 1 and 2)
#'   \item \code{shape.by} - Discrete metadata mapped to point shape (default: none)
#'   \item \code{split.by} - Discrete metadata to facet by (default: none)
#'   \item \code{size} - Point size (default: 1)
#'   \item \code{opacity} - Point opacity (default: 1)
#'   \item \code{order} - Point plotting order (default: "unordered")
#'   \item \code{do.label} - Draw cluster/group labels (default: FALSE)
#'   \item \code{labels.size} - Text size of the group labels (default: 5)
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
#' @author Jacob Martin, Jared Andrews
#' @seealso [dittoSeq::dittoDimPlot()], [VizModules::organize_inputs()],
#' [sciVizModules::dittoDimPlotOutputUI()], [sciVizModules::dittoDimPlotServer()],
#' [sciVizModules::dittoDimPlotApp()]
#' @examples
#' library(sciVizModules)
#' data(example_sce)
#' dittoDimPlotInputsUI("dittoDimPlot", example_sce)
dittoDimPlotInputsUI <- function(id, data, defaults = NULL, title = "DimPlot Settings", columns = 2) {
    ns <- NS(id)
    .assert_ditto_object(data, "data")

    if (is.null(defaults)) defaults <- list()

    selected <- list(
        "var", "reduction.use", c("dim.1", "dim.2"),
        "shape.by", "split.by",
        "min.color", "max.color",
        "order", "size", "opacity",
        "do.label", "labels.size",
        "do.ellipse", "do.contour"
    )

    documentParameters <- get_documentation(
        package_name = "dittoSeq::dittoDimPlot", type = "param",
        selected = selected, cap = TRUE
    )

    var.choices <- .ditto_var_choices(data, include.blank = FALSE)
    disc.choices <- c("None" = "", stats::setNames(
        .ditto_discrete_metas(data), .ditto_discrete_metas(data)
    ))
    red.choices <- .ditto_reductions(data)

    default.var <- get_default(defaults, "var", {
        metas <- .ditto_metas(data)
        if (length(metas)) metas[1] else if (length(.ditto_genes(data))) .ditto_genes(data)[1] else ""
    })
    default.red <- get_default(defaults, "reduction.use", get_default_reduction(data))

    inputs <- list(
        "Data" = tagList(
            tipify(selectInput(ns("var"), "Color By (gene / metadata)",
                choices = var.choices,
                selected = default.var, selectize = FALSE
            ), documentParameters$var,
                placement = "top", options = list(container = "body")),
            tipify(selectInput(ns("reduction.use"), "Reduction",
                choices = red.choices,
                selected = default.red, selectize = FALSE
            ), documentParameters$reduction.use,
                placement = "top", options = list(container = "body")),
            tipify(numericInput(ns("dim.1"), "X Dimension",
                value = get_default(defaults, "dim.1", 1), min = 1, step = 1),
                documentParameters$dim.1,
                placement = "top", options = list(container = "body")),
            tipify(numericInput(ns("dim.2"), "Y Dimension",
                value = get_default(defaults, "dim.2", 2), min = 1, step = 1),
                documentParameters$dim.2,
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
            tipify(materialSwitch(ns("do.ellipse"), "Group Ellipses",
                value = get_default(defaults, "do.ellipse", FALSE), status = "success"),
                documentParameters$do.ellipse,
                placement = "top", options = list(container = "body")),
            tipify(materialSwitch(ns("do.contour"), "Density Contours",
                value = get_default(defaults, "do.contour", FALSE), status = "success"),
                documentParameters$do.contour,
                placement = "top", options = list(container = "body")),
            tipify(numericInput(ns("labels.size"), "Label Size",
                value = get_default(defaults, "labels.size", 5), min = 1, step = 0.5),
                documentParameters$labels.size,
                placement = "top", options = list(container = "body"))
        ),
        "Plotly" = uniform_plotly_inputs_ui(ns, defaults),
        "Axes" = uniform_axes_inputs_ui(ns, defaults, include.rotate = FALSE),
        "Legend" = uniform_legend_inputs_ui(ns, defaults),
        "Lines" = uniform_lines_inputs_ui(ns, defaults)
    )

    organize_inputs(
        inputs,
        id = ns("dittoDimPlotTabsetPanel"),
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


#' Output UI components for the dittoDimPlot module
#'
#' This should be placed in the UI where the plot should be shown.
#'
#' @param id The ID for the Shiny module.
#' @param resizable Logical; when \code{TRUE} (the default) the plot output is
#'   wrapped in [shinyjqui::jqui_resizable()] so it can be resized by dragging.
#'
#' @return A Shiny plotlyOutput for the dim plot.
#'
#' @import shiny
#' @import plotly
#' @importFrom shinyjqui jqui_resizable
#'
#' @export
#' @author Jacob Martin, Jared Andrews
dittoDimPlotOutputUI <- function(id, resizable = TRUE) {
    ns <- NS(id)
    plot_output <- plotlyOutput(ns("dittoDimPlot"))
    if (isTRUE(resizable)) {
        plot_output <- shinyjqui::jqui_resizable(plot_output)
    }
    plot_output
}
