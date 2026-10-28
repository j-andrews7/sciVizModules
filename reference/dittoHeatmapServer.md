# Server logic for the dittoHeatmap module

Pulls the expression of the chosen genes with
[`dittoSeq::dittoHeatmap()`](https://rdrr.io/pkg/dittoSeq/man/dittoHeatmap.html)
and draws it with
[`VizModules::ComplexHeatmap_HeatmapServer()`](https://j-andrews7.github.io/VizModules/reference/ComplexHeatmap_HeatmapServer.html),
ordering the cells by the chosen metadata column (with column clustering
off, as by default).

## Usage

``` r
dittoHeatmapServer(
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

  A `reactive` returning a `SingleCellExperiment`,
  `SummarizedExperiment` or `Seurat` object.

- hide.inputs:

  A character vector of input IDs to hide. The wrapped module's
  `matrix.cols` and `rowname.col` are always hidden, since the module
  sets them.

- hide.tabs:

  A character vector of tab names to hide.

- defaults:

  A named list of default values, typically the same list passed to
  [`dittoHeatmapInputsUI()`](https://j-andrews7.github.io/sciVizModules/reference/dittoHeatmapInputsUI.md).

## Value

The source-data reactive of
[`VizModules::ComplexHeatmap_HeatmapServer()`](https://j-andrews7.github.io/VizModules/reference/ComplexHeatmap_HeatmapServer.html):
the matrix drawn (unscaled), the inputs, and SVG/PNG renderers.

## See also

[`dittoSeq::dittoHeatmap()`](https://rdrr.io/pkg/dittoSeq/man/dittoHeatmap.html),
[`dittoHeatmapInputsUI()`](https://j-andrews7.github.io/sciVizModules/reference/dittoHeatmapInputsUI.md),
[`dittoHeatmapOutputUI()`](https://j-andrews7.github.io/sciVizModules/reference/dittoHeatmapOutputUI.md),
[`dittoHeatmapApp()`](https://j-andrews7.github.io/sciVizModules/reference/dittoHeatmapApp.md)

## Author

Jared Andrews

## Examples

``` r
library(sciVizModules)
if (interactive()) dittoHeatmapApp()
```
