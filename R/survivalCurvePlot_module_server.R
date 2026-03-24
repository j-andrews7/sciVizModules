#' Server logic for the survivalCurvePlot module
#'
#' Renders a Kaplan-Meier-style survival curve following the same design
#' pattern as [volcanoPlotServer()]: raw KM data is pre-processed into a
#' step-function representation and [VizModules::linePlot()] handles all axis,
#' grid, and font styling.
#'
#' All axis, grid, font, line-style, reference-line, reset, auto-update, and
#' download settings come from the [VizModules::linePlotInputsUI()] tabset.
#' Survival-irrelevant inputs (`group.by`, `errorBar`, `order.by`, `flip.x`,
#' `flip.y`, etc.) and the Facet tab are hidden via shinyjs after the dynamic
#' UI renders.
#'
#' @section Column defaults:
#' Column 1 → time (x), column 2 → survival (y). Both can be overridden via
#' the Data tab selectors. No group column detection is performed; the module
#' always plots a single survival curve.
#'
#' @section Censor markers:
#' When the user selects a censor indicator column via `input$censor.col`,
#' every row where that column is **non-zero numeric** gets a marker plotted
#' on the curve at `(time, survival × 100)`.  This places the symbol at the
#' correct survival level for that time point, not at the raw censor value.
#'
#' @section Risk + censor table:
#' When the data contains an `n.risk`-style column (detected automatically)
#' and/or a censor column is selected, a summary table is drawn below the
#' KM curve using [plotly::subplot()].  Each row shows values at every time
#' point, with row labels on the left.  Because the table lives inside the
#' plotly figure it scales correctly when the user resizes the widget.
#'
#' @param id       The module namespace ID.
#' @param data     A `reactive` returning the KM summary data frame.
#' @param hide.inputs Character vector of linePlot input IDs to hide once the
#'   UI renders. Defaults cover all survival-irrelevant controls.
#' @param hide.tabs   Character vector of linePlot tab names to hide.
#'   Defaults to `"Facet"`.
#' @return The `moduleServer` for the survivalCurvePlot module.
#'
#' @import shiny
#' @import plotly
#' @importFrom shinyjs hide
#' @importFrom htmlwidgets saveWidget
#' @importFrom shinyjqui jqui_resizable
#' @importFrom VizModules linePlot
#'
#' @export
#' @author Jacob Martin, Jared Andrews
#' @seealso [VizModules::linePlot()], [VizModules::linePlotInputsUI()],
#'   [survivalCurvePlotInputsUI()], [survivalCurvePlotOutputUI()],
#'   [survivalCurvePlotApp()]
survivalCurvePlotServer <- function(
        id,
        data,
        hide.inputs = c("group.by", "errorBar", "errorBarColour",
                        "errorBarWidth", "order.by",
                        "x.adjustment", "y.adjustment",
                        "flip.x", "flip.y"),
        hide.tabs = "Facet") {

    stopifnot(is.reactive(data))

    moduleServer(id, function(input, output, session) {

        # ── Namespace helper (used when creating new UI output IDs) ───────────
        ns <- session$ns


        # ── STEP 1: Hide survival-irrelevant inputs and tabs ─────────────────
        # linePlotInputsUI is rendered dynamically via renderUI in the app, so
        # its DOM elements don't exist when the module server first starts.
        # We wait for `input$x.value` — the first input created by the Data tab
        # — before calling hide().  `once = TRUE` ensures this fires exactly once.
        observeEvent(input$x.value, {
            if (!is.null(hide.inputs)) {
                for (input_id in hide.inputs) shinyjs::hide(input_id)
            }
            if (!is.null(hide.tabs)) {
                for (tab_name in hide.tabs) {
                    hideTab(inputId = "linePlotTabsetPanel", target = tab_name)
                }
            }
        }, once = TRUE, ignoreNULL = TRUE)


        # ── STEP 2: Populate the palette colour picker ────────────────────────
        # linePlotInputsUI renders `uiOutput(ns("palette.selection"))` in the
        # Aesthetics tab as an empty placeholder for the parent module to fill.
        # We render a single-colour picker here (one colour = one survival curve).
        # This follows the same pattern used in volcanoPlotServer.
        output$palette.selection <- renderUI({
            # Preserve any colour the user has already chosen (isolate prevents
            # re-triggering this renderUI every time inputs change).
            initial_colour <- isolate(
                resolve_palette("Survival", input$palette.colours,
                                .default_sci_palette)
            )
            multiColorPicker(
                ns("palette.colours"),
                label           = "Curve Color",
                groups          = "Survival",
                palette_options = default_palettes()[["choices"]],
                colors          = initial_colour,
                compact         = TRUE
            )
        })


        # ── STEP 3: Column name helpers ───────────────────────────────────────
        # The linePlotInputsUI selectors can technically return multiple values;
        # these helpers extract a single column name from each to avoid errors.

        # The name of the time (x-axis) column chosen by the user.
        time_col <- reactive({
            col <- input$x.value
            if (length(col) > 1) col[1] else col
        })

        # The name of the survival probability (y-axis) column chosen by the user.
        surv_col <- reactive({
            col <- input$y.value
            if (length(col) > 1) col[1] else col
        })


        # ── STEP 4: Build the step-function version of the data ───────────────
        # A standard KM table stores one row per event time point.  To draw the
        # characteristic "staircase" shape, each row must be expanded to two
        # rows: one for the horizontal segment (survival stays flat) and one for
        # the vertical drop (survival falls).  The helper lives in plot_mods.R.
        step_function_data <- reactive({
            req(data())

            t_col <- time_col()
            s_col <- surv_col()

            # Require valid, non-empty column names that exist in the data frame.
            req(!is.null(t_col), !is.null(s_col), nzchar(t_col), nzchar(s_col))

            raw_data <- data()
            req(t_col %in% names(raw_data), s_col %in% names(raw_data))

            # No group column — a single survival curve only.
            .survival_to_step(raw_data, t_col, s_col, group_col = NULL)
        })


        # ── STEP 5: Reset all inputs to sensible defaults ─────────────────────
        # Called when the user clicks the Reset button inside module_tack_ui.
        # We reset both the survival-specific selectors (defined in this module)
        # and the shared axis/lines inputs (reset helpers from VizModules).
        observeEvent(input$reset, {
            raw_data <- data()
            if (is.null(raw_data)) return()

            all_column_names <- names(raw_data)

            # Restore Data-tab selectors to column-position defaults.
            updateSelectInput(session, "x.value",
                selected = all_column_names[1])
            updateSelectInput(session, "y.value",
                selected = if (length(all_column_names) >= 2) {
                    all_column_names[2]
                } else {
                    all_column_names[1]
                })

            # Restore survival-specific extras.
            updateSelectInput(session, "plot.type",     selected = "lines")
            updateSelectInput(session, "line.type",     selected = "solid")
            updateSelectInput(session, "censor.col",    selected = "")
            updateSelectInput(session, "marker.symbol", selected = "x")

            # Restore all Axes-tab and Lines-tab inputs via VizModules helpers.
            VizModules:::.reset_axes_inputs(session)
            VizModules:::.reset_lines_inputs(session)
        })


        # ── STEP 6: Build the survival curve plotly figure ────────────────────
        # This is the core reactive: it assembles all user settings into a
        # complete plotly figure every time inputs change (or when the user
        # clicks Update in manual mode).
        generate_plot <- reactive({

            # `isolate_fn` is either `identity` (auto-update ON) or
            # `shiny::isolate` (auto-update OFF / manual Update button).
            # Supplied by the VizModules helper `setup_auto_update_logic()`.
            isolate_fn <- setup_auto_update_logic(input)

            # Require that both the step-function data and the raw data are ready.
            req(step_function_data(), data())

            step_df  <- step_function_data()   # expanded staircase rows
            raw_data <- data()                  # original KM table rows

            t_col    <- time_col()
            s_col    <- surv_col()

            # ── Collect user settings from the linePlot tabset ────────────────

            line_style       <- isolate_fn(input$line.type)      %||% "solid"
            censor_indicator <- isolate_fn(input$censor.col)      # column name or ""
            censor_symbol    <- isolate_fn(input$marker.symbol)   %||% "x"
            download_format  <- isolate_fn(input$download.format) %||% "png"

            # Resolve curve colour from the colour picker.
            # `palette.colours` is a named vector of hex values keyed by group.
            named_colours <- isolate_fn(input$palette.colours)
            colour_vector <- if (!is.null(named_colours) && length(named_colours) > 0) {
                unname(named_colours)
            } else {
                .default_sci_palette
            }
            curve_colour <- colour_vector[1]   # single curve → first palette colour


            # ── Draw the KM step-function line via linePlot() ─────────────────
            # `colour.group.by = NULL` tells linePlot to use a single colour
            # (the first entry in `palette.selection`) for the whole trace.
            # All axis / grid / font arguments come directly from the shared
            # linePlotInputsUI inputs, keeping the styling in sync with the rest
            # of the VizModules ecosystem.
            km_figure <- linePlot(
                data              = step_df,
                x                 = t_col,
                y                 = s_col,
                plot.mode         = "lines",
                line.type         = line_style,
                colour.group.by   = NULL,
                palette.selection = colour_vector,
                show.legend       = FALSE,
                axis.showline     = isolate_fn(input$axis.showline),
                axis.mirror       = isolate_fn(input$axis.mirror),
                axis.linecolor    = isolate_fn(input$axis.linecolor),
                axis.linewidth    = isolate_fn(input$axis.linewidth),
                axis.tickfont.size    = isolate_fn(input$axis.tickfont.size),
                axis.tickfont.color   = isolate_fn(input$axis.tickfont.color),
                axis.tickfont.family  = isolate_fn(input$axis.tickfont.family),
                axis.tickangle.x  = isolate_fn(input$axis.tickangle.x),
                axis.tickangle.y  = isolate_fn(input$axis.tickangle.y),
                axis.ticks        = isolate_fn(input$axis.ticks),
                axis.tickcolor    = isolate_fn(input$axis.tickcolor),
                axis.ticklen      = isolate_fn(input$axis.ticklen),
                axis.tickwidth    = isolate_fn(input$axis.tickwidth),
                show.grid.x       = isolate_fn(input$show.grid.x),
                show.grid.y       = isolate_fn(input$show.grid.y),
                title.font.family = isolate_fn(input$title.font.family) %||% "Arial",
                title.text.color  = isolate_fn(input$text.colour)        %||% "#000000",
                x.title           = t_col,
                y.title           = "Survival (%)"
            )


            # ── Overlay censor event markers on the KM line ───────────────────
            # When the user chooses a censor indicator column, every row where
            # that column is non-zero is treated as a censoring event.  We plot
            # a symbol at the SURVIVAL value for that time point (not at the raw
            # censor indicator value) — the symbol sits on the step-function
            # line exactly where the patient was censored.
            # Only numeric censor columns are accepted to avoid type errors.
            censor_col_valid <- !is.null(censor_indicator) &&
                                 nzchar(censor_indicator) &&
                                 censor_indicator %in% names(raw_data) &&
                                 is.numeric(raw_data[[censor_indicator]])

            if (censor_col_valid) {
                # Keep only rows flagged as censored (non-zero indicator).
                censored_rows <- raw_data[
                    !is.na(raw_data[[censor_indicator]]) &
                    raw_data[[censor_indicator]] != 0,
                    , drop = FALSE
                ]

                if (nrow(censored_rows) > 0) {
                    # Place each symbol at (time, survival_at_that_time × 100).
                    # Multiplying by 100 converts the 0–1 KM estimate to the %
                    # scale that linePlot uses for the y-axis.
                    km_figure <- km_figure |> add_markers(
                        data       = censored_rows,
                        x          = censored_rows[[t_col]],
                        y          = censored_rows[[s_col]] * 100,
                        name       = "Censored",
                        marker     = list(color  = curve_colour,
                                          symbol = censor_symbol,
                                          size   = 8),
                        showlegend = FALSE,
                        inherit    = FALSE
                    )
                }
            }


            # ── Compute x-axis display range (with right-side padding) ────────
            # Adding ~8% blank space on the right keeps the curve from running
            # flush to the plot edge; a tiny left offset keeps t=0 from
            # touching the y-axis.
            max_time        <- max(raw_data[[t_col]], na.rm = TRUE)
            min_time        <- min(raw_data[[t_col]], na.rm = TRUE)
            time_range_span <- max_time - min_time
            x_padding       <- time_range_span * 0.08
            x_display_range <- c(min_time - x_padding * 0.2, max_time + x_padding)


            # ── Build the "Number at risk / Censored" summary table ───────────
            # The table lives as a second plotly subplot directly below the KM
            # curve.  Using subplot() means it resizes with the widget — unlike
            # fixed annotation approaches that can clip at small sizes.
            #
            # Table rows shown:
            #   "Number at risk" — n.risk values at each time point (auto-detected)
            #   "Censored"       — censor indicator values (shown only when the
            #                       user has selected a censor column)

            # Auto-detect the n.risk column by matching common naming conventions.
            nrisk_col_name <- {
                found <- grep("n[._]?risk|at[._]?risk",
                              names(raw_data), value = TRUE, ignore.case = TRUE)
                if (length(found) > 0) found[1] else NULL
            }
            has_nrisk  <- !is.null(nrisk_col_name)
            has_censor <- censor_col_valid   # same flag as the marker section

            if (has_nrisk || has_censor) {

                # Unique time points in ascending order (one column per time point).
                time_points <- sort(unique(raw_data[[t_col]]))

                # Count the rows we need in the table.
                n_table_rows <- sum(c(has_nrisk, has_censor))

                # Build an empty figure for the table panel.
                fig_table <- plot_ly()

                # `row_y` tracks the y-position of the current table row
                # (counts down from n_table_rows so the first row is at the top).
                row_y <- n_table_rows

                if (has_nrisk) {
                    # Look up the n.risk value for every time point.
                    nrisk_text <- vapply(time_points, function(t) {
                        val <- raw_data[raw_data[[t_col]] == t,
                                        nrisk_col_name, drop = TRUE]
                        if (length(val) > 0 && !is.na(val[1])) {
                            as.character(val[1])
                        } else {
                            ""
                        }
                    }, character(1))

                    fig_table <- fig_table |> add_trace(
                        type         = "scatter",
                        mode         = "text",
                        x            = time_points,
                        y            = rep(row_y - 0.5, length(time_points)),
                        text         = nrisk_text,
                        textfont     = list(color = curve_colour, size = 10),
                        showlegend   = FALSE,
                        hoverinfo    = "none",
                        textposition = "middle center"
                    )
                    row_y <- row_y - 1
                }

                if (has_censor) {
                    # Show the raw 0/1 indicator value for each time point.
                    censor_text <- vapply(time_points, function(t) {
                        val <- raw_data[raw_data[[t_col]] == t,
                                        censor_indicator, drop = TRUE]
                        if (length(val) > 0 && !is.na(val[1])) {
                            as.character(val[1])
                        } else {
                            ""
                        }
                    }, character(1))

                    fig_table <- fig_table |> add_trace(
                        type         = "scatter",
                        mode         = "text",
                        x            = time_points,
                        y            = rep(row_y - 0.5, length(time_points)),
                        text         = censor_text,
                        textfont     = list(color = curve_colour, size = 10),
                        showlegend   = FALSE,
                        hoverinfo    = "none",
                        textposition = "middle center"
                    )
                }

                # Hide the table subplot's own axes — the KM x-axis is shared.
                fig_table <- fig_table |> layout(
                    xaxis = list(range = x_display_range, visible = FALSE),
                    yaxis = list(range = c(-0.1, n_table_rows + 0.5),
                                 visible = FALSE, fixedrange = TRUE)
                )

                # Proportional heights: give each table row ~8% of total height,
                # capped at 25% so the KM curve always dominates visually.
                row_height_fraction <- 0.08   # fraction of total height per row
                max_table_height    <- 0.25   # upper cap on table panel height
                table_height <- min(max_table_height,
                                    max(row_height_fraction,
                                        row_height_fraction * (n_table_rows + 1)))
                km_height    <- 1 - table_height

                # Combine the KM plot (top) and table (bottom) into one figure.
                km_figure <- subplot(
                    km_figure, fig_table,
                    nrows   = 2,
                    heights = c(km_height, table_height),
                    shareX  = TRUE,
                    titleY  = TRUE,
                    margin  = 0.02
                )

                # Compute left margin wide enough for the longest row label.
                # Each character is approximately 7 pixels wide; add 20 px padding.
                min_left_margin  <- 90    # pixels — matches the no-table fallback
                pixels_per_char  <- 7
                label_padding_px <- 20
                max_label_chars <- max(nchar(c("Number at risk", "Censored")))
                left_margin     <- max(min_left_margin,
                                       ceiling(max_label_chars * pixels_per_char) +
                                       label_padding_px)

                # Build text annotations for each row label.
                # After subplot(), the table subplot axes are labelled "y2".
                table_annotations <- list()
                ann_row_y <- n_table_rows

                if (has_nrisk) {
                    table_annotations <- c(table_annotations, list(list(
                        text      = "<b>Number at risk</b>",
                        xref      = "x",  yref = "y2",
                        x         = x_display_range[1],
                        y         = ann_row_y - 0.5,
                        xanchor   = "right",
                        showarrow = FALSE,
                        font      = list(size = 10, color = "black")
                    )))
                    ann_row_y <- ann_row_y - 1
                }

                if (has_censor) {
                    table_annotations <- c(table_annotations, list(list(
                        text      = "<b>Censored</b>",
                        xref      = "x",  yref = "y2",
                        x         = x_display_range[1],
                        y         = ann_row_y - 0.5,
                        xanchor   = "right",
                        showarrow = FALSE,
                        font      = list(size = 10, color = "black")
                    )))
                }

                # Apply the final layout: shared x-axis title, margins, labels.
                km_figure <- km_figure |> layout(
                    xaxis       = list(range  = x_display_range,
                                       title  = list(text = t_col)),
                    showlegend  = FALSE,
                    margin      = list(t = 80, l = left_margin, r = 60,
                                       b = 30, autoexpand = TRUE),
                    annotations = table_annotations
                )

            } else {
                # No table to show — just apply ranges and titles directly.
                km_figure <- km_figure |> layout(
                    xaxis      = list(range = x_display_range,
                                      title = list(text = t_col)),
                    yaxis      = list(range = c(0, 105)),
                    showlegend = FALSE,
                    margin     = list(t = 80, l = 90, r = 60,
                                      b = 60, autoexpand = TRUE)
                )
            }


            # ── Add reference lines from the Lines tab ────────────────────────
            # The Lines tab inputs (hline.intercepts, vline.intercepts, etc.) are
            # comma-separated text fields parsed by the helper in plot_mods.R.
            km_figure <- .sci_add_reference_lines(
                km_figure,
                hline.intercepts  = isolate_fn(input$hline.intercepts),
                hline.colors      = isolate_fn(input$hline.colors),
                hline.widths      = isolate_fn(input$hline.widths),
                hline.linetypes   = isolate_fn(input$hline.linetypes),
                hline.opacities   = isolate_fn(input$hline.opacities),
                vline.intercepts  = isolate_fn(input$vline.intercepts),
                vline.colors      = isolate_fn(input$vline.colors),
                vline.widths      = isolate_fn(input$vline.widths),
                vline.linetypes   = isolate_fn(input$vline.linetypes),
                vline.opacities   = isolate_fn(input$vline.opacities),
                abline.slopes     = isolate_fn(input$abline.slopes),
                abline.intercepts = isolate_fn(input$abline.intercepts),
                abline.colors     = isolate_fn(input$abline.colors),
                abline.widths     = isolate_fn(input$abline.widths),
                abline.linetypes  = isolate_fn(input$abline.linetypes),
                abline.opacities  = isolate_fn(input$abline.opacities)
            )


            # ── Apply plotly toolbar config ───────────────────────────────────
            # Adds drawing tools and sets the download image format chosen by
            # the user in the module_tack_ui Download Format selector.
            plot_config <- .sci_plot_config(download.format = download_format)
            km_figure   <- do.call(plotly::config, c(list(p = km_figure), plot_config))

            km_figure
        })


        # ── STEP 7: Render the final figure to the output slot ────────────────
        # `output$linePlot` is the slot name that linePlotOutputUI() creates,
        # so the name must stay as-is for the wiring to work.
        output$linePlot <- renderPlotly({
            tryCatch(
                generate_plot(),
                error = function(err) {
                    # Show a clear error message inside the plot area instead of
                    # crashing the app silently.
                    plot_ly() |> layout(
                        annotations = list(list(
                            text      = paste("Error:", conditionMessage(err)),
                            xref      = "paper", yref = "paper",
                            x         = 0.5,     y    = 0.5,
                            showarrow = FALSE,
                            font      = list(size = 14, color = "red")
                        )),
                        xaxis = list(title = ""),
                        yaxis = list(title = "")
                    )
                }
            )
        })


        # ── STEP 8: Wire up the download handler ──────────────────────────────
        # Saves the current plotly figure as a self-contained HTML file.
        output$download.interactive <- .sci_plot_download_handler(
            generate_plot,
            filename_base = "survival_curve"
        )

    })  # end moduleServer
}
