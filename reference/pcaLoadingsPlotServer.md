# Server logic for the pcaLoadingsPlot module

Renders
[`pcaLoadingsPlot()`](https://j-andrews7.github.io/sciVizModules/reference/pcaLoadingsPlot.md)
for a PCAtools `pca` object. The retained loadings are included in the
source-data download as the statistics table.

## Usage

``` r
pcaLoadingsPlotServer(
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

  A `reactive` returning a PCAtools `pca` object.

- hide.inputs:

  A character vector of input IDs to hide.

- hide.tabs:

  A character vector of tab names to hide.

- defaults:

  A named list of default values used when resetting the inputs.
  Typically the same list passed to
  [`pcaLoadingsPlotInputsUI()`](https://j-andrews7.github.io/sciVizModules/reference/pcaLoadingsPlotInputsUI.md).

## Value

A `reactive` returning the source-data list.

## See also

[`pcaLoadingsPlot()`](https://j-andrews7.github.io/sciVizModules/reference/pcaLoadingsPlot.md),
[`pcaLoadingsPlotInputsUI()`](https://j-andrews7.github.io/sciVizModules/reference/pcaLoadingsPlotInputsUI.md),
[`pcaLoadingsPlotOutputUI()`](https://j-andrews7.github.io/sciVizModules/reference/pcaLoadingsPlotOutputUI.md),
[`pcaLoadingsPlotApp()`](https://j-andrews7.github.io/sciVizModules/reference/pcaLoadingsPlotApp.md)

## Author

Jared Andrews

## Examples

``` r
library(sciVizModules)
if (interactive()) pcaLoadingsPlotApp()
```
