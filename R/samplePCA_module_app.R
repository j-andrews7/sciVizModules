#' Create a standalone Shiny app for the samplePCA module
#'
#' Generates a Shiny application with a selector over the supplied experiments,
#' a read-only preview of the selected experiment's sample metadata, and the
#' sample PCA with its settings.
#'
#' When `object_list` is not provided (or `NULL`), the app launches with the
#' airway RNA-seq counts from the airway package (needs airway), on the
#' settings the module gallery ([sciModuleGalleryApp()]) opens this module on:
#' samples coloured by treatment, with an arrow from untreated to treated.
#'
#' @param object_list An optional named list of `SummarizedExperiment` objects.
#' @inheritParams volcanoPlotApp
#' @return A Shiny app object.
#'
#' @seealso [sample_pca()], [sciVizModules::samplePCAInputsUI()], [sciVizModules::samplePCAOutputUI()],
#' [sciVizModules::samplePCAServer()]
#'
#' @export
#' @author Jared Andrews
#' @examples
#' library(sciVizModules)
#' if (requireNamespace("airway", quietly = TRUE)) {
#'     app <- samplePCAApp()
#'     if (interactive()) shiny::runApp(app)
#' }
samplePCAApp <- function(object_list = NULL, defaults = NULL, hide.inputs = NULL, hide.tabs = NULL) {
    if (is.null(object_list)) {
        example <- .sci_module_example("samplepca", defaults)
        object_list <- example$data_list
        defaults <- example$defaults
    }
    .se_module_app(
        samplePCAInputsUI, samplePCAOutputUI, samplePCAServer, object_list, "Sample PCA",
        defaults = defaults, hide.inputs = hide.inputs, hide.tabs = hide.tabs
    )
}
