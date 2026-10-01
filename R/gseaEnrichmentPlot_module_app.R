#' Create a standalone Shiny app for the gseaEnrichmentPlot module
#'
#' Generates a Shiny application with a selector over the supplied GSEA inputs,
#' a read-only preview of the selected input's results, and the enrichment plot
#' with its settings.
#'
#' @param gsea_list An optional named list of fgsea bundles or clusterProfiler
#'   `gseaResult` objects. If `NULL` (the default), the bundled [example_gsea]
#'   is used.
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
gseaEnrichmentPlotApp <- function(gsea_list = NULL) {
    if (is.null(gsea_list)) {
        gsea_list <- list("example_gsea" = .sci_example_data("example_gsea"))
    }
    .sci_object_app(
        inputs_ui_fn = gseaEnrichmentPlotInputsUI,
        output_ui_fn = gseaEnrichmentPlotOutputUI,
        server_fn    = gseaEnrichmentPlotServer,
        object_list  = gsea_list,
        title        = "Modular GSEA Enrichment Plot",
        validate     = function(x) .assert_gsea(x, "gsea_list element"),
        preview      = function(x) {
            x <- .gsea_input(x)
            x$results %||% data.frame(pathway = names(x$pathways), size = lengths(x$pathways))
        },
        select_label = "Select GSEA:",
        preview_title = "Gene Set Results",
        preview_note = "Read-only preview of the gene set results."
    )
}
