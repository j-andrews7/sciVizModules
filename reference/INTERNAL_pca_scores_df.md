# Sample scores joined to the sample metadata

One row per sample: a `sample` column (the row names of `rotated`),
every component score, then every metadata column whose name does not
clash.

## Usage

``` r
.pca_scores_df(p)
```

## Arguments

- p:

  A `pca` object.

## Value

A data frame.

## Author

Jared Andrews
