#' Candidate column names for the oncoPlot sample/gene/alteration columns
#'
#' Ordered vectors of column-name candidates used by the auto-detectors when a
#' tidy (long) mutation table is supplied to the oncoPlot module. Matching is
#' case-insensitive.
#'
#' @author Jacob Martin, Jared Andrews
#' @rdname INTERNAL_onco_candidates
#' @keywords internal
.onco_sample_candidates <- c(
    "sample", "sample_id", "sampleid", "sample.id", "samples",
    "patient", "patient_id", "case", "case_id", "tumor_sample_barcode",
    "tumor_sample", "specimen", "id"
)

#' @rdname INTERNAL_onco_candidates
#' @keywords internal
.onco_gene_candidates <- c(
    "gene", "genes", "gene_symbol", "symbol", "hugo_symbol",
    "gene_name", "feature"
)

#' @rdname INTERNAL_onco_candidates
#' @keywords internal
.onco_alteration_candidates <- c(
    "alteration", "alterations", "variant_classification", "variant",
    "mutation", "mutation_type", "type", "consequence", "effect", "class",
    "event"
)

#' Detect a column by name candidates
#'
#' Returns the first column in `data` whose name (case-insensitively) matches an
#' entry in `candidates`. Falls back to `NULL` when nothing matches.
#'
#' @param data A data frame.
#' @param candidates A character vector of candidate column names (in priority
#'   order).
#' @return The matched column name, or `NULL`.
#'
#' @author Jacob Martin, Jared Andrews
#' @rdname INTERNAL_onco_detect_col
#' @keywords internal
.onco_detect_col <- function(data, candidates) {
    nms <- names(data)
    lower <- tolower(nms)
    for (cand in candidates) {
        hit <- which(lower == tolower(cand))
        if (length(hit)) {
            return(nms[hit[1]])
        }
    }
    NULL
}

#' Detect the sample / gene / alteration columns in a tidy mutation table
#'
#' Convenience wrappers around [.onco_detect_col()] that additionally fall back
#' to a positional guess (first non-target character column) so that a table
#' with unconventional names can still be plotted.
#'
#' @param data A data frame of tidy (long) mutation calls.
#' @param exclude Column names to exclude from the positional fallback.
#' @return The detected column name, or `NULL` when none can be found.
#'
#' @author Jacob Martin, Jared Andrews
#' @rdname INTERNAL_onco_role_cols
#' @keywords internal
.onco_sample_col <- function(data, exclude = NULL) {
    hit <- .onco_detect_col(data, .onco_sample_candidates)
    if (!is.null(hit)) {
        return(hit)
    }
    .onco_first_char_col(data, exclude)
}

#' @rdname INTERNAL_onco_role_cols
#' @keywords internal
.onco_gene_col <- function(data, exclude = NULL) {
    hit <- .onco_detect_col(data, .onco_gene_candidates)
    if (!is.null(hit)) {
        return(hit)
    }
    .onco_first_char_col(data, exclude)
}

#' @rdname INTERNAL_onco_role_cols
#' @keywords internal
.onco_alteration_col <- function(data, exclude = NULL) {
    hit <- .onco_detect_col(data, .onco_alteration_candidates)
    if (!is.null(hit)) {
        return(hit)
    }
    .onco_first_char_col(data, exclude)
}

#' First non-numeric column not in `exclude`
#'
#' @param data A data frame.
#' @param exclude Column names to skip.
#' @return A column name, or `NULL`.
#'
#' @author Jacob Martin, Jared Andrews
#' @rdname INTERNAL_onco_first_char_col
#' @keywords internal
.onco_first_char_col <- function(data, exclude = NULL) {
    cand <- setdiff(names(data), exclude)
    for (nm in cand) {
        if (!is.numeric(data[[nm]])) {
            return(nm)
        }
    }
    if (length(cand)) cand[1] else NULL
}

