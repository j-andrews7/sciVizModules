# Create a standalone Shiny app for the mafSummary module

Generates a Shiny application with modular MAF-summary components, built
with
[`VizModules::createModuleApp()`](https://j-andrews7.github.io/VizModules/reference/createModuleApp.html):
data import, a filterable data table, and the plot with its settings.

## Usage

``` r
mafSummaryApp(
  data_list = NULL,
  defaults = NULL,
  hide.inputs = NULL,
  hide.tabs = NULL
)
```

## Arguments

- data_list:

  An optional named list of MAF data frames or maftools `MAF` objects.
  If `NULL` (the default), the TCGA LAML cohort maftools ships is used
  (needs maftools), on the settings the module gallery
  ([`sciModuleGalleryApp()`](https://j-andrews7.github.io/sciVizModules/reference/sciModuleGalleryApp.md))
  opens this module on.

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

[`mafSummary()`](https://j-andrews7.github.io/sciVizModules/reference/mafSummary.md),
[`mafSummaryInputsUI()`](https://j-andrews7.github.io/sciVizModules/reference/mafSummaryInputsUI.md),
[`mafSummaryOutputUI()`](https://j-andrews7.github.io/sciVizModules/reference/mafSummaryOutputUI.md),
[`mafSummaryServer()`](https://j-andrews7.github.io/sciVizModules/reference/mafSummaryServer.md)

## Author

Jared Andrews

## Examples

``` r
library(sciVizModules)
if (requireNamespace("maftools", quietly = TRUE)) {
    app <- mafSummaryApp()
    if (interactive()) shiny::runApp(app)
}
```
