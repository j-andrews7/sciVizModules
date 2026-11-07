# Build the example multi-array methylation cohort used by the methylationTrack
# module, its tests and the gallery: real beta values from the three arrays' example
# data in sesameData, limited to a few genes.
#
# It carries its own probe positions, transcripts and cytobands, so the gallery and
# the tests need no ExperimentHub. The arrays hold different samples, so differences
# between them are biology and platform together: this shows the module's structure,
# not a comparison of platforms.
#
# Run from the package root, with sesame and sesameData installed (openSesame() takes
# about 8 seconds per sample).

library(sesame)
library(sesameData)
library(GenomicRanges)
library(S4Vectors)
devtools::load_all(".")

sesameDataCache(c(
    "HM450.10.TCGA.PAAD.normal", "EPIC.5.SigDF.normal", "EPICv2.8.SigDF", "HM450.address", "EPIC.address",
    "EPICv2.address", "genomeInfo.hg38"
))

genes <- c("DNMT1", "ADA", "MLH1", "BRCA1", "TP53", "GNAS")
flank <- 5000

info <- sesameData_getGenomeInfo("hg38")
meta <- mcols(info$txns)
regions <- GRanges(unlist(lapply(genes, function(gene) {
    hit <- which(meta$gene_name == gene)
    as.character(GRanges(
        meta$chrm[hit][1],
        IRanges(min(meta$transcript_start[hit]) - flank, max(meta$transcript_end[hit]) + flank)
    ))
})))

# ---- Beta values ------------------------------------------------------------

hm450 <- sesameDataGet("HM450.10.TCGA.PAAD.normal")
epic <- openSesame(sesameDataGet("EPIC.5.SigDF.normal"))
epicv2 <- openSesame(sesameDataGet("EPICv2.8.SigDF"))
arrays <- list(HM450 = hm450, EPIC = epic, EPICv2 = epicv2)

# The whole array's mean, before it is limited to these genes.
global <- unlist(lapply(arrays, function(m) colMeans(m[grepl("^cg", rownames(m)), ], na.rm = TRUE)), use.names = FALSE)
names(global) <- unlist(lapply(arrays, colnames), use.names = FALSE)

manifests <- lapply(names(arrays), function(platform) {
    manifest <- sesameData_getManifestGRanges(platform, "hg38")
    manifest[overlapsAny(manifest, regions, ignore.strand = TRUE) & grepl("^c[gh]", names(manifest))]
})
names(manifests) <- names(arrays)

arrays <- lapply(names(arrays), function(platform) {
    m <- arrays[[platform]]
    round(m[intersect(names(manifests[[platform]]), rownames(m)), , drop = FALSE], 3)
})
names(arrays) <- names(manifests)

# ---- Samples ----------------------------------------------------------------

cell.type <- c(
    rep("Pancreas", ncol(arrays$HM450)),
    sub("\\..*$", "", colnames(arrays$EPIC)),
    sub("_.*$", "", colnames(arrays$EPICv2))
)
category <- c(
    Pancreas = "Normal tissue", PrEC = "Normal cells", NAF = "Normal cells", GM12878 = "Cell line",
    K562 = "Cell line", LNCaP = "Cell line", HCT116 = "Cell line"
)
samples <- data.frame(
    cell.type = factor(cell.type, levels = names(category)),
    category = factor(unname(category[cell.type]), levels = unique(category)),
    global.beta = round(global, 3),
    row.names = names(global)
)

# ---- Annotation -------------------------------------------------------------

spans <- GRanges(meta$chrm, IRanges(meta$transcript_start, meta$transcript_end))
txns <- info$txns[overlapsAny(spans, regions, ignore.strand = TRUE)]
cytobands <- info$cytoBand[info$cytoBand$chrom %in% as.character(seqnames(regions)), ]
rownames(cytobands) <- NULL

example_methylation <- methylationCohort(
    arrays, samples = samples, probes = manifests, genome = "hg38", txns = txns, cytobands = cytobands
)
print(example_methylation)

# Not usethis::use_data(), which would turn on LazyData, which this package leaves off.
save(example_methylation, file = "data/example_methylation.rda", compress = "xz")