#' Pivot a tidy mutation table into an oncoPrint matrix
#'
#' Converts a long data frame of `sample`, `gene`, and `alteration` calls into
#' the character matrix that [ComplexHeatmap::oncoPrint()] expects: genes in
#' rows, samples in columns, and each cell a `;`-separated string of the
#' alteration types observed for that gene/sample pair (empty string when none).
#'
#' @param data A data frame of tidy (long) mutation calls.
#' @param sample.col,gene.col,alteration.col Column names giving the sample,
#'   gene, and alteration of each row.
#' @return A character matrix (genes x samples) of `;`-separated alteration
#'   strings suitable for [ComplexHeatmap::oncoPrint()].
#'
#' @author Jacob Martin, Jared Andrews
#' @rdname INTERNAL_onco_to_matrix
#' @keywords internal
.onco_to_matrix <- function(data, sample.col, gene.col, alteration.col) {
    df <- as.data.frame(data)
    for (col in c(sample.col, gene.col, alteration.col)) {
        if (!col %in% names(df)) {
            stop("Column '", col, "' not found in data.")
        }
    }

    samples <- as.character(df[[sample.col]])
    genes <- as.character(df[[gene.col]])
    alts <- as.character(df[[alteration.col]])

    keep <- !is.na(samples) & !is.na(genes) & !is.na(alts) & nzchar(alts)
    samples <- samples[keep]
    genes <- genes[keep]
    alts <- alts[keep]

    if (!length(genes)) {
        stop("No non-missing gene/sample/alteration rows found in data.")
    }

    gene.levels <- unique(genes)
    sample.levels <- unique(samples)

    mat <- matrix(
        "",
        nrow = length(gene.levels),
        ncol = length(sample.levels),
        dimnames = list(gene.levels, sample.levels)
    )

    gi <- match(genes, gene.levels)
    si <- match(samples, sample.levels)
    for (k in seq_along(alts)) {
        cur <- mat[gi[k], si[k]]
        # Accumulate distinct alteration types per cell, semicolon-separated.
        existing <- if (nzchar(cur)) strsplit(cur, ";", fixed = TRUE)[[1]] else character(0)
        if (!alts[k] %in% existing) {
            mat[gi[k], si[k]] <- paste(c(existing, alts[k]), collapse = ";")
        }
    }

    mat
}

#' Distinct alteration types in a tidy mutation table
#'
#' Returns the unique, non-missing values of the alteration column, splitting on
#' `;` so that pre-combined `"MUT;AMP"` cells are decomposed into their
#' constituent types. Used to seed and update the per-alteration colour picker.
#'
#' @param data A tidy (long) data frame of mutation calls.
#' @param alteration.col The name of the alteration-type column.
#' @return A character vector of distinct alteration types (may be empty).
#'
#' @author Jacob Martin, Jared Andrews
#' @rdname INTERNAL_onco_types_from_df
#' @keywords internal
.onco_types_from_df <- function(data, alteration.col) {
    if (is.null(alteration.col) || !alteration.col %in% names(data)) {
        return(character(0))
    }
    vals <- as.character(data[[alteration.col]])
    vals <- vals[!is.na(vals) & nzchar(vals)]
    vals <- unlist(strsplit(vals, ";", fixed = TRUE))
    vals <- trimws(vals)
    unique(vals[nzchar(vals)])
}

#' Non-empty-cell logical matrix
#'
#' [base::nzchar()] drops the `dim` attribute of a matrix; this preserves it so
#' that `rowSums()` / `colSums()` can be used to count alterations per gene or
#' sample.
#'
#' @param mat A character matrix.
#' @return A logical matrix of the same shape, `TRUE` where the cell is a
#'   non-empty string.
#'
#' @author Jacob Martin, Jared Andrews
#' @rdname INTERNAL_onco_nzchar_matrix
#' @keywords internal
.onco_nzchar_matrix <- function(mat) {
    matrix(nzchar(mat), nrow = nrow(mat), ncol = ncol(mat), dimnames = dimnames(mat))
}

