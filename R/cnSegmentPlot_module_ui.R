#' Input UI components for the cnSegmentPlot module
#'
#' This should be placed in the UI where the inputs should be shown, with an
#' `id` that matches the `id` used in the `cnSegmentPlotServer()` and
#' `cnSegmentPlotOutputUI()` functions.
#'
#' @details The user inputs for this module are separated from the outputs to
#' allow for more flexible UI design. The module draws a genome-wide copy
#' number scatter/segment plot from a `CNSegment` object (as returned by
#' [sesame::cnSegmentation()]). When a `genes` `GRanges` is supplied, users can
#' enter gene identifiers separated by commas or whitespace and choose the
#' metadata column used to match and display those labels.
#'
#' @param id The ID for the Shiny module.
#' @param seg A `CNSegment` object used to populate the chromosome choices.
#' @param genes An optional `GRanges` of gene coordinates, used to populate the
#'   gene label column choices and resolve identifiers entered in "Genes to
#'   Label".
#' @param defaults A named list of default values for the inputs.
#' @param title An optional title for the UI grid.
#' @param columns Number of columns for the UI grid.
#' @return A Shiny tagList containing the UI elements.
#'
#' @import shiny
#' @importFrom shinyBS tipify
#' @importFrom colourpicker colourInput
#' @importFrom methods is
#' @importFrom GenomicRanges seqinfo mcols
#' @import VizModules
#'
#' @export
#'
#' @author Jared Andrews
#'
#' @seealso [sciVizModules::cnSegmentPlot()],
#' [sciVizModules::cnSegmentPlotOutputUI()],
#' [sciVizModules::cnSegmentPlotServer()], [sciVizModules::cnSegmentPlotApp()]
#'
#' @examples
#' library(sciVizModules)
#' data(example_cn_segment)
#' data(example_cn_genes)
#' cnSegmentPlotInputsUI("cn_plot", example_cn_segment, example_cn_genes)
cnSegmentPlotInputsUI <- function(id, seg, genes = NULL, defaults = NULL,
                                  title = "CN Segment Settings", columns = 2) {
    ns <- NS(id)
    stopifnot(is(seg, "CNSegment"))

    if (is.null(defaults)) defaults <- list()

    seq.choices <- as.character(seqinfo(seg$bin.coords)@seqnames)
    hover.choices <- union(names(mcols(seg$bin.coords)), "signal")

    id.col.choices <- if (!is.null(genes) && length(genes) > 0) names(mcols(genes)) else character(0)
    default.id.col <- get_default(defaults, "id.col",
        if ("hgnc_symbol" %in% id.col.choices) {
            "hgnc_symbol"
        } else if ("gene_name" %in% id.col.choices) {
            "gene_name"
        } else if (length(id.col.choices)) {
            id.col.choices[1]
        } else {
            ""
        })

    data.inputs <- list(
        tipify(selectInput(ns("to.plot"), "Chromosomes to Plot",
            choices = seq.choices,
            selected = get_default(defaults, "to.plot", character(0)),
            multiple = TRUE
        ), "Chromosomes to include. Leave empty to auto-select chromosomes representing at least 1% of the genome.",
            placement = "top", options = list(container = "body")),
        tipify(selectInput(ns("hover.text.cols"), "Hover Text Columns",
            choices = hover.choices,
            selected = get_default(defaults, "hover.text.cols", "signal"),
            multiple = TRUE
        ), "Bin metadata columns to include in the point hover text.",
            placement = "top", options = list(container = "body"))
    )

    if (!is.null(genes) && length(genes) > 0) {
        data.inputs <- c(data.inputs, list(
            tipify(selectInput(ns("id.col"), "Gene Label Column",
                choices = id.col.choices, selected = default.id.col, selectize = FALSE
            ), "Metadata column in `genes` holding the label to display for each gene.",
                placement = "top", options = list(container = "body")),
            tipify(textInput(ns("label.genes"), "Genes to Label",
                value = get_default(defaults, "label.genes", ""),
                placeholder = "TP53, EGFR, MYC"),
                "Gene labels separated by commas or whitespace. Leave empty for no labels.",
                placement = "top", options = list(container = "body"))
        ))
    }

    inputs <- list(
        "Data" = do.call(tagList, data.inputs),
        "Aesthetics" = tagList(
            tipify(numericInput(ns("point.size"), "Point Size",
                value = get_default(defaults, "point.size", 1.5), min = 0, step = 0.5),
                "Size of the bin-level points.",
                placement = "top", options = list(container = "body")),
            tipify(numericInput(ns("point.alpha"), "Point Opacity",
                value = get_default(defaults, "point.alpha", 0.8), min = 0, max = 1, step = 0.05),
                "Opacity of the bin-level points.",
                placement = "top", options = list(container = "body")),
            tipify(colourInput(ns("color.low"), "Low Colour",
                value = get_default(defaults, "color.low", "#FF0000")),
                "Colour for the low end of the signal colour scale.",
                placement = "top", options = list(container = "body")),
            tipify(colourInput(ns("color.mid"), "Mid Colour",
                value = get_default(defaults, "color.mid", "#808080")),
                "Colour for the midpoint (0) of the signal colour scale.",
                placement = "top", options = list(container = "body")),
            tipify(colourInput(ns("color.high"), "High Colour",
                value = get_default(defaults, "color.high", "#00FF00")),
                "Colour for the high end of the signal colour scale.",
                placement = "top", options = list(container = "body")),
            tipify(numericInput(ns("color.limit.low"), "Colour Scale Min",
                value = get_default(defaults, "color.limit.low", -0.4), step = 0.1),
                "Lower limit of the signal colour scale. Values below this are squished to the limit.",
                placement = "top", options = list(container = "body")),
            tipify(numericInput(ns("color.limit.high"), "Colour Scale Max",
                value = get_default(defaults, "color.limit.high", 0.4), step = 0.1),
                "Upper limit of the signal colour scale. Values above this are squished to the limit.",
                placement = "top", options = list(container = "body")),
            tipify(colourInput(ns("color.seg"), "Segment Line Colour",
                value = get_default(defaults, "color.seg", "#0000FF")),
                "Colour of the called segment mean line overlay.",
                placement = "top", options = list(container = "body")),
            tipify(numericInput(ns("seg.line.width"), "Segment Line Width",
                value = get_default(defaults, "seg.line.width", 1), min = 0, step = 0.25),
                "Width of the called segment mean line overlay.",
                placement = "top", options = list(container = "body")),
            tipify(numericInput(ns("label.size"), "Gene Label Size",
                value = get_default(defaults, "label.size", 3), min = 0, step = 0.5),
                "Text size of gene labels (only used when genes are supplied).",
                placement = "top", options = list(container = "body"))
        ),
        "Axes" = tagList(
            uniform_axes_inputs_ui(ns, defaults),
            tipify(numericInput(ns("y.min"), "Y-Axis Min",
                value = get_default(defaults, "y.min", NA), step = 0.1),
                paste(
                    "Lower limit for the y-axis (log2 signal ratio). Values below this are",
                    "squished to the limit. Leave blank for automatic."
                ), placement = "top", options = list(container = "body")),
            tipify(numericInput(ns("y.max"), "Y-Axis Max",
                value = get_default(defaults, "y.max", NA), step = 0.1),
                "Upper limit for the y-axis. Values above this are squished to the limit. Leave blank for automatic.",
                placement = "top", options = list(container = "body"))
        ),
        "Plotly" = uniform_plotly_inputs_ui(ns, defaults),
        "Lines" = uniform_lines_inputs_ui(ns, defaults)
    )

    organize_inputs(
        inputs,
        id = ns("cnSegmentPlotTabsetPanel"),
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


#' Output UI components for the cnSegmentPlot module
#'
#' This should be placed in the UI where the plot should be shown.
#'
#' @param id The ID for the Shiny module.
#' @param resizable Logical; when \code{TRUE} (the default) the plot output is
#'   wrapped in [shinyjqui::jqui_resizable()] so it can be resized by dragging.
#'
#' @return A Shiny plotlyOutput for the copy number segment plot.
#'
#' @importFrom shiny NS
#' @importFrom shinyjqui jqui_resizable
#' @importFrom plotly plotlyOutput
#'
#' @export
#' @author Jared Andrews
cnSegmentPlotOutputUI <- function(id, resizable = TRUE) {
    ns <- NS(id)
    plot_output <- plotlyOutput(ns("cnSegmentPlot"))
    if (isTRUE(resizable)) {
        plot_output <- jqui_resizable(plot_output)
    }
    plot_output
}
