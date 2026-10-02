#' Input UI components for the gseaEnrichmentPlot module
#'
#' This should be placed in the UI where the inputs should be shown, with an `id`
#' that matches the `id` used in the `gseaEnrichmentPlotServer()` and
#' `gseaEnrichmentPlotOutputUI()` functions.
#'
#' @details The module draws [gseaEnrichmentPlot()]: the running enrichment
#' score of one or more gene sets over the ranked gene list, with hit ticks and
#' the ranked statistic below. It takes either an fgsea bundle - `list(stats =
#' <named numeric>, pathways = <named list>, results = <fgsea table, optional>)`
#' - or a clusterProfiler `gseaResult`. The inputs are organised into tabs via
#' [VizModules::organize_inputs()].
#'
#' @section Plot parameters and defaults:
#' The following parameters can be accessed via UI inputs and/or the `defaults` argument:
#'
#' - `pathways` - Gene sets to plot (default: the three most significant)
#' - `gsea.param` - Weight exponent of the running score (default: 1; fgsea `gseaParam`)
#' - `show.ticks` - Draw the hit ticks (default: TRUE)
#' - `show.metric` - Draw the ranked statistic (default: TRUE)
#' - `palette.colours` - Named gene set colours (multiColorPicker)
#' - `metric.color` - Colour of the ranked statistic (default: "#7F7F7F")
#'
#' The Legend, Axes and Plotly tabs carry the shared VizModules inputs.
#'
#' @param id The ID for the Shiny module.
#' @param data An fgsea bundle or a clusterProfiler `gseaResult`.
#' @param defaults A named list of default values for the inputs.
#' @param title An optional title for the UI grid.
#' @param columns Number of columns for the UI grid.
#' @return A Shiny tagList containing the UI elements
#'
#' @import shiny
#' @importFrom shinyWidgets materialSwitch
#' @importFrom colourpicker colourInput
#'
#' @export
#' @author Jared Andrews
#' @seealso [gseaEnrichmentPlot()], [sciVizModules::gseaEnrichmentPlotOutputUI()],
#' [sciVizModules::gseaEnrichmentPlotServer()], [sciVizModules::gseaEnrichmentPlotApp()]
#' @examples
#' library(sciVizModules)
#' data(example_gsea)
#' gseaEnrichmentPlotInputsUI("gsea", example_gsea)
gseaEnrichmentPlotInputsUI <- function(id, data, defaults = NULL, title = "GSEA Plot Settings", columns = 2) {
    ns <- NS(id)
    x <- .assert_gsea(data)
    choices <- stats::setNames(names(x$pathways), x$labels[names(x$pathways)] %||% names(x$pathways))

    data_tab <- tagList(
        .sci_tip(viz_select_input(ns("pathways"), "Gene Sets",
            choices = choices, selected = get_default(defaults, "pathways", .gsea_default_pathways(x)),
            multiple = TRUE
        ), "Gene sets to plot; each gets its own running score and tick row."),
        .sci_tip(numericInput(ns("gsea.param"), "Weight Exponent",
            value = get_default(defaults, "gsea.param", 1, is.numeric), min = 0, step = 0.5
        ), "Exponent on the gene statistics when stepping up the running score (1 is standard GSEA; 0 unweighted)."),
        .sci_tip(materialSwitch(ns("show.ticks"), "Hit Ticks",
            value = get_default(defaults, "show.ticks", TRUE, is.logical), status = "success"
        ), "Draw a tick for each gene of the set at its rank."),
        .sci_tip(materialSwitch(ns("show.metric"), "Ranked Metric",
            value = get_default(defaults, "show.metric", TRUE, is.logical), status = "success"
        ), "Draw the ranked gene statistic beneath.")
    )
    aes_tab <- tagList(
        uiOutput(ns("palette.selection")),
        .sci_tip(colourInput(ns("metric.color"), "Metric Color", value = get_default(defaults, "metric.color", "#7F7F7F")),
            "Colour of the ranked statistic.")
    )

    .sci_plot_inputs_ui(ns, "gseaEnrichmentPlot", data_tab, aes_tab, defaults, title, columns, lines = FALSE)
}


#' Output UI components for the gseaEnrichmentPlot module
#'
#' @param id The ID for the Shiny module.
#' @param resizable Logical; when `TRUE` (the default) the plot output can be resized by dragging.
#' @return A Shiny plotlyOutput for the GSEA plot.
#'
#' @examples
#' gseaEnrichmentPlotOutputUI("gsea")
#' @export
#' @author Jared Andrews
gseaEnrichmentPlotOutputUI <- function(id, resizable = TRUE) {
    .sci_plot_output_ui(id, "gseaEnrichmentPlot", resizable = resizable, height = "600px")
}
