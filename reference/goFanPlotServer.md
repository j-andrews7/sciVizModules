# Server logic for the goFanPlot module

This module builds a GO enrichment sunburst ("fan") plot with
[`GOfan::sunburstGO()`](https://rdrr.io/pkg/GOfan/man/sunburstGO.html)
(via
[`goFanPlot()`](https://j-andrews7.github.io/sciVizModules/reference/goFanPlot.md))
and renders it as an interactive `plotly` figure.

## Usage

``` r
goFanPlotServer(
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

  A `reactive` returning the enrichment results data frame. Must contain
  a column of GO identifiers and a numeric column to colour by. Values
  that are not data frames are coerced with
  [`as.data.frame()`](https://rdrr.io/r/base/as.data.frame.html); a
  `NULL` value is treated as "not ready yet" and the module waits for
  data.

- hide.inputs:

  A character vector of input IDs to hide. These will still be
  initialized and their values passed to the plot function, but the user
  will not be able to see/adjust them in the UI.

- hide.tabs:

  A character vector of tab names to hide.

- defaults:

  A named list of default values used when resetting the inputs.
  Typically the same list passed to
  [`goFanPlotInputsUI()`](https://j-andrews7.github.io/sciVizModules/reference/goFanPlotInputsUI.md).

## Value

The `moduleServer` function for the goFanPlot module.

## See also

[`GOfan::sunburstGO()`](https://rdrr.io/pkg/GOfan/man/sunburstGO.html),
[`goFanPlot()`](https://j-andrews7.github.io/sciVizModules/reference/goFanPlot.md),
[`goFanPlotInputsUI()`](https://j-andrews7.github.io/sciVizModules/reference/goFanPlotInputsUI.md),
[`goFanPlotOutputUI()`](https://j-andrews7.github.io/sciVizModules/reference/goFanPlotOutputUI.md),
[`goFanPlotApp()`](https://j-andrews7.github.io/sciVizModules/reference/goFanPlotApp.md)

## Author

Jacob Martin, Jared Andrews

## Examples

``` r
library(sciVizModules)
if (interactive()) goFanPlotApp()
```
