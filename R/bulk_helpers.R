#' Check that an object is a SummarizedExperiment
#'
#' @param x The object to check.
#' @param arg Argument name for the error message.
#' @return `x`, invisibly.
#'
#' @importFrom methods is
#' @author Jared Andrews
#' @rdname INTERNAL_assert_se
#' @keywords internal
.assert_se <- function(x, arg = "data") {
    if (!methods::is(x, "SummarizedExperiment")) {
        stop("'", arg, "' must be a SummarizedExperiment (or a subclass, such as a DESeqDataSet).",
            call. = FALSE)
    }
    invisible(x)
}


#' Assay names of a SummarizedExperiment
#'
#' @param se A `SummarizedExperiment`.
#' @return The assay names, or `"1"` for a single unnamed assay.
#'
#' @importFrom SummarizedExperiment assayNames
#' @author Jared Andrews
#' @rdname INTERNAL_se_assays
#' @keywords internal
.se_assays <- function(se) {
    nms <- assayNames(se)
    if (is.null(nms) || !length(nms)) {
        return(as.character(seq_along(SummarizedExperiment::assays(se))))
    }
    nms[!nzchar(nms)] <- as.character(which(!nzchar(nms)))
    nms
}


#' The default assay of a SummarizedExperiment
#'
#' @param se A `SummarizedExperiment`.
#' @return `"counts"` when present, otherwise the first assay.
#'
#' @author Jared Andrews
#' @rdname INTERNAL_se_default_assay
#' @keywords internal
.se_default_assay <- function(se) {
    a <- .se_assays(se)
    if ("counts" %in% a) "counts" else a[1]
}


#' Transformations offered for a bulk expression assay
#'
#' The variance-stabilising transformation is offered only when DESeq2 is
#' installed.
#'
#' @return A named character vector of transformation choices.
#'
#' @author Jared Andrews
#' @rdname INTERNAL_se_transform_choices
#' @keywords internal
.se_transform_choices <- function() {
    c(
        if (requireNamespace("DESeq2", quietly = TRUE)) c("Variance stabilised (DESeq2)" = "vst"),
        "log2 CPM" = "log2cpm",
        "log2(x + 1)" = "log2",
        "None (assay as is)" = "none"
    )
}


#' The default transformation for a bulk count assay
#'
#' @return `"vst"` when DESeq2 is installed, otherwise `"log2cpm"`.
#'
#' @author Jared Andrews
#' @rdname INTERNAL_se_default_transform
#' @keywords internal
.se_default_transform <- function() {
    if (requireNamespace("DESeq2", quietly = TRUE)) "vst" else "log2cpm"
}


#' Log2 counts per million
#'
#' Computed as [edgeR::cpm()] does with `log = TRUE`: the prior count is scaled
#' by each library's size relative to the mean, and twice it is added to the
#' library size, so a zero count maps to a finite value and libraries of
#' different depth are treated alike.
#'
#' @param counts A numeric matrix of counts, features by samples.
#' @param prior.count The average prior count added to each observation.
#' @return A matrix of log2 CPM values.
#'
#' @author Jared Andrews
#' @rdname INTERNAL_log2_cpm
#' @keywords internal
.log2_cpm <- function(counts, prior.count = 2) {
    lib <- colSums(counts)
    offset <- prior.count * lib / mean(lib)
    adj <- lib + 2 * offset
    log2(t((t(counts) + offset) / adj * 1e6))
}


#' Variance-stabilise a count matrix with DESeq2
#'
#' Uses [DESeq2::vst()], falling back to
#' [DESeq2::varianceStabilizingTransformation()] when the matrix has too few
#' genes for `vst()`'s subsampled dispersion fit.
#'
#' @param counts A matrix of non-negative integer counts, features by samples.
#' @return The transformed matrix.
#'
#' @author Jared Andrews
#' @rdname INTERNAL_vst_counts
#' @keywords internal
.vst_counts <- function(counts) {
    if (!requireNamespace("DESeq2", quietly = TRUE)) {
        stop("The variance-stabilising transformation needs DESeq2: BiocManager::install('DESeq2').",
            call. = FALSE)
    }
    if (any(counts < 0, na.rm = TRUE) || any(counts != round(counts), na.rm = TRUE)) {
        stop("The variance-stabilising transformation needs raw (non-negative integer) counts; ",
            "choose another transformation or assay.", call. = FALSE)
    }
    storage.mode(counts) <- "integer"
    dds <- suppressMessages(DESeq2::DESeqDataSetFromMatrix(
        counts, colData = data.frame(row.names = colnames(counts)), design = ~1
    ))
    out <- tryCatch(
        suppressMessages(DESeq2::vst(dds, blind = TRUE)),
        error = function(e) suppressMessages(DESeq2::varianceStabilizingTransformation(dds, blind = TRUE))
    )
    mat <- SummarizedExperiment::assay(out)
    dimnames(mat) <- dimnames(counts)
    mat
}


