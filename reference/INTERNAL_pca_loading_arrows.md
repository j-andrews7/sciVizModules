# Loading arrows for a biplot

Picks the `n` variables with the largest absolute loading on each of the
two components (as
[`PCAtools::biplot()`](https://rdrr.io/pkg/PCAtools/man/biplot.html)
does with `ntopLoadings`) and scales their loadings into score space.
The scale is the smaller of the two axes' ratio of score range to
loading range, times `length.factor`, so the longest arrows span a
comparable distance to the samples. (PCAtools computes
`max(scores) - min(scores) / range(loadings)` there, an
operator-precedence slip; this uses the ratio of ranges it intends.)

## Usage

``` r
.pca_loading_arrows(p, x, y, n = 5, length.factor = 1.5)
```

## Arguments

- p:

  A `pca` object.

- x, y:

  Component names on the two axes.

- n:

  Number of top variables per component.

- length.factor:

  Arrow length multiplier.

## Value

A data frame with `variable`, `xend`, `yend`.

## Author

Jared Andrews
