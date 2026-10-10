# Tests for the bulk expression helpers (transforms, sample_pca()) and the
# samplePCA module, which feeds them to the PCA biplot.

test_that("log2 CPM matches edgeR", {
    skip_if_not_installed("edgeR")
    airway <- airway_se()
    counts <- SummarizedExperiment::assay(airway, "counts")
    expect_equal(.log2_cpm(counts), edgeR::cpm(counts, log = TRUE), ignore_attr = TRUE)
    expect_equal(.log2_cpm(counts, prior.count = 0.5), edgeR::cpm(counts, log = TRUE, prior.count = 0.5),
        ignore_attr = TRUE)
})

test_that("sample_pca() matches PCAtools::pca() on the same matrix", {
    skip_if_not_installed("PCAtools")
    airway <- airway_se()
    p <- sample_pca(airway, transform = "log2cpm", ntop = 300)
    mat <- .se_top_variable(.se_transform(airway, "counts", "log2cpm"), 300)
    ref <- PCAtools::pca(mat, metadata = .se_coldata(airway))

    k <- seq_len(ncol(mat) - 1)
    expect_equal(unname(p$variance[k]), unname(ref$variance[k]))
    # Components are defined up to sign.
    expect_equal(abs(as.matrix(p$rotated[, k])), abs(as.matrix(ref$rotated[, k])), ignore_attr = TRUE)
    expect_identical(p$yvars, colnames(mat))
    expect_s3_class(p, "pca")
})

test_that("sample_pca() takes a matrix, labels features and keeps the metadata", {
    airway <- airway_se()
    p <- sample_pca(airway, transform = "log2", ntop = 100, feature.labels = "symbol")
    expect_identical(nrow(p$loadings), 100L)
    symbols <- SummarizedExperiment::rowData(airway)$symbol
    expect_true(all(rownames(p$loadings) %in% c(symbols, rownames(airway))))
    expect_true("XIST" %in% rownames(p$loadings))
    expect_true(all(c("dex", "cell", "SampleName", "avgLength") %in% names(p$metadata)))
    expect_equal(sum(p$variance), 100)
    .assert_pca(p)

    m <- matrix(stats::rnorm(200), 20, dimnames = list(paste0("g", 1:20), paste0("s", 1:10)))
    meta <- data.frame(grp = rep(c("a", "b"), 5))
    pm <- sample_pca(m, transform = "none", ntop = NA, metadata = meta)
    expect_identical(nrow(pm$loadings), 20L)
    expect_identical(pm$metadata$grp, meta$grp)
    expect_error(sample_pca(m, transform = "none", metadata = meta[1:3, , drop = FALSE]), "one row per column")
})

test_that("the transforms behave, and VST needs counts", {
    airway <- airway_se()
    expect_true("log2cpm" %in% .se_transform_choices())
    m <- .se_transform(airway, "counts", "log2")
    expect_equal(m, log2(SummarizedExperiment::assay(airway, "counts") + 1), ignore_attr = TRUE)
    expect_identical(.se_transform(airway, "counts", "none")[1, 1],
        as.numeric(SummarizedExperiment::assay(airway, "counts")[1, 1]))

    skip_if_not_installed("DESeq2")
    v <- .se_transform(airway, "counts", "vst")
    expect_identical(dim(v), dim(airway))
    expect_error(.vst_counts(m), "raw")
    # Too few genes for vst()'s subsample falls back to the full transformation.
    counts <- SummarizedExperiment::assay(airway, "counts")
    small <- counts[rowSums(counts) >= 100, ][1:200, ]
    expect_identical(dim(.vst_counts(small)), dim(small))
})

test_that("default annotations and colours skip sample IDs and constants", {
    meta <- data.frame(id = paste0("s", 1:6), cell = rep(c("a", "b", "c"), 2), dex = rep(c("u", "t"), each = 3),
        batch = "one")
    expect_identical(.se_group_cols(meta), c("cell", "dex"))
    expect_identical(.se_annotation_default(meta, 1), "cell")
})

test_that(".se_top_variable() drops constant rows and keeps the most variable", {
    m <- rbind(a = c(1, 1, 1), b = c(1, 2, 3), c = c(0, 10, 20), d = c(NA, 1, 2))
    expect_identical(rownames(.se_top_variable(m, 1)), c("c", "b"))  # never fewer than two
    expect_identical(rownames(.se_top_variable(m, NA)), c("c", "b"))
})

test_that("samplePCAServer hands the biplot a PCA that follows its inputs", {
    airway <- airway_se()
    captured <- NULL
    local_mocked_bindings(
        pcaBiplotServer = function(id, data, hide.inputs, hide.tabs, defaults) {
            captured <<- list(data = data, defaults = defaults, hide.tabs = hide.tabs)
            shiny::reactive(NULL)
        }
    )
    shiny::testServer(samplePCAServer, args = list(data = shiny::reactive(airway)), expr = {
        session$setInputs(auto.update = TRUE, pca.assay = "counts", pca.transform = "log2cpm", pca.ntop = 300,
            pca.center = TRUE, pca.scale = FALSE, pca.labels = "symbol")
        expect_identical(nrow(captured$data()$loadings), 300L)
        session$setInputs(pca.ntop = 50)
        expect_identical(nrow(captured$data()$loadings), 50L)
    })
    # The biplot cannot read the PCA when it is built, so its axes and colour are
    # given explicitly; the wrapper's own keys stay out.
    expect_identical(captured$defaults$x.by, "PC1")
    expect_identical(captured$defaults$y.by, "PC2")
    # The first colData column that groups samples, skipping airway's sample IDs.
    expect_identical(captured$defaults$color.by, "cell")
    expect_false(any(.spca_keys %in% names(captured$defaults)))
    expect_identical(captured$hide.tabs, "Trajectory")
})

test_that("samplePCAInputsUI builds the wrapper and biplot controls", {
    airway <- airway_se()
    html <- as.character(samplePCAInputsUI("p", airway, defaults = list(pca.transform = "log2cpm")))
    for (id in c("p-pca.assay", "p-pca.transform", "p-pca.ntop", "p-pca.labels", "p-x.by", "p-show.loadings")) {
        expect_true(grepl(id, html, fixed = TRUE), info = id)
    }
    expect_error(samplePCAInputsUI("p", data.frame(a = 1)), "SummarizedExperiment")
})