#' Transform a bulk expression assay
#'
#' @param se A `SummarizedExperiment`.
#' @param assay The assay to use.
#' @param method `"vst"` ([DESeq2::vst()]), `"log2cpm"` (as [edgeR::cpm()] with
#'   `log = TRUE`), `"log2"` (`log2(x + 1)`) or `"none"`.
#' @return A numeric matrix, features by samples.
#'
#' @importFrom SummarizedExperiment assay
#' @author Jared Andrews
#' @rdname INTERNAL_se_transform
#' @keywords internal
.se_transform <- function(se, assay = NULL, method = c("vst", "log2cpm", "log2", "none")) {
    method <- match.arg(method)
    assay <- assay %||% .se_default_assay(se)
    a <- if (assay %in% assayNames(se)) assay else as.integer(assay)
    mat <- as.matrix(SummarizedExperiment::assay(se, a))
    storage.mode(mat) <- "double"
    if (is.null(colnames(mat))) colnames(mat) <- paste0("sample", seq_len(ncol(mat)))
    if (is.null(rownames(mat))) rownames(mat) <- paste0("feature", seq_len(nrow(mat)))
    switch(method,
        vst = .vst_counts(mat),
        log2cpm = .log2_cpm(mat),
        log2 = {
            if (any(mat < 0, na.rm = TRUE)) {
                stop("log2(x + 1) needs non-negative values; choose another transformation.", call. = FALSE)
            }
            log2(mat + 1)
        },
        none = mat
    )
}


#' Per-row variances of a matrix
#'
#' @param mat A numeric matrix.
#' @return A numeric vector, one variance per row.
#'
#' @author Jared Andrews
#' @rdname INTERNAL_row_vars
#' @keywords internal
.row_vars <- function(mat) {
    n <- rowSums(!is.na(mat))
    centred <- mat - rowMeans(mat, na.rm = TRUE)
    rowSums(centred^2, na.rm = TRUE) / pmax(n - 1, 1)
}


#' Keep the most variable rows of a matrix
#'
#' Rows with zero, missing or non-finite variance are dropped first.
#'
#' @param mat A numeric matrix, features by samples.
#' @param n The number of rows to keep (at least two, the fewest a PCA or a
#'   clustering can use); `NA` keeps them all.
#' @return The matrix restricted to its `n` most variable rows, in decreasing
#'   order of variance.
#'
#' @author Jared Andrews
#' @rdname INTERNAL_se_top_variable
#' @keywords internal
.se_top_variable <- function(mat, n = 500) {
    v <- .row_vars(mat)
    ok <- is.finite(v) & v > 0 & rowSums(!is.finite(mat)) == 0
    idx <- which(ok)[order(v[ok], decreasing = TRUE)]
    if (length(n) == 1 && !is.na(n)) idx <- utils::head(idx, max(2L, as.integer(n)))
    mat[idx, , drop = FALSE]
}


#' Sample metadata of a SummarizedExperiment as a data frame
#'
#' List-like columns (nested `DataFrame`s, `List`s) are dropped, since they cannot
#' be plotted.
#'
#' @param se A `SummarizedExperiment`.
#' @return A data frame with one row per sample, row names the sample names.
#'
#' @importFrom SummarizedExperiment colData
#' @author Jared Andrews
#' @rdname INTERNAL_se_coldata
#' @keywords internal
.se_coldata <- function(se) {
    cd <- colData(se)
    keep <- vapply(seq_len(ncol(cd)), function(i) is.atomic(cd[[i]]) || is.factor(cd[[i]]), logical(1))
    df <- as.data.frame(cd[, keep, drop = FALSE], optional = TRUE)
    rownames(df) <- colnames(se) %||% paste0("sample", seq_len(ncol(se)))
    df
}


#' Feature-label columns of a SummarizedExperiment
#'
#' @param se A `SummarizedExperiment`.
#' @return The names of the character or factor `rowData` columns.
#'
#' @importFrom SummarizedExperiment rowData
#' @author Jared Andrews
#' @rdname INTERNAL_se_label_cols
#' @keywords internal
.se_label_cols <- function(se) {
    rd <- rowData(se)
    if (!ncol(rd)) {
        return(character(0))
    }
    names(rd)[vapply(seq_len(ncol(rd)), function(i) is.character(rd[[i]]) || is.factor(rd[[i]]), logical(1))]
}


