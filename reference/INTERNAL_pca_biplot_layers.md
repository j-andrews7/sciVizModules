# Add the biplot's layers to the wrapped scatter figure

The `fig.fn` hook
[`pcaBiplotServer()`](https://j-andrews7.github.io/sciVizModules/reference/pcaBiplotServer.md)
hands to
[`VizModules::dittoViz_scatterPlotServer()`](https://j-andrews7.github.io/VizModules/reference/dittoViz_scatterPlotServer.html).
Titles each component axis with its explained variance and, when
requested, draws the loading arrows. Both are skipped when an axis
adjustment or a split is active, since those change the coordinate space
the scores and loadings were computed in.

## Usage

``` r
.pca_biplot_layers(fig, p, input, isolate_fn)
```

## Arguments

- fig:

  The scatter figure.

- p:

  The `pca` object.

- input:

  The module's input.

- isolate_fn:

  The module's isolation helper.

## Value

The figure.

## Author

Jared Andrews
