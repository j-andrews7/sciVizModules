#' Read a macromolecular structure
#'
#' Reads a protein or nucleic-acid structure in PDB or mmCIF format (optionally
#' gzip-compressed) for [structureViewer()] and the structureViewer module.
#' The file text is kept as is for the viewer, and a per-residue table is taken
#' from its C-alpha atoms.
#'
#' AlphaFold and ColabFold models store the per-residue confidence (pLDDT) in
#' the B-factor column. When the file identifies itself as an AlphaFold model,
#' the result is flagged so the viewer colours by the AlphaFold DB pLDDT bands
#' by default; any structure can still be coloured that way.
#'
#' @param file Path to a `.pdb`, `.ent` or `.cif` / `.mmcif` file, optionally
#'   ending in `.gz`.
#' @return An object of class `"sci_structure"`: a list with `text` (the file
#'   contents), `format` (`"pdb"` or `"cif"`), `residues` (a data frame of
#'   `chain`, `residue`, `bfactor` and the pLDDT band `category`), `alphafold`
#'   (logical) and `file`.
#'
#' @seealso [structureViewer()], [read_alphafold()]
#' @export
#' @author Jared Andrews
#' @examples
#' p53 <- read_structure(system.file("extdata", "AF-P04637-F1-model_v6.pdb.gz",
#'     package = "sciVizModules"))
#' p53
read_structure <- function(file) {
    if (!file.exists(file)) stop("File not found: ", file, call. = FALSE)
    con <- gzfile(file, "rt")
    on.exit(close(con))
    lines <- readLines(con, warn = FALSE)

    is_cif <- grepl("[.](cif|mmcif)([.]gz)?$", file, ignore.case = TRUE) || any(startsWith(lines, "_atom_site."))
    ca <- tryCatch(
        if (is_cif) .af_ca_from_cif(lines) else .af_ca_from_pdb(lines),
        error = function(e) stop("Could not read '", basename(file), "' as a structure: ", conditionMessage(e),
            call. = FALSE)
    )
    if (nrow(ca) == 0) stop("No C-alpha atoms found in '", basename(file), "'.", call. = FALSE)
    names(ca)[names(ca) == "plddt"] <- "bfactor"
    ca$category <- .af_plddt_category(ca$bfactor)

    head_lines <- utils::head(lines, 60)
    alphafold <- any(grepl("alphafold", head_lines, ignore.case = TRUE)) || any(startsWith(lines, "_ma_qa_metric"))

    structure(
        list(text = paste(lines, collapse = "\n"), format = if (is_cif) "cif" else "pdb", residues = ca,
            alphafold = alphafold, file = file),
        class = "sci_structure"
    )
}


#' @export
print.sci_structure <- function(x, ...) {
    chains <- unique(x$residues$chain)
    cat("Structure (", x$format, "): ", nrow(x$residues), " residues in ", length(chains), " chain",
        if (length(chains) > 1) "s", " (", paste(chains, collapse = ", "), ")\n", sep = "")
    if (isTRUE(x$alphafold)) {
        cat("  AlphaFold model; mean pLDDT", round(mean(x$residues$bfactor, na.rm = TRUE), 1), "\n")
    }
    invisible(x)
}


#' Check that an object is from read_structure()
#'
#' @param x The object to check.
#' @param arg Argument name for the error message.
#' @return `x`, invisibly.
#'
#' @author Jared Andrews
#' @rdname INTERNAL_assert_structure
#' @keywords internal
.assert_structure <- function(x, arg = "data") {
    if (!inherits(x, "sci_structure")) {
        stop("'", arg, "' must be an object from read_structure().", call. = FALSE)
    }
    invisible(x)
}


#' The bundled example structure
#'
#' @return The AlphaFold DB model of human p53 (P04637), read with [read_structure()].
#'
#' @author Jared Andrews
#' @rdname INTERNAL_structure_example
#' @keywords internal
.structure_example <- function() {
    read_structure(system.file("extdata", "AF-P04637-F1-model_v6.pdb.gz", package = "sciVizModules"))
}
