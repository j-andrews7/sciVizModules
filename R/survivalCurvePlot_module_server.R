#' Server logic for the survivalCurvePlot module
#'
#' Renders a Kaplan-Meier–style survival curve as an interactive plotly step
#' function together with an optional confidence-interval ribbon and a
#' **Survival Summary Table** showing per-group numbers at risk.
#'
#' The server follows the same modular pattern as [volcanoPlotServer()]:
#' it first transforms the input data into a step-function representation
#' (duplicating each time point to create horizontal-then-vertical steps) and
#' then hands the result to [VizModules::linePlot()] for rendering.  CI ribbons
#' are added as an extra plotly layer on top of the linePlot output.
#'
#' @section Data transformation:
#' Each row \eqn{(t_i, s_i)} in the input data is expanded into two rows:
#' \enumerate{
#'   \item \eqn{(t_i,\; s_{i-1})} – horizontal segment at the previous survival level.
#'   \item \eqn{(t_i,\; s_i)}     – vertical drop to the new survival level.
#' }
#' The first time point is kept as-is.  Survival values are multiplied by 100
#' so that the y-axis shows percentages.
#'
#' @param id The ID for the Shiny module.
#' @param data A `reactive` containing the input data frame.
#'   Must include at minimum a time column and a survival probability column
#'   (0–1 scale).
#' @param hide.inputs A character vector of input IDs to hide via shinyjs.
#' @param hide.tabs A character vector of tab names to hide from the tabset panel.
#' @return The `moduleServer` for the survivalCurvePlot module.
#'
#' @import shiny
#' @import plotly
#' @importFrom shinyjs hide
#' @importFrom DT renderDT datatable
#' @importFrom htmlwidgets saveWidget
#' @importFrom htmltools tags
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
            for (tab in hide.tabs) {
                hideTab(inputId = "survivalPlotTabsetPanel", target = tab)
            }
        }

        # --- Determine groups present in data --------------------------------
        group_levels <- reactive({
            df <- data()
            if (is.null(df)) return("Survival")
            gc <- input$group.col
            if (!is.null(gc) && nzchar(gc) && gc %in% names(df)) {
                as.character(unique(df[[gc]]))
            } else {
                "Survival"
            }
        })

        # --- Dynamic per-group colour picker ---------------------------------
        output$palette.selection <- renderUI({
            groups <- group_levels()
            # Fallback palette: colourblind-friendly defaults drawn from dittoColors
            default_hex <- c(
                "#E69F00", "#56B4E9", "#009E73", "#F0E442",
                "#0072B2", "#D55E00", "#CC79A7", "#000000"
            )
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

        # --- Step-function data transformation -------------------------------
        step_data <- reactive({
            req(data(), input$time.col, input$surv.col)
            df <- data()
            req(input$time.col %in% names(df), input$surv.col %in% names(df))

            gc  <- if (!is.null(input$group.col) && nzchar(input$group.col) &&
                       input$group.col %in% names(df)) input$group.col else NULL
            lc  <- if (isTRUE(input$show.ci) && !is.null(input$lower.col) &&
                       nzchar(input$lower.col) && input$lower.col %in% names(df)) input$lower.col else NULL
            uc  <- if (isTRUE(input$show.ci) && !is.null(input$upper.col) &&
                       nzchar(input$upper.col) && input$upper.col %in% names(df)) input$upper.col else NULL

            .survival_to_step(df, input$time.col, input$surv.col, gc, lc, uc)
        })

        # --- Build the interactive plot --------------------------------------
        generate_plot <- reactive({
            req(step_data())
            sd <- step_data()

            tc   <- input$time.col
            sc   <- input$surv.col
            gc   <- if (!is.null(input$group.col) && nzchar(input$group.col) &&
                        input$group.col %in% names(sd)) input$group.col else NULL
            lc   <- if (isTRUE(input$show.ci) && !is.null(input$lower.col) &&
                        nzchar(input$lower.col) && input$lower.col %in% names(sd)) input$lower.col else NULL
            uc   <- if (isTRUE(input$show.ci) && !is.null(input$upper.col) &&
                        nzchar(input$upper.col) && input$upper.col %in% names(sd)) input$upper.col else NULL

            colors    <- input$survival.colors
            line_type <- if (!is.null(input$line.type) && nzchar(input$line.type)) input$line.type else "solid"
            title_txt <- if (!is.null(input$title.text)) input$title.text else "Survival Curve"

            groups <- group_levels()

            # Build one linePlot trace per group using the step-function data.
            # linePlot() handles the colour palette and legend; CI ribbons are
            # added as extra plotly layers afterwards.
            default_hex <- c(
                "#E69F00", "#56B4E9", "#009E73", "#F0E442",
                "#0072B2", "#D55E00", "#CC79A7", "#000000"
            )
            if (!is.null(gc)) {
                colour_by    <- reformulate(gc)
                palette_vals <- if (!is.null(colors) && length(colors) > 0) unname(colors) else default_hex
                show_legend  <- TRUE
            } else {
                colour_by    <- if (!is.null(colors) && length(colors) > 0) colors[[1]] else default_hex[1]
                palette_vals <- if (!is.null(colors) && length(colors) > 0) unname(colors) else default_hex
                show_legend  <- FALSE
            }

            fig <- linePlot(
                data              = sd,
                x                 = tc,
                y                 = sc,
                plot.mode         = "lines",
                line.type         = line_type,
                colour.group.by   = colour_by,
                palette.selection = palette_vals,
                show.legend       = show_legend,
                title.text        = title_txt,
                x.title           = tc,
                y.title           = "Survival (%)"
            )

            # Add CI ribbons on top if requested --------------------------------
            if (!is.null(lc) && !is.null(uc)) {
                if (!is.null(gc)) {
                    for (i in seq_along(groups)) {
                        g        <- groups[i]
                        grp_data <- sd[sd[[gc]] == g, , drop = FALSE]
                        hex      <- if (!is.null(colors) && as.character(g) %in% names(colors)) {
                            colors[[as.character(g)]]
                        } else {
                            palette_vals[min(i, length(palette_vals))]
                        }
                        rgb_v      <- grDevices::col2rgb(hex)
                        fill_color <- sprintf("rgba(%d,%d,%d,0.2)", rgb_v[1], rgb_v[2], rgb_v[3])
                        fig <- fig |>
                            add_ribbons(
                                data        = grp_data,
                                x           = grp_data[[tc]],
                                ymin        = grp_data[[lc]],
                                ymax        = grp_data[[uc]],
                                line        = list(color = "transparent"),
                                fillcolor   = fill_color,
                                name        = paste0(g, " 95% CI"),
                                showlegend  = FALSE,
                                legendgroup = as.character(g),
                                inherit     = FALSE
                            )
                    }
                } else {
                    hex        <- if (!is.null(colors) && length(colors) > 0) colors[[1]] else default_hex[1]
                    rgb_v      <- grDevices::col2rgb(hex)
                    fill_color <- sprintf("rgba(%d,%d,%d,0.2)", rgb_v[1], rgb_v[2], rgb_v[3])
                    fig <- fig |>
                        add_ribbons(
                            data       = sd,
                            x          = sd[[tc]],
                            ymin       = sd[[lc]],
                            ymax       = sd[[uc]],
                            line       = list(color = "transparent"),
                            fillcolor  = fill_color,
                            name       = "95% CI",
                            showlegend = TRUE,
                            inherit    = FALSE
                        )
                }
            }

            fig <- fig |>
                layout(
                    yaxis  = list(range = c(0, 105)),
                    margin = list(t = 80, l = 80, r = 80, b = 80, autoexpand = TRUE)
                )
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
                            xaxis = list(title = ""), yaxis = list(title = "")
                        )
                }
            )
        })

        # --- Survival Summary Table ------------------------------------------
        output$riskTable <- DT::renderDT({
            req(data(), input$time.col)
            df  <- data()
            tc  <- input$time.col
            gc  <- if (!is.null(input$group.col) && nzchar(input$group.col) &&
                       input$group.col %in% names(df)) input$group.col else NULL
            nrc <- if (!is.null(input$n.risk.col) && nzchar(input$n.risk.col) &&
                       input$n.risk.col %in% names(df)) input$n.risk.col else NULL

            if (!is.null(gc) && !is.null(nrc)) {
                # Wide format: rows = groups, cols = time points
                groups <- unique(df[[gc]])
                times  <- sort(unique(df[[tc]]))

                risk_rows <- lapply(groups, function(g) {
                    grp       <- df[df[[gc]] == g, , drop = FALSE]
                    risk_vals <- vapply(times, function(t) {
                        rows <- grp[grp[[tc]] == t, nrc, drop = TRUE]
                        if (length(rows) > 0) as.character(rows[[1]]) else "-"
                    }, character(1))
                    c(as.character(g), risk_vals)
                })

                risk_df           <- as.data.frame(do.call(rbind, risk_rows),
                                                   stringsAsFactors = FALSE)
                names(risk_df)    <- c("Group", as.character(times))
            } else {
                # Show the raw data columns relevant to survival
                keep_cols <- intersect(
                    names(df),
                    c(tc, "n.risk", "n_risk", "n.event", "n_event",
                      "survival", "surv", "std.err", "lower", "upper",
                      if (!is.null(nrc)) nrc else character(0))
                )
                risk_df <- if (length(keep_cols) > 0) df[, keep_cols, drop = FALSE] else df
            }

            DT::datatable(
                risk_df,
                options  = list(scrollX = TRUE, pageLength = 15, dom = "t"),
                rownames = FALSE,
                caption  = htmltools::tags$caption(
                    style = "caption-side: top; text-align: left; font-weight: bold;",
                    "Survival Summary Table"
                )
            )
        })

        # --- Download handler ------------------------------------------------
        output$download.interactive <- downloadHandler(
            filename = function() paste0("survivalCurve_", Sys.Date(), ".html"),
            content  = function(file) {
                htmlwidgets::saveWidget(generate_plot(), file)
            }
        )
    })
}


