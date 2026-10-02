#' Server logic for the alphafoldConfidence module
#'
#' Renders [alphafoldConfidence()] for an object from [read_alphafold()]. The
#' per-residue pLDDT table is included in the source-data download as the
#' statistics table.
#'
#' @param id The ID for the Shiny module.
#' @param data A `reactive` returning an object from [read_alphafold()].
#' @param hide.inputs A character vector of input IDs to hide.
#' @param hide.tabs A character vector of tab names to hide.
#' @param defaults A named list of default values used when resetting the inputs.
#'   Typically the same list passed to [alphafoldConfidenceInputsUI()].
#' @return A `reactive` returning the source-data list.
#'
#' @import shiny
#' @importFrom shinyWidgets updateMaterialSwitch
#' @importFrom colourpicker updateColourInput
#'
#' @seealso [alphafoldConfidence()], [read_alphafold()],
#' [sciVizModules::alphafoldConfidenceInputsUI()], [sciVizModules::alphafoldConfidenceOutputUI()],
#' [sciVizModules::alphafoldConfidenceApp()]
#' @examples
#' library(sciVizModules)
#' if (interactive()) alphafoldConfidenceApp()
#' @export
#' @author Jared Andrews
alphafoldConfidenceServer <- function(id, data, hide.inputs = NULL, hide.tabs = NULL, defaults = NULL) {
    .sci_plot_server(
        id, data, hide.inputs, hide.tabs, defaults,
        name = "alphafoldConfidence",
        validate = .assert_alphafold,
        build = function(x, input, isolate_fn, state) {
            alphafoldConfidence(
                x,
                residue.start = isolate_fn(input$residue.start),
                residue.end = isolate_fn(input$residue.end),
                max.pae = na_to_null(isolate_fn(input$max.pae)),
                show.bands = isTRUE(isolate_fn(input$show.bands)),
                show.chains = isTRUE(isolate_fn(input$show.chains)),
                band.colors = c(
                    isolate_fn(input$band.very.high) %||% "#0053D6",
                    isolate_fn(input$band.confident) %||% "#65CBF3",
                    isolate_fn(input$band.low) %||% "#FFDB13",
                    isolate_fn(input$band.very.low) %||% "#FF7D45"
                ),
                line.color = isolate_fn(input$line.color) %||% "#333333",
                pae.low.color = isolate_fn(input$pae.low.color) %||% "#0B4D1F",
                pae.high.color = isolate_fn(input$pae.high.color) %||% "#FFFFFF",
                track.height = isolate_fn(input$track.height) %||% 0.25
            )
        },
        reset = function(session, x, defaults, state) {
            d <- .af_defaults(x, defaults)
            for (k in c("residue.start", "residue.end", "max.pae", "track.height")) {
                updateNumericInput(session, k, value = d[[k]])
            }
            for (k in c("show.bands", "show.chains")) {
                updateMaterialSwitch(session, k, value = d[[k]])
            }
            for (k in c("line.color", "band.very.high", "band.confident", "band.low", "band.very.low",
                "pae.low.color", "pae.high.color")) {
                updateColourInput(session, k, value = d[[k]])
            }
        }
    )
}
