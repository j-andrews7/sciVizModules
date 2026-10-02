#' Server logic for the pcaPairsPlot module
#'
#' Renders [pcaPairsPlot()] for a PCAtools `pca` object. The sample scores are
#' included in the source-data download as the statistics table.
#'
#' @param id The ID for the Shiny module.
#' @param data A `reactive` returning a PCAtools `pca` object.
#' @param hide.inputs A character vector of input IDs to hide.
#' @param hide.tabs A character vector of tab names to hide.
#' @param defaults A named list of default values used when resetting the inputs.
#'   Typically the same list passed to [pcaPairsPlotInputsUI()].
#' @return A `reactive` returning the source-data list.
#'
#' @import shiny
#'
#' @seealso [pcaPairsPlot()], [sciVizModules::pcaPairsPlotInputsUI()],
#' [sciVizModules::pcaPairsPlotOutputUI()], [sciVizModules::pcaPairsPlotApp()]
#' @examples
#' library(sciVizModules)
#' if (interactive()) pcaPairsPlotApp()
#' @export
#' @author Jared Andrews
pcaPairsPlotServer <- function(id, data, hide.inputs = NULL, hide.tabs = NULL, defaults = NULL) {
    default_palette_values <- default_palettes()[["choices"]][["Defaults"]][["dittoColors"]]

    .sci_plot_server(
        id, data, hide.inputs, hide.tabs, defaults,
        name = "pcaPairsPlot",
        validate = .assert_pca,
        setup = function(input, output, session, pca_data, params) {
            palette_groups <- reactive({
                col <- blank_to_null(input$color.by)
                md <- as.data.frame(pca_data()$metadata %||% data.frame())
                if (is.null(col) || !col %in% names(md)) {
                    return(character(0))
                }
                unique(as.character(md[[col]]))
            })

            # The picker is rebuilt by renderUI() whenever the groups change, and
            # its first report back is what the server seeded it with; reading
            # the store rather than the raw input keeps that echo from redrawing.
            # See VizModules::setup_group_colors().
            palette_store <- setup_group_colors(
                input, "palette.colours", palette_groups,
                default_palette_values, defaults, params
            )

            output$palette.selection <- .sci_palette_picker_ui(input, session, palette_groups, palette_store,
                default_palette_values, defaults, "Group Colors")

            list(palette_groups = palette_groups, palette_store = palette_store)
        },
        build = function(p, input, isolate_fn, state) {
            pcaPairsPlot(
                p,
                components = isolate_fn(input$components),
                color.by = blank_to_null(isolate_fn(input$color.by)),
                shape.by = blank_to_null(isolate_fn(input$shape.by)),
                colors = isolate_fn(state$palette_store()),
                point.size = isolate_fn(input$point.size) %||% 8,
                opacity = isolate_fn(input$opacity) %||% 1
            )
        },
        reset = function(session, p, defaults, state) {
            disc <- .pca_metadata_cols(p, "discrete")
            update_viz_select(session, "components",
                selected = get_default(defaults, "components", utils::head(.pca_components(p), 4)))
            update_viz_select(session, "color.by",
                selected = get_default(defaults, "color.by", if (length(disc)) disc[1] else ""))
            update_viz_select(session, "shape.by", selected = get_default(defaults, "shape.by", ""))
            updateNumericInput(session, "point.size", value = get_default(defaults, "point.size", 8))
            updateNumericInput(session, "opacity", value = get_default(defaults, "opacity", 1))
            reset_group_colors(session, "palette.colours", defaults, state$palette_groups(), default_palette_values)
        }
    )
}
