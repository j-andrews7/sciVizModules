#' Interactive 3D structure viewer
#'
#' Renders a protein or nucleic-acid structure in an interactive 3D viewer
#' (NGL, through the NGLVieweR package): rotate, zoom, and hover over residues.
#' Unlike the other modules this is not a plotly figure - plotly has no
#' molecular graphics - so it has no Figure Builder support and no plotly
#' export; save an image with the viewer's own snapshot.
#'
#' @details Colour schemes:
#' \describe{
#'   \item{`"plddt"`}{AlphaFold confidence in the AlphaFold DB bands, from the
#'     B-factor column: very high (> 90), confident (70-90), low (50-70) and very
#'     low (< 50). Each band is drawn as its own representation, so the colours
#'     are exact rather than interpolated.}
#'   \item{`"bfactor"`}{The B-factor column on a continuous scale.}
#'   \item{`"chainname"`, `"residueindex"`, `"sstruc"`, `"hydrophobicity"`,
#'     `"element"`}{NGL's schemes: by chain, rainbow along the sequence, by
#'     secondary structure, by residue hydrophobicity, and by element.}
#' }
#'
#' Residues to highlight are written as a comma-separated list of residue
#' numbers and ranges, optionally prefixed with a chain: `"175, 245-250, B:12"`.
#'
#' @param x An object from [read_structure()].
#' @param representation NGL representation for the polymer: `"cartoon"`,
#'   `"backbone"`, `"ribbon"`, `"rope"`, `"surface"`, `"ball+stick"`,
#'   `"licorice"` or `"spacefill"`.
#' @param color.by Colour scheme (see Details). Default: `"plddt"` for an
#'   AlphaFold model, else `"chainname"`.
#' @param highlight Residues to highlight, as text (see Details), or `NULL`.
#' @param highlight.color Colour of the highlighted residues.
#' @param highlight.representation Representation of the highlighted residues.
#' @param show.ligands Logical; draw ligands and ions as ball-and-stick.
#' @param background Background colour.
#' @param spin Logical; spin the structure.
#' @param quality Rendering quality: `"low"`, `"medium"` or `"high"`.
#' @param band.colors Colours of the four pLDDT bands, from very high to very low
#'   (the AlphaFold DB colours by default).
#'
#' @return An `NGLVieweR` htmlwidget.
#'
#' @importFrom NGLVieweR NGLVieweR addRepresentation stageParameters setQuality setSpin
#' @seealso [read_structure()], [structureViewerServer()]
#' @export
#' @author Jared Andrews
#' @examples
#' p53 <- read_structure(system.file("extdata", "AF-P04637-F1-model_v6.pdb.gz",
#'     package = "sciVizModules"))
#' if (interactive()) structureViewer(p53, highlight = "175, 248, 273")
structureViewer <- function(x, representation = "cartoon", color.by = NULL, highlight = NULL,
                            highlight.color = "#E7298A", highlight.representation = "ball+stick",
                            show.ligands = TRUE, background = "#FFFFFF", spin = FALSE, quality = "medium",
                            band.colors = c("#0053D6", "#65CBF3", "#FFDB13", "#FF7D45")) {
    .assert_structure(x, "x")
    selections <- .structure_selections(
        x,
        representation = representation, color.by = color.by, highlight = highlight,
        highlight.color = highlight.color, highlight.representation = highlight.representation,
        show.ligands = show.ligands, band.colors = band.colors
    )

    viewer <- NGLVieweR::NGLVieweR(x$text, format = x$format)
    for (s in selections) {
        viewer <- NGLVieweR::addRepresentation(viewer, s$type, param = s$param)
    }
    viewer <- NGLVieweR::stageParameters(viewer, backgroundColor = background)
    viewer <- NGLVieweR::setQuality(viewer, quality = quality)
    if (isTRUE(spin)) viewer <- NGLVieweR::setSpin(viewer, spin = TRUE)
    viewer
}


