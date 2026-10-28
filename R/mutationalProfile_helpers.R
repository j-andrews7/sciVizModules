# The six pyrimidine-centred substitution classes, in the order
# MutationalPatterns, maftools and COSMIC use.
.sbs_classes <- c("C>A", "C>G", "C>T", "T>A", "T>C", "T>G")

# MutationalPatterns' six-class colours (plot_96_profile()).
.sbs_colors <- c(
    "C>A" = "#2EBAED", "C>G" = "#000000", "C>T" = "#DE1C14",
    "T>A" = "#D4D2D2", "T>C" = "#ADCC54", "T>G" = "#F0D0CE"
)


#' The 96 single-base-substitution channels
#'
#' Named and ordered as MutationalPatterns (`mut_matrix()`), maftools
#' (`trinucleotideMatrix()`) and COSMIC name them: class by class, the 5' base
#' outer and the 3' base inner, e.g. `"A[C>A]A"`, `"A[C>A]C"`, ...
#'
#' @return A character vector of 96 channel names.
#'
#' @author Jared Andrews
#' @rdname INTERNAL_sbs96_channels
#' @keywords internal
.sbs96_channels <- function() {
    bases <- c("A", "C", "G", "T")
    unlist(lapply(.sbs_classes, function(cl) {
        unlist(lapply(bases, function(five) paste0(five, "[", cl, "]", bases)))
    }))
}


#' Read a 96-channel substitution matrix into a channels-by-samples matrix
#'
#' Accepts the 96 x samples matrix MutationalPatterns' `mut_matrix()` returns,
#' the samples x 96 `nmf_matrix` of maftools' `trinucleotideMatrix()`, or a data
#' frame with a column of channel names and one numeric column per sample (the
#' SigProfiler layout). Channels are matched by name, so their order does not
#' matter; channels that are missing count zero.
#'
#' @param x A matrix or data frame.
#' @return A numeric matrix, the 96 channels (in canonical order) by samples.
#'
#' @author Jared Andrews
#' @rdname INTERNAL_sbs96_matrix
#' @keywords internal
.sbs96_matrix <- function(x) {
    channels <- .sbs96_channels()
    if (is.data.frame(x)) {
        chr <- names(x)[vapply(x, function(v) is.character(v) || is.factor(v), logical(1))]
        hits <- vapply(chr, function(cl) sum(as.character(x[[cl]]) %in% channels), numeric(1))
        num <- names(x)[vapply(x, is.numeric, logical(1))]
        if (length(hits) && max(hits) > 0) {
            ctx <- as.character(x[[chr[which.max(hits)]]])
            m <- as.matrix(x[, num, drop = FALSE])
            rownames(m) <- ctx
        } else {
            m <- as.matrix(x[, num, drop = FALSE])
            rownames(m) <- rownames(x)
        }
    } else {
        m <- as.matrix(x)
    }
    if (!is.numeric(m)) stop("The substitution counts must be numeric.", call. = FALSE)

    by_rows <- sum(rownames(m) %in% channels)
    by_cols <- sum(colnames(m) %in% channels)
    if (by_cols > by_rows) m <- t(m)
    if (max(by_rows, by_cols) == 0) {
        stop("No 96-channel substitution names (such as \"A[C>A]A\") were found in the rows or columns.",
            call. = FALSE)
    }
    if (is.null(colnames(m))) colnames(m) <- paste0("Sample", seq_len(ncol(m)))
    m <- m[rownames(m) %in% channels, , drop = FALSE]
    m <- rowsum(m, rownames(m), reorder = FALSE)

    out <- matrix(0, nrow = 96, ncol = ncol(m), dimnames = list(channels, colnames(m)))
    out[rownames(m), ] <- m
    out
}


#' A 96-channel substitution matrix as a long table
#'
#' @param x Anything [.sbs96_matrix()] reads.
#' @return A data frame with one row per sample and channel: `context` (a factor
#'   in canonical channel order), `substitution` (its class), `sample`, `count`
#'   and `fraction` (of the sample's substitutions).
#'
#' @author Jared Andrews
#' @rdname INTERNAL_sbs96_long
#' @keywords internal
.sbs96_long <- function(x) {
    m <- .sbs96_matrix(x)
    channels <- rownames(m)
    totals <- colSums(m)
    data.frame(
        context = factor(rep(channels, ncol(m)), levels = channels),
        substitution = factor(rep(substr(channels, 3, 5), ncol(m)), levels = .sbs_classes),
        sample = factor(rep(colnames(m), each = 96), levels = colnames(m)),
        count = as.vector(m),
        fraction = as.vector(sweep(m, 2, ifelse(totals > 0, totals, 1), "/")),
        stringsAsFactors = FALSE
    )
}


#' Default inputs for the mutationalProfile module
#'
#' The wrapped bar module's mapping set to the classic 96-channel spectrum: one
#' bar per channel, coloured by substitution class, one panel per sample. User
#' values win.
#'
#' @param defaults A named list of user defaults, or `NULL`.
#' @return A named list of defaults for [VizModules::plotthis_BarPlotServer()].
#'
#' @author Jared Andrews
#' @rdname INTERNAL_sbs96_defaults
#' @keywords internal
.sbs96_defaults <- function(defaults = NULL) {
    base <- list(
        x.data = "context",
        y.data = "fraction",
        fill.by = "substitution",
        group.by = "",
        facet.by = "sample",
        # Free y, since the bar module would otherwise size every panel to the
        # per-channel total across all samples.
        facet.scale = "free_y",
        facet.ncol = 1,
        palette.colours = .sbs_colors,
        axis.tickangle.x = -90,
        axis.tickfont.size = 7
    )
    base[names(defaults %||% list())] <- defaults
    base
}
