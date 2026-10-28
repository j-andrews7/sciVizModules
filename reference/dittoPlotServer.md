# Server logic for the dittoPlot module

This module builds a per-group continuous-data plot with
[`dittoSeq::dittoPlot()`](https://rdrr.io/pkg/dittoSeq/man/dittoPlot.html)
and renders it as an interactive `plotly` figure.

## Usage

``` r
dittoPlotServer(
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
  [`dittoPlotInputsUI()`](https://j-andrews7.github.io/sciVizModules/reference/dittoPlotInputsUI.md).

## Value

The `moduleServer` function for the dittoPlot module.

## See also

[`dittoSeq::dittoPlot()`](https://rdrr.io/pkg/dittoSeq/man/dittoPlot.html),
[`dittoPlotInputsUI()`](https://j-andrews7.github.io/sciVizModules/reference/dittoPlotInputsUI.md),
[`dittoPlotOutputUI()`](https://j-andrews7.github.io/sciVizModules/reference/dittoPlotOutputUI.md),
[`dittoPlotApp()`](https://j-andrews7.github.io/sciVizModules/reference/dittoPlotApp.md)

## Author

Jacob Martin, Jared Andrews

## Examples

``` r
library(sciVizModules)
if (interactive()) dittoPlotApp()
```
