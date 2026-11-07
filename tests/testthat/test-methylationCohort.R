# ---- Joining arrays ---------------------------------------------------------

test_that("arrays join on position, not on probe ID", {
    q <- .meth_query(meth_cohort(), meth_region())

    # cg2 sits at 200 on HM450 and 250 on EPIC, so it must stay two columns.
    expect_identical(q$cpgs$pos, c(100L, 200L, 250L, 300L, 400L, 500L))
    expect_identical(q$betas[q$cpgs$pos == 200, ][["H1"]], 0.2)
    expect_true(is.na(q$betas[q$cpgs$pos == 200, "E1"]))
    expect_identical(q$betas[q$cpgs$pos == 250, ][["E1"]], 0.21)
    expect_true(is.na(q$betas[q$cpgs$pos == 250, "H1"]))

    # cg3 and cg9 measure one CpG, so they share a column.
    at300 <- q$betas[q$cpgs$pos == 300, ]
    expect_identical(unname(at300[c("H1", "E1")]), c(0.3, 0.31))
    expect_identical(q$cpgs$probe.HM450[q$cpgs$pos == 300], "cg3")
    expect_identical(q$cpgs$probe.EPIC[q$cpgs$pos == 300], "cg9")
})

test_that("replicate probes at one position are averaged, skipping missing values", {
    q <- .meth_query(meth_cohort(), meth_region())
    at100 <- q$betas[q$cpgs$pos == 100, ]

    expect_equal(at100[["V1"]], mean(c(0.2, 0.4)))
    expect_equal(at100[["V2"]], 0.3)
    expect_identical(q$cpgs$probe.EPICv2[q$cpgs$pos == 100], "cg1_TC21;cg1_TC22")
})

test_that("collapsing matches sesame's replicate collapse", {
    skip_if_not_installed("sesame")
    m <- matrix(c(seq(0, 1, length.out = 8), NA), nrow = 3)
    rownames(m) <- c("cg00004963_TC21", "cg00004963_TC22", "cg00004747_TC21")
    colnames(m) <- c("A", "B", "C")

    ours <- .meth_collapse(m, c(20L, 20L, 10L))
    theirs <- sesame::betasCollapseToPfx(m)

    expect_equal(unname(ours), unname(theirs[c("cg00004747", "cg00004963"), ]))
})

test_that("only the region asked for is pulled", {
    q <- .meth_query(meth_cohort(), meth_region(150, 350))
    expect_identical(q$cpgs$pos, c(200L, 250L, 300L))
    expect_error(.meth_query(meth_cohort(), meth_region(600, 700)), "No CpGs")
})


# ---- Empty cells ------------------------------------------------------------

test_that("a CpG not on an array is told apart from a value that is missing", {
    betas <- meth_betas()
    betas$HM450["cg1", "H1"] <- NA
    cohort <- methylationCohort(betas, samples = meth_samples(), probes = meth_probes())
    q <- .meth_query(cohort, meth_region())

    # HM450 has a row for cg1, so H1 lacks a value there; it has none for position 400.
    expect_false(q$absent[q$cpgs$pos == 100, "H1"])
    expect_true(is.na(q$betas[q$cpgs$pos == 100, "H1"]))
    expect_true(q$absent[q$cpgs$pos == 400, "H1"])
    expect_identical(colSums(q$coverage), c(HM450 = 3, EPIC = 4, EPICv2 = 3))
})

test_that("a masked probe on every sample still counts as on the array", {
    betas <- meth_betas()
    betas$HM450["cg2", ] <- NA
    cohort <- methylationCohort(betas, samples = meth_samples(), probes = meth_probes())
    q <- .meth_query(cohort, meth_region())

    expect_false(any(q$absent[q$cpgs$pos == 200, c("H1", "H2")]))
})

