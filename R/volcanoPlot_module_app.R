#' Create a standalone Shiny app for the volcanoPlot module
#'
#' This function generates a Shiny application with modular volcano plot components.
#' The app features a **Data Import** section for uploading Excel spreadsheets,
#' a **Data Table** for viewing and editing the active dataset, and a **Plot** area
#' for configuring and displaying an interactive volcano plot.
#'
#' When `data_list` is not provided (or `NULL`), the app launches with
#' `airway_deseq2` as an example dataset, on the settings the module gallery
#' ([sciModuleGalleryApp()]) opens this module on: thresholds of FDR 0.05 and a
#' two-fold change, with some well-known dexamethasone-responsive genes
#' labelled. Uploaded Excel files are added to the available datasets and can
#' be selected for plotting. If an uploaded file shares a name with an existing
#' dataset, the existing one is overwritten with a warning.
#'
#' @param data_list An optional named list of data frames. If `NULL` (the default),
#'   `list("airway_deseq2" = airway_deseq2)` is used as example data. Each data frame
#'   must contain effect size (e.g., log2FoldChange) and significance (e.g., padj) columns.
#' @param defaults A named list of input IDs and their default values to apply on
#'   startup. With the example data, they are applied over the settings the module
#'   gallery opens the module on, a key given here replacing its showcase value.
#' @param hide.inputs A character vector of input IDs to hide. Their values are still
#'   initialized and used, but the controls are not shown in the UI.
#' @param hide.tabs A character vector of tab names to hide. Inputs in these tabs are
#'   still initialized and used. `NULL` (the default) keeps the module's own default.
#' @return A Shiny app object.
#'
#' @import shiny
#' @importFrom shinyjs useShinyjs
#' @importFrom readxl read_excel
#'
#' @seealso [sciVizModules::volcanoPlotInputsUI()], [sciVizModules::volcanoPlotOutputUI()],
#' [sciVizModules::volcanoPlotServer()], [sciVizModules::airway_deseq2]
#'
#' @export
#' @author Jacob Martin
#' @examples
#' library(sciVizModules)
#' # Launch with default example data:
#' app <- volcanoPlotApp()
#' if (interactive()) runApp(app)
#'
#' # Launch with custom data:
#' data(airway_deseq2)
#' app2 <- volcanoPlotApp(list("airway" = airway_deseq2))
#' if (interactive()) runApp(app2)
volcanoPlotApp <- function(data_list = NULL, defaults = NULL, hide.inputs = NULL, hide.tabs = NULL) {
    # Use default example data when none is provided
    if (is.null(data_list)) {
        example <- .sci_module_example("volcano", defaults)
        data_list <- example$data_list
        defaults <- example$defaults
    }

    # Validate input
    stopifnot(is.list(data_list))
    lapply(data_list, function(data) {
        stopifnot(is.data.frame(data))
    })

    ui <- fluidPage(
        title = "Modular Volcano Plot",
        useShinyjs(),

        sidebarLayout(
            sidebarPanel(

                # --- Data Import ---
                h4("Data Import"),
                fileInput("file_upload", "Upload Excel File",
                    accept = c(".xlsx", ".xls")
                ),
                actionButton("load_data", "Load Data", class = "btn-primary"),
                hr(),

                # --- Plot Settings ---
                h4("Plot Settings"),
                selectInput("plot_select", "Select Dataset:", choices = names(data_list)),
                helpText("Plot settings reset when switching datasets."),
                uiOutput("plot_inputs_ui")

            ),
            mainPanel(

                # --- Plot ---
                volcanoPlotOutputUI("active_plot"),
                hr(),

                # --- Table ---
                h4("Data Table"),
                p("Filtering or editing the data table will update the plot.",
                    style = "color: grey; font-size: 12px;"),
                dataFilterUI(paste0("table"))

            )
        )
    )

    server <- function(input, output, session) {

        rv <- reactiveValues(datasets = data_list)

        # Update active_data whenever the selected dataset changes
        observeEvent(input$plot_select, {
            req(input$plot_select)
        })

        # ---- Data Import ----
        observeEvent(input$load_data, {
            req(input$file_upload)
            tryCatch({
                new_data <- as.data.frame(
                    readxl::read_excel(input$file_upload$datapath)
                )
                name <- tools::file_path_sans_ext(input$file_upload$name)
                rv$datasets[[name]] <- new_data
                showNotification(
                    paste0("Loaded '", name, "' (", nrow(new_data), " rows, ", ncol(new_data), " cols)"),
                    type = "message"
                )
            }, error = function(e) {
                showNotification(
                    paste("Could not read the uploaded file.",
                        "Please ensure it is a valid Excel (.xlsx/.xls) file."),
                    type = "error"
                )
            })
        })
        filtered_data <- dataFilterServer("table", reactive(rv$datasets[[input$plot_select]]))
        # Keep dataset selector in sync when new datasets are loaded
        observe({
            updateSelectInput(session, "plot_select", choices = names(rv$datasets))
        })

        # ---- Plot Settings UI ----
        output$plot_inputs_ui <- renderUI({
            req(rv$datasets[[input$plot_select]])
            volcanoPlotInputsUI("active_plot", rv$datasets[[input$plot_select]],
                defaults = defaults,
                title = h3(paste(input$plot_select, "Settings"))
            )
        })

        # ---- Plot Module ----
        do.call(volcanoPlotServer, .sci_server_args("active_plot", filtered_data, defaults, hide.inputs, hide.tabs))
    }
    shinyApp(ui, server)
}
