# PCA of a transformed matrix, in PCAtools' shape

PCA of a transformed matrix, in PCAtools' shape

## Usage

``` r
.pca_from_matrix(
  mat,
  meta = NULL,
  ntop = 500,
  center = TRUE,
  scale = FALSE,
  labels = NULL
)
```

## Arguments

- mat:

  A transformed numeric matrix, features by samples.

- meta:

  Sample metadata, one row per column of `mat`, or `NULL`.

- ntop, center, scale:

  As for
  [`sample_pca()`](https://j-andrews7.github.io/sciVizModules/reference/sample_pca.md).

- labels:

  A character vector of feature labels named by row name, or `NULL` for
  the row names.

## Value

A list of class `"pca"`; see
[`sample_pca()`](https://j-andrews7.github.io/sciVizModules/reference/sample_pca.md).

## Author

Jared Andrews
