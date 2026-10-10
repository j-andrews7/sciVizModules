#' Create a standalone Shiny app for the mutationalProfile module
#'
#' Generates a Shiny application with modular mutational-spectrum components,
#' built with [VizModules::createModuleApp()]: data import, a filterable data
#' table, and the plot with its settings.
#'
#' @param data_list An optional named list of 96-channel substitution count
#'   matrices or data frames. If `NULL` (the default), the simulated
#'   [example_sbs96] spectra are used.
#' @return A Shiny app object.
#'
#' @seealso [sciVizModules::mutationalProfileInputsUI()], [sciVizModules::mutationalProfileOutputUI()],
#' [sciVizModules::mutationalProfileServer()], [sciVizModules::example_sbs96]
#'
#' @importFrom VizModules createModuleApp
#'
#' @export
#' @author Jared Andrews
#' @examples
#' library(sciVizModules)
#' app <- mutationalProfileApp()
#' if (interactive()) shiny::runApp(app)
mutationalProfileApp <- function(data_list = NULL) {
    if (is.null(data_list)) {
        data_list <- list("example_sbs96" = .sci_example_data("example_sbs96"))
    }
    stopifnot(is.list(data_list), length(data_list) >= 1)
    # The app's data table holds data frames, so a channel-named matrix becomes
    # one with the channels as a column.
    data_list <- lapply(data_list, function(x) {
        m <- .sbs96_matrix(x)
        data.frame(context = rownames(m), m, check.names = FALSE, stringsAsFactors = FALSE)
    })

    createModuleApp(
        inputs_ui_fn = mutationalProfileInputsUI,
        output_ui_fn = mutationalProfileOutputUI,
        server_fn    = mutationalProfileServer,
        data_list    = data_list,
        title        = "Modular Mutational Profile"
    )
}
