library(sciVizModules)

## ---------------------------------------------------------------------------
## sciVizModules Gallery
##
## Showcases every sciVizModules module using the bundled example datasets.
## Modules fall into three families, each wired to a different data source:
##
##   * "df"    - data.frame modules. Get a VizModules dataFilter data table
##               so users can filter/edit the data feeding the plot.
##   * "sce"   - dittoSeq / single-cell modules. Bound directly to a
##               SingleCellExperiment; no data-table filter applies.
##   * "mm"    - the Michaelis-Menten module, which needs a bundle of
##               observed points, a fitted line, and a stats object.
## ---------------------------------------------------------------------------

## ---- Package metadata (for the About tab / navbar) ------------------------
pkg_desc    <- utils::packageDescription("sciVizModules")
pkg_version <- as.character(utils::packageVersion("sciVizModules"))
repo_url    <- "https://github.com/j-andrews7/sciVizModules"
bug_url     <- "https://github.com/j-andrews7/sciVizModules/issues"

## ---- Bundled example data -------------------------------------------------
data("airway_deseq2",      package = "sciVizModules", envir = environment())
data("example_enrichment", package = "sciVizModules", envir = environment())
data("survival_lung",      package = "sciVizModules", envir = environment())
data("dose_response",      package = "sciVizModules", envir = environment())
data("example_sce",        package = "sciVizModules", envir = environment())
data("mm_kinetics",        package = "sciVizModules", envir = environment())
data("mm_kinetics_line",   package = "sciVizModules", envir = environment())
data("mm_kinetics_fit",    package = "sciVizModules", envir = environment())

## Michaelis-Menten needs three pieces bundled together.
mm_bundle <- list(
    data  = mm_kinetics,
    model = mm_kinetics_line,
    stats = mm_kinetics_fit
)

## ---- Module registry ------------------------------------------------------
## Each entry defines one gallery tab. `type` selects the data-wiring path.
module_registry <- list(
    list(
        label = "Volcano", id = "volcano", type = "df",
        inputs_ui = volcanoPlotInputsUI, output_ui = volcanoPlotOutputUI,
        server_fn = volcanoPlotServer, data = airway_deseq2, defaults = NULL
    ),
    list(
        label = "MA", id = "ma", type = "df",
        inputs_ui = maPlotInputsUI, output_ui = maPlotOutputUI,
        server_fn = maPlotServer, data = airway_deseq2, defaults = NULL
    ),
    list(
        label = "Enrichment Dot", id = "enrich", type = "df",
        inputs_ui = enrichmentDotPlotInputsUI, output_ui = enrichmentDotPlotOutputUI,
        server_fn = enrichmentDotPlotServer, data = example_enrichment, defaults = NULL
    ),
    list(
        label = "GO Sunburst", id = "gofan", type = "df",
        inputs_ui = goFanPlotInputsUI, output_ui = goFanPlotOutputUI,
        server_fn = goFanPlotServer, data = example_enrichment, defaults = NULL
    ),
    list(
        label = "Dose-Response", id = "dose", type = "df",
        inputs_ui = doseResponseInputsUI, output_ui = doseResponseOutputUI,
        server_fn = doseResponseServer, data = dose_response, defaults = NULL
    ),
    list(
        label = "Survival", id = "survival", type = "df",
        inputs_ui = survivalCurveInputsUI, output_ui = survivalCurveOutputUI,
        server_fn = survivalCurveServer, data = survival_lung, defaults = NULL
    ),
    list(
        label = "Michaelis-Menten", id = "mm", type = "mm",
        inputs_ui = michaelisMentenInputsUI, output_ui = michaelisMentenOutputUI,
        server_fn = michaelisMentenServer, data = mm_kinetics,
        bundle = mm_bundle, defaults = NULL
    ),
    list(
        label = "DimPlot", id = "dimplot", type = "sce",
        inputs_ui = dittoDimPlotInputsUI, output_ui = dittoDimPlotOutputUI,
        server_fn = dittoDimPlotServer, data = example_sce, defaults = NULL
    ),
    list(
        label = "DimHex", id = "dimhex", type = "sce",
        inputs_ui = dittoDimHexInputsUI, output_ui = dittoDimHexOutputUI,
        server_fn = dittoDimHexServer, data = example_sce, defaults = NULL
    ),
    list(
        label = "Scatter", id = "scatter", type = "sce",
        inputs_ui = dittoScatterPlotInputsUI, output_ui = dittoScatterPlotOutputUI,
        server_fn = dittoScatterPlotServer, data = example_sce, defaults = NULL
    ),
    list(
        label = "dittoPlot", id = "dittoplot", type = "sce",
        inputs_ui = dittoPlotInputsUI, output_ui = dittoPlotOutputUI,
        server_fn = dittoPlotServer, data = example_sce, defaults = NULL
    ),
    list(
        label = "Ridge + Jitter", id = "ridge", type = "sce",
        inputs_ui = dittoRidgeJitterInputsUI, output_ui = dittoRidgeJitterOutputUI,
        server_fn = dittoRidgeJitterServer, data = example_sce, defaults = NULL
    ),
    list(
        label = "Composition Bar", id = "barplot", type = "sce",
        inputs_ui = dittoBarPlotInputsUI, output_ui = dittoBarPlotOutputUI,
        server_fn = dittoBarPlotServer, data = example_sce, defaults = NULL
    ),
    list(
        label = "Frequency", id = "freq", type = "sce",
        inputs_ui = dittoFreqPlotInputsUI, output_ui = dittoFreqPlotOutputUI,
        server_fn = dittoFreqPlotServer, data = example_sce, defaults = NULL
    )
)

