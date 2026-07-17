#' Server logic for the enrichmentDotPlot module
#'
#' This module builds an enrichment dot plot with
#' [VizModules::plotthis_DotPlotServer()] and renders it as an interactive
#' `plotly` figure. The incoming enrichment results are augmented with a numeric
#' `GeneRatio` column, a `neg_log10_pvalue` column, and a categorical grouping
#' column before being handed to the wrapped DotPlot server (see
#' [enrichmentDotPlotInputsUI()] for details).
#'
#' @param id The ID for the Shiny module.
#' @param data A `reactive` returning the enrichment results data frame.
#' @param hide.inputs A character vector of input IDs to hide.
#' @param hide.tabs A character vector of tab names to hide.
#' @param defaults A named list of default values used when resetting the inputs.
#'   Typically the same list passed to [enrichmentDotPlotInputsUI()].
#' @return The `moduleServer` function for the enrichmentDotPlot module.
#'
#' @import shiny
#' @import plotly
#' @importFrom VizModules plotthis_DotPlotServer
#'
#' @seealso [plotthis::DotPlot()], [VizModules::plotthis_DotPlotServer()],
#' [sciVizModules::enrichmentDotPlotInputsUI()], [sciVizModules::enrichmentDotPlotOutputUI()],
#' [sciVizModules::enrichmentDotPlotApp()]
#'
#' @export
#' @author Jacob Martin, Jared Andrews
enrichmentDotPlotServer <- function(id, data, hide.inputs = NULL, hide.tabs = NULL, defaults = NULL) {
    stopifnot(is.reactive(data))

    # Augment the enrichment data with the derived numeric columns and grouping
    # column so the DotPlot server sees the same columns the UI offered.
    enriched_data <- reactive({
        req(data())
        .prepare_enrichment(data())$data
    })

    # Resolve reset defaults from an isolated snapshot so the reset button
    # restores the enrichment-aware selections rather than the generic DotPlot
    # fallbacks. Falls back to the user-supplied defaults when no data is ready.
    resolved_defaults <- tryCatch({
        snapshot <- isolate(data())
        if (is.null(snapshot) || nrow(as.data.frame(snapshot)) == 0) {
            defaults
        } else {
            .enrich_defaults(defaults, .prepare_enrichment(snapshot)$mapping)
        }
    }, error = function(e) defaults)

    plotthis_DotPlotServer(
        id = id,
        data = enriched_data,
        hide.inputs = hide.inputs,
        hide.tabs = hide.tabs,
        defaults = resolved_defaults
    )
}
