# Server logic for the dittoBarPlot module

This module builds a stacked composition bar plot with
[`dittoSeq::dittoBarPlot()`](https://rdrr.io/pkg/dittoSeq/man/dittoBarPlot.html)
and renders it as an interactive `plotly` figure.

## Usage

``` r
dittoBarPlotServer(
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
  [`dittoBarPlotInputsUI()`](https://j-andrews7.github.io/sciVizModules/reference/dittoBarPlotInputsUI.md).

## Value

The `moduleServer` function for the dittoBarPlot module.

## See also

[`dittoSeq::dittoBarPlot()`](https://rdrr.io/pkg/dittoSeq/man/dittoBarPlot.html),
[`dittoBarPlotInputsUI()`](https://j-andrews7.github.io/sciVizModules/reference/dittoBarPlotInputsUI.md),
[`dittoBarPlotOutputUI()`](https://j-andrews7.github.io/sciVizModules/reference/dittoBarPlotOutputUI.md),
[`dittoBarPlotApp()`](https://j-andrews7.github.io/sciVizModules/reference/dittoBarPlotApp.md)

## Author

Jacob Martin

## Examples

``` r
library(sciVizModules)
if (interactive()) dittoBarPlotApp()
```
