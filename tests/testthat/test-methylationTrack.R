# ---- Finding a region -------------------------------------------------------

test_that("a region is parsed from what people type", {
    region <- .meth_parse_region("chr19:10,260,000-10,380,000")
    expect_identical(region[c("chr", "start", "end")], list(chr = "chr19", start = 10260000, end = 10380000))
    expect_identical(region$label, "chr19:10,260,000-10,380,000")

    expect_identical(.meth_parse_region("7 100 200")$chr, "chr7")
    expect_identical(.meth_parse_region(" X:1-2 ")$chr, "chrX")
    expect_error(.meth_parse_region("chr19"), "Give a region")
    expect_error(.meth_parse_region("chr1:200-100"), "must come before")
})

test_that("a gene's flanks follow its strand", {
    cohort <- meth_cohort()

    forward <- .meth_gene_region(cohort, "GENEA", upstream = 10, downstream = 1)
    expect_identical(c(forward$start, forward$end), c(110, 321))
    expect_match(forward$label, "^GENEA  chr1")

    reverse <- .meth_gene_region(cohort, "GENEB", upstream = 10, downstream = 1)
    expect_identical(c(reverse$start, reverse$end), c(259, 480))

    expect_error(.meth_gene_region(cohort, "NOPE"), "not among the transcripts")
})

test_that("a gene cannot be found without transcripts", {
    local_mocked_bindings(.meth_genome_info = function(genome) NULL)
    plain <- methylationCohort(meth_betas(), probes = meth_probes())
    expect_error(.meth_gene_region(plain, "GENEA"), "give a region or probes")
})

test_that("probes are found on any array, by ID or prefix", {
    cohort <- meth_cohort()

    region <- .meth_probe_region(cohort, c("cg5", "cg9"), upstream = 10, downstream = 20)
    expect_identical(c(region$chr, region$start, region$end), c("chr1", "290", "520"))
    expect_identical(.meth_parse_probes("cg1, cg2;cg3\ncg4  cg1"), c("cg1", "cg2", "cg3", "cg4"))

    expect_error(.meth_probe_region(cohort, "cg404"), "None of those probes")
    expect_error(.meth_probe_region(cohort, character(0)), "at least one")
})

test_that("probes on two chromosomes are refused", {
    betas <- matrix(0.5, 2, 1, dimnames = list(c("cg1", "cg2"), "S1"))
    ranges <- c(meth_ranges("cg1", 100), meth_ranges("cg2", 100, "chr2"))
    cohort <- methylationCohort(list(EPIC = betas), probes = ranges)
    expect_error(.meth_probe_region(cohort, c("cg1", "cg2")), "on chr1, chr2")
})

test_that("a lookup with nothing to look up prompts for one", {
    cohort <- meth_cohort()
    expect_error(.meth_target(cohort, "gene", gene = ""), "Choose a gene")
    expect_error(.meth_target(cohort, "region", region = ""), "Choose a gene")
    expect_error(.meth_target(cohort, "probes", probes = ""), "Choose a gene")
    expect_error(.meth_target(cohort, "other"), "Unknown lookup")

    # A cleared flank is no flank.
    region <- .meth_target(cohort, "gene", gene = "GENEA", upstream = NA, downstream = NA)
    expect_identical(c(region$start, region$end), c(120, 320))
})


# ---- Choosing samples -------------------------------------------------------

test_that("samples are chosen by level and by condition", {
    samples <- meth_cohort()$samples

    expect_true(all(.meth_select_samples(samples)))
    expect_identical(.meth_select_samples(samples, "tissue", "Blood"), samples$tissue == "Blood")
    expect_identical(
        .meth_select_samples(samples, "tissue", "Blood", "age > 40"),
        samples$tissue == "Blood" & samples$age > 40
    )

    # No levels chosen keeps everything, as does a level left over from another column.
    expect_true(all(.meth_select_samples(samples, "tissue", character(0))))
    expect_true(all(.meth_select_samples(samples, "tissue", "HM450")))
})

test_that("a sample filter that is not a condition says so", {
    samples <- meth_cohort()$samples
    expect_error(.meth_select_samples(samples, expression = "age + 1"), "must be a condition")
    expect_error(.meth_select_samples(samples, expression = "system('whoami')"), "disallowed")
    expect_error(.meth_select_samples(samples, expression = "age >"), "Could not parse")

    # A missing value is not a match.
    samples$age[1] <- NA
    expect_identical(sum(.meth_select_samples(samples, expression = "age > 0")), 5L)
})

test_that("the status line counts samples by platform", {
    samples <- meth_cohort()$samples
    keep <- samples$tissue == "Blood" | samples$sample == "H2"
    expect_identical(.meth_sample_status(samples, keep), "4 of 6 samples: HM450 2, EPIC 1, EPICv2 1")
    expect_identical(.meth_sample_status(samples, rep(FALSE, 6)), "0 of 6 samples")
})


