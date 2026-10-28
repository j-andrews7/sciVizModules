#' Create a standalone Shiny app for the cnSegmentPlot module
#'
#' This function generates a Shiny application with the modular copy number
#' segment plotting components: an inputs panel for configuring the plot and
#' an output panel showing the interactive `plotly` figure.
#'
#' Unlike the upload-driven [VizModules::createModuleApp()] wrapper, this app
#' takes the `CNSegment` object directly rather than a single data frame. Gene
#' labels and centromere positions are derived from the object's `genomeInfo`
#' (`genomeInfo$genes` and `genomeInfo$cytoBand`, respectively).
#'
#' Passing a named list of `CNSegment` objects, e.g.
#' `list(Tumor = seg1, Normal = seg2)`, stacks the samples vertically over a
#' shared genomic x-axis; the plot container is sized to fit them, and the
#' "Samples to Plot" control chooses which ones are shown.
#'
#' When called with no arguments, the app launches with the bundled
#' [example_cn_segment] object, on the settings the module gallery
#' ([sciModuleGalleryApp()]) opens this module on; a curated set of cancer genes
#' is labeled initially.
#'
#' @param seg A `CNSegment` object, as returned by [sesame::cnSegmentation()],
#'   or a named list of them to compare several samples. If `NULL` (the
#'   default), the bundled [example_cn_segment] is used.
#' @param defaults An optional named list of default input values, applied over
#'   the gallery's settings when the example data is used.
#' @param hide.inputs A character vector of input IDs to hide. Their values are
#'   still initialized and used, but the controls are not shown in the UI.
#' @param hide.tabs A character vector of tab names to hide. Inputs in these tabs
#'   are still initialized and used.
#' @param title The app title.
#' @return A Shiny app object.
#'
#' @import shiny
#' @importFrom shinyjs useShinyjs
#' @importFrom methods is
#'
#' @seealso [sciVizModules::cnSegmentPlotInputsUI()],
#' [sciVizModules::cnSegmentPlotOutputUI()],
#' [sciVizModules::cnSegmentPlotServer()], [sciVizModules::cnSegmentPlot()]
#'
#' @export
#' @author Jared Andrews
#' @examples
#' library(sciVizModules)
#' # Launch with the bundled example data:
#' app <- cnSegmentPlotApp()
#' if (interactive()) shiny::runApp(app)
#'
#' # Compare several samples, stacked over a shared genomic x-axis:
#' data(example_cn_segment)
#' shifted <- example_cn_segment
#' shifted$bin.signals <- shifted$bin.signals + 0.2
#' app <- cnSegmentPlotApp(list(Tumor = example_cn_segment, Normal = shifted))
#' if (interactive()) shiny::runApp(app)
cnSegmentPlotApp <- function(seg = NULL,
                             defaults = NULL,
                             hide.inputs = NULL,
                             hide.tabs = NULL,
                             title = "Array Copy Number Segments") {
    if (is.null(seg)) {
        example <- .sci_module_example("cnseg", defaults)
        seg <- example$data_list[[1]]
        defaults <- example$defaults
    }
    seg.list <- .cn_seg_as_list(seg)

    # Stacked panels need vertical room; the figure still autosizes, so the
    # container remains draggable.
    plot.height <- paste0(max(400, 200 * length(seg.list)), "px")

    ui <- fluidPage(
        title = title,
        useShinyjs(),
        sidebarLayout(
            sidebarPanel(
                cnSegmentPlotInputsUI(
                    "cn_plot", seg.list,
                    title = h3(title), defaults = defaults
                )
            ),
            mainPanel(
                cnSegmentPlotOutputUI("cn_plot", height = plot.height)
            )
        )
    )

    server <- function(input, output, session) {
        seg_reactive <- reactive(seg.list)
        do.call(cnSegmentPlotServer, .sci_server_args("cn_plot", seg_reactive, defaults, hide.inputs, hide.tabs))
    }

    shinyApp(ui, server)
}


#' Segments of a copy-number input, for a read-only preview
#'
#' @param seg A `CNSegment` object or a list of them.
#' @return The segments of every sample, stacked.
#'
#' @author Jared Andrews
#' @rdname INTERNAL_cn_preview
#' @keywords internal
.cn_preview <- function(seg) {
    do.call(rbind, lapply(.cn_seg_as_list(seg), function(s) as.data.frame(s$seg.signals)))
}
