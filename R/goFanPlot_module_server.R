#' Server logic for the goFanPlot module
#'
#' This module builds a GO enrichment sunburst ("fan") plot with
#' [GOfan::sunburstGO()] (via [goFanPlot()]) and renders it as an interactive
#' `plotly` figure.
#'
#' @param id The ID for the Shiny module.
#' @param data A `reactive` returning the enrichment results data frame. Must
#'   contain a column of GO identifiers and a numeric column to colour by.
#' @param hide.inputs A character vector of input IDs to hide. These will still
#'   be initialized and their values passed to the plot function, but the user
#'   will not be able to see/adjust them in the UI.
#' @param hide.tabs A character vector of tab names to hide.
#' @param defaults A named list of default values used when resetting the
#'   inputs. Typically the same list passed to [goFanPlotInputsUI()].
#' @return The `moduleServer` function for the goFanPlot module.
#'
#' @import shiny
#' @import plotly
#' @importFrom shinyjs hide
#' @importFrom shinyWidgets updateMaterialSwitch
#'
#' @seealso [GOfan::sunburstGO()], [sciVizModules::goFanPlot()],
#' [sciVizModules::goFanPlotInputsUI()], [sciVizModules::goFanPlotOutputUI()],
#' [sciVizModules::goFanPlotApp()]
#'
#' @export
#' @author Jacob Martin, Jared Andrews
goFanPlotServer <- function(id, data, hide.inputs = NULL, hide.tabs = NULL, defaults = NULL) {
    stopifnot(is.reactive(data))
    data_reactive <- data

    moduleServer(id, function(input, output, session) {
        if (!is.null(hide.inputs)) {
            for (input.name in hide.inputs) hide(input.name)
        }
        if (!is.null(hide.tabs)) {
            for (tab.name in hide.tabs) hideTab(inputId = "goFanPlotTabsetPanel", target = tab.name)
        }

        observeEvent(input$reset, {
            df <- data_reactive()
            req(df)

            detected.id <- .gofan_id_col(df)
            id.choices <- names(df)[vapply(df, function(x) !is.numeric(x), logical(1))]
            if (is.null(detected.id)) detected.id <- if (length(id.choices)) id.choices[1] else ""
            detected.fill <- .gofan_fill_col(df)
            num.choices <- names(df)[vapply(df, is.numeric, logical(1))]
            if (is.null(detected.fill)) detected.fill <- if (length(num.choices)) num.choices[1] else ""

            updateSelectInput(session, "term.id", selected = get_default(defaults, "term.id", detected.id))
            updateSelectInput(session, "onto", selected = get_default(defaults, "onto", .gofan_onto(df)))
            updateSelectInput(session, "org", selected = get_default(defaults, "org", "org.Hs.eg.db"))
            updateSelectInput(session, "fill", selected = get_default(defaults, "fill", detected.fill))
            updateSelectInput(session, "sub_rect", selected = get_default(defaults, "sub_rect", ""))
            updateNumericInput(session, "go.annotation.level.cutoff",
                value = get_default(defaults, "go.annotation.level.cutoff", 4))
            updateNumericInput(session, "filter.nodes.by.edge.number",
                value = get_default(defaults, "filter.nodes.by.edge.number", 2))
            updateMaterialSwitch(session, "fill.na.by.0", value = get_default(defaults, "fill.na.by.0", TRUE))
            reset_plotly_inputs(session, defaults)
        })

        generate_goFanPlot <- reactive({
            isolate_fn <- setup_auto_update_logic(input)

            df <- data_reactive()
            req(df)

            term.id <- isolate_fn(input$term.id)
            fill <- isolate_fn(input$fill)
            req(term.id, nzchar(term.id), fill, nzchar(fill))
            req(term.id %in% names(df), fill %in% names(df))

            sub_rect <- isolate_fn(input$sub_rect)
            if (is.null(sub_rect) || !nzchar(sub_rect)) sub_rect <- NULL

            fig <- goFanPlot(
                data = df,
                org = isolate_fn(input$org),
                term.id = term.id,
                fill = fill,
                sub_rect = sub_rect,
                onto = isolate_fn(input$onto),
                go.annotation.level.cutoff = isolate_fn(input$go.annotation.level.cutoff),
                filter.nodes.by.edge.number = isolate_fn(input$filter.nodes.by.edge.number),
                fill.na.by.0 = isolate_fn(input$fill.na.by.0)
            )

            # Apply the generic (non-cartesian) plotly styling: title and export
            # config. Axis/legend/reference-line controls do not apply to a
            # radial sunburst layout and are intentionally omitted.
            fig <- VizModules::apply_title_layout(fig, input, isolate_fn, title_y = 0.95, title_x = 0.5)
            config_list <- add_plot_config(
                download.format = isolate_fn(input$download.format),
                include.modebar.buttons = TRUE, facet.by = NULL
            )
            fig <- do.call(config, c(list(p = fig), config_list))
            fig
        })

        output$goFanPlot <- renderPlotly({
            req(input$term.id, input$fill)
            tryCatch(
                apply_render_margins(generate_goFanPlot(), input),
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
                plot_reactive = generate_goFanPlot,
                inputs_reactive = AllInputs()
            )
        })

        output$download.source <- create_source_download_handler(
            data_list = plot_source_reactive,
            filename_base = "goFanPlot_source"
        )

        return(plot_source_reactive)
    })
}
