#' Build a standalone Shiny app for a dittoSeq-based module
#'
#' Internal factory that mirrors [VizModules::createModuleApp()] but for modules
#' whose data are `SingleCellExperiment`, `Seurat`, or `SummarizedExperiment`
#' objects rather than data frames. Because those objects cannot be edited in the
#' interactive data-table used by [VizModules::createModuleApp()], this factory
#' instead offers an object selector and a read-only metadata (`colData`) preview.
#'
#' @param inputs_ui_fn A module `*InputsUI(id, data, ...)` function.
#' @param output_ui_fn A module `*OutputUI(id)` function.
#' @param server_fn A module `*Server(id, data, ...)` function.
#' @param object_list A named list of dittoSeq-compatible objects.
#' @param title A character string used as the page title.
#' @param defaults,hide.inputs,hide.tabs Passed to the module; `NULL` ones are
#'   left to the module's own defaults (see [.sci_server_args()]).
#' @return A [shiny::shinyApp()] object.
#'
#' @import shiny
#' @importFrom shinyjs useShinyjs
#' @importFrom DT renderDT DTOutput
#'
#' @author Jacob Martin
#' @rdname INTERNAL_ditto_module_app
#' @keywords internal
.ditto_module_app <- function(inputs_ui_fn, output_ui_fn, server_fn, object_list, title,
                              defaults = NULL, hide.inputs = NULL, hide.tabs = NULL) {
    stopifnot(is.function(inputs_ui_fn), is.function(output_ui_fn), is.function(server_fn))
    stopifnot(is.list(object_list), length(object_list) >= 1)
    if (is.null(names(object_list)) || any(!nzchar(names(object_list)))) {
        stop("`object_list` must be a named list of objects.", call. = FALSE)
    }
    for (obj in object_list) {
        .assert_ditto_object(obj, "object_list element")
    }

    ui <- fluidPage(
        title = title,
        useShinyjs(),
        sidebarLayout(
            sidebarPanel(
                h4("Data"),
                selectInput("object_select", "Select Object:",
                    choices = names(object_list), selectize = FALSE
                ),
                helpText("Plot settings reset when switching objects."),
                hr(),
                uiOutput("plot_inputs_ui")
            ),
            mainPanel(
                output_ui_fn("active_plot"),
                hr(),
                h4("Metadata Preview"),
                p("Read-only preview of the object's cell/sample metadata.",
                    style = "color: grey; font-size: 12px;"
                ),
                DT::DTOutput("meta_table")
            )
        )
    )

    server <- function(input, output, session) {
        rv <- reactiveValues(objects = object_list)

        # The first object until the selector reports, so a server that reads
        # its data when it is constructed (for its Reset defaults) sees one.
        active_object <- reactive({
            rv$objects[[input$object_select %||% names(object_list)[1]]]
        })

        output$plot_inputs_ui <- renderUI({
            obj <- active_object()
            req(obj)
            inputs_ui_fn("active_plot", obj,
                defaults = defaults,
                title = h3(paste(input$object_select, "Settings"))
            )
        })

        output$meta_table <- DT::renderDT({
            obj <- active_object()
            req(obj)
            .ditto_preview(obj)
        }, options = list(scrollX = TRUE, pageLength = 5))

        do.call(server_fn, .sci_server_args("active_plot", active_object, defaults, hide.inputs, hide.tabs))
    }

    shinyApp(ui, server)
}


#' Cell metadata of a dittoSeq object, for a read-only preview
#'
#' @param obj A `SingleCellExperiment`, `Seurat` or `SummarizedExperiment`.
#' @return Its `colData` as a data frame, or a one-row message when it has none
#'   that can be read.
#'
#' @importFrom SummarizedExperiment colData
#'
#' @author Jacob Martin
#' @rdname INTERNAL_ditto_preview
#' @keywords internal
.ditto_preview <- function(obj) {
    md <- tryCatch(
        as.data.frame(SummarizedExperiment::colData(obj)),
        error = function(e) NULL
    )
    if (is.null(md)) {
        md <- data.frame(message = "Metadata preview unavailable for this object type.")
    }
    md
}
