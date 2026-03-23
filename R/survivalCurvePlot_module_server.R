#' Server logic for the survivalCurvePlot module
#'
#' Renders a Kaplan-Meier-style survival curve following the same design
#' pattern as [volcanoPlotServer()]: the module pre-processes the data (builds
#' the step-function representation) and delegates all rendering to
#' [VizModules::linePlot()], which is the same underlying engine used by
#' [VizModules::linePlotServer()].
#'
#' All standard plot-control inputs (axes, grid, fonts, line styles, reference
#' lines, reset, auto-update, download format) come from the
#' [VizModules::linePlotInputsUI()] tabset rendered by
#' [survivalCurvePlotInputsUI()].  The server hides irrelevant linePlot inputs
#' (`group.by`, `errorBar`, `order.by`, etc.) and overrides the colour-picker
#' output so it reflects the auto-detected groups in the survival data.
#'
#' @section Data transformation:
#' Each row \eqn{(t_i, s_i)} is expanded to two rows (using `.survival_to_step()`
#' from `R/plot_mods.R`) so that the line renders as a staircase:
#' \enumerate{
#'   \item \eqn{(t_i,\; s_{i-1} \times 100)} — horizontal segment.
#'   \item \eqn{(t_i,\; s_i \times 100)} — vertical drop.
#' }
#' A separate `add_markers()` trace drawn from the \emph{original} data
#' overlays symbols at the observed (non-interpolated) time points only.
#'
#' @param id The ID for the Shiny module.
#' @param data A `reactive` returning the input data frame.
#' @param hide.inputs A character vector of linePlot input IDs to hide via
#'   shinyjs.  Defaults to `c("group.by", "errorBar", "errorBarColour",
#'   "errorBarWidth", "order.by", "x.adjustment", "y.adjustment")`.
#' @param hide.tabs A character vector of linePlot tab names to hide.
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
#'   [survivalCurvePlotInputsUI()],
#'   [survivalCurvePlotOutputUI()],
#'   [survivalCurvePlotApp()]
survivalCurvePlotServer <- function(
        id, data,
        hide.inputs = c("group.by", "errorBar", "errorBarColour",
                        "errorBarWidth", "order.by",
                        "x.adjustment", "y.adjustment"),
        hide.tabs   = "Facet") {

    stopifnot(is.reactive(data))

    moduleServer(id, function(input, output, session) {
        ns <- session$ns

        # --- Hide irrelevant linePlot inputs / tabs --------------------------
        if (!is.null(hide.inputs)) {
            for (inp in hide.inputs) shinyjs::hide(inp)
        }
        if (!is.null(hide.tabs)) {
            for (tab in hide.tabs) hideTab(inputId = "linePlotTabsetPanel", target = tab)
        }

        # --- Auto-detect group column from raw data --------------------------
        group_col_name <- reactive({
            df <- data()
            if (is.null(df) || ncol(df) == 0) return(NULL)
            non_num <- names(df)[vapply(df, function(x) !is.numeric(x), logical(1))]
            found <- grep("^group$|^strata$|^arm$|^treatment$|^cohort$",
                          non_num, value = TRUE, ignore.case = TRUE)
            if (length(found) > 0) return(found[1])
            if (length(non_num) > 0) non_num[1] else NULL
        })

        # --- Auto-detect n.risk column from raw data -------------------------
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

        # --- Override linePlotInputsUI's palette.selection uiOutput ---------
        # linePlotInputsUI renders uiOutput(ns("palette.selection")) in the
        # Aesthetics tab; we fill it here so colours reflect survival groups.
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

        # --- Helpers: single time/survival column from (possibly multi) input
        get_tc <- reactive({
            tc <- input$x.value
            if (length(tc) > 1) tc[1] else tc
        })
        get_sc <- reactive({
            sc <- input$y.value
            if (length(sc) > 1) sc[1] else sc
        })

        # --- Step-function data transformation --------------------------------
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
            tc_found <- grep("^time$|^days$|^months$|^years$|^t$",
                             names(df), value = TRUE, ignore.case = TRUE)
            sc_found <- grep("surv|survival|^prob$|^estimate$|^s$",
                             names(df)[vapply(df, is.numeric, logical(1))],
                             value = TRUE, ignore.case = TRUE)
            updateSelectInput(session, "x.value",
                selected = if (length(tc_found) > 0) tc_found[1] else names(df)[1])
            updateSelectInput(session, "y.value",
                selected = if (length(sc_found) > 0) sc_found[1] else "")
            updateSelectInput(session, "plot.type",     selected = "lines")
            updateSelectInput(session, "line.type",     selected = "solid")
            shinyWidgets::updateMaterialSwitch(session, "show.markers", value = TRUE)
            updateSelectInput(session, "marker.symbol", selected = "circle")
            VizModules:::.reset_axes_inputs(session)
            VizModules:::.reset_lines_inputs(session)
        })

        # --- Build the interactive survival curve plot -----------------------
        generate_plot <- reactive({
            isolate_fn <- setup_auto_update_logic(input)

            req(step_data(), data())
            sd      <- step_data()
            orig_df <- data()

            tc  <- get_tc()
            sc  <- get_sc()
            gc  <- group_col_name()
            nrc <- nrisk_col_name()

            gc_valid  <- !is.null(gc) && gc %in% names(sd)
            nrc_valid <- !is.null(nrc) && nrc %in% names(orig_df)

            groups <- group_levels()

            line_type  <- isolate_fn(input$line.type)   %||% "solid"
            show_mrkrs <- isTRUE(isolate_fn(input$show.markers))
            marker_sym <- isolate_fn(input$marker.symbol) %||% "circle"
            dl_format  <- isolate_fn(input$download.format) %||% "png"

            # Colors: resolve from the colour picker in Aesthetics tab
            colors_named <- isolate_fn(input$palette.colours)
            palette_vals <- if (!is.null(colors_named) && length(colors_named) > 0) {
                unname(colors_named)
            } else {
                .default_sci_palette
            }

            get_hex <- function(g, i) {
                if (!is.null(colors_named) && as.character(g) %in% names(colors_named)) {
                    colors_named[[as.character(g)]]
                } else {
                    palette_vals[min(i, length(palette_vals))]
                }
            }

            # colour.group.by for linePlot()
            colour_by   <- if (gc_valid) reformulate(gc) else palette_vals[1]
            show_legend <- gc_valid

            # ------------------------------------------------------------------
            # Core: call linePlot() with step-function data.
            # .make_survival_steps() already converted survival to % (0-100),
            # so NO further multiplication is applied here.
            # ------------------------------------------------------------------
            fig <- linePlot(
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
                axis.tickfont.size   = isolate_fn(input$axis.tickfont.size),
                axis.tickfont.color  = isolate_fn(input$axis.tickfont.color),
                axis.tickfont.family = isolate_fn(input$axis.tickfont.family),
                axis.tickangle.x  = isolate_fn(input$axis.tickangle.x),
                axis.tickangle.y  = isolate_fn(input$axis.tickangle.y),
                axis.ticks        = isolate_fn(input$axis.ticks),
                axis.tickcolor    = isolate_fn(input$axis.tickcolor),
                axis.ticklen      = isolate_fn(input$axis.ticklen),
                axis.tickwidth    = isolate_fn(input$axis.tickwidth),
                show.grid.x       = isolate_fn(input$show.grid.x),
                show.grid.y       = isolate_fn(input$show.grid.y),
                title.font.family = isolate_fn(input$title.font.family) %||% "Arial",
                title.text.color  = isolate_fn(input$text.colour) %||% "#000000",
                x.title           = tc,
                y.title           = "Survival (%)"
            )

            # --- Markers at ORIGINAL data points only -------------------------
            # orig_df has survival on 0-1 scale; multiply by 100 for % axis.
            if (show_mrkrs) {
                for (i in seq_along(groups)) {
                    g         <- groups[i]
                    hex       <- get_hex(g, i)
                    orig_grp  <- if (gc_valid) orig_df[orig_df[[gc]] == g, , drop = FALSE] else orig_df
                    grp_label <- as.character(g)

                    fig <- fig |> add_markers(
                        data        = orig_grp,
                        x           = orig_grp[[tc]],
                        y           = orig_grp[[sc]] * 100,
                        name        = grp_label,
                        marker      = list(color = hex, symbol = marker_sym, size = 7),
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

            fig <- fig |> layout(
                xaxis       = list(range = x_range),
                yaxis       = list(range = c(0, 105)),
                showlegend  = gc_valid,
                margin      = list(t = 80, l = 90, r = 60,
                                   b = b_margin, autoexpand = TRUE),
                annotations = risk_annotations
            )

            # --- Reference lines from the Lines tab --------------------------
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
                generate_plot() |>
                    layout(margin = list(autoexpand = TRUE)),
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
