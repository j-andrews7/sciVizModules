#' Create a standalone Shiny app for the oncoPlot module
#'
#' Generates a Shiny application with modular oncoplot components, built with
#' [VizModules::createModuleApp()]: data import, a filterable data table, and
#' the plot with its settings. Filtering the table (to one subtype, say) redraws
#' the oncoplot for those variants.
#'
#' @param data_list An optional named list of MAF data frames or maftools `MAF`
#'   objects. If `NULL` (the default), the TCGA LAML cohort maftools ships is
#'   used (needs maftools).
#' @return A Shiny app object.
#'
#' @seealso [oncoPlot()], [sciVizModules::oncoPlotInputsUI()], [sciVizModules::oncoPlotOutputUI()],
#' [sciVizModules::oncoPlotServer()]
#'
#' @export
#' @author Jared Andrews
#' @examples
#' library(sciVizModules)
#' if (requireNamespace("maftools", quietly = TRUE)) {
#'     app <- oncoPlotApp()
#'     if (interactive()) shiny::runApp(app)
#' }
oncoPlotApp <- function(data_list = NULL) {
    .maf_module_app(oncoPlotInputsUI, oncoPlotOutputUI, oncoPlotServer, data_list, "Modular Oncoplot")
}
