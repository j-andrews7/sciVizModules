# Biplot defaults for the samplePCA module

The first two components on the axes, coloured by the first discrete
`colData` column. Given explicitly, since the wrapped biplot cannot read
the PCA when it is constructed. User values win.

## Usage

``` r
.spca_biplot_defaults(se, defaults = NULL)
```

## Arguments

- se:

  A `SummarizedExperiment`, or `NULL`.

- defaults:

  A named list of user defaults, or `NULL`.

## Value

Defaults for
[`pcaBiplotServer()`](https://j-andrews7.github.io/sciVizModules/reference/pcaBiplotServer.md).

## Author

Jared Andrews
