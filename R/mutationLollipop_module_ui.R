#' Input UI components for the mutationLollipop module
#'
#' This should be placed in the UI where the inputs should be shown, with an `id`
#' that matches the `id` used in the `mutationLollipopServer()` and
#' `mutationLollipopOutputUI()` functions.
#'
#' @details The module draws [mutationLollipop()]: one gene's non-synonymous
#' mutations along its protein, a stem per position and a point per protein
#' change, coloured by variant class, over the protein's domains. Its data is a
#' maftools `MAF` object or a data frame in MAF columns with a protein-change
#' column (see [mutationLollipop()]). Domains and the protein length come from
#' maftools' bundled domain table when maftools is installed, or from the
#' server's `domains` argument. The inputs are organised into tabs via
#' [VizModules::organize_inputs()].
#'
#' @section Plot parameters and defaults:
#' The following parameters can be accessed via UI inputs and/or the `defaults` argument:
#'
#' - `gene` - Gene to draw (default: the most often mutated)
#' - `label.top` - Most mutated positions to label (default: 3)
#' - `show.domains` - Draw the protein domains (default: TRUE)
#' - `point.size` - Marker size (default: 10)
#' - `palette.colours` - Named variant-class colours (multiColorPicker; default:
#'   maftools' palette)
#'
#' The Legend, Axes, Lines and Plotly tabs carry the shared VizModules inputs.
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
#' @seealso [mutationLollipop()], [sciVizModules::mutationLollipopOutputUI()],
#' [sciVizModules::mutationLollipopServer()], [sciVizModules::mutationLollipopApp()]
#' @examples
#' library(sciVizModules)
#' if (requireNamespace("maftools", quietly = TRUE)) {
#'     # The TCGA LAML cohort maftools ships, with its clinical annotations.
#'     laml <- read.delim(system.file("extdata", "tcga_laml.maf.gz", package = "maftools"),
#'         comment.char = "#")
#'     clinical <- read.delim(system.file("extdata", "tcga_laml_annot.tsv", package = "maftools"))
#'     laml <- merge(laml, clinical, by = "Tumor_Sample_Barcode")
#'     mutationLollipopInputsUI("lollipop", laml)
#' }
mutationLollipopInputsUI <- function(id, data, defaults = NULL, title = "Lollipop Settings", columns = 2) {
    ns <- NS(id)
    m <- .maf_validate(data)
    d <- .lollipop_defaults(m, defaults)

    data_tab <- tagList(
        .sci_tip(viz_select_input(ns("gene"), "Gene", choices = .maf_gene_summary(m)$Hugo_Symbol, selected = d$gene),
            "Gene to draw; genes are listed from most to least often mutated."),
        .sci_tip(numericInput(ns("label.top"), "Label Top Positions", value = d$label.top, min = 0, step = 1),
            "Label this many of the most mutated positions with their protein change."),
        .sci_tip(materialSwitch(ns("show.domains"), "Domains", value = isTRUE(d$show.domains), status = "success"),
            "Draw the protein's domains (from maftools' Pfam/SMART table, or the server's domains argument).")
    )
    aes_tab <- tagList(
        uiOutput(ns("palette.selection")),
        .sci_tip(numericInput(ns("point.size"), "Point Size", value = d$point.size, min = 2, step = 1),
            "Size of the mutation markers.")
    )

    .sci_plot_inputs_ui(ns, "mutationLollipop", data_tab, aes_tab, defaults, title, columns)
}


#' Output UI components for the mutationLollipop module
#'
#' @param id The ID for the Shiny module.
#' @param resizable Logical; when `TRUE` (the default) the plot output can be resized by dragging.
#' @return A Shiny plotlyOutput.
#'
#' @examples
#' mutationLollipopOutputUI("lollipop")
#' @export
#' @author Jared Andrews
mutationLollipopOutputUI <- function(id, resizable = TRUE) {
    .sci_plot_output_ui(id, "mutationLollipop", resizable = resizable, height = "450px")
}


#' Default inputs for the mutationLollipop module
#'
#' @param m A result of [.maf_table()].
#' @param defaults A named list of user defaults, or `NULL`.
#' @return A named list of defaults.
#'
#' @author Jared Andrews
#' @rdname INTERNAL_lollipop_defaults
#' @keywords internal
.lollipop_defaults <- function(m, defaults = NULL) {
    base <- list(gene = .maf_gene_summary(m)$Hugo_Symbol[1], label.top = 3, show.domains = TRUE, point.size = 10)
    lapply(stats::setNames(names(base), names(base)), function(k) get_default(defaults, k, base[[k]]))
}
