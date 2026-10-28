# Add the QQ plot's layers to the wrapped scatter figure

The `fig.fn` hook
[`gwasQQPlotServer()`](https://j-andrews7.github.io/sciVizModules/reference/gwasQQPlotServer.md)
hands to the scatter module: axis titles, the confidence band under the
null, and the genomic inflation factor. Only applied while the axes are
the expected and observed -log10(p) with no adjustment or split.

## Usage

``` r
.gwas_qq_layers(fig, n, lambda, input, isolate_fn)
```

## Arguments

- fig:

  The scatter figure.

- n:

  Number of variants (before thinning).

- lambda:

  Lambda GC.

- input:

  The module's input.

- isolate_fn:

  The module's isolation helper.

## Value

The figure.

## Author

Jared Andrews
