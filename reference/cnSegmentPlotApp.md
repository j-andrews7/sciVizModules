# Create a standalone Shiny app for the cnSegmentPlot module

This function generates a Shiny application with the modular copy number
segment plotting components: an inputs panel for configuring the plot
and an output panel showing the interactive `plotly` figure.

## Usage

``` r
cnSegmentPlotApp(
  seg = NULL,
  defaults = NULL,
  hide.inputs = NULL,
  hide.tabs = NULL,
  title = "Array Copy Number Segments"
)
```

## Arguments

- seg:

  A `CNSegment` object, as returned by
  [`sesame::cnSegmentation()`](https://rdrr.io/pkg/sesame/man/cnSegmentation.html),
  or a named list of them to compare several samples. If `NULL` (the
  default), the bundled
  [example_cn_segment](https://j-andrews7.github.io/sciVizModules/reference/example_cn_segment.md)
  is used.

- defaults:

  An optional named list of default input values, applied over the
  gallery's settings when the example data is used.

- hide.inputs:

  A character vector of input IDs to hide. Their values are still
  initialized and used, but the controls are not shown in the UI.

- hide.tabs:

  A character vector of tab names to hide. Inputs in these tabs are
  still initialized and used.

- title:

  The app title.

## Value

A Shiny app object.

## Details

Unlike the upload-driven
[`VizModules::createModuleApp()`](https://j-andrews7.github.io/VizModules/reference/createModuleApp.html)
wrapper, this app takes the `CNSegment` object directly rather than a
single data frame. Gene labels and centromere positions are derived from
the object's `genomeInfo` (`genomeInfo$genes` and `genomeInfo$cytoBand`,
respectively).

Passing a named list of `CNSegment` objects, e.g.
`list(Tumor = seg1, Normal = seg2)`, stacks the samples vertically over
a shared genomic x-axis; the plot container is sized to fit them, and
the "Samples to Plot" control chooses which ones are shown.

When called with no arguments, the app launches with the bundled
[example_cn_segment](https://j-andrews7.github.io/sciVizModules/reference/example_cn_segment.md)
object, on the settings the module gallery
([`sciModuleGalleryApp()`](https://j-andrews7.github.io/sciVizModules/reference/sciModuleGalleryApp.md))
opens this module on; a curated set of cancer genes is labeled
initially.

## See also

[`cnSegmentPlotInputsUI()`](https://j-andrews7.github.io/sciVizModules/reference/cnSegmentPlotInputsUI.md),
[`cnSegmentPlotOutputUI()`](https://j-andrews7.github.io/sciVizModules/reference/cnSegmentPlotOutputUI.md),
[`cnSegmentPlotServer()`](https://j-andrews7.github.io/sciVizModules/reference/cnSegmentPlotServer.md),
[`cnSegmentPlot()`](https://j-andrews7.github.io/sciVizModules/reference/cnSegmentPlot.md)

## Author

Jared Andrews

## Examples

``` r
library(sciVizModules)
# Launch with the bundled example data:
app <- cnSegmentPlotApp()
if (interactive()) shiny::runApp(app)

# Compare several samples, stacked over a shared genomic x-axis:
data(example_cn_segment)
shifted <- example_cn_segment
shifted$bin.signals <- shifted$bin.signals + 0.2
app <- cnSegmentPlotApp(list(Tumor = example_cn_segment, Normal = shifted))
if (interactive()) shiny::runApp(app)
```
