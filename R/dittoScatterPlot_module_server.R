#' Server logic for the dittoScatterPlot module
#'
#' This module builds a scatter plot with [dittoSeq::dittoScatterPlot()] and
#' renders it as an interactive `plotly` figure.
#'
#' @param id The ID for the Shiny module.
#' @param data A `reactive` returning a `SingleCellExperiment`, `Seurat`, or
#'   `SummarizedExperiment` object.
#' @param hide.inputs A character vector of input IDs to hide.
#' @param hide.tabs A character vector of tab names to hide.
#' @param defaults A named list of default values used when resetting the inputs.
#'   Typically the same list passed to [dittoScatterPlotInputsUI()].
#' @return The `moduleServer` function for the dittoScatterPlot module.
#'
#' @import shiny
#' @import plotly
#' @importFrom shinyjs hide
#' @importFrom shinyWidgets updateMaterialSwitch
#' @importFrom dittoSeq dittoScatterPlot
#'
#' @seealso [dittoSeq::dittoScatterPlot()], [sciVizModules::dittoScatterPlotInputsUI()],
#' [sciVizModules::dittoScatterPlotOutputUI()], [sciVizModules::dittoScatterPlotApp()]
#'
#' @export
#' @author Jared Andrews
dittoScatterPlotServer <- function(id, data, hide.inputs = NULL, hide.tabs = NULL, defaults = NULL) {
    stopifnot(is.reactive(data))
    data_reactive <- data

    moduleServer(id, function(input, output, session) {
        ns <- session$ns

        if (!is.null(hide.inputs)) {
            for (input.name in hide.inputs) hide(input.name)
        }
        if (!is.null(hide.tabs)) {
            for (tab.name in hide.tabs) hideTab(inputId = "dittoScatterPlotTabsetPanel", target = tab.name)
        }

        default_palette_values <- default_palettes()[["choices"]][["Defaults"]][["dittoColors"]]

        palette_groups <- reactive({
            obj <- data_reactive()
            color.var <- input$color.var
            if (is.null(obj) || is.null(color.var) || !nzchar(color.var)) {
                return(character(0))
            }
            if (!color.var %in% .ditto_discrete_metas(obj)) {
                return(character(0))
            }
            .ditto_group_levels(obj, color.var)
        })

        output$palette.selection <- renderUI({
            groups <- palette_groups()
            if (length(groups) == 0) {
                return(NULL)
            }
            initial_colors <- isolate(resolve_palette(groups, input$palette.colours, default_palette_values))
            multiColorPicker(
                ns("palette.colours"),
                label = "Group Colors",
                groups = groups,
                palette_options = default_palettes()[["choices"]],
                selected_palette = "dittoColors",
                colors = initial_colors,
                compact = TRUE
            )
        })

        observeEvent(input$reset, {
            obj <- data_reactive()
            req(obj)
            updateSelectInput(session, "color.var", selected = .ditto_default(defaults, "color.var", ""))
            updateSelectInput(session, "shape.by", selected = .ditto_default(defaults, "shape.by", ""))
            updateSelectInput(session, "split.by", selected = .ditto_default(defaults, "split.by", ""))
            updateSelectInput(session, "order", selected = .ditto_default(defaults, "order", "unordered"))
            updateNumericInput(session, "size", value = .ditto_default(defaults, "size", 1))
            updateNumericInput(session, "opacity", value = .ditto_default(defaults, "opacity", 1))
            updateMaterialSwitch(session, "do.label", value = .ditto_default(defaults, "do.label", FALSE))
            updateNumericInput(session, "labels.size", value = .ditto_default(defaults, "labels.size", 5))
            updateMaterialSwitch(session, "do.ellipse", value = .ditto_default(defaults, "do.ellipse", FALSE))
            updateMaterialSwitch(session, "do.contour", value = .ditto_default(defaults, "do.contour", FALSE))
            .ditto_reset_uniform(session, defaults)
        })

        generate_dittoScatterPlot <- reactive({
            isolate_fn <- setup_auto_update_logic(input)

            obj <- data_reactive()
            req(obj)

            x.var <- isolate_fn(input$x.var)
            y.var <- isolate_fn(input$y.var)
            req(x.var, nzchar(x.var), y.var, nzchar(y.var))

            color.var <- isolate_fn(input$color.var)
            if (is.null(color.var) || !nzchar(color.var)) color.var <- NULL
            shape.by <- isolate_fn(input$shape.by)
            if (is.null(shape.by) || !nzchar(shape.by)) shape.by <- NULL
            split.by <- isolate_fn(input$split.by)
            if (is.null(split.by) || !nzchar(split.by)) split.by <- NULL

            groups <- isolate_fn(palette_groups())
            color.panel <- default_palette_values
            if (length(groups) > 0) {
                palette_values <- resolve_palette(groups, isolate_fn(input$palette.colours), default_palette_values)
                color.panel <- unname(palette_values[groups])
            }

            gg <- dittoSeq::dittoScatterPlot(
                object = obj,
                x.var = x.var,
                y.var = y.var,
                color.var = color.var,
                shape.by = shape.by,
                split.by = split.by,
                size = isolate_fn(input$size),
                opacity = isolate_fn(input$opacity),
                order = isolate_fn(input$order),
                do.label = isolate_fn(input$do.label),
                labels.size = isolate_fn(input$labels.size),
                do.ellipse = isolate_fn(input$do.ellipse),
                do.contour = isolate_fn(input$do.contour),
                min.color = isolate_fn(input$min.color),
                max.color = isolate_fn(input$max.color),
                color.panel = color.panel
            )

            fig <- plotly::ggplotly(gg)
            .ditto_finalize_plotly(fig, input, isolate_fn)
        })

        output$dittoScatterPlot <- renderPlotly({
            req(input$x.var, input$y.var)
            tryCatch(
                apply_render_margins(generate_dittoScatterPlot(), input),
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
                plot_reactive = generate_dittoScatterPlot,
                inputs_reactive = AllInputs()
            )
        })

        output$download.source <- create_source_download_handler(
            data_list = plot_source_reactive,
            filename_base = "dittoScatterPlot_source"
        )

        return(plot_source_reactive)
    })
}
