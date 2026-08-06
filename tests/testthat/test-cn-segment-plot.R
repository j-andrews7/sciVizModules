# Smoke and regression tests for the cnSegmentPlot module.

test_that("all cnSegmentPlot functions are exported", {
    for (name in c(
        "cnSegmentPlot", "cnSegmentPlotInputsUI", "cnSegmentPlotOutputUI",
        "cnSegmentPlotServer", "cnSegmentPlotApp"
    )) {
        expect_true(is.function(get0(name, envir = asNamespace("sciVizModules"))), info = name)
    }
})

test_that("bundled example is a self-contained CNSegment object", {
    data(example_cn_segment, package = "sciVizModules")

    expect_s3_class(example_cn_segment, "CNSegment")
    expect_gt(length(example_cn_segment$bin.coords), 20000)

    # cytoBand drives centromere placement.
    cyto <- example_cn_segment$genomeInfo$cytoBand
    expect_true(is.data.frame(cyto))
    expect_true(all(c("chrom", "chromStart", "chromEnd", "name", "gieStain") %in% names(cyto)))
    expect_true(any(cyto$gieStain == "acen"))

    # Per-bin gene overlaps for hover, plus a gene annotation for labels.
    expect_true("genes" %in% names(GenomicRanges::mcols(example_cn_segment$bin.coords)))
    genes <- example_cn_segment$genomeInfo$genes
    expect_s4_class(genes, "GRanges")
    expect_true(all(c("TP53", "EGFR", "MYC") %in% GenomicRanges::mcols(genes)$gene_name))
})

test_that("gene text selection accepts commas and whitespace", {
    data(example_cn_segment, package = "sciVizModules")
    genes <- example_cn_segment$genomeInfo$genes

    selected <- .cn_seg_select_genes(
        genes,
        id.col = "gene_name",
        label.genes = "TP53, EGFR\nMYC"
    )

    expect_setequal(GenomicRanges::mcols(selected)$gene_name, c("TP53", "EGFR", "MYC"))
    expect_null(.cn_seg_select_genes(
        genes, id.col = "gene_name", label.genes = ""
    ))
})

test_that("cnSegmentPlot uses Plotly annotations and a zero-centered colorbar", {
    data(example_cn_segment, package = "sciVizModules")
    genes <- example_cn_segment$genomeInfo$genes
    selected <- genes[GenomicRanges::mcols(genes)$gene_name %in% c("TP53", "EGFR")]

    fig <- cnSegmentPlot(example_cn_segment, genes = selected, id.col = "gene_name")
    built <- plotly::plotly_build(fig)
    annotations <- built$x$layout$annotations
    color_traces <- Filter(function(trace) !is.null(trace$marker$colorscale), built$x$data)

    expect_s3_class(fig, "plotly")
    expect_setequal(vapply(annotations, `[[`, character(1), "text"), c("TP53", "EGFR"))
    expect_true(all(vapply(annotations, function(annotation) isTRUE(annotation$showarrow), logical(1))))
    expect_true(all(vapply(annotations, function(annotation) annotation$arrowhead == 4, logical(1))))
    expect_true(length(color_traces) > 0)
    expect_true(all(vapply(color_traces, function(trace) identical(trace$marker$cmid, 0), logical(1))))
    expect_true(all(vapply(color_traces, function(trace) identical(trace$marker$cmin, -0.4), logical(1))))
    expect_true(all(vapply(color_traces, function(trace) identical(trace$marker$cmax, 0.4), logical(1))))
    expect_true(any(vapply(color_traces, function(trace) isTRUE(trace$marker$showscale), logical(1))))
    expect_true(all(vapply(color_traces, function(trace) length(trace$marker$color) > 1, logical(1))))
    expect_equal(as.numeric(color_traces[[1]]$marker$colorbar$tickvals), seq(-0.4, 0.4, by = 0.2))

    point_text <- unlist(lapply(built$x$data, `[[`, "text"), use.names = FALSE)
    expect_true(any(grepl("gene_name:</b> TP53", point_text, fixed = TRUE)))
    expect_true(any(grepl("gene_name:</b> EGFR", point_text, fixed = TRUE)))
})

