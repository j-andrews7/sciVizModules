# Create a standalone Shiny app for the sampleDistanceHeatmap module

Generates a Shiny application with a selector over the supplied
experiments, a read-only preview of the selected experiment's sample
metadata, and the interactive distance heatmap with its settings. Needs
ComplexHeatmap, InteractiveComplexHeatmap and circlize.

## Usage

``` r
sampleDistanceHeatmapApp(
  object_list = NULL,
  defaults = NULL,
  hide.inputs = NULL,
  hide.tabs = NULL
)
```

## Arguments

- object_list:

  An optional named list of `SummarizedExperiment` objects.

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

When `object_list` is not provided (or `NULL`), the app launches with
the airway RNA-seq counts from the airway package (needs airway), on the
settings the module gallery
([`sciModuleGalleryApp()`](https://j-andrews7.github.io/sciVizModules/reference/sciModuleGalleryApp.md))
opens this module on.

## See also

[`sampleDistanceHeatmapInputsUI()`](https://j-andrews7.github.io/sciVizModules/reference/sampleDistanceHeatmapInputsUI.md),
[`sampleDistanceHeatmapOutputUI()`](https://j-andrews7.github.io/sciVizModules/reference/sampleDistanceHeatmapOutputUI.md),
[`sampleDistanceHeatmapServer()`](https://j-andrews7.github.io/sciVizModules/reference/sampleDistanceHeatmapServer.md)

## Author

Jared Andrews

## Examples

``` r
library(sciVizModules)
if (requireNamespace("ComplexHeatmap", quietly = TRUE) &&
    requireNamespace("InteractiveComplexHeatmap", quietly = TRUE) &&
    requireNamespace("circlize", quietly = TRUE) &&
    requireNamespace("airway", quietly = TRUE)) {
    app <- sampleDistanceHeatmapApp()
    if (interactive()) shiny::runApp(app)
}
```
