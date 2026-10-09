#' Input UI components for the deHeatmap module
#'
#' This should be placed in the UI where the inputs should be shown, with an `id`
#' that matches the `id` used in the `deHeatmapServer()` and
#' `deHeatmapOutputUI()` functions.
#'
#' @details The user inputs for this module are separated from the outputs to allow for
#' more flexible UI design.
#'
#' The module draws the heatmap of the top differentially expressed genes of a
#' bulk experiment: genes passing adjusted p-value and fold-change cut-offs are
#' ranked, the top ones taken from the transformed counts, and shown as per-gene
#' z-scores across the samples, split into up- and down-regulated blocks with the
#' sample metadata as annotations.
#'
#' `data` is a list holding the experiment and its results,
#' `list(object = <SummarizedExperiment>, results = <data frame>)`, where the
#' results are a DESeq2 `results()` table (a `DataFrame` will do), an edgeR
#' `topTags()` table, a limma `topTable()` or any table with an adjusted p-value
#' and a log2 fold change per gene; or a `SummarizedExperiment` whose `rowData`
#' carries those columns. Results are matched to the experiment's genes through
#' its row names, by the results' row names or an identifier column.
#'
#' The heatmap is drawn by [VizModules::ComplexHeatmap_HeatmapInputsUI()], so
#' its scaling, clustering, colour, label and annotation controls all apply;
#' those inputs are documented there. The rows carry `direction` ("Up"/"Down")
#' and `log2FC` as row annotations; every `colData` column is available as a
#' column annotation, keyed by the `sample` column.
#'
#' **This module is not plotly.** It renders through InteractiveComplexHeatmap,
#' so the shared plotly tabs do not apply, and it needs ComplexHeatmap,
#' InteractiveComplexHeatmap and circlize.
#'
#' @section Plot parameters and defaults:
#' The following parameters can be accessed via UI inputs and/or the `defaults` argument:
#'
#' - `de.id.col` - Results column matching the experiment's row names, or `""`
#'   for the results' row names (UI: "Gene ID Column", default: whichever matches
#'   best)
#' - `de.label.col` - Results column labelling the rows, or `""` for the
#'   identifier (UI: "Gene Label Column", default: `symbol` or similar when present)
#' - `de.padj.col`, `de.lfc.col` - Adjusted p-value and log2 fold change columns
#'   (UI: "Adj. P-value Column", "Log2 FC Column"; default: recognised DESeq2,
#'   edgeR, limma or Seurat names)
#' - `de.padj.cutoff` - Keep genes with an adjusted p-value below this (UI:
#'   "Adj. P-value Cut-off", default: 0.05)
#' - `de.lfc.cutoff` - Keep genes with an absolute log2 fold change of at least
#'   this (UI: "|Log2 FC| Cut-off", default: 1)
#' - `de.top.n` - The most genes to show (UI: "Top Genes", default: 50)
#' - `de.rank.by` - `"padj"` (most significant first) or `"lfc"` (largest fold
#'   change first) (UI: "Rank By", default: `"padj"`)
#' - `de.direction` - `"both"`, `"up"` or `"down"` (UI: "Direction", default: `"both"`)
#' - `de.assay`, `de.transform` - Assay and transformation, as for
#'   [sampleDistanceHeatmapInputsUI()] (default: `"counts"`, and `"vst"` when
#'   DESeq2 is installed, otherwise `"log2cpm"`)
#' - Wrapped heatmap defaults set here: `scale = "Rows"` (per-gene z-scores),
#'   the `direction` row annotation on the left with the rows split by it, the
#'   first two `colData` columns that group samples as column annotations, row labels at
#'   size 8, and `direction` colours `c(Up = "#B2182B", Down = "#2166AC")`
#' - All other [VizModules::ComplexHeatmap_HeatmapInputsUI()] parameters, except
#'   `matrix.cols` and `rowname.col`, which the module sets
#'
#' @param id The ID for the Shiny module.
#' @param data `list(object = <SummarizedExperiment>, results = <data frame>)`,
#'   or a `SummarizedExperiment` whose `rowData` holds the results.
#' @param defaults A named list of default values for the inputs.
#' @param title An optional title for the UI grid.
#' @param columns Number of columns for the UI grid.
#' @return A Shiny tagList containing the UI elements
#'
#' @import shiny
#'
#' @export
#' @author Jared Andrews
#' @seealso [VizModules::ComplexHeatmap_HeatmapInputsUI()], [sciVizModules::deHeatmapOutputUI()],
#' [sciVizModules::deHeatmapServer()], [sciVizModules::deHeatmapApp()]
#' @examples
#' library(sciVizModules)
#' data(airway_deseq2)
#' if (requireNamespace("ComplexHeatmap", quietly = TRUE) &&
#'     requireNamespace("airway", quietly = TRUE)) {
#'     data("airway", package = "airway")
#'     deHeatmapInputsUI("de", list(object = airway, results = airway_deseq2),
#'         defaults = list(de.transform = "log2cpm"))
#' }
deHeatmapInputsUI <- function(id, data, defaults = NULL, title = "DE Heatmap Settings", columns = 2) {
    ns <- NS(id)
    r <- .de_resolve(data)
    d <- .de_defaults(data, defaults)
    staged <- .se_stage(r$se, d$de.assay, d$de.transform)
    frame <- .de_heatmap_data(staged, r$results, d)

    res <- r$results
    num <- names(res)[vapply(res, is.numeric, logical(1))]
    chr <- names(res)[vapply(res, function(v) is.character(v) || is.factor(v), logical(1))]

    extras <- tagList(
        .sci_tip(viz_select_input(ns("de.id.col"), "Gene ID Column",
            choices = c("Row names" = "", stats::setNames(chr, chr)), selected = d$de.id.col
        ), "Results column whose values match the experiment's row names."),
        .sci_tip(viz_select_input(ns("de.label.col"), "Gene Label Column",
            choices = c("Gene ID" = "", stats::setNames(chr, chr)), selected = d$de.label.col
        ), "Results column used to label the rows, e.g. gene symbols."),
        .sci_tip(viz_select_input(ns("de.padj.col"), "Adj. P-value Column", choices = num, selected = d$de.padj.col),
            "Adjusted p-value (FDR) column of the results."),
        .sci_tip(viz_select_input(ns("de.lfc.col"), "Log2 FC Column", choices = num, selected = d$de.lfc.col),
            "Log2 fold change column of the results."),
        .sci_tip(numericInput(ns("de.padj.cutoff"), "Adj. P-value Cut-off",
            value = d$de.padj.cutoff, min = 0, max = 1, step = 0.01
        ), "Keep genes with an adjusted p-value below this."),
        .sci_tip(numericInput(ns("de.lfc.cutoff"), "|Log2 FC| Cut-off", value = d$de.lfc.cutoff, min = 0, step = 0.25),
            "Keep genes with an absolute log2 fold change of at least this."),
        .sci_tip(numericInput(ns("de.top.n"), "Top Genes", value = d$de.top.n, min = 2, step = 5),
            "The most genes to show."),
        .sci_tip(viz_select_input(ns("de.rank.by"), "Rank By",
            choices = c("Adjusted p-value" = "padj", "|Log2 fold change|" = "lfc"), selected = d$de.rank.by
        ), "Which genes count as the top ones."),
        .sci_tip(viz_select_input(ns("de.direction"), "Direction",
            choices = c("Up and down" = "both", "Up only" = "up", "Down only" = "down"), selected = d$de.direction
        ), "Show up-regulated genes, down-regulated genes, or both."),
        .sci_tip(viz_select_input(ns("de.assay"), "Assay", choices = .se_assays(r$se), selected = d$de.assay),
            "The assay the expression values are taken from."),
        .sci_tip(viz_select_input(ns("de.transform"), "Transformation",
            choices = .se_transform_choices(), selected = d$de.transform
        ), "How counts are transformed before the rows are scaled.")
    )

    .heatmap_wrapper_inputs_ui(id, extras, frame, .de_heat_defaults(frame, defaults), title, columns)
}


#' Output UI components for the deHeatmap module
#'
#' This should be placed in the UI where the plot should be shown. The heatmap
#' is an InteractiveComplexHeatmap widget, not a plotly figure.
#'
#' @param id The ID for the Shiny module.
#' @param resizable Accepted for consistency with the other modules; the
#'   widget sizes itself to its container.
#' @param ... Passed to [VizModules::ComplexHeatmap_HeatmapOutputUI()], e.g.
#'   `layout` or `compact`.
#' @return A Shiny tagList with the heatmap widget.
#'
#' @examples
#' if (requireNamespace("InteractiveComplexHeatmap", quietly = TRUE)) {
#'     deHeatmapOutputUI("de")
#' }
#' @export
#' @author Jared Andrews
deHeatmapOutputUI <- function(id, resizable = TRUE, ...) {
    .heatmap_wrapper_output_ui(id, resizable = resizable, ...)
}
