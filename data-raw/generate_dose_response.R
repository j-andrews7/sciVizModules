# Generate a small, self-contained dose-response example for the doseResponse
# module: a serial dilution of doses with triplicate percent-response readings
# plus per-dose mean and standard deviation. No real biological data; values
# are hand-picked to follow a smooth sigmoidal (log-logistic) dose-response.

dose_response <- structure(
    list(
        dose_uM = c(0.1, 0.3, 1, 3, 10, 30, 100, 300, 1000),
        rep1_response_pct = c(99, 98, 95, 89, 80, 65, 48, 28, 12),
        rep2_response_pct = c(100, 97, 94, 91, 78, 68, 51, 31, 14),
        rep3_response_pct = c(98, 99, 96, 88, 81, 63, 47, 26, 11)
    ),
    class = "data.frame",
    row.names = c(NA, -9L)
)

reps <- dose_response[, c("rep1_response_pct", "rep2_response_pct", "rep3_response_pct")]
dose_response$mean_response_pct <- round(rowMeans(reps), 2)
dose_response$sd_response_pct <- round(apply(reps, 1, stats::sd), 2)

save(dose_response, file = "data/dose_response.rda", compress = "xz")
