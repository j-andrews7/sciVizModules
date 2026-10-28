# Server logic for the pcaScreePlot module

Renders
[`pcaScreePlot()`](https://j-andrews7.github.io/sciVizModules/reference/pcaScreePlot.md)
for a PCAtools `pca` object. The variance table is included in the
source-data download as the statistics table.

## Usage

``` r
pcaScreePlotServer(
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
  [`pcaScreePlotInputsUI()`](https://j-andrews7.github.io/sciVizModules/reference/pcaScreePlotInputsUI.md).

## Value

A `reactive` returning the source-data list.

## See also

[`pcaScreePlot()`](https://j-andrews7.github.io/sciVizModules/reference/pcaScreePlot.md),
[`pcaScreePlotInputsUI()`](https://j-andrews7.github.io/sciVizModules/reference/pcaScreePlotInputsUI.md),
[`pcaScreePlotOutputUI()`](https://j-andrews7.github.io/sciVizModules/reference/pcaScreePlotOutputUI.md),
[`pcaScreePlotApp()`](https://j-andrews7.github.io/sciVizModules/reference/pcaScreePlotApp.md)

## Author

Jared Andrews

## Examples

``` r
library(sciVizModules)
if (interactive()) pcaScreePlotApp()
```
