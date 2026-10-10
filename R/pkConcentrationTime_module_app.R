#' Create a standalone Shiny app for the pkConcentrationTime module
#'
#' Generates a Shiny application with modular pharmacokinetic components, built
#' with [VizModules::createModuleApp()]: data import, a filterable data table,
#' and the plot with its settings.
#'
#' @param data_list An optional named list of concentration-time data frames. If
#'   `NULL` (the default), base R's [datasets::Theoph] (oral theophylline in 12
#'   subjects) is used.
#' @return A Shiny app object.
#'
#' @seealso [pkConcentrationTime()], [sciVizModules::pkConcentrationTimeInputsUI()],
#' [sciVizModules::pkConcentrationTimeOutputUI()], [sciVizModules::pkConcentrationTimeServer()]
#'
#' @export
#' @author Jared Andrews
#' @examples
#' library(sciVizModules)
#' app <- pkConcentrationTimeApp()
#' if (interactive()) shiny::runApp(app)
pkConcentrationTimeApp <- function(data_list = NULL) {
    if (is.null(data_list)) {
        data_list <- list("Theoph" = .pk_example())
    }
    stopifnot(is.list(data_list), length(data_list) >= 1)
    lapply(data_list, function(data) stopifnot(is.data.frame(data)))

    createModuleApp(
        inputs_ui_fn = pkConcentrationTimeInputsUI,
        output_ui_fn = pkConcentrationTimeOutputUI,
        server_fn    = pkConcentrationTimeServer,
        data_list    = data_list,
        title        = "Modular PK Concentration-Time Plot"
    )
}


#' The example concentration-time data
#'
#' @return [datasets::Theoph] as a plain data frame, with `Subject` as character.
#'
#' @author Jared Andrews
#' @rdname INTERNAL_pk_example
#' @keywords internal
.pk_example <- function() {
    th <- as.data.frame(datasets::Theoph)
    th$Subject <- as.character(th$Subject)
    th
}
