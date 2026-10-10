#' Server logic for the pkConcentrationTime module
#'
#' Renders [pkConcentrationTime()]. The per-subject non-compartmental parameters
#' are included in the source-data download as the statistics table.
#'
#' @param id The ID for the Shiny module.
#' @param data A `reactive` containing the concentration-time data frame.
#' @param hide.inputs A character vector of input IDs to hide.
#' @param hide.tabs A character vector of tab names to hide.
#' @param defaults A named list of default values used when resetting the inputs.
#'   Typically the same list passed to [pkConcentrationTimeInputsUI()].
#' @return A `reactive` returning the source-data list.
#'
#' @import shiny
#' @importFrom shinyWidgets updateMaterialSwitch
#'
#' @seealso [pkConcentrationTime()], [sciVizModules::pkConcentrationTimeInputsUI()],
#' [sciVizModules::pkConcentrationTimeOutputUI()], [sciVizModules::pkConcentrationTimeApp()]
#' @examples
#' library(sciVizModules)
#' if (interactive()) pkConcentrationTimeApp()
#' @export
#' @author Jared Andrews
pkConcentrationTimeServer <- function(id, data, hide.inputs = NULL, hide.tabs = NULL, defaults = NULL) {
    default_palette_values <- default_palettes()[["choices"]][["Defaults"]][["dittoColors"]]

    .sci_plot_server(
        id, data, hide.inputs, hide.tabs, defaults,
        name = "pkConcentrationTime",
        validate = .sci_require_df,
        setup = function(input, output, session, object, params) {
            # Subjects are coloured in individual mode, groups in mean mode.
            palette_groups <- reactive({
                df <- object()
                col <- if (identical(input$mode, "mean")) blank_to_null(input$group.col) else input$subject.col
                if (identical(input$mode, "mean") && is.null(col)) return("All")
                if (is.null(col) || !col %in% names(df)) character(0) else unique(as.character(df[[col]]))
            })
            palette_store <- setup_group_colors(
                input, "palette.colours", palette_groups, default_palette_values, defaults, params
            )
            output$palette.selection <- .sci_palette_picker_ui(input, session, palette_groups, palette_store,
                default_palette_values, defaults, "Colors")

            # The interval controls apply only to the group means, and the CI method
            # only to a confidence interval. What the app hid via hide.inputs is
            # never shown again here.
            observeEvent(list(input$mode, input$error.bar.type), {
                mean_mode <- identical(input$mode, "mean")
                toggle <- function(ids, show) {
                    if (show) show_input(session, setdiff(ids, hide.inputs)) else hide_input(session, ids)
                }
                toggle(.pk_error_inputs, mean_mode)
                toggle("error.bar.ci.method", mean_mode && identical(input$error.bar.type, "ci95"))
            }, ignoreInit = FALSE)

            list(palette_groups = palette_groups, palette_store = palette_store)
        },
        build = function(df, input, isolate_fn, state) {
            pkConcentrationTime(
                df,
                time = isolate_fn(input$time.col),
                conc = isolate_fn(input$conc.col),
                subject = isolate_fn(input$subject.col),
                group = blank_to_null(isolate_fn(input$group.col)),
                dose = blank_to_null(isolate_fn(input$dose.col)),
                mode = isolate_fn(input$mode) %||% "individual",
                log.y = isTRUE(isolate_fn(input$log.y)),
                show.lambda = isTRUE(isolate_fn(input$show.lambda)),
                auc.method = isolate_fn(input$auc.method) %||% "lin up/log down",
                colors = isolate_fn(state$palette_store()),
                error.type = .pk_choice(isolate_fn(input$error.bar.type), .pk_error_type_choices),
                error.ci.method = .pk_choice(isolate_fn(input$error.bar.ci.method), .pk_ci_method_choices),
                error.bar = !isFALSE(isolate_fn(input$error.bar)),
                error.ribbon = isTRUE(isolate_fn(input$error.ribbon)),
                error.ribbon.opacity = isolate_fn(input$error.ribbon.opacity) %||% 0.25
            )
        },
        reset = function(session, df, defaults, state) {
            d <- .pk_defaults(df, defaults)
            for (k in c("subject.col", "time.col", "conc.col", "group.col", "dose.col", "mode", "auc.method",
                "error.bar.type", "error.bar.ci.method")) {
                update_viz_select(session, k, selected = d[[k]])
            }
            for (k in c("log.y", "show.lambda", "error.bar", "error.ribbon")) {
                updateMaterialSwitch(session, k, value = isTRUE(d[[k]]))
            }
            updateNumericInput(session, "error.ribbon.opacity", value = d$error.ribbon.opacity)
            reset_group_colors(session, "palette.colours", defaults, state$palette_groups(), default_palette_values)
        }
    )
}
