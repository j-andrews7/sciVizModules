#' Server logic for the pcaBiplot module
#'
#' Plots the sample scores of a PCAtools `pca` object through
#' [VizModules::dittoViz_scatterPlotServer()], and uses its `fig.fn` hook to title
#' the axes with each component's explained variance and to draw the loading
#' arrows.
#'
#' @param id The ID for the Shiny module.
#' @param data A `reactive` returning a PCAtools `pca` object.
#' @param hide.inputs A character vector of input IDs to hide.
#' @param hide.tabs A character vector of tab names to hide. Default hides the
#'   scatter module's "Trajectory" tab.
#' @param defaults A named list of default values, merged over the biplot
#'   defaults (user values win) and used to restore state on reset.
#' @return The value returned by [VizModules::dittoViz_scatterPlotServer()].
#'
#' @import shiny
#' @importFrom shinyWidgets updateMaterialSwitch
#' @importFrom colourpicker updateColourInput
#' @importFrom VizModules dittoViz_scatterPlotServer
#'
#' @seealso [PCAtools::biplot()], [sciVizModules::pcaBiplotInputsUI()],
#' [sciVizModules::pcaBiplotOutputUI()], [sciVizModules::pcaBiplotApp()]
#'
#' @examples
#' library(sciVizModules)
#' if (interactive()) pcaBiplotApp()
#' @export
#' @author Jared Andrews
pcaBiplotServer <- function(id, data, hide.inputs = NULL, hide.tabs = "Trajectory", defaults = NULL) {
    stopifnot(is.reactive(data))

    pca_data <- reactive({
        p <- data()
        req(p)
        .assert_pca(p)
    })

    bi_defaults <- .pca_biplot_defaults(tryCatch(isolate(data()), error = function(e) NULL), defaults)
    scatter_defaults <- bi_defaults[setdiff(names(bi_defaults), .pca_biplot_keys)]

    # Restore the biplot's own inputs on Reset; the wrapped scatter server resets
    # everything else.
    moduleServer(id, function(input, output, session) {
        observeEvent(input$reset, {
            updateMaterialSwitch(session, "show.loadings", value = get_default(bi_defaults, "show.loadings", FALSE))
            updateNumericInput(session, "n.top.loadings", value = get_default(bi_defaults, "n.top.loadings", 5))
            updateNumericInput(session, "loadings.length.factor",
                value = get_default(bi_defaults, "loadings.length.factor", 1.5))
            updateColourInput(session, "loadings.color", value = get_default(bi_defaults, "loadings.color", "#000000"))
            updateNumericInput(session, "loadings.label.size",
                value = get_default(bi_defaults, "loadings.label.size", 12))
        })
    })

    biplot_layers <- function(fig, input, isolate_fn) {
        .pca_biplot_layers(fig, pca_data(), input, isolate_fn)
    }

    dittoViz_scatterPlotServer(
        id = id,
        data = reactive(.pca_scores_df(pca_data())),
        hide.inputs = hide.inputs,
        hide.tabs = hide.tabs,
        defaults = scatter_defaults,
        fig.fn = biplot_layers
    )
}
