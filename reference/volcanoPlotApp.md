# Create a standalone Shiny app for the volcanoPlot module

This function generates a Shiny application with modular volcano plot
components. The app features a **Data Import** section for uploading
Excel spreadsheets, a **Data Table** for viewing and editing the active
dataset, and a **Plot** area for configuring and displaying an
interactive volcano plot.

## Usage

``` r
volcanoPlotApp(
  data_list = NULL,
  defaults = NULL,
  hide.inputs = NULL,
  hide.tabs = NULL
)
```

## Arguments

- data_list:

  An optional named list of data frames. If `NULL` (the default),
  `list("airway_deseq2" = airway_deseq2)` is used as example data. Each
  data frame must contain effect size (e.g., log2FoldChange) and
  significance (e.g., padj) columns.

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
`airway_deseq2` as an example dataset, on the settings the module
gallery
([`sciModuleGalleryApp()`](https://j-andrews7.github.io/sciVizModules/reference/sciModuleGalleryApp.md))
opens this module on: thresholds of FDR 0.05 and a two-fold change, with
some well-known dexamethasone-responsive genes labelled. Uploaded Excel
files are added to the available datasets and can be selected for
plotting. If an uploaded file shares a name with an existing dataset,
the existing one is overwritten with a warning.

## See also

[`volcanoPlotInputsUI()`](https://j-andrews7.github.io/sciVizModules/reference/volcanoPlotInputsUI.md),
[`volcanoPlotOutputUI()`](https://j-andrews7.github.io/sciVizModules/reference/volcanoPlotOutputUI.md),
[`volcanoPlotServer()`](https://j-andrews7.github.io/sciVizModules/reference/volcanoPlotServer.md),
[airway_deseq2](https://j-andrews7.github.io/sciVizModules/reference/airway_deseq2.md)

## Author

Jacob Martin

## Examples

``` r
library(sciVizModules)
# Launch with default example data:
app <- volcanoPlotApp()
if (interactive()) runApp(app)

# Launch with custom data:
data(airway_deseq2)
app2 <- volcanoPlotApp(list("airway" = airway_deseq2))
if (interactive()) runApp(app2)
```
