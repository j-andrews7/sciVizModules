# Sample metadata of a SummarizedExperiment as a data frame

List-like columns (nested `DataFrame`s, `List`s) are dropped, since they
cannot be plotted.

## Usage

``` r
.se_coldata(se)
```

## Arguments

- se:

  A `SummarizedExperiment`.

## Value

A data frame with one row per sample, row names the sample names.

## Author

Jared Andrews
