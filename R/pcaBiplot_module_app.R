#' Create a standalone Shiny app for the pcaBiplot module
#'
#' Generates a Shiny application with an object selector over the supplied
#' PCAtools `pca` objects, a read-only preview of the selected object's sample
#' metadata, and the biplot with its settings.
#'
#' @param pca_list An optional named list of PCAtools `pca` objects. If `NULL`
#'   (the default), the bundled [example_pca] is used.
#' @return A Shiny app object.
#'
#' @seealso [sciVizModules::pcaBiplotInputsUI()], [sciVizModules::pcaBiplotOutputUI()],
#' [sciVizModules::pcaBiplotServer()], [sciVizModules::example_pca]
#'
#' @export
#' @author Jared Andrews
#' @examples
#' library(sciVizModules)
#' app <- pcaBiplotApp()
#' if (interactive()) shiny::runApp(app)
pcaBiplotApp <- function(pca_list = NULL) {
    if (is.null(pca_list)) {
        pca_list <- list("example_pca" = .sci_example_data("example_pca"))
    }
    .pca_module_app(
        inputs_ui_fn = pcaBiplotInputsUI,
        output_ui_fn = pcaBiplotOutputUI,
        server_fn    = pcaBiplotServer,
        pca_list     = pca_list,
        title        = "Modular PCA Biplot"
    )
}