#' Distinct alteration types present in an oncoPrint matrix
#' @param mat A character matrix of `;`-separated alteration strings.
#' @return A character vector of the distinct alteration types.
#'
#' @author Jacob Martin, Jared Andrews
#' @rdname INTERNAL_onco_alteration_types
#' @keywords internal
.onco_alteration_types <- function(mat) {
    vals <- unlist(strsplit(as.vector(mat), ";", fixed = TRUE))
    vals <- vals[!is.na(vals) & nzchar(vals)]
    unique(vals)
}

#' Default colour map for a set of alteration types
#'
#' Assigns colours to the supplied alteration types, preferring stable colours
#' for common alteration names (e.g. `MUT`, `AMP`, `HOMDEL`) and drawing the
#' remainder from a categorical palette.
#'
#' @param types A character vector of alteration types.
#' @return A named character vector mapping each type to a colour.
#'
#' @author Jacob Martin, Jared Andrews
#' @rdname INTERNAL_onco_default_colors
#' @keywords internal
.onco_default_colors <- function(types) {
    known <- c(
        MUT = "#008000", Missense_Mutation = "#008000",
        AMP = "#D62728", Amplification = "#D62728", Gain = "#FF9896",
        HOMDEL = "#1F77B4", Deletion = "#1F77B4", Loss = "#AEC7E8",
        Nonsense_Mutation = "#252525", Frame_Shift_Del = "#7F3B08",
        Frame_Shift_Ins = "#B35806", Splice_Site = "#9467BD",
        Fusion = "#E377C2", In_Frame_Del = "#8C564B", In_Frame_Ins = "#BCBD22"
    )

    out <- stats::setNames(rep(NA_character_, length(types)), types)
    for (t in types) {
        if (t %in% names(known)) out[[t]] <- known[[t]]
    }

    remaining <- types[is.na(out)]
    if (length(remaining)) {
        pal <- grDevices::hcl.colors(max(length(remaining), 3), palette = "Dark 3")
        out[remaining] <- pal[seq_along(remaining)]
    }
    out
}

#' Build the alter_fun list for oncoPrint
#'
#' Constructs the list of drawing functions [ComplexHeatmap::oncoPrint()] uses
#' to render each alteration type. A grey background rectangle is always drawn,
#' and each alteration type is drawn as a smaller filled rectangle in its mapped
#' colour so that co-occurring alterations in a cell are visible as stacked
#' bars.
#'
#' @param col A named character vector mapping alteration types to colours.
#' @param background Colour of the empty-cell background rectangle.
#' @return A named list of drawing functions plus a `background` entry, suitable
#'   for the `alter_fun` argument of [ComplexHeatmap::oncoPrint()].
#'
#' @author Jacob Martin, Jared Andrews
#' @rdname INTERNAL_onco_alter_fun
#' @keywords internal
.onco_alter_fun <- function(col, background = "#CCCCCC") {
    n <- length(col)
    types <- names(col)

    fun_list <- list(
        background = function(x, y, w, h) {
            grid::grid.rect(x, y, w * 0.9, h * 0.9,
                gp = grid::gpar(fill = background, col = NA)
            )
        }
    )

    # Each alteration type occupies its own horizontal band within the cell so
    # that co-occurring alterations (e.g. "MUT;AMP") are both visible instead of
    # overplotting one another at the cell centre. Band i is centred at a
    # vertical offset from the cell centre; with a single type the band fills the
    # cell, and with several the bands tile it top-to-bottom.
    for (i in seq_len(n)) {
        local({
            idx <- i
            type <- types[idx]
            fill <- col[[idx]]
            band_h <- 1 / n
            # Offset of band centre from cell centre, in fractions of cell height.
            # For n bands this yields evenly spaced, non-overlapping bands.
            offset <- (idx - 0.5) / n - 0.5
            fun_list[[type]] <<- function(x, y, w, h) {
                grid::grid.rect(x, y - h * offset, w * 0.9, h * 0.9 * band_h,
                    gp = grid::gpar(fill = fill, col = NA)
                )
            }
        })
    }

    fun_list
}

