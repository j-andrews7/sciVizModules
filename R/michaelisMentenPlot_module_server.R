#' Server logic for the michaelisMenten module
#'
#' This module builds a Michaelis-Menten plot with [michaelisMentenPlot()],
#' renders it as an interactive `plotly` figure, and (optionally) annotates the
#' estimated Michaelis constant (K) and maximum velocity (Vmax) onto the plot.
#'
#' The K/Vmax annotations are added here in the server using plotly
#' [plotly::add_annotations()] rather than inside the plotting function, so the
#' annotation logic is kept separate from the ggplot construction.
#'
#' @param id The ID for the Shiny module.
#' @param data A `reactive` returning a list with three elements:
#'   \describe{
#'     \item{`data`}{The plotting data frame (observed points).}
#'     \item{`model`}{A data frame of fitted-line coordinates (`mml`) sharing
#'       the same x/y columns as `data`.}
#'     \item{`stats`}{Optional. A fitted model (e.g. an `nls` fit of
#'       `v ~ Vm * S / (K + S)`) or named coefficients from which K and Vmax are
#'       extracted for annotation. May be `NULL`.}
#'   }
#'   The list may also be unnamed with positions 1 = data, 2 = model,
#'   3 = stats.
#' @param hide.inputs A character vector of input IDs to hide.
#' @param hide.tabs A character vector of tab names to hide.
#' @param defaults A named list of default values used when resetting the
#'   inputs.
#' @return The `moduleServer` function for the michaelisMenten module.
#'
#' @import shiny
#' @import plotly
#' @importFrom shinyjs hide
#' @importFrom shinyWidgets updateMaterialSwitch
#'
#' @seealso [sciVizModules::michaelisMentenPlot()],
#' [sciVizModules::michaelisMentenInputsUI()],
#' [sciVizModules::michaelisMentenOutputUI()], [sciVizModules::michaelisMentenApp()]
#'
#' @export
#' @author Jacob Martin
michaelisMentenServer <- function(id, data, hide.inputs = NULL, hide.tabs = NULL, defaults = NULL) {
    stopifnot(is.reactive(data))
    data_reactive <- data

    moduleServer(id, function(input, output, session) {
        if (!is.null(hide.inputs)) {
            for (input.name in hide.inputs) hide(input.name)
        }
        if (!is.null(hide.tabs)) {
            for (tab.name in hide.tabs) hideTab(inputId = "michaelisMentenTabsetPanel", target = tab.name)
        }

        # Pull the three inputs out of the reactive list (named or positional).
        get_part <- function(bundle, name, pos) {
            if (!is.null(bundle[[name]])) {
                bundle[[name]]
            } else if (length(bundle) >= pos) {
                bundle[[pos]]
            } else {
                NULL
            }
        }
        plot_data <- reactive(get_part(data_reactive(), "data", 1))
        model_data <- reactive(get_part(data_reactive(), "model", 2))
        stats_obj <- reactive(get_part(data_reactive(), "stats", 3))

        observeEvent(input$reset, {
            df <- plot_data()
            req(df)
            col.choices <- names(df)
            num.choices <- names(df)[vapply(df, is.numeric, logical(1))]
            if (length(num.choices) == 0) num.choices <- col.choices

            updateSelectInput(session, "x",
                selected = get_default(defaults, "x", if ("S" %in% col.choices) "S" else num.choices[1]))
            updateSelectInput(session, "y",
                selected = get_default(defaults, "y", if ("v" %in% col.choices) "v" else num.choices[min(2, length(num.choices))]))
            updateMaterialSwitch(session, "jitter", value = get_default(defaults, "jitter", TRUE))
            updateNumericInput(session, "jitter_size", value = get_default(defaults, "jitter_size", 1.5))
            colourpicker::updateColourInput(session, "jitter_color", value = get_default(defaults, "jitter_color", "#000000"))
            updateSliderInput(session, "jitter_alpha", value = get_default(defaults, "jitter_alpha", 1.0))
            colourpicker::updateColourInput(session, "line_color", value = get_default(defaults, "line_color", "#FF0000"))
            updateSelectInput(session, "linetype", selected = get_default(defaults, "linetype", "solid"))
            updateMaterialSwitch(session, "show_stats", value = get_default(defaults, "show_stats", TRUE))
            reset_plotly_inputs(session, defaults)
            reset_axes_inputs(session, defaults)
            reset_lines_inputs(session, defaults = defaults)
        })

        generate_michaelisMentenPlot <- reactive({
            isolate_fn <- setup_auto_update_logic(input)

            df <- plot_data()
            mml <- model_data()
            req(df, mml)

            x <- isolate_fn(input$x)
            y <- isolate_fn(input$y)
            req(x, nzchar(x), y, nzchar(y))
            req(x %in% names(df), y %in% names(df))
            req(x %in% names(mml), y %in% names(mml))

            # Axes tab controls (axis lines/ticks/border) feed the ggplot theme.
            additional_theme <- create_ggplot_axis_style(input, isolate_fn = isolate_fn)
            theme_style <- theme_bw() + theme(
                panel.border = additional_theme$panel.border,
                axis.line = additional_theme$axis.line,
                axis.ticks = additional_theme$axis.ticks,
                strip.background = element_blank()
            )
            gg <- michaelisMentenPlot(
                data = df,
                model = mml,
                x = x,
                y = y,
                theme = theme_style,
                jitter = isTRUE(isolate_fn(input$jitter)),
                jitter_size = isolate_fn(input$jitter_size),
                jitter_color = isolate_fn(input$jitter_color),
                jitter_alpha = isolate_fn(input$jitter_alpha),
                line_color = isolate_fn(input$line_color),
                linetype = isolate_fn(input$linetype)
            )

            fig <- plotly::ggplotly(gg)

            # Annotate K / Vmax from optionl stats directly in plotly.
            if (isTRUE(isolate_fn(input$show_stats))) {
                params <- .mm_params(stats_obj())
                if (!is.null(params) &&
                    (!is.na(params$K) || !is.na(params$Vmax))) {
                    lab <- paste(
                        c(
                            if (!is.na(params$K)) sprintf("K = %.4g", params$K),
                            if (!is.na(params$Vmax)) sprintf("Vmax = %.4g", params$Vmax)
                        ),
                        collapse = "<br>"
                    )
                    fig <- plotly::add_annotations(
                        fig,
                        x = 0.98, y = 0.05, xref = "paper", yref = "paper",
                        text = lab, showarrow = FALSE,
                        align = "right", xanchor = "right", yanchor = "bottom",
                        bgcolor = "rgba(255,255,255,0.7)", bordercolor = "grey"
                    )
                }
            }

            # Apply the uniform title / axis-title styling from the Plotly and
            # Axes tabs (plot title, axis titles, axis tick/line styling).
            fig <- VizModules::apply_title_layout(
                fig, input, isolate_fn,
                title_y = 0.95,
                title_x = isolate_fn(input$axis.title.horizontal.position)
            )
            xaxis_style <- VizModules::create_axis_styles(
                input,
                axis_side = "x", isolate_fn = isolate_fn, ggplot.axis.styling = FALSE
            )
            yaxis_style <- VizModules::create_axis_styles(
                input,
                axis_side = "y", isolate_fn = isolate_fn, ggplot.axis.styling = FALSE
            )
            fig <- VizModules::apply_subplot_axis_styling(fig, xaxis_style, yaxis_style)

            fig <- VizModules::add_reference_lines(fig,
                hline.intercepts = isolate_fn(input$hline.intercepts),
                hline.colors = isolate_fn(input$hline.colors),
                hline.widths = isolate_fn(input$hline.widths),
                hline.linetypes = isolate_fn(input$hline.linetypes),
                hline.opacities = isolate_fn(input$hline.opacities),
                vline.intercepts = isolate_fn(input$vline.intercepts),
                vline.colors = isolate_fn(input$vline.colors),
                vline.widths = isolate_fn(input$vline.widths),
                vline.linetypes = isolate_fn(input$vline.linetypes),
                vline.opacities = isolate_fn(input$vline.opacities),
                abline.slopes = isolate_fn(input$abline.slopes),
                abline.intercepts = isolate_fn(input$abline.intercepts),
                abline.colors = isolate_fn(input$abline.colors),
                abline.widths = isolate_fn(input$abline.widths),
                abline.linetypes = isolate_fn(input$abline.linetypes),
                abline.opacities = isolate_fn(input$abline.opacities)
            )

            config_list <- add_plot_config(
                download.format = isolate_fn(input$download.format),
                include.modebar.buttons = TRUE, facet.by = NULL
            )
            fig <- do.call(config, c(list(p = fig), config_list))
            fig <- axis_titles_as_annotations(fig)
            fig
        })

        output$michaelisMentenPlot <- renderPlotly({
            req(input$x, input$y)
            tryCatch(
                apply_render_margins(generate_michaelisMentenPlot(), input),
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
                plot_reactive = generate_michaelisMentenPlot,
                inputs_reactive = AllInputs()
            )
        })

        output$download.source <- create_source_download_handler(
            data_list = plot_source_reactive,
            filename_base = "michaelisMenten_source"
        )

        return(plot_source_reactive)
    })
}
