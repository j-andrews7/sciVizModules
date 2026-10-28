# Generate the example `example_sbs96` dataset shipped with sciVizModules.
#
# A simulated 96-channel single-base-substitution count matrix for six tumours,
# used by the mutationalProfile module. Each tumour mixes three synthetic
# processes in different proportions, shaped after familiar ones but not copied
# from any published signature catalogue:
#
#   * "ageing-like"  - C>T at CpG (NpCpG contexts)
#   * "APOBEC-like"  - C>T and C>G in a TpCpW context
#   * "smoking-like" - broad C>A
#
# plus a flat background. The channels are named and ordered as MutationalPatterns
# and maftools name them (e.g. "A[C>A]A").

set.seed(96)

classes <- c("C>A", "C>G", "C>T", "T>A", "T>C", "T>G")
bases <- c("A", "C", "G", "T")
context <- unlist(lapply(classes, function(cl) {
    unlist(lapply(bases, function(five) paste0(five, "[", cl, "]", bases)))
}))
class <- sub("^.\\[(.>.)\\].$", "\\1", context)
five <- substr(context, 1, 1)
three <- substr(context, 7, 7)

normalise <- function(x) x / sum(x)
ageing <- normalise(ifelse(class == "C>T" & three == "G", 30, 0.4) + stats::runif(96, 0, 0.2))
apobec <- normalise(ifelse(class %in% c("C>T", "C>G") & five == "T" & three %in% c("A", "T"), 25, 0.3) +
    stats::runif(96, 0, 0.2))
smoking <- normalise(ifelse(class == "C>A", 6 + stats::runif(96, 0, 4), 0.6) + stats::runif(96, 0, 0.2))
flat <- rep(1 / 96, 96)

exposures <- rbind(
    Tumour_1 = c(0.70, 0.05, 0.05, 0.20),
    Tumour_2 = c(0.55, 0.30, 0.00, 0.15),
    Tumour_3 = c(0.15, 0.70, 0.00, 0.15),
    Tumour_4 = c(0.20, 0.05, 0.60, 0.15),
    Tumour_5 = c(0.10, 0.10, 0.65, 0.15),
    Tumour_6 = c(0.40, 0.25, 0.20, 0.15)
)
burden <- c(Tumour_1 = 450, Tumour_2 = 820, Tumour_3 = 1600, Tumour_4 = 2400, Tumour_5 = 3100, Tumour_6 = 1200)
profiles <- cbind(ageing, apobec, smoking, flat)

counts <- vapply(rownames(exposures), function(s) {
    p <- as.vector(profiles %*% exposures[s, ])
    as.integer(stats::rmultinom(1, burden[[s]], p))
}, integer(96))

example_sbs96 <- data.frame(context = context, counts, stringsAsFactors = FALSE, check.names = FALSE)

save(example_sbs96, file = "data/example_sbs96.rda", compress = "xz")