# ---- Ordering samples -------------------------------------------------------

test_that("grouping and clustering work alone and together", {
    q <- .meth_query(meth_cohort(), meth_region())
    samples <- function(...) attr(.meth_figure(q, ...), "table")$samples

    expect_identical(samples()$sample, c("H1", "H2", "E1", "E2", "V1", "V2"))

    grouped <- samples(group.by = "tissue")
    expect_identical(grouped$sample, c("H1", "E1", "V1", "H2", "E2", "V2"))
    expect_identical(grouped$group, rep(c("Blood", "Liver"), each = 3))

    clustered <- .meth_order(q$betas, q$samples, cluster = TRUE)
    expect_setequal(clustered$index, 1:6)
    expect_length(clustered$trees, 1)

    both <- .meth_order(q$betas, q$samples, "platform", cluster = TRUE)
    expect_length(both$trees, 3)
    expect_identical(as.character(both$groups), rep(c("HM450", "EPIC", "EPICv2"), each = 2))
})

test_that("a group's order follows a factor, and missing values form a last group", {
    betas <- matrix(0.5, 2, 3, dimnames = list(NULL, c("a", "b", "c")))
    samples <- data.frame(g = factor(c("low", NA, "high"), levels = c("low", "high")), row.names = colnames(betas))

    ord <- .meth_order(betas, samples, "g")
    expect_identical(colnames(betas)[ord$index], c("a", "c", "b"))
    expect_identical(as.character(ord$groups), c("low", "high", "NA"))
})

test_that("a lone sample in a group is not clustered", {
    q <- .meth_query(meth_cohort(), meth_region())
    q$samples$group <- c("a", "a", "a", "a", "a", "b")
    ord <- .meth_order(q$betas, q$samples, "group", cluster = TRUE)
    expect_length(ord$trees, 1)
    expect_identical(colnames(q$betas)[ord$index[6]], "V2")
})

test_that("clustering uses the CpGs measured in every sample", {
    betas <- rbind(
        c(0, 0, 1, 1), c(0, 0.1, 1, 0.9), c(0.5, 0.5, 0.5, 0.5), c(NA, 1, 0, 1)
    )
    colnames(betas) <- c("a", "b", "c", "d")
    tree <- .meth_cluster(betas)
    reference <- stats::hclust(stats::dist(t(betas[1:3, ])), "ward.D2")

    expect_false(tree$fallback)
    expect_identical(tree$hc$merge, reference$merge)
    expect_equal(tree$hc$height, reference$height)
})

test_that("samples sharing no CpG still cluster, and the figure says so", {
    # H1 and V2 share nothing, so no CpG is complete across the samples.
    betas <- rbind(c(0.1, 0.2, NA), c(NA, 0.3, 0.4), c(NA, NA, 0.5), c(0.9, NA, NA))
    colnames(betas) <- c("H1", "E1", "V2")
    tree <- .meth_cluster(betas)
    expect_true(tree$fallback)
    expect_s3_class(tree$hc, "hclust")

    for (method in c("euclidean", "manhattan", "pearson", "spearman")) {
        expect_s3_class(.meth_cluster(betas, method)$hc, "hclust")
    }

    # With nothing at all to compare, every pair is equally far apart.
    empty <- matrix(NA_real_, 3, 3)
    expect_s3_class(.meth_cluster(empty)$hc, "hclust")

    cohort <- meth_cohort()
    q <- .meth_query(cohort, meth_region(150, 550))
    fig <- .meth_figure(q, cluster.samples = TRUE)
    notes <- vapply(fig$x$layout$annotations, `[[`, "", "text")
    expect_match(notes, "shares", all = FALSE)
})

test_that("group gaps are blank rows", {
    expect_identical(.meth_rows(4), list(y = 1:4, n = 4L))
    gapped <- .meth_rows(4, factor(c("a", "a", "b", "b")), gap = 2)
    expect_equal(gapped$y, c(1, 2, 5, 6))
    expect_equal(gapped$n, 6)
    expect_equal(.meth_rows(4, factor(c("a", "a", "b", "b")), gap = 0)$y, 1:4)
    expect_equal(.meth_rows(1, factor("a"))$y, 1)

    q <- .meth_query(meth_cohort(), meth_region())
    fig <- .meth_figure(q, group.by = "platform", group.gap = 1)
    beta <- fig$x$data[[2]]
    expect_identical(beta$name, "Beta")
    expect_identical(nrow(beta$z), 8L)
    expect_true(all(is.na(beta$z[3, ])))
    expect_true(all(is.na(fig$x$data[[1]]$z[3, ])))
})