#' Majority (most frequent) value of a vector
#'
#' @param x A vector.
#' @return The single most frequent non-missing value (as character), or `NA`.
#'
#' @author Jacob Martin, Jared Andrews
#' @rdname INTERNAL_onco_majority
#' @keywords internal
.onco_majority <- function(x) {
    x <- x[!is.na(x)]
    if (!length(x)) {
        return(NA)
    }
    tt <- sort(table(as.character(x)), decreasing = TRUE)
    names(tt)[1]
}

#' Available annotation data sources for an oncoprint
#'
#' Enumerates the annotation tracks that can be attached to the oncoprint, one
#' per **extra column** in the tidy data (i.e. any column that is not the
#' sample, gene, or alteration column). Each extra column is offered in two
#' spaces: aggregated to one value per sample (`sample`-space, for top/bottom
#' tracks) and one value per gene (`gene`-space, for left/right tracks).
#' Numeric columns are aggregated with the mean; categorical columns with the
#' majority value.
#'
#' @param data A tidy (long) mutation data frame.
#' @param sample.col,gene.col,alteration.col The sample, gene, and alteration
#'   column names.
#' @return A named list with two character vectors, `sample` and `gene`. Each is
#'   a named vector whose *names* are human-readable labels and whose *values*
#'   are internal source keys of the form `"<space>:<column>"` (e.g.
#'   `"sample:stage"`, `"gene:expression"`). Empty when the data has no extra
#'   columns.
#'
#' @author Jacob Martin, Jared Andrews
#' @rdname INTERNAL_onco_annotation_sources
#' @keywords internal
.onco_annotation_sources <- function(data, sample.col, gene.col, alteration.col) {
    extra <- setdiff(names(data), c(sample.col, gene.col, alteration.col))

    sample.src <- character(0)
    gene.src <- character(0)
    for (col in extra) {
        sample.src[[paste0(col, " (per sample)")]] <- paste0("sample:", col)
        gene.src[[paste0(col, " (per gene)")]] <- paste0("gene:", col)
    }

    list(sample = sample.src, gene = gene.src)
}

#' Derive an annotation vector aligned to the oncoprint axis
#'
#' Given a source key produced by [.onco_annotation_sources()], returns a vector
#' aligned to the samples (`colnames(mat)`) or genes (`rownames(mat)`) of the
#' oncoprint by aggregating the corresponding extra column of the tidy data:
#' the mean for numeric columns, the majority value for categorical columns.
#'
#' @param key A source key of the form `"<space>:<id>"`.
#' @param data The tidy (long) mutation data frame.
#' @param mat The oncoprint character matrix (genes x samples).
#' @param sample.col,gene.col,alteration.col The sample, gene, and alteration
#'   column names.
#' @return A named vector aligned to the relevant axis, or `NULL` when the key
#'   cannot be derived.
#'
#' @author Jacob Martin, Jared Andrews
#' @rdname INTERNAL_onco_summarise_source
#' @keywords internal
.onco_summarise_source <- function(key, data, mat, sample.col, gene.col, alteration.col) {
    if (is.null(key) || !nzchar(key) || !grepl(":", key, fixed = TRUE)) {
        return(NULL)
    }
    parts <- strsplit(key, ":", fixed = TRUE)[[1]]
    space <- parts[1]
    id <- paste(parts[-1], collapse = ":")

    df <- as.data.frame(data)
    samples <- colnames(mat)
    genes <- rownames(mat)

    if (space == "sample") {
        # Aggregate the extra column to one value per sample.
        if (!id %in% names(df)) {
            return(NULL)
        }
        agg <- split(df[[id]], as.character(df[[sample.col]]))
        if (is.numeric(df[[id]])) {
            vals <- vapply(agg, function(x) mean(x, na.rm = TRUE), numeric(1))
        } else {
            vals <- vapply(agg, .onco_majority, character(1))
        }
        stats::setNames(vals[samples], samples)
    } else if (space == "gene") {
        # Aggregate the extra column to one value per gene.
        if (!id %in% names(df)) {
            return(NULL)
        }
        agg <- split(df[[id]], as.character(df[[gene.col]]))
        if (is.numeric(df[[id]])) {
            vals <- vapply(agg, function(x) mean(x, na.rm = TRUE), numeric(1))
        } else {
            vals <- vapply(agg, .onco_majority, character(1))
        }
        stats::setNames(vals[genes], genes)
    } else {
        NULL
    }
}

