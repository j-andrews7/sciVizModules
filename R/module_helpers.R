#' A tooltip wrapper with the package's usual placement
#'
#' @param tag An input tag.
#' @param text Tooltip text.
#' @return The wrapped tag.
#'
#' @importFrom shinyBS tipify
#' @author Jared Andrews
#' @rdname INTERNAL_sci_tip
#' @keywords internal
.sci_tip <- function(tag, text) {
    tipify(tag, text, placement = "top", options = list(container = "body"))
}


#' Shared input layout for the native plot modules
#'
#' @param ns The module's namespace function.
#' @param name The module name (stem of the tabset id).
#' @param data_tab,aes_tab `tagList`s for the module's Data and Aesthetics tabs.
#' @param defaults Defaults for the uniform tabs.
#' @param title,columns As for the module UIs.
#' @param lines Logical; include the Lines tab.
#' @param legend Logical; include the Legend tab.
#' @return The organised inputs.
#'
#' @import shiny
#' @author Jared Andrews
#' @rdname INTERNAL_sci_plot_inputs_ui
#' @keywords internal
.sci_plot_inputs_ui <- function(ns, name, data_tab, aes_tab, defaults, title, columns, lines = TRUE,
                                legend = TRUE) {
    inputs <- list(
        "Data" = data_tab,
        "Aesthetics" = aes_tab,
        "Legend" = if (isTRUE(legend)) uniform_legend_inputs_ui(ns, defaults),
        "Axes" = uniform_axes_inputs_ui(ns, defaults),
        "Lines" = if (isTRUE(lines)) uniform_lines_inputs_ui(ns, defaults),
        "Plotly" = uniform_plotly_inputs_ui(ns, defaults)
    )
    inputs <- inputs[!vapply(inputs, is.null, logical(1))]

    organize_inputs(
        inputs,
        id = ns(paste0(name, "TabsetPanel")),
        title = if (is.null(title) || inherits(title, c("shiny.tag", "shiny.tag.list"))) title else h3(title),
        tack = module_tack_ui(ns, defaults = defaults),
        columns = columns
    )
}


#' Plot output for a native plot module
#'
#' @param id The module id.
#' @param name The module name (the output id).
#' @param resizable Logical; wrap in [shinyjqui::jqui_resizable()].
#' @param height CSS height of the output.
#' @return The output UI.
#'
#' @importFrom plotly plotlyOutput
#' @importFrom shinyjqui jqui_resizable
#' @author Jared Andrews
#' @rdname INTERNAL_sci_plot_output_ui
#' @keywords internal
.sci_plot_output_ui <- function(id, name, resizable = TRUE, height = "400px") {
    out <- plotlyOutput(NS(id)(name), height = height)
    if (isTRUE(resizable)) out <- jqui_resizable(out)
    out
}


#' Shared server for the native plot modules that take a non-data-frame object
#'
#' The PCAtools scree, loadings, pairs and correlation modules and the AlphaFold
#' module differ only in the inputs they read and the plot function they call,
#' so they share this server: reactive
#' defaults, input/tab hiding, the Reset handler for the uniform tabs, the plot
#' reactive (finished with [.sci_finalize_plotly()]), the render, and the source
#' download, whose statistics table is the plotted table attached to the figure.
#'
#' @param id,data,hide.inputs,hide.tabs,defaults As for the module servers.
#' @param name The module name, which is also the plot output's id and the stem
#'   of its tabset id (`<name>TabsetPanel`).
#' @param build `function(obj, input, isolate_fn, state)` returning the figure.
#'   Inputs must be read in the literal form `isolate_fn(input$key)`.
#' @param reset `function(session, obj, defaults, state)` restoring the module's
#'   own inputs.
#' @param validate A function returning the object, or erroring on one the
#'   module cannot take.
#' @param setup Optional `function(input, output, session, object, params)`
#'   run once in the server body, returning a list (`state`) of reactives or
#'   stores the build and reset functions need.
#' @return The source-data reactive.
#'
#' @import shiny
#' @import plotly
#' @author Jared Andrews
#' @rdname INTERNAL_sci_plot_server
#' @keywords internal
.sci_plot_server <- function(id, data, hide.inputs, hide.tabs, defaults, name, build, reset, validate,
                             setup = NULL) {
    stopifnot(is.reactive(data))

    moduleServer(id, function(input, output, session) {
        params <- setup_reactive_defaults(defaults, input, session)

        hide_input(session, hide.inputs)
        for (tab.name in hide.tabs) hideTab(inputId = paste0(name, "TabsetPanel"), target = tab.name)

        object <- reactive({
            obj <- data()
            req(obj)
            validate(obj)
        })
        state <- if (is.function(setup)) setup(input, output, session, object, params) else list()

        observeEvent(input$reset, {
            reset(session, object(), defaults, state)
            reset_axes_inputs(session, defaults)
            reset_legend_inputs(session, defaults)
            reset_lines_inputs(session, defaults = defaults)
            reset_plotly_inputs(session, defaults)
        })

        generate_plot <- reactive({
            isolate_fn <- setup_auto_update_logic(input, params)
            fig <- build(object(), input, isolate_fn, state)
            table <- attr(fig, "table")
            fig <- .sci_finalize_plotly(fig, input, isolate_fn)
            attr(fig, "table") <- table
            fig
        })

        output[[name]] <- renderPlotly({
            # Show why a plot cannot be drawn (no metadata, an empty range)
            # rather than leaving it blank; req()'s silent pause is re-raised.
            tryCatch(
                apply_render_margins(generate_plot(), input),
                shiny.silent.error = function(e) stop(e),
                error = function(e) empty_plot(text = conditionMessage(e), plotly = TRUE)
            )
        })

        AllInputs <- reactive({
            reactiveValuesToList(input)
        })

        plot_source_reactive <- reactive({
            collect_source_data(
                plot_reactive = generate_plot,
                stats_reactive = function() attr(generate_plot(), "table"),
                inputs_reactive = AllInputs()
            )
        })

        output$download.source <- create_source_download_handler(
            data_list = plot_source_reactive,
            filename_base = paste0(name, "_source")
        )

        plot_source_reactive
    })
}


