#' Create a standalone Shiny app for the mdTrajectoryMetrics module
#'
#' Generates a Shiny application with modular molecular dynamics trajectory
#' components, built with [VizModules::createModuleApp()]: data import, a
#' filterable data table, and the plot with its settings.
#'
#' When `data_list` is not provided (or `NULL`), the app launches with the
#' bundled simulated GROMACS outputs, read with [read_xvg()]: three RMSD
#' replicas with a radius of gyration trace, and a per-residue RMSF.
#'
#' @param data_list An optional named list of data frames, e.g. from [read_xvg()].
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
mdTrajectoryMetricsApp <- function(data_list = NULL) {
    if (is.null(data_list)) {
        ex <- .md_example()
        data_list <- list("RMSD and Rg (simulated)" = ex$trajectory, "RMSF (simulated)" = ex$rmsf)
    }
    stopifnot(is.list(data_list), length(data_list) >= 1)
    lapply(data_list, function(data) stopifnot(is.data.frame(data)))

    createModuleApp(
        inputs_ui_fn = mdTrajectoryMetricsInputsUI,
        output_ui_fn = mdTrajectoryMetricsOutputUI,
        server_fn    = mdTrajectoryMetricsServer,
        data_list    = data_list,
        title        = "Modular MD Trajectory Metrics"
    )
}