#' Feature labels from a rowData column, falling back to the row names
#'
#' @param se A `SummarizedExperiment`.
#' @param ids The feature identifiers (row names) to label.
#' @param col A `rowData` column, or `NULL` / `""` for the row names.
#' @return A character vector of labels, made unique.
#'
#' @author Jared Andrews
#' @rdname INTERNAL_se_feature_labels
#' @keywords internal
.se_feature_labels <- function(se, ids, col = NULL) {
    if (!nz_value(col) || !col %in% names(rowData(se))) {
        return(ids)
    }
    lab <- as.character(rowData(se)[[col]])[match(ids, rownames(se))]
    lab <- ifelse(is.na(lab) | !nzchar(lab), ids, lab)
    make.unique(lab)
}


#' Principal component analysis of a bulk expression experiment
#'
#' Builds the object the PCAtools modules ([pcaBiplotServer()],
#' [pcaScreePlotServer()], [pcaLoadingsPlotServer()], [pcaPairsPlotServer()],
#' [pcaEigencorPlotServer()]) take, from a `SummarizedExperiment` of counts: the
#' assay is transformed, the most variable genes kept, and the samples projected
#' with [stats::prcomp()]. The result has the shape [PCAtools::pca()] returns,
#' with the sample metadata from `colData`, so PCAtools is not needed.
#'
#' @param object A `SummarizedExperiment` (a `DESeqDataSet` will do), or a
#'   numeric matrix with features in rows and samples in columns.
#' @param assay The assay to use. Default: `"counts"` when present, otherwise
#'   the first.
#' @param transform `"vst"` (DESeq2's variance-stabilising transformation; the
#'   default when DESeq2 is installed), `"log2cpm"` (log2 counts per million, as
#'   [edgeR::cpm()] with `log = TRUE`; the default otherwise), `"log2"`
#'   (`log2(x + 1)`) or `"none"` (an already-transformed assay).
#' @param ntop The number of most variable features to keep. `NA` keeps every
#'   feature with non-zero variance.
#' @param center,scale Passed to [stats::prcomp()]: centre each feature, and
#'   scale it to unit variance.
#' @param feature.labels A `rowData` column whose values name the features in
#'   the loadings (e.g. `"symbol"`), or `NULL` for the row names.
#' @param metadata For a matrix `object`, an optional data frame of sample
#'   metadata with one row per column; ignored for a `SummarizedExperiment`,
#'   whose `colData` is used.
#'
#' @return A list of class `"pca"` with elements `rotated` (sample scores),
#'   `loadings`, `variance` (percent explained), `sdev`, `metadata`, `xvars`
#'   (features), `yvars` (samples) and `components`.
#'
#' @importFrom stats prcomp
#' @seealso [samplePCAServer()], [PCAtools::pca()], [pcaBiplotServer()]
#' @export
#' @author Jared Andrews
#' @examples
#' if (requireNamespace("airway", quietly = TRUE)) {
#'     data("airway", package = "airway")
#'     p <- sample_pca(airway, transform = "log2cpm", ntop = 500, feature.labels = "symbol")
#'     round(p$variance, 1)
#'     pcaScreePlot(p)
#' }
sample_pca <- function(object, assay = NULL, transform = .se_default_transform(), ntop = 500,
                       center = TRUE, scale = FALSE, feature.labels = NULL, metadata = NULL) {
    if (is.matrix(object) || is.data.frame(object)) {
        mat <- as.matrix(object)
        if (!is.numeric(mat)) stop("'object' must be a numeric matrix or a SummarizedExperiment.", call. = FALSE)
        se <- SummarizedExperiment::SummarizedExperiment(assays = list(values = mat))
        if (!is.null(metadata)) {
            metadata <- as.data.frame(metadata)
            if (nrow(metadata) != ncol(mat)) stop("'metadata' needs one row per column of 'object'.", call. = FALSE)
            SummarizedExperiment::colData(se) <- S4Vectors::DataFrame(metadata, check.names = FALSE)
        }
        assay <- "values"
    } else {
        se <- .assert_se(object, "object")
    }

    mat <- .se_transform(se, assay, transform)
    labels <- stats::setNames(.se_feature_labels(se, rownames(mat), feature.labels), rownames(mat))
    .pca_from_matrix(mat, .se_coldata(se), ntop, center, scale, labels)
}


