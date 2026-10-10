# Generate the example `example_gwas` dataset shipped with sciVizModules.
#
# Simulated GWAS summary statistics for the manhattanPlot and gwasQQPlot
# modules: 15,000 variants across the 22 autosomes (spread in proportion to
# chromosome length), null p-values everywhere except a genome-wide significant
# locus on chromosome 3, a weaker one on chromosome 11, and a suggestive one on
# chromosome 7. The columns follow qqman's naming (SNP, CHR, BP, P). No real
# genotypes or individuals are involved.

set.seed(20261001)

# GRCh38 autosome lengths in Mb.
lengths <- c(
    248.96, 242.19, 198.30, 190.21, 181.54, 170.81, 159.35, 145.14, 138.39, 133.80, 135.09,
    133.28, 114.36, 107.04, 101.99, 90.34, 83.26, 80.37, 58.62, 64.44, 46.71, 50.82
)
n_total <- 15000
n_chr <- round(n_total * lengths / sum(lengths))

example_gwas <- do.call(rbind, lapply(seq_along(lengths), function(chr) {
    bp <- sort(sample.int(floor(lengths[chr] * 1e6), n_chr[chr]))
    data.frame(CHR = chr, BP = bp, P = stats::runif(n_chr[chr]))
}))

# An association peak: p-values falling off with distance from the lead variant.
add_peak <- function(df, chr, centre_mb, min_log10p, width_mb = 0.6, n = 40) {
    centre <- centre_mb * 1e6
    bp <- sort(round(centre + stats::runif(n, -width_mb, width_mb) * 1e6))
    strength <- exp(-abs(bp - centre) / (width_mb * 1e6 / 3))
    p <- 10^-(min_log10p * strength + stats::runif(n, 0, 0.5))
    rbind(df, data.frame(CHR = chr, BP = bp, P = pmin(p, 1)))
}
example_gwas <- add_peak(example_gwas, chr = 3, centre_mb = 62.5, min_log10p = 12)
example_gwas <- add_peak(example_gwas, chr = 11, centre_mb = 101.4, min_log10p = 9)
example_gwas <- add_peak(example_gwas, chr = 7, centre_mb = 44.2, min_log10p = 6, n = 20)

example_gwas <- example_gwas[order(example_gwas$CHR, example_gwas$BP), ]
example_gwas$P <- signif(example_gwas$P, 3)
example_gwas$SNP <- sprintf("rs%d", seq_len(nrow(example_gwas)) + 100000)
example_gwas <- example_gwas[, c("SNP", "CHR", "BP", "P")]
rownames(example_gwas) <- NULL

save(example_gwas, file = "data/example_gwas.rda", compress = "xz")
