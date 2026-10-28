# Server logic for the pcaEigencorPlot module

Renders
[`pcaEigencorPlot()`](https://j-andrews7.github.io/sciVizModules/reference/pcaEigencorPlot.md)
for a PCAtools `pca` object. The correlation table (coefficients,
p-values and adjusted p-values) is included in the source-data download
as the statistics table.

## Usage

``` r
pcaEigencorPlotServer(
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
  [`pcaEigencorPlotInputsUI()`](https://j-andrews7.github.io/sciVizModules/reference/pcaEigencorPlotInputsUI.md).

## Value

A `reactive` returning the source-data list.

## See also

[`pcaEigencorPlot()`](https://j-andrews7.github.io/sciVizModules/reference/pcaEigencorPlot.md),
[`pcaEigencorPlotInputsUI()`](https://j-andrews7.github.io/sciVizModules/reference/pcaEigencorPlotInputsUI.md),
[`pcaEigencorPlotOutputUI()`](https://j-andrews7.github.io/sciVizModules/reference/pcaEigencorPlotOutputUI.md),
[`pcaEigencorPlotApp()`](https://j-andrews7.github.io/sciVizModules/reference/pcaEigencorPlotApp.md)

## Author

Jared Andrews

## Examples

``` r
library(sciVizModules)
if (interactive()) pcaEigencorPlotApp()
```
