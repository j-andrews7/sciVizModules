# Create a standalone Shiny app for the pcaEigencorPlot module

Generates a Shiny application with an object selector over the supplied
PCAtools `pca` objects, a read-only preview of the selected object's
sample metadata, and the PC-metadata correlation heatmap with its
settings.

## Usage

``` r
pcaEigencorPlotApp(
  pca_list = NULL,
  defaults = NULL,
  hide.inputs = NULL,
  hide.tabs = NULL
)
```

## Arguments

- pca_list:

  An optional named list of PCAtools `pca` objects. If `NULL` (the
  default), the bundled
  [example_pca](https://j-andrews7.github.io/sciVizModules/reference/example_pca.md)
  is used.

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

[`pcaEigencorPlotInputsUI()`](https://j-andrews7.github.io/sciVizModules/reference/pcaEigencorPlotInputsUI.md),
[`pcaEigencorPlotOutputUI()`](https://j-andrews7.github.io/sciVizModules/reference/pcaEigencorPlotOutputUI.md),
[`pcaEigencorPlotServer()`](https://j-andrews7.github.io/sciVizModules/reference/pcaEigencorPlotServer.md),
[example_pca](https://j-andrews7.github.io/sciVizModules/reference/example_pca.md)

## Author

Jared Andrews

## Examples

``` r
library(sciVizModules)
app <- pcaEigencorPlotApp()
if (interactive()) shiny::runApp(app)
```
