#' Parse well identifiers into plate rows and columns
#'
#' Accepts `"A01"`, `"A1"`, `"a1"` and, for 1536-well plates, two-letter rows
#' (`"AF48"`). Rows run A = 1 ... Z = 26, AA = 27 ...
#'
#' @param well Character vector of well identifiers.
#' @return A data frame with integer `row` and `col`.
#'
#' @author Jared Andrews
#' @rdname INTERNAL_plate_parse_wells
#' @keywords internal
.plate_parse_wells <- function(well) {
    well <- toupper(trimws(as.character(well)))
    ok <- grepl("^[A-Z]{1,2}[0-9]+$", well)
    if (!all(ok)) {
        stop("Unrecognised well identifier(s): ", paste(utils::head(unique(well[!ok]), 5), collapse = ", "),
            ". Expected e.g. \"A01\" or \"B7\".", call. = FALSE)
    }
    letters_part <- sub("[0-9]+$", "", well)
    row <- vapply(strsplit(letters_part, ""), function(ch) {
        Reduce(function(a, i) a * 26L + i, match(ch, LETTERS), 0L)
    }, integer(1))
    data.frame(row = row, col = as.integer(sub("^[A-Z]+", "", well)))
}


#' Row label of a plate row index
#'
#' @param i Integer row indices.
#' @return Character labels (`1` gives `"A"`, `27` gives `"AA"`).
#'
#' @author Jared Andrews
#' @rdname INTERNAL_plate_parse_wells
#' @keywords internal
.plate_row_label <- function(i) {
    vapply(i, function(n) {
        out <- character(0)
        while (n > 0) {
            r <- (n - 1) %% 26
            out <- c(LETTERS[r + 1], out)
            n <- (n - 1) %/% 26
        }
        paste(out, collapse = "")
    }, character(1))
}


#' Standard plate formats
#'
#' @author Jared Andrews
#' @rdname INTERNAL_plate_format
#' @keywords internal
.plate_formats <- list(
    "6" = c(2, 3), "12" = c(3, 4), "24" = c(4, 6), "48" = c(6, 8), "96" = c(8, 12),
    "384" = c(16, 24), "1536" = c(32, 48)
)


#' Resolve the plate format
#'
#' @param row,col Integer rows and columns of the wells present.
#' @param format A plate size (`96`, `384`, ...), or `NULL` / `"auto"` for the
#'   smallest standard plate that holds every well.
#' @return A list with `wells`, `nrow` and `ncol`.
#'
#' @author Jared Andrews
#' @rdname INTERNAL_plate_format
#' @keywords internal
.plate_format <- function(row, col, format = NULL) {
    if (!is.null(format) && !identical(as.character(format), "auto") && nzchar(as.character(format))) {
        dims <- .plate_formats[[as.character(format)]]
        if (is.null(dims)) stop("Unknown plate format: ", format, call. = FALSE)
        if (max(row) > dims[1] || max(col) > dims[2]) {
            stop("Wells fall outside a ", format, "-well plate.", call. = FALSE)
        }
    } else {
        fits <- vapply(.plate_formats, function(d) d[1] >= max(row) && d[2] >= max(col), logical(1))
        if (!any(fits)) {
            dims <- c(max(row), max(col))
            return(list(wells = prod(dims), nrow = dims[1], ncol = dims[2]))
        }
        format <- names(.plate_formats)[which(fits)[1]]
        dims <- .plate_formats[[format]]
    }
    list(wells = as.integer(format), nrow = dims[1], ncol = dims[2])
}


