#' Module registry for the VizModules Figure Builder
#'
#' Describes this package's data-frame modules in the shape
#' [VizModules::figureBuilderServer()] expects, so sciVizModules plots can be
#' arranged into a multi-panel figure alongside the VizModules ones.
#'
#' @details
#' Each entry is a list with `label` (shown in the builder's "Add Plot"
#' picker), `dataset` (the dataset name its `defaults` were written for),
#' `inputs_ui` / `output_ui` / `server_fn` (the module's trio), and `defaults`.
#'
#' Only the modules that take a plain data frame can be registered. The
#' builder's dataset catalogue holds data frames, so the `dittoSeq` modules
#' (which take a `SingleCellExperiment`, `Seurat` or `SummarizedExperiment`),
#' the bulk expression modules (`samplePCA`, `sampleDistanceHeatmap`,
#' `deHeatmap`), `cnSegmentPlot` (a `CNSegment` object) and `michaelisMenten`
#' (a bundle whose `stats` element is a model fit) have no place in it. Run
#' their `*App()` functions instead.
#'
#' `goFanPlot` is included only when the packages it needs are installed
#' (`GOfan` plus an `OrgDb`), so the picker never offers a panel that cannot draw.
#'
#' Every registered module renders a plotly graph, so the builder's SVG figure
#' export and its source-data archive photograph them in the browser; none of
#' them needs the `vector_svg` / `raster_png` hooks that a non-plotly module
#' would supply.
#'
#' @return A named list of Figure Builder module registry entries.
#'
#' @seealso [sciFigureBuilderApp()], [VizModules::figureBuilderServer()],
#' [VizModules::figureBuilderApp()]
#'
#' @export
#' @author Jared Andrews
#' @examples
#' registry <- sci_figure_builder_registry()
#' names(registry)
sci_figure_builder_registry <- function() {
    registry <- list(
        volcano = list(
            label = "Volcano Plot", dataset = "airway_deseq2",
            inputs_ui = volcanoPlotInputsUI,
            output_ui = volcanoPlotOutputUI,
            server_fn = volcanoPlotServer,
            defaults = list("sig.thresh" = 0.05, "fc.thresh" = 1)
        ),
        ma = list(
            label = "MA Plot", dataset = "airway_deseq2",
            inputs_ui = maPlotInputsUI,
            output_ui = maPlotOutputUI,
            server_fn = maPlotServer,
            defaults = list("sig.thresh" = 0.05, "fc.thresh" = 1)
        ),
        enrichment = list(
            label = "Enrichment Dot Plot", dataset = "example_enrichment",
            inputs_ui = enrichmentDotPlotInputsUI,
            output_ui = enrichmentDotPlotOutputUI,
            server_fn = enrichmentDotPlotServer,
            defaults = NULL
        ),
        dose = list(
            label = "Dose-Response", dataset = "dose_response",
            inputs_ui = doseResponseInputsUI,
            output_ui = doseResponseOutputUI,
            server_fn = doseResponseServer,
            defaults = NULL
        ),
        mutational = list(
            label = "Mutational Profile", dataset = "example_sbs96",
            inputs_ui = mutationalProfileInputsUI,
            output_ui = mutationalProfileOutputUI,
            server_fn = mutationalProfileServer,
            defaults = NULL
        )
    )

    registry$survival <- list(
        label = "Survival Curve", dataset = "survival_lung",
        inputs_ui = survivalCurveInputsUI,
        output_ui = survivalCurveOutputUI,
        server_fn = survivalCurveServer,
        defaults = list("time" = "time", "status" = "status", "group.by" = "sex")
    )

    if (requireNamespace("GOfan", quietly = TRUE) &&
        requireNamespace("org.Hs.eg.db", quietly = TRUE)) {
        registry$gofan <- list(
            label = "GO Sunburst", dataset = "example_enrichment",
            inputs_ui = goFanPlotInputsUI,
            output_ui = goFanPlotOutputUI,
            server_fn = goFanPlotServer,
            defaults = NULL
        )
    }

    registry
}


