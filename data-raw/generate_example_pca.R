# Generate the example `example_pca` dataset shipped with sciVizModules.
#
# A PCAtools `pca` object for the airway RNA-seq experiment (8 samples: 4 cell
# lines, dexamethasone-treated or not), used by the pcaBiplot, pcaScreePlot,
# pcaLoadingsPlot, pcaPairsPlot and pcaEigencorPlot modules. The object is a
# plain list, so it loads without PCAtools installed.

library(airway)
library(DESeq2)
library(PCAtools)

data("airway")
airway$dex <- relevel(airway$dex, ref = "untrt")

dds <- DESeqDataSet(airway, design = ~ cell + dex)
dds <- estimateSizeFactors(dds)
vsd <- assay(vst(dds, blind = TRUE))

# The 500 most variable genes, named by symbol where one is available.
top <- head(order(matrixStats::rowVars(vsd), decreasing = TRUE), 500)
mat <- vsd[top, ]
symbols <- rowData(airway)$symbol[match(rownames(mat), rownames(airway))]
rownames(mat) <- make.unique(ifelse(is.na(symbols) | symbols == "", rownames(mat), symbols))

metadata <- data.frame(
    dex = droplevels(airway$dex),
    cell = droplevels(airway$cell),
    avgLength = airway$avgLength,
    lib.size = colSums(assay(airway)),
    size.factor = unname(sizeFactors(dds)),
    row.names = colnames(airway)
)

example_pca <- pca(mat, metadata = metadata)

save(example_pca, file = "data/example_pca.rda", compress = "xz")
