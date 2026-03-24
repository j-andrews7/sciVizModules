#' Server logic for the survivalCurvePlot module
#'
#' Renders a Kaplan-Meier-style survival curve following the same design
#' pattern as [volcanoPlotServer()]: data is pre-processed (step-function
#' transform) and [VizModules::linePlot()] handles all rendering.
#'
#' All axis, grid, font, line-style, reference-line, reset, auto-update, and
#' download settings come from the [VizModules::linePlotInputsUI()] tabset.
#' Irrelevant inputs (`group.by`, `errorBar`, `order.by`, etc.) and the Facet
#' tab are hidden via shinyjs after the dynamic UI renders.
#'
#' @section Column defaults:
#' Column 1 → time (x), column 2 → survival (y).  Both can be overridden via
#' the Data tab selectors.  No automatic group or n.risk column detection is
#' performed; only the two selected columns are used for the survival curve.
#'
#' @section Censor markers:
#' When a censor column is selected via `input$censor.col`, rows where that
#' column is non-zero are overlaid as marker symbols on the curve at their
#' corresponding `(time, survival)` coordinates.
#'
#' @param id The ID for the Shiny module.
#' @param data A `reactive` returning the input data frame.
#' @param hide.inputs linePlot input IDs to hide after the UI renders.
#' @param hide.tabs linePlot tab names to hide.  Defaults to `"Facet"`.
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
        id, data,
        hide.inputs = c("group.by", "errorBar", "errorBarColour",
                        "errorBarWidth", "order.by",
                        "x.adjustment", "y.adjustment",
                        "flip.x", "flip.y"),
        hide.tabs = "Facet") {

    stopifnot(is.reactive(data))

    moduleServer(id, function(input, output, session) {
        ns <- session$ns

        # --- Hide irrelevant inputs/tabs AFTER dynamic UI renders -----------
        # Wait for x.value (first Data-tab input) to exist before hiding.
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

        # --- Override linePlotInputsUI's palette.selection uiOutput ----------
        # linePlotInputsUI renders `uiOutput(ns("palette.selection"))` in the
        # Aesthetics tab and leaves it empty for the parent module to fill.
        # We fill it here with a single-group colour picker for the KM curve,
        # following the same pattern used in volcanoPlotServer.
        output$palette.selection <- renderUI({
            initial_colors <- isolate(
                resolve_palette("Survival", input$palette.colours,
                                .default_sci_palette)
            )
            multiColorPicker(
                ns("palette.colours"),
                label           = "Curve Color",
                groups          = "Survival",
                palette_options = default_palettes()[["choices"]],
                colors          = initial_colors,
                compact         = TRUE
            )
        })

        # --- Column helpers (single value from potentially-multi select) -----
        get_tc <- reactive({
            tc <- input$x.value
            if (length(tc) > 1) tc[1] else tc
        })
        get_sc <- reactive({
            sc <- input$y.value
            if (length(sc) > 1) sc[1] else sc
        })

        # --- Step-function transform -----------------------------------------
        step_data <- reactive({
            req(data())
            tc <- get_tc()
            sc <- get_sc()
            req(!is.null(tc), !is.null(sc), nzchar(tc), nzchar(sc))
            df <- data()
            req(tc %in% names(df), sc %in% names(df))
            # No group column — single survival curve from col[1] and col[2]
            .survival_to_step(df, tc, sc, NULL)
        })

        # --- Reset handler ---------------------------------------------------
        observeEvent(input$reset, {
            df <- data()
            if (is.null(df)) return()
            col_names <- names(df)
            updateSelectInput(session, "x.value",
                selected = col_names[1])
            updateSelectInput(session, "y.value",
                selected = if (length(col_names) >= 2) col_names[2] else col_names[1])
            updateSelectInput(session, "plot.type",     selected = "lines")
            updateSelectInput(session, "line.type",     selected = "solid")
            updateSelectInput(session, "censor.col",    selected = "")
            updateSelectInput(session, "marker.symbol", selected = "x")
            VizModules:::.reset_axes_inputs(session)
            VizModules:::.reset_lines_inputs(session)
        })

        # --- Build the survival curve plot -----------------------------------
        generate_plot <- reactive({
            isolate_fn <- setup_auto_update_logic(input)

            req(step_data(), data())
            sd      <- step_data()
            orig_df <- data()

            tc <- get_tc()
            sc <- get_sc()

            line_type  <- isolate_fn(input$line.type)    %||% "solid"
            censor_col <- isolate_fn(input$censor.col)
            marker_sym <- isolate_fn(input$marker.symbol) %||% "x"
            dl_format  <- isolate_fn(input$download.format) %||% "png"

            colors_named <- isolate_fn(input$palette.colours)
            palette_vals <- if (!is.null(colors_named) && length(colors_named) > 0) {
                unname(colors_named)
            } else {
                .default_sci_palette
            }
            curve_color <- palette_vals[1]

            # --- KM line plot via linePlot() ---------------------------------
            # `colour.group.by = NULL` forces a single-colour trace using the
            # first entry in palette.selection.  Without this argument linePlot
            # attempts group-based colouring and can error on a plain data frame.
            fig <- linePlot(
                data              = sd,
                x                 = tc,
                y                 = sc,
                plot.mode         = "lines",
                line.type         = line_type,
                colour.group.by   = NULL,
                palette.selection = palette_vals,
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
                x.title           = tc,
                y.title           = "Survival (%)"
            )

            # --- Censor event markers ----------------------------------------
            # Rows where the censor column is non-zero are plotted as markers.
            # The censor column must be numeric (e.g. 0/1 indicator); non-numeric
            # columns are silently skipped.
            censor_valid <- !is.null(censor_col) && nzchar(censor_col) &&
                            censor_col %in% names(orig_df) &&
                            is.numeric(orig_df[[censor_col]])

            if (censor_valid) {
                censor_rows <- orig_df[
                    !is.na(orig_df[[censor_col]]) & orig_df[[censor_col]] != 0,
                    , drop = FALSE
                ]
                if (nrow(censor_rows) > 0) {
                    fig <- fig |> add_markers(
                        data       = censor_rows,
                        x          = censor_rows[[tc]],
                        y          = censor_rows[[sc]] * 100,
                        name       = "Censored",
                        marker     = list(color = curve_color,
                                          symbol = marker_sym, size = 8),
                        showlegend = FALSE,
                        inherit    = FALSE
                    )
                }
            }

            # --- X-axis padding: ~8% blank space beyond last time point ------
            max_time <- max(orig_df[[tc]], na.rm = TRUE)
            min_time <- min(orig_df[[tc]], na.rm = TRUE)
            x_pad    <- (max_time - min_time) * 0.08
            x_range  <- c(min_time - x_pad * 0.2, max_time + x_pad)

            # --- "Number at risk" and "Censored" summary table ---------------
            # Auto-detect the n.risk column by name (grep for common patterns).
            # The censor column is only shown when the user has selected it.
            nrisk_col <- {
                found <- grep("n[._]?risk|at[._]?risk",
                              names(orig_df), value = TRUE, ignore.case = TRUE)
                if (length(found) > 0) found[1] else NULL
            }
            has_nrisk  <- !is.null(nrisk_col)
            has_censor <- censor_valid   # reuse the flag from the markers section

            if (has_nrisk || has_censor) {
                # One table column per unique time point, ascending.
                time_pts    <- sort(unique(orig_df[[tc]]))
                n_rows      <- sum(c(has_nrisk, has_censor))

                fig_tbl <- plot_ly()
                row_y   <- n_rows   # counts down; top row = n_rows - 0.5

                if (has_nrisk) {
                    nrisk_vals <- vapply(time_pts, function(t) {
                        v <- orig_df[orig_df[[tc]] == t, nrisk_col, drop = TRUE]
                        if (length(v) > 0 && !is.na(v[1])) as.character(v[1]) else ""
                    }, character(1))
                    fig_tbl <- fig_tbl |> add_trace(
                        type = "scatter", mode = "text",
                        x = time_pts, y = rep(row_y - 0.5, length(time_pts)),
                        text = nrisk_vals,
                        textfont = list(color = curve_color, size = 10),
                        showlegend = FALSE, hoverinfo = "none",
                        textposition = "middle center"
                    )
                    row_y <- row_y - 1
                }

                if (has_censor) {
                    censor_vals <- vapply(time_pts, function(t) {
                        v <- orig_df[orig_df[[tc]] == t, censor_col, drop = TRUE]
                        if (length(v) > 0 && !is.na(v[1])) as.character(v[1]) else ""
                    }, character(1))
                    fig_tbl <- fig_tbl |> add_trace(
                        type = "scatter", mode = "text",
                        x = time_pts, y = rep(row_y - 0.5, length(time_pts)),
                        text = censor_vals,
                        textfont = list(color = curve_color, size = 10),
                        showlegend = FALSE, hoverinfo = "none",
                        textposition = "middle center"
                    )
                }

                fig_tbl <- fig_tbl |> layout(
                    xaxis = list(range = x_range, visible = FALSE),
                    yaxis = list(range = c(-0.1, n_rows + 0.5),
                                 visible = FALSE, fixedrange = TRUE)
                )

                # Table height: ~8% per row, max 25% of total widget height.
                tbl_h <- min(0.25, max(0.08, 0.08 * (n_rows + 1)))
                km_h  <- 1 - tbl_h

                fig <- subplot(
                    fig, fig_tbl,
                    nrows  = 2, heights = c(km_h, tbl_h),
                    shareX = TRUE, titleY = TRUE, margin = 0.02
                )

                # Left margin wide enough for the longest row label.
                max_label <- max(nchar(c("Number at risk", "Censored")))
                l_margin  <- max(90, ceiling(max_label * 7) + 20)

                # Row label annotations (after subplot(), table axes = y2).
                ann_row_y   <- n_rows
                table_anns  <- list()
                if (has_nrisk) {
                    table_anns <- c(table_anns, list(list(
                        text = "<b>Number at risk</b>",
                        xref = "x", yref = "y2",
                        x = x_range[1], y = ann_row_y - 0.5,
                        xanchor = "right", showarrow = FALSE,
                        font = list(size = 10, color = "black")
                    )))
                    ann_row_y <- ann_row_y - 1
                }
                if (has_censor) {
                    table_anns <- c(table_anns, list(list(
                        text = "<b>Censored</b>",
                        xref = "x", yref = "y2",
                        x = x_range[1], y = ann_row_y - 0.5,
                        xanchor = "right", showarrow = FALSE,
                        font = list(size = 10, color = "black")
                    )))
                }

                # Apply final layout: shared x-axis title, margins, labels.
                fig <- fig |> layout(
                    xaxis       = list(range = x_range,
                                       title = list(text = tc)),
                    showlegend  = FALSE,
                    margin      = list(t = 80, l = l_margin, r = 60,
                                       b = 30, autoexpand = TRUE),
                    annotations = table_anns
                )

            } else {
                # No table — just set axis ranges and x-axis title directly.
                # Explicitly re-setting x-axis title here is important because a
                # subsequent layout() call can overwrite what linePlot() set.
                fig <- fig |> layout(
                    xaxis      = list(range = x_range,
                                      title = list(text = tc)),
                    yaxis      = list(range = c(0, 105)),
                    showlegend = FALSE,
                    margin     = list(t = 80, l = 90, r = 60,
                                      b = 60, autoexpand = TRUE)
                )
            }

            # --- Reference lines from Lines tab ------------------------------
            fig <- .sci_add_reference_lines(
                fig,
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

            # --- Plot config (modebar, download format) ----------------------
            cfg <- .sci_plot_config(download.format = dl_format)
            fig <- do.call(plotly::config, c(list(p = fig), cfg))

            fig
        })

        # --- Render to output$linePlot (matches linePlotOutputUI) ------------
        output$linePlot <- renderPlotly({
            tryCatch(
                generate_plot(),
                error = function(e) {
                    plot_ly() |> layout(
                        annotations = list(list(
                            text      = paste("Error:", conditionMessage(e)),
                            xref      = "paper", yref = "paper",
                            x = 0.5, y = 0.5, showarrow = FALSE,
                            font      = list(size = 14, color = "red")
                        )),
                        xaxis = list(title = ""),
                        yaxis = list(title = "")
                    )
                }
            )
        })

        # --- Download handler ------------------------------------------------
        output$download.interactive <- .sci_plot_download_handler(
            generate_plot,
            filename_base = "survival_curve"
        )
    })
}
