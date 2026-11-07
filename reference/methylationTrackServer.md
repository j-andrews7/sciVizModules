# Server logic for the methylationTrack module

Renders
[`methylationTrack()`](https://j-andrews7.github.io/sciVizModules/reference/methylationTrack.md).
The plotted beta values, with each CpG's position and probes, and the
samples in plotted order are included in the source-data download as the
statistics tables.

## Usage

``` r
methylationTrackServer(
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

  A `reactive` containing a
  [`methylationCohort()`](https://j-andrews7.github.io/sciVizModules/reference/methylationCohort.md),
  or anything it takes.

- hide.inputs:

  A character vector of input IDs to hide. The gridline inputs
  (`show.grid.x`, `show.grid.y`, `grid.color`) are always hidden.

- hide.tabs:

  A character vector of tab names to hide.

- defaults:

  A named list of default values used when resetting the inputs.
  Typically the same list passed to
  [`methylationTrackInputsUI()`](https://j-andrews7.github.io/sciVizModules/reference/methylationTrackInputsUI.md).

## Value

A `reactive` returning the source-data list.

## Details

A lookup runs only when what it depends on changes, so changing the
strips, the transcripts or the grouping redraws the figure without
reading the arrays again. A change to the colour scale, the empty-cell
colours, the sample font size or the Axes tab's lines needs no redraw at
all.

## See also

[`methylationTrack()`](https://j-andrews7.github.io/sciVizModules/reference/methylationTrack.md),
[`methylationTrackInputsUI()`](https://j-andrews7.github.io/sciVizModules/reference/methylationTrackInputsUI.md),
[`methylationTrackOutputUI()`](https://j-andrews7.github.io/sciVizModules/reference/methylationTrackOutputUI.md),
[`methylationTrackApp()`](https://j-andrews7.github.io/sciVizModules/reference/methylationTrackApp.md)

## Author

Jared Andrews

## Examples

``` r
library(sciVizModules)
if (interactive()) methylationTrackApp()
```
