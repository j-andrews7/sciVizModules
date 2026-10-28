# Server logic for the dittoFreqPlot module

This module builds a per-sample frequency plot with
[`dittoSeq::dittoFreqPlot()`](https://rdrr.io/pkg/dittoSeq/man/dittoFreqPlot.html)
and renders it as an interactive `plotly` figure.

## Usage

``` r
dittoFreqPlotServer(
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
  [`dittoFreqPlotInputsUI()`](https://j-andrews7.github.io/sciVizModules/reference/dittoFreqPlotInputsUI.md).

## Value

The `moduleServer` function for the dittoFreqPlot module.

## See also

[`dittoSeq::dittoFreqPlot()`](https://rdrr.io/pkg/dittoSeq/man/dittoFreqPlot.html),
[`dittoFreqPlotInputsUI()`](https://j-andrews7.github.io/sciVizModules/reference/dittoFreqPlotInputsUI.md),
[`dittoFreqPlotOutputUI()`](https://j-andrews7.github.io/sciVizModules/reference/dittoFreqPlotOutputUI.md),
[`dittoFreqPlotApp()`](https://j-andrews7.github.io/sciVizModules/reference/dittoFreqPlotApp.md)

## Author

Jacob Martin, Jared Andrews

## Examples

``` r
library(sciVizModules)
if (interactive()) dittoFreqPlotApp()
```
