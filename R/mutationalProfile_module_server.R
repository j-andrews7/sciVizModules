#' Server logic for the mutationalProfile module
#'
#' Reshapes a 96-channel substitution count matrix into a long table (see
#' [mutationalProfileInputsUI()]) and draws it with
#' [VizModules::plotthis_BarPlotServer()].
#'
#' @param id The ID for the Shiny module.
#' @param data A `reactive` returning a 96-channel substitution count matrix or
#'   data frame.
#' @param hide.inputs A character vector of input IDs to hide.
#' @param hide.tabs A character vector of tab names to hide.
#' @param defaults A named list of default values, merged over the spectrum
#'   defaults (user values win) and used to restore state on reset.
#' @return The value returned by [VizModules::plotthis_BarPlotServer()].
#'
#' @import shiny
#' @importFrom VizModules plotthis_BarPlotServer
#'
#' @seealso [sciVizModules::mutationalProfileInputsUI()], [sciVizModules::mutationalProfileOutputUI()],
#' [sciVizModules::mutationalProfileApp()]
#' @examples
#' library(sciVizModules)
#' if (interactive()) mutationalProfileApp()
#' @export
#' @author Jared Andrews
mutationalProfileServer <- function(id, data, hide.inputs = NULL, hide.tabs = NULL, defaults = NULL) {
    stopifnot(is.reactive(data))

    long <- reactive({
        x <- data()
        req(x)
        .sbs96_long(x)
    })

    plotthis_BarPlotServer(
        id = id,
        data = long,
        hide.inputs = hide.inputs,
        hide.tabs = hide.tabs,
        defaults = .sbs96_defaults(defaults)
    )
}