test_that("a dendrogram's leaves sit on their samples' rows", {
    hc <- stats::hclust(stats::dist(c(a = 1, b = 2, c = 10)))
    rows <- c(5, 6, 9)
    shape <- .meth_dendrogram(hc, rows)

    # Leaves are drawn at height 0, on the rows given for hc$order.
    expect_setequal(shape$y[which(shape$x == 0)], rows)
    expect_equal(max(shape$x, na.rm = TRUE), max(hc$height))
})


# ---- Heatmap ----------------------------------------------------------------

test_that("the layer behind the heatmap holds why each cell is empty", {
    betas <- matrix(c(0.5, NA, NA, 0.1), 2, 2)
    absent <- matrix(c(FALSE, TRUE, FALSE, FALSE), 2, 2)
    expect_identical(.meth_empty_cells(betas, absent), matrix(c(NA, 1, 2, NA), 2, 2))
})

test_that("the heatmap shows every CpG in order, with beta rounded for the page", {
    q <- .meth_query(meth_cohort(), meth_region())
    q$betas[1, 1] <- 0.123456
    fig <- .meth_figure(q)

    empty <- fig$x$data[[1]]
    beta <- fig$x$data[[2]]
    expect_identical(dim(beta$z), c(6L, 6L))
    expect_identical(beta$z[1, 1], 0.123)
    expect_identical(beta$coloraxis, "coloraxis")
    expect_identical(empty$coloraxis, "coloraxis2")
    # H1 has no CpG at 250, the third column: not on HM450.
    expect_identical(empty$z[1, 3], 1)
    expect_true(is.na(beta$z[1, 3]))
    expect_match(beta$text[1, 1], "H1<br>chr1:100<br>cg1<br>Beta: 0.123", fixed = TRUE)
    expect_match(empty$text[1, 3], "Not on this array", fixed = TRUE)
})

test_that("a heatmap past the limit drops its hover text", {
    local_mocked_bindings(.meth_hover_limit = 1)
    fig <- .meth_figure(.meth_query(meth_cohort(), meth_region()))
    expect_null(fig$x$data[[2]]$text)
    expect_identical(fig$x$data[[2]]$hoverinfo, "z")
    expect_identical(fig$x$data[[1]]$hoverinfo, "skip")
})

test_that("colours are set on the layout, not the traces", {
    fig <- .meth_figure(.meth_query(meth_cohort(), meth_region()))
    first <- .meth_apply_scale(fig, colors = c("#000000", "#FFFFFF"), min = 0, max = 1, title = "Beta")
    second <- .meth_apply_scale(fig,
        colors = c("#FF0000", "#00FF00"), min = 0.2, max = 0.8, reverse = TRUE, title = "New",
        absent.color = "#123456", na.color = "#654321"
    )

    expect_identical(first$x$data, second$x$data)
    expect_identical(second$x$layout$coloraxis$cmin, 0.2)
    expect_identical(second$x$layout$coloraxis$colorscale[[1]][[2]], "#00FF00")
    expect_identical(second$x$layout$coloraxis$colorbar$title$text, "New")
    expect_identical(second$x$layout$coloraxis2$colorscale[[1]][[2]], "#123456")
    expect_identical(second$x$layout$coloraxis2$colorscale[[4]][[2]], "#654321")
})

test_that("blank limits fall back on the data", {
    fig <- .meth_figure(.meth_query(meth_cohort(), meth_region()))
    scaled <- .meth_apply_scale(fig)
    expect_identical(scaled$x$layout$coloraxis$cmin, 0.1)
    expect_identical(scaled$x$layout$coloraxis$cmax, 0.9)
})


# ---- Panels and axes --------------------------------------------------------

test_that("each panel has its own axes, all linked to the first of each side", {
    q <- .meth_query(meth_cohort(), meth_region())
    fig <- .meth_figure(q, cluster.samples = TRUE, anno.left = "tissue", anno.right = "age")
    layout <- fig$x$layout
    heat <- attr(fig, "heat.axes")

    # The primary axes sit on the outermost panels, not on the heatmap.
    expect_false(any(heat %in% c("xaxis", "yaxis")))
    expect_identical(layout[[heat[1]]]$matches, "x")
    expect_identical(layout[[heat[2]]]$matches, "y")
    expect_identical(layout$yaxis$range, c(6.5, 0.5))
    expect_identical(layout$yaxis$ticktext, attr(fig, "table")$samples$sample)

    used <- unique(unlist(lapply(fig$x$data, function(tr) c(tr$xaxis, tr$yaxis))))
    drawn <- sub("^([xy])", "\\1axis", used)
    expect_setequal(drawn, grep("^[xy]axis", names(layout), value = TRUE))

    # Everything but the primary axes keeps its own styling.
    expect_setequal(fig$x$.vizmodules_overlay_axes, setdiff(drawn, c("xaxis", "yaxis")))
})

