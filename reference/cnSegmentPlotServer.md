# Server logic for the cnSegmentPlot module

This module builds a genome-wide copy number segment plot with
[`cnSegmentPlot()`](https://j-andrews7.github.io/sciVizModules/reference/cnSegmentPlot.md)
from a `CNSegment` object (as returned by
[`sesame::cnSegmentation()`](https://rdrr.io/pkg/sesame/man/cnSegmentation.html)),
renders it as an interactive `plotly` figure, and adds user-selected
genes as draggable Plotly annotations.

## Usage

``` r
cnSegmentPlotServer(
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

  A `reactive` returning a `CNSegment` object (as returned by
  [`sesame::cnSegmentation()`](https://rdrr.io/pkg/sesame/man/cnSegmentation.html)),
  or a named list of them to compare several samples stacked vertically
  over a shared genomic x-axis. Gene labels are taken from
  `seg$genomeInfo$genes` and chromosome tick/guide positions from
  `seg$genomeInfo$cytoBand`; genes overlapping each bin are read from
  the `bin.coords$genes` metadata column when present.

- hide.inputs:

  A character vector of input IDs to hide.

- hide.tabs:

  A character vector of tab names to hide.

- defaults:

  A named list of default values used when resetting the inputs.
  Individual entries may be a
  [`shiny::reactive()`](https://rdrr.io/pkg/shiny/man/reactive.html)/`reactiveVal`,
  in which case the parameter follows the parent app's state and is
  resolved server-side (a single render, control kept in sync and still
  editable); see
  [`VizModules::setup_reactive_defaults()`](https://j-andrews7.github.io/VizModules/reference/setup_reactive_defaults.html).

## Value

The `moduleServer` function for the cnSegmentPlot module.

## See also

[`cnSegmentPlot()`](https://j-andrews7.github.io/sciVizModules/reference/cnSegmentPlot.md),
[`cnSegmentPlotInputsUI()`](https://j-andrews7.github.io/sciVizModules/reference/cnSegmentPlotInputsUI.md),
[`cnSegmentPlotOutputUI()`](https://j-andrews7.github.io/sciVizModules/reference/cnSegmentPlotOutputUI.md),
[`cnSegmentPlotApp()`](https://j-andrews7.github.io/sciVizModules/reference/cnSegmentPlotApp.md)

## Author

Jared Andrews

## Examples

``` r
library(sciVizModules)
if (interactive()) cnSegmentPlotApp()
```
