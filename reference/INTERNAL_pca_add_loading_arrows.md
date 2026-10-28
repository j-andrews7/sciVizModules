# Draw loading arrows onto a biplot figure

Each arrow is an annotation from the origin to the scaled loading (tail
and head both in data coordinates), with the variable name as a separate
label at the head so it sits beyond the arrow rather than at the origin.

## Usage

``` r
.pca_add_loading_arrows(fig, arrows, color = "#000000", label.size = 12)
```

## Arguments

- fig:

  A `plotly` figure.

- arrows:

  A data frame from
  [`.pca_loading_arrows()`](https://j-andrews7.github.io/sciVizModules/reference/INTERNAL_pca_loading_arrows.md).

- color:

  Arrow and label colour.

- label.size:

  Label font size.

## Value

The figure with the arrows added.

## Author

Jared Andrews
