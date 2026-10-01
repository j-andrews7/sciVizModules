#' Server logic for the dittoBarPlot module
#'
#' This module builds a stacked composition bar plot with
#' [dittoSeq::dittoBarPlot()] and renders it as an interactive `plotly` figure.
#'
#' @param id The ID for the Shiny module.
#' @param data A `reactive` returning a `SingleCellExperiment`, `Seurat`, or
#'   `SummarizedExperiment` object.
#' @param hide.inputs A character vector of input IDs to hide.
#' @param hide.tabs A character vector of tab names to hide.
#' @param defaults A named list of default values used when resetting the inputs.
#'   Typically the same list passed to [dittoBarPlotInputsUI()].
#' @return The `moduleServer` function for the dittoBarPlot module.
#'
#' @import shiny
#' @import plotly
#' @importFrom shinyWidgets updateMaterialSwitch
#' @importFrom dittoSeq dittoBarPlot
#'
#' @seealso [dittoSeq::dittoBarPlot()], [sciVizModules::dittoBarPlotInputsUI()],
#' [sciVizModules::dittoBarPlotOutputUI()], [sciVizModules::dittoBarPlotApp()]
#'
#'
#' @examples
#' library(sciVizModules)
#' if (interactive()) dittoBarPlotApp()
#' @export
#' @author Jacob Martin
dittoBarPlotServer <- function(id, data, hide.inputs = NULL, hide.tabs = NULL, defaults = NULL) {
    stopifnot(is.reactive(data))
    data_reactive <- data

    moduleServer(id, function(input, output, session) {
        # Resolve any reactive() entries in `defaults` server-side, so a parent
        # app driving a parameter costs one render rather than a client round-trip.
        params <- setup_reactive_defaults(defaults, input, session)

        ns <- session$ns

        hide_input(session, hide.inputs)
        if (!is.null(hide.tabs)) {
            for (tab.name in hide.tabs) hideTab(inputId = "dittoBarPlotTabsetPanel", target = tab.name)
        }

        default_palette_values <- default_palettes()[["choices"]][["Defaults"]][["dittoColors"]]

        # Palette groups are the levels of the 'var' being quantified.
        palette_groups <- reactive({
            obj <- data_reactive()
            var <- input$var
            if (is.null(obj) || is.null(var) || !nzchar(var)) {
                return(character(0))
            }
            .ditto_group_levels(obj, var)
        })

        # The group-to-colour mapping the plot draws with. The picker is rebuilt
        # by renderUI() whenever the group set changes, and the value it then
        # reports is exactly what the server seeded it with -- reading the raw
        # input would rebuild the plot for that echo, on load and again the first
        # time the user opens the tab the picker lives on. See
        # VizModules::setup_group_colors().
        palette_store <- setup_group_colors(
            input, "palette.colours", palette_groups,
            default_palette_values, defaults, params
        )

        output$palette.selection <- renderUI({
            groups <- palette_groups()
            if (length(groups) == 0) {
                return(NULL)
            }
            initial_colors <- isolate(resolve_palette(
                groups, input$palette.colours, default_palette_values,
                VizModules::default_group_colors(defaults, "palette.colours")
            ))
            # Seed the store with what the picker is built from, so its first
            # report back is a no-op rather than a change.
            palette_store(initial_colors)
            multiColorPicker(
                ns("palette.colours"),
                label = "Bar Colors",
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
            update_viz_select(session, "var",
                selected = get_default(defaults, "var", if (length(disc)) disc[1] else ""))
            update_viz_select(session, "group.by", selected = get_default(defaults, "group.by",
                if (length(disc) >= 2) disc[2] else if (length(disc)) disc[1] else ""))
            update_viz_select(session, "scale", selected = get_default(defaults, "scale", "percent"))
            update_viz_select(session, "split.by", selected = get_default(defaults, "split.by", ""))
            updateNumericInput(session, "split.nrow", value = get_default(defaults, "split.nrow", NA))
            updateNumericInput(session, "split.ncol", value = get_default(defaults, "split.ncol", NA))
            updateMaterialSwitch(session, "x.labels.rotate", value = get_default(defaults, "x.labels.rotate", TRUE))
            updateMaterialSwitch(session, "retain.factor.levels", value = get_default(defaults, "retain.factor.levels", FALSE))
            .ditto_reset_uniform(session, defaults)
        })

        observeEvent(input$split.by, {
            split.set <- !is.null(input$split.by) && any(nzchar(input$split.by))
            VizModules::toggle_facet_title_inputs(session, split.set, hidden = hide.inputs)
        }, ignoreNULL = FALSE)

        generate_dittoBarPlot <- reactive({
            isolate_fn <- setup_auto_update_logic(input, params)

            obj <- data_reactive()
            req(obj)

            var <- isolate_fn(input$var)
            group.by <- isolate_fn(input$group.by)
            req(var, nzchar(var), group.by, nzchar(group.by))

            split.by <- isolate_fn(input$split.by)
            if (is.null(split.by) || !nzchar(split.by)) split.by <- NULL

            split.nrow <- isolate_fn(input$split.nrow)
            if (is.null(split.nrow) || is.na(split.nrow)) split.nrow <- NULL
            split.ncol <- isolate_fn(input$split.ncol)
            if (is.null(split.ncol) || is.na(split.ncol)) split.ncol <- NULL

            groups <- isolate_fn(palette_groups())
            color.panel <- default_palette_values
            if (length(groups) > 0) {
                palette_values <- resolve_palette(
                    groups, isolate_fn(palette_store()), default_palette_values,
                    VizModules::default_group_colors(defaults, "palette.colours")
                )
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

            gg <- dittoSeq::dittoBarPlot(
                object = obj,
                var = var,
                group.by = group.by,
                scale = isolate_fn(input$scale),
                split.by = split.by,
                split.nrow = split.nrow,
                split.ncol = split.ncol,
                x.labels.rotate = isolate_fn(input$x.labels.rotate),
                retain.factor.levels = isolate_fn(input$retain.factor.levels),
                color.panel = color.panel,
                theme = theme_style
            )

            fig <- plotly::ggplotly(gg)
            .ditto_finalize_plotly(fig, input, isolate_fn, faceted = !is.null(split.by))
        })

        output$dittoBarPlot <- renderPlotly({
            req(input$var, input$group.by)
            tryCatch(
                apply_render_margins(generate_dittoBarPlot(), input),
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
                plot_reactive = generate_dittoBarPlot,
                inputs_reactive = AllInputs()
            )
        })

        output$download.source <- create_source_download_handler(
            data_list = plot_source_reactive,
            filename_base = "dittoBarPlot_source"
        )

        return(plot_source_reactive)
    })
}