test_that("with no strips the heatmap holds the primary axes", {
    q <- .meth_query(meth_cohort(), meth_region())
    fig <- .meth_figure(q, show.coverage = FALSE)
    expect_identical(attr(fig, "heat.axes"), c("xaxis", "yaxis"))
    expect_null(fig$x$layout$xaxis$matches)
})

test_that("panels stack without overlapping", {
    q <- .meth_query(meth_cohort(), meth_region())
    fig <- .meth_figure(q, cluster.samples = TRUE, anno.left = "tissue", anno.right = "age", cpg.labels = "locus")
    y <- lapply(fig$x$data, function(tr) fig$x$layout[[sub("^y", "yaxis", tr$yaxis)]]$domain)
    y <- unique(Filter(Negate(is.null), y))
    y <- y[order(vapply(y, `[`, numeric(1), 1))]
    for (i in seq_along(y)[-1]) expect_gte(y[[i]][1], y[[i - 1]][2])
    expect_true(all(vapply(y, function(d) d[1] >= 0 && d[2] <= 1, logical(1))))

    panels <- .meth_domains(n.left = 2, n.right = 3, dendrogram = TRUE, txn.rows = 500, n.bottom = 2, labelled = TRUE)
    expect_gt(diff(panels$y$heatmap), 0.2)
    expect_lte(diff(panels$y$transcripts), 0.3 + 1e-8)
    expect_gt(diff(panels$x$heatmap), 0.5)
})

test_that("panels can be turned off", {
    q <- .meth_query(meth_cohort(), meth_region())
    fig <- .meth_figure(q, show.cytoband = FALSE, show.map.lines = FALSE)
    text <- plotly::plotly_json(fig, FALSE)
    expect_false(grepl("#FF0000", text, fixed = TRUE))
    expect_length(Filter(function(tr) isTRUE(tr$fill == "toself") && tr$fillcolor == "#EEEEEE", fig$x$data), 0)

    full <- .meth_figure(q)
    expect_gt(length(full$x$data), length(fig$x$data))
})

test_that("the coverage strip shows each array's CpGs", {
    q <- .meth_query(meth_cohort(), meth_region())
    fig <- .meth_figure(q)
    strips <- Filter(function(tr) identical(dim(tr$z), c(1L, 6L)), fig$x$data)

    expect_length(strips, 3)
    expect_identical(as.vector(strips[[1]]$z), c(1, 1, NA, 1, NA, NA))
    expect_identical(fig$x$layout[[sub("^y", "yaxis", strips[[1]]$yaxis)]]$ticktext, c("HM450", "EPIC", "EPICv2"))

    # One array has nothing to compare.
    single <- methylationCohort(meth_betas()["HM450"], probes = meth_probes(), txns = meth_txns())
    alone <- .meth_figure(.meth_query(single, meth_region()))
    expect_length(Filter(function(tr) identical(dim(tr$z), c(1L, 3L)), alone$x$data), 0)
})

test_that("columns can be labelled by probe or position", {
    q <- .meth_query(meth_cohort(), meth_region())
    expect_identical(.meth_figure(q, cpg.labels = "locus")$x$layout$xaxis$ticktext, q$cpgs$locus)
    expect_identical(.meth_figure(q, cpg.labels = "probe")$x$layout$xaxis$ticktext[c(1, 3, 6)],
        c("cg1", "cg2", "cg5_TC21"))
    expect_null(.meth_figure(q)$x$layout$xaxis$ticktext)
})

test_that("rowData is drawn as CpG strips", {
    betas <- matrix(c(0.1, 0.2), 2, 1, dimnames = list(c("cg1", "cg2"), "S1"))
    se <- SummarizedExperiment::SummarizedExperiment(
        list(betas = betas),
        rowData = S4Vectors::DataFrame(chr = "chr1", pos = c(100, 200), context = c("Island", "Sea"))
    )
    cohort <- methylationCohort(list(EPIC = se), txns = meth_txns(), cytobands = meth_bands())
    expect_identical(.meth_cpg_cols(cohort), "context")

    fig <- .meth_figure(.meth_query(cohort, meth_region()), cpg.tracks = "context")
    entries <- vapply(Filter(function(tr) !is.null(tr$legendgroup), fig$x$data), `[[`, "", "name")
    expect_setequal(entries, c("Island", "Sea"))
})


# ---- Sample strips ----------------------------------------------------------

test_that("a discrete strip is one flat band per level", {
    strip <- .meth_strip(c("b", "a", NA), "col", c("col: a" = "#111111", "col: b" = "#222222"))

    expect_identical(strip$z, c(2L, 1L, NA))
    expect_identical(strip$legend$color, c("#111111", "#222222"))
    expect_identical(c(strip$zmin, strip$zmax), c(0.5, 2.5))
    expect_identical(strip$colorscale, .meth_steps(c("#111111", "#222222")))
    expect_identical(.meth_steps(c("#111111", "#222222"))[[2]], list(0.5, "#111111"))
})

