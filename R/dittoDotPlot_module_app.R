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
#' With the example data, the app opens on the settings the module gallery
#' ([sciModuleGalleryApp()]) opens this module on.
#'
#' @param object_list An optional named list of `SingleCellExperiment`, `Seurat`,
#'   or `SummarizedExperiment` objects. If `NULL` (the default),
#'   `list("example_sce" = example_sce)` is used as example data.
#' @inheritParams volcanoPlotApp
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
dittoDotPlotApp <- function(object_list = NULL, defaults = NULL, hide.inputs = NULL, hide.tabs = NULL) {
    if (is.null(object_list)) {
        example <- .sci_module_example("dotplot", defaults)
        object_list <- example$data_list
        defaults <- example$defaults
    }
    .ditto_module_app(
        inputs_ui_fn = dittoDotPlotInputsUI,
        output_ui_fn = dittoDotPlotOutputUI,
        server_fn    = dittoDotPlotServer,
        object_list  = object_list,
        defaults     = defaults,
        hide.inputs  = hide.inputs,
        hide.tabs    = hide.tabs,
        title        = "Modular dittoDotPlot"
    )
}