test_that("a merged matrix tells presence from the values of each platform", {
    positions <- meth_ranges(c("a", "b"), c(100, 200))
    betas <- matrix(c(0.1, NA, 0.2, NA, 0.3, 0.4, NA, 0.5), 2, 4,
        dimnames = list(c("a", "b"), c("H1", "H2", "E1", "E2")))
    samples <- data.frame(Platform = c("HM450", "HM450", "EPIC", "EPIC"), row.names = colnames(betas))
    q <- .meth_query(methylationCohort(betas, samples = samples, probes = positions), meth_region())

    # No HM450 sample has a value for b, so it is taken not to be on HM450. E2 is a
    # masked probe, since E1 has a value for a.
    expect_true(all(q$absent[2, c("H1", "H2")]))
    expect_false(q$absent[1, "E2"])
    expect_true(is.na(q$betas[1, "E2"]))
})

test_that("a merged matrix with no platforms cannot mark cells absent", {
    betas <- matrix(c(0.1, NA, 0.2, 0.3), 2, 2, dimnames = list(c("a", "b"), c("S1", "S2")))
    cohort <- methylationCohort(betas, probes = meth_ranges(c("a", "b"), c(100, 200)))
    q <- .meth_query(cohort, meth_region())

    expect_null(q$coverage)
    expect_false(any(q$absent))
    expect_false("platform" %in% names(cohort$samples))
})

test_that("CpG scope and the sample choice set which CpGs are drawn", {
    cohort <- meth_cohort()

    expect_identical(.meth_query(cohort, meth_region(), scope = "shared")$cpgs$pos, 100L)

    # Without EPICv2's samples, its own CpG at 500 has nothing to show.
    hm_epic <- .meth_query(cohort, meth_region(), samples = c("H1", "E1"))
    expect_false(500L %in% hm_epic$cpgs$pos)
    expect_identical(colnames(hm_epic$coverage), c("HM450", "EPIC"))
    shared <- .meth_query(cohort, meth_region(), samples = c("H1", "E1"), scope = "shared")
    expect_identical(shared$cpgs$pos, c(100L, 300L))

    expect_error(.meth_query(cohort, meth_region(), samples = character(0)), "No samples")
    expect_error(.meth_query(cohort, meth_region(150, 350), scope = "shared"), "on all of the plotted arrays")
})

test_that("too many CpGs asks for a smaller region", {
    expect_error(.meth_query(meth_cohort(), meth_region(), max.cpgs = 2), "over the limit of 2")
})


# ---- Input forms ------------------------------------------------------------

meth_se <- function(betas, ...) {
    SummarizedExperiment::SummarizedExperiment(list(betas = betas), ...)
}

test_that("a list of SummarizedExperiments gives the same cohort as matrices", {
    betas <- meth_betas()
    probes <- meth_probes()
    samples <- meth_samples()
    ses <- lapply(stats::setNames(nm = names(betas)), function(p) {
        meth_se(betas[[p]], rowRanges = probes[[p]], colData = S4Vectors::DataFrame(samples[colnames(betas[[p]]), ]))
    })
    cohort <- methylationCohort(ses, cytobands = meth_bands())
    reference <- meth_cohort()

    expect_identical(cohort$samples$tissue, reference$samples$tissue)
    expect_identical(names(cohort$arrays), c("HM450", "EPIC", "EPICv2"))
    expect_equal(.meth_query(cohort, meth_region())$betas, .meth_query(reference, meth_region())$betas)
})

test_that("a merged SummarizedExperiment carries its samples and positions", {
    betas <- matrix(c(0.1, 0.2, 0.3, 0.4), 2, 2, dimnames = list(c("a", "b"), c("S1", "S2")))
    se <- meth_se(betas,
        rowRanges = meth_ranges(c("a", "b"), c(100, 200)),
        colData = S4Vectors::DataFrame(platform = c("HM450", "EPIC"), group = c("x", "y"), row.names = c("S1", "S2"))
    )
    cohort <- methylationCohort(se)

    expect_true(cohort$arrays$merged$merged)
    expect_identical(levels(cohort$samples$platform), c("HM450", "EPIC"))
    expect_identical(cohort$samples$group, c("x", "y"))
    expect_identical(.meth_query(cohort, meth_region())$betas[[2, "S2"]], 0.4)
})

