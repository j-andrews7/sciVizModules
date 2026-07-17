# Generate a small, realistic clusterProfiler-style enrichment result to serve
# as ready-to-use example data for the enrichmentDotPlot module.
#
# The data mimic the output of a `clusterProfiler::compareCluster()` GO
# over-representation analysis: several enrichment terms tested across a couple
# of gene clusters. No real biological analysis is performed; values are
# hand-picked so the module has sensible, self-contained example data.

set.seed(42)

terms <- data.frame(
    ID = c(
        "GO:0006955", "GO:0002250", "GO:0045087", "GO:0006954",
        "GO:0002376", "GO:0050900", "GO:0071345", "GO:0019221",
        "GO:0034097", "GO:0032496"
    ),
    Description = c(
        "immune response",
        "adaptive immune response",
        "innate immune response",
        "inflammatory response",
        "immune system process",
        "leukocyte migration",
        "cellular response to cytokine stimulus",
        "cytokine-mediated signaling pathway",
        "response to cytokine",
        "response to lipopolysaccharide"
    ),
    stringsAsFactors = FALSE
)

clusters <- c("Upregulated", "Downregulated")

rows <- list()
for (cl in clusters) {
    n_terms <- if (cl == "Upregulated") 8 else 6
    idx <- sort(sample(seq_len(nrow(terms)), n_terms))
    set_size <- if (cl == "Upregulated") 210 else 150
    counts <- sample(6:35, n_terms, replace = TRUE)
    bg <- sample(80:400, n_terms, replace = TRUE)
    pvalue <- sort(10^(-runif(n_terms, 2, 9)))
    padj <- p.adjust(pvalue, method = "BH")
    rows[[cl]] <- data.frame(
        Cluster = cl,
        ONTOLOGY = "BP",
        ID = terms$ID[idx],
        Description = terms$Description[idx],
        GeneRatio = paste0(counts, "/", set_size),
        BgRatio = paste0(bg, "/", 18000),
        pvalue = pvalue,
        p.adjust = padj,
        qvalue = padj * 0.9,
        Count = counts,
        stringsAsFactors = FALSE
    )
}

example_enrichment <- do.call(rbind, rows)
rownames(example_enrichment) <- NULL

save(example_enrichment, file = "data/example_enrichment.rda", compress = "xz")
