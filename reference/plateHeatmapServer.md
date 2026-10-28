# Server logic for the plateHeatmap module

Renders
[`plateHeatmap()`](https://j-andrews7.github.io/sciVizModules/reference/plateHeatmap.md).
The per-plate quality statistics (control means and SDs,
signal-to-background, Z'-factor, edge-to-interior ratio) are included in
the source-data download as the statistics table.

## Usage

``` r
plateHeatmapServer(
  id,
  data,
  hide.inputs = NULL,
  hide.tabs = NULL,
  defaults = NULL
)
```

## Arguments

- id:

  The ID for the Shiny module.

- data:

  A `reactive` containing the plate data frame.

- hide.inputs:

  A character vector of input IDs to hide. The gridline inputs
  (`show.grid.x`, `show.grid.y`, `grid.color`) are always hidden.

- hide.tabs:

  A character vector of tab names to hide.

- defaults:

  A named list of default values used when resetting the inputs.
  Typically the same list passed to
  [`plateHeatmapInputsUI()`](https://j-andrews7.github.io/sciVizModules/reference/plateHeatmapInputsUI.md).

## Value

A `reactive` returning the source-data list.

## See also

[`plateHeatmap()`](https://j-andrews7.github.io/sciVizModules/reference/plateHeatmap.md),
[`plateHeatmapInputsUI()`](https://j-andrews7.github.io/sciVizModules/reference/plateHeatmapInputsUI.md),
[`plateHeatmapOutputUI()`](https://j-andrews7.github.io/sciVizModules/reference/plateHeatmapOutputUI.md),
[`plateHeatmapApp()`](https://j-andrews7.github.io/sciVizModules/reference/plateHeatmapApp.md)

## Author

Jared Andrews

## Examples

``` r
library(sciVizModules)
if (interactive()) plateHeatmapApp()
```
