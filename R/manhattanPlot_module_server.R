#' Server logic for the manhattanPlot module
#'
#' Lays the variants of GWAS summary statistics end to end along the genome,
#' thins the non-significant ones if asked, and plots them through
#' [VizModules::dittoViz_scatterPlotServer()]. Its `fig.fn` hook labels the
#' x-axis with chromosome names and draws the significance lines.
#'
#' @param id The ID for the Shiny module.
#' @param data A `reactive` containing a data frame of GWAS summary statistics.
#' @param hide.inputs A character vector of input IDs to hide.
#' @param hide.tabs A character vector of tab names to hide. Default hides the
#'   scatter module's "Trajectory" tab.
#' @param defaults A named list of default values, merged over the Manhattan
#'   defaults (user values win) and used to restore state on reset.
#' @return The value returned by [VizModules::dittoViz_scatterPlotServer()].
#'
#' @import shiny
#' @importFrom VizModules dittoViz_scatterPlotServer
#'
#' @seealso [sciVizModules::manhattanPlotInputsUI()], [sciVizModules::manhattanPlotOutputUI()],
#' [sciVizModules::manhattanPlotApp()], [sciVizModules::gwasQQPlotServer()]
#' @examples
#' library(sciVizModules)
#' if (interactive()) manhattanPlotApp()
#' @export
#' @author Jared Andrews
manhattanPlotServer <- function(id, data, hide.inputs = NULL, hide.tabs = "Trajectory", defaults = NULL) {
    stopifnot(is.reactive(data))
    d <- .manhattan_defaults(tryCatch(isolate(data()), error = function(e) NULL), defaults)
    scatter_defaults <- d[setdiff(names(d), .manhattan_keys)]

    res <- moduleServer(id, function(input, output, session) {
        prepared <- reactive({
            df <- data()
            req(df)
            isolate_fn <- setup_auto_update_logic(input)
            chr <- isolate_fn(input$chr.col)
            bp <- isolate_fn(input$bp.col)
            p <- isolate_fn(input$p.col)
            req(nz_value(chr), nz_value(bp), nz_value(p))
            .gwas_prepare(df, chr, bp, p)
        })

        thinned <- reactive({
            df <- prepared()
            isolate_fn <- setup_auto_update_logic(input)
            if (!isTRUE(isolate_fn(input$thin))) {
                return(df)
            }
            .gwas_thin(df, isolate_fn(input$p.col), isolate_fn(input$thin.p) %||% 0.01,
                isolate_fn(input$thin.fraction) %||% 1)
        })

        # The wrapped scatter server resets its own inputs; these are the
        # Manhattan module's.
        observeEvent(input$reset, {
            .gwas_reset_inputs(session, d)
            updateNumericInput(session, "sig.threshold", value = d$sig.threshold)
            updateNumericInput(session, "suggestive.threshold", value = d$suggestive.threshold)
        })

        list(data = thinned, centres = reactive(attr(prepared(), "centres")))
    })

    dittoViz_scatterPlotServer(
        id = id,
        data = res$data,
        hide.inputs = hide.inputs,
        hide.tabs = hide.tabs,
        defaults = scatter_defaults,
        fig.fn = function(fig, input, isolate_fn) .manhattan_layers(fig, res$centres(), input, isolate_fn)
    )
}
