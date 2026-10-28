# Add the CRISPR rank plot's layers to the wrapped scatter figure

The `fig.fn` hook
[`crisprScreenRankServer()`](https://j-andrews7.github.io/sciVizModules/reference/crisprScreenRankServer.md)
hands to the scatter module: axis titles for the metric, and the FDR
cut-offs (one per direction) when the metric is the FDR. Only applied
while the axes are the rank and the metric with no adjustment or split.
Gene labels come from the scatter module's own Annotations controls.

## Usage

``` r
.crispr_layers(fig, prepared, input, isolate_fn)
```

## Arguments

- fig:

  The scatter figure.

- prepared:

  The prepared table from
  [`.crispr_prepare()`](https://j-andrews7.github.io/sciVizModules/reference/INTERNAL_crispr_prepare.md).

- input:

  The module's input.

- isolate_fn:

  The module's isolation helper.

## Value

The figure.

## Author

Jared Andrews
