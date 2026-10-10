#' Server logic for the rocCurve module
#'
#' Renders [rocCurve()]. The per-predictor table (AUC, confidence interval,
#' Youden cut-off, sensitivity, specificity) is included in the source-data
#' download as the statistics table.
#'
#' @param id The ID for the Shiny module.
#' @param data A `reactive` containing the data frame.
#' @param hide.inputs A character vector of input IDs to hide.
#' @param hide.tabs A character vector of tab names to hide.
#' @param defaults A named list of default values used when resetting the inputs.
#'   Typically the same list passed to [rocCurveInputsUI()].
#' @return A `reactive` returning the source-data list.
#'
#' @import shiny
#' @importFrom shinyWidgets updateMaterialSwitch
#'
#' @seealso [rocCurve()], [sciVizModules::rocCurveInputsUI()], [sciVizModules::rocCurveOutputUI()],
#' [sciVizModules::rocCurveApp()]
#' @examples
#' library(sciVizModules)
#' if (interactive()) rocCurveApp()
#' @export
#' @author Jared Andrews
rocCurveServer <- function(id, data, hide.inputs = NULL, hide.tabs = NULL, defaults = NULL) {
    default_palette_values <- default_palettes()[["choices"]][["Defaults"]][["dittoColors"]]

    .sci_plot_server(
        id, data, hide.inputs, hide.tabs, defaults,
        name = "rocCurve",
        validate = .sci_require_df,
        setup = function(input, output, session, object, params) {
            # The case value's choices follow the outcome column. Freeze it so
            # the plot waits for the new selection instead of drawing twice.
            observeEvent(input$response, {
                df <- object()
                req(input$response %in% names(df))
                x <- df[[input$response]]
                lv <- as.character(if (is.factor(x)) levels(droplevels(x)) else sort(unique(x[!is.na(x)])))
                selected <- if (isolate(input$positive) %in% lv) isolate(input$positive) else lv[length(lv)]
                freezeReactiveValue(input, "positive")
                update_viz_select(session, "positive", choices = lv, selected = selected)
            }, ignoreInit = TRUE)

            palette_groups <- reactive(input$predictors %||% character(0))
            palette_store <- setup_group_colors(
                input, "palette.colours", palette_groups, default_palette_values, defaults, params
            )
            output$palette.selection <- .sci_palette_picker_ui(input, session, palette_groups, palette_store,
                default_palette_values, defaults, "Predictor Colors")
            list(palette_groups = palette_groups, palette_store = palette_store)
        },
        build = function(df, input, isolate_fn, state) {
            rocCurve(
                df,
                response = isolate_fn(input$response),
                predictors = isolate_fn(input$predictors),
                positive = blank_to_null(isolate_fn(input$positive)),
                direction = isolate_fn(input$direction) %||% "auto",
                ci = !isFALSE(isolate_fn(input$ci)),
                show.youden = !isFALSE(isolate_fn(input$show.youden)),
                colors = isolate_fn(state$palette_store())
            )
        },
        reset = function(session, df, defaults, state) {
            d <- .roc_defaults(df, defaults)
            for (k in c("response", "positive", "predictors", "direction")) update_viz_select(session, k, selected = d[[k]])
            updateMaterialSwitch(session, "ci", value = isTRUE(d$ci))
            updateMaterialSwitch(session, "show.youden", value = isTRUE(d$show.youden))
            reset_group_colors(session, "palette.colours", defaults, state$palette_groups(), default_palette_values)
        }
    )
}
