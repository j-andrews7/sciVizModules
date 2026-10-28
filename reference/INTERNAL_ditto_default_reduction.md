# Choose a sensible default dimensionality reduction

Choose a sensible default dimensionality reduction

## Usage

``` r
.ditto_default_reduction(object)
```

## Arguments

- object:

  A dittoSeq-compatible object.

## Value

The name of the best-guess reduction (priority UMAP \> t-SNE \> PCA), or
`NULL` when none exist.

## Author

Jacob Martin, Jared Andrews