#' The named representations a structure is drawn with
#'
#' Shared by [structureViewer()] (initial render) and the module's proxy updates
#' (restyling without reloading), so both draw the same thing. Each element is
#' `list(type, param)` with `param$name` set, so a representation can later be
#' removed by name.
#'
#' @inheritParams structureViewer
#' @return A list of representations.
#'
#' @author Jared Andrews
#' @rdname INTERNAL_structure_selections
#' @keywords internal
.structure_selections <- function(x, representation = "cartoon", color.by = NULL, highlight = NULL,
                                  highlight.color = "#E7298A", highlight.representation = "ball+stick",
                                  show.ligands = TRUE, band.colors = c("#0053D6", "#65CBF3", "#FFDB13", "#FF7D45")) {
    color.by <- color.by %||% if (isTRUE(x$alphafold)) "plddt" else "chainname"
    representation <- representation %||% "cartoon"
    out <- list()

    if (identical(color.by, "plddt")) {
        bands <- levels(x$residues$category)
        for (i in seq_along(bands)) {
            sele <- .structure_sele(x$residues[x$residues$category %in% bands[i], , drop = FALSE])
            if (is.null(sele)) next
            out[[length(out) + 1]] <- list(type = representation, param = list(
                name = paste0("band.", i), sele = sele, color = band.colors[i]
            ))
        }
    } else {
        param <- list(name = "main", sele = "polymer", colorScheme = color.by)
        if (identical(color.by, "bfactor")) param$colorScale <- "RdYlBu"
        out[[length(out) + 1]] <- list(type = representation, param = param)
    }

    if (isTRUE(show.ligands)) {
        out[[length(out) + 1]] <- list(type = "ball+stick", param = list(
            name = "ligand", sele = "(ligand or ion) and not water"
        ))
    }

    hl <- .structure_parse_highlight(highlight)
    if (!is.null(hl)) {
        out[[length(out) + 1]] <- list(type = highlight.representation %||% "ball+stick", param = list(
            name = "highlight", sele = hl, color = highlight.color
        ))
    }
    out
}


#' NGL selection string for a set of residues
#'
#' Collapses consecutive residue numbers within each chain into ranges, e.g.
#' `"1-40:A or 95-290:A"`.
#'
#' @param res A data frame with `chain` and `residue`.
#' @return A selection string, or `NULL` for no residues.
#'
#' @author Jared Andrews
#' @rdname INTERNAL_structure_sele
#' @keywords internal
.structure_sele <- function(res) {
    if (is.null(res) || nrow(res) == 0) {
        return(NULL)
    }
    parts <- unlist(lapply(split(res$residue, res$chain), function(r) {
        r <- sort(unique(r))
        breaks <- c(0, which(diff(r) != 1), length(r))
        vapply(seq_len(length(breaks) - 1), function(i) {
            run <- r[(breaks[i] + 1):breaks[i + 1]]
            if (length(run) == 1) as.character(run) else paste0(run[1], "-", run[length(run)])
        }, character(1))
    }), use.names = TRUE)
    chains <- sub("[.].*$", "", sub("[0-9]+$", "", names(parts)))
    paste0(parts, ifelse(nzchar(chains), paste0(":", chains), ""), collapse = " or ")
}


#' Parse typed residues into an NGL selection
#'
#' Accepts residue numbers and ranges separated by commas or spaces, each
#' optionally prefixed with a chain and a colon: `"175, 245-250, B:12"`.
#'
#' @param text The typed residues, or `NULL`.
#' @return An NGL selection string, or `NULL` when nothing valid was given.
#'
#' @author Jared Andrews
#' @rdname INTERNAL_structure_parse_highlight
#' @keywords internal
.structure_parse_highlight <- function(text) {
    if (!nz_value(text)) {
        return(NULL)
    }
    tokens <- strsplit(trimws(text), "[,;[:space:]]+")[[1]]
    tokens <- tokens[nzchar(tokens)]
    out <- vapply(tokens, function(tok) {
        chain <- ""
        if (grepl(":", tok, fixed = TRUE)) {
            chain <- sub(":.*$", "", tok)
            tok <- sub("^[^:]*:", "", tok)
        }
        if (!grepl("^[0-9]+(-[0-9]+)?$", tok)) {
            return(NA_character_)
        }
        if (nzchar(chain)) paste0(tok, ":", chain) else tok
    }, character(1), USE.NAMES = FALSE)
    out <- out[!is.na(out)]
    if (length(out) == 0) NULL else paste(out, collapse = " or ")
}
