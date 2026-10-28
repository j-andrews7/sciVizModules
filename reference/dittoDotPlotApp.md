# Create a standalone Shiny app for the dittoDotPlot module

This function generates a Shiny application with modular dittoDotPlot
components: a **Data** section for selecting among the provided objects,
a read-only **Metadata Preview**, and a **Plot** area for configuring
and displaying an interactive
[`dittoSeq::dittoDotPlot()`](https://rdrr.io/pkg/dittoSeq/man/dittoDotPlot.html).

## Usage

``` r
dittoDotPlotApp(
  object_list = NULL,
  defaults = NULL,
  hide.inputs = NULL,
  hide.tabs = NULL
)
```

## Arguments

- object_list:

  An optional named list of `SingleCellExperiment`, `Seurat`, or
  `SummarizedExperiment` objects. If `NULL` (the default),
  `list("example_sce" = example_sce)` is used as example data.

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
the bundled `example_sce` dataset.

With the example data, the app opens on the settings the module gallery
([`sciModuleGalleryApp()`](https://j-andrews7.github.io/sciVizModules/reference/sciModuleGalleryApp.md))
opens this module on.

## See also

[`dittoDotPlotInputsUI()`](https://j-andrews7.github.io/sciVizModules/reference/dittoDotPlotInputsUI.md),
[`dittoDotPlotOutputUI()`](https://j-andrews7.github.io/sciVizModules/reference/dittoDotPlotOutputUI.md),
[`dittoDotPlotServer()`](https://j-andrews7.github.io/sciVizModules/reference/dittoDotPlotServer.md),
[example_sce](https://j-andrews7.github.io/sciVizModules/reference/example_sce.md)

## Author

Jared Andrews

## Examples

``` r
library(sciVizModules)
app <- dittoDotPlotApp()
if (interactive()) shiny::runApp(app)
```
