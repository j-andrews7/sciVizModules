# Server logic for volcanoPlot module

This module builds upon the
[`VizModules::dittoViz_scatterPlotServer()`](https://j-andrews7.github.io/VizModules/reference/dittoViz_scatterPlotServer.html)
to provide a volcano plot with interactive significance and fold-change
thresholding.

## Usage

``` r
volcanoPlotServer(
  id,
  data,
  hide.inputs = NULL,
  hide.tabs = c("Trajectory", "Facet"),
  defaults = NULL
)
```

## Arguments

- id:

  The ID for the Shiny module.

- data:

  A `reactive` containing the data frame to plot. Must contain effect
  size (e.g., log2FoldChange) and significance (e.g., padj) columns.

- hide.inputs:

  A character vector of input IDs to hide. The continuous colour-scale
  and contour controls are always hidden, since a volcano plot colours
  by the discrete `group` column.

- hide.tabs:

  A character vector of tab names to hide. Default hides: "Trajectory"
  and "Facet".

- defaults:

  A named list of default values. Merged over the module's volcano
  defaults (user values win) and used to restore state on reset. Group
  colours are set with `color.up` / `color.down` / `color.ns`, or
  directly with a named `color.panel` vector.

## Value

The `moduleServer` function for the volcanoPlot module.

## See also

[`VizModules::dittoViz_scatterPlotServer()`](https://j-andrews7.github.io/VizModules/reference/dittoViz_scatterPlotServer.html),
[`volcanoPlotInputsUI()`](https://j-andrews7.github.io/sciVizModules/reference/volcanoPlotInputsUI.md),
[`volcanoPlotOutputUI()`](https://j-andrews7.github.io/sciVizModules/reference/volcanoPlotOutputUI.md),
[`volcanoPlotApp()`](https://j-andrews7.github.io/sciVizModules/reference/volcanoPlotApp.md)

## Author

Jacob Martin

## Examples

``` r
library(sciVizModules)
if (interactive()) volcanoPlotApp()
```
