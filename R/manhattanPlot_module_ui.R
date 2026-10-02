#' Input UI components for the manhattanPlot module
#'
#' This should be placed in the UI where the inputs should be shown, with an `id`
#' that matches the `id` used in the `manhattanPlotServer()` and
#' `manhattanPlotOutputUI()` functions.
#'
#' @details The module draws a Manhattan plot of GWAS summary statistics: each
#' variant's -log10(p) against its position along the genome, chromosomes laid
#' end to end in alternating colours, with genome-wide and suggestive
#' significance lines. It wraps [VizModules::dittoViz_scatterPlotInputsUI()], so
#' point labelling (`annotate.by` / `highlight.points`), hover data, colours and
#' the other scatter controls all apply; those inputs are documented there.
#'
#' Columns are detected from the usual names (qqman, PLINK, REGENIE, GWAS
#' Catalog harmonised): e.g. `CHR` / `chromosome`, `BP` / `POS` /
#' `base_pair_location`, `P` / `p_value`, `SNP` / `rsid` / `variant_id`. Large
#' summary statistics are thinned by default: every variant below `thin.p` is
#' kept, plus a reproducible `thin.fraction` of the rest; the source-data
#' download describes the plotted (thinned) variants.
#'
#' @section Plot parameters and defaults:
#' The following parameters can be accessed via UI inputs and/or the `defaults` argument:
#'
#' - `chr.col`, `bp.col`, `p.col`, `snp.col` - Chromosome, position, p-value and
#'   variant columns (default: detected)
#' - `sig.threshold` - Genome-wide significance line (default: 5e-8)
#' - `suggestive.threshold` - Suggestive line (default: 1e-5)
#' - `thin` - Thin the non-significant variants (default: TRUE)
#' - `thin.p` - Variants below this p-value are always kept (default: 0.01)
#' - `thin.fraction` - Fraction of the other variants kept (default: 0.25)
#' - `color.odd`, `color.even` - The two alternating chromosome colours seeding
#'   the colour picker (defaults only; default: dark and light blue)
#' - All other [VizModules::dittoViz_scatterPlotInputsUI()] parameters
#'
#' @param id The ID for the Shiny module.
#' @param data A data frame of GWAS summary statistics.
#' @param defaults A named list of default values for the inputs.
#' @param title An optional title for the UI grid.
#' @param columns Number of columns for the UI grid.
#' @return A Shiny tagList containing the UI elements
#'
#' @import shiny
#' @importFrom shinyWidgets materialSwitch
#' @importFrom VizModules dittoViz_scatterPlotInputsUI
#'
#' @export
#' @author Jared Andrews
#' @seealso [sciVizModules::manhattanPlotOutputUI()], [sciVizModules::manhattanPlotServer()],
#' [sciVizModules::manhattanPlotApp()], [sciVizModules::gwasQQPlotInputsUI()]
#' @examples
#' library(sciVizModules)
#' data(example_gwas)
#' manhattanPlotInputsUI("manhattan", example_gwas)
manhattanPlotInputsUI <- function(id, data, defaults = NULL, title = "Manhattan Plot Settings", columns = 2) {
    ns <- NS(id)
    d <- .manhattan_defaults(data, defaults)
    .gwas_require_columns(d)

    extras <- tagList(
        .gwas_column_inputs(ns, data, d),
        .sci_tip(numericInput(ns("sig.threshold"), "Genome-wide Threshold",
            value = d$sig.threshold, min = 0, max = 1, step = 1e-8
        ), "p-value of the genome-wide significance line (5e-8 by convention)."),
        .sci_tip(numericInput(ns("suggestive.threshold"), "Suggestive Threshold",
            value = d$suggestive.threshold, min = 0, max = 1, step = 1e-5
        ), "p-value of the suggestive significance line. Leave blank for none."),
        .gwas_thin_inputs(ns, d)
    )

    tagList(
        organize_inputs(extras, columns = columns),
        dittoViz_scatterPlotInputsUI(
            id = id, data = .gwas_prepare(data, d$chr.col, d$bp.col, d$p.col),
            defaults = d[setdiff(names(d), .manhattan_keys)],
            title = if (is.null(title) || inherits(title, c("shiny.tag", "shiny.tag.list"))) title else h3(title),
            columns = columns
        )
    )
}


#' Output UI components for the manhattanPlot module
#'
#' @param id The ID for the Shiny module.
#' @param resizable Logical, whether to wrap the output in a resizable container.
#' @return A Shiny plotlyOutput for the Manhattan plot.
#'
#' @importFrom VizModules dittoViz_scatterPlotOutputUI
#'
#' @examples
#' manhattanPlotOutputUI("manhattan")
#' @export
#' @author Jared Andrews
manhattanPlotOutputUI <- function(id, resizable = TRUE) {
    dittoViz_scatterPlotOutputUI(id, resizable = resizable)
}
