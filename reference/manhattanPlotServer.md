# Server logic for the manhattanPlot module

Lays the variants of GWAS summary statistics end to end along the
genome, thins the non-significant ones if asked, and plots them through
[`VizModules::dittoViz_scatterPlotServer()`](https://j-andrews7.github.io/VizModules/reference/dittoViz_scatterPlotServer.html).
Its `fig.fn` hook labels the x-axis with chromosome names and draws the
significance lines.

## Usage

``` r
manhattanPlotServer(
  id,
  data,
  hide.inputs = NULL,
  hide.tabs = c("Trajectory", "Marginals"),
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
  module's "Trajectory" and "Marginals" tabs; the distribution of
  genomic positions along the x-axis says nothing about the
  associations.

- defaults:

  A named list of default values, merged over the Manhattan defaults
  (user values win) and used to restore state on reset.

## Value

The value returned by
[`VizModules::dittoViz_scatterPlotServer()`](https://j-andrews7.github.io/VizModules/reference/dittoViz_scatterPlotServer.html).

## See also

[`manhattanPlotInputsUI()`](https://j-andrews7.github.io/sciVizModules/reference/manhattanPlotInputsUI.md),
[`manhattanPlotOutputUI()`](https://j-andrews7.github.io/sciVizModules/reference/manhattanPlotOutputUI.md),
[`manhattanPlotApp()`](https://j-andrews7.github.io/sciVizModules/reference/manhattanPlotApp.md),
[`gwasQQPlotServer()`](https://j-andrews7.github.io/sciVizModules/reference/gwasQQPlotServer.md)

## Author

Jared Andrews

## Examples

``` r
library(sciVizModules)
if (interactive()) manhattanPlotApp()
```