test_that("a level with no colour given takes one from the palette", {
    strip <- .meth_strip("a", "col", NULL)
    expect_identical(strip$legend$color, .meth_palette(1))
})

test_that("a numeric strip runs from low to high", {
    strip <- .meth_strip(c(10, 20, NA), "age", low = "#FFFFFF", high = "#000000")
    expect_identical(c(strip$zmin, strip$zmax), c(10, 20))
    expect_identical(strip$colorscale, list(list(0, "#FFFFFF"), list(1, "#000000")))
    expect_identical(strip$legend$name, c("10", "15", "20"))

    constant <- .meth_strip(c(5, 5), "age")
    expect_identical(c(constant$zmin, constant$zmax), c(4.5, 5.5))
    expect_identical(c(.meth_strip(c(NA_real_, NA_real_), "age")$zmin), 0)
})

test_that("strips follow the plotted order and leave group gaps empty", {
    q <- .meth_query(meth_cohort(), meth_region())
    fig <- .meth_figure(q, group.by = "tissue", anno.left = "platform")
    strip <- Filter(function(tr) identical(dim(tr$z), c(7L, 1L)), fig$x$data)[[1]]

    expect_identical(as.vector(strip$z), c(1L, 2L, 3L, NA, 1L, 2L, 3L) + 0)
    expect_match(strip$text[5, 1], "H2<br>platform: HM450", fixed = TRUE)
})

test_that("an annotation on both sides is in the legend once", {
    q <- .meth_query(meth_cohort(), meth_region())
    fig <- .meth_figure(q, anno.left = "tissue", anno.right = c("tissue", "age"))
    groups <- vapply(Filter(function(tr) !is.null(tr$legendgroup), fig$x$data), `[[`, "", "legendgroup")

    expect_identical(as.vector(table(groups)[c("tissue", "age")]), c(2L, 3L))
})

test_that("a level's colour holds whichever strips are shown", {
    cohort <- meth_cohort()
    colors <- .meth_level_colors(cohort)

    expect_identical(anyDuplicated(colors), 0L)
    expect_true(all(c("tissue: Blood", "platform: EPIC") %in% names(colors)))
    expect_identical(
        .meth_anno_groups(cohort, c("tissue", "age", "tissue")),
        c("tissue: Blood", "tissue: Liver")
    )
})

test_that("a level with an apostrophe is carried through intact", {
    betas <- meth_betas()
    samples <- meth_samples()
    samples$tissue[1] <- "Crohn's"
    cohort <- methylationCohort(betas, samples = samples, probes = meth_probes())

    expect_true("tissue: Crohn's" %in% names(.meth_level_colors(cohort)))
    fig <- .meth_figure(.meth_query(cohort, meth_region()), anno.left = "tissue")
    entries <- vapply(Filter(function(tr) !is.null(tr$legendgroup), fig$x$data), `[[`, "", "name")
    expect_true("Crohn's" %in% entries)
})

test_that("columns are offered by what they can be used for", {
    samples <- meth_cohort()$samples
    samples$id <- paste0("id", seq_len(nrow(samples)))

    expect_false("sample" %in% .meth_group_cols(samples))
    expect_true(all(c("platform", "tissue") %in% .meth_group_cols(samples)))
    expect_true("age" %in% .meth_strip_cols(samples))
    expect_false("age" %in% .meth_group_cols(samples))
})


# ---- Transcripts ------------------------------------------------------------

test_that("full transcripts take a row each", {
    model <- .meth_txn_model(meth_txns(), meth_region())
    expect_identical(model$n, 3L)
    expect_identical(sort(model$spans$label), c("GENEA (T1)", "GENEA (T2)", "GENEB (T3)"))
    expect_identical(nrow(model$exons), 6L)
})

test_that("collapsed transcripts overlay each gene on a row", {
    model <- .meth_txn_model(meth_txns(), meth_region(), "collapsed")

    expect_identical(model$spans$label, c("GENEA", "GENEB"))
    expect_identical(model$exons$start[model$exons$row == 1], c(120, 220))
    expect_identical(model$exons$end[model$exons$row == 1], c(160, 320))
    expect_identical(model$spans$strand, c("+", "-"))
    expect_match(model$spans$hover[1], "2 transcripts", fixed = TRUE)
})

test_that("genes that overlap take separate rows, and others share one", {
    model <- .meth_txn_model(meth_txns(), meth_region(), "collapsed")
    expect_identical(model$spans$row, c(1L, 2L))
    expect_identical(model$n, 2L)

    # Inside GENEB's second exon only, they no longer meet.
    apart <- meth_txns()
    apart <- apart[c(1, 3)]
    apart[[1]] <- apart[[1]][1]
    model <- .meth_txn_model(apart, meth_region(), "collapsed")
    expect_identical(model$spans$row, c(1L, 1L))
})

