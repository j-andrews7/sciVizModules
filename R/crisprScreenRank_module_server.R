#' Server logic for the crisprScreenRank module
#'
#' Ranks the genes of a MAGeCK RRA or MLE gene summary for the chosen
#' selection by the plotted statistic, flags hits by FDR, and plots them through
#' [VizModules::dittoViz_scatterPlotServer()]. Its `fig.fn` hook titles the
#' axes, labels the top genes and draws the FDR cut-off.
#'
#' @param id The ID for the Shiny module.
#' @param data A `reactive` containing a MAGeCK RRA or MLE gene summary, from
#'   [read_mageck()] or read with `read.delim()`.
#' @param hide.inputs A character vector of input IDs to hide.
#' @param hide.tabs A character vector of tab names to hide. Default hides the
#'   scatter module's "Trajectory" and "Facet" tabs.
#' @param defaults A named list of default values, merged over the rank-plot
#'   defaults (user values win) and used to restore state on reset.
#' @return The value returned by [VizModules::dittoViz_scatterPlotServer()].
#'
#' @import shiny
#' @importFrom VizModules dittoViz_scatterPlotServer
#'
#' @seealso [read_mageck()], [sciVizModules::crisprScreenRankInputsUI()],
#' [sciVizModules::crisprScreenRankOutputUI()], [sciVizModules::crisprScreenRankApp()]
#' @examples
#' library(sciVizModules)
#' if (interactive()) crisprScreenRankApp()
#' @export
#' @author Jared Andrews
crisprScreenRankServer <- function(id, data, hide.inputs = NULL, hide.tabs = c("Trajectory", "Facet"),
                                   defaults = NULL) {
    stopifnot(is.reactive(data))
    d <- .crispr_defaults(NULL, defaults)
    scatter_defaults <- d[setdiff(names(d), .crispr_keys)]

    prepared <- moduleServer(id, function(input, output, session) {
        observeEvent(input$reset, {
            update_viz_select(session, "direction", selected = d$direction)
            update_viz_select(session, "metric", selected = d$metric)
            updateNumericInput(session, "fdr.threshold", value = d$fdr.threshold)
            updateNumericInput(session, "n.labels", value = d$n.labels)
            updateNumericInput(session, "label.size", value = d$label.size)
            conds <- .mageck_conditions(data())
            if (length(conds)) {
                update_viz_select(session, "condition",
                    selected = if (isTRUE(d$condition %in% conds)) d$condition else conds[1]
                )
            }
        })

        reactive({
            df <- data()
            req(df)
            isolate_fn <- setup_auto_update_logic(input)
            direction <- isolate_fn(input$direction)
            metric <- isolate_fn(input$metric)
            thr <- isolate_fn(input$fdr.threshold)
            req(nz_value(direction), nz_value(metric), !is.null(thr))
            .crispr_prepare(df, direction, metric, thr, isolate_fn(input$condition))
        })
    })

    dittoViz_scatterPlotServer(
        id = id,
        data = prepared,
        hide.inputs = hide.inputs,
        hide.tabs = hide.tabs,
        defaults = scatter_defaults,
        fig.fn = function(fig, input, isolate_fn) .crispr_layers(fig, prepared(), input, isolate_fn)
    )
}
