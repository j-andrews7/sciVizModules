# Create a standalone Shiny app for the gseaEnrichmentPlot module

Generates a Shiny application with a selector over the supplied GSEA
inputs, a read-only preview of the selected input's results, and the
enrichment plot with its settings.

## Usage

``` r
gseaEnrichmentPlotApp(
  gsea_list = NULL,
  defaults = NULL,
  hide.inputs = NULL,
  hide.tabs = NULL
)
```

## Arguments

- gsea_list:

  An optional named list of fgsea bundles or clusterProfiler
  `gseaResult` objects. If `NULL` (the default), the bundled
  [example_gsea](https://j-andrews7.github.io/sciVizModules/reference/example_gsea.md)
  is used, on the settings the module gallery
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

[`gseaEnrichmentPlotInputsUI()`](https://j-andrews7.github.io/sciVizModules/reference/gseaEnrichmentPlotInputsUI.md),
[`gseaEnrichmentPlotOutputUI()`](https://j-andrews7.github.io/sciVizModules/reference/gseaEnrichmentPlotOutputUI.md),
[`gseaEnrichmentPlotServer()`](https://j-andrews7.github.io/sciVizModules/reference/gseaEnrichmentPlotServer.md),
[example_gsea](https://j-andrews7.github.io/sciVizModules/reference/example_gsea.md)

## Author

Jared Andrews

## Examples

``` r
library(sciVizModules)
app <- gseaEnrichmentPlotApp()
if (interactive()) shiny::runApp(app)
```
