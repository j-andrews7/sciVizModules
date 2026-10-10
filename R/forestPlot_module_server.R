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
        })

        generate_forestPlot <- reactive({
            isolate_fn <- setup_auto_update_logic(input, params)

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
            estimates <- attr(fig, "estimates")

            fig <- apply_title_layout(
                fig, input, isolate_fn,
                title_y = 0.95, title_x = isolate_fn(input$axis.title.horizontal.position)
            )
            xaxis_style <- create_axis_styles(input, axis_side = "x", isolate_fn = isolate_fn,
                ggplot.axis.styling = FALSE)
            yaxis_style <- create_axis_styles(input, axis_side = "y", isolate_fn = isolate_fn,
                ggplot.axis.styling = FALSE)
            fig <- apply_subplot_axis_styling(fig, xaxis_style, yaxis_style)

            fig <- add_reference_lines(fig,
                hline.intercepts = isolate_fn(input$hline.intercepts),
                hline.colors = isolate_fn(input$hline.colors),
                hline.widths = isolate_fn(input$hline.widths),
                hline.linetypes = isolate_fn(input$hline.linetypes),
                hline.opacities = isolate_fn(input$hline.opacities),
                vline.intercepts = isolate_fn(input$vline.intercepts),
                vline.colors = isolate_fn(input$vline.colors),
                vline.widths = isolate_fn(input$vline.widths),
                vline.linetypes = isolate_fn(input$vline.linetypes),
                vline.opacities = isolate_fn(input$vline.opacities),
                abline.slopes = isolate_fn(input$abline.slopes),
                abline.intercepts = isolate_fn(input$abline.intercepts),
                abline.colors = isolate_fn(input$abline.colors),
                abline.widths = isolate_fn(input$abline.widths),
                abline.linetypes = isolate_fn(input$abline.linetypes),
                abline.opacities = isolate_fn(input$abline.opacities)
            )

            config_list <- add_plot_config(
                download.format = isolate_fn(input$download.format),
                include.modebar.buttons = TRUE, facet.by = NULL
            )
            fig <- do.call(config, c(list(p = fig), config_list))
            fig <- apply_plotly_newshape(fig, input, isolate_fn)
            fig <- axis_titles_as_annotations(fig)
            attr(fig, "estimates") <- estimates
            fig
        })

        output$forestPlot <- renderPlotly({
            # Fitting can fail on the user's choices (a single-level factor, a
            # non-binary outcome); show why rather than a blank plot. req()'s
            # silent condition is re-raised so it still just pauses the render.
            tryCatch(
                apply_render_margins(generate_forestPlot(), input),
                shiny.silent.error = function(e) stop(e),
                error = function(e) empty_plot(text = conditionMessage(e), plotly = TRUE)
            )
        })

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
