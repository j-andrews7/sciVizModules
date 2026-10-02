# Generate the example `example_plate` dataset shipped with sciVizModules.
#
# Simulated luminescence screen for the plateHeatmap module: two 384-well
# plates with 16 negative (DMSO) control wells in column 2 and 16 positive
# (fully inhibited) control wells in column 23, an evaporation edge effect that
# is strong on the first plate and mild on the second, and a handful of hits.
# No real compounds are involved.

set.seed(20261002)

one_plate <- function(name, edge_outer, edge_inner, n_hits, offset) {
    grid <- expand.grid(col = 1:24, row = 1:16)
    type <- ifelse(grid$col == 2, "negative", ifelse(grid$col == 23, "positive", "sample"))
    signal <- ifelse(type == "positive", stats::rnorm(nrow(grid), 1500, 180), stats::rnorm(nrow(grid), 10000, 550))
    ring <- pmin(grid$row - 1, 16 - grid$row, grid$col - 1, 24 - grid$col)
    signal <- signal * ifelse(ring == 0, edge_outer, ifelse(ring == 1, edge_inner, 1))
    hits <- sample(which(type == "sample" & ring > 0), n_hits)
    signal[hits] <- stats::runif(n_hits, 1500, 5500)
    compound <- ifelse(type == "negative", "DMSO", ifelse(type == "positive", "Staurosporine", ""))
    compound[type == "sample"] <- sprintf("CMP-%04d", offset + seq_len(sum(type == "sample")))
    data.frame(
        plate = name,
        well = sprintf("%s%02d", LETTERS[grid$row], grid$col),
        type = type,
        compound = compound,
        signal = round(signal),
        stringsAsFactors = FALSE
    )
}

example_plate <- rbind(
    one_plate("Plate_01", edge_outer = 0.82, edge_inner = 0.94, n_hits = 8, offset = 0),
    one_plate("Plate_02", edge_outer = 0.95, edge_inner = 0.99, n_hits = 6, offset = 352)
)

save(example_plate, file = "data/example_plate.rda", compress = "xz")
