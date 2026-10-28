# Helpers for the bulk expression heatmaps (sampleDistanceHeatmap, deHeatmap),
# which wrap VizModules' ComplexHeatmap_Heatmap module through
# .heatmap_wrapper_server() (R/heatmap_wrapper_helpers.R).


#' Transform the assay of a SummarizedExperiment once, for the heatmap wrappers
#'
#' @param se A `SummarizedExperiment`.
#' @param assay,transform As for [.se_transform()].
#' @return `list(se =, mat =)`, the object and its transformed assay.
#'
#' @author Jared Andrews
#' @rdname INTERNAL_se_stage
#' @keywords internal
.se_stage <- function(se, assay, transform) {
    list(se = se, mat = .se_transform(se, blank_to_null(assay), transform))
}


#' The first few sample-metadata columns that group samples (see [.se_group_cols()])
#'
#' @param meta A sample metadata data frame.
#' @param n The most columns to return.
#' @return Column names.
#'
#' @author Jared Andrews
#' @rdname INTERNAL_se_annotation_default
#' @keywords internal
.se_annotation_default <- function(meta, n = 2) {
    utils::head(.se_group_cols(meta), n)
}


#' Column annotation rows for the wrapped heatmap module
#'
#' @param cols Columns to show, top to bottom.
#' @param side `"Top"` or `"Bottom"` (`"Left"` / `"Right"` for rows).
#' @param prefix Row-name prefix.
#' @return A `multiDynamicInput()` row list, or `NULL`.
#'
#' @author Jared Andrews
#' @rdname INTERNAL_heatmap_annotation_rows
#' @keywords internal
.heatmap_annotation_rows <- function(cols, side = "Top", prefix = "c") {
    if (!length(cols)) {
        return(NULL)
    }
    stats::setNames(lapply(cols, function(a) list(column = a, side = side)), paste0(prefix, seq_along(cols)))
}


# ---- sampleDistanceHeatmap -------------------------------------------------

# Distance or correlation measures offered.
.sd_methods <- c("Euclidean distance" = "euclidean", "Pearson correlation" = "pearson",
    "Spearman correlation" = "spearman")


#' Default inputs for the sampleDistanceHeatmap module
#'
#' @param se A `SummarizedExperiment`, or `NULL`.
#' @param defaults A named list of user defaults, or `NULL`.
#' @return The wrapper's own defaults.
#'
#' @author Jared Andrews
#' @rdname INTERNAL_sd_defaults
#' @keywords internal
.sd_defaults <- function(se, defaults = NULL) {
    base <- list(
        sd.assay = if (is.null(se)) "" else .se_default_assay(se),
        sd.transform = .se_default_transform(),
        sd.ntop = 500,
        sd.method = "euclidean",
        sd.order = "cluster"
    )
    lapply(stats::setNames(names(base), names(base)), function(k) get_default(defaults, k, base[[k]]))
}

.sd_keys <- c("sd.assay", "sd.transform", "sd.ntop", "sd.method", "sd.order")


#' Legend title and colour ramp for a sample distance measure
#'
#' Distances are dark where samples are close, as in the DESeq2 vignette, and
#' correlations dark where they are similar, so the ramp runs the other way.
#'
#' @param method `"euclidean"`, `"pearson"` or `"spearman"`.
#' @return A list with `name`, `low_color`, `mid_color` and `high_color`.
#'
#' @author Jared Andrews
#' @rdname INTERNAL_sd_style
#' @keywords internal
.sd_style <- function(method) {
    dark <- "#08306B"
    light <- "#F7FBFF"
    if (identical(method, "euclidean")) {
        list(name = "Distance", low_color = dark, mid_color = "#6BAED6", high_color = light)
    } else {
        list(name = if (identical(method, "spearman")) "Spearman rho" else "Pearson r",
            low_color = light, mid_color = "#6BAED6", high_color = dark)
    }
}


#' Sample distances or correlations
#'
#' @param mat A transformed expression matrix, features by samples.
#' @param method `"euclidean"`, `"pearson"` or `"spearman"`.
#' @return A list with `values` (samples by samples: distances, or
#'   correlations) and `dist` (the distances clustering uses: Euclidean, or one
#'   minus the correlation).
#'
#' @importFrom stats dist cor as.dist
#' @author Jared Andrews
#' @rdname INTERNAL_sample_distances
#' @keywords internal
.sample_distances <- function(mat, method = "euclidean") {
    if (identical(method, "euclidean")) {
        d <- dist(t(mat))
        list(values = as.matrix(d), dist = d)
    } else {
        r <- cor(mat, method = method)
        list(values = r, dist = as.dist(1 - r))
    }
}


