# Add the Manhattan plot's layers to the wrapped scatter figure

The `fig.fn` hook
[`manhattanPlotServer()`](https://j-andrews7.github.io/sciVizModules/reference/manhattanPlotServer.md)
hands to the scatter module. While the x-axis is the concatenated
genome, it labels the axis with chromosome names at their centres; while
the y-axis is the p-value drawn as -log10, it titles it and draws the
genome-wide and suggestive significance lines. Adjusted or split axes
are left alone.

## Usage

``` r
.manhattan_layers(fig, centres, input, isolate_fn)
```

## Arguments

- fig:

  The scatter figure.

- centres:

  Named chromosome centres along the x-axis.

- input:

  The module's input.

- isolate_fn:

  The module's isolation helper.

## Value

The figure.

## Author

Jared Andrews
