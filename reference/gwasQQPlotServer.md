# Server logic for the gwasQQPlot module

Computes observed against expected -log10(p) from GWAS summary
statistics, thins the points if asked, and plots them through
[`VizModules::dittoViz_scatterPlotServer()`](https://j-andrews7.github.io/VizModules/reference/dittoViz_scatterPlotServer.html).
Its `fig.fn` hook adds the confidence band and lambda GC.

## Usage

``` r
gwasQQPlotServer(
  id,
  data,
  hide.inputs = NULL,
  hide.tabs = c("Trajectory", "Facet", "Marginals"),
  defaults = NULL
)
```

## Arguments

- id:

  The ID for the Shiny module.

- data:

  A `reactive` containing a data frame of GWAS summary statistics.

- hide.inputs:

  A character vector of input IDs to hide.

- hide.tabs:

  A character vector of tab names to hide. Default hides the scatter
  module's "Trajectory", "Facet" and "Marginals" tabs; the expected
  quantiles are evenly spaced by construction, so their distribution is
  uninformative.

- defaults:

  A named list of default values, merged over the QQ defaults (user
  values win) and used to restore state on reset.

## Value

The value returned by
[`VizModules::dittoViz_scatterPlotServer()`](https://j-andrews7.github.io/VizModules/reference/dittoViz_scatterPlotServer.html).

## See also

[`gwasQQPlotInputsUI()`](https://j-andrews7.github.io/sciVizModules/reference/gwasQQPlotInputsUI.md),
[`gwasQQPlotOutputUI()`](https://j-andrews7.github.io/sciVizModules/reference/gwasQQPlotOutputUI.md),
[`gwasQQPlotApp()`](https://j-andrews7.github.io/sciVizModules/reference/gwasQQPlotApp.md),
[`manhattanPlotServer()`](https://j-andrews7.github.io/sciVizModules/reference/manhattanPlotServer.md)

## Author

Jared Andrews

## Examples

``` r
library(sciVizModules)
if (interactive()) gwasQQPlotApp()
```
