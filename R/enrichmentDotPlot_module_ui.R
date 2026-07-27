#' Input UI components for the enrichmentDotPlot module
#'
#' This should be placed in the UI where the inputs should be shown, with an `id`
#' that matches the `id` used in the `enrichmentDotPlotServer()` and
#' `enrichmentDotPlotOutputUI()` functions.
#'
#' @details The user inputs for this module are separated from the outputs to allow for
#' more flexible UI design.
#'
#' This module wraps [VizModules::plotthis_DotPlotInputsUI()] and pre-configures
#' it for functional enrichment results (e.g. the output of
#' `clusterProfiler::enrichGO()` or `clusterProfiler::compareCluster()`). It is
#' designed to interpret enrichment tables as a dot plot where the enrichment
#' terms are on the y-axis, a grouping variable is on the x-axis, dot size
#' encodes the gene ratio, and dot color encodes significance.
#'
#' The data are automatically augmented before being passed to the wrapped
#' DotPlot UI so that the appropriate defaults can be selected:
#'
#' - A numeric `GeneRatio` column is derived when the incoming
#'   `GeneRatio` is a `"count/total"` fraction string.
#' - A `neg_log10_pvalue` column (\eqn{-\log_{10}(p)}) is derived from
#'   the first available p-value column (`p.adjust`, `padj`,
#'   `FDR`, `qvalue`, `pvalue`, ...).
#' - A categorical grouping column is guaranteed for the x-axis (a constant
#'   `Group` column is added when none is detected).
#'
#' @section Enrichment defaults:
#' The following defaults are selected automatically (any value supplied via
#' `defaults` takes precedence):
#'
#' - `y.data` - The enrichment term column (e.g. `Description`)
#' - `x.data` - A grouping column (e.g. `Cluster`) or a constant
#'   `Group` column when none is present
#' - `size.by` - `GeneRatio` (or another detected ratio column)
#' - `fill.by` - `neg_log10_pvalue`
#'
#' All other [plotthis::DotPlot()] parameters remain available via the wrapped UI.
#'
#' @param id The ID for the Shiny module.
#' @param data The enrichment results data frame used for plot generation.
#' @param defaults A named list of default values for the inputs.
#' @param title An optional title for the UI grid.
#' @param columns Number of columns for the UI grid.
#' @return A Shiny tagList containing the UI elements
#'
#' @import shiny
#' @importFrom VizModules plotthis_DotPlotInputsUI
#'
#' @export
#' @author Jacob Martin, Jared Andrews
#' @seealso [plotthis::DotPlot()], [VizModules::plotthis_DotPlotInputsUI()],
#' [sciVizModules::enrichmentDotPlotOutputUI()], [sciVizModules::enrichmentDotPlotServer()],
#' [sciVizModules::enrichmentDotPlotApp()]
#' @examples
#' library(sciVizModules)
#' data(example_enrichment)
#' enrichmentDotPlotInputsUI("enrichmentDotPlot", example_enrichment)
enrichmentDotPlotInputsUI <- function(id, data, defaults = NULL, title = "Enrichment DotPlot Settings", columns = 2) {
    stopifnot(is.data.frame(data))

    prepared <- .prepare_enrichment(data)
    defaults <- .enrich_defaults(defaults, prepared$mapping)

    plotthis_DotPlotInputsUI(
        id = id,
        data = prepared$data,
        defaults = defaults,
        title = if (is.null(title)) NULL else if (inherits(title, c("shiny.tag", "shiny.tag.list"))) title else h3(title),
        columns = columns
    )
}


#' Output UI components for the enrichmentDotPlot module
#'
#' This should be placed in the UI where the plot should be shown.
#'
#' @param id The ID for the Shiny module.
#' @param resizable Logical; when `TRUE` (the default) the plot output is
#'   wrapped in [shinyjqui::jqui_resizable()] so it can be resized by dragging.
#'
#' @return A Shiny plotlyOutput for the enrichment dot plot.
#'
#' @import shiny
#' @importFrom VizModules plotthis_DotPlotOutputUI
#'
#' @export
#' @author Jacob Martin, Jared Andrews
enrichmentDotPlotOutputUI <- function(id, resizable = TRUE) {
    plotthis_DotPlotOutputUI(id, resizable = resizable)
}
