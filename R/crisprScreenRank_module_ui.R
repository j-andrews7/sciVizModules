#' Input UI components for the crisprScreenRank module
#'
#' This should be placed in the UI where the inputs should be shown, with an `id`
#' that matches the `id` used in the `crisprScreenRankServer()` and
#' `crisprScreenRankOutputUI()` functions.
#'
#' @details The module draws the gene rank plot of a pooled CRISPR screen from a
#' MAGeCK gene summary ([read_mageck()]): every gene, ranked by the statistic on
#' the y-axis, with depleted (negative selection) genes on the left, enriched
#' (positive selection) genes on the right, hits below the FDR cut-off coloured
#' and the most extreme hits at each end labelled. Every statistic is signed:
#' negative for depletion, positive for enrichment.
#'
#' A `mageck test` (RRA) summary plots the log2 fold change, or the RRA score
#' or FDR of the side (depletion or enrichment) each gene scores better on. A
#' `mageck mle` summary plots the beta, z-score or FDR of one condition, the FDR
#' signed by the beta. It wraps
#' [VizModules::dittoViz_scatterPlotInputsUI()], so the scatter controls (point
#' highlighting by gene, hover data, colours) all apply; those inputs are
#' documented there.
#'
#' @section Plot parameters and defaults:
#' The following parameters can be accessed via UI inputs and/or the `defaults` argument:
#'
#' - `metric` - y-axis, and the statistic genes are ranked by: `"lfc"` (log2
#'   fold change; beta for MLE), `"score"` (signed -log10 RRA score; z-score for
#'   MLE) or `"fdr"` (signed -log10 FDR) (default: `"lfc"`)
#' - `condition` - MLE only: the condition plotted (default: the first)
#' - `fdr.threshold` - FDR below which a gene is a hit (default: 0.05)
#' - `n.labels` - Number of hits labelled at each end (default: 10)
#' - `label.size` - Label font size (default: 11)
#' - `color.panel` - Colours of "Depleted", "Enriched" and "n.s." (scatter colour picker)
#' - All other [VizModules::dittoViz_scatterPlotInputsUI()] parameters
#'
#' @param id The ID for the Shiny module.
#' @param data A MAGeCK RRA or MLE gene summary, from [read_mageck()] or read
#'   with `read.delim()`.
#' @param defaults A named list of default values for the inputs.
#' @param title An optional title for the UI grid.
#' @param columns Number of columns for the UI grid.
#' @return A Shiny tagList containing the UI elements
#'
#' @import shiny
#' @importFrom VizModules dittoViz_scatterPlotInputsUI
#'
#' @export
#' @author Jared Andrews
#' @seealso [read_mageck()], [sciVizModules::crisprScreenRankOutputUI()],
#' [sciVizModules::crisprScreenRankServer()], [sciVizModules::crisprScreenRankApp()]
#' @examples
#' library(sciVizModules)
#' screen <- read_mageck(system.file("extdata", "example_mageck.gene_summary.txt.gz",
#'     package = "sciVizModules"))
#' crisprScreenRankInputsUI("crispr", screen)
crisprScreenRankInputsUI <- function(id, data, defaults = NULL, title = "CRISPR Screen Settings", columns = 2) {
    ns <- NS(id)
    d <- .crispr_defaults(data, defaults)
    prepared <- .crispr_prepare(data, d$metric, d$fdr.threshold, d$condition)
    conds <- .mageck_conditions(data)

    extras <- tagList(
        if (length(conds)) {
            .sci_tip(viz_select_input(ns("condition"), "Condition", choices = conds, selected = d$condition),
                "The MLE condition (design matrix column) whose statistics are plotted.")
        },
        .sci_tip(viz_select_input(ns("metric"), "Y-axis",
            choices = .crispr_metric_labels(attr(prepared, "mageck_type")), selected = d$metric
        ), paste("Gene-level statistic on the y-axis, negative for depletion and positive for enrichment.",
            "Genes are ranked by it.")),
        .sci_tip(numericInput(ns("fdr.threshold"), "FDR Threshold",
            value = d$fdr.threshold, min = 0, max = 1, step = 0.01
        ), "Genes below this FDR are hits, depleted or enriched."),
        .sci_tip(numericInput(ns("n.labels"), "Label Top Hits", value = d$n.labels, min = 0, step = 1),
            "Number of hits to label at each end of the curve."),
        .sci_tip(numericInput(ns("label.size"), "Label Size", value = d$label.size, min = 4, step = 1),
            "Font size of the gene labels.")
    )

    tagList(
        organize_inputs(extras, columns = columns),
        dittoViz_scatterPlotInputsUI(
            id = id, data = prepared, defaults = d[setdiff(names(d), .crispr_keys)],
            title = if (is.null(title) || inherits(title, c("shiny.tag", "shiny.tag.list"))) title else h3(title),
            columns = columns
        )
    )
}


#' Output UI components for the crisprScreenRank module
#'
#' @param id The ID for the Shiny module.
#' @param resizable Logical, whether to wrap the output in a resizable container.
#' @return A Shiny plotlyOutput for the rank plot.
#'
#' @importFrom VizModules dittoViz_scatterPlotOutputUI
#'
#' @examples
#' crisprScreenRankOutputUI("crispr")
#' @export
#' @author Jared Andrews
crisprScreenRankOutputUI <- function(id, resizable = TRUE) {
    dittoViz_scatterPlotOutputUI(id, resizable = resizable)
}
