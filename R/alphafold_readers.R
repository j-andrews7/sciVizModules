#' Read AlphaFold confidence outputs
#'
#' Reads the per-residue confidence (pLDDT) and the predicted aligned error
#' (PAE) of an AlphaFold prediction into one object for
#' [alphafoldConfidence()] and the alphafoldConfidence module. Files may be
#' gzip-compressed.
#'
#' @details
#' Accepted inputs:
#' \itemize{
#'   \item `pae`: the AlphaFold DB `*-predicted_aligned_error_v*.json` (current
#'     `predicted_aligned_error` matrix, or the older `residue1` / `residue2` /
#'     `distance` arrays), or a ColabFold `*_scores_*.json`, which holds both the
#'     PAE (`pae`, `max_pae`) and the pLDDT (`plddt`).
#'   \item `confidence`: the AlphaFold DB `*-confidence_v*.json`
#'     (`residueNumber`, `confidenceScore`).
#'   \item `structure`: the predicted model as `.pdb` or mmCIF (`.cif`).
#'     AlphaFold writes the pLDDT into the B-factor column, so this gives the
#'     pLDDT and, for a multimer, the chain of each residue (read from the
#'     C-alpha atoms).
#' }
#'
#' The pLDDT comes from `confidence` if given, else the ColabFold scores, else
#' `structure`; chain IDs come from `structure` when it is given. AlphaFold 3
#' `*_full_data_*.json` output is not yet supported.
#'
#' AlphaFold DB data is available under CC-BY 4.0. Please cite Jumper et al.
#' (2021) Nature 596:583-589 and Varadi et al. (2024) Nucleic Acids Research
#' 52:D368-D375 when using it.
#'
#' @param pae Path to a PAE JSON (AlphaFold DB or ColabFold scores), or `NULL`.
#' @param confidence Path to an AlphaFold DB confidence JSON, or `NULL`.
#' @param structure Path to a `.pdb` or `.cif` model, or `NULL`.
#'
#' @return An object of class `"alphafold_confidence"`: a list with
#'   \describe{
#'     \item{plddt}{A data frame with `index` (position along the prediction),
#'       `chain`, `residue` and `plddt`, plus the AlphaFold DB `category`
#'       ("Very high" > 90, "Confident" 70-90, "Low" 50-70, "Very low" < 50).}
#'     \item{pae}{The PAE matrix (Angstroms; row = aligned residue, column =
#'       scored residue), or `NULL`.}
#'     \item{max_pae}{The maximum possible PAE reported by the file, or `NULL`.}
#'     \item{files}{The files read.}
#'   }
#'
#' @importFrom jsonlite fromJSON
#' @seealso [alphafoldConfidence()], [alphafoldConfidenceServer()]
#' @export
#' @author Jared Andrews
#' @examples
#' af <- read_alphafold(
#'     pae = system.file("extdata", "AF-P04637-F1-predicted_aligned_error_v6.json.gz",
#'         package = "sciVizModules"),
#'     confidence = system.file("extdata", "AF-P04637-F1-confidence_v6.json.gz",
#'         package = "sciVizModules")
#' )
#' af
read_alphafold <- function(pae = NULL, confidence = NULL, structure = NULL) {
    if (is.null(pae) && is.null(confidence) && is.null(structure)) {
        stop("Give at least one of `pae`, `confidence` or `structure`.", call. = FALSE)
    }

    pae_mat <- NULL
    max_pae <- NULL
    plddt <- NULL

    if (!is.null(pae)) {
        js <- .af_read_json(pae)
        if (!is.null(js$predicted_aligned_error)) {
            pae_mat <- .af_matrix(js$predicted_aligned_error)
            max_pae <- .af_scalar(js$max_predicted_aligned_error)
        } else if (!is.null(js$distance) && !is.null(js$residue1)) {
            n <- max(unlist(js$residue1))
            pae_mat <- matrix(as.numeric(unlist(js$distance)), nrow = n, ncol = n, byrow = TRUE)
        } else if (!is.null(js$pae)) {
            pae_mat <- .af_matrix(js$pae)
            max_pae <- .af_scalar(js$max_pae)
            if (!is.null(js$plddt)) {
                scores <- as.numeric(unlist(js$plddt))
                plddt <- data.frame(residue = seq_along(scores), plddt = scores)
            }
        } else {
            stop("'", basename(pae), "' is not an AlphaFold DB PAE file or a ColabFold scores file ",
                "(no 'predicted_aligned_error' or 'pae' field).", call. = FALSE)
        }
    }

    if (!is.null(confidence)) {
        js <- .af_read_json(confidence)
        if (is.null(js$confidenceScore)) {
            stop("'", basename(confidence), "' is not an AlphaFold DB confidence file ",
                "(no 'confidenceScore' field).", call. = FALSE)
        }
        scores <- as.numeric(unlist(js$confidenceScore))
        plddt <- data.frame(
            residue = as.integer(unlist(js$residueNumber %||% seq_along(scores))),
            plddt = scores
        )
    }

    if (!is.null(structure)) {
        ca <- .af_read_structure(structure)
        if (is.null(plddt)) {
            plddt <- ca
        } else if (nrow(ca) == nrow(plddt)) {
            plddt$chain <- ca$chain
            plddt$residue <- ca$residue
        } else {
            warning("The structure has ", nrow(ca), " residues but the confidence file ", nrow(plddt),
                "; chain IDs were not taken from the structure.", call. = FALSE)
        }
    }

    if (is.null(plddt)) {
        if (is.null(pae_mat)) stop("No pLDDT or PAE could be read.", call. = FALSE)
        plddt <- data.frame(residue = seq_len(nrow(pae_mat)), plddt = NA_real_)
    }
    if (is.null(plddt$chain)) plddt$chain <- "A"
    if (!is.null(pae_mat) && nrow(pae_mat) != nrow(plddt)) {
        stop("The PAE matrix covers ", nrow(pae_mat), " residues but the pLDDT ", nrow(plddt), ".", call. = FALSE)
    }

    plddt$index <- seq_len(nrow(plddt))
    plddt$category <- .af_plddt_category(plddt$plddt)
    plddt <- plddt[, c("index", "chain", "residue", "plddt", "category")]

    structure(
        list(plddt = plddt, pae = pae_mat, max_pae = max_pae,
            files = c(pae = pae %||% NA, confidence = confidence %||% NA, structure = structure %||% NA)),
        class = "alphafold_confidence"
    )
}


