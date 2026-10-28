# Default UI values for the MA plot module

Computes the MA-specific defaults shared by the MA UI and the underlying
[`VizModules::dittoViz_scatterPlotServer()`](https://j-andrews7.github.io/VizModules/reference/dittoViz_scatterPlotServer.html):
mean abundance on the x-axis (on a log10 scale for DESeq2's `baseMean`),
log fold change on the y-axis, the significance column used for
grouping, the auto-generated `group` colouring, and the significance /
fold-change thresholds. Sharing this between the UI and server keeps the
initial state and the reset state identical.

## Usage

``` r
.ma_defaults(data, defaults = NULL)
```

## Arguments

- data:

  A differential-expression results data frame.

- defaults:

  An optional named list of user overrides.

## Value

A named list of scatter plot module defaults.

## Details

User-supplied `defaults` take precedence over the auto-detected values.

## Author

Jacob Martin
