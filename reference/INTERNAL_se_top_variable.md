# Keep the most variable rows of a matrix

Rows with zero, missing or non-finite variance are dropped first.

## Usage

``` r
.se_top_variable(mat, n = 500)
```

## Arguments

- mat:

  A numeric matrix, features by samples.

- n:

  The number of rows to keep (at least two, the fewest a PCA or a
  clustering can use); `NA` keeps them all.

## Value

The matrix restricted to its `n` most variable rows, in decreasing order
of variance.

## Author

Jared Andrews
