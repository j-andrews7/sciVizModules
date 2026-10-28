# Create a standalone Shiny app for the forestPlot module

Generates a Shiny application with modular forest plot components, built
with
[`VizModules::createModuleApp()`](https://j-andrews7.github.io/VizModules/reference/createModuleApp.html):
data import, a filterable data table, and the plot with its settings.

## Usage

``` r
forestPlotApp(
  data_list = NULL,
  defaults = NULL,
  hide.inputs = NULL,
  hide.tabs = NULL
)
```

## Arguments

- data_list:

  An optional named list of data frames. If `NULL` (the default),
  `list("survival_lung" = survival_lung)` is used as example data.

- defaults:

  A named list of input IDs and their default values to apply on
  startup. With the example data, they are applied over the settings the
  module gallery opens the module on, a key given here replacing its
  showcase value.

- hide.inputs:

  A character vector of input IDs to hide. Their values are still
  initialized and used, but the controls are not shown in the UI.

- hide.tabs:

  A character vector of tab names to hide. Inputs in these tabs are
  still initialized and used. `NULL` (the default) keeps the module's
  own default.

## Value

A Shiny app object.

## Details

When `data_list` is not provided (or `NULL`), the app launches with the
bundled `survival_lung` dataset.

With the example data, the app opens on the settings the module gallery
([`sciModuleGalleryApp()`](https://j-andrews7.github.io/sciVizModules/reference/sciModuleGalleryApp.md))
opens this module on.

## See also

[`forestPlotInputsUI()`](https://j-andrews7.github.io/sciVizModules/reference/forestPlotInputsUI.md),
[`forestPlotOutputUI()`](https://j-andrews7.github.io/sciVizModules/reference/forestPlotOutputUI.md),
[`forestPlotServer()`](https://j-andrews7.github.io/sciVizModules/reference/forestPlotServer.md),
[`forestPlot()`](https://j-andrews7.github.io/sciVizModules/reference/forestPlot.md),
[survival_lung](https://j-andrews7.github.io/sciVizModules/reference/survival_lung.md)

## Author

Jared Andrews

## Examples

``` r
library(sciVizModules)
app <- forestPlotApp()
if (interactive()) shiny::runApp(app)
```
