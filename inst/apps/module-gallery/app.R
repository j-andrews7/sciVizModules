library(sciVizModules)

## ---------------------------------------------------------------------------
## sciVizModules Gallery
##
## Showcases every sciVizModules module using the bundled example datasets.
## Modules fall into families, each wired to a different data source:
##
##   * "df"    - data.frame modules. Get a VizModules dataFilter data table
##               so users can filter/edit the data feeding the plot.
##   * "sce"   - dittoSeq / single-cell modules. Bound directly to a
##               SingleCellExperiment; no data-table filter applies.
##   * "mm"    - the Michaelis-Menten module, which needs a bundle of
##               observed points, a fitted line, and a stats object.
##   * "cn"    - the copy-number module, bound to a CNSegment object.
##   * "pca"   - the PCAtools modules, bound to a PCAtools `pca` object.
##   * "af"    - the AlphaFold module, bound to a read_alphafold() object.
##   * "gsea"  - the GSEA module, bound to an fgsea input bundle.
##   * "structure" - the 3D structure viewer, bound to a read_structure()
##               object. Its output is an NGL widget, not a plotly figure.
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
data("example_cn_segment", package = "sciVizModules", envir = environment())
data("example_pca",        package = "sciVizModules", envir = environment())
data("example_gwas",       package = "sciVizModules", envir = environment())
data("example_gsea",       package = "sciVizModules", envir = environment())
data("example_biomarkers", package = "sciVizModules", envir = environment())
data("example_plate",      package = "sciVizModules", envir = environment())

## Oral theophylline in 12 subjects, from base R.
theoph <- as.data.frame(datasets::Theoph)
theoph$Subject <- as.character(theoph$Subject)

## A simulated MAGeCK RRA gene summary, shipped as the file MAGeCK writes.
example_mageck <- read_mageck(
    system.file("extdata", "example_mageck.gene_summary.txt.gz", package = "sciVizModules")
)

## The AlphaFold DB prediction for human p53 (CC-BY 4.0), shipped as files.
example_alphafold <- read_alphafold(
    pae = system.file("extdata", "AF-P04637-F1-predicted_aligned_error_v6.json.gz", package = "sciVizModules"),
    confidence = system.file("extdata", "AF-P04637-F1-confidence_v6.json.gz", package = "sciVizModules")
)

## The same p53 model as a 3D structure.
example_structure <- read_structure(
    system.file("extdata", "AF-P04637-F1-model_v6.pdb.gz", package = "sciVizModules")
)

