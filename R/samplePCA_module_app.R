#' Create a standalone Shiny app for the samplePCA module
#'
#' Generates a Shiny application with a selector over the supplied experiments,
#' a read-only preview of the selected experiment's sample metadata, and the
#' sample PCA with its settings.
#'
#' When `object_list` is not provided (or `NULL`), the app launches with the
#' airway RNA-seq counts from the airway package (needs airway).
#'
#' @param object_list An optional named list of `SummarizedExperiment` objects.
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
samplePCAApp <- function(object_list = NULL) {
    if (is.null(object_list)) {
        object_list <- list("airway" = .se_example())
    }
    .se_module_app(samplePCAInputsUI, samplePCAOutputUI, samplePCAServer, object_list, "Sample PCA")
}
