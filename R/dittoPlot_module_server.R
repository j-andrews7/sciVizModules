#' Server logic for the dittoPlot module
#'
#' This module builds a per-group continuous-data plot with
#' [dittoSeq::dittoPlot()] and renders it as an interactive `plotly` figure.
#'
#' @param id The ID for the Shiny module.
#' @param data A `reactive` returning a `SingleCellExperiment`, `Seurat`, or
#'   `SummarizedExperiment` object.
#' @param hide.inputs A character vector of input IDs to hide.
#' @param hide.tabs A character vector of tab names to hide.
#' @param defaults A named list of default values used when resetting the inputs.
#'   Typically the same list passed to [dittoPlotInputsUI()].
#' @return The `moduleServer` function for the dittoPlot module.
#'
#' @import shiny
#' @import plotly
#' @importFrom shinyjs hide
#' @importFrom dittoSeq dittoPlot
#'
#' @seealso [dittoSeq::dittoPlot()], [sciVizModules::dittoPlotInputsUI()],
#' [sciVizModules::dittoPlotOutputUI()], [sciVizModules::dittoPlotApp()]
#'
#' @export
#' @author Jared Andrews
dittoPlotServer <- function(id, data, hide.inputs = NULL, hide.tabs = NULL, defaults = NULL) {
    stopifnot(is.reactive(data))
    data_reactive <- data

    moduleServer(id, function(input, output, session) {
        ns <- session$ns

        if (!is.null(hide.inputs)) {
            for (input.name in hide.inputs) hide(input.name)
        }
        if (!is.null(hide.tabs)) {
            for (tab.name in hide.tabs) hideTab(inputId = "dittoPlotTabsetPanel", target = tab.name)
        }

        default_palette_values <- default_palettes()[["choices"]][["Defaults"]][["dittoColors"]]

        # Palette groups come from color.by, falling back to group.by.
        palette_groups <- reactive({
            obj <- data_reactive()
            if (is.null(obj)) {
                return(character(0))
            }
            col <- input$color.by
            if (is.null(col) || !nzchar(col)) col <- input$group.by
            if (is.null(col) || !nzchar(col)) {
                return(character(0))
            }
            .ditto_group_levels(obj, col)
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
            disc <- .ditto_discrete_metas(obj)
            updateSelectInput(session, "group.by",
                selected = .ditto_default(defaults, "group.by", if (length(disc)) disc[1] else ""))
            updateSelectInput(session, "color.by", selected = .ditto_default(defaults, "color.by", ""))
            updateCheckboxGroupInput(session, "plots",
                selected = .ditto_default(defaults, "plots", c("jitter", "vlnplot")))
            updateSelectInput(session, "split.by", selected = .ditto_default(defaults, "split.by", ""))
            updateNumericInput(session, "jitter.size", value = .ditto_default(defaults, "jitter.size", 1))
            updateNumericInput(session, "jitter.width", value = .ditto_default(defaults, "jitter.width", 0.2))
            updateNumericInput(session, "vlnplot.lineweight", value = .ditto_default(defaults, "vlnplot.lineweight", 1))
            updateNumericInput(session, "boxplot.width", value = .ditto_default(defaults, "boxplot.width", 0.2))
            updateNumericInput(session, "boxplot.lineweight", value = .ditto_default(defaults, "boxplot.lineweight", 1))
            updateNumericInput(session, "vlnplot.width", value = .ditto_default(defaults, "vlnplot.width", 1))
            updateSelectInput(session, "vlnplot.scaling", selected = .ditto_default(defaults, "vlnplot.scaling", "area"))
            updateNumericInput(session, "ridgeplot.scale", value = .ditto_default(defaults, "ridgeplot.scale", 1.25))
            updateNumericInput(session, "ridgeplot.lineweight", value = .ditto_default(defaults, "ridgeplot.lineweight", 1))
            .ditto_reset_uniform(session, defaults)
        })

        generate_dittoPlot <- reactive({
            isolate_fn <- setup_auto_update_logic(input)

            obj <- data_reactive()
            req(obj)

            var <- isolate_fn(input$var)
            group.by <- isolate_fn(input$group.by)
            req(var, nzchar(var), group.by, nzchar(group.by))

            plots <- isolate_fn(input$plots)
            req(length(plots) > 0)

            color.by <- isolate_fn(input$color.by)
            if (is.null(color.by) || !nzchar(color.by)) color.by <- group.by
            split.by <- isolate_fn(input$split.by)
            if (is.null(split.by) || !nzchar(split.by)) split.by <- NULL

            groups <- isolate_fn(palette_groups())
            color.panel <- default_palette_values
            if (length(groups) > 0) {
                palette_values <- resolve_palette(groups, isolate_fn(input$palette.colours), default_palette_values)
                color.panel <- unname(palette_values[groups])
            }

            # Making theme arguments for uniform aesthetic
            additional_theme <- create_ggplot_axis_style(input, isolate_fn = isolate_fn)
            theme_style <- theme_bw() + theme(
                panel.border = additional_theme$panel.border,
                axis.line = additional_theme$axis.line,
                axis.ticks = additional_theme$axis.ticks,
                strip.background = element_blank()
            )

            gg <- dittoSeq::dittoPlot(
                object = obj,
                var = var,
                group.by = group.by,
                color.by = color.by,
                plots = plots,
                split.by = split.by,
                jitter.size = isolate_fn(input$jitter.size),
                jitter.width = isolate_fn(input$jitter.width),
                jitter.color = isolate_fn(input$jitter.color),
                vlnplot.lineweight = isolate_fn(input$vlnplot.lineweight),
                boxplot.width = isolate_fn(input$boxplot.width),
                boxplot.lineweight = isolate_fn(input$boxplot.lineweight),
                vlnplot.width = isolate_fn(input$vlnplot.width),
                vlnplot.scaling = isolate_fn(input$vlnplot.scaling),
                ridgeplot.scale = isolate_fn(input$ridgeplot.scale),
                ridgeplot.lineweight = isolate_fn(input$ridgeplot.lineweight),
                color.panel = color.panel,
                theme = theme_style
            )

            fig <- plotly::ggplotly(gg)
            .ditto_finalize_plotly(fig, input, isolate_fn)
        })

        output$dittoPlot <- renderPlotly({
            req(input$var, input$group.by, input$plots)
            tryCatch(
                apply_render_margins(generate_dittoPlot(), input),
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
                plot_reactive = generate_dittoPlot,
                inputs_reactive = AllInputs()
            )
        })

        output$download.source <- create_source_download_handler(
            data_list = plot_source_reactive,
            filename_base = "dittoPlot_source"
        )

        return(plot_source_reactive)
    })
}
