# Generate the example `example_biomarkers` dataset shipped with sciVizModules.
#
# Simulated diagnostic study for the rocCurve module: 300 patients, a binary
# disease outcome, and three serum markers that separate the groups strongly,
# moderately and weakly, plus age and sex. No real patients are involved.

set.seed(20261001)

n <- 300
disease <- factor(ifelse(stats::runif(n) < 0.4, "Disease", "Healthy"), levels = c("Healthy", "Disease"))
case <- disease == "Disease"

example_biomarkers <- data.frame(
    id = sprintf("P%03d", seq_len(n)),
    disease = disease,
    marker_strong = round(stats::rlnorm(n, meanlog = ifelse(case, 2.6, 1.6), sdlog = 0.45), 2),
    marker_moderate = round(stats::rnorm(n, mean = ifelse(case, 58, 50), sd = 9), 1),
    marker_weak = round(stats::rnorm(n, mean = ifelse(case, 1.15, 1.0), sd = 0.45), 2),
    age = round(stats::rnorm(n, mean = ifelse(case, 61, 55), sd = 11)),
    sex = factor(sample(c("Female", "Male"), n, replace = TRUE)),
    stringsAsFactors = FALSE
)

save(example_biomarkers, file = "data/example_biomarkers.rda", compress = "xz")