test_that("rowData positions are read, and manifest starts shifted to one-based", {
    betas <- matrix(c(0.1, 0.2), 2, 1, dimnames = list(c("cg1", "cg2"), "S1"))

    manifest <- meth_se(betas, rowData = S4Vectors::DataFrame(
        CpG_chrm = c("chr1", "chr1"), CpG_beg = c(99, 199), CpG_end = c(101, 201), context = c("Island", "Sea")
    ))
    q <- .meth_query(methylationCohort(list(EPIC = manifest)), meth_region())
    expect_identical(q$cpgs$pos, c(100L, 200L))
    expect_identical(q$rowdata$context, c("Island", "Sea"))

    minfi <- meth_se(betas, rowData = S4Vectors::DataFrame(chr = c("chr1", "chr1"), pos = c(100, 200)))
    expect_identical(.meth_query(methylationCohort(list(EPIC = minfi)), meth_region())$cpgs$pos, c(100L, 200L))
})

test_that("rowRanges on another genome build are refused", {
    betas <- matrix(0.5, 1, 1, dimnames = list("cg1", "S1"))
    ranges <- meth_ranges("cg1", 100)
    Seqinfo::genome(ranges) <- "hg19"
    arrays <- list(EPIC = meth_se(betas, rowRanges = ranges))
    expect_error(methylationCohort(arrays), "on hg19, not hg38")
    expect_s3_class(methylationCohort(arrays, genome = "hg19"), "methylationCohort")

    Seqinfo::genome(ranges) <- "GRCh38"
    arrays <- list(EPIC = meth_se(betas, rowRanges = ranges))
    expect_s3_class(methylationCohort(arrays), "methylationCohort")
})

test_that("a delayed matrix stays delayed until a region is pulled", {
    skip_if_not_installed("DelayedArray")
    betas <- lapply(meth_betas(), DelayedArray::DelayedArray)
    cohort <- methylationCohort(betas, samples = meth_samples(), probes = meth_probes())

    expect_s4_class(cohort$arrays$HM450$betas, "DelayedMatrix")
    expect_equal(.meth_query(cohort, meth_region())$betas, .meth_query(meth_cohort(), meth_region())$betas)
})

test_that("an array named merged is still an array", {
    betas <- meth_betas()["HM450"]
    names(betas) <- "merged"
    probes <- list(merged = meth_probes()$HM450)
    q <- .meth_query(methylationCohort(betas, probes = probes), meth_region())

    expect_true(all(c("probe.merged") %in% names(q$cpgs)))
    expect_identical(colnames(q$coverage), "merged")
})

test_that("the beta assay is found by name, or asked for", {
    betas <- matrix(0.5, 1, 1, dimnames = list("cg1", "S1"))
    se <- SummarizedExperiment::SummarizedExperiment(list(mvals = betas + 1, Beta = betas))

    expect_identical(.meth_assay(se), "Beta")
    expect_identical(.meth_assay(se, "mvals"), "mvals")
    expect_error(.meth_assay(se, "other"), "No assay named")
})

test_that("positions match on a probe's prefix, either way round", {
    expect_identical(.meth_match_ids(c("cg1_TC21", "cg2", "cg3"), c("cg1", "cg2_BC11")), c(1L, 2L, NA))

    betas <- matrix(0.5, 1, 1, dimnames = list("cg1_TC21", "S1"))
    cohort <- methylationCohort(list(EPICv2 = betas), probes = meth_ranges("cg1", 100))
    expect_identical(.meth_query(cohort, meth_region())$cpgs$pos, 100L)
})