# ---- Internal helper: step-function data transformation --------------------

#' Convert survival data to a plotly step-function format
#'
#' @param df       Input data frame.
#' @param time_col Name of the time column.
#' @param surv_col Name of the survival column (0–1 scale; multiplied by 100).
#' @param group_col Optional name of a grouping column.
#' @param lower_col Optional name of the lower CI column (0–1 scale).
#' @param upper_col Optional name of the upper CI column (0–1 scale).
#' @return A data frame with duplicated rows that create a step-function shape
#'   when plotted as a line.
#' @noRd
.survival_to_step <- function(df, time_col, surv_col,
                               group_col = NULL,
                               lower_col = NULL,
                               upper_col = NULL) {
    if (!is.null(group_col) && group_col %in% names(df)) {
        groups      <- unique(df[[group_col]])
        result_list <- lapply(groups, function(g) {
            grp_data <- df[df[[group_col]] == g, , drop = FALSE]
            grp_data <- grp_data[order(grp_data[[time_col]]), ]
            step     <- .make_survival_steps(grp_data, time_col, surv_col,
                                             lower_col, upper_col)
            step[[group_col]] <- g
            step
        })
        do.call(rbind, result_list)
    } else {
        df <- df[order(df[[time_col]]), ]
        .make_survival_steps(df, time_col, surv_col, lower_col, upper_col)
    }
}

