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
        plot_source <- session$ns("dittoDotPlot")
        edit_store <- setup_manual_edits(input, session, plot_source)

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
            .ditto_reset_uniform(session, defaults, edit_store)
        })

        observeEvent(input$split.by, {
            toggle_facet_title_inputs(session, nz_value(input$split.by), hidden = hide.inputs)
        }, ignoreNULL = FALSE)

        # What is drawn, cached by cached_structure(): it runs again only for a
        # change to the data, to `extra`, or to an input read here as
        # isolate_fn(input$key). A styling change re-runs generate_*() alone.
        draw_dittoDotPlot <- function(isolate_fn) {
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

            list(
                fig = .ddp_colorbar_top(plotly::ggplotly(out$p)), faceted = !is.null(split.by),
                size = args$size, limits = 100 * c(min.percent, max.percent),
                legend_data = .ddp_size_legend_data(out$data, min.percent, max.percent)
            )
        }
        base_dittoDotPlot <- cached_structure(draw_dittoDotPlot, input, session, data, params = params)

        # How it looks: re-run for a styling change, without redrawing.
        generate_dittoDotPlot <- reactive({
            isolate_fn <- setup_auto_update_logic(input, params)
            base <- base_dittoDotPlot()
            fig <- .sci_finalize_plotly(base$fig, input, isolate_fn, faceted = base$faceted)

            # ggplotly() drops the size legend; draw it as the VizModules DotPlot
            # module does, from dittoSeq's own size scale (scale_size() over
            # min.percent to max.percent, sizes 0 to `size`) so the circles match
            # the dots. Hiding the legend hides this one too.
            add_size_legend(
                fig,
                data = base$legend_data,
                size.by = if (isFALSE(isolate_fn(input$legend.show))) NULL else "percent",
                title = "percent<br>expression",
                digits = 0,
                limits = base$limits,
                size.range = c(0, base$size),
                breaks = .ddp_size_breaks(base$legend_data$percent, base$limits),
                gap = 0.04,
                title.size = isolate_fn(input$legend.title.size),
                text.size = isolate_fn(input$legend.text.size),
                start.y = isolate_fn(input$size.legend.y),
                start.x = isolate_fn(input$size.legend.x),
                font.family = isolate_fn(input$legend.font.family),
                font.color = isolate_fn(input$legend.font.color)
            )
        })

        output$dittoDotPlot <- .sci_render_plotly(generate_dittoDotPlot, input, plot_source, edit_store, session,
            guard = function() req(input$vars, input$group.by)
        )

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