#' Build a single annotation track from a conformable vector
#'
#' Dispatches on the requested track `type` to the appropriate
#' `ComplexHeatmap::anno_*` builder and returns a one-track
#' `HeatmapAnnotation`/`rowAnnotation`. Numeric tracks use the supplied
#' `colour`; categorical vectors always render as a simple track with an
#' automatic discrete palette (the colour is ignored, per design).
#'
#' @param vec A named vector aligned to the axis (from [.onco_summarise_source()]).
#' @param name The annotation track name (shown as its label).
#' @param type One of `"Bar"`, `"Points"`, `"Lines"`, `"Simple"`
#'   (case-insensitive).
#' @param colour A hex colour used for numeric/simple tracks.
#' @param which `"column"` (top/bottom) or `"row"` (left/right).
#' @return A `HeatmapAnnotation` object with one track, or `NULL` on failure.
#'
#' @importFrom ComplexHeatmap HeatmapAnnotation anno_barplot anno_points
#'   anno_lines anno_simple
#' @importFrom grid gpar
#'
#' @author Jacob Martin, Jared Andrews
#' @rdname INTERNAL_onco_build_annotation
#' @keywords internal
.onco_build_annotation <- function(vec, name, type, colour, which) {
    if (is.null(vec) || !length(vec)) {
        return(NULL)
    }
    if (is.null(colour) || !nzchar(colour)) colour <- "#4C78A8"
    type <- tolower(type %||% "bar")

    is.num <- is.numeric(vec)

    track <- if (!is.num) {
        # Categorical: simple track with an automatic discrete palette.
        levs <- unique(as.character(vec[!is.na(vec)]))
        pal <- grDevices::hcl.colors(max(length(levs), 2), palette = "Dark 3")[seq_along(levs)]
        col.map <- stats::setNames(pal, levs)
        ComplexHeatmap::anno_simple(as.character(vec), col = col.map, which = which)
    } else {
        switch(type,
            points = ComplexHeatmap::anno_points(vec,
                gp = grid::gpar(col = colour), which = which),
            lines = ComplexHeatmap::anno_lines(vec,
                gp = grid::gpar(col = colour), which = which),
            simple = {
                # Continuous simple track: white -> colour ramp.
                ComplexHeatmap::anno_simple(vec,
                    col = circlize_colorRamp2(range(vec, na.rm = TRUE), c("#FFFFFF", colour)),
                    which = which)
            },
            # default: bar
            ComplexHeatmap::anno_barplot(vec,
                gp = grid::gpar(fill = colour, col = colour), which = which)
        )
    }

    args <- stats::setNames(list(track), name)
    args$which <- which
    tryCatch(
        do.call(ComplexHeatmap::HeatmapAnnotation, args),
        error = function(e) NULL
    )
}

#' Simple two-point colour ramp (avoids a hard circlize dependency)
#'
#' A minimal stand-in for `circlize::colorRamp2()` used to build a white->colour
#' ramp for continuous simple annotation tracks. Returns a function mapping
#' numeric values to hex colours.
#'
#' @param breaks Numeric length-2 vector `c(min, max)`.
#' @param colors Character length-2 vector of endpoint colours.
#' @return A function `f(x)` returning hex colours.
#'
#' @author Jacob Martin, Jared Andrews
#' @rdname INTERNAL_circlize_colorRamp2
#' @keywords internal
circlize_colorRamp2 <- function(breaks, colors) {
    if (requireNamespace("circlize", quietly = TRUE)) {
        return(circlize::colorRamp2(breaks, colors))
    }
    ramp <- grDevices::colorRamp(colors)
    lo <- breaks[1]
    hi <- breaks[2]
    function(x) {
        x <- pmin(pmax((x - lo) / (hi - lo), 0), 1)
        x[is.na(x)] <- 0
        rgb <- ramp(x)
        grDevices::rgb(rgb[, 1], rgb[, 2], rgb[, 3], maxColorValue = 255)
    }
}

