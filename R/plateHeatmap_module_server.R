#' Server logic for the plateHeatmap module
#'
#' Renders [plateHeatmap()]. The per-plate quality statistics (control means and
#' SDs, signal-to-background, Z'-factor, edge-to-interior ratio) are included in
#' the source-data download as the statistics table.
#'
#' @param id The ID for the Shiny module.
#' @param data A `reactive` containing the plate data frame.
#' @param hide.inputs A character vector of input IDs to hide.
#' @param hide.tabs A character vector of tab names to hide.
#' @param defaults A named list of default values used when resetting the inputs.
#'   Typically the same list passed to [plateHeatmapInputsUI()].
#' @return A `reactive` returning the source-data list.
#'
#' @import shiny
#' @importFrom shinyWidgets updateMaterialSwitch
#' @importFrom colourpicker updateColourInput
#'
#' @seealso [plateHeatmap()], [sciVizModules::plateHeatmapInputsUI()],
#' [sciVizModules::plateHeatmapOutputUI()], [sciVizModules::plateHeatmapApp()]
#' @examples
#' library(sciVizModules)
#' if (interactive()) plateHeatmapApp()
#' @export
#' @author Jared Andrews
plateHeatmapServer <- function(id, data, hide.inputs = NULL, hide.tabs = NULL, defaults = NULL) {
    .sci_plot_server(
        id, data, hide.inputs, hide.tabs, .plate_axes_defaults(defaults),
        name = "plateHeatmap",
        validate = .sci_require_df,
        setup = function(input, output, session, object, params) {
            # The control labels follow the control column. Freeze them so the
            # plot waits for the new selection instead of drawing twice.
            observeEvent(input$control.col, {
                labels <- .plate_control_labels(object(), input$control.col)
                keep <- function(key, pattern) {
                    current <- isolate(input[[key]])
                    if (nz_value(current) && current %in% labels) return(current)
                    hit <- grep(pattern, labels, ignore.case = TRUE, value = TRUE)
                    if (length(hit)) hit[1] else ""
                }
                positive <- keep("positive", "^pos")
                negative <- keep("negative", "^neg")
                freezeReactiveValue(input, "positive")
                freezeReactiveValue(input, "negative")
                update_viz_select(session, "positive", choices = c("None" = "", labels), selected = positive)
                update_viz_select(session, "negative", choices = c("None" = "", labels), selected = negative)
            }, ignoreInit = TRUE)
            list()
        },
        build = function(df, input, isolate_fn, state) {
            midpoint <- isolate_fn(input$midpoint)
            plateHeatmap(
                df,
                well = isolate_fn(input$well.col),
                value = isolate_fn(input$value.col),
                plate = blank_to_null(isolate_fn(input$plate.col)),
                control = blank_to_null(isolate_fn(input$control.col)),
                positive = blank_to_null(isolate_fn(input$positive)),
                negative = blank_to_null(isolate_fn(input$negative)),
                normalise = isolate_fn(input$normalise) %||% "raw",
                plate.format = isolate_fn(input$plate.format) %||% "auto",
                colors = c(
                    isolate_fn(input$color.low) %||% "#2166AC",
                    isolate_fn(input$color.mid) %||% "#F7F7F7",
                    isolate_fn(input$color.high) %||% "#B2182B"
                ),
                midpoint = if (is.numeric(midpoint) && length(midpoint) == 1 && is.finite(midpoint)) midpoint,
                show.controls = !isFALSE(isolate_fn(input$show.controls)),
                positive.color = isolate_fn(input$positive.color) %||% "#E7298A",
                negative.color = isolate_fn(input$negative.color) %||% "#000000",
                marginals = isTRUE(isolate_fn(input$marginals)),
                ncols = max(1, as.integer(isolate_fn(input$ncols) %||% 2), na.rm = TRUE)
            )
        },
        reset = function(session, df, defaults, state) {
            d <- .plate_defaults(df, defaults)
            for (k in c("well.col", "value.col", "plate.col", "control.col", "positive", "negative", "normalise",
                "plate.format")) {
                update_viz_select(session, k, selected = d[[k]])
            }
            for (k in c("marginals", "show.controls")) updateMaterialSwitch(session, k, value = isTRUE(d[[k]]))
            for (k in c("color.low", "color.mid", "color.high", "positive.color", "negative.color")) {
                updateColourInput(session, k, value = d[[k]])
            }
            for (k in c("midpoint", "ncols")) updateNumericInput(session, k, value = d[[k]])
        }
    )
}
