#' Create an oncoPrint (oncoplot) from a tidy mutation table
#'
#' Builds a mutation landscape ("oncoprint") from a long / tidy table of
#' mutation calls and returns a drawn [ComplexHeatmap::oncoPrint()] object. Each
#' column is a sample, each row is a gene, and the coloured tiles encode which
#' alteration(s) were observed. Rows are ordered by their overall alteration
#' frequency and per-gene / per-sample alteration barplots are added by
#' `oncoPrint()`.
#'
#' @details The input `data` is expected in **tidy (long)** form: one row per
#' observed alteration, with a sample column, a gene column, and an alteration
#' column. It is pivoted internally (via [.onco_to_matrix()]) into the character
#' matrix [ComplexHeatmap::oncoPrint()] expects, where each cell is a
#' `;`-separated string of the alteration types seen for that gene/sample pair.
#'
#' When `col` is `NULL`, a colour is assigned to each alteration type
#' automatically ([.onco_default_colors()]), preferring stable colours for
#' common alteration names. The `alter_fun` that draws the tiles is likewise
#' derived from the colour map ([.onco_alter_fun()]).
#'
#' The returned object is the value of [ComplexHeatmap::oncoPrint()] (an
#' undrawn `Heatmap`/`HeatmapList`). Printing it at the console draws it, while
#' the interactive Shiny wrapper
#' ([InteractiveComplexHeatmap::makeInteractiveComplexHeatmap()]) requires it
#' undrawn so it can render onto the Shiny output device itself.
#'
#' @param data A tidy (long) data frame of mutation calls, or a pre-built
#'   character matrix of `;`-separated alteration strings (genes x samples). When
#'   a matrix is supplied the `sample`/`gene`/`alteration` arguments are ignored.
#' @param sample The name of the sample column (default `"sample"`).
#' @param gene The name of the gene column (default `"gene"`).
#' @param alteration The name of the alteration-type column
#'   (default `"alteration"`).
#' @param col An optional named character vector mapping alteration types to
#'   colours. When `NULL` (the default) colours are assigned automatically.
#' @param top.n Optional integer; keep only the `top.n` most frequently altered
#'   genes. `NULL` (the default) keeps all genes.
#' @param remove.empty.columns Logical; drop samples with no alterations
#'   (passed to [ComplexHeatmap::oncoPrint()], default `FALSE`).
#' @param remove.empty.rows Logical; drop genes with no alterations
#'   (default `FALSE`).
#' @param show.column.names Logical; show sample names along the bottom
#'   (default `FALSE`, as sample counts are often large).
#' @param show.pct Logical; show the per-gene alteration percentage on the left
#'   (default `TRUE`).
#' @param row.names.side,pct.side Sides for the row names and percentage
#'   annotations (passed through to [ComplexHeatmap::oncoPrint()]).
#' @param column.title,row.title Optional plot titles.
#' @param background Colour of the empty-cell background rectangle
#'   (default `"#CCCCCC"`).
#' @param border Logical; draw a border around each cell (default `FALSE`).
#' @param row.font.size,column.font.size Font sizes (in points) for the gene
#'   (row) and sample (column) names.
#' @param top.annotation,bottom.annotation,left.annotation,right.annotation
#'   Optional prebuilt [ComplexHeatmap::HeatmapAnnotation()] objects attached to
#'   the corresponding side. Typically built by [.onco_collect_annotations()]
#'   from the module's dynamic annotation adder. When a `top.annotation` or
#'   `right.annotation` is supplied, oncoPrint's default per-sample / per-gene
#'   alteration barplots are preserved alongside the user track(s).
#' @param ... Further arguments passed to [ComplexHeatmap::oncoPrint()].
#'
#' @return A `Heatmap`/`HeatmapList` object as returned by
#'   [ComplexHeatmap::oncoPrint()] (undrawn).
#'
#' @importFrom ComplexHeatmap oncoPrint HeatmapAnnotation rowAnnotation
#'   anno_oncoprint_barplot
#'
#' @export
#' @author Jacob Martin, Jared Andrews
#' @seealso [ComplexHeatmap::oncoPrint()],
#' [sciVizModules::oncoPlotInputsUI()], [sciVizModules::oncoPlotServer()],
#' [sciVizModules::oncoPlotApp()]
#' @examples
#' library(sciVizModules)
#' data(example_mutations)
#' if (requireNamespace("ComplexHeatmap", quietly = TRUE)) {
#'     ht <- oncoPlot(example_mutations)
#'     if (interactive()) ht
#' }
oncoPlot <- function(data,
                     sample = "sample",
                     gene = "gene",
                     alteration = "alteration",
                     col = NULL,
                     top.n = NULL,
                     remove.empty.columns = FALSE,
                     remove.empty.rows = FALSE,
                     show.column.names = FALSE,
                     show.pct = TRUE,
                     row.names.side = "left",
                     pct.side = "right",
                     column.title = NULL,
                     row.title = NULL,
                     background = "#CCCCCC",
                     border = FALSE,
                     row.font.size = 12,
                     column.font.size = 10,
                     top.annotation = NULL,
                     bottom.annotation = NULL,
                     left.annotation = NULL,
                     right.annotation = NULL,
                     ...) {
    if (!requireNamespace("ComplexHeatmap", quietly = TRUE)) {
        stop(
            "The 'ComplexHeatmap' package is required for oncoPlot(). ",
            "Install it with BiocManager::install('ComplexHeatmap')."
        )
    }

    # Accept either a tidy data frame (pivot it) or a ready-made matrix.
    if (is.matrix(data)) {
        mat <- data
        storage.mode(mat) <- "character"
        mat[is.na(mat)] <- ""
    } else {
        stopifnot(is.data.frame(data))
        mat <- .onco_to_matrix(data, sample, gene, alteration)
    }

    if (!is.null(top.n) && is.finite(top.n) && top.n >= 1 && top.n < nrow(mat)) {
        n.alt <- rowSums(.onco_nzchar_matrix(mat))
        keep <- order(n.alt, decreasing = TRUE)[seq_len(top.n)]
        mat <- mat[sort(keep), , drop = FALSE]
    }

    types <- .onco_alteration_types(mat)
    if (!length(types)) {
        stop("No alterations found to plot.")
    }

    if (is.null(col)) {
        col <- .onco_default_colors(types)
    } else {
        # Ensure every observed type has a colour; fill gaps automatically.
        missing.types <- setdiff(types, names(col))
        if (length(missing.types)) {
            col <- c(col, .onco_default_colors(missing.types))
        }
        col <- col[names(col) %in% types]
    }

    alter_fun <- .onco_alter_fun(col, background = background)

    # Guard against dimension mismatches: annotations must match the *final*
    # matrix (after any top.n filtering). When they do not (e.g. annotations
    # were built before top.n subsetting), drop them with a warning rather than
    # letting oncoPrint() error out.
    n_col <- ncol(mat)
    n_row <- nrow(mat)
    .ann_len_ok <- function(ann, expected) {
        if (is.null(ann)) {
            return(TRUE)
        }
        n <- tryCatch(ann@anno_list[[1]]@fun@n, error = function(e) NA_integer_)
        is.na(n) || n == expected
    }
    for (nm in c("top.annotation", "bottom.annotation")) {
        a <- get(nm)
        if (!is.null(a) && !isTRUE(.ann_len_ok(a, n_col))) {
            warning(nm, " does not match the number of samples; dropping it.")
            assign(nm, NULL)
        }
    }
    for (nm in c("left.annotation", "right.annotation")) {
        a <- get(nm)
        if (!is.null(a) && !isTRUE(.ann_len_ok(a, n_row))) {
            warning(nm, " does not match the number of genes; dropping it.")
            assign(nm, NULL)
        }
    }

    # Assemble side-annotation arguments. When a user top/right annotation is
    # supplied, prepend oncoPrint's default per-sample / per-gene alteration
    # barplot so it is kept alongside the user's track(s).
    onco_args <- list(
        mat,
        alter_fun = alter_fun,
        col = col,
        remove_empty_columns = isTRUE(remove.empty.columns),
        remove_empty_rows = isTRUE(remove.empty.rows),
        show_column_names = isTRUE(show.column.names),
        pct_side = pct.side,
        row_names_side = row.names.side,
        show_pct = isTRUE(show.pct),
        column_title = column.title,
        row_title = row.title,
        border = isTRUE(border),
        row_names_gp = grid::gpar(fontsize = row.font.size),
        column_names_gp = grid::gpar(fontsize = column.font.size),
        pct_gp = grid::gpar(fontsize = row.font.size)
    )

    if (!is.null(top.annotation)) {
        onco_args$top_annotation <- c(
            ComplexHeatmap::HeatmapAnnotation(
                cbar = ComplexHeatmap::anno_oncoprint_barplot(),
                which = "column"
            ),
            top.annotation
        )
    }
    if (!is.null(bottom.annotation)) onco_args$bottom_annotation <- bottom.annotation
    if (!is.null(right.annotation)) {
        onco_args$right_annotation <- c(
            ComplexHeatmap::rowAnnotation(
                rbar = ComplexHeatmap::anno_oncoprint_barplot()
            ),
            right.annotation
        )
    }
    if (!is.null(left.annotation)) onco_args$left_annotation <- left.annotation

    ht <- do.call(ComplexHeatmap::oncoPrint, c(onco_args, list(...)))

    # Return the *undrawn* oncoPrint object. Printing it at the console
    # auto-draws it, while InteractiveComplexHeatmap::makeInteractiveComplexHeatmap()
    # requires an undrawn object so it can draw onto the Shiny output device
    # itself. Calling draw() here would render to the active (console) device.
    ht
}