#' Build a standalone Shiny app for a module that takes a non-data-frame object
#'
#' The counterpart of `.ditto_module_app()` for the PCAtools and AlphaFold
#' modules: an object selector over a named list of objects and a read-only
#' preview table, since such objects cannot be edited in a data table.
#'
#' @param inputs_ui_fn,output_ui_fn,server_fn The module's functions.
#' @param object_list A named list of objects.
#' @param title Page title.
#' @param validate A function erroring on an object the module cannot take.
#' @param preview A function returning the data frame to preview for an object.
#' @param select_label,preview_title,preview_note Labels for the selector and
#'   the preview.
#' @return A [shiny::shinyApp()] object.
#'
#' @import shiny
#' @importFrom shinyjs useShinyjs
#' @importFrom DT renderDT DTOutput
#'
#' @author Jared Andrews
#' @rdname INTERNAL_sci_object_app
#' @keywords internal
.sci_object_app <- function(inputs_ui_fn, output_ui_fn, server_fn, object_list, title, validate,
                            preview, select_label = "Select Object:", preview_title = "Preview",
                            preview_note = "") {
    stopifnot(is.list(object_list), length(object_list) >= 1)
    if (is.null(names(object_list)) || any(!nzchar(names(object_list)))) {
        stop("The object list must be named.", call. = FALSE)
    }
    for (obj in object_list) validate(obj)

    ui <- fluidPage(
        title = title,
        useShinyjs(),
        sidebarLayout(
            sidebarPanel(
                h4("Data"),
                selectInput("object_select", select_label, choices = names(object_list), selectize = FALSE),
                helpText("Plot settings reset when switching objects."),
                hr(),
                uiOutput("plot_inputs_ui")
            ),
            mainPanel(
                output_ui_fn("active_plot"),
                hr(),
                h4(preview_title),
                p(preview_note, style = "color: grey; font-size: 12px;"),
                DT::DTOutput("meta_table")
            )
        )
    )

    server <- function(input, output, session) {
        # The first object until the selector reports, so a server that reads
        # its data when it is constructed (for its Reset defaults) sees one.
        active_object <- reactive({
            object_list[[input$object_select %||% names(object_list)[1]]]
        })

        output$plot_inputs_ui <- renderUI({
            inputs_ui_fn("active_plot", active_object(), title = h3(paste(input$object_select, "Settings")))
        })

        output$meta_table <- DT::renderDT({
            preview(active_object())
        }, options = list(scrollX = TRUE, pageLength = 5))

        server_fn("active_plot", data = active_object)
    }

    shinyApp(ui, server)
}


#' Require a data frame for a native module
#'
#' The `validate` function the data-frame modules built on [.sci_plot_server()]
#' pass to it.
#'
#' @param x The module's data.
#' @param arg Argument name for the error message.
#' @return `x` as a data frame.
#'
#' @author Jared Andrews
#' @rdname INTERNAL_sci_require_df
#' @keywords internal
.sci_require_df <- function(x, arg = "data") {
    if (!is.data.frame(x)) {
        x <- tryCatch(as.data.frame(x), error = function(e) NULL)
        if (is.null(x)) stop("'", arg, "' must be a data frame.", call. = FALSE)
    }
    x
}


#' Render a group colour picker backed by a server-side store
#'
#' The `renderUI()` the native modules use for their group colours: the picker
#' is built from the same [resolve_palette()] result it seeds the store with, so
#' its first report back is a no-op rather than a redraw (see
#' [setup_group_colors()]).
#'
#' @param input,session The module's input and session.
#' @param groups A reactive returning the group levels.
#' @param store The store from [setup_group_colors()].
#' @param default_palette_values Fallback colours.
#' @param defaults The module defaults (for a caller-supplied mapping).
#' @param label Picker label.
#' @param key The picker's input id.
#' @return A `renderUI()` output.
#'
#' @import shiny
#' @author Jared Andrews
#' @rdname INTERNAL_sci_palette_picker_ui
#' @keywords internal
.sci_palette_picker_ui <- function(input, session, groups, store, default_palette_values, defaults,
                                   label = "Group Colors", key = "palette.colours") {
    renderUI({
        lv <- groups()
        if (length(lv) == 0) {
            return(NULL)
        }
        initial_colors <- isolate(resolve_palette(
            lv, input[[key]], default_palette_values, default_group_colors(defaults, key)
        ))
        store(initial_colors)
        multiColorPicker(
            session$ns(key),
            label = label,
            groups = lv,
            palette_options = default_palettes()[["choices"]],
            selected_palette = "dittoColors",
            colors = initial_colors,
            compact = TRUE
        )
    })
}
