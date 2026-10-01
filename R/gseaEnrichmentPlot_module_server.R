#' Server logic for the gseaEnrichmentPlot module
#'
#' Renders [gseaEnrichmentPlot()]. The per-gene-set summary (enrichment score,
#' NES, adjusted p-value, size and leading edge) is included in the source-data
#' download as the statistics table.
#'
#' @param id The ID for the Shiny module.
#' @param data A `reactive` returning an fgsea bundle or a clusterProfiler
#'   `gseaResult`.
#' @param hide.inputs A character vector of input IDs to hide.
#' @param hide.tabs A character vector of tab names to hide.
#' @param defaults A named list of default values used when resetting the inputs.
#'   Typically the same list passed to [gseaEnrichmentPlotInputsUI()].
#' @return A `reactive` returning the source-data list.
#'
#' @import shiny
#' @importFrom shinyWidgets updateMaterialSwitch
#' @importFrom colourpicker updateColourInput
#'
#' @seealso [gseaEnrichmentPlot()], [sciVizModules::gseaEnrichmentPlotInputsUI()],
#' [sciVizModules::gseaEnrichmentPlotOutputUI()], [sciVizModules::gseaEnrichmentPlotApp()]
#' @examples
#' library(sciVizModules)
#' if (interactive()) gseaEnrichmentPlotApp()
#' @export
#' @author Jared Andrews
gseaEnrichmentPlotServer <- function(id, data, hide.inputs = NULL, hide.tabs = NULL, defaults = NULL) {
    default_palette_values <- default_palettes()[["choices"]][["Defaults"]][["dittoColors"]]

    .sci_plot_server(
        id, data, hide.inputs, hide.tabs, defaults,
        name = "gseaEnrichmentPlot",
        validate = .assert_gsea,
        setup = function(input, output, session, object, params) {
            palette_groups <- reactive({
                sets <- input$pathways
                if (length(sets) == 0) character(0) else sets
            })

            # One colour per selected gene set, through the server-side store so
            # the rebuilt picker's echo does not redraw the plot. See
            # VizModules::setup_group_colors().
            palette_store <- setup_group_colors(
                input, "palette.colours", palette_groups,
                default_palette_values, defaults, params
            )

            output$palette.selection <- renderUI({
                groups <- palette_groups()
                if (length(groups) == 0) {
                    return(NULL)
                }
                initial_colors <- isolate(resolve_palette(
                    groups, input$palette.colours, default_palette_values,
                    default_group_colors(defaults, "palette.colours")
                ))
                palette_store(initial_colors)
                multiColorPicker(
                    session$ns("palette.colours"),
                    label = "Gene Set Colors",
                    groups = groups,
                    palette_options = default_palettes()[["choices"]],
                    selected_palette = "dittoColors",
                    colors = initial_colors,
                    compact = TRUE
                )
            })

            list(palette_groups = palette_groups, palette_store = palette_store)
        },
        build = function(x, input, isolate_fn, state) {
            gseaEnrichmentPlot(
                x,
                pathways = isolate_fn(input$pathways),
                gsea.param = isolate_fn(input$gsea.param) %||% 1,
                colors = isolate_fn(state$palette_store()),
                show.ticks = isTRUE(isolate_fn(input$show.ticks)),
                show.metric = isTRUE(isolate_fn(input$show.metric)),
                metric.color = isolate_fn(input$metric.color) %||% "#7F7F7F"
            )
        },
        reset = function(session, x, defaults, state) {
            update_viz_select(session, "pathways",
                selected = get_default(defaults, "pathways", .gsea_default_pathways(x)))
            updateNumericInput(session, "gsea.param", value = get_default(defaults, "gsea.param", 1))
            updateMaterialSwitch(session, "show.ticks", value = get_default(defaults, "show.ticks", TRUE))
            updateMaterialSwitch(session, "show.metric", value = get_default(defaults, "show.metric", TRUE))
            updateColourInput(session, "metric.color", value = get_default(defaults, "metric.color", "#7F7F7F"))
            reset_group_colors(session, "palette.colours", defaults, state$palette_groups(), default_palette_values)
        }
    )
}
