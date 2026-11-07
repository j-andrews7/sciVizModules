#' Server logic for the dittoRidgeJitter module
#'
#' This module builds a ridgeline-with-jitter plot with
#' [dittoSeq::dittoRidgeJitter()] and renders it as an interactive `plotly`
#' figure.
#'
#' @param id The ID for the Shiny module.
#' @param data A `reactive` returning a `SingleCellExperiment`, `Seurat`, or
#'   `SummarizedExperiment` object.
#' @param hide.inputs A character vector of input IDs to hide.
#' @param hide.tabs A character vector of tab names to hide.
#' @param defaults A named list of default values used when resetting the inputs.
#'   Typically the same list passed to [dittoRidgeJitterInputsUI()].
#' @return The `moduleServer` function for the dittoRidgeJitter module.
#'
#' @import shiny
#' @import plotly
#' @importFrom dittoSeq dittoRidgeJitter
#'
#' @seealso [dittoSeq::dittoRidgeJitter()], [sciVizModules::dittoRidgeJitterInputsUI()],
#' [sciVizModules::dittoRidgeJitterOutputUI()], [sciVizModules::dittoRidgeJitterApp()]
#'
#'
#' @examples
#' library(sciVizModules)
#' if (interactive()) dittoRidgeJitterApp()
#' @export
#' @author Jacob Martin, Jared Andrews
dittoRidgeJitterServer <- function(id, data, hide.inputs = NULL, hide.tabs = NULL, defaults = NULL) {
    stopifnot(is.reactive(data))
    data_reactive <- data

    moduleServer(id, function(input, output, session) {
        # Resolve any reactive() entries in `defaults` server-side, so a parent
        # app driving a parameter costs one render rather than a client round-trip.
        params <- setup_reactive_defaults(defaults, input, session)
        plot_source <- session$ns("dittoRidgeJitter")
        edit_store <- setup_manual_edits(input, session, plot_source)

        ns <- session$ns

        hide_input(session, hide.inputs)
        if (!is.null(hide.tabs)) {
            for (tab.name in hide.tabs) hideTab(inputId = "dittoRidgeJitterTabsetPanel", target = tab.name)
        }

        default_palette_values <- default_palettes()[["choices"]][["Defaults"]][["dittoColors"]]

        # Palette groups come from color.by, falling back to group.by.
        palette_groups <- reactive({
            obj <- data_reactive()
            if (is.null(obj)) {
                return(character(0))
            }
            col <- blank_to_null(input$color.by) %||% blank_to_null(input$group.by)
            if (is.null(col)) {
                return(character(0))
            }
            .ditto_group_levels(obj, col)
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

        observeEvent(input$reset, {
            obj <- data_reactive()
            req(obj)
            disc <- .ditto_discrete_metas(obj)
            update_viz_select(session, "group.by",
                selected = get_default(defaults, "group.by", if (length(disc)) disc[1] else ""))
            update_viz_select(session, "color.by", selected = get_default(defaults, "color.by", ""))
            update_viz_select(session, "split.by", selected = get_default(defaults, "split.by", ""))
            updateNumericInput(session, "ridgeplot.scale", value = get_default(defaults, "ridgeplot.scale", 1.25))
            updateNumericInput(session, "ridgeplot.lineweight", value = get_default(defaults, "ridgeplot.lineweight", 1))
            update_viz_select(session, "ridgeplot.shape", selected = get_default(defaults, "ridgeplot.shape", "smooth"))
            updateNumericInput(session, "ridgeplot.bins", value = get_default(defaults, "ridgeplot.bins", 30))
            updateNumericInput(session, "jitter.size", value = get_default(defaults, "jitter.size", 1))
            updateNumericInput(session, "jitter.width", value = get_default(defaults, "jitter.width", 0.2))
            reset_group_colors(session, "palette.colours", defaults, palette_groups(), default_palette_values)
            updateCheckboxInput(session, "webgl", value = get_default(defaults, "webgl", TRUE, is.logical))
            .ditto_reset_uniform(session, defaults, edit_store)
        })

        observeEvent(input$split.by, {
            split.set <- nz_value(input$split.by)
            toggle_facet_title_inputs(session, split.set, hidden = hide.inputs)
        }, ignoreNULL = FALSE)

        # What is drawn, cached by cached_structure(): it runs again only for a
        # change to the data, to `extra`, or to an input read here as
        # isolate_fn(input$key). A styling change re-runs generate_*() alone.
        draw_dittoRidgeJitter <- function(isolate_fn) {
            obj <- data_reactive()
            req(obj)

            var <- isolate_fn(input$var)
            group.by <- isolate_fn(input$group.by)
            req(nz_value(var), nz_value(group.by))

            color.by <- isolate_fn(input$color.by)
            color.by <- blank_to_null(color.by) %||% group.by
            split.by <- isolate_fn(input$split.by)
            split.by <- blank_to_null(split.by)

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

            # ggplot2 draws a jitter layer's seed when the layer is created, so build under
            # a fixed one or the points jump to new positions on every rebuild.
            gg <- with_stable_seed(dittoSeq::dittoRidgeJitter(
                object = obj,
                var = var,
                group.by = group.by,
                color.by = color.by,
                split.by = split.by,
                ridgeplot.scale = isolate_fn(input$ridgeplot.scale),
                ridgeplot.lineweight = isolate_fn(input$ridgeplot.lineweight),
                ridgeplot.shape = isolate_fn(input$ridgeplot.shape),
                ridgeplot.bins = isolate_fn(input$ridgeplot.bins),
                jitter.size = isolate_fn(input$jitter.size),
                jitter.width = isolate_fn(input$jitter.width),
                jitter.color = isolate_fn(input$jitter.color),
                color.panel = color.panel,
                theme = theme_style
            ))

            fig <- plotly::ggplotly(gg)
            if (!isFALSE(isolate_fn(input$webgl))) {
                fig <- auto_webgl(fig)
            }
            list(fig = fig, faceted = !is.null(split.by))
        }
        base_dittoRidgeJitter <- cached_structure(draw_dittoRidgeJitter, input, session, data_reactive,
            params = params, extra = function() list(palette_groups(), palette_store())
        )

        # How it looks: re-run for a styling change, without redrawing.
        generate_dittoRidgeJitter <- reactive({
            isolate_fn <- setup_auto_update_logic(input, params)
            base <- base_dittoRidgeJitter()
            .sci_finalize_plotly(base$fig, input, isolate_fn, faceted = base$faceted)
        })

        output$dittoRidgeJitter <- .sci_render_plotly(
            generate_dittoRidgeJitter, input, plot_source, edit_store, session,
            guard = function() req(input$var, input$group.by)
        )

        AllInputs <- reactive({
            reactiveValuesToList(input)
        })

        plot_source_reactive <- reactive({
            collect_source_data(
                plot_reactive = generate_dittoRidgeJitter,
                inputs_reactive = AllInputs()
            )
        })

        output$download.source <- create_source_download_handler(
            data_list = plot_source_reactive,
            filename_base = "dittoRidgeJitter_source"
        )

        return(plot_source_reactive)
    })
}