#' @export
print.alphafold_confidence <- function(x, ...) {
    chains <- unique(x$plddt$chain)
    cat("AlphaFold confidence:", nrow(x$plddt), "residues",
        if (length(chains) > 1) paste0("in ", length(chains), " chains (", paste(chains, collapse = ", "), ")"),
        "\n")
    if (any(!is.na(x$plddt$plddt))) {
        cat("  mean pLDDT:", round(mean(x$plddt$plddt, na.rm = TRUE), 1), "\n")
    }
    cat("  PAE:", if (is.null(x$pae)) "none" else paste(dim(x$pae), collapse = " x "), "\n")
    invisible(x)
}


#' Check that an object is from read_alphafold()
#'
#' @param x The object to check.
#' @param arg Argument name for the error message.
#' @return `x`, invisibly.
#'
#' @author Jared Andrews
#' @rdname INTERNAL_assert_alphafold
#' @keywords internal
.assert_alphafold <- function(x, arg = "data") {
    if (!inherits(x, "alphafold_confidence")) {
        stop("'", arg, "' must be an object from read_alphafold().", call. = FALSE)
    }
    invisible(x)
}


#' AlphaFold DB pLDDT confidence bands
#'
#' @param x Numeric pLDDT values.
#' @return A factor with levels "Very high", "Confident", "Low", "Very low".
#'
#' @author Jared Andrews
#' @rdname INTERNAL_af_plddt_category
#' @keywords internal
.af_plddt_category <- function(x) {
    out <- cut(x, c(-Inf, 50, 70, 90, Inf), labels = c("Very low", "Low", "Confident", "Very high"), right = FALSE)
    factor(out, levels = c("Very high", "Confident", "Low", "Very low"))
}


#' Read a (possibly gzipped) JSON file
#'
#' @param path File path.
#' @return The parsed JSON. A one-element top-level array (the AlphaFold DB
#'   PAE layout) is unwrapped.
#'
#' @author Jared Andrews
#' @rdname INTERNAL_af_read_json
#' @keywords internal
.af_read_json <- function(path) {
    if (!file.exists(path)) stop("File not found: ", path, call. = FALSE)
    con <- gzfile(path, "rt")
    on.exit(close(con))
    js <- tryCatch(
        jsonlite::fromJSON(paste(readLines(con, warn = FALSE), collapse = "\n"), simplifyVector = TRUE),
        error = function(e) stop("'", basename(path), "' is not valid JSON: ", conditionMessage(e), call. = FALSE)
    )
    if (is.data.frame(js) && nrow(js) == 1) {
        js <- lapply(as.list(js), function(col) if (is.list(col)) col[[1]] else col)
    } else if (is.list(js) && is.null(names(js)) && length(js) == 1) {
        js <- js[[1]]
    }
    js
}


