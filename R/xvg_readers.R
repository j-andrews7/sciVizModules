#' Read a GROMACS .xvg file
#'
#' Reads the analysis output GROMACS writes as `.xvg` (`gmx rms`, `gmx rmsf`,
#' `gmx gyrate`, `gmx hbond`, `gmx energy`, ...) into a long data frame for the
#' mdTrajectoryMetrics module. `#` comment lines are skipped; the `@ title`,
#' axis labels and series legends are kept; Grace formatting codes such as
#' `\\sX\\N` (subscript) are removed from labels. The file may be
#' gzip-compressed. Several files - replicas, or different analyses - can be
#' combined with [rbind()].
#'
#' @param file Path to a `.xvg` file.
#' @param series Optional names for the data series (the y columns), e.g. a
#'   replica name for a single-series file. Defaults to the file's legends, or
#'   the file name when it has none.
#' @return A data frame with one row per point: `x`, `value`, `series`,
#'   `metric` (the file's title), `x.label`, `y.label` and `file`.
#'
#' @importFrom utils read.table
#' @seealso [mdTrajectoryMetrics()], the mdTrajectoryMetrics module
#' @export
#' @author Jared Andrews
#' @examples
#' rmsd <- read_xvg(system.file("extdata", "example_rmsd_rep1.xvg.gz", package = "sciVizModules"),
#'     series = "replica 1")
#' head(rmsd)
read_xvg <- function(file, series = NULL) {
    if (!file.exists(file)) stop("File not found: ", file, call. = FALSE)
    con <- gzfile(file, "rt")
    on.exit(close(con))
    lines <- readLines(con, warn = FALSE)

    directive <- function(pattern) {
        hit <- grep(pattern, lines, value = TRUE)
        if (length(hit) == 0) return(NA_character_)
        .xvg_clean(sub('^[^"]*"(.*)"[^"]*$', "\\1", hit[1]))
    }
    title <- directive("^@[[:space:]]+title[[:space:]]")
    x_label <- directive("^@[[:space:]]+xaxis[[:space:]]+label")
    y_label <- directive("^@[[:space:]]+yaxis[[:space:]]+label")
    legend_lines <- grep("^@[[:space:]]*s[0-9]+[[:space:]]+legend", lines, value = TRUE)
    legends <- .xvg_clean(sub('^[^"]*"(.*)"[^"]*$', "\\1", legend_lines))
    names(legends) <- as.integer(sub("^@[[:space:]]*s([0-9]+).*$", "\\1", legend_lines))

    body <- lines[!grepl("^[[:space:]]*[#@&]", lines) & nzchar(trimws(lines))]
    if (length(body) == 0) stop("No data in '", basename(file), "'.", call. = FALSE)
    tab <- tryCatch(
        utils::read.table(text = body, header = FALSE),
        error = function(e) stop("'", basename(file), "' is not a readable .xvg file: ", conditionMessage(e),
            call. = FALSE)
    )
    if (ncol(tab) < 2 || !all(vapply(tab, is.numeric, logical(1)))) {
        stop("'", basename(file), "' does not hold numeric x/y columns.", call. = FALSE)
    }

    stem <- sub("[.]xvg([.]gz)?$", "", basename(file), ignore.case = TRUE)
    n_series <- ncol(tab) - 1
    names_out <- if (!is.null(series)) {
        rep_len(series, n_series)
    } else if (length(legends)) {
        vapply(seq_len(n_series) - 1, function(i) legends[as.character(i)] %||% paste0("s", i), character(1))
    } else if (n_series == 1) {
        stem
    } else {
        paste0(stem, "_s", seq_len(n_series) - 1)
    }

    out <- do.call(rbind, lapply(seq_len(n_series), function(j) {
        data.frame(x = tab[[1]], value = tab[[j + 1]], series = unname(names_out[j]), stringsAsFactors = FALSE)
    }))
    out$metric <- if (is.na(title)) stem else title
    out$x.label <- if (is.na(x_label)) "x" else x_label
    out$y.label <- if (is.na(y_label)) "value" else y_label
    out$file <- stem
    out
}


#' Strip Grace formatting codes from an .xvg label
#'
#' Removes the subscript, superscript, normal-text, font and symbol codes Grace
#' uses (`\\s`, `\\S`, `\\N`, `\\f{...}`, `\\x`), and turns the angstrom symbol
#' code into "A".
#'
#' @param x Character vector of labels.
#' @return The cleaned labels.
#'
#' @author Jared Andrews
#' @rdname INTERNAL_xvg_clean
#' @keywords internal
.xvg_clean <- function(x) {
    x <- gsub("[\\\\]f[{][^}]*[}]", "", x)
    x <- gsub("[\\\\]x[\\\\]?", "", x)
    x <- gsub("[\\\\][sSN]", "", x)
    trimws(x)
}
