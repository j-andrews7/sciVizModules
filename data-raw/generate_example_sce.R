# Generate the example `example_sce` dataset shipped with sciVizModules.
#
# A small, self-contained simulated single-cell RNA-seq `SingleCellExperiment`
# used as the default example data for the dittoSeq-based modules
# (dittoDimPlot, dittoScatterPlot, dittoPlot, dittoBarPlot, dittoDimHex,
# dittoFreqPlot, dittoRidgeJitter). It provides:
#   - counts + logcounts assays for a handful of genes,
#   - PCA / TSNE / UMAP dimensionality reductions,
#   - discrete metadata (clustering, sample, condition, celltype),
#   - continuous metadata (nCount, percent.mito).
#
# Requires the Bioconductor package SingleCellExperiment.

library(SingleCellExperiment)

set.seed(42)

n_cells <- 240L
n_genes <- 40L

# ---- Discrete metadata --------------------------------------------------
clustering <- factor(sample(paste0("C", 1:4), n_cells, replace = TRUE))
celltype <- factor(c("T cell", "B cell", "Myeloid", "NK cell")[as.integer(clustering)])
condition <- factor(sample(c("Control", "Treated"), n_cells, replace = TRUE))
# Several samples nested within condition (needed for dittoFreqPlot).
sample_id <- factor(paste0(
    as.character(condition), "_S",
    sample(1:3, n_cells, replace = TRUE)
))

# ---- Expression counts --------------------------------------------------
gene_names <- paste0("Gene", seq_len(n_genes))
base_mean <- matrix(
    rgamma(n_genes * nlevels(clustering), shape = 2, scale = 20),
    nrow = n_genes
)
counts <- matrix(0L, nrow = n_genes, ncol = n_cells, dimnames = list(gene_names, NULL))
for (j in seq_len(n_cells)) {
    lambda <- base_mean[, as.integer(clustering[j])]
    counts[, j] <- rpois(n_genes, lambda)
}
logcounts <- log2(counts + 1)

# ---- Continuous metadata ------------------------------------------------
nCount <- colSums(counts)
percent.mito <- pmin(1, rbeta(n_cells, 1, 20))

# ---- Dimensionality reductions ------------------------------------------
# Give clusters distinct centers so embeddings look sensible.
centers <- matrix(rnorm(nlevels(clustering) * 2, sd = 6), ncol = 2)
umap <- centers[as.integer(clustering), ] + matrix(rnorm(n_cells * 2), ncol = 2)
tsne <- centers[as.integer(clustering), ] * 1.5 + matrix(rnorm(n_cells * 2, sd = 1.2), ncol = 2)
pca <- prcomp(t(logcounts))$x[, 1:5]

colnames(umap) <- c("UMAP_1", "UMAP_2")
colnames(tsne) <- c("TSNE_1", "TSNE_2")

cell_names <- paste0("Cell", seq_len(n_cells))
colnames(counts) <- colnames(logcounts) <- cell_names
rownames(umap) <- rownames(tsne) <- rownames(pca) <- cell_names

example_sce <- SingleCellExperiment(
    assays = list(counts = counts, logcounts = logcounts),
    colData = DataFrame(
        clustering = clustering,
        celltype = celltype,
        condition = condition,
        sample = sample_id,
        nCount = nCount,
        percent.mito = percent.mito,
        row.names = cell_names
    ),
    reducedDims = list(PCA = pca, TSNE = tsne, UMAP = umap)
)

save(example_sce, file = "data/example_sce.rda", compress = "xz")
