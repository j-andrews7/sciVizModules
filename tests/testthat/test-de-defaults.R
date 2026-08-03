# Unit tests for the volcano and MA plot default helpers
# (volcano_helpers.R and maPlot_helpers.R).
#
# These exercise the pure default-computation and colour helpers that back the
# differential-expression modules, using the bundled airway datasets.

test_that(".volcano_defaults detects DESeq2 effect-size and significance columns", {
    data(airway_deseq2, package = "sciVizModules")
    d <- .volcano_defaults(airway_deseq2)
    expect_identical(d$x.by, "log2FoldChange")
    expect_identical(d$y.by, "padj")
    expect_identical(d$color.by, "group")
    expect_identical(d$y.adj.fxn, "neg_log10")
    expect_equal(d$sig.thresh, 0.05)
    expect_equal(d$fc.thresh, 0)
})

test_that(".volcano_defaults lets user-supplied defaults take precedence", {
    data(airway_deseq2, package = "sciVizModules")
    d <- .volcano_defaults(
        airway_deseq2,
        defaults = list(sig.thresh = 0.01, x.by = "log2FoldChange")
    )
    expect_equal(d$sig.thresh, 0.01)
    expect_identical(d$x.by, "log2FoldChange")
})

test_that(".volcano_defaults errors when no effect-size column is present", {
    df <- data.frame(padj = 0.1, symbol = "A")
    expect_error(.volcano_defaults(df), "effect size")
})

test_that(".volcano_defaults errors when no significance column is present", {
    df <- data.frame(log2FoldChange = 1, symbol = "A")
    expect_error(.volcano_defaults(df), "significance")
})

test_that(".de_group_colors returns a named Up/Down/n.s. colour vector", {
    cols <- .de_group_colors(list())
    expect_named(cols, c("Up", "Down", "n.s."))
    expect_identical(unname(cols), c("red", "blue", "lightgray"))

    custom <- .de_group_colors(
        list(color.up = "darkred", color.down = "navy", color.ns = "grey80")
    )
    expect_identical(unname(custom), c("darkred", "navy", "grey80"))
})

test_that(".ma_defaults detects abundance, effect-size, and significance columns", {
    data(airway_deseq2, package = "sciVizModules")
    d <- .ma_defaults(airway_deseq2)
    expect_identical(d$x.by, "baseMean")
    expect_identical(d$y.by, "log2FoldChange")
    expect_identical(d$sig.by, "padj")
    # DESeq2 baseMean should default to a log10 x-axis.
    expect_identical(d$x.adj.fxn, "log10")
})

test_that(".ma_defaults uses identity x-axis for pre-logged abundance (edgeR)", {
    data(airway_edger, package = "sciVizModules")
    d <- .ma_defaults(airway_edger)
    expect_identical(d$x.by, "logCPM")
    expect_identical(d$x.adj.fxn, "identity")
})

test_that(".ma_defaults errors when a required column is missing", {
    expect_error(
        .ma_defaults(data.frame(logFC = 1, padj = 0.1)),
        "mean abundance"
    )
})
