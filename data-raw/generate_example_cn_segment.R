# Generate the example `example_cn_segment` and `example_cn_genes` datasets
# shipped with sciVizModules for the cnSegmentPlot module.
#
# `example_cn_segment` mimics the structure returned by
# sesame::cnSegmentation() (a "CNSegment" list of bin.coords/bin.signals/
# seg.signals/genomeInfo) but is entirely simulated - no real biological or
# array data are included. A handful of simulated gain/loss regions are baked
# into the per-bin signal and the called segment table so the example plot has
# something interesting to show. A tiny "chrM"-like chromosome is included to
# exercise the default (>1% of genome length) chromosome auto-selection logic
# in cnSegmentPlot().

library(GenomicRanges)

set.seed(42)

chrom.lens <- c(chr1 = 250000000, chr2 = 240000000, chr3 = 200000000, chrM = 16569)
tile.width <- 5000000

build_chrom_bins <- function(chrom, len, width) {
    starts <- seq(1, len, by = width)
    ends <- pmin(starts + width - 1, len)
    gr <- GRanges(seqnames = chrom, ranges = IRanges(start = starts, end = ends))
    names(gr) <- sprintf("%s-%03d", chrom, seq_along(gr))
    gr
}

bin.coords <- do.call(c, lapply(names(chrom.lens), function(chrom) {
    build_chrom_bins(chrom, chrom.lens[[chrom]], tile.width)
}))
seqlengths(bin.coords) <- chrom.lens[seqlevels(bin.coords)]
mcols(bin.coords)$probes <- sample(5:40, length(bin.coords), replace = TRUE)

# Simulated called segments: a few gain/loss regions per chromosome, with
# "normal" (mean ~ 0) segments filling the rest of each chromosome.
make_segments <- function(chrom, breaks, means) {
    data.frame(
        ID = "example_sample",
        chrom = chrom,
        loc.start = breaks[-length(breaks)],
        loc.end = breaks[-1] - 1,
        num.mark = 10,
        seg.mean = means,
        pval = 0.001,
        lcl = means - 0.05,
        ucl = means + 0.05,
        stringsAsFactors = FALSE
    )
}

seg.signals <- rbind(
    make_segments("chr1", c(1, 50e6, 90e6, 150e6, 170e6, chrom.lens[["chr1"]]), c(0, 0.5, 0, -0.6, 0)),
    make_segments("chr2", c(1, 20e6, 60e6, chrom.lens[["chr2"]]), c(0, 0.4, 0)),
    make_segments("chr3", c(1, 100e6, 140e6, chrom.lens[["chr3"]]), c(0, -0.5, 0)),
    make_segments("chrM", c(1, chrom.lens[["chrM"]]), c(0))
)
row.names(seg.signals) <- NULL

# Per-bin signal: the mean of whichever called segment the bin midpoint falls
# in, plus noise. A random ~10% of bins are dropped to simulate bins with no
# overlapping probes (as in real cnSegmentation() output).
segment_mean_at <- function(chrom, pos) {
    sub <- seg.signals[seg.signals$chrom == chrom, ]
    idx <- which(pos >= sub$loc.start & pos <= sub$loc.end)[1]
    if (is.na(idx)) 0 else sub$seg.mean[idx]
}

bin.mid <- (start(bin.coords) + end(bin.coords)) / 2
bin.chrom <- as.character(seqnames(bin.coords))
base.mean <- mapply(segment_mean_at, bin.chrom, bin.mid)
bin.signal.values <- base.mean + rnorm(length(bin.coords), sd = 0.08)
names(bin.signal.values) <- names(bin.coords)

keep.bin <- sample(c(TRUE, FALSE), length(bin.signal.values), replace = TRUE, prob = c(0.9, 0.1))
bin.signals <- bin.signal.values[keep.bin]

genomeInfo <- list(seqLength = chrom.lens, gapInfo = GRanges())

example_cn_segment <- structure(
    list(
        seg.signals = seg.signals,
        bin.coords = bin.coords,
        bin.signals = bin.signals,
        genomeInfo = genomeInfo
    ),
    class = "CNSegment"
)

# A handful of example genes overlapping the simulated gain/loss regions
# (and one straddling a segment boundary) to demonstrate gene labeling.
example_cn_genes <- GRanges(
    seqnames = c("chr1", "chr1", "chr1", "chr2", "chr2", "chr3"),
    ranges = IRanges(
        start = c(60e6, 95e6, 155e6, 30e6, 58e6, 110e6),
        width = c(2e6, 1e6, 3e6, 1.5e6, 4e6, 2.5e6)
    ),
    gene_name = c("GENEA", "GENEB", "GENEC", "GENED", "GENEE", "GENEF")
)

save(example_cn_segment, file = "data/example_cn_segment.rda", compress = "xz")
save(example_cn_genes, file = "data/example_cn_genes.rda", compress = "xz")