#' Collect user annotation rows into per-side annotation objects
#'
#' Iterates the rows collected by a [VizModules::multiDynamicInput()] annotation
#' adder, derives a conformable vector for each, builds the corresponding
#' annotation track, and combines tracks that share a side into one
#' `HeatmapAnnotation`. Rows whose source space does not match the chosen side
#' (e.g. a per-gene source placed on `top`) or that cannot be derived are
#' skipped.
#'
#' @param rows A named list of rows from `input[[annotation_id]]`; each row is a
#'   list with `side`, `source`, `type`, and `colour`.
#' @param data The tidy (long) mutation data frame.
#' @param mat The oncoprint character matrix (genes x samples).
#' @param sample.col,gene.col,alteration.col The sample, gene, and alteration
#'   column names.
#' @return A named list with elements `top`, `bottom`, `left`, `right`, each a
#'   `HeatmapAnnotation` object or `NULL`.
#'
#' @importFrom ComplexHeatmap HeatmapAnnotation
#'
#' @author Jacob Martin, Jared Andrews
#' @rdname INTERNAL_onco_collect_annotations
#' @keywords internal
.onco_collect_annotations <- function(rows, data, mat, sample.col, gene.col, alteration.col) {
    empty <- list(top = NULL, bottom = NULL, left = NULL, right = NULL)
    if (is.null(rows) || !length(rows)) {
        return(empty)
    }

    # Accumulate per-side named lists of tracks, then combine at the end so
    # multiple rows on one side become a single multi-track annotation.
    tracks <- list(top = list(), bottom = list(), left = list(), right = list())

    idx <- 0L
    for (row in rows) {
        idx <- idx + 1L
        side <- row$side %||% "top"
        if (!side %in% c("top", "bottom", "left", "right")) next

        which <- if (side %in% c("top", "bottom")) "column" else "row"
        space <- if (which == "column") "sample" else "gene"

        key <- row$source %||% ""
        # Skip rows whose source space does not match the chosen side.
        if (!startsWith(key, paste0(space, ":"))) next

        vec <- tryCatch(
            .onco_summarise_source(key, data, mat, sample.col, gene.col, alteration.col),
            error = function(e) NULL
        )
        if (is.null(vec)) next

        nm <- sub("^[^:]*:", "", key)
        nm <- make.unique(c(names(tracks[[side]]), nm))[length(tracks[[side]]) + 1]

        ann <- .onco_build_annotation(vec, nm, row$type %||% "Bar", row$colour, which)
        if (!is.null(ann)) tracks[[side]][[nm]] <- ann
    }

    # Combine tracks per side into a single HeatmapAnnotation. Since each track
    # is itself a one-track HeatmapAnnotation, rebuild from the underlying
    # vectors would be cleaner, but ComplexHeatmap allows concatenating
    # annotations with c(). Fall back to the first when only one is present.
    out <- empty
    for (side in names(tracks)) {
        lst <- tracks[[side]]
        if (!length(lst)) next
        out[[side]] <- if (length(lst) == 1) lst[[1]] else Reduce(c, lst)
    }
    out
}

#' Null-coalescing operator
#'
#' @param a,b Values; returns `a` unless it is `NULL`, otherwise `b`.
#' @author Jacob Martin, Jared Andrews
#' @rdname INTERNAL_onco_null_coalesce
#' @keywords internal
`%||%` <- function(a, b) if (is.null(a)) b else a
