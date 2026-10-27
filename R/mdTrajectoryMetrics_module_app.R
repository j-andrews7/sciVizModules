#' Create a standalone Shiny app for the mdTrajectoryMetrics module
#'
#' Generates a Shiny application with modular molecular dynamics trajectory
#' components, built with [VizModules::createModuleApp()]: data import, a
#' filterable data table, and the plot with its settings.
#'
#' When `data_list` is not provided (or `NULL`), the app launches with the
#' bundled simulated GROMACS outputs, read with [read_xvg()]: three RMSD
#' replicas with a radius of gyration trace, and a per-residue RMSF. The first
#' opens on the settings the module gallery ([sciModuleGalleryApp()]) shows it
#' with: each series smoothed over its faded raw trace.
#'
#' @param data_list An optional named list of data frames, e.g. from [read_xvg()].
#' @inheritParams volcanoPlotApp
#' @return A Shiny app object.
#'
#' @seealso [read_xvg()], [sciVizModules::mdTrajectoryMetricsInputsUI()],
#' [sciVizModules::mdTrajectoryMetricsOutputUI()], [sciVizModules::mdTrajectoryMetricsServer()]
#'
#' @export
#' @author Jared Andrews
#' @examples
#' library(sciVizModules)
#' app <- mdTrajectoryMetricsApp()
#' if (interactive()) shiny::runApp(app)
mdTrajectoryMetricsApp <- function(data_list = NULL, defaults = NULL, hide.inputs = NULL, hide.tabs = NULL) {
    if (is.null(data_list)) {
        example <- .sci_module_example("md", defaults)
        data_list <- example$data_list
        defaults <- example$defaults
    }
    stopifnot(is.list(data_list), length(data_list) >= 1)
    lapply(data_list, function(data) stopifnot(is.data.frame(data)))

    createModuleApp(
        inputs_ui_fn = mdTrajectoryMetricsInputsUI,
        output_ui_fn = mdTrajectoryMetricsOutputUI,
        server_fn    = mdTrajectoryMetricsServer,
        data_list    = data_list,
        defaults     = defaults,
        hide.inputs  = hide.inputs,
        hide.tabs    = hide.tabs,
        title        = "Modular MD Trajectory Metrics"
    )
}
