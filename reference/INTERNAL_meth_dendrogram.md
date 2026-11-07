# The line segments of a dendrogram

The line segments of a dendrogram

## Usage

``` r
.meth_dendrogram(hc, y)
```

## Arguments

- hc:

  An `hclust` object.

- y:

  The rows of its leaves, in `hc$order`.

## Value

A list of `x` (heights) and `y`, with `NA` between merges.

## Author

Jared Andrews
