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
#' @importFrom shinyWidgets updateMaterialSwitch
#' @importFrom dittoSeq dittoScatterPlot
#'
#' @seealso [dittoSeq::dittoScatterPlot()], [sciVizModules::dittoScatterPlotInputsUI()],
#' [sciVizModules::dittoScatterPlotOutputUI()], [sciVizModules::dittoScatterPlotApp()]
#'
#'
#' @examples
#' library(sciVizModules)
#' if (interactive()) dittoScatterPlotApp()
#' @export
#' @author Jacob Martin, Jared Andrews
dittoScatterPlotServer <- function(id, data, hide.inputs = NULL, hide.tabs = NULL, defaults = NULL) {
    stopifnot(is.reactive(data))
    data_reactive <- data

    moduleServer(id, function(input, output, session) {
        # Resolve any reactive() entries in `defaults` server-side, so a parent
        # app driving a parameter costs one render rather than a client round-trip.
        params <- setup_reactive_defaults(defaults, input, session)
        plot_source <- session$ns("dittoScatterPlot")
        edit_store <- setup_manual_edits(input, session, plot_source)

        ns <- session$ns

        hide_input(session, hide.inputs)
        if (!is.null(hide.tabs)) {
            for (tab.name in hide.tabs) hideTab(inputId = "dittoScatterPlotTabsetPanel", target = tab.name)
        }

        default_palette_values <- default_palettes()[["choices"]][["Defaults"]][["dittoColors"]]

        palette_groups <- reactive({
            obj <- data_reactive()
            color.var <- input$color.var
            if (is.null(obj) || !nz_value(color.var)) {
                return(character(0))
            }
            if (!color.var %in% .ditto_discrete_metas(obj)) {
                return(character(0))
            }
            .ditto_group_levels(obj, color.var)
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
                default_group_colors(defaults, "palette.colours")
            ))
            # Seed the store with what the picker is built from, so its first
            # report back is a no-op rather than a change.
            palette_store(initial_colors)
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

        # What the Annotations tab labels. plotly reports a picked cell by its place in
        # its trace, so the selection goes whenever the traces are drawn differently.
        annotations <- .ditto_annotation_state(input, plot_source, params, function() {
            list(data_reactive(), input$color.var, input$shape.by, input$split.by, input$order)
        })

        observeEvent(input$reset, {
            obj <- data_reactive()
            req(obj)
            update_viz_select(session, "color.var", selected = get_default(defaults, "color.var", ""))
            update_viz_select(session, "shape.by", selected = get_default(defaults, "shape.by", ""))
            update_viz_select(session, "split.by", selected = get_default(defaults, "split.by", ""))
            update_viz_select(session, "order", selected = get_default(defaults, "order", "unordered"))
            updateNumericInput(session, "size", value = get_default(defaults, "size", 1))
            updateNumericInput(session, "opacity", value = get_default(defaults, "opacity", 1))
            updateMaterialSwitch(session, "do.ellipse", value = get_default(defaults, "do.ellipse", FALSE))
            updateMaterialSwitch(session, "do.contour", value = get_default(defaults, "do.contour", FALSE))
            reset_group_colors(session, "palette.colours", defaults, palette_groups(), default_palette_values)
            updateCheckboxInput(session, "webgl", value = get_default(defaults, "webgl", TRUE, is.logical))
            .ditto_reset_annotations(session, defaults, obj, annotations)
            .ditto_reset_uniform(session, defaults, edit_store)
        })

        observeEvent(input$split.by, {
            split.set <- nz_value(input$split.by)
            toggle_facet_title_inputs(session, split.set, hidden = hide.inputs)
        }, ignoreNULL = FALSE)

        # What is drawn, cached by cached_structure(): it runs again only for a
        # change to the data, to `extra`, or to an input read here as
        # isolate_fn(input$key). A styling change re-runs generate_*() alone.
        draw_dittoScatterPlot <- function(isolate_fn) {
            obj <- data_reactive()
            req(obj)

            x.var <- isolate_fn(input$x.var)
            y.var <- isolate_fn(input$y.var)
            req(nz_value(x.var), nz_value(y.var))

            color.var <- isolate_fn(input$color.var)
            color.var <- blank_to_null(color.var)
            shape.by <- isolate_fn(input$shape.by)
            shape.by <- blank_to_null(shape.by)
            split.by <- isolate_fn(input$split.by)
            split.by <- blank_to_null(split.by)

            # Annotations find their cells through the hover text, so it is drawn
            # while they are in use, with the Annotate By field first.
            annotate.by <- blank_to_null(isolate_fn(input$annotate.by))
            if (identical(annotate.by, .ditto_cell_id)) obj <- .ditto_with_cell_ids(obj)

            groups <- isolate_fn(palette_groups())
            color.panel <- default_palette_values
            if (length(groups) > 0) {
                palette_values <- resolve_palette(
                    groups, isolate_fn(palette_store()), default_palette_values,
                    default_group_colors(defaults, "palette.colours")
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
                do.ellipse = isolate_fn(input$do.ellipse),
                do.contour = isolate_fn(input$do.contour),
                min.color = isolate_fn(input$min.color),
                max.color = isolate_fn(input$max.color),
                color.panel = color.panel,
                do.hover = !is.null(annotate.by),
                hover.data = unique(c(annotate.by, x.var, y.var, color.var, shape.by)),
                theme = theme_style
            )

            # dittoSeq converts the plot itself when it draws the hover text.
            fig <- plotly::plotly_build(if (inherits(gg, "plotly")) gg else plotly::ggplotly(gg))
            fig <- .ditto_annotate(
                fig, obj, annotate.by, isolate_fn(annotations$highlights()), isolate_fn(annotations$selected()),
                input, isolate_fn, size = isolate_fn(input$size)
            )
            # With the lines, or an ellipse or contour would end up beneath the points.
            if (!isFALSE(isolate_fn(input$webgl))) {
                fig <- auto_webgl(fig, overlays = TRUE)
            }
            if (length(groups) > 0 && !is.null(shape.by)) {
                fig <- split_color_shape_legend(fig, groups, .ditto_group_levels(obj, shape.by))
            }
            list(fig = fig, faceted = !is.null(split.by))
        }
        base_dittoScatterPlot <- cached_structure(draw_dittoScatterPlot, input, session, data_reactive,
            params = params, extra = function() {
                list(palette_groups(), palette_store(), annotations$highlights(), annotations$selected())
            }
        )

        # How it looks: re-run for a styling change, without redrawing.
        generate_dittoScatterPlot <- reactive({
            isolate_fn <- setup_auto_update_logic(input, params)
            base <- base_dittoScatterPlot()
            .sci_finalize_plotly(base$fig, input, isolate_fn, faceted = base$faceted)
        })

        output$dittoScatterPlot <- .sci_render_plotly(
            generate_dittoScatterPlot, input, plot_source, edit_store, session,
            guard = function() req(input$x.var, input$y.var)
        )

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
