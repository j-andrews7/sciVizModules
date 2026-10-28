#' Create a standalone Shiny app for the gseaEnrichmentPlot module
#'
#' Generates a Shiny application with a selector over the supplied GSEA inputs,
#' a read-only preview of the selected input's results, and the enrichment plot
#' with its settings.
#'
#' @param gsea_list An optional named list of fgsea bundles or clusterProfiler
#'   `gseaResult` objects. If `NULL` (the default), the bundled [example_gsea]
#'   is used, on the settings the module gallery ([sciModuleGalleryApp()])
#'   opens this module on.
#' @inheritParams volcanoPlotApp
#' @return A Shiny app object.
#'
#' @seealso [sciVizModules::gseaEnrichmentPlotInputsUI()], [sciVizModules::gseaEnrichmentPlotOutputUI()],
#' [sciVizModules::gseaEnrichmentPlotServer()], [sciVizModules::example_gsea]
#'
#' @export
#' @author Jared Andrews
#' @examples
#' library(sciVizModules)
#' app <- gseaEnrichmentPlotApp()
#' if (interactive()) shiny::runApp(app)
gseaEnrichmentPlotApp <- function(gsea_list = NULL, defaults = NULL, hide.inputs = NULL, hide.tabs = NULL) {
    if (is.null(gsea_list)) {
        example <- .sci_module_example("gsea", defaults)
        gsea_list <- example$data_list
        defaults <- example$defaults
    }
    .sci_object_app(
        inputs_ui_fn = gseaEnrichmentPlotInputsUI,
        output_ui_fn = gseaEnrichmentPlotOutputUI,
        server_fn    = gseaEnrichmentPlotServer,
        object_list  = gsea_list,
        title        = "Modular GSEA Enrichment Plot",
        validate     = function(x) .assert_gsea(x, "gsea_list element"),
        preview      = .gsea_preview,
        select_label = "Select GSEA:",
        preview_title = "Gene Set Results",
        preview_note = "Read-only preview of the gene set results.",
        defaults     = defaults,
        hide.inputs  = hide.inputs,
        hide.tabs    = hide.tabs
    )
}


#' Gene set results of a GSEA input, for a read-only preview
#'
#' @param x An fgsea bundle or clusterProfiler `gseaResult`.
#' @return Its results table, or the gene sets and their sizes when it has none.
#'
#' @author Jared Andrews
#' @rdname INTERNAL_gsea_preview
#' @keywords internal
.gsea_preview <- function(x) {
    x <- .gsea_input(x)
    x$results %||% data.frame(pathway = names(x$pathways), size = lengths(x$pathways))
}
