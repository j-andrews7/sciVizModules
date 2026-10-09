# Example data that other packages already ship, read the way the package's
# apps read it. Each skips the calling test when its package is not installed.

# The airway RNA-seq counts (airway package), `dex` relevelled to untrt first.
airway_se <- function() {
    testthat::skip_if_not_installed("airway")
    .se_example()
}

# The TCGA LAML somatic mutations maftools ships, with their clinical data, as
# a MAF data frame.
laml_df <- function() {
    testthat::skip_if_not_installed("maftools")
    .maf_example()
}
