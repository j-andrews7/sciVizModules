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
#' @section Risk table:
#' When the data contains an `n.risk` column (detected by [grep()]), the
#' server builds a second subplot below the KM curve using
#' [plotly::subplot()].  Each group's at-risk counts are rendered as text
#' scatter traces — so the table is part of the plotly figure and resizes
#' correctly when the user drags the widget handles.
#'
#' @section Column defaults:
#' Column 1 → time (x), column 2 → survival (y).  Both can be overridden via
#' the Data tab selectors.
#'
#' @param id The ID for the Shiny module.
#' @param data A `reactive` returning the input data frame.
#' @param hide.inputs linePlot input IDs to hide (defaults cover all
#'   survival-irrelevant inputs).
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
                        "x.adjustment", "y.adjustment"),
        hide.tabs = "Facet") {

    stopifnot(is.reactive(data))

    moduleServer(id, function(input, output, session) {
        ns <- session$ns

        # --- Hide irrelevant inputs/tabs AFTER dynamic UI renders -----------
        # The UI is created via renderUI in the app, so DOM elements don't
        # exist when the module server initialises.  We wait for x.value
        # (first input the Data tab creates) before calling hide().
        observeEvent(input$x.value, {
            if (!is.null(hide.inputs)) {
                for (inp in hide.inputs) shinyjs::hide(inp)
            }
            if (!is.null(hide.tabs)) {
                for (tab in hide.tabs) {
                    hideTab(inputId = "linePlotTabsetPanel", target = tab)
                }
            }
        }, once = TRUE, ignoreNULL = TRUE)

        # --- Auto-detect group column ----------------------------------------
        group_col_name <- reactive({
            df <- data()
            if (is.null(df) || ncol(df) == 0) return(NULL)
            non_num <- names(df)[vapply(df, function(x) !is.numeric(x), logical(1))]
            found <- grep("^group$|^strata$|^arm$|^treatment$|^cohort$",
                          non_num, value = TRUE, ignore.case = TRUE)
            if (length(found) > 0) return(found[1])
            if (length(non_num) > 0) non_num[1] else NULL
        })

        # --- Auto-detect n.risk column ---------------------------------------
        nrisk_col_name <- reactive({
            df <- data()
            if (is.null(df)) return(NULL)
            found <- grep("n[._]?risk|at[._]?risk",
                          names(df), value = TRUE, ignore.case = TRUE)
            if (length(found) > 0) found[1] else NULL
        })

        # --- Group levels ----------------------------------------------------
        group_levels <- reactive({
            df <- data()
            gc <- group_col_name()
            if (!is.null(gc) && gc %in% names(df)) {
                as.character(unique(df[[gc]]))
            } else {
                "Survival"
            }
        })

        # --- Override linePlotInputsUI's palette.selection uiOutput ----------
        output$palette.selection <- renderUI({
            groups <- group_levels()
            initial_colors <- isolate(
                resolve_palette(groups, input$palette.colours, .default_sci_palette)
            )
            multiColorPicker(
                ns("palette.colours"),
                label           = "Group Colors",
                groups          = groups,
                palette_options = default_palettes()[["choices"]],
                colors          = initial_colors,
                compact         = TRUE
            )
        })

        # --- Single column helpers -------------------------------------------
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
            gc <- group_col_name()
            .survival_to_step(
                df, tc, sc,
                if (!is.null(gc) && gc %in% names(df)) gc else NULL
            )
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
            shinyWidgets::updateMaterialSwitch(session, "show.markers", value = TRUE)
            updateSelectInput(session, "marker.symbol", selected = "circle")
            VizModules:::.reset_axes_inputs(session)
            VizModules:::.reset_lines_inputs(session)
        })

        # --- Build the survival curve plot -----------------------------------
        generate_plot <- reactive({
            isolate_fn <- setup_auto_update_logic(input)

            req(step_data(), data())
            sd      <- step_data()
            orig_df <- data()

            tc  <- get_tc()
            sc  <- get_sc()
            gc  <- group_col_name()
            nrc <- nrisk_col_name()

            gc_valid  <- !is.null(gc)  && gc  %in% names(sd)
            nrc_valid <- !is.null(nrc) && nrc %in% names(orig_df)

            groups   <- group_levels()
            n_groups <- length(groups)

            line_type  <- isolate_fn(input$line.type)    %||% "solid"
            show_mrkrs <- isTRUE(isolate_fn(input$show.markers))
            marker_sym <- isolate_fn(input$marker.symbol) %||% "circle"
            dl_format  <- isolate_fn(input$download.format) %||% "png"

            colors_named <- isolate_fn(input$palette.colours)
            palette_vals <- if (!is.null(colors_named) && length(colors_named) > 0) {
                unname(colors_named)
            } else {
                .default_sci_palette
            }

            get_hex <- function(g, i) {
                if (!is.null(colors_named) &&
                    as.character(g) %in% names(colors_named)) {
                    colors_named[[as.character(g)]]
                } else {
                    palette_vals[min(i, length(palette_vals))]
                }
            }

            colour_by   <- if (gc_valid) reformulate(gc) else palette_vals[1]
            show_legend <- gc_valid

            # --- KM line plot via linePlot() ---------------------------------
            fig_km <- linePlot(
                data              = sd,
                x                 = tc,
                y                 = sc,
                plot.mode         = "lines",
                line.type         = line_type,
                colour.group.by   = colour_by,
                palette.selection = palette_vals,
                show.legend       = show_legend,
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

            # --- Marker overlay at original (non-interpolated) data points ---
            if (show_mrkrs) {
                for (i in seq_along(groups)) {
                    g        <- groups[i]
                    hex      <- get_hex(g, i)
                    orig_grp <- if (gc_valid) {
                        orig_df[orig_df[[gc]] == g, , drop = FALSE]
                    } else {
                        orig_df
                    }
                    fig_km <- fig_km |> add_markers(
                        data        = orig_grp,
                        x           = orig_grp[[tc]],
                        y           = orig_grp[[sc]] * 100,
                        name        = as.character(g),
                        marker      = list(color = hex, symbol = marker_sym, size = 7),
                        legendgroup = as.character(g),
                        showlegend  = FALSE,
                        inherit     = FALSE
                    )
                }
            }

            # --- X-axis padding ----------------------------------------------
            max_time <- max(orig_df[[tc]], na.rm = TRUE)
            min_time <- min(orig_df[[tc]], na.rm = TRUE)
            x_pad    <- (max_time - min_time) * 0.08
            x_range  <- c(min_time - x_pad * 0.2, max_time + x_pad)

            fig_km <- fig_km |> layout(
                xaxis      = list(range = x_range),
                yaxis      = list(range = c(0, 105)),
                showlegend = gc_valid
            )

            # --- Reference lines ---------------------------------------------
            fig_km <- .sci_add_reference_lines(
                fig_km,
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

            # --- Number at risk: subplot approach ----------------------------
            # Using subplot() ensures the table scales correctly when the user
            # resizes the widget — unlike annotation-only approach which can
            # clip content outside fixed pixel margins.
            if (nrc_valid) {
                times <- sort(unique(orig_df[[tc]]))

                # Build risk table as a second subplot with text scatter traces
                fig_risk <- plot_ly()

                for (i in seq_along(groups)) {
                    g      <- groups[i]
                    hex    <- get_hex(g, i)
                    y_pos  <- n_groups - i + 0.5  # top group at highest y

                    grp_data <- if (gc_valid) {
                        orig_df[orig_df[[gc]] == g, , drop = FALSE]
                    } else {
                        orig_df
                    }

                    risk_vals <- vapply(times, function(t) {
                        row <- grp_data[grp_data[[tc]] == t, nrc, drop = TRUE]
                        if (length(row) > 0 && !is.na(row[1])) {
                            as.character(row[1])
                        } else {
                            ""
                        }
                    }, character(1))

                    fig_risk <- fig_risk |> add_trace(
                        type         = "scatter",
                        mode         = "text",
                        x            = times,
                        y            = rep(y_pos, length(times)),
                        text         = risk_vals,
                        textfont     = list(color = hex, size = 10),
                        showlegend   = FALSE,
                        hoverinfo    = "none",
                        textposition = "middle center"
                    )
                }

                fig_risk <- fig_risk |> layout(
                    xaxis = list(range = x_range, visible = FALSE),
                    yaxis = list(range = c(-0.1, n_groups + 0.6),
                                 visible = FALSE, fixedrange = TRUE)
                )

                # Proportional heights: risk table gets ~8% per group row
                risk_h <- min(0.28, max(0.10, 0.08 * (n_groups + 1)))
                km_h   <- 1 - risk_h

                fig <- subplot(
                    fig_km, fig_risk,
                    nrows   = 2,
                    heights = c(km_h, risk_h),
                    shareX  = TRUE,
                    titleY  = TRUE,
                    margin  = 0.02
                )

                # Dynamic left margin so group labels are never clipped
                max_label_chars <- max(nchar(c("Number at risk",
                                               as.character(groups))))
                l_margin <- max(90, ceiling(max_label_chars * 7) + 20)

                # After subplot(), risk subplot's axes are y2.
                # Build annotations: header + group labels (yref = "y2")
                risk_anns <- list(
                    list(
                        text      = "<b>Number at risk</b>",
                        xref      = "x",  yref = "y2",
                        x         = x_range[1],
                        y         = n_groups + 0.5,
                        xanchor   = "left",
                        showarrow = FALSE,
                        font      = list(size = 11, color = "black")
                    )
                )
                for (i in seq_along(groups)) {
                    g     <- groups[i]
                    hex   <- get_hex(g, i)
                    y_pos <- n_groups - i + 0.5
                    risk_anns[[length(risk_anns) + 1]] <- list(
                        text      = as.character(g),
                        xref      = "x",  yref = "y2",
                        x         = x_range[1],
                        y         = y_pos,
                        xanchor   = "right",
                        showarrow = FALSE,
                        font      = list(color = hex, size = 10)
                    )
                }

                fig <- fig |> layout(
                    xaxis       = list(range = x_range, title = tc),
                    showlegend  = gc_valid,
                    margin      = list(t = 80, l = l_margin, r = 60,
                                       b = 30, autoexpand = TRUE),
                    annotations = risk_anns
                )
            } else {
                fig <- fig_km |> layout(
                    margin = list(t = 80, l = 90, r = 60,
                                  b = 60, autoexpand = TRUE)
                )
            }

            # --- Plot config -------------------------------------------------
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