## ---- Tab builders ---------------------------------------------------------
build_tab <- function(mod) {
    ## data.frame modules get an editable data table under the plot; the other
    ## families show a read-only note about their fixed example object instead.
    lower <- if (identical(mod$type, "df")) {
        tagList(
            hr(),
            h4("Data Table"),
            p("Filtering the data table will update the plot.",
                style = "color: grey; font-size: 12px;"),
            VizModules::dataFilterUI(paste0(mod$id, "_filter"))
        )
    } else if (identical(mod$type, "sce")) {
        tagList(
            hr(),
            p("This module is bound to the bundled 'example_sce' ",
                "SingleCellExperiment.",
                style = "color: grey; font-size: 12px;")
        )
    } else {
        tagList(
            hr(),
            p("This module uses the bundled Michaelis-Menten kinetics data ",
                "(observed points, fitted line, and nls fit).",
                style = "color: grey; font-size: 12px;")
        )
    }

    tabPanel(
        mod$label,
        value = mod$id,
        sidebarLayout(
            sidebarPanel(
                width = 4,
                uiOutput(paste0(mod$id, "_inputs_ui"))
            ),
            mainPanel(
                width = 8,
                mod$output_ui(mod$id),
                lower
            )
        )
    )
}

about_tab <- tabPanel(
    "About",
    value = "about",
    fluidPage(
        fluidRow(
            column(
                width = 9,
                h2("About sciVizModules"),
                p(pkg_desc$Title),
                p(pkg_desc$Description),
                p(
                    "This gallery showcases sciVizModules' interactive Shiny",
                    "modules using bundled example datasets so you can preview",
                    "each scientific plot type and its configurable inputs.",
                    "Differential-expression, enrichment, survival, and",
                    "pharmacology modules are driven by editable data tables;",
                    "the single-cell (dittoSeq) modules are bound to the",
                    "bundled example SingleCellExperiment."
                ),
                tags$p(
                    tags$strong("Repository: "),
                    tags$a(href = repo_url, target = "_blank",
                        rel = "noopener noreferrer", repo_url)
                ),
                tags$p(
                    tags$strong("Report issues: "),
                    tags$a(href = bug_url, target = "_blank",
                        rel = "noopener noreferrer", bug_url)
                ),
                tags$p(tags$strong("Version: "), paste0("v", pkg_version))
            )
        )
    )
)

## ---- UI -------------------------------------------------------------------
ui <- do.call(navbarPage, c(
    list(
        title    = "sciVizModules Gallery",
        id       = "active_tab",
        position = "static-top",
        header   = tagList(
            shinyjs::useShinyjs(),
            tags$head(tags$style(HTML(paste(
                ".navbar { margin-bottom: 0; }",
                ".navbar-nav > li > a {",
                "  padding-left: 9px; padding-right: 9px; font-size: 13px;",
                "}",
                ".navbar .navbar-collapse { flex-wrap: nowrap; }",
                ".navbar-nav { white-space: nowrap; }",
                sep = "\n"
            ))))
        )
    ),
    list(about_tab),
    lapply(module_registry, build_tab)
))

## ---- Server ---------------------------------------------------------------
server <- function(input, output, session) {
    lapply(module_registry, function(m) {
        if (identical(m$type, "df")) {
            ## Editable/filterable data table feeds the plot.
            filtered_data <- VizModules::dataFilterServer(
                paste0(m$id, "_filter"),
                reactive(m$data)
            )
            output[[paste0(m$id, "_inputs_ui")]] <- renderUI({
                m$inputs_ui(m$id, filtered_data(), defaults = m$defaults,
                    title = h3(paste(m$label, "Settings")))
            })
            m$server_fn(m$id, data = filtered_data)

        } else if (identical(m$type, "sce")) {
            ## SingleCellExperiment bound directly (no data table).
            sce_data <- reactive(m$data)
            output[[paste0(m$id, "_inputs_ui")]] <- renderUI({
                m$inputs_ui(m$id, sce_data(), defaults = m$defaults,
                    title = h3(paste(m$label, "Settings")))
            })
            m$server_fn(m$id, data = sce_data)

        } else {
            ## Michaelis-Menten: bundle of data + model + stats.
            bundle <- reactive(m$bundle)
            output[[paste0(m$id, "_inputs_ui")]] <- renderUI({
                m$inputs_ui(m$id, m$data, defaults = m$defaults,
                    title = h3(paste(m$label, "Settings")))
            })
            m$server_fn(m$id, data = bundle)
        }
    })
}

shinyApp(ui, server)