#' PCA of a transformed matrix, in PCAtools' shape
#'
#' @param mat A transformed numeric matrix, features by samples.
#' @param meta Sample metadata, one row per column of `mat`, or `NULL`.
#' @param ntop,center,scale As for [sample_pca()].
#' @param labels A character vector of feature labels named by row name, or
#'   `NULL` for the row names.
#' @return A list of class `"pca"`; see [sample_pca()].
#'
#' @importFrom stats prcomp
#' @author Jared Andrews
#' @rdname INTERNAL_pca_from_matrix
#' @keywords internal
.pca_from_matrix <- function(mat, meta = NULL, ntop = 500, center = TRUE, scale = FALSE, labels = NULL) {
    mat <- .se_top_variable(mat, ntop)
    if (nrow(mat) < 2) stop("Fewer than two features vary across the samples.", call. = FALSE)
    if (ncol(mat) < 2) stop("At least two samples are needed for a PCA.", call. = FALSE)

    pc <- prcomp(t(mat), center = isTRUE(center), scale. = isTRUE(scale))
    comps <- paste0("PC", seq_along(pc$sdev))
    total <- if (isTRUE(scale)) nrow(mat) else sum(.row_vars(mat))

    scores <- as.data.frame(pc$x)
    names(scores) <- comps
    loadings <- as.data.frame(pc$rotation)
    names(loadings) <- comps
    if (!is.null(labels)) rownames(loadings) <- unname(labels[rownames(mat)])

    meta <- meta %||% data.frame(row.names = colnames(mat))
    out <- list(
        rotated = scores,
        loadings = loadings,
        variance = stats::setNames(pc$sdev^2 / total * 100, comps),
        sdev = pc$sdev,
        metadata = if (ncol(meta)) meta else NULL,
        xvars = rownames(loadings),
        yvars = colnames(mat),
        components = comps
    )
    class(out) <- "pca"
    out
}


#' Build a standalone Shiny app for a module that takes a SummarizedExperiment
#'
#' [.sci_object_app()] over a named list of experiments, previewing each one's
#' sample metadata.
#'
#' @param inputs_ui_fn,output_ui_fn,server_fn The module's functions.
#' @param object_list A named list of `SummarizedExperiment` objects.
#' @param title Page title.
#' @return A [shiny::shinyApp()] object.
#'
#' @author Jared Andrews
#' @rdname INTERNAL_se_module_app
#' @keywords internal
.se_module_app <- function(inputs_ui_fn, output_ui_fn, server_fn, object_list, title) {
    .sci_object_app(
        inputs_ui_fn, output_ui_fn, server_fn, object_list, title,
        validate = function(x) .assert_se(x, "object_list element"),
        preview = function(x) .se_coldata(x),
        select_label = "Select Experiment:",
        preview_title = "Sample Metadata",
        preview_note = "Read-only preview of the experiment's colData."
    )
}


#' The example bulk experiment: airway, as the airway package ships it
#'
#' The airway RNA-seq counts (Himes et al. 2014; four airway smooth muscle cell
#' lines, each untreated or treated with dexamethasone) from the airway data
#' package, with `dex` relevelled so the untreated samples come first.
#'
#' @return A `RangedSummarizedExperiment`.
#'
#' @author Jared Andrews
#' @rdname INTERNAL_se_example
#' @keywords internal
.se_example <- function() {
    if (!requireNamespace("airway", quietly = TRUE)) {
        stop("The example experiment ships with the airway package: BiocManager::install('airway').",
            call. = FALSE)
    }
    env <- new.env(parent = emptyenv())
    utils::data("airway", package = "airway", envir = env)
    se <- env$airway
    se$dex <- stats::relevel(se$dex, ref = "untrt")
    se
}


#' Sample-metadata columns that group samples
#'
#' The discrete columns ([.sci_discrete_cols()]) with at least two values and
#' fewer values than samples, so sample IDs (one value per sample) and
#' constants are left out of default annotations and colours.
#'
#' @param meta A sample metadata data frame.
#' @return Column names.
#'
#' @author Jared Andrews
#' @rdname INTERNAL_se_group_cols
#' @keywords internal
.se_group_cols <- function(meta) {
    cols <- .sci_discrete_cols(meta)
    n <- vapply(cols, function(cl) length(unique(meta[[cl]][!is.na(meta[[cl]])])), numeric(1))
    cols[n >= 2 & n < nrow(meta)]
}