test_that("the coding part of each exon is found", {
    model <- .meth_txn_model(meth_txns()[1], meth_region())
    expect_identical(model$cds$start, c(130, 220))
    expect_identical(model$cds$end, c(160, 250))

    # GENEB is non-coding.
    expect_identical(nrow(.meth_txn_model(meth_txns()[3], meth_region())$cds), 0L)
})

test_that("transcripts are filtered by type and clipped to the region", {
    coding <- .meth_txn_model(meth_txns(), meth_region(), types = "protein_coding")
    expect_identical(coding$n, 2L)
    expect_identical(.meth_txn_model(meth_txns(), meth_region(), types = "lncRNA")$n, 1L)
    expect_identical(.meth_txn_model(meth_txns(), meth_region(), types = character(0))$n, 3L)
    expect_identical(.meth_txn_model(meth_txns(), meth_region(), types = "miRNA")$n, 0L)
    expect_identical(.meth_txn_model(NULL, meth_region())$n, 0L)

    clipped <- .meth_txn_model(meth_txns(), meth_region(200, 300))
    expect_true(all(clipped$exons$start >= 200 & clipped$exons$end <= 300))
})

test_that("a transcript with only an intron in the region is kept", {
    cohort <- meth_cohort()
    reg <- GenomicRanges::GRanges("chr1", IRanges::IRanges(350, 400))
    expect_identical(names(.meth_region_txns(cohort, reg, meth_region(350, 400))), "T3")
})

test_that("transcripts draw whichever way their strand runs", {
    q <- .meth_query(meth_cohort(), meth_region())
    fig <- .meth_figure(q, txn.types = NULL)
    arrows <- Filter(function(tr) identical(tr$mode, "markers") && is.null(tr$legendgroup), fig$x$data)[[1]]

    expect_setequal(arrows$marker$symbol, c("triangle-right", "triangle-left"))
    expect_match(paste(arrows$text, collapse = " "), "T3 (-)", fixed = TRUE)
})

test_that("a region with no transcripts says so", {
    q <- .meth_query(meth_cohort(), meth_region())
    q$txns <- q$txns[0]
    fig <- .meth_figure(q)
    text <- unlist(lapply(fig$x$data, `[[`, "text"))
    expect_true("No transcripts" %in% text)
})


# ---- The function -----------------------------------------------------------

test_that("the function takes one lookup and draws it", {
    cohort <- meth_cohort()

    expect_error(methylationTrack(cohort), "one of")
    expect_error(methylationTrack(cohort, gene = "GENEA", region = "chr1:1-2"), "one of")

    fig <- methylationTrack(cohort, region = "chr1:50-550", group.by = "platform", cluster.samples = TRUE)
    expect_s3_class(fig, "plotly")
    expect_identical(fig$x$layout$coloraxis$cmax, 1)
    expect_identical(fig$x$layout$coloraxis$colorbar$title$text, "Beta value")

    by_probes <- methylationTrack(cohort, probes = c("cg1", "cg9"), upstream = 0, downstream = 0)
    expect_identical(attr(by_probes, "table")$betas$pos, c(100L, 200L, 250L, 300L))

    # Anything methylationCohort() takes.
    betas <- matrix(0.5, 1, 2, dimnames = list("cg1_TC21", c("A", "B")))
    local_mocked_bindings(.meth_manifest = function(platform, genome) meth_ranges("cg1_TC21", 100))
    local_mocked_bindings(.meth_genome_info = function(genome) NULL)
    expect_s3_class(methylationTrack(betas, region = "chr1:50-150"), "plotly")
})

test_that("the function names a column it does not know", {
    expect_error(methylationTrack(meth_cohort(), gene = "GENEA", group.by = "nope"), "Not columns")
    expect_error(methylationTrack(meth_cohort(), gene = "GENEA", anno.left = "nope"), "Not columns")
})

test_that("the function gives each strip the cohort's colours", {
    cohort <- meth_cohort()
    colors <- .meth_level_colors(cohort)
    fig <- methylationTrack(cohort, gene = "GENEA", anno.left = c("tissue", "platform"))
    swatches <- Filter(function(tr) identical(tr$legendgroup, "tissue"), fig$x$data)

    expect_identical(swatches[[1]]$marker$color, unname(colors["tissue: Blood"]))

    mine <- methylationTrack(cohort, gene = "GENEA", anno.left = "tissue", anno.colors = c("tissue: Blood" = "#ABCDEF"))
    swatches <- Filter(function(tr) identical(tr$legendgroup, "tissue"), mine$x$data)
    expect_identical(swatches[[1]]$marker$color, "#ABCDEF")
})

