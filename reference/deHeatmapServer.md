# Server logic for the deHeatmap module

Selects the top differentially expressed genes from a results table,
takes their transformed expression from the experiment, and draws it
with
[`VizModules::ComplexHeatmap_HeatmapServer()`](https://j-andrews7.github.io/VizModules/reference/ComplexHeatmap_HeatmapServer.html).
The transformation is kept in its own step, so changing the cut-offs
does not repeat it.

## Usage

``` r
deHeatmapServer(
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

  A `reactive` returning
  `list(object = <SummarizedExperiment>, results = <data frame>)`, or a
  `SummarizedExperiment` whose `rowData` holds the results.

- hide.inputs:

  A character vector of input IDs to hide. The wrapped module's
  `matrix.cols` and `rowname.col` are always hidden, since the module
  sets them.

- hide.tabs:

  A character vector of tab names to hide.

- defaults:

  A named list of default values, typically the same list passed to
  [`deHeatmapInputsUI()`](https://j-andrews7.github.io/sciVizModules/reference/deHeatmapInputsUI.md).

## Value

The source-data reactive of
[`VizModules::ComplexHeatmap_HeatmapServer()`](https://j-andrews7.github.io/VizModules/reference/ComplexHeatmap_HeatmapServer.html):
the matrix drawn (unscaled), the inputs, and SVG/PNG renderers.

## See also

[`deHeatmapInputsUI()`](https://j-andrews7.github.io/sciVizModules/reference/deHeatmapInputsUI.md),
[`deHeatmapOutputUI()`](https://j-andrews7.github.io/sciVizModules/reference/deHeatmapOutputUI.md),
[`deHeatmapApp()`](https://j-andrews7.github.io/sciVizModules/reference/deHeatmapApp.md)

## Author

Jared Andrews

## Examples

``` r
library(sciVizModules)
if (interactive()) deHeatmapApp()
```