test_that("positions are read from manifests, array by array, only as needed", {
    loaded <- character(0)
    manifests <- list(
        EPICv2 = meth_ranges(c("cg1_TC21", "cg2_BC11"), c(100, 200)),
        EPIC = meth_ranges(c("cg1", "cg3"), c(111, 300)),
        HM450 = meth_ranges("cg4", 400)
    )
    local_mocked_bindings(.meth_manifest = function(platform, genome) {
        loaded <<- c(loaded, platform)
        manifests[[platform]]
    })

    place <- .meth_from_manifests("cg1_TC21", "EPICv2", "hg38")
    expect_identical(loaded, "EPICv2")
    expect_identical(place$start, 100L)

    # An ID in a merged matrix: exact matches first, on the newest array.
    loaded <- character(0)
    place <- .meth_from_manifests(c("cg1", "cg3", "cg4", "cg2", "gone"), NULL, "hg38")
    expect_identical(place$start, c(111L, 300L, 400L, 200L, NA))
    expect_identical(unique(loaded), c("EPICv2", "EPIC", "HM450"))

    expect_identical(.meth_platform_code(c("450K", "hm450", "EPICv1", "epic v2", "Other")),
        c("HM450", "HM450", "EPIC", "EPICv2", NA))
})

test_that("a matrix of an unnamed array finds its manifest from the row names", {
    local_mocked_bindings(.meth_manifest = function(platform, genome) {
        if (platform == "EPICv2") meth_ranges("cg1_TC21", 100) else stop("not needed")
    })
    betas <- matrix(0.5, 1, 1, dimnames = list("cg1_TC21", "S1"))
    expect_identical(.meth_query(.meth_as_cohort(betas), meth_region())$cpgs$pos, 100L)
})


# ---- Rows and samples -------------------------------------------------------

test_that("SNP, control and variant probes are dropped and unplaced ones counted", {
    ids <- c("cg1", "rs123", "ctl_1_NEGATIVE", "nv-GRCh38-chr1-1-1-A-T_TC11", "cg404")
    betas <- matrix(0.5, 5, 1, dimnames = list(ids, "S1"))
    cohort <- methylationCohort(list(EPIC = betas), probes = meth_ranges(c("cg1", "rs123"), c(100, 200)))

    expect_identical(names(cohort$arrays$EPIC$loci), "cg1")
    expect_identical(cohort$dropped, c(control = 3L, unplaced = 1L))
    expect_output(print(cohort), "3 SNP, control or variant probes left out")
    expect_output(print(cohort), "1 probes left out with no known position")
})

test_that("an array with nothing placed is an error", {
    betas <- matrix(0.5, 1, 1, dimnames = list("cg1", "S1"))
    expect_error(methylationCohort(list(EPIC = betas), probes = meth_ranges("cg2", 100)), "could be placed")
})

test_that("a sample on two arrays stays two samples", {
    betas <- meth_betas()
    colnames(betas$EPIC) <- c("H1", "E2")
    samples <- meth_samples()[c("H1", "H2", "E2", "V1", "V2"), ]
    cohort <- methylationCohort(betas, samples = samples, probes = meth_probes())

    expect_true(all(c("H1.HM450", "H1.EPIC") %in% cohort$samples$sample))
    expect_identical(cohort$samples["H1.EPIC", "age"], 30)
    expect_false(anyDuplicated(cohort$samples$sample) > 0)
    expect_identical(colnames(cohort$arrays$EPIC$betas), c("H1.EPIC", "E2"))
    q <- .meth_query(cohort, meth_region())
    expect_identical(q$betas[[1, "H1.EPIC"]], 0.11)
})

test_that("sample information is found by row name or by column", {
    by_column <- cbind(id = rownames(meth_samples()), meth_samples())
    rownames(by_column) <- NULL
    cohort <- methylationCohort(meth_betas(), samples = by_column, probes = meth_probes())
    expect_identical(cohort$samples["V2", "tissue"], "Liver")

    expect_error(
        methylationCohort(meth_betas(), samples = meth_samples()[1:2, ], probes = meth_probes()),
        "must name every sample"
    )
})

