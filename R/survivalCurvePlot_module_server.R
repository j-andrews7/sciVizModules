#' Server logic for the survivalCurvePlot module
#'
#' Renders a Kaplan-Meier-style survival curve as an interactive plotly step
#' function.  The server:
#'
#' \enumerate{
#'   \item **Auto-detects** the group and `n.risk` columns from the data using
#'     `grep()` -- no user selectors are needed for these columns.
#'   \item **Transforms** the data into a step-function representation via
#'     `.survival_to_step()` (defined in `R/plot_mods.R`).
#'   \item **Draws** one `add_lines` trace per group plus an optional
#'     `add_markers` trace placed only at the original data points.
#'   \item **Embeds** a "Number at risk" table as plotly annotations below the
#'     x-axis when an `n.risk` column is present.
#'   \item Respects the **Axes** and **Lines** tab inputs from
#'     `VizModules:::.uniform_axes_inputs_ui()` and
#'     `VizModules:::.uniform_lines_inputs_ui()`.
#'   \item Supports **Auto Update / manual Update / Reset** via
#'     [VizModules::module_tack_ui()] and [VizModules::setup_auto_update_logic()].
#' }
#'
#' @section Data transformation:
#' Each row (t_i, s_i) is expanded to two rows so that the line renders
#' as a staircase:
#' \enumerate{
#'   \item (t_i, s_{i-1} * 100) -- horizontal segment.
#'   \item (t_i, s_i * 100) -- vertical drop.
#' }
#' Marker points are drawn from the original (un-expanded) data only.
#'
#' @param id The ID for the Shiny module.
#' @param data A `reactive` returning the input data frame.
#' @param hide.inputs A character vector of input IDs to hide.
#' @param hide.tabs A character vector of tab names to hide.
#' @return The `moduleServer` for the survivalCurvePlot module.
#'
#' @import shiny
#' @import plotly
#' @importFrom shinyjs hide
#' @importFrom htmlwidgets saveWidget
#' @importFrom shinyjqui jqui_resizable
#' @importFrom grDevices col2rgb
#'
#' @export
#' @author Jacob Martin, Jared Andrews
#' @seealso [VizModules::linePlot()], [survivalCurvePlotInputsUI()],
#'   [survivalCurvePlotOutputUI()],
#'   [survivalCurvePlotApp()]
survivalCurvePlotServer <- function(id, data,
                                    hide.inputs = NULL,
                                    hide.tabs   = NULL) {
    stopifnot(is.reactive(data))

    moduleServer(id, function(input, output, session) {
        ns <- session$ns

        # --- Hide specified inputs / tabs ------------------------------------
        if (!is.null(hide.inputs)) {
            for (inp in hide.inputs) shinyjs::hide(inp)
        }
        if (!is.null(hide.tabs)) {
            for (tab in hide.tabs) hideTab(inputId = "survivalPlotTabsetPanel", target = tab)
        }

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

        # --- Auto-detect n.risk column ----------------------------------------
        nrisk_col_name <- reactive({
            df <- data()
            if (is.null(df)) return(NULL)
            found <- grep("n[._]?risk|at[._]?risk",
                          names(df), value = TRUE, ignore.case = TRUE)
            if (length(found) > 0) found[1] else NULL
        })

        # --- Group levels present in data ------------------------------------
        group_levels <- reactive({
            df <- data()
            gc <- group_col_name()
            if (!is.null(gc) && gc %in% names(df)) {
                as.character(unique(df[[gc]]))
            } else {
                "Survival"
            }
        })

        # --- Dynamic colour picker -------------------------------------------
        default_hex <- c(
            "#E69F00", "#56B4E9", "#009E73", "#F0E442",
            "#0072B2", "#D55E00", "#CC79A7", "#000000"
        )

        output$palette.selection <- renderUI({
            groups <- group_levels()
            initial_colors <- isolate(
                resolve_palette(groups, input$survival.colors, default_hex)
            )
            multiColorPicker(
                ns("survival.colors"),
                label           = "Group Colors",
                groups          = groups,
                palette_options = default_palettes()[["choices"]],
                colors          = initial_colors,
                compact         = TRUE
            )
        })

        # --- Reset handler ---------------------------------------------------
        observeEvent(input$reset, {
            df <- data()
            if (is.null(df)) return()
            tc_found <- grep("^time$|^days$|^months$|^years$|^t$",
                             names(df), value = TRUE, ignore.case = TRUE)
            sc_found <- grep("surv|survival|^prob$|^estimate$|^s$",
                             names(df)[vapply(df, is.numeric, logical(1))],
                             value = TRUE, ignore.case = TRUE)
            updateSelectInput(session, "time.col",
                selected = if (length(tc_found) > 0) tc_found[1] else names(df)[1])
            updateSelectInput(session, "surv.col",
                selected = if (length(sc_found) > 0) sc_found[1] else "")
            updateSelectInput(session, "line.type",     selected = "solid")
            updateSelectInput(session, "marker.symbol", selected = "circle")
            shinyWidgets::updateMaterialSwitch(session, "show.markers", value = TRUE)
            VizModules:::.reset_axes_inputs(session)
            VizModules:::.reset_lines_inputs(session)
        })

        # --- Step-function data transformation --------------------------------
        step_data <- reactive({
            req(data(), input$time.col, input$surv.col)
            df <- data()
            req(input$time.col %in% names(df), input$surv.col %in% names(df))
            gc <- group_col_name()
            .survival_to_step(
                df, input$time.col, input$surv.col,
                if (!is.null(gc) && gc %in% names(df)) gc else NULL
            )
        })

        # --- Build the interactive plot --------------------------------------
        generate_plot <- reactive({
            isolate_fn <- setup_auto_update_logic(input)

            req(step_data(), data())
            sd      <- step_data()
            orig_df <- data()

            tc  <- input$time.col
            sc  <- input$surv.col
            gc  <- group_col_name()
            nrc <- nrisk_col_name()

            gc_valid  <- !is.null(gc) && gc %in% names(sd)
            nrc_valid <- !is.null(nrc) && nrc %in% names(orig_df)

            colors     <- isolate_fn(input$survival.colors)
            raw_lt     <- isolate_fn(input$line.type)
            line_type  <- if (!is.null(raw_lt) && nzchar(raw_lt %||% "")) raw_lt else "solid"
            show_mrkrs <- isTRUE(isolate_fn(input$show.markers))
            raw_ms     <- isolate_fn(input$marker.symbol)
            marker_sym <- if (!is.null(raw_ms) && nzchar(raw_ms %||% "")) raw_ms else "circle"
            raw_dlf    <- isolate_fn(input$download.format)
            dl_format  <- if (!is.null(raw_dlf) && nzchar(raw_dlf %||% "")) raw_dlf else "png"

            groups <- group_levels()

            palette_vals <- if (!is.null(colors) && length(colors) > 0) {
                unname(colors)
            } else {
                default_hex
            }

            get_hex <- function(g, i) {
                if (!is.null(colors) && as.character(g) %in% names(colors)) {
                    colors[[as.character(g)]]
                } else {
                    palette_vals[min(i, length(palette_vals))]
                }
            }

            # --- Build traces ------------------------------------------------
            fig <- plot_ly()

            for (i in seq_along(groups)) {
                g   <- groups[i]
                hex <- get_hex(g, i)

                step_grp <- if (gc_valid) sd[sd[[gc]] == g, , drop = FALSE] else sd
                orig_grp <- if (gc_valid) orig_df[orig_df[[gc]] == g, , drop = FALSE] else orig_df

                grp_label <- as.character(g)
                show_leg  <- length(groups) > 1

                fig <- fig |> add_lines(
                    data       = step_grp,
                    x          = step_grp[[tc]],
                    y          = step_grp[[sc]] * 100,
                    name       = grp_label,
                    line       = list(color = hex, dash = line_type),
                    legendgroup = grp_label,
                    showlegend  = show_leg,
                    inherit     = FALSE
                )

                if (show_mrkrs) {
                    fig <- fig |> add_markers(
                        data       = orig_grp,
                        x          = orig_grp[[tc]],
                        y          = orig_grp[[sc]] * 100,
                        name       = grp_label,
                        marker     = list(color = hex, symbol = marker_sym, size = 7),
                        legendgroup = grp_label,
                        showlegend  = FALSE,
                        inherit     = FALSE
                    )
                }
            }

            # --- X-axis padding: ~8% blank space beyond last time point ------
            max_time <- max(orig_df[[tc]], na.rm = TRUE)
            min_time <- min(orig_df[[tc]], na.rm = TRUE)
            x_pad    <- (max_time - min_time) * 0.08
            x_range  <- c(min_time - x_pad * 0.2, max_time + x_pad)

            # --- Axis styling from uniform inputs ----------------------------
            x_style <- .build_axis_style(input, "x", isolate_fn, title = tc)
            y_style <- .build_axis_style(input, "y", isolate_fn, title = "Survival (%)")
            x_style$range <- x_range
            y_style$range <- c(0, 105)

            # --- Number at risk table as plotly annotations below plot -------
            risk_annotations <- list()
            n_groups <- length(groups)

            if (nrc_valid) {
                times    <- sort(unique(orig_df[[tc]]))
                row_h    <- 0.06
                y_header <- -0.14

                risk_annotations[[1]] <- list(
                    text      = "<b>Number at risk</b>",
                    xref      = "paper", yref = "paper",
                    x = 0, y = y_header,
                    xanchor   = "right",
                    showarrow = FALSE,
                    font      = list(size = 11)
                )

                for (i in seq_along(groups)) {
                    g     <- groups[i]
                    hex   <- get_hex(g, i)
                    y_pos <- y_header - i * row_h

                    risk_annotations[[length(risk_annotations) + 1]] <- list(
                        text      = as.character(g),
                        xref      = "paper", yref = "paper",
                        x = 0, y = y_pos,
                        xanchor   = "right",
                        showarrow = FALSE,
                        font      = list(size = 10, color = hex)
                    )

                    grp_data <- if (gc_valid) {
                        orig_df[orig_df[[gc]] == g, , drop = FALSE]
                    } else {
                        orig_df
                    }

                    for (t in times) {
                        row_data <- grp_data[grp_data[[tc]] == t, nrc, drop = TRUE]
                        if (length(row_data) > 0 && !is.na(row_data[1])) {
                            risk_annotations[[length(risk_annotations) + 1]] <- list(
                                text      = as.character(row_data[1]),
                                xref      = "x", yref = "paper",
                                x = t,    y = y_pos,
                                xanchor   = "center",
                                showarrow = FALSE,
                                font      = list(size = 10, color = hex)
                            )
                        }
                    }
                }
            }

            b_margin <- if (nrc_valid) 80 + n_groups * 30 else 80

            raw_tf     <- isolate_fn(input$title.font.family)
            raw_tc     <- isolate_fn(input$text.colour)
            title_font <- list(
                family = if (!is.null(raw_tf)) raw_tf else "Arial",
                color  = if (!is.null(raw_tc)) raw_tc else "#000000"
            )

            fig <- fig |> layout(
                title       = list(text = "", font = title_font),
                xaxis       = x_style,
                yaxis       = y_style,
                showlegend  = length(groups) > 1,
                margin      = list(t = 60, l = 90, r = 60,
                                   b = b_margin, autoexpand = TRUE),
                annotations = risk_annotations
            )

            # --- Reference lines (Lines tab) ---------------------------------
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

            # --- Plotly config (download format, modebar) --------------------
            cfg <- .sci_plot_config(download.format = dl_format)
            fig <- do.call(plotly::config, c(list(p = fig), cfg))

            fig
        })

        # --- Render the plot -------------------------------------------------
        output$survivalPlot <- renderPlotly({
            tryCatch(
                generate_plot(),
                error = function(e) {
                    plot_ly() |>
                        layout(
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

# Null-coalescing operator used internally in this module
`%||%` <- function(x, y) {
    if (!is.null(x) && length(x) > 0 && !is.na(x[1]) &&
        nzchar(as.character(x[1]))) x else y
}