#' Coerce a parsed JSON matrix to a numeric matrix
#'
#' @param x A matrix, or a list of rows.
#' @return A numeric matrix.
#'
#' @author Jared Andrews
#' @rdname INTERNAL_af_matrix
#' @keywords internal
.af_matrix <- function(x) {
    if (is.list(x)) x <- do.call(rbind, lapply(x, as.numeric))
    m <- as.matrix(x)
    storage.mode(m) <- "double"
    m
}


#' First value of a parsed JSON scalar, or NULL
#'
#' @param x A value from parsed JSON.
#' @return A numeric scalar or `NULL`.
#'
#' @author Jared Andrews
#' @rdname INTERNAL_af_scalar
#' @keywords internal
.af_scalar <- function(x) {
    if (is.null(x) || length(x) == 0) NULL else as.numeric(unlist(x))[1]
}


#' Per-residue pLDDT and chains from a model's C-alpha B-factors
#'
#' @param path A `.pdb` or `.cif` file (optionally gzipped).
#' @return A data frame with `chain`, `residue`, `plddt`.
#'
#' @author Jared Andrews
#' @rdname INTERNAL_af_read_structure
#' @keywords internal
.af_read_structure <- function(path) {
    if (!file.exists(path)) stop("File not found: ", path, call. = FALSE)
    con <- gzfile(path, "rt")
    on.exit(close(con))
    lines <- readLines(con, warn = FALSE)

    is_cif <- grepl("\\.(cif|mmcif)(\\.gz)?$", path, ignore.case = TRUE) ||
        any(startsWith(lines, "_atom_site."))
    ca <- if (is_cif) .af_ca_from_cif(lines) else .af_ca_from_pdb(lines)
    if (nrow(ca) == 0) stop("No C-alpha atoms found in '", basename(path), "'.", call. = FALSE)
    ca
}


#' C-alpha rows of a PDB file
#'
#' @param lines The file's lines.
#' @return A data frame with `chain`, `residue`, `plddt`.
#'
#' @author Jared Andrews
#' @rdname INTERNAL_af_ca_from_pdb
#' @keywords internal
.af_ca_from_pdb <- function(lines) {
    atoms <- lines[startsWith(lines, "ATOM")]
    atoms <- atoms[trimws(substr(atoms, 13, 16)) == "CA"]
    data.frame(
        chain = trimws(substr(atoms, 22, 22)),
        residue = as.integer(substr(atoms, 23, 26)),
        plddt = as.numeric(substr(atoms, 61, 66)),
        stringsAsFactors = FALSE
    )
}


#' C-alpha rows of an mmCIF `_atom_site` loop
#'
#' @param lines The file's lines.
#' @return A data frame with `chain`, `residue`, `plddt`.
#'
#' @author Jared Andrews
#' @rdname INTERNAL_af_ca_from_cif
#' @keywords internal
.af_ca_from_cif <- function(lines) {
    fields_at <- which(startsWith(lines, "_atom_site."))
    if (length(fields_at) == 0) stop("No _atom_site loop in the mmCIF file.", call. = FALSE)
    fields <- sub("^_atom_site\\.", "", trimws(lines[fields_at]))
    start <- max(fields_at) + 1
    stop_at <- which(seq_along(lines) >= start & (startsWith(lines, "#") | startsWith(lines, "loop_") |
        startsWith(lines, "_")))
    end <- if (length(stop_at)) min(stop_at) - 1 else length(lines)
    rows <- strsplit(trimws(lines[start:end]), "[[:space:]]+")
    rows <- rows[lengths(rows) == length(fields)]
    tab <- as.data.frame(do.call(rbind, rows), stringsAsFactors = FALSE)
    names(tab) <- fields

    col <- function(...) {
        hit <- intersect(c(...), names(tab))
        if (length(hit) == 0) stop("mmCIF _atom_site lacks ", paste(c(...), collapse = "/"), call. = FALSE)
        tab[[hit[1]]]
    }
    atom <- col("label_atom_id", "auth_atom_id")
    group <- col("group_PDB")
    keep <- group == "ATOM" & atom == "CA"
    data.frame(
        chain = col("auth_asym_id", "label_asym_id")[keep],
        residue = as.integer(col("auth_seq_id", "label_seq_id")[keep]),
        plddt = as.numeric(col("B_iso_or_equiv")[keep]),
        stringsAsFactors = FALSE
    )
}
