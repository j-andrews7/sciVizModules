# Create a standalone Shiny app for the crisprScreenRank module

Generates a Shiny application with modular CRISPR screen rank plot
components, built with
[`VizModules::createModuleApp()`](https://j-andrews7.github.io/VizModules/reference/createModuleApp.html):
data import, a filterable data table, and the plot with its settings.

## Usage

``` r
crisprScreenRankApp(
  data_list = NULL,
  defaults = NULL,
  hide.inputs = NULL,
  hide.tabs = NULL
)
```

## Arguments

- data_list:

  An optional named list of MAGeCK RRA or MLE gene summaries (data
  frames from
  [`read_mageck()`](https://j-andrews7.github.io/sciVizModules/reference/read_mageck.md)).

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
bundled simulated MAGeCK gene summaries, one from `mageck test` (RRA)
and one from `mageck mle`, read with
[`read_mageck()`](https://j-andrews7.github.io/sciVizModules/reference/read_mageck.md).
The RRA summary opens on the settings the module gallery
([`sciModuleGalleryApp()`](https://j-andrews7.github.io/sciVizModules/reference/sciModuleGalleryApp.md))
shows it with: genes ranked by FDR, with the strongest hits labelled.

## See also

[`read_mageck()`](https://j-andrews7.github.io/sciVizModules/reference/read_mageck.md),
[`crisprScreenRankInputsUI()`](https://j-andrews7.github.io/sciVizModules/reference/crisprScreenRankInputsUI.md),
[`crisprScreenRankOutputUI()`](https://j-andrews7.github.io/sciVizModules/reference/crisprScreenRankOutputUI.md),
[`crisprScreenRankServer()`](https://j-andrews7.github.io/sciVizModules/reference/crisprScreenRankServer.md)

## Author

Jared Andrews

## Examples

``` r
library(sciVizModules)
app <- crisprScreenRankApp()
if (interactive()) shiny::runApp(app)
```
