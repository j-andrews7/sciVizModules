# Smoke and regression tests for the cnSegmentPlot module.

test_that("all cnSegmentPlot functions are exported", {
    for (name in c(
        "cnSegmentPlot", "cnSegmentPlotInputsUI", "cnSegmentPlotOutputUI",
        "cnSegmentPlotServer", "cnSegmentPlotApp"
    )) {
        expect_true(is.function(get0(name, envir = asNamespace("sciVizModules"))), info = name)
    }
})

test_that("gene text selection accepts commas and whitespace", {
    data(example_cn_genes, package = "sciVizModules")

    selected <- sciVizModules:::.cn_seg_select_genes(
        example_cn_genes,
        id.col = "gene_name",
        label.genes = "GENEA, GENEC\nGENEF"
    )

    expect_setequal(GenomicRanges::mcols(selected)$gene_name, c("GENEA", "GENEC", "GENEF"))
    expect_null(sciVizModules:::.cn_seg_select_genes(
        example_cn_genes, id.col = "gene_name", label.genes = ""
    ))
})

test_that("cnSegmentPlot uses Plotly annotations and a zero-centered colorbar", {
    data(example_cn_segment, package = "sciVizModules")
    data(example_cn_genes, package = "sciVizModules")
    selected <- example_cn_genes[GenomicRanges::mcols(example_cn_genes)$gene_name %in% c("GENEA", "GENEC")]

    fig <- cnSegmentPlot(example_cn_segment, genes = selected, id.col = "gene_name")
    built <- plotly::plotly_build(fig)
    annotations <- built$x$layout$annotations
    color_traces <- Filter(function(trace) !is.null(trace$marker$colorscale), built$x$data)

    expect_s3_class(fig, "plotly")
    expect_setequal(vapply(annotations, `[[`, character(1), "text"), c("GENEA", "GENEC"))
    expect_true(length(color_traces) > 0)
    expect_true(all(vapply(color_traces, function(trace) identical(trace$marker$cmid, 0), logical(1))))
    expect_true(all(vapply(color_traces, function(trace) identical(trace$marker$cmin, -0.4), logical(1))))
    expect_true(all(vapply(color_traces, function(trace) identical(trace$marker$cmax, 0.4), logical(1))))
    expect_true(any(vapply(color_traces, function(trace) isTRUE(trace$marker$showscale), logical(1))))
})

test_that("cnSegmentPlot places the mid color at zero with asymmetric limits", {
    data(example_cn_segment, package = "sciVizModules")

    fig <- plotly::plotly_build(cnSegmentPlot(
        example_cn_segment,
        color.limits = c(-0.2, 0.8),
        color.mid = "#123456"
    ))
    color_trace <- Filter(function(trace) !is.null(trace$marker$colorscale), fig$x$data)[[1]]

    expect_identical(color_trace$marker$cmin, -0.2)
    expect_identical(color_trace$marker$cmax, 0.8)
    expect_equal(as.numeric(color_trace$marker$colorscale[2, 1]), 0.2)
    expect_identical(color_trace$marker$colorscale[2, 2], "#123456")
})

test_that("cnSegmentPlot color limits must include zero", {
    data(example_cn_segment, package = "sciVizModules")

    expect_error(cnSegmentPlot(example_cn_segment, color.limits = c(0.1, 1)), "must include")
    expect_error(cnSegmentPlot(example_cn_segment, color.limits = c(-1, -0.1)), "must include")
})

test_that("cnSegmentPlot hover text supports character metadata", {
    data(example_cn_segment, package = "sciVizModules")
    seg <- example_cn_segment
    GenomicRanges::mcols(seg$bin.coords)$gene_symbol <- rep(c("TP53", "EGFR"), length.out = length(seg$bin.coords))

    fig <- cnSegmentPlot(seg, hover.text.cols = c("signal", "gene_symbol"))
    built <- plotly::plotly_build(fig)
    point_text <- unlist(lapply(built$x$data, `[[`, "text"), use.names = FALSE)

    expect_true(any(grepl("gene_symbol: TP53", point_text, fixed = TRUE)))
})

test_that("cnSegmentPlotInputsUI includes free-text gene selection", {
    data(example_cn_segment, package = "sciVizModules")
    data(example_cn_genes, package = "sciVizModules")

    ui <- cnSegmentPlotInputsUI("test", example_cn_segment, example_cn_genes)
    html <- htmltools::renderTags(ui)$html

    expect_match(html, "test-label.genes", fixed = TRUE)
    expect_match(html, "Genes to Label", fixed = TRUE)
})
