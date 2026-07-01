#' Server logic for survivalCurve module
#'
#' This module fits a Kaplan-Meier survival curve with the
#' [survminer](https://cran.r-project.org/package=survminer) package and renders
#' it as an interactive `plotly` figure via [survivalCurve()].
#'
#' @param id The ID for the Shiny module.
#' @param data A `reactive` containing the data frame to plot. Must contain a
#'   numeric follow-up time column and an event/status column.
#' @param hide.inputs A character vector of input IDs to hide. These will still be
#'   initialized and their values passed to the plot function, but the user will
#'   not be able to see/adjust them in the UI.
#' @param hide.tabs A character vector of tab names to hide.
#' @return The `moduleServer` function for the survivalCurve module.
#'
#' @import shiny
#' @import plotly
#' @importFrom shinyjs hide
#' @importFrom shinyWidgets updateMaterialSwitch
#'
#' @seealso [survminer::ggsurvplot()], [sciVizModules::survivalCurve()],
#' [sciVizModules::survivalCurveInputsUI()], [sciVizModules::survivalCurveOutputUI()],
#' [sciVizModules::survivalCurveApp()]
#'
#' @export
#' @author Jared Andrews, Jacob Martin
survivalCurveServer <- function(id, data, hide.inputs = NULL, hide.tabs = NULL) {
    stopifnot(is.reactive(data))
    data_reactive <- data

    moduleServer(id, function(input, output, session) {
        # Hide individual inputs if requested.
        if (!is.null(hide.inputs)) {
            for (input.name in hide.inputs) hide(input.name)
        }

        # Hide whole tabs if requested.
        if (!is.null(hide.tabs)) {
            for (tab.name in hide.tabs) hideTab(inputId = "survivalCurveTabsetPanel", target = tab.name)
        }

        default_palette_values <- default_palettes()[["choices"]][["Defaults"]][["dittoColors"]]

        # The strata that need colors depend on the grouping selection.
        palette_groups <- reactive({
            df <- data_reactive()
            group_col <- input$group.by
            if (is.null(df) || is.null(group_col) || !nzchar(group_col) || !group_col %in% names(df)) {
                return("All")
            }
            grp <- unique(stats::na.omit(as.character(df[[group_col]])))
            if (length(grp) == 0) "All" else grp
        })

        output$palette.selection <- renderUI({
            ns <- session$ns
            groups <- palette_groups()
            initial_colors <- isolate(resolve_palette(groups, input$palette.colours, default_palette_values))
            multiColorPicker(
                ns("palette.colours"),
                label = "Curve Colors",
                groups = groups,
                palette_options = default_palettes()[["choices"]],
                selected_palette = "dittoColors",
                colors = initial_colors,
                compact = TRUE
            )
        })

        # Reset inputs to their defaults (or sensible fallbacks).
        observeEvent(input$reset, {
            df <- data_reactive()
            req(df)
            num.choices <- names(df)[vapply(df, is.numeric, logical(1))]

            updateSelectInput(session, "time", selected = .detect_time_col(df, num.choices))
            updateSelectInput(session, "status", selected = .detect_status_col(df, num.choices))
            updateSelectInput(session, "group.by", selected = "")
            updateMaterialSwitch(session, "conf.int", value = TRUE)
            updateMaterialSwitch(session, "pval", value = TRUE)
            updateMaterialSwitch(session, "risk.table", value = FALSE)
            updateMaterialSwitch(session, "censor", value = TRUE)
            updateSelectInput(session, "surv.median.line", selected = "none")
            updateSelectInput(session, "fun", selected = "survival")
            updateNumericInput(session, "line.size", value = 1)
            updateTextInput(session, "title", value = "")
            updateTextInput(session, "xlab", value = "Time")
            updateTextInput(session, "ylab", value = "Survival probability")
            updateTextInput(session, "legend.title", value = "")
            updateNumericInput(session, "break.time.by", value = NA)
            updateNumericInput(session, "xlim.min", value = NA)
            updateNumericInput(session, "xlim.max", value = NA)
        })

        # Build the plot (shared by the output and the source download).
        generate_survivalCurve <- reactive({
            isolate_fn <- setup_auto_update_logic(input)

            d <- data_reactive()
            req(d)

            time_col <- isolate_fn(input$time)
            status_col <- isolate_fn(input$status)
            req(time_col, status_col)
            req(time_col %in% names(d), status_col %in% names(d))

            group.by <- isolate_fn(input$group.by)
            if (is.null(group.by) || !nzchar(group.by)) group.by <- NULL

            fun_choice <- isolate_fn(input$fun)
            fun <- if (is.null(fun_choice) || fun_choice == "survival") NULL else fun_choice

            groups <- isolate_fn(palette_groups())
            palette_values <- resolve_palette(groups, isolate_fn(input$palette.colours), default_palette_values)

            break.time.by <- isolate_fn(input$break.time.by)
            if (length(break.time.by) != 1 || is.na(break.time.by)) break.time.by <- NULL

            xlim.min <- isolate_fn(input$xlim.min)
            xlim.max <- isolate_fn(input$xlim.max)
            xlim <- NULL
            if (length(xlim.min) == 1 && length(xlim.max) == 1 &&
                !is.na(xlim.min) && !is.na(xlim.max)) {
                xlim <- c(xlim.min, xlim.max)
            }

            legend.title <- isolate_fn(input$legend.title)
            if (is.null(legend.title) || !nzchar(legend.title)) legend.title <- NULL

            title <- isolate_fn(input$title)

            survivalCurve(
                data = d,
                time = time_col,
                status = status_col,
                group.by = group.by,
                conf.int = isolate_fn(input$conf.int),
                pval = isolate_fn(input$pval),
                risk.table = isolate_fn(input$risk.table),
                censor = isolate_fn(input$censor),
                surv.median.line = isolate_fn(input$surv.median.line),
                fun = fun,
                palette.selection = palette_values,
                line.size = isolate_fn(input$line.size),
                xlab = isolate_fn(input$xlab),
                ylab = isolate_fn(input$ylab),
                legend.title = legend.title,
                break.time.by = break.time.by,
                xlim = xlim,
                title = title
            )
        })

        output$survivalCurve <- renderPlotly({
            req(input$time, input$status)
            tryCatch(
                generate_survivalCurve(),
                error = function(e) {
                    empty_plot(text = conditionMessage(e), plotly = TRUE)
                }
            )
        })

        # Capture all UI inputs for the source download.
        AllInputs <- reactive({
            reactiveValuesToList(input)
        })

        plot_source_reactive <- reactive({
            collect_source_data(
                plot_reactive = generate_survivalCurve,
                inputs_reactive = AllInputs()
            )
        })

        output$download.source <- create_source_download_handler(
            data_list = plot_source_reactive,
            filename_base = "survivalCurve_source"
        )

        return(plot_source_reactive)
    })
}
