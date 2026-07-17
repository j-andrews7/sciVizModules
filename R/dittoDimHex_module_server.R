#' Server logic for the dittoDimHex module
#'
#' This module builds a hexagonal-bin dimensionality-reduction plot with
#' [dittoSeq::dittoDimHex()] and renders it as an interactive `plotly` figure.
#'
#' @param id The ID for the Shiny module.
#' @param data A `reactive` returning a `SingleCellExperiment`, `Seurat`, or
#'   `SummarizedExperiment` object.
#' @param hide.inputs A character vector of input IDs to hide.
#' @param hide.tabs A character vector of tab names to hide.
#' @param defaults A named list of default values used when resetting the inputs.
#'   Typically the same list passed to [dittoDimHexInputsUI()].
#' @return The `moduleServer` function for the dittoDimHex module.
#'
#' @import shiny
#' @import plotly
#' @importFrom shinyjs hide
#' @importFrom shinyWidgets updateMaterialSwitch
#' @importFrom dittoSeq dittoDimHex
#'
#' @seealso [dittoSeq::dittoDimHex()], [sciVizModules::dittoDimHexInputsUI()],
#' [sciVizModules::dittoDimHexOutputUI()], [sciVizModules::dittoDimHexApp()]
#'
#' @export
#' @author Jacob Martin
dittoDimHexServer <- function(id, data, hide.inputs = NULL, hide.tabs = NULL, defaults = NULL) {
    stopifnot(is.reactive(data))
    data_reactive <- data

    moduleServer(id, function(input, output, session) {
        if (!is.null(hide.inputs)) {
            for (input.name in hide.inputs) hide(input.name)
        }
        if (!is.null(hide.tabs)) {
            for (tab.name in hide.tabs) hideTab(inputId = "dittoDimHexTabsetPanel", target = tab.name)
        }

        default_palette_values <- default_palettes()[["choices"]][["Defaults"]][["dittoColors"]]

        observeEvent(input$reset, {
            obj <- data_reactive()
            req(obj)
            updateSelectInput(session, "color.var", selected = get_default(defaults, "color.var", ""))
            updateSelectInput(session, "reduction.use",
                selected = get_default(defaults, "reduction.use", get_default_reduction(obj)))
            updateNumericInput(session, "dim.1", value = get_default(defaults, "dim.1", 1))
            updateNumericInput(session, "dim.2", value = get_default(defaults, "dim.2", 2))
            updateNumericInput(session, "bins", value = get_default(defaults, "bins", 30))
            updateTextInput(session, "color.method", value = get_default(defaults, "color.method", ""))
            updateSelectInput(session, "split.by", selected = get_default(defaults, "split.by", ""))
            updateNumericInput(session, "min.opacity", value = get_default(defaults, "min.opacity", 0.2))
            updateNumericInput(session, "max.opacity", value = get_default(defaults, "max.opacity", 1))
            updateMaterialSwitch(session, "do.contour", value = get_default(defaults, "do.contour", FALSE))
            updateMaterialSwitch(session, "do.label", value = get_default(defaults, "do.label", FALSE))
            updateNumericInput(session, "labels.size", value = get_default(defaults, "labels.size", 5))
            updateMaterialSwitch(session, "do.ellipse", value = get_default(defaults, "do.ellipse", FALSE))
            .ditto_reset_uniform(session, defaults)
        })

        generate_dittoDimHex <- reactive({
            isolate_fn <- setup_auto_update_logic(input)

            obj <- data_reactive()
            req(obj)

            reduction.use <- isolate_fn(input$reduction.use)
            req(reduction.use, nzchar(reduction.use))

            color.var <- isolate_fn(input$color.var)
            if (is.null(color.var) || !nzchar(color.var)) color.var <- NULL

            color.method <- isolate_fn(input$color.method)
            if (is.null(color.method) || !nzchar(color.method)) color.method <- NULL

            split.by <- isolate_fn(input$split.by)
            if (is.null(split.by) || !nzchar(split.by)) split.by <- NULL

            # Making theme arguments for uniform aesthetic
            additional_theme <- create_ggplot_axis_style(input, isolate_fn = isolate_fn)
            theme_style <- theme_bw() + theme(
                panel.border = additional_theme$panel.border,
                axis.line = additional_theme$axis.line,
                axis.ticks = additional_theme$axis.ticks,
                strip.background = element_blank()
            )

            gg <- dittoSeq::dittoDimHex(
                object = obj,
                color.var = color.var,
                bins = isolate_fn(input$bins),
                color.method = color.method,
                reduction.use = reduction.use,
                dim.1 = isolate_fn(input$dim.1),
                dim.2 = isolate_fn(input$dim.2),
                split.by = split.by,
                min.color = isolate_fn(input$min.color),
                max.color = isolate_fn(input$max.color),
                min.opacity = isolate_fn(input$min.opacity),
                max.opacity = isolate_fn(input$max.opacity),
                do.contour = isolate_fn(input$do.contour),
                do.label = isolate_fn(input$do.label),
                labels.size = isolate_fn(input$labels.size),
                do.ellipse = isolate_fn(input$do.ellipse),
                color.panel = default_palette_values,
                theme = theme_style
            )

            fig <- plotly::ggplotly(gg)
            .ditto_finalize_plotly(fig, input, isolate_fn)
        })

        output$dittoDimHex <- renderPlotly({
            req(input$reduction.use)
            tryCatch(
                apply_render_margins(generate_dittoDimHex(), input),
                error = function(e) {
                    empty_plot(text = conditionMessage(e), plotly = TRUE)
                }
            )
        })

        AllInputs <- reactive({
            reactiveValuesToList(input)
        })

        plot_source_reactive <- reactive({
            collect_source_data(
                plot_reactive = generate_dittoDimHex,
                inputs_reactive = AllInputs()
            )
        })

        output$download.source <- create_source_download_handler(
            data_list = plot_source_reactive,
            filename_base = "dittoDimHex_source"
        )

        return(plot_source_reactive)
    })
}
