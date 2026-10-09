#' Create a standalone Shiny app for the deHeatmap module
#'
#' Generates a Shiny application with a selector over the supplied experiments
#' and their results, a read-only preview of the selected experiment's sample
#' metadata, and the interactive heatmap with its settings. Needs
#' ComplexHeatmap, InteractiveComplexHeatmap and circlize.
#'
#' When `bundle_list` is not provided (or `NULL`), the app launches with the
#' airway RNA-seq counts from the airway package (needs airway) and their
#' DESeq2 results, [airway_deseq2].
#'
#' @param bundle_list An optional named list, each element
#'   `list(object = <SummarizedExperiment>, results = <data frame>)` or a
#'   `SummarizedExperiment` whose `rowData` holds the results.
#' @return A Shiny app object.
#'
#' @seealso [sciVizModules::deHeatmapInputsUI()], [sciVizModules::deHeatmapOutputUI()],
#' [sciVizModules::deHeatmapServer()], [sciVizModules::airway_deseq2]
#'
#' @export
#' @author Jared Andrews
#' @examples
#' library(sciVizModules)
#' if (requireNamespace("InteractiveComplexHeatmap", quietly = TRUE) &&
#'     requireNamespace("circlize", quietly = TRUE) &&
#'     requireNamespace("airway", quietly = TRUE)) {
#'     app <- deHeatmapApp()
#'     if (interactive()) shiny::runApp(app)
#' }
deHeatmapApp <- function(bundle_list = NULL) {
    .assert_heatmap_packages()
    if (is.null(bundle_list)) {
        bundle_list <- list("airway (DESeq2)" = list(
            object = .se_example(),
            results = .sci_example_data("airway_deseq2")
        ))
    }
    .sci_object_app(
        deHeatmapInputsUI, deHeatmapOutputUI, deHeatmapServer, bundle_list, "DE Heatmap",
        validate = .de_resolve,
        preview = function(x) .se_coldata(.de_resolve(x)$se),
        select_label = "Select Experiment:",
        preview_title = "Sample Metadata",
        preview_note = "Read-only preview of the experiment's colData."
    )
}
