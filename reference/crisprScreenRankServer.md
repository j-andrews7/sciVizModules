# Server logic for the crisprScreenRank module

Ranks the genes of a MAGeCK RRA or MLE gene summary by the plotted
statistic, signed so that depleted genes fall on the left and enriched
genes on the right, flags hits by FDR, and plots them through
[`VizModules::dittoViz_scatterPlotServer()`](https://j-andrews7.github.io/VizModules/reference/dittoViz_scatterPlotServer.html).
Its `fig.fn` hook titles the axes and draws the FDR cut-offs. Genes are
labelled through the scatter module's Annotations tab.

## Usage

``` r
crisprScreenRankServer(
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

  A `reactive` containing a MAGeCK RRA or MLE gene summary, from
  [`read_mageck()`](https://j-andrews7.github.io/sciVizModules/reference/read_mageck.md)
  or read with
  [`read.delim()`](https://rdrr.io/r/utils/read.table.html).

- hide.inputs:

  A character vector of input IDs to hide.

- hide.tabs:

  A character vector of tab names to hide. Default hides the scatter
  module's "Trajectory", "Facet" and "Marginals" tabs; ranks are evenly
  spaced by construction, so their distribution is uninformative.

- defaults:

  A named list of default values, merged over the rank-plot defaults
  (user values win) and used to restore state on reset.

## Value

The value returned by
[`VizModules::dittoViz_scatterPlotServer()`](https://j-andrews7.github.io/VizModules/reference/dittoViz_scatterPlotServer.html).

## See also

[`read_mageck()`](https://j-andrews7.github.io/sciVizModules/reference/read_mageck.md),
[`crisprScreenRankInputsUI()`](https://j-andrews7.github.io/sciVizModules/reference/crisprScreenRankInputsUI.md),
[`crisprScreenRankOutputUI()`](https://j-andrews7.github.io/sciVizModules/reference/crisprScreenRankOutputUI.md),
[`crisprScreenRankApp()`](https://j-andrews7.github.io/sciVizModules/reference/crisprScreenRankApp.md)

## Author

Jared Andrews

## Examples

``` r
library(sciVizModules)
if (interactive()) crisprScreenRankApp()
```
