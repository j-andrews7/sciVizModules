# Create a standalone Shiny app for the goFanPlot module

This function generates a Shiny application with modular GO enrichment
sunburst ("fan") plot components. The app features a **Data Import**
section for uploading data files, a **Data Table** for filtering the
active dataset, and a **Plot** area for configuring and displaying an
interactive sunburst plot built on
[`GOfan::sunburstGO()`](https://rdrr.io/pkg/GOfan/man/sunburstGO.html).

## Usage

``` r
goFanPlotApp(
  data_list = NULL,
  defaults = NULL,
  hide.inputs = NULL,
  hide.tabs = NULL
)
```

## Arguments

- data_list:

  An optional named list of enrichment results data frames. If `NULL`
  (the default), `list("example_enrichment" = example_enrichment)` is
  used as example data. Each data frame should contain a column of GO
  identifiers and a numeric column (e.g. `qvalue`) to colour by.

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
bundled `example_enrichment` dataset, on the settings the module gallery
([`sciModuleGalleryApp()`](https://j-andrews7.github.io/sciVizModules/reference/sciModuleGalleryApp.md))
opens this module on. Uploaded files are added to the available datasets
and can be selected for plotting. If an uploaded file shares a name with
an existing dataset, the existing one is overwritten with a warning.

This is a convenience wrapper around
[`VizModules::createModuleApp()`](https://j-andrews7.github.io/VizModules/reference/createModuleApp.html).

## Note

Rendering the plot requires the **GOfan** package and the relevant
organism annotation (`OrgDb`) package (e.g. `org.Hs.eg.db`) to be
installed.

## See also

[`goFanPlotInputsUI()`](https://j-andrews7.github.io/sciVizModules/reference/goFanPlotInputsUI.md),
[`goFanPlotOutputUI()`](https://j-andrews7.github.io/sciVizModules/reference/goFanPlotOutputUI.md),
[`goFanPlotServer()`](https://j-andrews7.github.io/sciVizModules/reference/goFanPlotServer.md),
[example_enrichment](https://j-andrews7.github.io/sciVizModules/reference/example_enrichment.md)

## Author

Jacob Martin, Jared Andrews

## Examples

``` r
library(sciVizModules)
# Launch with default example data:
app <- goFanPlotApp()
if (interactive()) shiny::runApp(app)

# Launch with custom data:
data(example_enrichment)
app2 <- goFanPlotApp(list("enrichment" = example_enrichment))
if (interactive()) shiny::runApp(app2)
```