#' Build step-function rows for a single group
#'
#' @param df       Data frame for one group, sorted by time.
#' @param time_col Name of the time column.
#' @param surv_col Name of the survival column.
#' @param lower_col Optional lower CI column.
#' @param upper_col Optional upper CI column.
#' @return A data frame with step-function values.
#' @noRd
.make_survival_steps <- function(df, time_col, surv_col,
                                  lower_col = NULL,
                                  upper_col = NULL) {
    n <- nrow(df)
    if (n == 0) {
        keep <- c(time_col, surv_col,
                  if (!is.null(lower_col)) lower_col else character(0),
                  if (!is.null(upper_col)) upper_col else character(0))
        return(df[0, intersect(keep, names(df)), drop = FALSE])
    }

    times     <- df[[time_col]]
    survivals <- df[[surv_col]] * 100  # convert to %
    lowers    <- if (!is.null(lower_col) && lower_col %in% names(df)) df[[lower_col]] * 100 else NULL
    uppers    <- if (!is.null(upper_col) && upper_col %in% names(df)) df[[upper_col]] * 100 else NULL

    # Initialise with the first (leftmost) point
    new_times     <- times[1]
    new_survivals <- survivals[1]
    new_lowers    <- if (!is.null(lowers)) lowers[1] else NULL
    new_uppers    <- if (!is.null(uppers)) uppers[1] else NULL

    if (n > 1) {
        for (i in 2:n) {
            # Horizontal segment: extend previous survival level to current time
            new_times     <- c(new_times,     times[i])
            new_survivals <- c(new_survivals, survivals[i - 1])
            if (!is.null(lowers)) new_lowers <- c(new_lowers, lowers[i - 1])
            if (!is.null(uppers)) new_uppers <- c(new_uppers, uppers[i - 1])

            # Vertical drop: fall to the new survival value at the same time
            new_times     <- c(new_times,     times[i])
            new_survivals <- c(new_survivals, survivals[i])
            if (!is.null(lowers)) new_lowers <- c(new_lowers, lowers[i])
            if (!is.null(uppers)) new_uppers <- c(new_uppers, uppers[i])
        }
    }

    result              <- data.frame(a = new_times, b = new_survivals,
                                      stringsAsFactors = FALSE)
    names(result)       <- c(time_col, surv_col)
    if (!is.null(lowers)) result[[lower_col]] <- new_lowers
    if (!is.null(uppers)) result[[upper_col]] <- new_uppers

    result
}
