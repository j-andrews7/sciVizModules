# Create a standalone Shiny app for the structureViewer module

Generates a Shiny application with a selector over the supplied
structures, a read-only preview of the selected structure's residues,
and the 3D viewer with its settings.

## Usage

``` r
structureViewerApp(
  structure_list = NULL,
  defaults = NULL,
  hide.inputs = NULL,
  hide.tabs = NULL
)
```

## Arguments

- structure_list:

  An optional named list of objects from
  [`read_structure()`](https://j-andrews7.github.io/sciVizModules/reference/read_structure.md).

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

When `structure_list` is not provided (or `NULL`), the app launches with
the bundled AlphaFold DB model of human p53 (UniProt P04637; AlphaFold
DB, CC-BY 4.0), coloured by pLDDT, on the settings the module gallery
([`sciModuleGalleryApp()`](https://j-andrews7.github.io/sciVizModules/reference/sciModuleGalleryApp.md))
opens this module on: its most often mutated DNA-binding residues
highlighted.

## See also

[`read_structure()`](https://j-andrews7.github.io/sciVizModules/reference/read_structure.md),
[`structureViewerInputsUI()`](https://j-andrews7.github.io/sciVizModules/reference/structureViewerInputsUI.md),
[`structureViewerOutputUI()`](https://j-andrews7.github.io/sciVizModules/reference/structureViewerOutputUI.md),
[`structureViewerServer()`](https://j-andrews7.github.io/sciVizModules/reference/structureViewerServer.md)

## Author

Jared Andrews

## Examples

``` r
library(sciVizModules)
app <- structureViewerApp()
if (interactive()) shiny::runApp(app)
```
