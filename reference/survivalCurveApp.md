# Create a standalone Shiny app for the survivalCurve module

This function generates a Shiny application with modular survival curve
components. The app features a **Data Import** section for uploading
data files, a **Data Table** for filtering the active dataset, and a
**Plot** area for configuring and displaying an interactive Kaplan-Meier
survival curve.

## Usage

``` r
survivalCurveApp(
  data_list = NULL,
  defaults = NULL,
  hide.inputs = NULL,
  hide.tabs = NULL
)
```

## Arguments

- data_list:

  An optional named list of data frames. If `NULL` (the default),
  `list("survival_lung" = survival_lung)` is used as example data. Each
  data frame must contain a numeric follow-up time column and an
  event/status column.

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

When `data_list` is not provided (or `NULL`), the app launches with
`survival_lung` as an example dataset, on the settings the module
gallery
([`sciModuleGalleryApp()`](https://j-andrews7.github.io/sciVizModules/reference/sciModuleGalleryApp.md))
opens this module on: curves grouped by `sex`, with median survival
marked and a risk table. Uploaded files are added to the available
datasets and can be selected for plotting.

This is a convenience wrapper around
[`VizModules::createModuleApp()`](https://j-andrews7.github.io/VizModules/reference/createModuleApp.html).

## See also

[`survivalCurveInputsUI()`](https://j-andrews7.github.io/sciVizModules/reference/survivalCurveInputsUI.md),
[`survivalCurveOutputUI()`](https://j-andrews7.github.io/sciVizModules/reference/survivalCurveOutputUI.md),
[`survivalCurveServer()`](https://j-andrews7.github.io/sciVizModules/reference/survivalCurveServer.md),
[survival_lung](https://j-andrews7.github.io/sciVizModules/reference/survival_lung.md)

## Author

Jacob Martin

## Examples

``` r
library(sciVizModules)
# Launch with default example data:
app <- survivalCurveApp()
if (interactive()) shiny::runApp(app)

# Launch with custom data:
data(survival_lung)
app2 <- survivalCurveApp(list("lung" = survival_lung))
if (interactive()) shiny::runApp(app2)
```
