# Server logic for the gseaEnrichmentPlot module

Renders
[`gseaEnrichmentPlot()`](https://j-andrews7.github.io/sciVizModules/reference/gseaEnrichmentPlot.md).
The per-gene-set summary (enrichment score, NES, adjusted p-value, size
and leading edge) is included in the source-data download as the
statistics table.

## Usage

``` r
gseaEnrichmentPlotServer(
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

  A `reactive` returning an fgsea bundle or a clusterProfiler
  `gseaResult`.

- hide.inputs:

  A character vector of input IDs to hide.

- hide.tabs:

  A character vector of tab names to hide.

- defaults:

  A named list of default values used when resetting the inputs.
  Typically the same list passed to
  [`gseaEnrichmentPlotInputsUI()`](https://j-andrews7.github.io/sciVizModules/reference/gseaEnrichmentPlotInputsUI.md).

## Value

A `reactive` returning the source-data list.

## See also

[`gseaEnrichmentPlot()`](https://j-andrews7.github.io/sciVizModules/reference/gseaEnrichmentPlot.md),
[`gseaEnrichmentPlotInputsUI()`](https://j-andrews7.github.io/sciVizModules/reference/gseaEnrichmentPlotInputsUI.md),
[`gseaEnrichmentPlotOutputUI()`](https://j-andrews7.github.io/sciVizModules/reference/gseaEnrichmentPlotOutputUI.md),
[`gseaEnrichmentPlotApp()`](https://j-andrews7.github.io/sciVizModules/reference/gseaEnrichmentPlotApp.md)

## Author

Jared Andrews

## Examples

``` r
library(sciVizModules)
if (interactive()) gseaEnrichmentPlotApp()
```