#' Datasets seeding the sciVizModules Figure Builder
#'
#' The bundled data frames the modules in [sci_figure_builder_registry()] are
#' written for. Loaded on demand rather than referenced by name, since this
#' package sets no `LazyData`.
#'
#' @return A named list of data frames.
#'
#' @author Jared Andrews
#' @rdname INTERNAL_sci_figure_builder_data
#' @keywords internal
.sci_figure_builder_data <- function() {
    list(
        "airway_deseq2"      = .sci_example_data("airway_deseq2"),
        "airway_edger"       = .sci_example_data("airway_edger"),
        "airway_voom"        = .sci_example_data("airway_voom"),
        "example_enrichment" = .sci_example_data("example_enrichment"),
        "survival_lung"      = .sci_example_data("survival_lung"),
        "dose_response"      = .sci_example_data("dose_response"),
        "example_sbs96"      = .sci_example_data("example_sbs96")
    )
}


#' Figure Builder app seeded with the sciVizModules modules
#'
#' A thin wrapper around [VizModules::figureBuilderApp()] that hands it
#' [sci_figure_builder_registry()] and this package's bundled datasets, so
#' scientific panels can be dragged, sized and exported as one multi-panel
#' figure with a per-panel source-data archive.
#'
#' The builder offers only the modules in the registry it is given. To have the
#' VizModules panels available alongside these ones, pass a combined registry
#' and a combined dataset list (see the examples).
#'
#' @param data_list An optional named list of data frames seeding the dataset
#'   registry. Defaults to this package's bundled example data.
#' @param module_registry An optional registry overriding
#'   [sci_figure_builder_registry()].
#' @param title The app title.
#' @param return_components Logical; when `TRUE`, return `list(ui =, server =)`
#'   instead of a [shiny::shinyApp()] object, e.g. for a deployment `app.R`.
#'
#' @return A [shiny::shinyApp()] object, or a list of `ui` and `server`
#'   components when `return_components = TRUE`.
#'
#' @import shiny
#' @importFrom VizModules figureBuilderApp
#'
#' @seealso [sci_figure_builder_registry()], [VizModules::figureBuilderApp()]
#'
#' @export
#' @author Jared Andrews
#' @examples
#' library(sciVizModules)
#' app <- sciFigureBuilderApp()
#' if (interactive()) shiny::runApp(app)
#'
#' \dontrun{
#' # Offer a VizModules panel alongside these ones. A registry entry is just a
#' # list of the module's trio plus a dataset name and its defaults.
#' data(airway_deseq2)
#' registry <- c(
#'     sci_figure_builder_registry(),
#'     list(box = list(
#'         label = "Box Plot", dataset = "airway_deseq2",
#'         inputs_ui = VizModules::plotthis_BoxPlotInputsUI,
#'         output_ui = VizModules::plotthis_BoxPlotOutputUI,
#'         server_fn = VizModules::plotthis_BoxPlotServer,
#'         defaults = list("y.data" = "log2FoldChange")
#'     ))
#' )
#' sciFigureBuilderApp(module_registry = registry)
#' }
sciFigureBuilderApp <- function(data_list = NULL,
                                module_registry = NULL,
                                title = "sciVizModules Figure Builder",
                                return_components = FALSE) {
    if (is.null(data_list)) {
        data_list <- .sci_figure_builder_data()
    }
    if (is.null(module_registry)) {
        module_registry <- sci_figure_builder_registry()
    }

    stopifnot(is.list(data_list), length(data_list) >= 1)
    stopifnot(is.list(module_registry), length(module_registry) >= 1)

    VizModules::figureBuilderApp(
        data_list = data_list,
        module_registry = module_registry,
        title = title,
        return_components = return_components
    )
}
