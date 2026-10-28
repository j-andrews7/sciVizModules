# Server logic for maPlot module

This module builds upon the
[`VizModules::dittoViz_scatterPlotServer()`](https://j-andrews7.github.io/VizModules/reference/dittoViz_scatterPlotServer.html)
to provide an MA plot (log fold change versus mean abundance) with
interactive significance and fold-change thresholding.

## Usage

``` r
maPlotServer(
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

  A `reactive` containing the data frame to plot. Must contain a mean
  abundance (e.g., baseMean, logCPM, AveExpr), effect size (e.g.,
  log2FoldChange, logFC), and significance (e.g., padj, FDR) columns.

- hide.inputs:

  A character vector of input IDs to hide. The continuous colour-scale
  and contour controls are always hidden, since an MA plot colours by
  the discrete `group` column.

- hide.tabs:

  A character vector of tab names to hide. Default hides: "Trajectory"
  and "Facet".

- defaults:

  A named list of default values. Merged over the module's MA defaults
  (user values win) and used to restore state on reset. Group colours
  are set with `color.up` / `color.down` / `color.ns`, or directly with
  a named `color.panel` vector.

## Value

The `moduleServer` function for the maPlot module.

## See also

[`VizModules::dittoViz_scatterPlotServer()`](https://j-andrews7.github.io/VizModules/reference/dittoViz_scatterPlotServer.html),
[`maPlotInputsUI()`](https://j-andrews7.github.io/sciVizModules/reference/maPlotInputsUI.md),
[`maPlotOutputUI()`](https://j-andrews7.github.io/sciVizModules/reference/maPlotOutputUI.md),
[`maPlotApp()`](https://j-andrews7.github.io/sciVizModules/reference/maPlotApp.md)

## Author

Jared Andrews

## Examples

``` r
library(sciVizModules)
if (interactive()) maPlotApp()
```