test_that("the figure carries what it plotted", {
    fig <- methylationTrack(meth_cohort(), gene = "GENEA", group.by = "platform")
    tables <- attr(fig, "table")

    expect_named(tables, c("betas", "samples"))
    expect_true(all(c("locus", "pos", "probe.HM450", "H1", "V2") %in% names(tables$betas)))
    expect_identical(tables$samples$row, c(1, 2, 4, 5, 7, 8))
})

test_that("the figure survives the shared styling", {
    q <- .meth_query(meth_cohort(), meth_region())
    fig <- .meth_figure(q, anno.right = "tissue", cluster.samples = TRUE)
    input <- c(test_axes_inputs(), list(
        title.font.size = 20, download.format = "png", legend.show = TRUE, legend.text.size = 12,
        legend.title.size = 14, hline.intercepts = "2"
    ))
    framed <- .meth_apply_frame(fig,
        font.size = 7, showline = TRUE, mirror = TRUE, linecolor = "#123456", linewidth = 2
    )
    styled <- plotly::plotly_build(.sci_finalize_plotly(framed, input, identity))
    layout <- styled$x$layout
    heat <- attr(fig, "heat.axes")

    # The Axes tab reaches the labels but boxes the heatmap, not the strips.
    expect_identical(layout$yaxis$tickfont$size, 7)
    expect_false(layout$yaxis$showline)
    expect_false(layout$yaxis$showgrid)
    expect_true(layout[[heat[1]]]$showline)
    expect_identical(layout[[heat[1]]]$linecolor, "#123456")
    expect_identical(layout[[heat[2]]]$linewidth, 2)
    # Panels keep their own settings, and no extra borders are drawn around them.
    expect_identical(layout$yaxis$range, fig$x$layout$yaxis$range)
    expect_length(Filter(function(s) identical(s$type, "rect"), layout$shapes), 0)
})


# ---- The module -------------------------------------------------------------

meth_module_inputs <- function(...) {
    utils::modifyList(c(
        list(
            auto.update = TRUE, download.format = "png", locate.by = "gene", gene = "GENEA", region = "", probes = "",
            sample.filter = "", upstream = 0, downstream = 0, cpg.scope = "all", max.cpgs = 1000, filter.col = "",
            group.by = "platform", group.gap = 1, cluster.samples = FALSE, show.dendrogram = TRUE
        ),
        test_axes_inputs(), test_legend_inputs()
    ), list(...))
}

test_that("the module's inputs and defaults are consistent", {
    cohort <- meth_cohort()
    d <- .meth_defaults(cohort)
    expect_identical(d$group.by, "platform")
    expect_identical(d$txn.types, "protein_coding")

    expect_identical(.meth_defaults(cohort, list(group.by = "nope"))$group.by, "platform")
    expect_identical(.meth_defaults(cohort, list(anno.left = c("tissue", "age")))$anno.left, c("tissue", "age"))
    expect_identical(.meth_defaults(cohort, list(anno.left = "nope"))$anno.left, character(0))
    expect_identical(.meth_defaults(cohort, list(gene = "GENEB"))$gene, "GENEB")
    expect_identical(.meth_defaults(cohort, list(gene = "NOPE"))$gene, "")
    expect_identical(
        .meth_defaults(cohort, list(filter.col = "tissue", filter.levels = "Blood"))$filter.levels, "Blood"
    )

    html <- as.character(methylationTrackInputsUI("m", cohort, defaults = list(gene = "GENEB")))
    for (key in c("gene", "cpg.scope", "anno.left", "txn.view", "colorscale.colors", "absent.color", "legend.show")) {
        expect_match(html, paste0("m-", key), fixed = TRUE)
    }
    for (tab in c("Samples", "Tracks", "Aesthetics")) expect_match(html, tab, fixed = TRUE)
    expect_false(grepl("hline.intercepts", html, fixed = TRUE))
})

test_that("one array is not grouped by default", {
    single <- methylationCohort(meth_betas()["HM450"], probes = meth_probes(), txns = meth_txns())
    expect_identical(.meth_defaults(single)$group.by, "")
})

test_that("the module's scale starts from 0 to 1, and a caller can change that", {
    expect_identical(.meth_axes_defaults(NULL)$colorscale.max, 1)
    expect_identical(.meth_axes_defaults(list(colorscale.max = 0.8))$colorscale.max, 0.8)
    expect_true(all(.meth_grid_inputs %in% c("show.grid.x", "show.grid.y", "grid.color")))
})

