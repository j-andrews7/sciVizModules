# Server logic for the dittoDimPlot module

This module builds a dimensionality-reduction plot with
[`dittoSeq::dittoDimPlot()`](https://rdrr.io/pkg/dittoSeq/man/dittoDimPlot.html)
and renders it as an interactive `plotly` figure.

## Usage

``` r
dittoDimPlotServer(
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

  A character vector of input IDs to hide. These will still be
  initialized and their values passed to the plot function, but the user
  will not be able to see/adjust them in the UI.

- hide.tabs:

  A character vector of tab names to hide.

- defaults:

  A named list of default values used when resetting the inputs.
  Typically the same list passed to
  [`dittoDimPlotInputsUI()`](https://j-andrews7.github.io/sciVizModules/reference/dittoDimPlotInputsUI.md).

## Value

The `moduleServer` function for the dittoDimPlot module.

## See also

[`dittoSeq::dittoDimPlot()`](https://rdrr.io/pkg/dittoSeq/man/dittoDimPlot.html),
[`dittoDimPlotInputsUI()`](https://j-andrews7.github.io/sciVizModules/reference/dittoDimPlotInputsUI.md),
[`dittoDimPlotOutputUI()`](https://j-andrews7.github.io/sciVizModules/reference/dittoDimPlotOutputUI.md),
[`dittoDimPlotApp()`](https://j-andrews7.github.io/sciVizModules/reference/dittoDimPlotApp.md)

## Author

Jacob Martin, Jared Andrews

## Examples

``` r
library(sciVizModules)
if (interactive()) dittoDimPlotApp()
```
