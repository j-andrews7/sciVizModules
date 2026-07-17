#' Create a standalone Shiny app for the dittoFreqPlot module
#'
#' This function generates a Shiny application with modular frequency-plot
#' components. The app features a **Data** section for selecting among the
#' provided objects, a read-only **Metadata Preview**, and a **Plot** area for
#' configuring and displaying an interactive [dittoSeq::dittoFreqPlot()].
#'
#' When `object_list` is not provided (or `NULL`), the app launches with the
#' bundled `example_sce` dataset.
#'
#' @param object_list An optional named list of `SingleCellExperiment`, `Seurat`,
#'   or `SummarizedExperiment` objects. If `NULL` (the default),
#'   `list("example_sce" = example_sce)` is used as example data.
#' @return A Shiny app object.
#'
#' @seealso [sciVizModules::dittoFreqPlotInputsUI()], [sciVizModules::dittoFreqPlotOutputUI()],
#' [sciVizModules::dittoFreqPlotServer()], [sciVizModules::example_sce]
#'
#' @export
#' @author Jacob Martin, Jared Andrews
#' @examples
#' library(sciVizModules)
#' # Launch with default example data:
#' app <- dittoFreqPlotApp()
#' if (interactive()) shiny::runApp(app)
dittoFreqPlotApp <- function(object_list = NULL) {
    if (is.null(object_list)) {
        object_list <- list("example_sce" = example_sce)
    }
    .ditto_module_app(
        inputs_ui_fn = dittoFreqPlotInputsUI,
        output_ui_fn = dittoFreqPlotOutputUI,
        server_fn    = dittoFreqPlotServer,
        object_list  = object_list,
        title        = "Modular FreqPlot"
    )
}
