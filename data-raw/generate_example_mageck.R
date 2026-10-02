# Generate the example MAGeCK RRA gene summary shipped with sciVizModules.
#
# A simulated pooled CRISPR knockout screen summarised the way `mageck test`
# writes `<prefix>.gene_summary.txt`, for read_mageck() and the
# crisprScreenRank module: 2,000 genes with 4 sgRNAs each, about 5% depleted
# (essential-like) and 1% enriched (resistance-like) hits, and null genes in
# between. Gene symbols are borrowed for readability, but every value is
# simulated; this is not the output of a real screen.

set.seed(20261001)

depleted <- c(
    "RPL3", "RPL4", "RPL7", "RPL11", "RPS3", "RPS6", "RPS11", "RPS19", "POLR2A", "POLR2B", "PCNA",
    "PSMA1", "PSMA3", "PSMB2", "PSMB5", "PSMC1", "PSMD1", "SF3B1", "SF3A1", "SNRPD1", "SNRPE", "EEF2",
    "EIF3A", "EIF2S1", "CDK1", "PLK1", "AURKB", "KIF11", "RRM1", "RRM2", "MCM2", "MCM3", "MCM7", "TOP2A",
    "RAN", "XPO1", "NUP93", "KPNB1", "CCT2", "CCT4", "HSPA9", "VCP", "DDX18", "NOP56", "FBL", "GINS2",
    "RPA1", "RPA2", "POLA1", "PRIM1", "SUPT5H", "CDC20", "ANAPC4", "BUB3", "SMC1A", "SMC3", "RAD21",
    "NCAPD2", "ESPL1", "CHEK1", "WEE1", "ATR", "DHODH", "UMPS", "CAD", "TYMS", "GART", "PAICS", "ATIC",
    "PPAT", "HCFC1", "MYC", "MAX", "YY1", "TAF1", "TBP", "GTF2B", "ERCC3", "CDK7", "CCNH", "CDK9",
    "BRD4", "MED12", "MED14", "NAA10", "SRSF1", "SRSF2", "HNRNPC", "U2AF1", "U2AF2", "PRPF8", "PRPF19",
    "SNRNP200", "EFTUD2", "DHX15", "LSM2", "ZNF207", "WDR5"
)
enriched <- c("NF1", "NF2", "PTEN", "TSC1", "TSC2", "KEAP1", "CUL3", "TP53", "CDKN2A", "STK11",
    "NPRL2", "DEPDC5", "MED12L", "KMT2D", "ARID1A", "TADA2B", "CIC", "SMARCB1", "RB1", "FBXW7")
n_null <- 2000 - length(depleted) - length(enriched)
genes <- c(depleted, enriched, sprintf("GENE%04d", seq_len(n_null)))
type <- rep(c("depleted", "enriched", "null"), c(length(depleted), length(enriched), n_null))

lfc <- ifelse(type == "depleted", stats::rnorm(length(type), -2.4, 0.7),
    ifelse(type == "enriched", stats::rnorm(length(type), 1.8, 0.5), stats::rnorm(length(type), 0, 0.35)))

# One-sided p-values: small in the direction of the effect, near-uniform otherwise.
side_p <- function(hit) {
    ifelse(hit, 10^-stats::runif(length(hit), 3.5, 7), stats::runif(length(hit)))
}
neg_p <- side_p(type == "depleted")
neg_p[type == "enriched"] <- stats::runif(sum(type == "enriched"), 0.9, 1)
pos_p <- side_p(type == "enriched")
pos_p[type == "depleted"] <- stats::runif(sum(type == "depleted"), 0.9, 1)

# The RRA score sits a little below the permutation p-value it is tested by.
neg_score <- neg_p * stats::runif(length(neg_p), 0.3, 1)
pos_score <- pos_p * stats::runif(length(pos_p), 0.3, 1)
good <- function(hit) ifelse(hit, sample(3:4, length(hit), TRUE), sample(0:2, length(hit), TRUE))

summary <- data.frame(
    id = genes,
    num = 4L,
    `neg|score` = signif(neg_score, 4),
    `neg|p-value` = signif(neg_p, 4),
    `neg|fdr` = signif(stats::p.adjust(neg_p, "BH"), 4),
    `neg|rank` = rank(neg_score, ties.method = "first"),
    `neg|goodsgrna` = good(type == "depleted"),
    `neg|lfc` = round(lfc, 5),
    `pos|score` = signif(pos_score, 4),
    `pos|p-value` = signif(pos_p, 4),
    `pos|fdr` = signif(stats::p.adjust(pos_p, "BH"), 4),
    `pos|rank` = rank(pos_score, ties.method = "first"),
    `pos|goodsgrna` = good(type == "enriched"),
    `pos|lfc` = round(lfc, 5),
    check.names = FALSE
)
summary <- summary[order(summary$`neg|rank`), ]

dir.create("inst/extdata", showWarnings = FALSE, recursive = TRUE)
out <- gzfile("inst/extdata/example_mageck.gene_summary.txt.gz", "w")
utils::write.table(summary, out, sep = "\t", quote = FALSE, row.names = FALSE)
close(out)
