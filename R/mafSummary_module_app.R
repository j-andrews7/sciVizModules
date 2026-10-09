#' Create a standalone Shiny app for the mafSummary module
#'
#' Generates a Shiny application with modular MAF-summary components, built
#' with [VizModules::createModuleApp()]: data import, a filterable data table,
#' and the plot with its settings.
#'
#' @param data_list An optional named list of MAF data frames or maftools `MAF`
#'   objects. If `NULL` (the default), the TCGA LAML cohort maftools ships is
#'   used (needs maftools).
#' @return A Shiny app object.
#'
#' @seealso [mafSummary()], [sciVizModules::mafSummaryInputsUI()], [sciVizModules::mafSummaryOutputUI()],
#' [sciVizModules::mafSummaryServer()]
#'
#' @export
#' @author Jared Andrews
#' @examples
#' library(sciVizModules)
#' if (requireNamespace("maftools", quietly = TRUE)) {
#'     app <- mafSummaryApp()
#'     if (interactive()) shiny::runApp(app)
#' }
mafSummaryApp <- function(data_list = NULL) {
    .maf_module_app(mafSummaryInputsUI, mafSummaryOutputUI, mafSummaryServer, data_list, "Modular MAF Summary")
}