test_that("a list of arrays must be named, and platform follows the list's order", {
    expect_error(methylationCohort(unname(meth_betas()), probes = meth_probes()), "named by platform")
    expect_error(methylationCohort(list()), "holds no arrays")
    expect_identical(levels(meth_cohort()$samples$platform), c("HM450", "EPIC", "EPICv2"))
})

test_that("annotation is checked as it comes in", {
    expect_error(methylationCohort(meth_betas(), probes = meth_probes(), txns = list()), "GRangesList")
    expect_error(methylationCohort(meth_betas(), probes = meth_probes(), cytobands = data.frame(a = 1)), "chromStart")
    expect_error(methylationCohort(list(a = 1:3)), "must be a matrix")
    expect_error(methylationCohort(matrix(0.5, 1, 1)), "probe IDs as row names")
})

test_that("a cohort's own annotation is used, and a genome's is read only without it", {
    local_mocked_bindings(.meth_genome_info = function(genome) stop("should not be read"))
    cohort <- meth_cohort()
    expect_identical(.meth_txns(cohort), cohort$txns)
    expect_identical(.meth_cytobands(cohort), cohort$cytobands)

    local_mocked_bindings(.meth_genome_info = function(genome) NULL)
    plain <- methylationCohort(meth_betas(), probes = meth_probes())
    expect_null(.meth_txns(plain))
    q <- .meth_query(plain, meth_region())
    expect_null(q$txns)
    expect_null(q$cytobands)
})

test_that("printing reports how much the arrays share", {
    expect_output(print(meth_cohort()), "6 samples on hg38")
    expect_output(print(meth_cohort()), "2 CpGs shared by HM450 and EPIC")
    expect_output(print(meth_cohort()), "2 CpGs shared by EPIC and EPICv2")
})

test_that("coercion leaves a cohort alone", {
    cohort <- meth_cohort()
    expect_identical(.meth_as_cohort(cohort), cohort)
})

test_that("the example cohort needs no ExperimentHub", {
    data("example_methylation", package = "sciVizModules", envir = environment())
    local_mocked_bindings(.meth_genome_info = function(genome) stop("should not be read"))

    expect_s3_class(example_methylation, "methylationCohort")
    expect_setequal(.meth_gene_names(example_methylation)[.meth_gene_names(example_methylation) %in%
        c("DNMT1", "ADA", "MLH1", "BRCA1", "TP53", "GNAS")], c("DNMT1", "ADA", "MLH1", "BRCA1", "TP53", "GNAS"))
    q <- .meth_query(example_methylation, .meth_gene_region(example_methylation, "DNMT1"))
    expect_gt(sum(q$absent), 0)
    # Probes masked in the EPICv2 data, which the empty cells must not lose.
    expect_gt(sum(is.na(q$betas) & !q$absent), 0)
})


# ---- Agreement with sesame --------------------------------------------------

test_that("a region and a gene match sesame's on one array", {
    betas <- meth_sesame_betas()
    cohort <- methylationCohort(list(HM450 = betas))

    region <- .meth_region("chr19", 10260000, 10380000)
    q <- .meth_query(cohort, region, max.cpgs = 2000)
    theirs <- sesame::visualizeRegion("chr19", 10260000, 10380000, betas, platform = "HM450", draw = FALSE)
    expect_identical(q$cpgs$probe.HM450, rownames(theirs))
    expect_equal(unname(q$betas), unname(theirs))

    gene <- .meth_gene_region(cohort, "DNMT1")
    q <- .meth_query(cohort, gene)
    theirs <- sesame::visualizeGene("DNMT1", betas, platform = "HM450", draw = FALSE)
    expect_identical(q$cpgs$probe.HM450, rownames(theirs))
    expect_equal(unname(q$betas), unname(theirs))
})
