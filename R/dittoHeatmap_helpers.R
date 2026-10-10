#' Assays a dittoSeq object offers for a heatmap
#'
#' @param object A dittoSeq-compatible object.
#' @return The assay names of a `SummarizedExperiment`-family object, or
#'   `character(0)` (dittoSeq then picks the default assay itself).
#'
#' @author Jared Andrews
#' @rdname INTERNAL_ditto_assays
#' @keywords internal
.ditto_assays <- function(object) {
    if (methods::is(object, "SummarizedExperiment")) .se_assays(object) else character(0)
}


#' The assay dittoSeq uses by default
#'
#' @param object A dittoSeq-compatible object.
#' @return The first of `logcounts`, `normcounts` and `counts` present (as
#'   dittoSeq chooses), otherwise the first assay, or `""`.
#'
#' @author Jared Andrews
#' @rdname INTERNAL_ditto_default_assay
#' @keywords internal
.ditto_default_assay <- function(object) {
    a <- .ditto_assays(object)
    hit <- intersect(c("logcounts", "normcounts", "counts"), a)
    if (length(hit)) hit[1] else if (length(a)) a[1] else ""
}


#' The most variable genes of a dittoSeq object
#'
#' Variances are computed with matrix products, so a sparse or delayed assay is
#' never expanded to a dense matrix.
#'
#' @param object A dittoSeq-compatible object.
#' @param assay The assay to use.
#' @param n The number of genes to return.
#' @return Gene names. Objects that are not a `SummarizedExperiment`, or whose
#'   assay cannot be read, give the first `n` genes.
#'
#' @author Jared Andrews
#' @rdname INTERNAL_ditto_top_variable_genes
#' @keywords internal
.ditto_top_variable_genes <- function(object, assay = NULL, n = 20) {
    genes <- .ditto_genes(object)
    if (length(genes) <= n) {
        return(genes)
    }
    tryCatch({
        x <- SummarizedExperiment::assay(object, assay %||% .ditto_default_assay(object))
        k <- ncol(x)
        one <- rep(1, k)
        s1 <- as.vector(x %*% one)
        s2 <- as.vector((x * x) %*% one)
        v <- (s2 - s1^2 / k) / max(k - 1, 1)
        rownames(x)[utils::head(order(v, decreasing = TRUE), n)]
    }, error = function(e) utils::head(genes, n))
}


#' Default inputs for the dittoHeatmap module
#'
#' Shared by the UI, the server and the Reset handler. User values win.
#'
#' @param object A dittoSeq-compatible object, or `NULL`.
#' @param defaults A named list of user defaults, or `NULL`.
#' @return A named list with the wrapper's own defaults (`dh.genes`, `dh.assay`,
#'   `dh.order.by`, `annot.by`).
#'
#' @author Jared Andrews
#' @rdname INTERNAL_dh_defaults
#' @keywords internal
.dh_defaults <- function(object, defaults = NULL) {
    base <- list(dh.genes = character(0), dh.assay = "", dh.order.by = "", annot.by = character(0))
    if (!is.null(object)) {
        disc <- .ditto_discrete_metas(object)
        base$dh.assay <- .ditto_default_assay(object)
        base$dh.genes <- .ditto_top_variable_genes(object, blank_to_null(base$dh.assay), 20)
        base$annot.by <- if (length(disc)) disc[1] else character(0)
        base$dh.order.by <- if (length(disc)) disc[1] else ""
    }
    lapply(stats::setNames(names(base), names(base)), function(k) get_default(defaults, k, base[[k]]))
}

# The dittoHeatmap wrapper's own keys, kept out of the defaults handed to the
# wrapped heatmap module.
.dh_keys <- c("dh.genes", "dh.assay", "dh.order.by", "annot.by")


#' Per-cell metadata of a dittoSeq object
#'
#' @param object A dittoSeq-compatible object.
#' @param cells The cell names, in matrix column order.
#' @return A data frame of the atomic metadata columns, row names `cells`.
#'
#' @author Jared Andrews
#' @rdname INTERNAL_ditto_cell_meta
#' @keywords internal
.ditto_cell_meta <- function(object, cells) {
    metas <- .ditto_metas(object)
    cols <- list()
    for (m in metas) {
        v <- .ditto_meta_values(object, m)
        if ((is.atomic(v) || is.factor(v)) && length(v) == length(cells)) cols[[m]] <- v
    }
    if (!length(cols)) {
        return(data.frame(row.names = cells))
    }
    df <- as.data.frame(cols, optional = TRUE, stringsAsFactors = FALSE)
    names(df) <- names(cols)
    rownames(df) <- cells
    df
}


