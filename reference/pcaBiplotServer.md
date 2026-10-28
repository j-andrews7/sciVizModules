# Server logic for the pcaBiplot module

Plots the sample scores of a PCAtools `pca` object through
[`VizModules::dittoViz_scatterPlotServer()`](https://j-andrews7.github.io/VizModules/reference/dittoViz_scatterPlotServer.html),
and uses its `fig.fn` hook to title the axes with each component's
explained variance and to draw the loading arrows. The scatter module's
Trajectory tab draws arrowed paths through the median scores of chosen
sample groups (a time course, say), and its Marginals tab draws each
group's distribution along each component.

## Usage

``` r
pcaBiplotServer(
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

  A `reactive` returning a PCAtools `pca` object.

- hide.inputs:

  A character vector of input IDs to hide.

- hide.tabs:

  A character vector of tab names to hide. None are hidden by default.

- defaults:

  A named list of default values, merged over the biplot defaults (user
  values win) and used to restore state on reset.

## Value

The value returned by
[`VizModules::dittoViz_scatterPlotServer()`](https://j-andrews7.github.io/VizModules/reference/dittoViz_scatterPlotServer.html).

## See also

[`PCAtools::biplot()`](https://rdrr.io/pkg/PCAtools/man/biplot.html),
[`pcaBiplotInputsUI()`](https://j-andrews7.github.io/sciVizModules/reference/pcaBiplotInputsUI.md),
[`pcaBiplotOutputUI()`](https://j-andrews7.github.io/sciVizModules/reference/pcaBiplotOutputUI.md),
[`pcaBiplotApp()`](https://j-andrews7.github.io/sciVizModules/reference/pcaBiplotApp.md)

## Author

Jared Andrews

## Examples

``` r
library(sciVizModules)
if (interactive()) pcaBiplotApp()
```
