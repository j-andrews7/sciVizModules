#' Create a standalone Shiny app for the deHeatmap module
#'
#' Generates a Shiny application with a selector over the supplied experiments
#' and their results, a read-only preview of the selected experiment's sample
#' metadata, and the interactive heatmap with its settings. Needs
#' ComplexHeatmap, InteractiveComplexHeatmap and circlize.
#'
#' When `bundle_list` is not provided (or `NULL`), the app launches with the
#' airway RNA-seq counts from the airway package (needs airway) and their
#' DESeq2 results, [airway_deseq2], on the settings the module gallery
#' ([sciModuleGalleryApp()]) opens this module on.
#'
#' @param bundle_list An optional named list, each element
#'   `list(object = <SummarizedExperiment>, results = <data frame>)` or a
#'   `SummarizedExperiment` whose `rowData` holds the results.
#' @inheritParams volcanoPlotApp
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
deHeatmapApp <- function(bundle_list = NULL, defaults = NULL, hide.inputs = NULL, hide.tabs = NULL) {
    .assert_heatmap_packages()
    if (is.null(bundle_list)) {
        example <- .sci_module_example("deheatmap", defaults)
        bundle_list <- example$data_list
        defaults <- example$defaults
    }
    .sci_object_app(
        deHeatmapInputsUI, deHeatmapOutputUI, deHeatmapServer, bundle_list, "DE Heatmap",
        validate = .de_resolve,
        preview = .de_preview,
        select_label = "Select Experiment:",
        preview_title = "Sample Metadata",
        preview_note = "Read-only preview of the experiment's colData.",
        defaults = defaults, hide.inputs = hide.inputs, hide.tabs = hide.tabs
    )
}


#' Sample metadata of a deHeatmap input, for a read-only preview
#'
#' @param x A deHeatmap input (see [.de_resolve()]).
#' @return The experiment's `colData` as a data frame.
#'
#' @author Jared Andrews
#' @rdname INTERNAL_de_preview
#' @keywords internal
.de_preview <- function(x) {
    .se_coldata(.de_resolve(x)$se)
}
