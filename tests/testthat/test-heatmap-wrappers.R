# Tests for the modules that wrap VizModules' ComplexHeatmap_Heatmap module:
# dittoHeatmap, sampleDistanceHeatmap and deHeatmap. The frames they build are
# plain data, so most of this runs without the heatmap packages; the module
# servers need ComplexHeatmap, InteractiveComplexHeatmap and circlize.

skip_without_heatmaps <- function() {
    for (p in c("ComplexHeatmap", "InteractiveComplexHeatmap", "circlize")) skip_if_not_installed(p)
}

test_that(".heatmap_frame() lays out the matrix, row annotations and a unique key", {
    mat <- matrix(1:6, 2, dimnames = list(c("g1", "g2"), c("s1", "s2", "sample")))
    meta <- data.frame(sample = c("x", "y", "z"), grp = c("a", "b", "a"), row.names = colnames(mat))
    fr <- .heatmap_frame(mat, col.meta = meta, label = "gene", row.annotations = data.frame(s1 = c("u", "d")),
        key = "sample")
    keys <- attr(fr, "keys")
    expect_identical(keys$matrix.cols, c("s1", "s2", "sample"))
    # The key clashes with a metadata column, the row annotation with a sample.
    expect_identical(keys$key, "sample_1")
    expect_identical(names(fr$column_annotations)[1], "sample_1")
    expect_identical(names(fr$matrix)[1:2], c("gene", "s1_1"))
    expect_identical(fr$column_annotations$sample_1, colnames(mat))
})

test_that(".heatmap_clean_rows() drops rows that cannot be clustered or scaled", {
    m <- rbind(a = c(1, 2, 3), flat = c(2, 2, 2), gap = c(NA, 1, 2), b = c(3, 1, 2))
    expect_identical(rownames(.heatmap_clean_rows(m)), c("a", "b"))
    expect_error(.heatmap_clean_rows(m[c("a", "flat"), ]), "Fewer than 2")
})

test_that(".heatmap_defaults() fixes the base's matrix columns and keeps the wrapper keys out", {
    mat <- matrix(1:4, 2, dimnames = list(c("g1", "g2"), c("s1", "s2")))
    fr <- .heatmap_frame(mat, data.frame(grp = c("a", "b"), row.names = c("s1", "s2")), label = "gene")
    d <- .heatmap_defaults(fr, list(scale = "None", matrix.cols = "s1", dh.genes = "x"), list(scale = "Rows"),
        wrapper.keys = "dh.genes")
    expect_identical(d$scale, "None")
    expect_identical(d$matrix.cols, c("s1", "s2"))
    expect_identical(d$rowname.col, "gene")
    expect_identical(d$column_key, "sample")
    expect_null(d$dh.genes)
    expect_identical(names(.heatmap_annotation_colors(list(scale = c(a = "#000000"), grp = c(a = "#FF0000")))),
        "grp")
})

test_that("preparation errors become validation messages, and pauses pass through", {
    v <- tryCatch(.sci_soft_errors(stop("nope")), error = function(e) e)
    expect_s3_class(v, "shiny.silent.error")
    expect_identical(conditionMessage(v), "nope")
    p <- tryCatch(.sci_soft_errors(shiny::req(FALSE)), error = function(e) e)
    expect_s3_class(p, "shiny.silent.error")
    expect_identical(conditionMessage(p), "")
})

test_that("dittoHeatmap pulls the genes, drops flat ones and orders the cells", {
    data(example_sce, package = "sciVizModules")
    genes <- rownames(example_sce)[1:6]
    fr <- .ditto_heatmap_data(example_sce, genes, "logcounts", "celltype")
    expect_identical(fr$matrix$gene, genes)
    expect_identical(attr(fr, "keys")$matrix.cols, .ditto_heatmap_order(example_sce, "celltype"))
    ct <- SummarizedExperiment::colData(example_sce)$celltype
    expect_false(is.unsorted(as.integer(ct[match(attr(fr, "keys")$matrix.cols, colnames(example_sce))])))
    expect_true(all(c("cell", "celltype", "nCount") %in% names(fr$column_annotations)))
    expect_error(.ditto_heatmap_data(example_sce, genes[1]), "at least two genes")

    d <- .dh_defaults(example_sce)
    hd <- .dh_heat_defaults(.ditto_heatmap_data(example_sce, d$dh.genes, d$dh.assay, d$dh.order.by), example_sce, d)
    expect_identical(hd$scale, "Rows")
    expect_false(hd$show_column_names)
    expect_identical(hd$column_annotations$c1$column, d$annot.by)
    expect_identical(hd$column_key, "cell")
})

test_that("sample distances are ordered by clustering and correlations run from 1", {
    airway <- airway_se()
    st <- .se_stage(airway, "counts", "log2cpm")
    fr <- .sample_distance_data(st, 500, "euclidean", "cluster")
    vals <- as.matrix(fr$matrix[attr(fr, "keys")$matrix.cols])
    expect_equal(unname(diag(vals)), rep(0, 8))
    expect_identical(fr$matrix$sample, attr(fr, "keys")$matrix.cols)
    mat <- .se_top_variable(st$mat, 500)
    hc <- stats::hclust(stats::dist(t(mat)), method = "complete")
    expect_identical(attr(fr, "keys")$matrix.cols, colnames(mat)[hc$order])

    fp <- .sample_distance_data(st, 500, "pearson", "data")
    expect_identical(attr(fp, "keys")$matrix.cols, colnames(airway))
    expect_equal(unname(diag(as.matrix(fp$matrix[colnames(airway)]))), rep(1, 8))
    expect_identical(.sd_style("pearson")$high_color, .sd_style("euclidean")$low_color)
})

