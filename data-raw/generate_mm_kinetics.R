# Generate a small, self-contained Michaelis-Menten enzyme-kinetics example for
# the michaelisMenten module. Three objects are produced:
#   * mm_kinetics      - observed substrate concentration (S) vs velocity (v)
#   * mm_kinetics_fit  - an nls() fit of v ~ Vm * S / (K + S) (the "stats")
#   * mm_kinetics_line - the fitted curve predicted over a fine S grid (the
#                        "model" / mml passed to michaelisMentenPlot())
#
# No real biological data are included; the velocities are hand-picked so the
# module has sensible, ready-to-use example data.

mm_kinetics <- structure(
    list(
        S = c(
            3.6, 1.8, 0.9, 0.45, 0.225, 0.1125, 3.6, 1.8, 0.9, 0.45, 0.225,
            0.1125, 3.6, 1.8, 0.9, 0.45, 0.225, 0.1125, 0
        ),
        v = c(
            0.004407692, 0.004192308, 0.003553846, 0.002576923, 0.001661538,
            0.001064286, 0.004835714, 0.004671429, 0.0039, 0.002857143,
            0.00175, 0.001057143, 0.004907143, 0.004521429, 0.00375,
            0.002764286, 0.001857143, 0.001121429, 0
        )
    ),
    .Names = c("S", "v"),
    class = "data.frame",
    row.names = c(NA, -19L)
)

# nls fit; coefficients K and Vm are used for the K / Vmax annotations.
mm_kinetics_fit <- nls(
    v ~ Vm * S / (K + S),
    data = mm_kinetics,
    start = list(K = max(mm_kinetics$v) / 2, Vm = max(mm_kinetics$v))
)

# Fitted line predicted over a fine grid, sharing the S / v column names.
mm_kinetics_line <- data.frame(
    S = seq(min(mm_kinetics$S), max(mm_kinetics$S), length.out = 100)
)
mm_kinetics_line$v <- predict(mm_kinetics_fit, newdata = mm_kinetics_line)

save(mm_kinetics, file = "data/mm_kinetics.rda", compress = "xz")
save(mm_kinetics_line, file = "data/mm_kinetics_line.rda", compress = "xz")
save(mm_kinetics_fit, file = "data/mm_kinetics_fit.rda", compress = "xz")
