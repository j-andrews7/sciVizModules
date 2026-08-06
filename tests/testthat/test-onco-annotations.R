# Unit tests for the oncoPlot annotation helpers (oncoPlot_helpers.R) and the
# oncoPlot() annotation plumbing (oncoPlot.R).

make_tidy <- function() {
    data.frame(
        sample = c("S1", "S1", "S2", "S3", "S1", "S2"),
        gene = c("TP53", "TP53", "TP53", "TP53", "KRAS", "KRAS"),
        alteration = c("MUT", "AMP", "MUT", "HOMDEL", "AMP", "MUT"),
        stage = c("I", "I", "II", "III", "I", "II"),
        score = c(1, 1, 2, 3, 1, 2),
        stringsAsFactors = FALSE
    )
}

test_that(".onco_annotation_sources offers each extra column in both spaces", {
    df <- make_tidy()
    src <- .onco_annotation_sources(df, "sample", "gene", "alteration")

    expect_named(src, c("sample", "gene"))
    # Extra columns (stage, score) appear in both spaces; nothing else does.
    expect_setequal(unname(src$sample), c("sample:stage", "sample:score"))
    expect_setequal(unname(src$gene), c("gene:stage", "gene:score"))
})

test_that(".onco_annotation_sources is empty when there are no extra columns", {
    df <- make_tidy()[, c("sample", "gene", "alteration")]
    src <- .onco_annotation_sources(df, "sample", "gene", "alteration")
    expect_length(src$sample, 0)
    expect_length(src$gene, 0)
})

test_that(".onco_summarise_source aligns to the matrix axis", {
    df <- make_tidy()
    mat <- .onco_to_matrix(df, "sample", "gene", "alteration")

    v_s <- .onco_summarise_source("sample:score", df, mat, "sample", "gene", "alteration")
    expect_length(v_s, ncol(mat))
    expect_identical(names(v_s), colnames(mat))

    v_g <- .onco_summarise_source("gene:score", df, mat, "sample", "gene", "alteration")
    expect_length(v_g, nrow(mat))
    expect_identical(names(v_g), rownames(mat))
})

test_that(".onco_summarise_source aggregates extra columns and returns NULL on bad keys", {
    df <- make_tidy()
    mat <- .onco_to_matrix(df, "sample", "gene", "alteration")

    v_num <- .onco_summarise_source("sample:score", df, mat, "sample", "gene", "alteration")
    expect_length(v_num, ncol(mat))
    expect_true(is.numeric(v_num))

    v_cat <- .onco_summarise_source("gene:stage", df, mat, "sample", "gene", "alteration")
    expect_length(v_cat, nrow(mat))
    expect_true(is.character(v_cat))

    expect_null(.onco_summarise_source("sample:not_a_col", df, mat, "sample", "gene", "alteration"))
    expect_null(.onco_summarise_source("garbage", df, mat, "sample", "gene", "alteration"))
})

test_that(".onco_build_annotation builds a HeatmapAnnotation for each numeric type", {
    skip_if_not_installed("ComplexHeatmap")
    vec <- stats::setNames(c(1, 2, 3), c("S1", "S2", "S3"))
    for (type in c("Bar", "Points", "Lines", "Simple")) {
        ann <- .onco_build_annotation(vec, "foo", type, "#4C78A8", which = "column")
        expect_s4_class(ann, "HeatmapAnnotation")
    }
})

test_that(".onco_collect_annotations skips space-mismatched rows", {
    skip_if_not_installed("ComplexHeatmap")
    df <- make_tidy()
    mat <- .onco_to_matrix(df, "sample", "gene", "alteration")

    rows <- list(
        # top with a sample source -> kept
        a = list(side = "top", source = "sample:score", type = "Bar", colour = "#000000"),
        # top with a GENE source -> skipped (space mismatch)
        b = list(side = "top", source = "gene:score", type = "Bar", colour = "#000000"),
        # left with a gene source -> kept
        c = list(side = "left", source = "gene:score", type = "Points", colour = "#000000")
    )
    anns <- .onco_collect_annotations(rows, df, mat, "sample", "gene", "alteration")

    expect_s4_class(anns$top, "HeatmapAnnotation")
    expect_s4_class(anns$left, "HeatmapAnnotation")
    expect_null(anns$bottom)
    expect_null(anns$right)
})

test_that("oncoPlot accepts side annotations and returns a heatmap", {
    skip_if_not_installed("ComplexHeatmap")
    df <- make_tidy()
    mat <- .onco_to_matrix(df, "sample", "gene", "alteration")
    anns <- .onco_collect_annotations(
        list(a = list(side = "top", source = "sample:score", type = "Bar", colour = "#4C78A8")),
        df, mat, "sample", "gene", "alteration"
    )
    ht <- oncoPlot(df, top.annotation = anns$top)
    expect_s4_class(ht, "Heatmap")
})

test_that("oncoPlot drops annotations that do not match the filtered matrix", {
    skip_if_not_installed("ComplexHeatmap")
    df <- make_tidy()
    mat <- .onco_to_matrix(df, "sample", "gene", "alteration")
    # Gene-space annotation built on the full matrix (2 genes).
    anns <- .onco_collect_annotations(
        list(a = list(side = "left", source = "gene:score", type = "Bar", colour = "#000000")),
        df, mat, "sample", "gene", "alteration"
    )
    # Force a mismatch by keeping only 1 gene via top.n.
    expect_warning(
        oncoPlot(df, top.n = 1, left.annotation = anns$left),
        "does not match the number of genes"
    )
})
