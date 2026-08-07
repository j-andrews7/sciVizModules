#' Server logic for the dittoDimPlot module
#'
#' This module builds a dimensionality-reduction plot with
#' [dittoSeq::dittoDimPlot()] and renders it as an interactive `plotly` figure.
#'
#' @param id The ID for the Shiny module.
#' @param data A `reactive` returning a `SingleCellExperiment`, `Seurat`, or
#'   `SummarizedExperiment` object.
#' @param hide.inputs A character vector of input IDs to hide. These will still be
#'   initialized and their values passed to the plot function, but the user will
#'   not be able to see/adjust them in the UI.
#' @param hide.tabs A character vector of tab names to hide.
#' @param defaults A named list of default values used when resetting the inputs.
#'   Typically the same list passed to [dittoDimPlotInputsUI()].
#' @return The `moduleServer` function for the dittoDimPlot module.
#'
#' @import shiny
#' @import plotly
#' @importFrom shinyWidgets updateMaterialSwitch
#' @importFrom dittoSeq dittoDimPlot
#'
#' @seealso [dittoSeq::dittoDimPlot()], [sciVizModules::dittoDimPlotInputsUI()],
#' [sciVizModules::dittoDimPlotOutputUI()], [sciVizModules::dittoDimPlotApp()]
#'
#'
#' @examples
#' library(sciVizModules)
#' if (interactive()) dittoDimPlotApp()
#' @export
#' @author Jacob Martin, Jared Andrews
dittoDimPlotServer <- function(id, data, hide.inputs = NULL, hide.tabs = NULL, defaults = NULL) {
    stopifnot(is.reactive(data))
    data_reactive <- data

    moduleServer(id, function(input, output, session) {
        ns <- session$ns

        hideInput(session, hide.inputs)
        if (!is.null(hide.tabs)) {
            for (tab.name in hide.tabs) hideTab(inputId = "dittoDimPlotTabsetPanel", target = tab.name)
        }

        default_palette_values <- default_palettes()[["choices"]][["Defaults"]][["dittoColors"]]

        # Discrete groups needing colors depend on the selected 'var'.
        palette_groups <- reactive({
            obj <- data_reactive()
            var <- input$var
            if (is.null(obj) || is.null(var) || !nzchar(var)) {
                return(character(0))
            }
            if (!var %in% .ditto_discrete_metas(obj)) {
                return(character(0))
            }
            .ditto_group_levels(obj, var)
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
            updateSelectInput(session, "reduction.use",
                selected = get_default(defaults, "reduction.use", get_default_reduction(obj)))
            updateNumericInput(session, "dim.1", value = get_default(defaults, "dim.1", 1))
            updateNumericInput(session, "dim.2", value = get_default(defaults, "dim.2", 2))
            updateSelectInput(session, "shape.by", selected = get_default(defaults, "shape.by", ""))
            updateSelectInput(session, "split.by", selected = get_default(defaults, "split.by", ""))
            updateSelectInput(session, "order", selected = get_default(defaults, "order", "unordered"))
            updateNumericInput(session, "size", value = get_default(defaults, "size", 1))
            updateNumericInput(session, "opacity", value = get_default(defaults, "opacity", 1))
            updateMaterialSwitch(session, "do.label", value = get_default(defaults, "do.label", FALSE))
            updateMaterialSwitch(session, "do.ellipse", value = get_default(defaults, "do.ellipse", FALSE))
            updateMaterialSwitch(session, "do.contour", value = get_default(defaults, "do.contour", FALSE))
            updateNumericInput(session, "labels.size", value = get_default(defaults, "labels.size", 5))
            .ditto_reset_uniform(session, defaults)
        })

        generate_dittoDimPlot <- reactive({
            isolate_fn <- setup_auto_update_logic(input)

            obj <- data_reactive()
            req(obj)

            var <- isolate_fn(input$var)
            req(var, nzchar(var))
            reduction.use <- isolate_fn(input$reduction.use)
            req(reduction.use, nzchar(reduction.use))

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

            # Making theme arguments for uniform aesthetic
            additional_theme <- create_ggplot_axis_style(input, isolate_fn = isolate_fn)
            theme_style <- theme_bw() + theme(
                panel.border = additional_theme$panel.border,
                axis.line = additional_theme$axis.line,
                axis.ticks = additional_theme$axis.ticks,
                strip.background = element_blank()
            )

            gg <- dittoSeq::dittoDimPlot(
                object = obj,
                var = var,
                reduction.use = reduction.use,
                dim.1 = isolate_fn(input$dim.1),
                dim.2 = isolate_fn(input$dim.2),
                shape.by = shape.by,
                split.by = split.by,
                size = isolate_fn(input$size),
                opacity = isolate_fn(input$opacity),
                order = isolate_fn(input$order),
                do.label = isolate_fn(input$do.label),
                do.ellipse = isolate_fn(input$do.ellipse),
                do.contour = isolate_fn(input$do.contour),
                labels.size = isolate_fn(input$labels.size),
                min.color = isolate_fn(input$min.color),
                max.color = isolate_fn(input$max.color),
                color.panel = color.panel,
                theme = theme_style
            )

            fig <- plotly::ggplotly(gg)
            .ditto_finalize_plotly(fig, input, isolate_fn)
        })

        output$dittoDimPlot <- renderPlotly({
            req(input$var, input$reduction.use)
            tryCatch(
                apply_render_margins(generate_dittoDimPlot(), input),
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
                plot_reactive = generate_dittoDimPlot,
                inputs_reactive = AllInputs()
            )
        })

        output$download.source <- create_source_download_handler(
            data_list = plot_source_reactive,
            filename_base = "dittoDimPlot_source"
        )

        return(plot_source_reactive)
    })
}
