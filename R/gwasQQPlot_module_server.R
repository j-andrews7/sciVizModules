#' Server logic for the gwasQQPlot module
#'
#' Computes observed against expected -log10(p) from GWAS summary statistics,
#' thins the points if asked, and plots them through
#' [VizModules::dittoViz_scatterPlotServer()]. Its `fig.fn` hook adds the
#' confidence band and lambda GC.
#'
#' @param id The ID for the Shiny module.
#' @param data A `reactive` containing a data frame of GWAS summary statistics.
#' @param hide.inputs A character vector of input IDs to hide.
#' @param hide.tabs A character vector of tab names to hide. Default hides the
#'   scatter module's "Trajectory" and "Facet" tabs.
#' @param defaults A named list of default values, merged over the QQ defaults
#'   (user values win) and used to restore state on reset.
#' @return The value returned by [VizModules::dittoViz_scatterPlotServer()].
#'
#' @import shiny
#' @importFrom shinyWidgets updateMaterialSwitch
#' @importFrom colourpicker updateColourInput
#' @importFrom VizModules dittoViz_scatterPlotServer
#'
#' @seealso [sciVizModules::gwasQQPlotInputsUI()], [sciVizModules::gwasQQPlotOutputUI()],
#' [sciVizModules::gwasQQPlotApp()], [sciVizModules::manhattanPlotServer()]
#' @examples
#' library(sciVizModules)
#' if (interactive()) gwasQQPlotApp()
#' @export
#' @author Jared Andrews
gwasQQPlotServer <- function(id, data, hide.inputs = NULL, hide.tabs = c("Trajectory", "Facet"), defaults = NULL) {
    stopifnot(is.reactive(data))
    d <- .gwas_qq_defaults(tryCatch(isolate(data()), error = function(e) NULL), defaults)
    scatter_defaults <- d[setdiff(names(d), .gwas_qq_keys)]

    res <- moduleServer(id, function(input, output, session) {
        full <- reactive({
            df <- data()
            req(df)
            isolate_fn <- setup_auto_update_logic(input)
            p <- isolate_fn(input$p.col)
            req(nz_value(p))
            .gwas_qq_frame(df, p, blank_to_null(isolate_fn(input$snp.col)))
        })

        plotted <- reactive({
            qq <- full()
            isolate_fn <- setup_auto_update_logic(input)
            if (!isTRUE(isolate_fn(input$thin))) {
                return(qq)
            }
            .gwas_thin(qq, "qq.p", isolate_fn(input$thin.p) %||% 0.01, isolate_fn(input$thin.fraction) %||% 1)
        })

        observeEvent(input$reset, {
            .gwas_reset_inputs(session, d)
            updateMaterialSwitch(session, "show.band", value = isTRUE(d$show.band))
            updateNumericInput(session, "ci.level", value = d$ci.level)
            updateColourInput(session, "band.color", value = d$band.color)
            updateNumericInput(session, "band.opacity", value = d$band.opacity)
            updateMaterialSwitch(session, "show.lambda", value = isTRUE(d$show.lambda))
        })

        list(data = plotted, full = full)
    })

    dittoViz_scatterPlotServer(
        id = id,
        data = res$data,
        hide.inputs = hide.inputs,
        hide.tabs = hide.tabs,
        defaults = scatter_defaults,
        fig.fn = function(fig, input, isolate_fn) {
            full <- res$full()
            .gwas_qq_layers(fig, attr(full, "n"), attr(full, "lambda"), input, isolate_fn)
        }
    )
}
