#' Create a standalone Shiny app for the structureViewer module
#'
#' Generates a Shiny application with a selector over the supplied structures,
#' a read-only preview of the selected structure's residues, and the 3D viewer
#' with its settings.
#'
#' When `structure_list` is not provided (or `NULL`), the app launches with the
#' bundled AlphaFold DB model of human p53 (UniProt P04637; AlphaFold DB,
#' CC-BY 4.0), coloured by pLDDT.
#'
#' @param structure_list An optional named list of objects from [read_structure()].
#' @return A Shiny app object.
#'
#' @seealso [read_structure()], [sciVizModules::structureViewerInputsUI()],
#' [sciVizModules::structureViewerOutputUI()], [sciVizModules::structureViewerServer()]
#'
#' @export
#' @author Jared Andrews
#' @examples
#' library(sciVizModules)
#' app <- structureViewerApp()
#' if (interactive()) shiny::runApp(app)
structureViewerApp <- function(structure_list = NULL) {
    if (is.null(structure_list)) {
        structure_list <- list("TP53 (P04637, AlphaFold)" = .structure_example())
    }
    .sci_object_app(
        inputs_ui_fn = structureViewerInputsUI,
        output_ui_fn = structureViewerOutputUI,
        server_fn    = structureViewerServer,
        object_list  = structure_list,
        title        = "Structure Viewer",
        validate     = function(x) .assert_structure(x, "structure_list element"),
        preview      = function(x) x$residues,
        select_label = "Select Structure:",
        preview_title = "Residues",
        preview_note = "Read-only preview of the structure's residues (C-alpha B-factor; pLDDT for AlphaFold models)."
    )
}
