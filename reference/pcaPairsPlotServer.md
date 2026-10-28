# Server logic for the pcaPairsPlot module

Renders
[`pcaPairsPlot()`](https://j-andrews7.github.io/sciVizModules/reference/pcaPairsPlot.md)
for a PCAtools `pca` object. The sample scores are included in the
source-data download as the statistics table.

## Usage

``` r
pcaPairsPlotServer(
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
  [`pcaPairsPlotInputsUI()`](https://j-andrews7.github.io/sciVizModules/reference/pcaPairsPlotInputsUI.md).

## Value

A `reactive` returning the source-data list.

## See also

[`pcaPairsPlot()`](https://j-andrews7.github.io/sciVizModules/reference/pcaPairsPlot.md),
[`pcaPairsPlotInputsUI()`](https://j-andrews7.github.io/sciVizModules/reference/pcaPairsPlotInputsUI.md),
[`pcaPairsPlotOutputUI()`](https://j-andrews7.github.io/sciVizModules/reference/pcaPairsPlotOutputUI.md),
[`pcaPairsPlotApp()`](https://j-andrews7.github.io/sciVizModules/reference/pcaPairsPlotApp.md)

## Author

Jared Andrews

## Examples

``` r
library(sciVizModules)
if (interactive()) pcaPairsPlotApp()
```