#' Build the heatmap data for the dittoHeatmap module
#'
#' Pulls the expression of `genes` with [dittoSeq::dittoHeatmap()]
#' (`data.out = TRUE`, unscaled; the wrapped module scales), drops genes that do
#' not vary across the cells, and attaches every cell's metadata as the column
#' annotation table.
#'
#' @param object A dittoSeq-compatible object.
#' @param genes The genes to show.
#' @param assay The assay, or `NULL` / `""` for dittoSeq's default.
#' @param order.by A metadata column the cells are ordered by, or `""` for the
#'   object's order.
#' @return A [.heatmap_frame()] result: genes by cells, row labels in `gene`,
#'   column key `cell`.
#'
#' @author Jared Andrews
#' @rdname INTERNAL_ditto_heatmap_data
#' @keywords internal
.ditto_heatmap_data <- function(object, genes, assay = NULL, order.by = "") {
    cells <- colnames(object)
    if (is.null(cells)) stop("The object needs cell (column) names.", call. = FALSE)
    genes <- intersect(as.character(genes), .ditto_genes(object))
    if (length(genes) < 2) stop("Choose at least two genes.", call. = FALSE)

    args <- list(object = object, genes = genes, order.by = NULL, scale = "none", data.out = TRUE)
    if (nz_value(assay)) args$assay <- assay
    out <- suppressWarnings(do.call(dittoSeq::dittoHeatmap, args))
    mat <- as.matrix(out$mat)
    storage.mode(mat) <- "double"
    mat <- .heatmap_clean_rows(mat)[, .ditto_heatmap_order(object, order.by), drop = FALSE]

    .heatmap_frame(mat, .ditto_cell_meta(object, colnames(mat)), label = "gene", key = "cell")
}


#' Cell order for the dittoHeatmap module
#'
#' @param object A dittoSeq-compatible object.
#' @param order.by A metadata column to order the cells by, or `""` to keep the
#'   object's order.
#' @return Cell names.
#'
#' @author Jared Andrews
#' @rdname INTERNAL_ditto_heatmap_order
#' @keywords internal
.ditto_heatmap_order <- function(object, order.by = "") {
    cells <- colnames(object)
    if (!nz_value(order.by)) {
        return(cells)
    }
    vals <- .ditto_meta_values(object, order.by)
    if (is.null(vals) || length(vals) != length(cells)) {
        return(cells)
    }
    cells[order(vals)]
}


#' Heatmap defaults for the dittoHeatmap module
#'
#' @param frame A [.ditto_heatmap_data()] result.
#' @param object The dittoSeq object.
#' @param d The wrapper defaults from [.dh_defaults()].
#' @param defaults The caller's defaults.
#' @return Defaults for the wrapped heatmap module.
#'
#' @author Jared Andrews
#' @rdname INTERNAL_dh_heat_defaults
#' @keywords internal
.dh_heat_defaults <- function(frame, object, d, defaults = NULL) {
    annot <- intersect(d$annot.by, names(frame$column_annotations))
    base <- list(
        name = "Expression",
        scale = "Rows",
        cluster_rows = TRUE,
        cluster_columns = FALSE,
        show_column_dend = FALSE,
        show_column_names = ncol(object) <= 50,
        column_annotations = if (length(annot)) {
            stats::setNames(lapply(annot, function(a) list(column = a, side = "Top")), paste0("c", seq_along(annot)))
        }
    )
    if (length(annot)) {
        # dittoSeq's own annotation palette, which offsets each track's colours
        # so two tracks never share one.
        colors <- tryCatch(
            suppressWarnings(dittoSeq::dittoHeatmap(object,
                genes = utils::head(frame$matrix[[attr(frame, "keys")$label]], 2),
                annot.by = annot, order.by = NULL, scale = "none", data.out = TRUE
            )$annotation_colors),
            error = function(e) NULL
        )
        base <- c(base, .heatmap_annotation_colors(colors))
    }
    base <- base[!vapply(base, is.null, logical(1))]
    .heatmap_defaults(frame, defaults, base, wrapper.keys = .dh_keys)
}
