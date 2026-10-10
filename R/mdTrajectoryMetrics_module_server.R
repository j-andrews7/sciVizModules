#' Server logic for the mdTrajectoryMetrics module
#'
#' Renders [mdTrajectoryMetrics()]. The per-group summary (points, mean, SD and
#' second-half mean) is included in the source-data download as the statistics
#' table.
#'
#' @param id The ID for the Shiny module.
#' @param data A `reactive` returning a data frame, e.g. from [read_xvg()].
#' @param hide.inputs A character vector of input IDs to hide.
#' @param hide.tabs A character vector of tab names to hide.
#' @param defaults A named list of default values used when resetting the inputs.
#'   Typically the same list passed to [mdTrajectoryMetricsInputsUI()].
#' @return A `reactive` returning the source-data list.
#'
#' @import shiny
#' @importFrom shinyWidgets updateMaterialSwitch
#'
#' @seealso [mdTrajectoryMetrics()], [read_xvg()], [sciVizModules::mdTrajectoryMetricsInputsUI()],
#' [sciVizModules::mdTrajectoryMetricsOutputUI()], [sciVizModules::mdTrajectoryMetricsApp()]
#' @examples
#' library(sciVizModules)
#' if (interactive()) mdTrajectoryMetricsApp()
#' @export
#' @author Jared Andrews
mdTrajectoryMetricsServer <- function(id, data, hide.inputs = NULL, hide.tabs = NULL, defaults = NULL) {
    default_palette_values <- default_palettes()[["choices"]][["Defaults"]][["dittoColors"]]

    .sci_plot_server(
        id, data, hide.inputs, hide.tabs, defaults,
        name = "mdTrajectoryMetrics",
        validate = .sci_require_df,
        setup = function(input, output, session, object, params) {
            # An ungrouped trace is the single series "all", as mdTrajectoryMetrics()
            # names it, so its colour can still be picked.
            palette_groups <- reactive({
                col <- blank_to_null(input$group.col)
                df <- object()
                if (is.null(col) || !col %in% names(df)) "all" else unique(as.character(df[[col]]))
            })
            palette_store <- setup_group_colors(
                input, "palette.colours", palette_groups, default_palette_values, defaults, params
            )
            output$palette.selection <- .sci_palette_picker_ui(input, session, palette_groups, palette_store,
                default_palette_values, defaults, "Group Colors")
            list(palette_groups = palette_groups, palette_store = palette_store)
        },
        build = function(df, input, isolate_fn, state) {
            mdTrajectoryMetrics(
                df,
                x = isolate_fn(input$x.col),
                y = isolate_fn(input$y.col),
                group = blank_to_null(isolate_fn(input$group.col)),
                facet = blank_to_null(isolate_fn(input$facet.col)),
                smooth.window = isolate_fn(input$smooth.window) %||% 0,
                time.unit = isolate_fn(input$time.unit) %||% "as is",
                length.unit = isolate_fn(input$length.unit) %||% "as is",
                show.raw = !isFALSE(isolate_fn(input$show.raw)),
                raw.opacity = isolate_fn(input$raw.opacity) %||% 0.3,
                colors = isolate_fn(state$palette_store())
            )
        },
        reset = function(session, df, defaults, state) {
            d <- .md_defaults(df, defaults)
            for (k in c("x.col", "y.col", "group.col", "facet.col", "time.unit", "length.unit")) {
                update_viz_select(session, k, selected = d[[k]])
            }
            updateNumericInput(session, "smooth.window", value = d$smooth.window)
            updateMaterialSwitch(session, "show.raw", value = isTRUE(d$show.raw))
            updateNumericInput(session, "raw.opacity", value = d$raw.opacity)
            reset_group_colors(session, "palette.colours", defaults, state$palette_groups(), default_palette_values)
        }
    )
}
