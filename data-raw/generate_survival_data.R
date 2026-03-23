## code to prepare example survival data for the sciVizModules package
## Run this script to regenerate data/km_survival_single.rda and
## data/km_survival_groups.rda.

# ---- Single-group Kaplan-Meier data ----------------------------------------
# Data matches the example table shown in the problem description

km_survival_single <- data.frame(
    time    = c(0, 100, 200, 300, 400, 500, 600, 700, 800, 900, 1000),
    n.risk  = c(138, 114, 78, 49, 31, 20, 13, 8, 6, 2, 2),
    n.event = c(0, 24, 30, 20, 15, 7, 7, 5, 2, 2, 0),
    survival = c(1.0000, 0.8261, 0.6073, 0.4411, 0.2977,
                 0.2232, 0.1451, 0.0893, 0.0670, 0.0357, 0.0357),
    std.err  = c(0.0000, 0.0323, 0.0417, 0.0439, 0.0425,
                 0.0402, 0.0353, 0.0293, 0.0259, 0.0216, 0.0216),
    lower    = c(1.0000, 0.7652, 0.5309, 0.3629, 0.2250,
                 0.1569, 0.0900, 0.0470, 0.0314, 0.0109, 0.0109),
    upper    = c(1.000,  0.892,  0.695,  0.536,  0.394,
                 0.318,  0.234,  0.170,  0.143,  0.117,  0.117)
)

usethis::use_data(km_survival_single, overwrite = TRUE)


# ---- Two-group Kaplan-Meier data -------------------------------------------
# Simulated low-risk vs. high-risk groups demonstrating grouped survival curves

group1 <- data.frame(
    time     = c(0, 10, 20, 30, 40, 50, 60, 70),
    n.risk   = c(112, 95, 90, 85, 79, 56, 53, 50),
    n.event  = c(0, 17, 5, 5, 6, 23, 3, 3),
    survival = c(1.000, 0.848, 0.804, 0.759, 0.716, 0.634, 0.616, 0.499),
    std.err  = c(0.000, 0.034, 0.037, 0.040, 0.043, 0.046, 0.046, 0.047),
    lower    = c(1.000, 0.782, 0.734, 0.683, 0.635, 0.546, 0.529, 0.412),
    upper    = c(1.000, 0.919, 0.882, 0.843, 0.808, 0.733, 0.715, 0.603),
    group    = rep("Group 1 (low risk)", 8)
)

group2 <- data.frame(
    time     = c(0, 10, 20, 30, 40, 50, 60, 70),
    n.risk   = c(103, 80, 63, 50, 23, 10, 7, 6),
    n.event  = c(0, 23, 17, 13, 27, 13, 3, 1),
    survival = c(1.000, 0.777, 0.612, 0.483, 0.196, 0.078, 0.039, 0.013),
    std.err  = c(0.000, 0.041, 0.048, 0.049, 0.039, 0.027, 0.019, 0.011),
    lower    = c(1.000, 0.699, 0.519, 0.392, 0.127, 0.037, 0.012, 0.002),
    upper    = c(1.000, 0.863, 0.720, 0.592, 0.300, 0.162, 0.125, 0.104),
    group    = rep("Group 2 (high risk)", 8)
)

km_survival_groups <- rbind(group1, group2)
rownames(km_survival_groups) <- NULL

usethis::use_data(km_survival_groups, overwrite = TRUE)
