# Server logic for the dittoRidgeJitter module

This module builds a ridgeline-with-jitter plot with
[`dittoSeq::dittoRidgeJitter()`](https://rdrr.io/pkg/dittoSeq/man/dittoPlot.html)
and renders it as an interactive `plotly` figure.

## Usage

``` r
dittoRidgeJitterServer(
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
  [`dittoRidgeJitterInputsUI()`](https://j-andrews7.github.io/sciVizModules/reference/dittoRidgeJitterInputsUI.md).

## Value

The `moduleServer` function for the dittoRidgeJitter module.

## See also

[`dittoSeq::dittoRidgeJitter()`](https://rdrr.io/pkg/dittoSeq/man/dittoPlot.html),
[`dittoRidgeJitterInputsUI()`](https://j-andrews7.github.io/sciVizModules/reference/dittoRidgeJitterInputsUI.md),
[`dittoRidgeJitterOutputUI()`](https://j-andrews7.github.io/sciVizModules/reference/dittoRidgeJitterOutputUI.md),
[`dittoRidgeJitterApp()`](https://j-andrews7.github.io/sciVizModules/reference/dittoRidgeJitterApp.md)

## Author

Jacob Martin, Jared Andrews

## Examples

``` r
library(sciVizModules)
if (interactive()) dittoRidgeJitterApp()
```
