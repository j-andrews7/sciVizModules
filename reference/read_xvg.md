# Read a GROMACS .xvg file

Reads the analysis output GROMACS writes as `.xvg` (`gmx rms`,
`gmx rmsf`, `gmx gyrate`, `gmx hbond`, `gmx energy`, ...) into a long
data frame for the mdTrajectoryMetrics module. `#` comment lines are
skipped; the `@ title`, axis labels and series legends are kept; Grace
formatting codes such as `\\sX\\N` (subscript) are removed from labels.
The file may be gzip-compressed. Several files - replicas, or different
analyses - can be combined with
[`rbind()`](https://rdrr.io/r/base/cbind.html).

## Usage

``` r
read_xvg(file, series = NULL)
```

## Arguments

- file:

  Path to a `.xvg` file.

- series:

  Optional names for the data series (the y columns), e.g. a replica
  name for a single-series file. Defaults to the file's legends, or the
  file name when it has none.

## Value

A data frame with one row per point: `x`, `value`, `series`, `metric`
(the file's title), `x.label`, `y.label` and `file`.

## See also

[`mdTrajectoryMetrics()`](https://j-andrews7.github.io/sciVizModules/reference/mdTrajectoryMetrics.md),
the mdTrajectoryMetrics module

## Author

Jared Andrews

## Examples

``` r
rmsd <- read_xvg(system.file("extdata", "example_rmsd_rep1.xvg.gz", package = "sciVizModules"),
    series = "replica 1")
head(rmsd)
#>     x   value    series metric   x.label   y.label              file
#> 1   0 0.00000 replica 1   RMSD Time (ps) RMSD (nm) example_rmsd_rep1
#> 2 100 0.01225 replica 1   RMSD Time (ps) RMSD (nm) example_rmsd_rep1
#> 3 200 0.01587 replica 1   RMSD Time (ps) RMSD (nm) example_rmsd_rep1
#> 4 300 0.02164 replica 1   RMSD Time (ps) RMSD (nm) example_rmsd_rep1
#> 5 400 0.01884 replica 1   RMSD Time (ps) RMSD (nm) example_rmsd_rep1
#> 6 500 0.02131 replica 1   RMSD Time (ps) RMSD (nm) example_rmsd_rep1
```
