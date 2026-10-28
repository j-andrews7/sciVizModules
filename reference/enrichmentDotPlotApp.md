# Create a standalone Shiny app for the enrichmentDotPlot module

This function generates a Shiny application with modular enrichment
dot-plot components. The app features a **Data Import** section for
uploading data files, a **Data Table** for filtering the active dataset,
and a **Plot** area for configuring and displaying an interactive
enrichment dot plot built on
[`plotthis::DotPlot()`](https://pwwang.github.io/plotthis/reference/dotplot.html).

## Usage

``` r
enrichmentDotPlotApp(
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
  used as example data. Each data frame should contain enrichment terms
  and, ideally, `GeneRatio` and p-value columns.

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
bundled `example_enrichment` dataset. Uploaded files are added to the
available datasets and can be selected for plotting. If an uploaded file
shares a name with an existing dataset, the existing one is overwritten
with a warning.

This is a convenience wrapper around
[`VizModules::createModuleApp()`](https://j-andrews7.github.io/VizModules/reference/createModuleApp.html).

With the example data, the app opens on the settings the module gallery
([`sciModuleGalleryApp()`](https://j-andrews7.github.io/sciVizModules/reference/sciModuleGalleryApp.md))
opens this module on.

## See also

[`enrichmentDotPlotInputsUI()`](https://j-andrews7.github.io/sciVizModules/reference/enrichmentDotPlotInputsUI.md),
[`enrichmentDotPlotOutputUI()`](https://j-andrews7.github.io/sciVizModules/reference/enrichmentDotPlotOutputUI.md),
[`enrichmentDotPlotServer()`](https://j-andrews7.github.io/sciVizModules/reference/enrichmentDotPlotServer.md),
[example_enrichment](https://j-andrews7.github.io/sciVizModules/reference/example_enrichment.md)

## Author

Jacob Martin, Jared Andrews

## Examples

``` r
library(sciVizModules)
# Launch with default example data:
app <- enrichmentDotPlotApp()
if (interactive()) shiny::runApp(app)

# Launch with custom data:
data(example_enrichment)
app2 <- enrichmentDotPlotApp(list("enrichment" = example_enrichment))
if (interactive()) shiny::runApp(app2)
```