#' Normalise one plate's readout
#'
#' @param x Numeric readout of each well.
#' @param row,col Integer row and column of each well.
#' @param role `"positive"`, `"negative"` or `"sample"` for each well.
#' @param method One of `"raw"`, `"percent.control"` (percent of the negative
#'   control mean), `"percent.inhibition"` (0 at the negative, 100 at the
#'   positive control mean), `"zscore"` and `"robust.z"` (against the sample
#'   wells' mean / SD or median / MAD), or `"bscore"` (Tukey median-polish
#'   residuals of the sample wells, over their MAD; Brideau et al. 2003).
#' @return The normalised readout.
#'
#' @author Jared Andrews
#' @rdname INTERNAL_plate_normalise
#' @keywords internal
.plate_normalise <- function(x, row, col, role, method = "raw") {
    samples <- role == "sample"
    if (!any(samples)) samples <- rep(TRUE, length(x))
    pos <- x[role == "positive"]
    neg <- x[role == "negative"]
    need_controls <- function() {
        if (!length(neg) || (method == "percent.inhibition" && !length(pos))) {
            stop("This normalisation needs ", if (method == "percent.inhibition") "positive and negative" else
                "negative", " control wells.", call. = FALSE)
        }
    }
    switch(method,
        raw = x,
        percent.control = {
            need_controls()
            100 * x / mean(neg, na.rm = TRUE)
        },
        percent.inhibition = {
            need_controls()
            100 * (mean(neg, na.rm = TRUE) - x) / (mean(neg, na.rm = TRUE) - mean(pos, na.rm = TRUE))
        },
        zscore = (x - mean(x[samples], na.rm = TRUE)) / stats::sd(x[samples], na.rm = TRUE),
        robust.z = (x - stats::median(x[samples], na.rm = TRUE)) / stats::mad(x[samples], na.rm = TRUE),
        bscore = {
            rows <- sort(unique(row[samples]))
            cols <- sort(unique(col[samples]))
            m <- matrix(NA_real_, length(rows), length(cols))
            m[cbind(match(row[samples], rows), match(col[samples], cols))] <- x[samples]
            mp <- stats::medpolish(m, na.rm = TRUE, trace.iter = FALSE)
            # Every well, controls included, takes the effects of its row and column.
            row_eff <- mp$row[match(row, rows)]
            col_eff <- mp$col[match(col, cols)]
            res <- x - mp$overall - ifelse(is.na(row_eff), 0, row_eff) - ifelse(is.na(col_eff), 0, col_eff)
            res / stats::mad(res[samples], na.rm = TRUE)
        },
        stop("Unknown normalisation: ", method, call. = FALSE)
    )
}


#' Z'-factor of an assay plate
#'
#' `1 - 3 (sd_pos + sd_neg) / |mean_pos - mean_neg|` (Zhang et al. 1999).
#'
#' @param pos,neg Readouts of the positive and negative control wells.
#' @return The Z'-factor, or `NA` without at least two of each.
#'
#' @author Jared Andrews
#' @rdname INTERNAL_plate_zprime
#' @keywords internal
.plate_zprime <- function(pos, neg) {
    pos <- pos[is.finite(pos)]
    neg <- neg[is.finite(neg)]
    if (length(pos) < 2 || length(neg) < 2) return(NA_real_)
    1 - 3 * (stats::sd(pos) + stats::sd(neg)) / abs(mean(pos) - mean(neg))
}


#' Detect the columns of plate data
#'
#' @param data The data frame.
#' @return A list with `well`, `value`, `plate`, `control` (column names or
#'   `""`) and the `positive` / `negative` control labels found in `control`.
#'
#' @author Jared Andrews
#' @rdname INTERNAL_plate_columns
#' @keywords internal
.plate_columns <- function(data) {
    nms <- names(data)
    pick <- function(pattern, pool = nms) {
        hit <- grep(pattern, pool, ignore.case = TRUE, value = TRUE)
        if (length(hit)) hit[1] else ""
    }
    num <- nms[vapply(data, is.numeric, logical(1))]
    value <- pick("signal|value|readout|intensity|lum|fluor|response|od", num)
    if (!nzchar(value) && length(num)) value <- num[1]
    control <- pick("^(control|type|well[._ ]?type|role|content)$")
    labels <- if (nzchar(control)) unique(as.character(data[[control]])) else character(0)
    pos <- grep("^pos", labels, ignore.case = TRUE, value = TRUE)
    neg <- grep("^neg", labels, ignore.case = TRUE, value = TRUE)
    list(
        well = pick("^well"),
        value = value,
        plate = pick("^plate|barcode"),
        control = control,
        positive = if (length(pos)) pos[1] else "",
        negative = if (length(neg)) neg[1] else ""
    )
}
