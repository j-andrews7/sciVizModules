#' Server logic for the oncoPlot module
#'
#' Renders [oncoPlot()]. The shown genes' summary (mutated samples, their
#' percentage, variants per class) is included in the source-data download as
#' the statistics table.
#'
#' @param id The ID for the Shiny module.
#' @param data A `reactive` returning a maftools `MAF` object or a data frame in
#'   MAF columns.
#' @param hide.inputs A character vector of input IDs to hide.
#' @param hide.tabs A character vector of tab names to hide.
#' @param defaults A named list of default values used when resetting the inputs.
#'   Typically the same list passed to [oncoPlotInputsUI()].
#' @return A `reactive` returning the source-data list.
#'
#' @import shiny
#' @importFrom shinyWidgets updateMaterialSwitch
#' @importFrom colourpicker updateColourInput
#'
#' @seealso [oncoPlot()], [sciVizModules::oncoPlotInputsUI()], [sciVizModules::oncoPlotOutputUI()],
#' [sciVizModules::oncoPlotApp()]
#' @examples
#' library(sciVizModules)
#' if (interactive()) oncoPlotApp()
#' @export
#' @author Jared Andrews
oncoPlotServer <- function(id, data, hide.inputs = NULL, hide.tabs = NULL, defaults = NULL) {
    default_palette_values <- default_palettes()[["choices"]][["Defaults"]][["dittoColors"]]
    # Variant classes start on maftools' colours unless the caller gives others,
    # and the Axes tab without gridlines (as the UI).
    defaults <- .maf_color_defaults(.onco_style_defaults(defaults))

    .sci_plot_server(
        id, data, hide.inputs, hide.tabs, defaults,
        name = "oncoPlot",
        validate = .maf_validate,
        setup = function(input, output, session, object, params) {
            palette_groups <- reactive(.maf_vc_levels(object(), multi.hit = TRUE))
            palette_store <- setup_group_colors(
                input, "palette.colours", palette_groups, default_palette_values, defaults, params
            )
            output$palette.selection <- .sci_palette_picker_ui(input, session, palette_groups, palette_store,
                default_palette_values, defaults, "Variant Class Colors")
            list(palette_groups = palette_groups, palette_store = palette_store)
        },
        build = function(m, input, isolate_fn, state) {
            top.n <- isolate_fn(input$top.n)
            oncoPlot(
                m,
                genes = isolate_fn(input$genes),
                top.n = na_to_null(top.n) %||% 20,
                colors = isolate_fn(state$palette_store()),
                clinical.tracks = isolate_fn(input$clinical.tracks),
                sort.samples = !isFALSE(isolate_fn(input$sort.samples)),
                include.unmutated = !isFALSE(isolate_fn(input$include.unmutated)),
                show.tmb = !isFALSE(isolate_fn(input$show.tmb)),
                show.gene.bar = !isFALSE(isolate_fn(input$show.gene.bar)),
                show.sample.names = isTRUE(isolate_fn(input$show.sample.names)),
                background.color = isolate_fn(input$background.color) %||% "#ECF0F1"
            )
        },
        reset = function(session, m, defaults, state) {
            d <- .onco_defaults(m, defaults)
            update_viz_select(session, "genes", selected = d$genes)
            update_viz_select(session, "clinical.tracks", selected = d$clinical.tracks)
            updateNumericInput(session, "top.n", value = d$top.n)
            for (k in c("sort.samples", "include.unmutated", "show.tmb", "show.gene.bar", "show.sample.names")) {
                updateMaterialSwitch(session, k, value = isTRUE(d[[k]]))
            }
            updateColourInput(session, "background.color", value = d$background.color)
            reset_group_colors(session, "palette.colours", defaults, state$palette_groups(), default_palette_values)
        }
    )
}
