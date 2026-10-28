# Create a standalone Shiny app for the mutationalProfile module

Generates a Shiny application with modular mutational-spectrum
components, built with
[`VizModules::createModuleApp()`](https://j-andrews7.github.io/VizModules/reference/createModuleApp.html):
data import, a filterable data table, and the plot with its settings.

## Usage

``` r
mutationalProfileApp(
  data_list = NULL,
  defaults = NULL,
  hide.inputs = NULL,
  hide.tabs = NULL
)
```

## Arguments

- data_list:

  An optional named list of 96-channel substitution count matrices or
  data frames. If `NULL` (the default), the simulated
  [example_sbs96](https://j-andrews7.github.io/sciVizModules/reference/example_sbs96.md)
  spectra are used.

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

With the example data, the app opens on the settings the module gallery
([`sciModuleGalleryApp()`](https://j-andrews7.github.io/sciVizModules/reference/sciModuleGalleryApp.md))
opens this module on.

## See also

[`mutationalProfileInputsUI()`](https://j-andrews7.github.io/sciVizModules/reference/mutationalProfileInputsUI.md),
[`mutationalProfileOutputUI()`](https://j-andrews7.github.io/sciVizModules/reference/mutationalProfileOutputUI.md),
[`mutationalProfileServer()`](https://j-andrews7.github.io/sciVizModules/reference/mutationalProfileServer.md),
[example_sbs96](https://j-andrews7.github.io/sciVizModules/reference/example_sbs96.md)

## Author

Jared Andrews

## Examples

``` r
library(sciVizModules)
app <- mutationalProfileApp()
if (interactive()) shiny::runApp(app)
```
