#' Input UI components for the mutationalProfile module
#'
#' This should be placed in the UI where the inputs should be shown, with an `id`
#' that matches the `id` used in the `mutationalProfileServer()` and
#' `mutationalProfileOutputUI()` functions.
#'
#' @details The user inputs for this module are separated from the outputs to allow for
#' more flexible UI design.
#'
#' The module draws the 96-channel single-base-substitution (SBS96) spectrum of
#' one or more samples: six substitution classes, each split by its 5' and 3'
#' neighbouring bases, one bar per channel, one panel per sample. The input is
#' the standard count matrix, as produced by MutationalPatterns
#' (`mut_matrix()`, 96 channels by samples), maftools
#' (`trinucleotideMatrix()$nmf_matrix`, samples by 96) or SigProfiler (a table
#' with a channel column and a column per sample); channels are matched by name
#' (e.g. `"A[C>A]A"`), so their order does not matter.
#'
#' The matrix is reshaped to a long table with columns `context`,
#' `substitution`, `sample`, `count` and `fraction` and drawn by
#' [VizModules::plotthis_BarPlotInputsUI()], so every bar-plot control applies;
#' those inputs are documented there. Switch the Y value between `fraction` (the
#' share of each sample's substitutions, the default) and `count`.
#'
#' @section Plot parameters and defaults:
#' The wrapped bar module's defaults set here (any value supplied via `defaults`
#' takes precedence):
#'
#' - `x.data` - `"context"`, the 96 channels in canonical order
#' - `y.data` - `"fraction"` (or `"count"`)
#' - `fill.by` - `"substitution"`, coloured by the MutationalPatterns six-class
#'   palette (`palette.colours`)
#' - `group.by` - `""`
#' - `facet.by` - `"sample"`, with `facet.scale = "free_y"` and `facet.ncol = 1`
#' - `axis.tickangle.x` - -90, with `axis.tickfont.size` 7
#' - All other [VizModules::plotthis_BarPlotInputsUI()] parameters
#'
#' @param id The ID for the Shiny module.
#' @param data A 96-channel substitution count matrix or data frame (see Details).
#' @param defaults A named list of default values for the inputs.
#' @param title An optional title for the UI grid.
#' @param columns Number of columns for the UI grid.
#' @return A Shiny tagList containing the UI elements
#'
#' @import shiny
#' @importFrom VizModules plotthis_BarPlotInputsUI
#'
#' @export
#' @author Jared Andrews
#' @seealso [VizModules::plotthis_BarPlotInputsUI()], [sciVizModules::mutationalProfileOutputUI()],
#' [sciVizModules::mutationalProfileServer()], [sciVizModules::mutationalProfileApp()]
#' @examples
#' library(sciVizModules)
#' data(example_sbs96)
#' mutationalProfileInputsUI("sbs", example_sbs96)
mutationalProfileInputsUI <- function(id, data, defaults = NULL, title = "Mutational Profile Settings",
                                      columns = 2) {
    plotthis_BarPlotInputsUI(
        id = id,
        data = .sbs96_long(data),
        defaults = .sbs96_defaults(defaults),
        title = if (is.null(title) || inherits(title, c("shiny.tag", "shiny.tag.list"))) title else h3(title),
        columns = columns
    )
}


#' Output UI components for the mutationalProfile module
#'
#' This should be placed in the UI where the plot should be shown.
#'
#' @param id The ID for the Shiny module.
#' @param resizable Logical; when `TRUE` (the default) the plot output is
#'   wrapped in [shinyjqui::jqui_resizable()] so it can be resized by dragging.
#' @param height CSS height of the output. The default leaves room for a few
#'   stacked sample panels.
#'
#' @return A Shiny plotlyOutput for the spectrum.
#'
#' @import shiny
#' @importFrom plotly plotlyOutput
#' @importFrom shinyjqui jqui_resizable
#'
#' @examples
#' mutationalProfileOutputUI("sbs")
#' @export
#' @author Jared Andrews
mutationalProfileOutputUI <- function(id, resizable = TRUE, height = "700px") {
    # The output id the wrapped bar module renders to; plotthis_BarPlotOutputUI()
    # itself has no height argument.
    out <- plotlyOutput(NS(id)("BarPlot"), height = height)
    if (isTRUE(resizable)) out <- jqui_resizable(out)
    out
}
