# Create a standalone Shiny app for the alphafoldConfidence module

Generates a Shiny application with a selector over the supplied
AlphaFold predictions, a read-only preview of the selected prediction's
per-residue pLDDT, and the confidence plot with its settings.

## Usage

``` r
alphafoldConfidenceApp(
  af_list = NULL,
  defaults = NULL,
  hide.inputs = NULL,
  hide.tabs = NULL
)
```

## Arguments

- af_list:

  An optional named list of objects from
  [`read_alphafold()`](https://j-andrews7.github.io/sciVizModules/reference/read_alphafold.md).

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

When `af_list` is not provided (or `NULL`), the app launches with the
bundled AlphaFold DB prediction for human p53 (UniProt P04637; AlphaFold
DB, CC-BY 4.0), on the settings the module gallery
([`sciModuleGalleryApp()`](https://j-andrews7.github.io/sciVizModules/reference/sciModuleGalleryApp.md))
opens this module on.

## See also

[`read_alphafold()`](https://j-andrews7.github.io/sciVizModules/reference/read_alphafold.md),
[`alphafoldConfidenceInputsUI()`](https://j-andrews7.github.io/sciVizModules/reference/alphafoldConfidenceInputsUI.md),
[`alphafoldConfidenceOutputUI()`](https://j-andrews7.github.io/sciVizModules/reference/alphafoldConfidenceOutputUI.md),
[`alphafoldConfidenceServer()`](https://j-andrews7.github.io/sciVizModules/reference/alphafoldConfidenceServer.md)

## Author

Jared Andrews

## Examples

``` r
library(sciVizModules)
app <- alphafoldConfidenceApp()
if (interactive()) shiny::runApp(app)
```
