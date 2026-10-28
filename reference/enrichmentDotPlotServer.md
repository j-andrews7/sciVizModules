# Server logic for the enrichmentDotPlot module

This module builds an enrichment dot plot with
[`VizModules::plotthis_DotPlotServer()`](https://j-andrews7.github.io/VizModules/reference/plotthis_DotPlotServer.html)
and renders it as an interactive `plotly` figure. The incoming
enrichment results are augmented with a numeric `GeneRatio` column, a
`neg_log10_pvalue` column, and a categorical grouping column before
being handed to the wrapped DotPlot server (see
[`enrichmentDotPlotInputsUI()`](https://j-andrews7.github.io/sciVizModules/reference/enrichmentDotPlotInputsUI.md)
for details).

## Usage

``` r
enrichmentDotPlotServer(
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

  A `reactive` returning the enrichment results data frame.

- hide.inputs:

  A character vector of input IDs to hide.

- hide.tabs:

  A character vector of tab names to hide.

- defaults:

  A named list of default values used when resetting the inputs.
  Typically the same list passed to
  [`enrichmentDotPlotInputsUI()`](https://j-andrews7.github.io/sciVizModules/reference/enrichmentDotPlotInputsUI.md).

## Value

The `moduleServer` function for the enrichmentDotPlot module.

## See also

[`plotthis::DotPlot()`](https://pwwang.github.io/plotthis/reference/dotplot.html),
[`VizModules::plotthis_DotPlotServer()`](https://j-andrews7.github.io/VizModules/reference/plotthis_DotPlotServer.html),
[`enrichmentDotPlotInputsUI()`](https://j-andrews7.github.io/sciVizModules/reference/enrichmentDotPlotInputsUI.md),
[`enrichmentDotPlotOutputUI()`](https://j-andrews7.github.io/sciVizModules/reference/enrichmentDotPlotOutputUI.md),
[`enrichmentDotPlotApp()`](https://j-andrews7.github.io/sciVizModules/reference/enrichmentDotPlotApp.md)

## Author

Jacob Martin, Jared Andrews

## Examples

``` r
library(sciVizModules)
if (interactive()) enrichmentDotPlotApp()
```
