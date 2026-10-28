#' Input UI components for the mafSummary module
#'
#' This should be placed in the UI where the inputs should be shown, with an `id`
#' that matches the `id` used in the `mafSummaryServer()` and
#' `mafSummaryOutputUI()` functions.
#'
#' @details The module draws [mafSummary()]: up to six panels summarising the
#' non-synonymous variants of a cohort (counts per variant classification, per
#' variant type and per substitution class, variants per sample, the per-sample
#' spread of each classification, and the most frequently mutated genes). Its
#' data is a maftools `MAF` object or a data frame in MAF columns (see
#' [oncoPlot()]). The inputs are organised into tabs via
#' [VizModules::organize_inputs()].
#'
#' @section Plot parameters and defaults:
#' The following parameters can be accessed via UI inputs and/or the `defaults` argument:
#'
#' - `panels` - Panels to draw (default: all six: `"classification"`, `"type"`,
#'   `"snv"`, `"per.sample"`, `"box"`, `"genes"`)
#' - `top.n` - Genes in the top-genes panel (default: 10)
#' - `show.median` - Mark the median variants per sample (default: TRUE)
#' - `palette.colours` - Named variant-class colours (multiColorPicker; default:
#'   maftools' palette)
#'
#' The Legend, Axes and Plotly tabs carry the shared VizModules inputs.
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
#'
#' @export
#' @author Jared Andrews
#' @seealso [mafSummary()], [sciVizModules::mafSummaryOutputUI()], [sciVizModules::mafSummaryServer()],
#' [sciVizModules::mafSummaryApp()]
#' @examples
#' library(sciVizModules)
#' if (requireNamespace("maftools", quietly = TRUE)) {
#'     # The TCGA LAML cohort maftools ships, with its clinical annotations.
#'     laml <- read.delim(system.file("extdata", "tcga_laml.maf.gz", package = "maftools"),
#'         comment.char = "#")
#'     clinical <- read.delim(system.file("extdata", "tcga_laml_annot.tsv", package = "maftools"))
#'     laml <- merge(laml, clinical, by = "Tumor_Sample_Barcode")
#'     mafSummaryInputsUI("summary", laml)
#' }
mafSummaryInputsUI <- function(id, data, defaults = NULL, title = "MAF Summary Settings", columns = 2) {
    ns <- NS(id)
    .maf_validate(data)
    d <- .mafsum_defaults(defaults)

    data_tab <- tagList(
        .sci_tip(viz_select_input(ns("panels"), "Panels", choices = .mafsum_panels, selected = d$panels,
            multiple = TRUE), "Summary panels to draw, three to a row."),
        .sci_tip(numericInput(ns("top.n"), "Top Genes", value = d$top.n, min = 1, step = 1),
            "Number of most often mutated genes in the top-genes panel."),
        .sci_tip(materialSwitch(ns("show.median"), "Median Line", value = isTRUE(d$show.median), status = "success"),
            "Mark the median number of variants per sample.")
    )
    aes_tab <- tagList(uiOutput(ns("palette.selection")))

    .sci_plot_inputs_ui(ns, "mafSummary", data_tab, aes_tab, defaults, title, columns, lines = FALSE)
}


#' Output UI components for the mafSummary module
#'
#' @param id The ID for the Shiny module.
#' @param resizable Logical; when `TRUE` (the default) the plot output can be resized by dragging.
#' @return A Shiny plotlyOutput.
#'
#' @examples
#' mafSummaryOutputUI("summary")
#' @export
#' @author Jared Andrews
mafSummaryOutputUI <- function(id, resizable = TRUE) {
    .sci_plot_output_ui(id, "mafSummary", resizable = resizable, height = "700px")
}


#' Default inputs for the mafSummary module
#'
#' @param defaults A named list of user defaults, or `NULL`.
#' @return A named list of defaults.
#'
#' @author Jared Andrews
#' @rdname INTERNAL_mafsum_defaults
#' @keywords internal
.mafsum_defaults <- function(defaults = NULL) {
    base <- list(panels = unname(.mafsum_panels), top.n = 10, show.median = TRUE)
    lapply(stats::setNames(names(base), names(base)), function(k) get_default(defaults, k, base[[k]]))
}
