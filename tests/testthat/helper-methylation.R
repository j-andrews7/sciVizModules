# A small cohort built to hold each case the join on position has to get right:
#
#   position   HM450   EPIC    EPICv2
#   100        cg1     cg1     cg1_TC21, cg1_TC22   replicates on EPICv2
#   200        cg2     -       -
#   250        -       cg2     -                    one ID at two positions
#   300        cg3     cg9     -                    two IDs at one position
#   400        -       cg4     cg4_BC21
#   500        -       -       cg5_TC21
meth_ranges <- function(ids, pos, chr = "chr1") {
    ranges <- GenomicRanges::GRanges(chr, IRanges::IRanges(pos, width = 2))
    names(ranges) <- ids
    ranges
}

meth_probes <- function() {
    list(
        HM450 = meth_ranges(c("cg1", "cg2", "cg3"), c(100, 200, 300)),
        EPIC = meth_ranges(c("cg1", "cg2", "cg9", "cg4"), c(100, 250, 300, 400)),
        EPICv2 = meth_ranges(c("cg1_TC21", "cg1_TC22", "cg4_BC21", "cg5_TC21"), c(100, 100, 400, 500))
    )
}

meth_betas <- function() {
    probes <- meth_probes()
    arrays <- list(
        HM450 = matrix(c(0.1, 0.2, 0.3, 0.4, 0.5, 0.6), 3, 2),
        EPIC = matrix(c(0.11, 0.21, 0.31, 0.41, 0.12, 0.22, 0.32, 0.42), 4, 2),
        EPICv2 = matrix(c(0.2, 0.4, 0.7, 0.8, 0.3, NA, 0.6, 0.9), 4, 2)
    )
    names <- list(HM450 = c("H1", "H2"), EPIC = c("E1", "E2"), EPICv2 = c("V1", "V2"))
    lapply(stats::setNames(nm = names(arrays)), function(p) {
        dimnames(arrays[[p]]) <- list(names(probes[[p]]), names[[p]])
        arrays[[p]]
    })
}

meth_samples <- function() {
    data.frame(
        tissue = c("Blood", "Liver", "Blood", "Liver", "Blood", "Liver"),
        age = c(30, 40, 50, 60, 70, 80),
        row.names = c("H1", "H2", "E1", "E2", "V1", "V2")
    )
}

# Two genes that overlap, one with two transcripts, on opposite strands.
meth_txns <- function() {
    exons <- function(starts, ends, strand) {
        GenomicRanges::GRanges("chr1", IRanges::IRanges(starts, ends), strand = strand)
    }
    txns <- GenomicRanges::GRangesList(
        T1 = exons(c(120, 220), c(160, 280), "+"),
        T2 = exons(c(120, 240), c(150, 320), "+"),
        T3 = exons(c(260, 420), c(300, 470), "-")
    )
    S4Vectors::mcols(txns) <- S4Vectors::DataFrame(
        gene_name = c("GENEA", "GENEA", "GENEB"),
        transcript_type = c("protein_coding", "protein_coding", "lncRNA"),
        cdsStart = c(130, 130, NA),
        cdsEnd = c(250, 260, NA)
    )
    txns
}

meth_bands <- function() {
    data.frame(
        chrom = "chr1", chromStart = c(0, 300), chromEnd = c(300, 1000), name = c("p1", "q1"),
        gieStain = c("gneg", "acen")
    )
}

meth_cohort <- function(...) {
    methylationCohort(
        meth_betas(), samples = meth_samples(), probes = meth_probes(), txns = meth_txns(),
        cytobands = meth_bands(), ...
    )
}

meth_region <- function(start = 50, end = 550) {
    .meth_region("chr1", start, end)
}

# Beta values from sesameData, skipping where they cannot be had.
meth_sesame_betas <- function() {
    testthat::skip_on_cran()
    for (pkg in c("sesame", "sesameData", "pals", "wheatmap")) testthat::skip_if_not_installed(pkg)
    betas <- tryCatch(
        suppressMessages(sesameData::sesameDataGet("HM450.10.TCGA.PAAD.normal")),
        error = function(e) NULL
    )
    if (is.null(betas)) testthat::skip("sesameData's example betas are unavailable")
    betas
}
