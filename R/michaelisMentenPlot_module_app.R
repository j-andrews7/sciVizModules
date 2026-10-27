#' Create a standalone Shiny app for the michaelisMenten module
#'
#' This function generates a Shiny application with the modular
#' Michaelis-Menten plotting components: an inputs panel for configuring the
#' plot and an output panel showing the interactive `plotly` figure.
#'
#' Unlike the upload-driven [VizModules::createModuleApp()] wrapper, this app
#' takes the three data inputs directly because the module needs more than a
#' single data frame: the observed data, the fitted line, and (optionally) the
#' stats object used for K / Vmax annotations.
#'
#' When called with no arguments, the app launches with the bundled example
#' kinetics data ([mm_kinetics], [mm_kinetics_line], and [mm_kinetics_fit]), on
#' the settings the module gallery ([sciModuleGalleryApp()]) opens this module
#' on.
#'
#' @param data The plotting data frame of observed points. If `NULL` (the
#'   default), the bundled [mm_kinetics] is used, with [mm_kinetics_line] as
#'   `model` and [mm_kinetics_fit] as `stats`.
#' @param model A data frame of fitted-line coordinates (e.g. `mml`) sharing the
#'   same x/y columns as `data`. Required when `data` is given.
#' @param stats Optional fitted model (e.g. an `nls` fit of
#'   `v ~ Vm * S / (K + S)`) or named coefficients from which K and Vmax are
#'   extracted for annotation. `NULL` (the default, when `data` is given)
#'   disables the annotation.
#' @param defaults An optional named list of default input values, applied over
#'   the gallery's settings when the example data is used.
#' @param hide.inputs A character vector of input IDs to hide. Their values are
#'   still initialized and used, but the controls are not shown in the UI.
#' @param hide.tabs A character vector of tab names to hide. Inputs in these tabs
#'   are still initialized and used.
#' @param title The app title.
#' @return A Shiny app object.
#'
#' @import shiny
#' @importFrom shinyjs useShinyjs
#'
#' @seealso [sciVizModules::michaelisMentenInputsUI()],
#' [sciVizModules::michaelisMentenOutputUI()],
#' [sciVizModules::michaelisMentenServer()], [sciVizModules::michaelisMentenPlot()]
#'
#' @export
#' @author Jacob Martin
#' @examples
#' library(sciVizModules)
#' # Launch with the bundled example kinetics data:
#' app <- michaelisMentenApp()
#' if (interactive()) shiny::runApp(app)
#'
#' # Launch with custom data:
#' data(mm_kinetics)
#' if (requireNamespace("drc", quietly = TRUE)) {
#'     library(drc)
#'     mm_model <- drm(v ~ S, data = mm_kinetics, fct = MM.2())
#'     mml <- data.frame(S = seq(min(mm_kinetics$S), max(mm_kinetics$S), length.out = 100))
#'     mml$v <- predict(mm_model, newdata = mml)
#'     stats <- nls(v ~ Vm * S / (K + S), data = mm_kinetics,
#'         start = list(K = max(mm_kinetics$v) / 2, Vm = max(mm_kinetics$v)))
#'     app2 <- michaelisMentenApp(mm_kinetics, mml, stats)
#'     if (interactive()) shiny::runApp(app2)
#' }
michaelisMentenApp <- function(data = NULL, model = NULL, stats = NULL, defaults = NULL,
                               hide.inputs = NULL, hide.tabs = NULL,
                               title = "Modular Michaelis-Menten Plot") {
    if (is.null(data)) {
        example <- .sci_module_example("mm", defaults)
        bundle <- example$data_list[[1]]
        data <- bundle$data
        model <- bundle$model
        stats <- bundle$stats
        defaults <- example$defaults
    }
    stopifnot(is.data.frame(data), is.data.frame(model))

    ui <- fluidPage(
        title = title,
        shinyjs::useShinyjs(),
        sidebarLayout(
            sidebarPanel(
                michaelisMentenInputsUI("mm_plot", data,
                    title = h3(title), defaults = defaults)
            ),
            mainPanel(
                michaelisMentenOutputUI("mm_plot")
            )
        )
    )

    server <- function(input, output, session) {
        bundle <- reactive(list(data = data, model = model, stats = stats))
        do.call(michaelisMentenServer, .sci_server_args("mm_plot", bundle, defaults, hide.inputs, hide.tabs))
    }

    shinyApp(ui, server)
}