# Generate the example `example_gsea` dataset shipped with sciVizModules.
#
# A GSEA input bundle for the gseaEnrichmentPlot module, built from the example
# data of the fgsea package (MIT licence; Korotkevich et al., bioRxiv 2016,
# doi:10.1101/060012): `exampleRanks`, gene-level statistics for an mouse
# immune-cell experiment, and the Reactome pathways in `examplePathways`. The
# 40 pathways fgsea ranks most significant are kept, with their fgsea results.

library(fgsea)

data("exampleRanks", package = "fgsea")
data("examplePathways", package = "fgsea")

set.seed(42)
res <- fgsea(examplePathways, exampleRanks, minSize = 15, maxSize = 500)
res <- res[order(res$padj, -abs(res$NES)), ]
top <- head(res, 40)

results <- as.data.frame(top)
results$leadingEdge <- I(lapply(results$leadingEdge, as.character))

example_gsea <- list(
    stats = exampleRanks,
    pathways = examplePathways[top$pathway],
    results = results
)

save(example_gsea, file = "data/example_gsea.rda", compress = "xz")
