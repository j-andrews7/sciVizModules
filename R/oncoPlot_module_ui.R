#' Input UI components for the oncoPlot module
#'
#' This should be placed in the UI where the inputs should be shown, with an `id`
#' that matches the `id` used in the `oncoPlotServer()` and `oncoPlotOutputUI()`
#' functions.
#'
#' @details The module draws [oncoPlot()]: the gene-by-sample grid of
#' non-synonymous mutations, coloured by variant class, with each sample's
#' mutation burden above, each gene's mutation frequency to the right and sample
#' annotations as tracks below. Its data is a maftools `MAF` object or a data
#' frame in MAF columns (see [oncoPlot()]); in the apps and the gallery it is a
#' data frame, so filtering the data table (to a subtype, say) redraws the plot.
#' The inputs are organised into tabs via [VizModules::organize_inputs()].
#'
#' @section Plot parameters and defaults:
#' The following parameters can be accessed via UI inputs and/or the `defaults` argument:
#'
#' - `genes` - Genes to show; empty for the `top.n` most often mutated (default: empty)
#' - `top.n` - Number of most often mutated genes (default: 20)
#' - `clinical.tracks` - Sample annotations drawn as tracks (default: none)
#' - `sort.samples` - Sort samples into the oncoplot waterfall (default: TRUE)
#' - `include.unmutated` - Keep samples with none of the genes mutated (default: TRUE)
#' - `show.tmb` - Per-sample mutation count bar (default: TRUE)
#' - `show.gene.bar` - Per-gene frequency bar (default: TRUE)
#' - `show.sample.names` - Label the samples (default: FALSE)
#' - `background.color` - Colour of unmutated tiles (default: "#ECF0F1", as maftools)
#' - `palette.colours` - Named variant-class colours (multiColorPicker; default:
#'   maftools' oncoplot palette)
#'
#' The Legend, Axes and Plotly tabs carry the shared VizModules inputs; the
#' Axes tab starts with gridlines and axis lines off (`show.grid.x`,
#' `show.grid.y` and `axis.showline` FALSE).
#'
#' @param id The ID for the Shiny module.
#' @param data A maftools `MAF` object or a data frame in MAF columns.
#' @param defaults A named list of default values for the inputs.
#' @param title An optional title for the UI grid.
#' @param columns Number of columns for the UI grid.
#' @return A Shiny tagList containing the UI elements
#'
#' @import shiny
#' @importFrom shinyWidgets materialSwitch
#' @importFrom colourpicker colourInput
#'
#' @export
#' @author Jared Andrews
#' @seealso [oncoPlot()], [sciVizModules::oncoPlotOutputUI()], [sciVizModules::oncoPlotServer()],
#' [sciVizModules::oncoPlotApp()]
#' @examples
#' library(sciVizModules)
#' if (requireNamespace("maftools", quietly = TRUE)) {
#'     # The TCGA LAML cohort maftools ships, with its clinical annotations.
#'     laml <- read.delim(system.file("extdata", "tcga_laml.maf.gz", package = "maftools"),
#'         comment.char = "#")
#'     clinical <- read.delim(system.file("extdata", "tcga_laml_annot.tsv", package = "maftools"))
#'     laml <- merge(laml, clinical, by = "Tumor_Sample_Barcode")
#'     oncoPlotInputsUI("onco", laml)
#' }
oncoPlotInputsUI <- function(id, data, defaults = NULL, title = "Oncoplot Settings", columns = 2) {
    ns <- NS(id)
    m <- .maf_validate(data)
    d <- .onco_defaults(m, defaults)
    genes <- .maf_gene_summary(m)$Hugo_Symbol

    data_tab <- tagList(
        .sci_tip(viz_select_input(ns("genes"), "Genes", choices = genes, selected = d$genes, multiple = TRUE),
            "Genes to show, in place of the most often mutated ones. Leave empty to use Top Genes."),
        .sci_tip(numericInput(ns("top.n"), "Top Genes", value = d$top.n, min = 1, step = 1),
            "Number of most often mutated genes shown when no genes are chosen."),
        .sci_tip(viz_select_input(ns("clinical.tracks"), "Sample Tracks",
            choices = .maf_track_cols(m), selected = d$clinical.tracks, multiple = TRUE
        ), "Sample annotations drawn as tracks below the grid."),
        .sci_tip(materialSwitch(ns("sort.samples"), "Sort Samples", value = isTRUE(d$sort.samples), status = "success"),
            "Sort the samples into the oncoplot waterfall, by their mutations in gene order."),
        .sci_tip(materialSwitch(ns("include.unmutated"), "Unmutated Samples", value = isTRUE(d$include.unmutated),
            status = "success"), "Keep samples with none of the shown genes mutated."),
        .sci_tip(materialSwitch(ns("show.tmb"), "Mutation Burden Bar", value = isTRUE(d$show.tmb), status = "success"),
            "Draw each sample's non-synonymous variant count above the grid."),
        .sci_tip(materialSwitch(ns("show.gene.bar"), "Gene Frequency Bar", value = isTRUE(d$show.gene.bar),
            status = "success"), "Draw the percentage of samples each gene is mutated in."),
        .sci_tip(materialSwitch(ns("show.sample.names"), "Sample Names", value = isTRUE(d$show.sample.names),
            status = "success"), "Label each sample on the x-axis.")
    )
    aes_tab <- tagList(
        uiOutput(ns("palette.selection")),
        .sci_tip(colourInput(ns("background.color"), "Unmutated Color", value = d$background.color),
            "Colour of tiles where the gene is not mutated.")
    )

    .sci_plot_inputs_ui(ns, "oncoPlot", data_tab, aes_tab, .onco_style_defaults(defaults), title, columns,
        lines = FALSE)
}


#' Axes-tab defaults for the oncoPlot module
#'
#' A tile grid reads better without gridlines or axis lines. User values win.
#'
#' @param defaults A named list of user defaults, or `NULL`.
#' @return `defaults` with the oncoplot's axis styling filled in.
#'
#' @author Jared Andrews
#' @rdname INTERNAL_onco_style_defaults
#' @keywords internal
.onco_style_defaults <- function(defaults = NULL) {
    base <- list(show.grid.x = FALSE, show.grid.y = FALSE, axis.showline = FALSE)
    base[names(defaults %||% list())] <- defaults
    base
}


#' Output UI components for the oncoPlot module
#'
#' @param id The ID for the Shiny module.
#' @param resizable Logical; when `TRUE` (the default) the plot output can be resized by dragging.
#' @return A Shiny plotlyOutput.
#'
#' @examples
#' oncoPlotOutputUI("onco")
#' @export
#' @author Jared Andrews
oncoPlotOutputUI <- function(id, resizable = TRUE) {
    .sci_plot_output_ui(id, "oncoPlot", resizable = resizable, height = "700px")
}


#' Default inputs for the oncoPlot module
#'
#' Shared by the UI and the Reset handler. User values win.
#'
#' @param m A result of [.maf_table()].
#' @param defaults A named list of user defaults, or `NULL`.
#' @return A named list of defaults.
#'
#' @author Jared Andrews
#' @rdname INTERNAL_onco_defaults
#' @keywords internal
.onco_defaults <- function(m, defaults = NULL) {
    base <- list(
        genes = character(0), top.n = 20, clinical.tracks = character(0), sort.samples = TRUE,
        include.unmutated = TRUE, show.tmb = TRUE, show.gene.bar = TRUE, show.sample.names = FALSE,
        background.color = "#ECF0F1"
    )
    lapply(stats::setNames(names(base), names(base)), function(k) get_default(defaults, k, base[[k]]))
}
