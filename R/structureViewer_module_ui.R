#' Input UI components for the structureViewer module
#'
#' This should be placed in the UI where the inputs should be shown, with an `id`
#' that matches the `id` used in the `structureViewerServer()` and
#' `structureViewerOutputUI()` functions.
#'
#' @details The module shows a protein or nucleic-acid structure from
#' [read_structure()] in an interactive 3D viewer (see [structureViewer()]).
#' Changing the style, colours or highlighted residues restyles the structure in
#' place, so the view you have rotated to is kept.
#'
#' This module is **not a plotly figure**: plotly has no molecular graphics, so
#' it uses the NGL viewer (NGLVieweR) instead. It therefore has no Figure Builder
#' support and no plotly export, and its control strip carries its own buttons:
#' **Snapshot (PNG)** saves the current view, and **Download Structure** saves
#' the structure file.
#'
#' @section Plot parameters and defaults:
#' The following parameters can be accessed via UI inputs and/or the `defaults` argument:
#'
#' - `representation` - Polymer representation (default: `"cartoon"`)
#' - `color.by` - Colour scheme: `"plddt"` (AlphaFold DB bands), `"bfactor"`,
#'   `"chainname"`, `"residueindex"`, `"sstruc"`, `"hydrophobicity"` or
#'   `"element"` (default: `"plddt"` for an AlphaFold model, else `"chainname"`)
#' - `background` - Background colour (default: "#FFFFFF")
#' - `quality` - Rendering quality (default: `"medium"`)
#' - `highlight.residues` - Residues to highlight, e.g. `"175, 245-250, B:12"`
#'   (default: none)
#' - `highlight.color` - Highlight colour (default: "#E7298A")
#' - `highlight.representation` - Highlight representation (default: `"ball+stick"`)
#' - `show.ligands` - Draw ligands and ions (default: TRUE)
#' - `spin` - Spin the structure (default: FALSE)
#'
#' @param id The ID for the Shiny module.
#' @param data An object from [read_structure()].
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
#' @seealso [structureViewer()], [read_structure()], [sciVizModules::structureViewerOutputUI()],
#' [sciVizModules::structureViewerServer()], [sciVizModules::structureViewerApp()]
#' @examples
#' library(sciVizModules)
#' p53 <- read_structure(system.file("extdata", "AF-P04637-F1-model_v6.pdb.gz",
#'     package = "sciVizModules"))
#' structureViewerInputsUI("viewer", p53)
structureViewerInputsUI <- function(id, data, defaults = NULL, title = "Structure Viewer Settings", columns = 2) {
    ns <- NS(id)
    .assert_structure(data)
    d <- .structure_defaults(data, defaults)

    inputs <- list(
        "Style" = tagList(
            .sci_tip(viz_select_input(ns("representation"), "Representation",
                choices = .structure_representations, selected = d$representation
            ), "How the polymer is drawn."),
            .sci_tip(viz_select_input(ns("color.by"), "Color By",
                choices = .structure_color_schemes, selected = d$color.by
            ), paste(
                "Colour scheme. pLDDT uses the AlphaFold DB confidence bands from the B-factor column",
                "(very high > 90, confident 70-90, low 50-70, very low < 50)."
            )),
            .sci_tip(colourInput(ns("background"), "Background", value = d$background), "Background colour."),
            .sci_tip(viz_select_input(ns("quality"), "Quality",
                choices = c("Low" = "low", "Medium" = "medium", "High" = "high"), selected = d$quality
            ), "Rendering quality; lower is faster for large structures.")
        ),
        "Highlight" = tagList(
            .sci_tip(textInput(ns("highlight.residues"), "Residues", value = d$highlight.residues,
                placeholder = "175, 245-250, B:12"
            ), "Residue numbers and ranges to highlight, optionally prefixed with a chain and a colon."),
            .sci_tip(colourInput(ns("highlight.color"), "Highlight Color", value = d$highlight.color),
                "Colour of the highlighted residues."),
            .sci_tip(viz_select_input(ns("highlight.representation"), "Highlight Style",
                choices = c("Ball and stick" = "ball+stick", "Licorice" = "licorice", "Spacefill" = "spacefill",
                    "Surface" = "surface"),
                selected = d$highlight.representation
            ), "How the highlighted residues are drawn.")
        ),
        "View" = tagList(
            .sci_tip(materialSwitch(ns("show.ligands"), "Ligands and Ions", value = isTRUE(d$show.ligands),
                status = "success"), "Draw ligands and ions as ball-and-stick."),
            .sci_tip(materialSwitch(ns("spin"), "Spin", value = isTRUE(d$spin), status = "success"),
                "Spin the structure about its vertical axis.")
        )
    )

    # The usual control strip carries a plotly source-data export; this module
    # is not plotly, so it has its own snapshot and structure download instead.
    tack <- div(
        class = "sci-structure-viewer-tack",
        actionButton(ns("reset"), "Reset", class = "btn-sm"),
        actionButton(ns("snapshot"), "Snapshot (PNG)", class = "btn-sm"),
        downloadButton(ns("download.structure"), "Download Structure", class = "btn-sm btn-secondary")
    )

    organize_inputs(
        inputs,
        id = ns("structureViewerTabsetPanel"),
        title = if (is.null(title) || inherits(title, c("shiny.tag", "shiny.tag.list"))) title else h3(title),
        tack = tack,
        columns = columns
    )
}


#' Output UI components for the structureViewer module
#'
#' @param id The ID for the Shiny module.
#' @param height Height of the viewer, as a valid CSS unit.
#' @return The viewer output.
#'
#' @importFrom NGLVieweR NGLVieweROutput
#'
#' @examples
#' structureViewerOutputUI("viewer")
#' @export
#' @author Jared Andrews
structureViewerOutputUI <- function(id, height = "600px") {
    NGLVieweR::NGLVieweROutput(NS(id)("structureViewer"), height = height)
}


#' Default inputs for the structureViewer module
#'
#' @param x An object from [read_structure()].
#' @param defaults A named list of user defaults, or `NULL`.
#' @return A named list of defaults.
#'
#' @author Jared Andrews
#' @rdname INTERNAL_structure_defaults
#' @keywords internal
.structure_defaults <- function(x, defaults = NULL) {
    base <- list(
        representation = "cartoon",
        color.by = if (isTRUE(x$alphafold)) "plddt" else "chainname",
        background = "#FFFFFF",
        quality = "medium",
        highlight.residues = "",
        highlight.color = "#E7298A",
        highlight.representation = "ball+stick",
        show.ligands = TRUE,
        spin = FALSE
    )
    lapply(stats::setNames(names(base), names(base)), function(k) get_default(defaults, k, base[[k]]))
}

# Representation and colour-scheme choices offered by the module.
.structure_representations <- c(
    "Cartoon" = "cartoon", "Backbone" = "backbone", "Ribbon" = "ribbon", "Rope" = "rope",
    "Surface" = "surface", "Ball and stick" = "ball+stick", "Licorice" = "licorice", "Spacefill" = "spacefill"
)
.structure_color_schemes <- c(
    "pLDDT (AlphaFold)" = "plddt", "B-factor" = "bfactor", "Chain" = "chainname",
    "Rainbow (N to C)" = "residueindex", "Secondary structure" = "sstruc",
    "Hydrophobicity" = "hydrophobicity", "Element" = "element"
)
