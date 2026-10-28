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

test_that(".cn_seg_as_list normalizes and names samples", {
    data(example_cn_segment, package = "sciVizModules")

    # A bare CNSegment becomes a stack of one.
    single <- .cn_seg_as_list(example_cn_segment)
    expect_length(single, 1)
    expect_s3_class(single[[1]], "CNSegment")

    # Supplied names win; the `seg.signals$ID` column is the fallback.
    named <- .cn_seg_as_list(list(Tumor = example_cn_segment, Normal = example_cn_segment))
    expect_identical(names(named), c("Tumor", "Normal"))
    expect_identical(
        names(.cn_seg_as_list(list(example_cn_segment))),
        unique(as.character(example_cn_segment$seg.signals$ID))
    )

    # Positional fallback when no ID is available, and names are made unique.
    no.id <- example_cn_segment
    no.id$seg.signals$ID <- NA_character_
    expect_identical(names(.cn_seg_as_list(list(no.id, no.id))), c("Sample 1", "Sample 2"))
    expect_identical(names(.cn_seg_as_list(list(A = no.id, A = no.id))), c("A", "A.1"))

    expect_error(.cn_seg_as_list(list(example_cn_segment, 1)), "element\\(s\\) 2 are not")
    expect_error(.cn_seg_as_list(list()), "non-empty list")
})

test_that(".cn_seg_shared_seqlengths rejects mismatched genome builds", {
    data(example_cn_segment, package = "sciVizModules")

    seg.list <- .cn_seg_as_list(list(A = example_cn_segment, B = example_cn_segment))
    expect_identical(
        .cn_seg_shared_seqlengths(seg.list),
        Seqinfo::seqlengths(Seqinfo::seqinfo(example_cn_segment$bin.coords))
    )

    other <- example_cn_segment
    lens <- Seqinfo::seqlengths(other$bin.coords)
    lens["chr1"] <- lens[["chr1"]] + 1000L
    Seqinfo::seqlengths(other$bin.coords) <- lens

    expect_error(
        .cn_seg_shared_seqlengths(.cn_seg_as_list(list(A = example_cn_segment, B = other))),
        "share a genome build"
    )
})

test_that("cnSegmentPlot stacks samples over a single shared x-axis", {
    data(example_cn_segment, package = "sciVizModules")
    shifted <- example_cn_segment
    shifted$bin.signals <- shifted$bin.signals + 0.25

    built <- plotly::plotly_build(cnSegmentPlot(
        list(Tumor = example_cn_segment, Normal = shifted),
        to.plot = c("chr1", "chr2")
    ))
    layout.names <- names(built$x$layout)

    # One panel per sample, but a single x-axis shared by the whole stack, so
    # chromosome labels are drawn once and loci line up vertically.
    expect_setequal(grep("^yaxis", layout.names, value = TRUE), c("yaxis", "yaxis2"))
    expect_identical(grep("^xaxis", layout.names, value = TRUE), "xaxis")
    expect_equal(built$x$layout$xaxis$domain, c(0, 1))

    # The first sample is on top.
    expect_gt(built$x$layout$yaxis$domain[1], built$x$layout$yaxis2$domain[1])

    # Sample names label the panels.
    strips <- vapply(built$x$layout$annotations, `[[`, character(1), "text")
    expect_true(all(c("Tumor", "Normal") %in% strips))

    # Every panel gets the colorscale, but the colorbar is drawn once.
    color_traces <- Filter(function(trace) !is.null(trace$marker$colorscale), built$x$data)
    expect_length(color_traces, 2)
    expect_equal(sum(vapply(color_traces, function(trace) isTRUE(trace$marker$showscale), logical(1))), 1)
    expect_true(all(vapply(color_traces, function(trace) identical(trace$marker$cmid, 0), logical(1))))
})

test_that("cnSegmentPlot shares gene labels across a stack", {
    data(example_cn_segment, package = "sciVizModules")
    genes <- example_cn_segment$genomeInfo$genes
    selected <- genes[GenomicRanges::mcols(genes)$gene_name %in% c("TP53", "EGFR")]
    shifted <- example_cn_segment
    shifted$bin.signals <- shifted$bin.signals + 0.25

    built <- plotly::plotly_build(cnSegmentPlot(
        list(Tumor = example_cn_segment, Normal = shifted),
        genes = selected, id.col = "gene_name",
        gene.line.linetype = "dotted"
    ))

    # Each gene is labeled once for the whole stack, above the top panel:
    # anchored to the shared data x-axis but to the paper in y.
    gene.labels <- Filter(
        function(ann) identical(ann$xref, "x") && identical(ann$yref, "paper"),
        built$x$layout$annotations
    )
    expect_setequal(vapply(gene.labels, `[[`, character(1), "text"), c("TP53", "EGFR"))
    expect_true(all(vapply(gene.labels, function(ann) identical(ann$y, 1), logical(1))))
    expect_true(all(vapply(gene.labels, function(ann) ann$textangle == -90, logical(1))))

    # A guide line per gene runs through every panel, so one trace per panel
    # carrying both x positions.
    guides <- Filter(function(trace) identical(trace$line$dash, "dot"), built$x$data)
    expect_length(guides, 2)
    expect_equal(length(unique(stats::na.omit(guides[[1]]$x))), 2)

    # Suppressing the guide lines leaves the labels in place.
    no.guides <- plotly::plotly_build(cnSegmentPlot(
        list(Tumor = example_cn_segment, Normal = shifted),
        genes = selected, id.col = "gene_name", gene.line.width = 0
    ))
    expect_length(Filter(function(trace) identical(trace$line$dash, "dot"), no.guides$x$data), 0)
})