#' Build the heatmap data for the sampleDistanceHeatmap module
#'
#' @param staged A [.se_stage()] result.
#' @param ntop The number of most variable features the distances use.
#' @param method `"euclidean"`, `"pearson"` or `"spearman"`.
#' @param order `"cluster"` to order the samples by hierarchical clustering
#'   (complete linkage) of the distances, or `"data"` to keep their order.
#' @return A [.heatmap_frame()] result: samples by samples, row labels in
#'   `sample`, every sample-metadata column as a row annotation and in the
#'   column annotation table.
#'
#' @importFrom stats hclust
#' @author Jared Andrews
#' @rdname INTERNAL_sample_distance_data
#' @keywords internal
.sample_distance_data <- function(staged, ntop = 500, method = "euclidean", order = "cluster") {
    mat <- .se_top_variable(staged$mat, ntop)
    if (nrow(mat) < 2) stop("Fewer than two features vary across the samples.", call. = FALSE)
    if (ncol(mat) < 3) stop("At least three samples are needed for a distance heatmap.", call. = FALSE)
    dm <- .sample_distances(mat, method)
    idx <- if (identical(order, "cluster")) hclust(dm$dist, method = "complete")$order else seq_len(ncol(mat))
    values <- dm$values[idx, idx, drop = FALSE]
    meta <- .se_coldata(staged$se)[colnames(values), , drop = FALSE]
    .heatmap_frame(values, col.meta = meta, label = "sample", row.annotations = meta, key = "sample")
}


#' Heatmap defaults for the sampleDistanceHeatmap module
#'
#' @param frame A [.sample_distance_data()] result.
#' @param d The wrapper defaults from [.sd_defaults()].
#' @param defaults The caller's defaults.
#' @return Defaults for the wrapped heatmap module.
#'
#' @author Jared Andrews
#' @rdname INTERNAL_sd_heat_defaults
#' @keywords internal
.sd_heat_defaults <- function(frame, d, defaults = NULL) {
    meta <- frame$column_annotations[-1]
    base <- c(
        list(
            scale = "None",
            cluster_rows = FALSE,
            cluster_columns = FALSE,
            show_row_dend = FALSE,
            show_column_dend = FALSE,
            column_annotations = .heatmap_annotation_rows(.se_annotation_default(meta))
        ),
        .sd_style(d$sd.method)
    )
    .heatmap_defaults(frame, defaults, base[!vapply(base, is.null, logical(1))], wrapper.keys = .sd_keys)
}


# ---- deHeatmap -------------------------------------------------------------

#' Split a deHeatmap input into the experiment and its results
#'
#' @param x A list with the experiment (`object`, or `se`) and a results table
#'   (`results`), or a `SummarizedExperiment` whose `rowData` carries the
#'   statistics.
#' @return `list(se =, results =)`, `results` a data frame.
#'
#' @author Jared Andrews
#' @rdname INTERNAL_de_resolve
#' @keywords internal
.de_resolve <- function(x) {
    if (methods::is(x, "SummarizedExperiment")) {
        res <- as.data.frame(rowData(x), optional = TRUE)
        rownames(res) <- rownames(x)
        return(list(se = x, results = res))
    }
    if (!is.list(x) || is.null(x$results) || is.null(x$object %||% x$se)) {
        stop("'data' must be list(object = <SummarizedExperiment>, results = <DE results>), ",
            "or a SummarizedExperiment whose rowData holds the results.", call. = FALSE)
    }
    se <- .assert_se(x$object %||% x$se, "data$object")
    res <- as.data.frame(x$results, optional = TRUE)
    list(se = se, results = res)
}


