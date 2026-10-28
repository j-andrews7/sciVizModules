# Sample distances or correlations

Sample distances or correlations

## Usage

``` r
.sample_distances(mat, method = "euclidean")
```

## Arguments

- mat:

  A transformed expression matrix, features by samples.

- method:

  `"euclidean"`, `"pearson"` or `"spearman"`.

## Value

A list with `values` (samples by samples: distances, or correlations)
and `dist` (the distances clustering uses: Euclidean, or one minus the
correlation).

## Author

Jared Andrews
