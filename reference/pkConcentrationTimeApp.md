# Create a standalone Shiny app for the pkConcentrationTime module

Generates a Shiny application with modular pharmacokinetic components,
built with
[`VizModules::createModuleApp()`](https://j-andrews7.github.io/VizModules/reference/createModuleApp.html):
data import, a filterable data table, and the plot with its settings.

## Usage

``` r
pkConcentrationTimeApp(
  data_list = NULL,
  defaults = NULL,
  hide.inputs = NULL,
  hide.tabs = NULL
)
```

## Arguments

- data_list:

  An optional named list of concentration-time data frames. If `NULL`
  (the default), base R's
  [datasets::Theoph](https://rdrr.io/r/datasets/Theoph.html) (oral
  theophylline in 12 subjects) is used, on the settings the module
  gallery
  ([`sciModuleGalleryApp()`](https://j-andrews7.github.io/sciVizModules/reference/sciModuleGalleryApp.md))
  opens this module on: each subject's terminal elimination fit drawn.

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

## See also

[`pkConcentrationTime()`](https://j-andrews7.github.io/sciVizModules/reference/pkConcentrationTime.md),
[`pkConcentrationTimeInputsUI()`](https://j-andrews7.github.io/sciVizModules/reference/pkConcentrationTimeInputsUI.md),
[`pkConcentrationTimeOutputUI()`](https://j-andrews7.github.io/sciVizModules/reference/pkConcentrationTimeOutputUI.md),
[`pkConcentrationTimeServer()`](https://j-andrews7.github.io/sciVizModules/reference/pkConcentrationTimeServer.md)

## Author

Jared Andrews

## Examples

``` r
library(sciVizModules)
app <- pkConcentrationTimeApp()
if (interactive()) shiny::runApp(app)
```
