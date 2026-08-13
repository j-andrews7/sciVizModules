# Generate the self-contained `example_cn_segment` object for the cnSegmentPlot
# module.
#
# The EPIC signal and normal-reference objects are distributed through
# sesameData. The resulting `CNSegment` object is made self-contained so the
# module can be driven by this single object:
#   * `genomeInfo` carries the platform `cytoBand` (a data frame with `chrom`,
#     `chromStart`, `chromEnd`, `name`, and `gieStain` columns). Centromere
#     guide positions are derived from the `"acen"` bands (end of the p-arm).
#   * `genomeInfo$genes` holds a controlled gene-level `GRanges` used for the
#     draggable gene labels. Any `GRanges` with a symbol column works; here we
#     use sesameData's hg38 transcript annotation merged to gene level.
#   * `bin.coords$genes` is a `CharacterList` of the gene symbols overlapping
#     each bin (rendered one-per-line in the module hover text) and
#     `bin.coords$signal` holds the per-bin log2 signal ratio.

library(GenomicRanges)
library(sesame)
library(sesameData)
library(usethis)

set.seed(42)

sdf <- sesameDataGet("EPIC.1.SigDF")
sdfs.normal <- sesameDataGet("EPIC.5.SigDF.normal")
example_cn_segment <- cnSegmentation(sdf, sdfs.normal)

# cnSegmentation() attaches the platform `genomeInfo`, which already carries the
# `cytoBand` data frame used for centromere placement. Gene annotations are
# added below so the whole module is driven by this single object.

# Controlled gene annotation used for labels and per-bin gene overlaps.
genes <- sesameData_getTxnGRanges("hg38", merge2gene = TRUE)
genes <- genes[genes$gene_type == "protein_coding",]
example_cn_segment$genomeInfo$genes <- genes

# Per-bin log2 signal ratio.
bin.coords <- example_cn_segment$bin.coords
bin.signals <- example_cn_segment$bin.signals
bin.coords$signal <- bin.signals[match(names(bin.coords), names(bin.signals))]

# Per-bin overlapping gene symbols, stored as a CharacterList so the module can
# render each gene on its own line in the hover text.
hits <- findOverlaps(genes, bin.coords)
gene.names <- as.character(mcols(genes)$gene_name[queryHits(hits)])
genes.by.bin <- splitAsList(gene.names, factor(subjectHits(hits), levels = seq_along(bin.coords)))
bin.coords$genes <- sort(unique(genes.by.bin))

example_cn_segment$bin.coords <- bin.coords

usethis::use_data(example_cn_segment, overwrite = TRUE)