test_that("cnSegmentPlot places the mid color at zero with asymmetric limits", {
    data(example_cn_segment, package = "sciVizModules")

    fig <- plotly::plotly_build(cnSegmentPlot(
        example_cn_segment,
        color.limits = c(-0.2, 0.8),
        color.zero = "#123456"
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

    expect_true(any(grepl("gene_symbol:</b> TP53", point_text, fixed = TRUE)))
})

test_that("cnSegmentPlot surfaces per-bin genes in hover text", {
    data(example_cn_segment, package = "sciVizModules")

    built <- plotly::plotly_build(cnSegmentPlot(example_cn_segment, to.plot = "chr1"))
    point_text <- unlist(lapply(built$x$data, `[[`, "text"), use.names = FALSE)

    expect_true(any(grepl("genes:</b>", point_text, fixed = TRUE)))
})

test_that("cnSegmentPlot uses centromeres for dashed guides", {
    data(example_cn_segment, package = "sciVizModules")
    centromere <- GenomicRanges::GRanges(
        seqnames = c("chr1", "chr2", "chr3"),
        ranges = IRanges::IRanges(start = c(100e6, 110e6, 90e6), width = 1)
    )

    built <- plotly::plotly_build(cnSegmentPlot(
        example_cn_segment,
        centromere = centromere,
        to.plot = c("chr1", "chr2", "chr3")
    ))
    dashed <- Filter(function(trace) identical(trace$line$dash, "dash"), built$x$data)

    expect_length(dashed, 1)
    expect_equal(length(unique(stats::na.omit(dashed[[1]]$x))), 3)
})

test_that(".cn_seg_centromeres extracts p-arm acen ends and drives dashed guides", {
    data(example_cn_segment, package = "sciVizModules")

    cent <- .cn_seg_centromeres(example_cn_segment)
    expect_s4_class(cent, "GRanges")
    expect_gt(length(cent), 0)

    # Positions match the end of each chromosome's p-arm acen band.
    cyto <- example_cn_segment$genomeInfo$cytoBand
    acen <- cyto[cyto$gieStain == "acen", ]
    p.arm <- acen[startsWith(as.character(acen$name), "p"), ]
    chr1.end <- max(p.arm$chromEnd[p.arm$chrom == "chr1"])
    chr1.cent <- cent[as.character(GenomicRanges::seqnames(cent)) == "chr1"]
    expect_equal(GenomicRanges::start(chr1.cent), as.integer(chr1.end))

    # Dashed guides are drawn without passing centromeres explicitly.
    built <- plotly::plotly_build(cnSegmentPlot(example_cn_segment, to.plot = c("chr1", "chr2")))
    dashed <- Filter(function(trace) identical(trace$line$dash, "dash"), built$x$data)
    expect_length(dashed, 1)
    expect_equal(length(unique(stats::na.omit(dashed[[1]]$x))), 2)
})

test_that("cnSegmentPlot exposes centromere and chromosome-border line styling", {
    data(example_cn_segment, package = "sciVizModules")

    built <- plotly::plotly_build(cnSegmentPlot(
        example_cn_segment,
        to.plot = c("chr1", "chr2", "chr3"),
        centromere.color = "#FF0000", centromere.width = 2, centromere.linetype = "dotted",
        border.color = "#00FF00", border.width = 1.5, border.linetype = "longdash"
    ))

    cent <- Filter(function(trace) identical(trace$line$dash, "dot"), built$x$data)
    border <- Filter(function(trace) identical(trace$line$dash, "longdash"), built$x$data)

    expect_length(cent, 1)
    expect_length(border, 1)
    expect_match(cent[[1]]$line$color, "255,0,0", fixed = TRUE)
    expect_match(border[[1]]$line$color, "0,255,0", fixed = TRUE)
    expect_true(cent[[1]]$line$width > border[[1]]$line$width)
})

test_that("cnSegmentPlotInputsUI includes free-text gene selection", {
    data(example_cn_segment, package = "sciVizModules")

    ui <- cnSegmentPlotInputsUI("test", example_cn_segment)
    html <- htmltools::renderTags(ui)$html

    expect_match(html, "test-label.genes", fixed = TRUE)
    expect_match(html, "Genes to Label", fixed = TRUE)
})

test_that("cnSegmentPlotInputsUI exposes centromere and border line controls", {
    data(example_cn_segment, package = "sciVizModules")

    ui <- cnSegmentPlotInputsUI("test", example_cn_segment)
    html <- htmltools::renderTags(ui)$html

    for (input.id in c(
        "test-centromere.color", "test-centromere.width", "test-centromere.linetype",
        "test-border.color", "test-border.width", "test-border.linetype"
    )) {
        expect_match(html, input.id, fixed = TRUE)
    }
})