#' Guess the columns of a DE results table
#'
#' Recognises DESeq2, edgeR, limma and Seurat names.
#'
#' @param res A results data frame.
#' @param se The experiment, whose row names the identifier column must match.
#' @return A list with `id` (`""` for the row names), `label`, `padj` and `lfc`.
#'
#' @author Jared Andrews
#' @rdname INTERNAL_de_guess_cols
#' @keywords internal
.de_guess_cols <- function(res, se) {
    num <- names(res)[vapply(res, is.numeric, logical(1))]
    chr <- names(res)[vapply(res, function(v) is.character(v) || is.factor(v), logical(1))]
    first <- function(cands, pool) {
        hit <- cands[cands %in% pool]
        if (length(hit)) hit[1] else if (length(pool)) pool[1] else ""
    }
    ids <- rownames(se)
    overlap <- vapply(chr, function(cl) sum(as.character(res[[cl]]) %in% ids), numeric(1))
    rn_overlap <- sum(rownames(res) %in% ids)
    id <- if (length(overlap) && max(overlap) > rn_overlap) chr[which.max(overlap)] else ""
    label_cands <- c("symbol", "SYMBOL", "gene_name", "gene_symbol", "Gene", "gene", "external_gene_name")
    list(
        id = id,
        label = if (any(label_cands %in% chr)) label_cands[label_cands %in% chr][1] else "",
        padj = first(c("padj", "FDR", "adj.P.Val", "p.adjust", "qvalue", "p_val_adj", "PValue", "pvalue",
            "P.Value"), num),
        lfc = first(c("log2FoldChange", "logFC", "log2FC", "avg_log2FC", "lfc"), num)
    )
}


#' Default inputs for the deHeatmap module
#'
#' @param x The module's data (see [.de_resolve()]), or `NULL`.
#' @param defaults A named list of user defaults, or `NULL`.
#' @return The wrapper's own defaults.
#'
#' @author Jared Andrews
#' @rdname INTERNAL_de_defaults
#' @keywords internal
.de_defaults <- function(x, defaults = NULL) {
    base <- list(
        de.id.col = "", de.label.col = "", de.padj.col = "", de.lfc.col = "",
        de.padj.cutoff = 0.05, de.lfc.cutoff = 1, de.top.n = 50, de.rank.by = "padj", de.direction = "both",
        de.assay = "", de.transform = .se_default_transform()
    )
    if (!is.null(x)) {
        r <- .de_resolve(x)
        g <- .de_guess_cols(r$results, r$se)
        base$de.id.col <- g$id
        base$de.label.col <- g$label
        base$de.padj.col <- g$padj
        base$de.lfc.col <- g$lfc
        base$de.assay <- .se_default_assay(r$se)
    }
    lapply(stats::setNames(names(base), names(base)), function(k) get_default(defaults, k, base[[k]]))
}

.de_keys <- c("de.id.col", "de.label.col", "de.padj.col", "de.lfc.col", "de.padj.cutoff", "de.lfc.cutoff",
    "de.top.n", "de.rank.by", "de.direction", "de.assay", "de.transform")


#' Select the top differentially expressed genes
#'
#' @param res A results data frame.
#' @param ids Gene identifiers of the experiment (its row names).
#' @param id.col Results column matching `ids`, or `""` for the row names.
#' @param padj.col,lfc.col The adjusted p-value and log2 fold change columns.
#' @param padj.cutoff Keep genes with an adjusted p-value below this.
#' @param lfc.cutoff Keep genes with an absolute log2 fold change of at least this.
#' @param top.n The most genes to keep.
#' @param rank.by `"padj"` (most significant first, ties by fold change) or
#'   `"lfc"` (largest absolute fold change first).
#' @param direction `"both"`, `"up"` or `"down"`.
#' @return The kept rows of `res`, ranked, with columns `.id` (the matched
#'   identifier), `.padj` and `.lfc` added.
#'
#' @author Jared Andrews
#' @rdname INTERNAL_de_select
#' @keywords internal
.de_select <- function(res, ids, id.col = "", padj.col, lfc.col, padj.cutoff = 0.05, lfc.cutoff = 1,
                       top.n = 50, rank.by = "padj", direction = "both") {
    if (!nz_value(padj.col) || !padj.col %in% names(res)) stop("Choose the adjusted p-value column.", call. = FALSE)
    if (!nz_value(lfc.col) || !lfc.col %in% names(res)) stop("Choose the log2 fold change column.", call. = FALSE)
    res$.id <- if (nz_value(id.col) && id.col %in% names(res)) as.character(res[[id.col]]) else rownames(res)
    res$.padj <- as.numeric(res[[padj.col]])
    res$.lfc <- as.numeric(res[[lfc.col]])
    keep <- !is.na(res$.padj) & !is.na(res$.lfc) & res$.id %in% ids &
        res$.padj < (padj.cutoff %||% 0.05) & abs(res$.lfc) >= (lfc.cutoff %||% 0)
    if (identical(direction, "up")) keep <- keep & res$.lfc > 0
    if (identical(direction, "down")) keep <- keep & res$.lfc < 0
    res <- res[keep, , drop = FALSE]
    res <- res[!duplicated(res$.id), , drop = FALSE]
    o <- if (identical(rank.by, "lfc")) order(-abs(res$.lfc), res$.padj) else order(res$.padj, -abs(res$.lfc))
    utils::head(res[o, , drop = FALSE], max(1L, as.integer(top.n %||% 50)))
}