test_that("the server draws, and a lookup runs only when it must", {
    queries <- 0
    real <- .meth_query
    local_mocked_bindings(.meth_query = function(...) {
        queries <<- queries + 1
        real(...)
    })
    cohort <- meth_cohort()
    shiny::testServer(methylationTrackServer, args = list(id = "m", data = shiny::reactive(cohort)), {
        suppressWarnings(do.call(session$setInputs, meth_module_inputs()))
        fig <- suppressWarnings(generate_plot())
        expect_identical(attr(fig, "table")$betas$pos, c(200L, 250L, 300L))
        expect_identical(queries, 1)

        # Colours, grouping and tracks work from the same query.
        session$setInputs(colorscale.reverse = TRUE)
        suppressWarnings(generate_plot())
        session$setInputs(group.by = "tissue", txn.view = "collapsed", anno.left = "tissue")
        fig <- suppressWarnings(generate_plot())
        expect_identical(attr(fig, "table")$samples$group[1], "Blood")
        expect_identical(queries, 1)

        # A new sample choice or lookup needs one.
        session$setInputs(filter.col = "tissue", filter.levels = "Blood")
        fig <- suppressWarnings(generate_plot())
        expect_identical(attr(fig, "table")$samples$sample, c("H1", "E1", "V1"))
        expect_identical(queries, 2)
        expect_match(output$sample.status, "3 of 6 samples")

        session$setInputs(locate.by = "region", region = "chr1:350-550")
        session$elapse(800)
        fig <- suppressWarnings(generate_plot())
        expect_identical(attr(fig, "table")$betas$pos, c(400L, 500L))
        expect_identical(queries, 3)
    })
})

test_that("Reset puts the module's own inputs back", {
    sent <- list()
    record <- function(session, inputId, label = NULL, value = NULL, selected = NULL, ...) {
        sent[[inputId]] <<- value %||% selected
        invisible(NULL)
    }
    local_mocked_bindings(
        update_viz_select = function(session, inputId, choices = NULL, selected = NULL, ...) {
            sent[[inputId]] <<- selected
            invisible(NULL)
        },
        updateMaterialSwitch = record, updateColourInput = record, updateNumericInput = record,
        updateTextInput = record, updateTextAreaInput = record,
        reset_colorscale_inputs = function(session, defaults) {
            sent$scale <<- defaults
            invisible(NULL)
        }
    )
    cohort <- meth_cohort()
    defaults <- list(gene = "GENEB", anno.left = "tissue", cluster.samples = TRUE)
    shiny::testServer(methylationTrackServer, args = list(
        id = "m", data = shiny::reactive(cohort), defaults = defaults
    ), {
        suppressWarnings(do.call(session$setInputs, meth_module_inputs(gene = "GENEA")))
        session$setInputs(reset = 1)
    })

    expect_identical(sent$gene, "GENEB")
    expect_identical(sent$anno.left, "tissue")
    expect_identical(sent$group.by, "platform")
    expect_true(sent$cluster.samples)
    expect_identical(sent$max.cpgs, 1000)
    expect_identical(sent$absent.color, .meth_colors$absent)
    expect_identical(sent$scale$colorscale.max, 1)
    expect_identical(sent$scale$colorbar.title, "Beta value")

    # Every control the module's UI builds for its own settings is covered.
    expect_identical(setdiff(names(.meth_defaults(cohort)), names(sent)), character(0))
})

test_that("a lookup that fails is a message, not a crash", {
    cohort <- meth_cohort()
    shiny::testServer(methylationTrackServer, args = list(id = "m", data = shiny::reactive(cohort)), {
        suppressWarnings(do.call(session$setInputs, meth_module_inputs(gene = "")))
        expect_error(generate_plot(), "Choose a gene")

        session$setInputs(sample.filter = "age >")
        session$setInputs(gene = "GENEA")
        session$elapse(800)
        expect_error(generate_plot(), "Could not parse")
        expect_match(output$sample.status, "Could not parse")
    })
})

test_that("the lookup waits for the inputs of a rendered UI", {
    cohort <- meth_cohort()
    shiny::testServer(methylationTrackServer, args = list(id = "m", data = shiny::reactive(cohort)), {
        session$setInputs(auto.update = TRUE)
        expect_error(state$target(), class = "shiny.silent.error")
    })
})

test_that("the app takes one cohort or a list of them", {
    captured <- NULL
    local_mocked_bindings(.sci_object_app = function(..., object_list, validate, preview, defaults = NULL) {
        captured <<- object_list
        "app"
    })
    cohort <- meth_cohort()

    methylationTrackApp(cohort)
    expect_named(captured, "Cohort")
    expect_s3_class(captured$Cohort, "methylationCohort")

    methylationTrackApp(list(First = cohort, Second = cohort))
    expect_named(captured, c("First", "Second"))

    methylationTrackApp()
    expect_named(captured, "example_methylation")
    expect_identical(.meth_preview(cohort), cohort$samples)
})
