# Generate a small, self-contained tidy (long) mutation table to serve as
# ready-to-use example data for the oncoPlot module.
#
# Each row is one observed alteration in one sample. No real patient data are
# used; sample/gene/alteration assignments are simulated so the module has
# sensible, self-contained example data resembling a cancer mutation cohort.

set.seed(7412)

genes <- c(
    "TP53", "PIK3CA", "PTEN", "KRAS", "EGFR", "BRAF",
    "APC", "RB1", "NF1", "CDKN2A", "MYC", "ARID1A"
)
samples <- sprintf("S%02d", seq_len(30))
alterations <- c("MUT", "AMP", "HOMDEL")

# Per-gene base alteration frequency (so some genes are recurrently altered).
gene_freq <- stats::setNames(
    seq(0.55, 0.08, length.out = length(genes)),
    genes
)
# Per-gene preferred alteration type mix.
alt_weights <- list(
    default = c(MUT = 0.7, AMP = 0.15, HOMDEL = 0.15),
    MYC = c(MUT = 0.1, AMP = 0.8, HOMDEL = 0.1),
    EGFR = c(MUT = 0.4, AMP = 0.55, HOMDEL = 0.05),
    CDKN2A = c(MUT = 0.1, AMP = 0.05, HOMDEL = 0.85),
    PTEN = c(MUT = 0.5, AMP = 0.05, HOMDEL = 0.45)
)

rows <- list()
for (g in genes) {
    w <- if (!is.null(alt_weights[[g]])) alt_weights[[g]] else alt_weights$default
    for (s in samples) {
        if (stats::runif(1) < gene_freq[[g]]) {
            n_alt <- sample(c(1L, 2L), 1, prob = c(0.9, 0.1))
            chosen <- sample(alterations, n_alt, replace = FALSE, prob = w[alterations])
            for (a in chosen) {
                rows[[length(rows) + 1]] <- data.frame(
                    sample = s, gene = g, alteration = a,
                    stringsAsFactors = FALSE
                )
            }
        }
    }
}

example_mutations <- do.call(rbind, rows)
example_mutations <- example_mutations[
    order(example_mutations$sample, example_mutations$gene),
    ,
    drop = FALSE
]
rownames(example_mutations) <- NULL

# Per-sample clinical attributes (constant within a sample) so top/bottom
# annotation tracks have something to display: a categorical stage and sex, and
# a numeric tumour mutational burden.
sample_stage <- stats::setNames(
    sample(c("I", "II", "III", "IV"), length(samples), replace = TRUE,
        prob = c(0.3, 0.3, 0.25, 0.15)),
    samples
)
sample_sex <- stats::setNames(
    sample(c("Female", "Male"), length(samples), replace = TRUE),
    samples
)
sample_tmb <- stats::setNames(
    round(stats::rgamma(length(samples), shape = 2, scale = 3), 1),
    samples
)

# Per-gene attributes (constant within a gene) so left/right annotation tracks
# have something to display: a categorical pathway and a numeric mean expression.
gene_pathway <- stats::setNames(
    c(
        TP53 = "Cell cycle", PIK3CA = "PI3K", PTEN = "PI3K", KRAS = "RTK-RAS",
        EGFR = "RTK-RAS", BRAF = "RTK-RAS", APC = "WNT", RB1 = "Cell cycle",
        NF1 = "RTK-RAS", CDKN2A = "Cell cycle", MYC = "MYC", ARID1A = "Chromatin"
    )[genes],
    genes
)
gene_expression <- stats::setNames(
    round(stats::rnorm(length(genes), mean = 8, sd = 2), 2),
    genes
)

example_mutations$stage <- unname(sample_stage[example_mutations$sample])
example_mutations$sex <- unname(sample_sex[example_mutations$sample])
example_mutations$tmb <- unname(sample_tmb[example_mutations$sample])
example_mutations$pathway <- unname(gene_pathway[example_mutations$gene])
example_mutations$expression <- unname(gene_expression[example_mutations$gene])

usethis::use_data(example_mutations, overwrite = TRUE)
