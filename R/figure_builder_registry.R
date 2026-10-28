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
#' The entries are those of the registry behind the module gallery
#' ([sciModuleGalleryApp()]) and every module's `*App()`, so a panel opens on
#' the same settings as the module's gallery tab when its example dataset is
#' the one chosen.
#'
#' Only the modules that take a plain data frame can be registered. The
#' builder's dataset catalogue holds data frames, so the `dittoSeq` modules
#' (which take a `SingleCellExperiment`, `Seurat` or `SummarizedExperiment`),
#' the bulk expression modules (`samplePCA`, `sampleDistanceHeatmap`,
#' `deHeatmap`), `cnSegmentPlot` (a `CNSegment` object) and `michaelisMenten`
#' (a bundle whose `stats` element is a model fit) have no place in it. Run
#' their `*App()` functions instead.
#'
#' A module is included only when the packages it needs are installed
#' (`goFanPlot` needs `GOfan` plus an `OrgDb`, `doseResponse` needs `drc`), so
#' the picker never offers a panel that cannot draw.
#'
#' Every registered module renders a plotly graph, so the builder's SVG figure
#' export and its source-data archive photograph them in the browser; none of
#' them needs the `vector_svg` / `raster_png` hooks that a non-plotly module
#' would supply.
#'
#' @return A named list of Figure Builder module registry entries.
#'
#' @seealso [sciFigureBuilderApp()], [sciModuleGalleryApp()],
#' [VizModules::figureBuilderServer()], [VizModules::figureBuilderApp()]
#'
#' @export
#' @author Jared Andrews
#' @examples
#' registry <- sci_figure_builder_registry()
#' names(registry)
sci_figure_builder_registry <- function() {
    showcase <- .sci_module_showcase()
    keep <- vapply(showcase, function(entry) {
        isTRUE(entry$figure_builder) && !length(.sci_showcase_missing(entry))
    }, logical(1))
    lapply(showcase[keep], function(entry) {
        entry[c("label", "dataset", "inputs_ui", "output_ui", "server_fn", "defaults")]
    })
}


#' Datasets seeding the sciVizModules Figure Builder
#'
#' The example datasets the modules in [sci_figure_builder_registry()] are
#' written for, plus the airway edgeR and limma-voom results as alternatives to
#' the DESeq2 ones. Loaded on demand rather than referenced by name, since this
#' package sets no `LazyData`.
#'
#' @return A named list of data frames.
#'
#' @author Jared Andrews
#' @rdname INTERNAL_sci_figure_builder_data
#' @keywords internal
.sci_figure_builder_data <- function() {
    keys <- unique(c(
        vapply(sci_figure_builder_registry(), function(entry) entry$dataset, character(1)),
        "airway_edger", "airway_voom"
    ))
    stats::setNames(lapply(keys, .sci_example_dataset), keys)
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
