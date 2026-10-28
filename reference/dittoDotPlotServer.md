# Server logic for the dittoDotPlot module

This module builds a marker dot plot with
[`dittoSeq::dittoDotPlot()`](https://rdrr.io/pkg/dittoSeq/man/dittoDotPlot.html)
and renders it as an interactive `plotly` figure.

## Usage

``` r
dittoDotPlotServer(
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
  [`dittoDotPlotInputsUI()`](https://j-andrews7.github.io/sciVizModules/reference/dittoDotPlotInputsUI.md).

## Value

A `reactive` returning the source-data list.

## See also

[`dittoSeq::dittoDotPlot()`](https://rdrr.io/pkg/dittoSeq/man/dittoDotPlot.html),
[`dittoDotPlotInputsUI()`](https://j-andrews7.github.io/sciVizModules/reference/dittoDotPlotInputsUI.md),
[`dittoDotPlotOutputUI()`](https://j-andrews7.github.io/sciVizModules/reference/dittoDotPlotOutputUI.md),
[`dittoDotPlotApp()`](https://j-andrews7.github.io/sciVizModules/reference/dittoDotPlotApp.md)

## Author

Jared Andrews

## Examples

``` r
library(sciVizModules)
if (interactive()) dittoDotPlotApp()
```