## Simulated GROMACS backbone RMSD for three replicas, shipped as .xvg files.
example_md <- do.call(rbind, lapply(1:3, function(i) {
    read_xvg(
        system.file("extdata", sprintf("example_rmsd_rep%d.xvg.gz", i), package = "sciVizModules"),
        series = paste("replica", i)
    )
}))

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
        label = "GSEA", id = "gsea", type = "gsea",
        inputs_ui = gseaEnrichmentPlotInputsUI, output_ui = gseaEnrichmentPlotOutputUI,
        server_fn = gseaEnrichmentPlotServer, data = example_gsea, defaults = NULL
    ),
    list(
        label = "Manhattan", id = "manhattan", type = "df",
        inputs_ui = manhattanPlotInputsUI, output_ui = manhattanPlotOutputUI,
        server_fn = manhattanPlotServer, data = example_gwas, defaults = NULL
    ),
    list(
        label = "GWAS QQ", id = "gwasqq", type = "df",
        inputs_ui = gwasQQPlotInputsUI, output_ui = gwasQQPlotOutputUI,
        server_fn = gwasQQPlotServer, data = example_gwas, defaults = NULL
    ),
    list(
        label = "CRISPR Screen", id = "crispr", type = "df",
        inputs_ui = crisprScreenRankInputsUI, output_ui = crisprScreenRankOutputUI,
        server_fn = crisprScreenRankServer, data = example_mageck, defaults = NULL
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
        label = "PK Profiles", id = "pk", type = "df",
        inputs_ui = pkConcentrationTimeInputsUI, output_ui = pkConcentrationTimeOutputUI,
        server_fn = pkConcentrationTimeServer, data = theoph, defaults = NULL
    ),
    list(
        label = "Plate", id = "plate", type = "df",
        inputs_ui = plateHeatmapInputsUI, output_ui = plateHeatmapOutputUI,
        server_fn = plateHeatmapServer, data = example_plate, defaults = NULL
    ),
    list(
        label = "Forest", id = "forest", type = "df",
        inputs_ui = forestPlotInputsUI, output_ui = forestPlotOutputUI,
        server_fn = forestPlotServer, data = survival_lung, defaults = NULL
    ),
    list(
        label = "ROC", id = "roc", type = "df",
        inputs_ui = rocCurveInputsUI, output_ui = rocCurveOutputUI,
        server_fn = rocCurveServer, data = example_biomarkers, defaults = NULL
    ),
    list(
        label = "Copy Number", id = "cnseg", type = "cn",
        inputs_ui = cnSegmentPlotInputsUI, output_ui = cnSegmentPlotOutputUI,
        server_fn = cnSegmentPlotServer, data = example_cn_segment, defaults = NULL
    ),
    list(
        label = "PCA Biplot", id = "pcabiplot", type = "pca",
        inputs_ui = pcaBiplotInputsUI, output_ui = pcaBiplotOutputUI,
        server_fn = pcaBiplotServer, data = example_pca, defaults = NULL
    ),
    list(
        label = "PCA Scree", id = "pcascree", type = "pca",
        inputs_ui = pcaScreePlotInputsUI, output_ui = pcaScreePlotOutputUI,
        server_fn = pcaScreePlotServer, data = example_pca, defaults = NULL
    ),
    list(
        label = "PCA Loadings", id = "pcaloadings", type = "pca",
        inputs_ui = pcaLoadingsPlotInputsUI, output_ui = pcaLoadingsPlotOutputUI,
        server_fn = pcaLoadingsPlotServer, data = example_pca, defaults = NULL
    ),
    list(
        label = "PCA Pairs", id = "pcapairs", type = "pca",
        inputs_ui = pcaPairsPlotInputsUI, output_ui = pcaPairsPlotOutputUI,
        server_fn = pcaPairsPlotServer, data = example_pca, defaults = NULL
    ),
    list(
        label = "PC Correlation", id = "pcaeigencor", type = "pca",
        inputs_ui = pcaEigencorPlotInputsUI, output_ui = pcaEigencorPlotOutputUI,
        server_fn = pcaEigencorPlotServer, data = example_pca, defaults = NULL
    ),
    list(
        label = "AlphaFold", id = "alphafold", type = "af",
        inputs_ui = alphafoldConfidenceInputsUI, output_ui = alphafoldConfidenceOutputUI,
        server_fn = alphafoldConfidenceServer, data = example_alphafold, defaults = NULL
    ),
    list(
        label = "Structure", id = "structure", type = "structure",
        inputs_ui = structureViewerInputsUI, output_ui = structureViewerOutputUI,
        server_fn = structureViewerServer, data = example_structure, defaults = NULL
    ),
    list(
        label = "MD Trajectory", id = "md", type = "df",
        inputs_ui = mdTrajectoryMetricsInputsUI, output_ui = mdTrajectoryMetricsOutputUI,
        server_fn = mdTrajectoryMetricsServer, data = example_md, defaults = NULL
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
    } else {
        note <- switch(mod$type,
            sce = "This module is bound to the bundled 'example_sce' SingleCellExperiment.",
            cn = "This module is bound to the bundled 'example_cn_segment' CNSegment object.",
            pca = "This module is bound to the bundled 'example_pca' PCAtools object (airway RNA-seq).",
            gsea = "This module is bound to the bundled 'example_gsea' input (fgsea's example ranks and pathways).",
            af = paste(
                "This module is bound to the bundled AlphaFold DB prediction for human p53",
                "(P04637; AlphaFold DB, CC-BY 4.0)."
            ),
            structure = paste(
                "This module shows the bundled AlphaFold DB model of human p53 (P04637; CC-BY 4.0).",
                "It is an NGL 3D widget rather than a plotly figure: drag to rotate, scroll to zoom,",
                "and use Snapshot for a PNG."
            ),
            paste(
                "This module uses the bundled Michaelis-Menten kinetics data",
                "(observed points, fitted line, and nls fit)."
            )
        )
        tagList(hr(), p(note, style = "color: grey; font-size: 12px;"))
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
                    "Differential-expression, enrichment, survival, forest, ROC, GWAS,",
                    "CRISPR screen, pharmacology, plate and MD trajectory modules are",
                    "driven by editable data tables; the single-cell (dittoSeq), copy",
                    "number, PCA (PCAtools), GSEA, AlphaFold and 3D structure modules",
                    "are bound to bundled example objects."
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
            ## Every rule is anchored on .scivizmodules-gallery, a class this
            ## app invents. Bare `.navbar` / `.navbar-nav` are Bootstrap's own,
            ## so they would restyle any navbar on the page -- see the CSS
            ## containment notes in AGENTS.md.
            tags$head(tags$style(HTML(paste(
                ".scivizmodules-gallery .navbar { margin-bottom: 0; }",
                ".scivizmodules-gallery .navbar-nav > li > a {",
                "  padding-left: 9px; padding-right: 9px; font-size: 13px;",
                "}",
                ".scivizmodules-gallery .navbar .navbar-collapse { flex-wrap: nowrap; }",
                ".scivizmodules-gallery .navbar-nav { white-space: nowrap; }",
                sep = "\n"
            ))))
        )
    ),
    list(about_tab),
    lapply(module_registry, build_tab)
))

## The stylesheet above is scoped to this class, so the whole page carries it.
## navbarPage() returns a tagList rather than a single tag, so wrap rather than
## trying to append an attribute to it.
ui <- tags$div(class = "scivizmodules-gallery", ui)

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

        } else if (m$type %in% c("sce", "cn", "pca", "af", "gsea", "structure")) {
            ## An object bound directly (no data table): SingleCellExperiment,
            ## CNSegment, PCAtools pca, read_alphafold() or read_structure() result.
            obj_data <- reactive(m$data)
            output[[paste0(m$id, "_inputs_ui")]] <- renderUI({
                m$inputs_ui(m$id, obj_data(), defaults = m$defaults,
                    title = h3(paste(m$label, "Settings")))
            })
            m$server_fn(m$id, data = obj_data)

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
