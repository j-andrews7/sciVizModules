#' Input UI components for the alphafoldConfidence module
#'
#' This should be placed in the UI where the inputs should be shown, with an `id`
#' that matches the `id` used in the `alphafoldConfidenceServer()` and
#' `alphafoldConfidenceOutputUI()` functions.
#'
#' @details The module draws [alphafoldConfidence()] for an object from
#' [read_alphafold()]: the per-residue pLDDT over the AlphaFold DB confidence
#' bands, and the predicted aligned error heatmap on the same residue axis. The
#' inputs are organised into tabs via [VizModules::organize_inputs()].
#'
#' @section Plot parameters and defaults:
#' The following parameters can be accessed via UI inputs and/or the `defaults` argument:
#'
#' - `residue.start`, `residue.end` - Range of positions to show (default: all)
#' - `max.pae` - Top of the PAE colour scale in Angstroms (default: the file's maximum)
#' - `show.bands` - Shade the pLDDT confidence bands (default: TRUE)
#' - `show.chains` - Mark chain boundaries (default: TRUE)
#' - `track.height` - Fraction of the height given to the pLDDT track (default: 0.25)
#' - `line.color` - pLDDT line colour (default: "#333333")
#' - `band.very.high`, `band.confident`, `band.low`, `band.very.low` - Band and
#'   marker colours (default: the AlphaFold DB colours)
#' - `pae.low.color`, `pae.high.color` - PAE colours at zero and at `max.pae`
#'   (default: dark green to white, as AlphaFold DB)
#'
#' The Legend, Axes and Plotly tabs carry the shared VizModules inputs.
#'
#' @param id The ID for the Shiny module.
#' @param data An object from [read_alphafold()].
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
#' @seealso [alphafoldConfidence()], [read_alphafold()],
#' [sciVizModules::alphafoldConfidenceOutputUI()], [sciVizModules::alphafoldConfidenceServer()],
#' [sciVizModules::alphafoldConfidenceApp()]
#' @examples
#' library(sciVizModules)
#' af <- read_alphafold(
#'     pae = system.file("extdata", "AF-P04637-F1-predicted_aligned_error_v6.json.gz",
#'         package = "sciVizModules"),
#'     confidence = system.file("extdata", "AF-P04637-F1-confidence_v6.json.gz",
#'         package = "sciVizModules")
#' )
#' alphafoldConfidenceInputsUI("af", af)
alphafoldConfidenceInputsUI <- function(id, data, defaults = NULL, title = "AlphaFold Confidence Settings",
                                        columns = 2) {
    ns <- NS(id)
    .assert_alphafold(data)
    d <- .af_defaults(data, defaults)

    data_tab <- tagList(
        .sci_tip(numericInput(ns("residue.start"), "First Residue",
            value = d$residue.start, min = 1, max = nrow(data$plddt), step = 1
        ), "First position to show, counting along the prediction (across chains)."),
        .sci_tip(numericInput(ns("residue.end"), "Last Residue",
            value = d$residue.end, min = 1, max = nrow(data$plddt), step = 1
        ), "Last position to show."),
        .sci_tip(numericInput(ns("max.pae"), "Max PAE (\u00c5)",
            value = d$max.pae, min = 1, step = 1
        ), "Top of the PAE colour scale; errors at or above it get the high colour."),
        .sci_tip(numericInput(ns("track.height"), "pLDDT Track Height",
            value = d$track.height, min = 0.1, max = 0.6, step = 0.05
        ), "Fraction of the plot height given to the pLDDT track."),
        .sci_tip(materialSwitch(ns("show.bands"), "Confidence Bands",
            value = d$show.bands, status = "success"
        ), "Shade the pLDDT bands: very high > 90, confident 70-90, low 50-70, very low < 50."),
        .sci_tip(materialSwitch(ns("show.chains"), "Chain Boundaries",
            value = d$show.chains, status = "success"
        ), "Mark where one chain ends and the next begins (multimers).")
    )
    aes_tab <- tagList(
        .sci_tip(colourInput(ns("line.color"), "pLDDT Line Color", value = d$line.color),
            "Colour of the pLDDT line."),
        .sci_tip(colourInput(ns("band.very.high"), "Very High (> 90)", value = d$band.very.high),
            "Colour of the very high confidence band and markers."),
        .sci_tip(colourInput(ns("band.confident"), "Confident (70-90)", value = d$band.confident),
            "Colour of the confident band and markers."),
        .sci_tip(colourInput(ns("band.low"), "Low (50-70)", value = d$band.low),
            "Colour of the low confidence band and markers."),
        .sci_tip(colourInput(ns("band.very.low"), "Very Low (< 50)", value = d$band.very.low),
            "Colour of the very low confidence band and markers."),
        .sci_tip(colourInput(ns("pae.low.color"), "PAE Low Color", value = d$pae.low.color),
            "Colour of zero predicted aligned error."),
        .sci_tip(colourInput(ns("pae.high.color"), "PAE High Color", value = d$pae.high.color),
            "Colour of the maximum predicted aligned error.")
    )

    .sci_plot_inputs_ui(ns, "alphafoldConfidence", data_tab, aes_tab, defaults, title, columns, lines = FALSE)
}


#' Output UI components for the alphafoldConfidence module
#'
#' @param id The ID for the Shiny module.
#' @param resizable Logical; when `TRUE` (the default) the plot output can be resized by dragging.
#' @return A Shiny plotlyOutput for the confidence plot.
#'
#' @examples
#' alphafoldConfidenceOutputUI("af")
#' @export
#' @author Jared Andrews
alphafoldConfidenceOutputUI <- function(id, resizable = TRUE) {
    .sci_plot_output_ui(id, "alphafoldConfidence", resizable = resizable, height = "700px")
}


#' Default inputs for the alphafoldConfidence module
#'
#' Shared by the UI and the Reset handler. User values win.
#'
#' @param x An object from [read_alphafold()].
#' @param defaults A named list of user defaults, or `NULL`.
#' @return A named list of defaults.
#'
#' @author Jared Andrews
#' @rdname INTERNAL_af_defaults
#' @keywords internal
.af_defaults <- function(x, defaults = NULL) {
    base <- list(
        residue.start = 1,
        residue.end = nrow(x$plddt),
        max.pae = ceiling(x$max_pae %||% (if (is.null(x$pae)) 30 else max(x$pae, na.rm = TRUE))),
        track.height = 0.25,
        show.bands = TRUE,
        show.chains = TRUE,
        line.color = "#333333",
        band.very.high = "#0053D6",
        band.confident = "#65CBF3",
        band.low = "#FFDB13",
        band.very.low = "#FF7D45",
        pae.low.color = "#0B4D1F",
        pae.high.color = "#FFFFFF"
    )
    resolved <- lapply(stats::setNames(names(base), names(base)), function(k) get_default(defaults, k, base[[k]]))
    resolved
}


#' The bundled AlphaFold example
#'
#' The AlphaFold DB prediction for human p53 (P04637), read from the files in
#' `inst/extdata`.
#'
#' @return An object from [read_alphafold()].
#'
#' @author Jared Andrews
#' @rdname INTERNAL_af_example
#' @keywords internal
.af_example <- function() {
    read_alphafold(
        pae = system.file("extdata", "AF-P04637-F1-predicted_aligned_error_v6.json.gz", package = "sciVizModules"),
        confidence = system.file("extdata", "AF-P04637-F1-confidence_v6.json.gz", package = "sciVizModules")
    )
}