#' Build the heatmap data for the deHeatmap module
#'
#' @param staged A [.se_stage()] result.
#' @param res The results data frame.
#' @param d The wrapper's resolved inputs (as from [.de_defaults()]).
#' @return A [.heatmap_frame()] result: the selected genes by samples, row
#'   labels in `gene`, `direction` and `log2FC` row annotations, the sample
#'   metadata as the column annotation table.
#'
#' @author Jared Andrews
#' @rdname INTERNAL_de_heatmap_data
#' @keywords internal
.de_heatmap_data <- function(staged, res, d) {
    sel <- .de_select(res, rownames(staged$mat), d$de.id.col, d$de.padj.col, d$de.lfc.col, d$de.padj.cutoff,
        d$de.lfc.cutoff, d$de.top.n, d$de.rank.by, d$de.direction)
    if (nrow(sel) < 2) stop("Fewer than two genes pass the cut-offs; loosen them.", call. = FALSE)
    mat <- staged$mat[sel$.id, , drop = FALSE]
    v <- .row_vars(mat)
    ok <- rowSums(!is.finite(mat)) == 0 & is.finite(v) & v > 0
    sel <- sel[ok, , drop = FALSE]
    mat <- mat[ok, , drop = FALSE]
    if (nrow(mat) < 2) stop("Fewer than two of the selected genes vary across the samples.", call. = FALSE)

    has_label <- nz_value(d$de.label.col) && d$de.label.col %in% names(sel)
    labels <- if (has_label) as.character(sel[[d$de.label.col]]) else sel$.id
    labels <- make.unique(ifelse(is.na(labels) | !nzchar(labels), sel$.id, labels))
    rownames(mat) <- labels
    ann <- data.frame(
        direction = factor(ifelse(sel$.lfc > 0, "Up", "Down"), levels = c("Up", "Down")),
        log2FC = sel$.lfc,
        stringsAsFactors = FALSE
    )
    .heatmap_frame(mat, col.meta = .se_coldata(staged$se), label = "gene", row.annotations = ann, key = "sample")
}


#' Heatmap defaults for the deHeatmap module
#'
#' @param frame A [.de_heatmap_data()] result.
#' @param defaults The caller's defaults.
#' @return Defaults for the wrapped heatmap module.
#'
#' @author Jared Andrews
#' @rdname INTERNAL_de_heat_defaults
#' @keywords internal
.de_heat_defaults <- function(frame, defaults = NULL) {
    meta <- frame$column_annotations[-1]
    base <- list(
        name = "Expression",
        scale = "Rows",
        row_annotations = list(r1 = list(column = "direction", side = "Left")),
        column_annotations = .heatmap_annotation_rows(.se_annotation_default(meta)),
        row_split_by = "Annotation",
        row_split_cols = "direction",
        show_row_slice_titles = FALSE,
        row_names_fontsize = 8,
        direction = c(Up = "#B2182B", Down = "#2166AC")
    )
    .heatmap_defaults(frame, defaults, base[!vapply(base, is.null, logical(1))], wrapper.keys = .de_keys)
}


#' The deHeatmap wrapper's inputs, read from the session
#'
#' @param input The module's input.
#' @param isolate_fn The isolation helper.
#' @param d Fallback values, from [.de_defaults()].
#' @return A list of the wrapper's input values.
#'
#' @author Jared Andrews
#' @rdname INTERNAL_de_read_inputs
#' @keywords internal
.de_read_inputs <- function(input, isolate_fn, d) {
    .sci_fill_inputs(list(
        de.id.col = isolate_fn(input$de.id.col),
        de.label.col = isolate_fn(input$de.label.col),
        de.padj.col = isolate_fn(input$de.padj.col),
        de.lfc.col = isolate_fn(input$de.lfc.col),
        de.padj.cutoff = isolate_fn(input$de.padj.cutoff),
        de.lfc.cutoff = isolate_fn(input$de.lfc.cutoff),
        de.top.n = isolate_fn(input$de.top.n),
        de.rank.by = isolate_fn(input$de.rank.by),
        de.direction = isolate_fn(input$de.direction)
    ), d)
}
