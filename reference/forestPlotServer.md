# Server logic for the forestPlot module

Fits the chosen model to the data and renders its effect estimates with
[`forestPlot()`](https://j-andrews7.github.io/sciVizModules/reference/forestPlot.md)
as an interactive `plotly` figure. The estimates table is included in
the source-data download as the statistics table.

## Usage

``` r
forestPlotServer(
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

  A `reactive` containing the data frame to fit. Values that are not
  data frames are coerced with
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
  [`forestPlotInputsUI()`](https://j-andrews7.github.io/sciVizModules/reference/forestPlotInputsUI.md).
  An entry may also be a
  [`shiny::reactive()`](https://rdrr.io/pkg/shiny/man/reactive.html), in
  which case the input tracks it; see
  [`VizModules::setup_reactive_defaults()`](https://j-andrews7.github.io/VizModules/reference/setup_reactive_defaults.html).

## Value

A `reactive` returning the source-data list (plot, plotted data,
estimates table, inputs).

## See also

[`forestPlot()`](https://j-andrews7.github.io/sciVizModules/reference/forestPlot.md),
[`forestPlotInputsUI()`](https://j-andrews7.github.io/sciVizModules/reference/forestPlotInputsUI.md),
[`forestPlotOutputUI()`](https://j-andrews7.github.io/sciVizModules/reference/forestPlotOutputUI.md),
[`forestPlotApp()`](https://j-andrews7.github.io/sciVizModules/reference/forestPlotApp.md)

## Author

Jared Andrews

## Examples

``` r
library(sciVizModules)
if (interactive()) forestPlotApp()
```