test_that("cnSegmentPlot boxes every stacked panel", {
    data(example_cn_segment, package = "sciVizModules")
    shifted <- example_cn_segment
    shifted$bin.signals <- shifted$bin.signals + 0.25
    seg.list <- list(Tumor = example_cn_segment, Normal = shifted, Extra = shifted)

    panel_boxes <- function(fig) {
        shapes <- plotly::plotly_build(fig)$x$layout$shapes
        Filter(
            function(shape) {
                identical(shape$type, "rect") && identical(shape$xref, "paper") &&
                    !is.null(shape$line$color) && !is.na(shape$line$color)
            },
            shapes
        )
    }

    boxes <- panel_boxes(cnSegmentPlot(seg.list, to.plot = "chr1"))

    # One full-width rectangle per panel, so no panel is left open at the top or
    # bottom the way the shared x-axis line alone would leave it.
    expect_length(boxes, 3)
    expect_true(all(vapply(boxes, function(b) b$x0 == 0 && b$x1 == 1, logical(1))))
    expect_true(all(vapply(boxes, function(b) identical(b$line$color, "black"), logical(1))))

    # The boxes tile the panels top to bottom without overlapping.
    tops <- sort(vapply(boxes, function(b) b$y1, numeric(1)), decreasing = TRUE)
    bottoms <- sort(vapply(boxes, function(b) b$y0, numeric(1)), decreasing = TRUE)
    expect_equal(tops[1], 1)
    expect_equal(bottoms[3], 0)
    expect_true(all(tops > bottoms))

    # Styling and suppression.
    styled <- panel_boxes(cnSegmentPlot(
        seg.list, to.plot = "chr1", panel.border.color = "#FF0000", panel.border.width = 2
    ))
    expect_true(all(vapply(styled, function(b) identical(b$line$color, "#FF0000"), logical(1))))
    expect_true(all(vapply(styled, function(b) b$line$width == 2, logical(1))))
    expect_length(panel_boxes(cnSegmentPlot(seg.list, to.plot = "chr1", panel.border.width = 0)), 0)

    # Without mirroring, only the left and bottom edges are drawn.
    unmirrored <- plotly::plotly_build(
        cnSegmentPlot(seg.list, to.plot = "chr1", panel.border.mirror = FALSE)
    )$x$layout$shapes
    expect_length(Filter(function(s) identical(s$type, "line"), unmirrored), 6)

    # A single sample is boxed by its own axis lines, so it gains no shapes.
    expect_length(panel_boxes(cnSegmentPlot(example_cn_segment, to.plot = "chr1")), 0)
})

test_that("cnSegmentPlot free.y scales stacked panels independently", {
    data(example_cn_segment, package = "sciVizModules")
    shifted <- example_cn_segment
    shifted$bin.signals <- shifted$bin.signals + 0.5
    seg.list <- list(Tumor = example_cn_segment, Normal = shifted)

    shared <- plotly::plotly_build(cnSegmentPlot(seg.list, to.plot = "chr1"))
    expect_equal(shared$x$layout$yaxis$range, shared$x$layout$yaxis2$range)

    free <- plotly::plotly_build(cnSegmentPlot(seg.list, to.plot = "chr1", free.y = TRUE))
    expect_false(isTRUE(all.equal(free$x$layout$yaxis$range, free$x$layout$yaxis2$range)))

    # y.min/y.max are ignored when each panel scales itself.
    limited <- plotly::plotly_build(cnSegmentPlot(
        seg.list, to.plot = "chr1", free.y = TRUE, y.min = -0.1, y.max = 0.1
    ))
    expect_gt(diff(limited$x$layout$yaxis$range), 0.2)
})

test_that("cnSegmentPlotOutputUI takes a height for stacked plots", {
    expect_match(htmltools::renderTags(cnSegmentPlotOutputUI("p"))$html, "400px", fixed = TRUE)
    expect_match(
        htmltools::renderTags(cnSegmentPlotOutputUI("p", height = "800px"))$html,
        "800px",
        fixed = TRUE
    )
})

test_that("cnSegmentPlotInputsUI exposes the multi-sample controls", {
    data(example_cn_segment, package = "sciVizModules")

    ui <- cnSegmentPlotInputsUI(
        "test", list(Tumor = example_cn_segment, Normal = example_cn_segment)
    )
    html <- htmltools::renderTags(ui)$html

    for (input.id in c(
        "test-samples", "test-free.y",
        "test-gene.line.color", "test-gene.line.width", "test-gene.line.linetype"
    )) {
        expect_match(html, input.id, fixed = TRUE)
    }
    # Both samples are offered, and selected by default.
    expect_match(html, "Tumor", fixed = TRUE)
    expect_match(html, "Normal", fixed = TRUE)
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
