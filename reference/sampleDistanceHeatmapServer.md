# Server logic for the sampleDistanceHeatmap module

Transforms the assay of a `SummarizedExperiment`, computes the distances
(or correlations) between samples over its most variable genes, orders
the samples by clustering those distances, and draws the result with
[`VizModules::ComplexHeatmap_HeatmapServer()`](https://j-andrews7.github.io/VizModules/reference/ComplexHeatmap_HeatmapServer.html).
The transformation is kept in its own step, so changing the measure or
the gene count does not repeat it.

## Usage

``` r
sampleDistanceHeatmapServer(
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

  A `reactive` returning a `SummarizedExperiment` of counts.

- hide.inputs:

  A character vector of input IDs to hide. The wrapped module's
  `matrix.cols` and `rowname.col` are always hidden, since the module
  sets them.

- hide.tabs:

  A character vector of tab names to hide.

- defaults:

  A named list of default values, typically the same list passed to
  [`sampleDistanceHeatmapInputsUI()`](https://j-andrews7.github.io/sciVizModules/reference/sampleDistanceHeatmapInputsUI.md).

## Value

The source-data reactive of
[`VizModules::ComplexHeatmap_HeatmapServer()`](https://j-andrews7.github.io/VizModules/reference/ComplexHeatmap_HeatmapServer.html):
the matrix drawn, the inputs, and SVG/PNG renderers.

## See also

[`sampleDistanceHeatmapInputsUI()`](https://j-andrews7.github.io/sciVizModules/reference/sampleDistanceHeatmapInputsUI.md),
[`sampleDistanceHeatmapOutputUI()`](https://j-andrews7.github.io/sciVizModules/reference/sampleDistanceHeatmapOutputUI.md),
[`sampleDistanceHeatmapApp()`](https://j-andrews7.github.io/sciVizModules/reference/sampleDistanceHeatmapApp.md)

## Author

Jared Andrews

## Examples

``` r
library(sciVizModules)
if (interactive()) sampleDistanceHeatmapApp()
```
