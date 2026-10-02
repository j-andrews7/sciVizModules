#' Input UI components for the gwasQQPlot module
#'
#' This should be placed in the UI where the inputs should be shown, with an `id`
#' that matches the `id` used in the `gwasQQPlotServer()` and
#' `gwasQQPlotOutputUI()` functions.
#'
#' @details The module draws a quantile-quantile plot of GWAS p-values: observed
#' against expected -log10(p) under the null, with the y = x line, a confidence
#' band, and the genomic inflation factor (lambda GC). Systematic departure along
#' the whole curve suggests inflation (population structure, cryptic
#' relatedness); departure only in the tail is the expected signature of true
#' associations. It wraps [VizModules::dittoViz_scatterPlotInputsUI()], whose
#' inputs are documented there.
#'
#' Expected values and lambda GC are computed from every variant; thinning (on
#' by default) only drops points from the plot.
#'
#' @section Plot parameters and defaults:
#' The following parameters can be accessed via UI inputs and/or the `defaults` argument:
#'
#' - `p.col`, `snp.col` - P-value and variant columns (default: detected)
#' - `show.band` - Draw the confidence band (default: TRUE)
#' - `ci.level` - Confidence level of the band (default: 0.95)
#' - `show.lambda` - Print lambda GC (default: TRUE)
#' - `thin`, `thin.p`, `thin.fraction` - Thinning, as in [manhattanPlotInputsUI()]
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
#' @seealso [sciVizModules::gwasQQPlotOutputUI()], [sciVizModules::gwasQQPlotServer()],
#' [sciVizModules::gwasQQPlotApp()], [sciVizModules::manhattanPlotInputsUI()]
#' @examples
#' library(sciVizModules)
#' data(example_gwas)
#' gwasQQPlotInputsUI("qq", example_gwas)
gwasQQPlotInputsUI <- function(id, data, defaults = NULL, title = "QQ Plot Settings", columns = 2) {
    ns <- NS(id)
    d <- .gwas_qq_defaults(data, defaults)
    .gwas_require_columns(d, "p.col")

    extras <- tagList(
        .gwas_column_inputs(ns, data, d, which = c("p.col", "snp.col")),
        .sci_tip(materialSwitch(ns("show.band"), "Confidence Band", value = isTRUE(d$show.band), status = "success"),
            "Shade where the observed p-values would fall under the null."),
        .sci_tip(numericInput(ns("ci.level"), "Band Level", value = d$ci.level, min = 0.5, max = 0.999, step = 0.01),
            "Confidence level of the band."),
        .sci_tip(materialSwitch(ns("show.lambda"), "Lambda GC", value = isTRUE(d$show.lambda), status = "success"),
            "Print the genomic inflation factor, computed from every variant."),
        .gwas_thin_inputs(ns, d)
    )

    tagList(
        organize_inputs(extras, columns = columns),
        dittoViz_scatterPlotInputsUI(
            id = id, data = .gwas_qq_frame(data, d$p.col, blank_to_null(d$snp.col)),
            defaults = d[setdiff(names(d), .gwas_qq_keys)],
            title = if (is.null(title) || inherits(title, c("shiny.tag", "shiny.tag.list"))) title else h3(title),
            columns = columns
        )
    )
}


#' Output UI components for the gwasQQPlot module
#'
#' @param id The ID for the Shiny module.
#' @param resizable Logical, whether to wrap the output in a resizable container.
#' @return A Shiny plotlyOutput for the QQ plot.
#'
#' @importFrom VizModules dittoViz_scatterPlotOutputUI
#'
#' @examples
#' gwasQQPlotOutputUI("qq")
#' @export
#' @author Jared Andrews
gwasQQPlotOutputUI <- function(id, resizable = TRUE) {
    dittoViz_scatterPlotOutputUI(id, resizable = resizable)
}
