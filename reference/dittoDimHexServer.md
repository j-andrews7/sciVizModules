# Server logic for the dittoDimHex module

This module builds a hexagonal-bin dimensionality-reduction plot with
[`dittoSeq::dittoDimHex()`](https://rdrr.io/pkg/dittoSeq/man/dittoHex.html)
and renders it as an interactive `plotly` figure.

## Usage

``` r
dittoDimHexServer(
  id,
  data,
  hide.inputs = NULL,
  hide.tabs = NULL,
  defaults = NULL
)
```

## Arguments

- id:

  The ID for the Shiny module.

- data:

  A `reactive` returning a `SingleCellExperiment`, `Seurat`, or
  `SummarizedExperiment` object.

- hide.inputs:

  A character vector of input IDs to hide.

- hide.tabs:

  A character vector of tab names to hide.

- defaults:

  A named list of default values used when resetting the inputs.
  Typically the same list passed to
  [`dittoDimHexInputsUI()`](https://j-andrews7.github.io/sciVizModules/reference/dittoDimHexInputsUI.md).

## Value

The `moduleServer` function for the dittoDimHex module.

## See also

[`dittoSeq::dittoDimHex()`](https://rdrr.io/pkg/dittoSeq/man/dittoHex.html),
[`dittoDimHexInputsUI()`](https://j-andrews7.github.io/sciVizModules/reference/dittoDimHexInputsUI.md),
[`dittoDimHexOutputUI()`](https://j-andrews7.github.io/sciVizModules/reference/dittoDimHexOutputUI.md),
[`dittoDimHexApp()`](https://j-andrews7.github.io/sciVizModules/reference/dittoDimHexApp.md)

## Author

Jacob Martin

## Examples

``` r
library(sciVizModules)
if (interactive()) dittoDimHexApp()
```
