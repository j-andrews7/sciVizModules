# Default inputs for the PCA biplot module

Shared by
[`pcaBiplotInputsUI()`](https://j-andrews7.github.io/sciVizModules/reference/pcaBiplotInputsUI.md)
and
[`pcaBiplotServer()`](https://j-andrews7.github.io/sciVizModules/reference/pcaBiplotServer.md):
the first two components on the axes, colour by the first discrete
metadata column, and the loading-arrow settings. User values win.

## Usage

``` r
.pca_biplot_defaults(p, defaults = NULL)
```

## Arguments

- p:

  A `pca` object, or `NULL` when no data is available yet.

- defaults:

  A named list of user defaults, or `NULL`.

## Value

A named list of defaults.

## Author

Jared Andrews
