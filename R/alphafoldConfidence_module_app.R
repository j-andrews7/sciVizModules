#' Create a standalone Shiny app for the alphafoldConfidence module
#'
#' Generates a Shiny application with a selector over the supplied AlphaFold
#' predictions, a read-only preview of the selected prediction's per-residue
#' pLDDT, and the confidence plot with its settings.
#'
#' When `af_list` is not provided (or `NULL`), the app launches with the bundled
#' AlphaFold DB prediction for human p53 (UniProt P04637; AlphaFold DB, CC-BY 4.0).
#'
#' @param af_list An optional named list of objects from [read_alphafold()].
#' @return A Shiny app object.
#'
#' @seealso [read_alphafold()], [sciVizModules::alphafoldConfidenceInputsUI()],
#' [sciVizModules::alphafoldConfidenceOutputUI()], [sciVizModules::alphafoldConfidenceServer()]
#'
#' @export
#' @author Jared Andrews
#' @examples
#' library(sciVizModules)
#' app <- alphafoldConfidenceApp()
#' if (interactive()) shiny::runApp(app)
alphafoldConfidenceApp <- function(af_list = NULL) {
    if (is.null(af_list)) {
        af_list <- list("TP53 (P04637)" = .af_example())
    }
    .sci_object_app(
        inputs_ui_fn = alphafoldConfidenceInputsUI,
        output_ui_fn = alphafoldConfidenceOutputUI,
        server_fn    = alphafoldConfidenceServer,
        object_list  = af_list,
        title        = "AlphaFold Confidence",
        validate     = function(x) .assert_alphafold(x, "af_list element"),
        preview      = function(x) x$plddt,
        select_label = "Select Prediction:",
        preview_title = "Per-residue pLDDT",
        preview_note = "Read-only preview of the prediction's per-residue confidence."
    )
}
