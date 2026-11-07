#' Server logic for the forestPlot module
#'
#' Fits the chosen model to the data and renders its effect estimates with
#' [forestPlot()] as an interactive `plotly` figure. The estimates table is
#' included in the source-data download as the statistics table.
#'
#' @param id The ID for the Shiny module.
#' @param data A `reactive` containing the data frame to fit. Values that are not
#'   data frames are coerced with [as.data.frame()]; a `NULL` value is treated as
#'   "not ready yet" and the module waits for data.
#' @param hide.inputs A character vector of input IDs to hide. These will still be
#'   initialized and their values passed to the plot function, but the user will
#'   not be able to see/adjust them in the UI.
#' @param hide.tabs A character vector of tab names to hide.
#' @param defaults A named list of default values used when resetting the
#'   inputs. Typically the same list passed to [forestPlotInputsUI()]. An entry
#'   may also be a [shiny::reactive()], in which case the input tracks it; see
#'   [VizModules::setup_reactive_defaults()].
#' @return A `reactive` returning the source-data list (plot, plotted data,
#'   estimates table, inputs).
#'
#' @import shiny
#' @import plotly
#' @importFrom shinyWidgets updateMaterialSwitch
#' @importFrom colourpicker updateColourInput
#'
#' @seealso [forestPlot()], [sciVizModules::forestPlotInputsUI()],
#' [sciVizModules::forestPlotOutputUI()], [sciVizModules::forestPlotApp()]
#'
#' @examples
#' library(sciVizModules)
#' if (interactive()) forestPlotApp()
#' @export
#' @author Jared Andrews
forestPlotServer <- function(id, data, hide.inputs = NULL, hide.tabs = NULL, defaults = NULL) {
    stopifnot(is.reactive(data))
    data_reactive <- require_data_frame(data)

    moduleServer(id, function(input, output, session) {
        params <- setup_reactive_defaults(defaults, input, session)
        plot_source <- session$ns("forestPlot")
        edit_store <- setup_manual_edits(input, session, plot_source)

        hide_input(session, hide.inputs)
        for (tab.name in hide.tabs) hideTab(inputId = "forestPlotTabsetPanel", target = tab.name)

        # A Cox model takes time + status; the others take a single outcome.
        observeEvent(input$model, {
            cox <- identical(input$model, "cox")
            hide_input(session, if (cox) "outcome" else c("time", "status"))
            show_input(session, setdiff(if (cox) c("time", "status") else "outcome", hide.inputs))
        })

        observeEvent(input$reset, {
            d <- .forest_defaults(data_reactive(), defaults)
            update_viz_select(session, "model", selected = get_default(d, "model", "cox"))
            update_viz_select(session, "time", selected = get_default(d, "time", ""))
            update_viz_select(session, "status", selected = get_default(d, "status", ""))
            update_viz_select(session, "outcome", selected = get_default(d, "outcome", ""))
            update_viz_select(session, "covariates", selected = get_default(d, "covariates", ""))
            updateMaterialSwitch(session, "multivariable", value = get_default(d, "multivariable", TRUE))
            updateNumericInput(session, "conf.level", value = get_default(d, "conf.level", 0.95))
            updateMaterialSwitch(session, "show.reference", value = get_default(d, "show.reference", TRUE))
            updateMaterialSwitch(session, "show.table", value = get_default(d, "show.table", TRUE))
            update_viz_select(session, "sort.by", selected = get_default(d, "sort.by", "input"))
            updateNumericInput(session, "digits", value = get_default(d, "digits", 2))
            updateColourInput(session, "point.color", value = get_default(d, "point.color", "#000000"))
            updateNumericInput(session, "point.size", value = get_default(d, "point.size", 10))
            updateColourInput(session, "ci.color", value = get_default(d, "ci.color", "#000000"))
            updateNumericInput(session, "ci.width", value = get_default(d, "ci.width", 2))
            reset_axes_inputs(session, d)
            reset_lines_inputs(session, defaults = d)
            reset_plotly_inputs(session, d)
            reset_manual_edits(edit_store)
        })

        # What is drawn, cached by cached_structure(): it runs again only for a
        # change to the data, to `extra`, or to an input read here as
        # isolate_fn(input$key). A styling change re-runs generate_*() alone.
        draw_forestPlot <- function(isolate_fn) {
            df <- data_reactive()
            model <- isolate_fn(input$model)
            req(nz_value(model))

            fig <- forestPlot(
                df,
                model = model,
                covariates = isolate_fn(input$covariates),
                time = blank_to_null(isolate_fn(input$time)),
                status = blank_to_null(isolate_fn(input$status)),
                outcome = blank_to_null(isolate_fn(input$outcome)),
                multivariable = isTRUE(isolate_fn(input$multivariable)),
                conf.level = isolate_fn(input$conf.level),
                show.reference = isTRUE(isolate_fn(input$show.reference)),
                show.table = isTRUE(isolate_fn(input$show.table)),
                sort.by = isolate_fn(input$sort.by) %||% "input",
                digits = isolate_fn(input$digits) %||% 2,
                point.color = isolate_fn(input$point.color),
                point.size = isolate_fn(input$point.size),
                ci.color = isolate_fn(input$ci.color),
                ci.width = isolate_fn(input$ci.width)
            )
            list(fig = fig)
        }
        base_forestPlot <- cached_structure(draw_forestPlot, input, session, data_reactive, params = params)

        # How it looks: re-run for a styling change, without redrawing.
        generate_forestPlot <- reactive({
            isolate_fn <- setup_auto_update_logic(input, params)
            fig <- base_forestPlot()$fig
            estimates <- attr(fig, "estimates")
            fig <- apply_uniform_styling(fig, input, isolate_fn, ggplot.axis.styling = FALSE)
            attr(fig, "estimates") <- estimates
            fig
        })

        # Fitting can fail on the user's choices (a single-level factor, a
        # non-binary outcome); the render shows why rather than a blank plot.
        output$forestPlot <- .sci_render_plotly(generate_forestPlot, input, plot_source, edit_store, session)

        AllInputs <- reactive({
            reactiveValuesToList(input)
        })

        plot_source_reactive <- reactive({
            collect_source_data(
                plot_reactive = generate_forestPlot,
                stats_reactive = function() attr(generate_forestPlot(), "estimates"),
                inputs_reactive = AllInputs()
            )
        })

        output$download.source <- create_source_download_handler(
            data_list = plot_source_reactive,
            filename_base = "forestPlot_source"
        )

        return(plot_source_reactive)
    })
}
