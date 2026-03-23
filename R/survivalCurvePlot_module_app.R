#' Create a standalone Shiny app for the survivalCurvePlot module
#'
#' Generates a complete Shiny application built around the modular survival
#' curve components.  The app includes:
#' \enumerate{
#'   \item A **Data Import** section for uploading CSV or Excel files.
#'   \item A **Dataset selector** to switch between loaded datasets.
#'   \item A **Plot Settings** panel driven by [survivalCurvePlotInputsUI()].
#'   \item A **main panel** with the interactive Kaplan-Meier step-function
#'     plot and a Survival Summary Table, both rendered by
#'     [survivalCurvePlotServer()].
#' }
#'
#' When `data_list` is `NULL` (the default), the app launches with
#' `km_survival_groups` (two-group KM data) and `km_survival_single`
#' (single-group KM data) as built-in example datasets.  Uploaded files are
#' added to the available datasets and can be selected for plotting.
#'
#' @param data_list An optional named list of data frames.  Each data frame
#'   must contain at minimum a time column and a survival probability column
#'   (0–1 scale).  If `NULL` (the default), the bundled `km_survival_groups`
#'   and `km_survival_single` datasets are used.
#' @return A Shiny app object.
#'
#' @import shiny
#' @importFrom shinyjs useShinyjs
#' @importFrom readxl read_excel
#'
#' @export
#' @author Jacob Martin, Jared Andrews
#' @seealso [survivalCurvePlotInputsUI()],
#'   [survivalCurvePlotOutputUI()],
#'   [survivalCurvePlotServer()],
#'   [km_survival_groups],
#'   [km_survival_single]
#' @examples
#' library(sciVizModules)
#' # Launch with default example data:
#' app <- survivalCurvePlotApp()
#' if (interactive()) runApp(app)
#'
#' # Launch with custom data:
#' data(km_survival_single)
#' app2 <- survivalCurvePlotApp(list("my_data" = km_survival_single))
#' if (interactive()) runApp(app2)
survivalCurvePlotApp <- function(data_list = NULL) {
    if (is.null(data_list)) {
        data_list <- list(
            "km_survival_groups" = km_survival_groups,
            "km_survival_single" = km_survival_single
        )
    }

    stopifnot(is.list(data_list))
    lapply(data_list, function(d) stopifnot(is.data.frame(d)))

    ui <- fluidPage(
        title = "Modular Survival Curve Plot",
        useShinyjs(),

        sidebarLayout(
            sidebarPanel(

                # --- Data Import ---
                h4("Data Import"),
                fileInput("file_upload", "Upload CSV or Excel File",
                    accept = c(".csv", ".tsv", ".xlsx", ".xls")
                ),
                actionButton("load_data", "Load Data", class = "btn-primary"),
                hr(),

                # --- Plot Settings ---
                h4("Plot Settings"),
                selectInput("plot_select", "Select Dataset:",
                    choices = names(data_list)),
                helpText("Plot settings reset when switching datasets."),
                uiOutput("plot_inputs_ui")

            ),
            mainPanel(

                # --- Plot + risk table (rendered by survivalCurvePlotOutputUI) ---
                survivalCurvePlotOutputUI("active_plot")

            )
        )
    )

    server <- function(input, output, session) {

        rv <- reactiveValues(datasets = data_list)

        observeEvent(input$plot_select, {
            req(input$plot_select)
        })

        # ---- Data Import ----------------------------------------------------
        observeEvent(input$load_data, {
            req(input$file_upload)
            tryCatch({
                path <- input$file_upload$datapath
                ext  <- tolower(tools::file_ext(input$file_upload$name))
                new_data <- if (ext %in% c("xlsx", "xls")) {
                    as.data.frame(readxl::read_excel(path))
                } else {
                    utils::read.csv(path, stringsAsFactors = FALSE)
                }
                name <- tools::file_path_sans_ext(input$file_upload$name)
                rv$datasets[[name]] <- new_data
                showNotification(
                    paste0("Loaded '", name, "' (",
                           nrow(new_data), " rows, ",
                           ncol(new_data), " cols)"),
                    type = "message"
                )
            }, error = function(e) {
                showNotification(
                    paste("Could not read the uploaded file.",
                          "Please ensure it is a valid CSV or Excel file."),
                    type = "error"
                )
            })
        })

        # Keep dataset selector in sync when new datasets are loaded
        observe({
            updateSelectInput(session, "plot_select",
                choices = names(rv$datasets))
        })

        # Active dataset reactive
        active_data <- reactive({
            req(input$plot_select)
            rv$datasets[[input$plot_select]]
        })

        # ---- Dynamic plot inputs UI ----------------------------------------
        output$plot_inputs_ui <- renderUI({
            req(active_data())
            survivalCurvePlotInputsUI(
                "active_plot",
                active_data(),
                title = paste(input$plot_select, "Settings")
            )
        })

        # ---- Plot + table module --------------------------------------------
        survivalCurvePlotServer("active_plot", data = active_data)
    }

    shinyApp(ui, server)
}
