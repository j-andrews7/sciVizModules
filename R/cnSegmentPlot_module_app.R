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
#' When called with no arguments, the app launches with the bundled
#' [example_cn_segment] object; a curated set of cancer genes is labeled
#' initially.
#'
#' @param seg A `CNSegment` object, as returned by [sesame::cnSegmentation()].
#'   Defaults to the bundled [example_cn_segment].
#' @param defaults An optional named list of default input values.
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
cnSegmentPlotApp <- function(seg = example_cn_segment,
                             defaults = NULL,
                             title = "Array Copy Number Segments") {
    stopifnot(is(seg, "CNSegment"))

    ui <- fluidPage(
        title = title,
        useShinyjs(),
        sidebarLayout(
            sidebarPanel(
                cnSegmentPlotInputsUI(
                    "cn_plot", seg,
                    title = h3(title), defaults = defaults
                )
            ),
            mainPanel(
                cnSegmentPlotOutputUI("cn_plot")
            )
        )
    )

    server <- function(input, output, session) {
        seg_reactive <- reactive(seg)
        cnSegmentPlotServer("cn_plot", data = seg_reactive, defaults = defaults)
    }

    shinyApp(ui, server)
}
