# Server logic for the oncoPlot module

Renders
[`oncoPlot()`](https://j-andrews7.github.io/sciVizModules/reference/oncoPlot.md).
The shown genes' summary (mutated samples, their percentage, variants
per class) is included in the source-data download as the statistics
table.

## Usage

``` r
oncoPlotServer(id, data, hide.inputs = NULL, hide.tabs = NULL, defaults = NULL)
```

## Arguments

- id:

  The ID for the Shiny module.

- data:

  A `reactive` returning a maftools `MAF` object or a data frame in MAF
  columns.

- hide.inputs:

  A character vector of input IDs to hide.

- hide.tabs:

  A character vector of tab names to hide.

- defaults:

  A named list of default values used when resetting the inputs.
  Typically the same list passed to
  [`oncoPlotInputsUI()`](https://j-andrews7.github.io/sciVizModules/reference/oncoPlotInputsUI.md).

## Value

A `reactive` returning the source-data list.

## See also

[`oncoPlot()`](https://j-andrews7.github.io/sciVizModules/reference/oncoPlot.md),
[`oncoPlotInputsUI()`](https://j-andrews7.github.io/sciVizModules/reference/oncoPlotInputsUI.md),
[`oncoPlotOutputUI()`](https://j-andrews7.github.io/sciVizModules/reference/oncoPlotOutputUI.md),
[`oncoPlotApp()`](https://j-andrews7.github.io/sciVizModules/reference/oncoPlotApp.md)

## Author

Jared Andrews

## Examples

``` r
library(sciVizModules)
if (interactive()) oncoPlotApp()
```
