# Create a standalone Shiny app for the dose-response module

Convenience wrapper around
[`VizModules::createModuleApp()`](https://j-andrews7.github.io/VizModules/reference/createModuleApp.html)
that launches the dose-response module: a scatter plot of response
versus dose (log10 x-axis) with a **drc** log-logistic model fitted as
the curve. Irrelevant scatter plot tabs and inputs are hidden.

## Usage

``` r
doseResponseApp(
  data_list = NULL,
  defaults = NULL,
  hide.inputs = NULL,
  hide.tabs = NULL
)
```

## Arguments

- data_list:

  An optional named list of dose-response data frames. If `NULL` (the
  default), `list("dose_response" = dose_response)` is used.

- defaults:

  A named list of default values, merged over the module's dose-response
  defaults (user values win) and, with the example data, over the
  gallery's settings.

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

When `data_list` is not provided, the app launches with the bundled
[dose_response](https://j-andrews7.github.io/sciVizModules/reference/dose_response.md)
example data, on the settings the module gallery
([`sciModuleGalleryApp()`](https://j-andrews7.github.io/sciVizModules/reference/sciModuleGalleryApp.md))
opens this module on.

## See also

[`doseResponseInputsUI()`](https://j-andrews7.github.io/sciVizModules/reference/doseResponseInputsUI.md),
[`doseResponseOutputUI()`](https://j-andrews7.github.io/sciVizModules/reference/doseResponseOutputUI.md),
[`doseResponseServer()`](https://j-andrews7.github.io/sciVizModules/reference/doseResponseServer.md),
[dose_response](https://j-andrews7.github.io/sciVizModules/reference/dose_response.md)

## Author

Jacob Martin

## Examples

``` r
library(sciVizModules)
# Launch with the bundled example dose-response data:
app <- doseResponseApp()
if (interactive()) shiny::runApp(app)
```
