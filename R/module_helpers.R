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
#' @param extra_tabs An optional named list of further tabs, placed after the Data tab.
#' @return The organised inputs.
#'
#' @import shiny
#' @author Jared Andrews
#' @rdname INTERNAL_sci_plot_inputs_ui
#' @keywords internal
.sci_plot_inputs_ui <- function(ns, name, data_tab, aes_tab, defaults, title, columns, lines = TRUE,
                                legend = TRUE, extra_tabs = NULL) {
    inputs <- c(list("Data" = data_tab), extra_tabs, list(
        "Aesthetics" = aes_tab,
        "Legend" = if (isTRUE(legend)) uniform_legend_inputs_ui(ns, defaults),
        "Axes" = uniform_axes_inputs_ui(ns, defaults),
        "Lines" = if (isTRUE(lines)) uniform_lines_inputs_ui(ns, defaults),
        "Plotly" = uniform_plotly_inputs_ui(ns, defaults)
    ))
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


#' Render a native module's figure
#'
#' The `renderPlotly()` of every module that builds its own figure. It shows why
#' a plot cannot be drawn (no metadata, an empty range) rather than leaving it
#' blank, while `req()`'s silent pause stays a pause, and finishes with
#' [VizModules::finalize_manual_edits()], which is what updates the plot in place
#' and sends only the layout when its traces have not changed. That call cancels
#' the render on such an update, so it has to stay last and outside the
#' `tryCatch()`.
#'
#' @param generate The module's styled figure reactive.
#' @param input,session The module's input and session.
#' @param plot_source,edit_store The event source and the store from
#'   [VizModules::setup_manual_edits()].
#' @param guard Optional function run first, for the render's own `req()`s. Inside
#'   the `tryCatch()`, so an error in it (a malformed `data`) shows as a message.
#' @return A `renderPlotly()` output.
#'
#' @import shiny
#' @import plotly
#' @author Jared Andrews
#' @rdname INTERNAL_sci_render_plotly
#' @keywords internal
.sci_render_plotly <- function(generate, input, plot_source, edit_store, session, guard = NULL) {
    titles <- new.env(parent = emptyenv())
    renderPlotly(.sci_rendered_figure(generate, input, plot_source, edit_store, session, guard, titles))
}


#' The body of a native module's render
#'
#' Apart from [.sci_render_plotly()] so it can be tested: a plotly output cannot
#' be driven from [shiny::testServer()].
#'
#' @inheritParams .sci_render_plotly
#' @param titles The environment [.sci_clear_stale_titles()] keeps its titles in.
#' @return The figure to send. On a layout-only update the render is cancelled
#'   instead.
#'
#' @import shiny
#' @author Jared Andrews
#' @rdname INTERNAL_sci_rendered_figure
#' @keywords internal
.sci_rendered_figure <- function(generate, input, plot_source, edit_store, session, guard, titles) {
    # One handler, deliberately. tryCatch() nests a second handler around the first,
    # so a `shiny.silent.error = function(e) stop(e)` beside an `error` handler has
    # its re-raise caught there, and a req() pause comes out as a blank plot.
    fig <- tryCatch(
        {
            if (is.function(guard)) guard()
            apply_render_margins(generate(), input)
        },
        error = function(e) {
            if (inherits(e, "shiny.silent.error")) stop(e)
            empty_plot(text = conditionMessage(e), plotly = TRUE)
        }
    )
    .sci_clear_stale_titles(fig, edit_store, titles)
    finalize_manual_edits(fig, plot_source, edit_store, session)
}


#' Forget a typed axis title once the axis it named has changed
#'
#' A captured title's text is restored on every render, but it only makes sense
#' for the variable it was typed for. The VizModules modules drop it when their
#' axis column changes; a native module's axis title can follow any of its
#' inputs, so this compares the title each render draws instead. The figure's
#' text here is the freshly built one, since captured edits are restored after
#' this, in [VizModules::finalize_manual_edits()]. The position stays either way.
#'
#' @param fig The styled figure. Its axis titles are annotations by now.
#' @param store The store from [VizModules::setup_manual_edits()].
#' @param seen An environment holding the titles last drawn.
#' @return `NULL`, invisibly.
#'
#' @author Jared Andrews
#' @rdname INTERNAL_sci_clear_stale_titles
#' @keywords internal
.sci_clear_stale_titles <- function(fig, store, seen) {
    axes <- Filter(function(ann) identical(ann$annotationType, "axis"), fig$x$layout$annotations)
    for (side in c("x", "y")) {
        drawn <- Filter(function(ann) identical(isTRUE(ann$textangle == -90), side == "y"), axes)
        # A figure with no title on this side (the error plot) says nothing about it.
        if (length(drawn) == 0) next
        text <- as.character(drawn[[1]]$text)
        if (!is.null(seen[[side]]) && !identical(seen[[side]], text)) {
            reset_axis_title_text(store, paste0("axis:", side))
        }
        seen[[side]] <- text
    }
    invisible(NULL)
}


#' Shared server for the native plot modules that take a non-data-frame object
#'
#' The PCAtools scree, loadings, pairs and correlation modules and the AlphaFold
#' module differ only in the inputs they read and the plot function they call,
#' so they share this server: reactive
#' defaults, input/tab hiding, the Reset handler for the uniform tabs, the plot
#' reactives, the render, and the source download, whose statistics table is the
#' plotted table attached to the figure.
#'
#' The plot is drawn in two steps: `build` under
#' [VizModules::cached_structure()], then [.sci_finalize_plotly()] on the cached
#' figure, so a styling change never redraws it and reaches the browser as a
#' layout-only update. The reactives in `state` are named to the cache
#' automatically.
#'
#' @param id,data,hide.inputs,hide.tabs,defaults As for the module servers.
#' @param name The module name, which is also the plot output's id and the stem
#'   of its tabset id (`<name>TabsetPanel`).
#' @param build `function(obj, input, isolate_fn, state)` returning the figure.
#'   It is cached, so inputs must be read in the literal form
#'   `isolate_fn(input$key)`, any other reactive it reads must be in `state`, and
#'   it must have no side effects.
#' @param reset `function(session, obj, defaults, state)` restoring the module's
#'   own inputs.
#' @param validate A function returning the object, or erroring on one the
#'   module cannot take.
#' @param setup Optional `function(input, output, session, object, params)`
#'   run once in the server body, returning a list (`state`) of reactives or
#'   stores the build and reset functions need.
#' @param style Optional `function(fig, input, isolate_fn, state)` returning the
#'   figure, run on the cached figure before the shared styling. It is not
#'   cached, so what it sets (a `layout.coloraxis`, say) changes without a redraw;
#'   it should write to the layout only, or the change is not a layout-only update.
#' @return The source-data reactive.
#'
#' @import shiny
#' @import plotly
#' @author Jared Andrews
#' @rdname INTERNAL_sci_plot_server
#' @keywords internal
.sci_plot_server <- function(id, data, hide.inputs, hide.tabs, defaults, name, build, reset, validate,
                             setup = NULL, style = NULL) {
    stopifnot(is.reactive(data))

    moduleServer(id, function(input, output, session) {
        params <- setup_reactive_defaults(defaults, input, session)
        plot_source <- session$ns(name)
        edit_store <- setup_manual_edits(input, session, plot_source)

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
            reset_manual_edits(edit_store)
        })

        base_plot <- cached_structure(
            function(isolate_fn) list(fig = build(object(), input, isolate_fn, state)),
            input, session, object, params = params,
            extra = function() lapply(Filter(is.reactive, state), function(value) value())
        )

        generate_plot <- reactive({
            isolate_fn <- setup_auto_update_logic(input, params)
            fig <- base_plot()$fig
            table <- attr(fig, "table")
            if (is.function(style)) fig <- style(fig, input, isolate_fn, state)
            fig <- .sci_finalize_plotly(fig, input, isolate_fn)
            attr(fig, "table") <- table
            fig
        })

        output[[name]] <- .sci_render_plotly(generate_plot, input, plot_source, edit_store, session)

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
#' @param defaults,hide.inputs,hide.tabs Passed to the module; `NULL` ones are
#'   left to the module's own defaults (see [.sci_server_args()]).
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
                            preview_note = "", defaults = NULL, hide.inputs = NULL, hide.tabs = NULL) {
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
            inputs_ui_fn(
                "active_plot", active_object(),
                defaults = defaults, title = h3(paste(input$object_select, "Settings"))
            )
        })

        output$meta_table <- DT::renderDT({
            preview(active_object())
        }, options = list(scrollX = TRUE, pageLength = 5))

        do.call(server_fn, .sci_server_args("active_plot", active_object, defaults, hide.inputs, hide.tabs))
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
