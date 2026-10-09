#' Create a standalone Shiny app for the dittoDotPlot module
#'
#' This function generates a Shiny application with modular dittoDotPlot
#' components: a **Data** section for selecting among the provided objects, a
#' read-only **Metadata Preview**, and a **Plot** area for configuring and
#' displaying an interactive [dittoSeq::dittoDotPlot()].
#'
#' When `object_list` is not provided (or `NULL`), the app launches with the
#' bundled `example_sce` dataset.
#'
#' @param object_list An optional named list of `SingleCellExperiment`, `Seurat`,
#'   or `SummarizedExperiment` objects. If `NULL` (the default),
#'   `list("example_sce" = example_sce)` is used as example data.
#' @return A Shiny app object.
#'
#' @seealso [sciVizModules::dittoDotPlotInputsUI()], [sciVizModules::dittoDotPlotOutputUI()],
#' [sciVizModules::dittoDotPlotServer()], [sciVizModules::example_sce]
#'
#' @export
#' @author Jared Andrews
#' @examples
#' library(sciVizModules)
#' app <- dittoDotPlotApp()
#' if (interactive()) shiny::runApp(app)
dittoDotPlotApp <- function(object_list = NULL) {
    if (is.null(object_list)) {
        object_list <- list("example_sce" = .sci_example_data("example_sce"))
    }
    .ditto_module_app(
        inputs_ui_fn = dittoDotPlotInputsUI,
        output_ui_fn = dittoDotPlotOutputUI,
        server_fn    = dittoDotPlotServer,
        object_list  = object_list,
        title        = "Modular dittoDotPlot"
    )
}
