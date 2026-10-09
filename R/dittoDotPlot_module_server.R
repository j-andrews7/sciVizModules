#' Server logic for the dittoDotPlot module
#'
#' This module builds a marker dot plot with [dittoSeq::dittoDotPlot()] and
#' renders it as an interactive `plotly` figure.
#'
#' @param id The ID for the Shiny module.
#' @param data A `reactive` returning a `SingleCellExperiment`, `Seurat`, or
#'   `SummarizedExperiment` object.
#' @param hide.inputs A character vector of input IDs to hide.
#' @param hide.tabs A character vector of tab names to hide.
#' @param defaults A named list of default values used when resetting the inputs.
#'   Typically the same list passed to [dittoDotPlotInputsUI()].
#' @return A `reactive` returning the source-data list.
#'
#' @import shiny
#' @import plotly
#' @importFrom dittoSeq dittoDotPlot
#' @importFrom VizModules add_size_legend
#' @importFrom shinyWidgets updateMaterialSwitch
#' @importFrom colourpicker updateColourInput
#'
#' @seealso [dittoSeq::dittoDotPlot()], [sciVizModules::dittoDotPlotInputsUI()],
#' [sciVizModules::dittoDotPlotOutputUI()], [sciVizModules::dittoDotPlotApp()]
#' @examples
#' library(sciVizModules)
#' if (interactive()) dittoDotPlotApp()
#' @export
#' @author Jared Andrews
dittoDotPlotServer <- function(id, data, hide.inputs = NULL, hide.tabs = NULL, defaults = NULL) {
    stopifnot(is.reactive(data))

    moduleServer(id, function(input, output, session) {
        params <- setup_reactive_defaults(defaults, input, session)

        hide_input(session, hide.inputs)
        for (tab.name in hide.tabs) hideTab(inputId = "dittoDotPlotTabsetPanel", target = tab.name)

        observeEvent(input$reset, {
            obj <- data()
            req(obj)
            d <- .ddp_defaults(obj, defaults)
            for (k in c("vars", "group.by", "split.by", "vars.dir", "summary.fxn.color", "mid.color")) {
                update_viz_select(session, k, selected = d[[k]])
            }
            if (length(.ditto_assays(obj))) update_viz_select(session, "assay", selected = d$assay)
            updateMaterialSwitch(session, "scale", value = isTRUE(d$scale))
            updateColourInput(session, "min.color", value = d$min.color)
            updateColourInput(session, "max.color", value = d$max.color)
            for (k in c("size", "min.percent", "max.percent", "size.legend.x", "size.legend.y")) {
                updateNumericInput(session, k, value = d[[k]])
            }
            .ditto_reset_uniform(session, defaults)
        })

        observeEvent(input$split.by, {
            toggle_facet_title_inputs(session, nz_value(input$split.by), hidden = hide.inputs)
        }, ignoreNULL = FALSE)

        generate_dittoDotPlot <- reactive({
            isolate_fn <- setup_auto_update_logic(input, params)

            obj <- data()
            req(obj)

            vars <- isolate_fn(input$vars)
            group.by <- isolate_fn(input$group.by)
            req(length(vars) > 0, nz_value(group.by))
            split.by <- blank_to_null(isolate_fn(input$split.by))
            assay <- blank_to_null(isolate_fn(input$assay))
            mid.color <- blank_to_null(isolate_fn(input$mid.color))
            summary.fxn <- isolate_fn(input$summary.fxn.color)
            min.percent <- isolate_fn(input$min.percent)
            max.percent <- isolate_fn(input$max.percent)
            min.percent <- na_to_null(min.percent) %||% 0.01
            max.percent <- na_to_null(max.percent) %||% NA

            additional_theme <- create_ggplot_axis_style(input, isolate_fn = isolate_fn)
            theme_style <- theme_bw() + theme(
                panel.border = additional_theme$panel.border,
                axis.line = additional_theme$axis.line,
                axis.ticks = additional_theme$axis.ticks,
                strip.background = element_blank()
            )

            args <- list(
                object = obj,
                vars = vars,
                group.by = group.by,
                scale = isTRUE(isolate_fn(input$scale)),
                split.by = split.by,
                vars.dir = isolate_fn(input$vars.dir) %||% "x",
                size = isolate_fn(input$size) %||% 6,
                min.color = isolate_fn(input$min.color) %||% "grey90",
                max.color = isolate_fn(input$max.color) %||% "#C51B7D",
                mid.color = mid.color,
                summary.fxn.color = .ddp_summary_fxn(summary.fxn),
                min.percent = min.percent,
                max.percent = max.percent,
                theme = theme_style,
                data.out = TRUE
            )
            if (!is.null(assay)) args$assay <- assay
            out <- do.call(dittoSeq::dittoDotPlot, args)

            fig <- .ddp_colorbar_top(plotly::ggplotly(out$p))
            fig <- .sci_finalize_plotly(fig, input, isolate_fn, faceted = !is.null(split.by))

            # ggplotly() drops the size legend; draw it as the VizModules DotPlot
            # module does. Hiding the legend hides this one too.
            add_size_legend(
                fig,
                data = .ddp_size_legend_data(out$data, min.percent, max.percent),
                size.by = if (isFALSE(isolate_fn(input$legend.show))) NULL else "percent",
                title = "percent<br>expression",
                digits = 0,
                gap = 0.04,
                title.size = isolate_fn(input$legend.title.size),
                text.size = isolate_fn(input$legend.text.size),
                start.y = isolate_fn(input$size.legend.y),
                start.x = isolate_fn(input$size.legend.x),
                font.family = isolate_fn(input$legend.font.family),
                font.color = isolate_fn(input$legend.font.color)
            )
        })

        output$dittoDotPlot <- renderPlotly({
            req(input$vars, input$group.by)
            tryCatch(
                apply_render_margins(generate_dittoDotPlot(), input),
                shiny.silent.error = function(e) stop(e),
                error = function(e) empty_plot(text = conditionMessage(e), plotly = TRUE)
            )
        })

        AllInputs <- reactive({
            reactiveValuesToList(input)
        })

        plot_source_reactive <- reactive({
            collect_source_data(
                plot_reactive = generate_dittoDotPlot,
                inputs_reactive = AllInputs()
            )
        })

        output$download.source <- create_source_download_handler(
            data_list = plot_source_reactive,
            filename_base = "dittoDotPlot_source"
        )

        plot_source_reactive
    })
}
