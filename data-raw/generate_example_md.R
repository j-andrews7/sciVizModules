# Generate the example molecular-dynamics analysis files shipped with sciVizModules.
#
# Simulated GROMACS `.xvg` outputs for read_xvg() and the mdTrajectoryMetrics
# module, written with the headers `gmx rms`, `gmx gyrate` and `gmx rmsf` use:
# backbone RMSD for three 100 ns replicas (time in ps), the radius of gyration
# of one replica, and per-residue C-alpha RMSF over the p53 DNA-binding domain
# (residues 94-312). The values are simulated; no simulation was run.

set.seed(20261001)

write_xvg <- function(path, header, data) {
    out <- gzfile(path, "w")
    writeLines(header, out)
    utils::write.table(format(data, digits = 6, scientific = FALSE), out, sep = "    ",
        quote = FALSE, row.names = FALSE, col.names = FALSE)
    close(out)
}

time <- seq(0, 100000, by = 100) # ps, 1001 frames
plateau <- c(0.24, 0.28, 0.22)
for (rep in 1:3) {
    rmsd <- plateau[rep] * (1 - exp(-time / 6000)) + stats::arima.sim(list(ar = 0.95), length(time), sd = 0.004)
    rmsd <- pmax(rmsd - rmsd[1], 0)
    write_xvg(
        sprintf("inst/extdata/example_rmsd_rep%d.xvg.gz", rep),
        c(
            "# This file was created by gmx rms (simulated example for sciVizModules)",
            "@    title \"RMSD\"",
            "@    xaxis  label \"Time (ps)\"",
            "@    yaxis  label \"RMSD (nm)\"",
            "@TYPE xy",
            "@ subtitle \"Backbone after lsq fit to Backbone\""
        ),
        data.frame(time, round(rmsd, 5))
    )
}

rg <- 1.62 + 0.03 * exp(-time / 8000) + stats::arima.sim(list(ar = 0.9), length(time), sd = 0.002)
axes <- cbind(rg * 0.78, rg * 0.66, rg * 0.55) + matrix(stats::rnorm(3 * length(time), 0, 0.004), ncol = 3)
write_xvg(
    "inst/extdata/example_gyrate.xvg.gz",
    c(
        "# This file was created by gmx gyrate (simulated example for sciVizModules)",
        "@    title \"Radius of gyration (total and around axes)\"",
        "@    xaxis  label \"Time (ps)\"",
        "@    yaxis  label \"Rg (nm)\"",
        "@TYPE xy",
        "@ legend on",
        "@ s0 legend \"Rg\"",
        "@ s1 legend \"Rg\\sX\\N\"",
        "@ s2 legend \"Rg\\sY\\N\"",
        "@ s3 legend \"Rg\\sZ\\N\""
    ),
    data.frame(time, round(rg, 5), round(axes, 5))
)

residue <- 94:312
rmsf <- 0.06 + 0.04 * stats::runif(length(residue))
loops <- c(117:122, 182:186, 207:213, 224:229, 245:249, 287:312)
rmsf[residue %in% loops] <- rmsf[residue %in% loops] + stats::runif(sum(residue %in% loops), 0.05, 0.25)
rmsf[residue > 290] <- rmsf[residue > 290] + seq(0, 0.35, length.out = sum(residue > 290))
write_xvg(
    "inst/extdata/example_rmsf.xvg.gz",
    c(
        "# This file was created by gmx rmsf (simulated example for sciVizModules)",
        "@    title \"RMS fluctuation\"",
        "@    xaxis  label \"Residue\"",
        "@    yaxis  label \"(nm)\"",
        "@TYPE xy"
    ),
    data.frame(residue, round(rmsf, 5))
)
