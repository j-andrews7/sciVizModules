# Server logic for the dittoScatterPlot module

This module builds a scatter plot with
[`dittoSeq::dittoScatterPlot()`](https://rdrr.io/pkg/dittoSeq/man/dittoScatterPlot.html)
and renders it as an interactive `plotly` figure.

## Usage

``` r
dittoScatterPlotServer(
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
  [`dittoScatterPlotInputsUI()`](https://j-andrews7.github.io/sciVizModules/reference/dittoScatterPlotInputsUI.md).

## Value

The `moduleServer` function for the dittoScatterPlot module.

## See also

[`dittoSeq::dittoScatterPlot()`](https://rdrr.io/pkg/dittoSeq/man/dittoScatterPlot.html),
[`dittoScatterPlotInputsUI()`](https://j-andrews7.github.io/sciVizModules/reference/dittoScatterPlotInputsUI.md),
[`dittoScatterPlotOutputUI()`](https://j-andrews7.github.io/sciVizModules/reference/dittoScatterPlotOutputUI.md),
[`dittoScatterPlotApp()`](https://j-andrews7.github.io/sciVizModules/reference/dittoScatterPlotApp.md)

## Author

Jacob Martin, Jared Andrews

## Examples

``` r
library(sciVizModules)
if (interactive()) dittoScatterPlotApp()
```
