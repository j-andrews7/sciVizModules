#' Create a standalone Shiny app for the mutationLollipop module
#'
#' Generates a Shiny application with modular lollipop-plot components, built
#' with [VizModules::createModuleApp()]: data import, a filterable data table,
#' and the plot with its settings. Domains come from maftools when it is
#' installed.
#'
#' @param data_list An optional named list of MAF data frames or maftools `MAF`
#'   objects. If `NULL` (the default), the TCGA LAML cohort maftools ships is
#'   used (needs maftools).
#' @return A Shiny app object.
#'
#' @seealso [mutationLollipop()], [sciVizModules::mutationLollipopInputsUI()],
#' [sciVizModules::mutationLollipopOutputUI()], [sciVizModules::mutationLollipopServer()]
#'
#' @export
#' @author Jared Andrews
#' @examples
#' library(sciVizModules)
#' if (requireNamespace("maftools", quietly = TRUE)) {
#'     app <- mutationLollipopApp()
#'     if (interactive()) shiny::runApp(app)
#' }
mutationLollipopApp <- function(data_list = NULL) {
    .maf_module_app(mutationLollipopInputsUI, mutationLollipopOutputUI, mutationLollipopServer, data_list,
        "Modular Mutation Lollipop")
}