test_that("the DE heatmap selects, ranks and annotates the top genes", {
    airway <- airway_se()
    data(airway_deseq2, package = "sciVizModules")
    b <- list(object = airway, results = airway_deseq2)
    d <- .de_defaults(b)
    expect_identical(d[c("de.id.col", "de.label.col", "de.padj.col", "de.lfc.col")],
        list(de.id.col = "", de.label.col = "symbol", de.padj.col = "padj", de.lfc.col = "log2FoldChange"))

    sel <- .de_select(airway_deseq2, rownames(airway), "", "padj", "log2FoldChange", 0.05, 1, 20, "padj", "both")
    expect_identical(nrow(sel), 20L)
    expect_false(is.unsorted(sel$.padj))
    expect_true(all(abs(sel$.lfc) >= 1))
    up <- .de_select(airway_deseq2, rownames(airway), "", "padj", "log2FoldChange", 0.05, 1, 20, "lfc", "up")
    expect_true(all(up$.lfc > 0))
    expect_false(is.unsorted(-abs(up$.lfc)))

    fr <- .de_heatmap_data(.se_stage(airway, "counts", "log2cpm"), airway_deseq2, d)
    expect_identical(levels(fr$matrix$direction), c("Up", "Down"))
    expect_true("log2FC" %in% names(fr$matrix))
    expect_identical(attr(fr, "keys")$matrix.cols, colnames(airway))

    # A SummarizedExperiment carrying its results in rowData works too.
    se <- airway
    res <- airway_deseq2[match(rownames(se), airway_deseq2$ensembl), c("log2FoldChange", "padj")]
    SummarizedExperiment::rowData(se) <- cbind(SummarizedExperiment::rowData(se), res)
    expect_identical(.de_defaults(se)$de.padj.col, "padj")
    expect_error(.de_resolve(list(results = airway_deseq2)), "object")
})

test_that("each heatmap wrapper builds its UI on the wrapped module", {
    skip_without_heatmaps()
    data(example_sce, package = "sciVizModules")
    airway <- airway_se()
    data(airway_deseq2, package = "sciVizModules")
    uis <- list(
        dittoHeatmapInputsUI("h", example_sce),
        sampleDistanceHeatmapInputsUI("h", airway, defaults = list(sd.transform = "log2cpm")),
        deHeatmapInputsUI("h", list(object = airway, results = airway_deseq2),
            defaults = list(de.transform = "log2cpm"))
    )
    for (ui in uis) {
        html <- as.character(ui)
        expect_true(grepl("h-matrix.cols", html, fixed = TRUE))
        expect_true(grepl("h-column_annotations", html, fixed = TRUE))
    }
    expect_true(inherits(dittoHeatmapOutputUI("h"), "shiny.tag.list"))
})

test_that("the heatmap wrappers drive the wrapped module's matrix", {
    skip_without_heatmaps()
    data(example_sce, package = "sciVizModules")
    airway <- airway_se()
    data(airway_deseq2, package = "sciVizModules")

    genes <- rownames(example_sce)[1:6]
    shiny::testServer(dittoHeatmapServer, args = list(data = shiny::reactive(example_sce)), expr = {
        session$setInputs(auto.update = TRUE, dh.genes = genes, dh.assay = "logcounts", dh.order.by = "celltype",
            matrix.cols = colnames(example_sce), rowname.col = "gene", column_key = "cell")
        pd <- session$returned()$plot_data
        # The column order reaches the base through the reactive matrix.cols default.
        expect_identical(colnames(pd), .ditto_heatmap_order(example_sce, "celltype"))
        expect_identical(rownames(pd), genes)
        session$setInputs(dh.genes = genes[1:3])
        expect_identical(nrow(session$returned()$plot_data), 3L)
        expect_true(is.function(attr(session$returned, "vector_svg")))
    })

    shiny::testServer(sampleDistanceHeatmapServer, args = list(data = shiny::reactive(airway)), expr = {
        session$setInputs(auto.update = TRUE, sd.assay = "counts", sd.transform = "log2cpm", sd.ntop = 500,
            sd.method = "euclidean", sd.order = "data", rowname.col = "sample")
        pd <- session$returned()$plot_data
        expect_identical(colnames(pd), colnames(airway))
        expect_identical(rownames(pd), colnames(airway))
    })

    b <- list(object = airway, results = airway_deseq2)
    shiny::testServer(deHeatmapServer, args = list(data = shiny::reactive(b)), expr = {
        session$setInputs(auto.update = TRUE, de.id.col = "", de.label.col = "symbol", de.padj.col = "padj",
            de.lfc.col = "log2FoldChange", de.padj.cutoff = 0.05, de.lfc.cutoff = 1, de.top.n = 25,
            de.rank.by = "padj", de.direction = "both", de.assay = "counts", de.transform = "log2cpm",
            rowname.col = "gene")
        expect_identical(nrow(session$returned()$plot_data), 25L)
        session$setInputs(de.direction = "down", de.top.n = 10)
        expect_identical(nrow(session$returned()$plot_data), 10L)
        # Cut-offs nothing passes stop the build with a message, not the session.
        session$setInputs(de.padj.cutoff = 1e-300)
        expect_error(session$returned(), "loosen")
        expect_match(as.character(output$wrapper.status$html), "loosen")
    })
})
