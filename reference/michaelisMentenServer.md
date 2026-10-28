# Server logic for the michaelisMenten module

This module builds a Michaelis-Menten plot with
[`michaelisMentenPlot()`](https://j-andrews7.github.io/sciVizModules/reference/michaelisMentenPlot.md),
renders it as an interactive `plotly` figure, and (optionally) annotates
the estimated Michaelis constant (K) and maximum velocity (Vmax) onto
the plot.

## Usage

``` r
michaelisMentenServer(
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

  A `reactive` returning a list with three elements:

  `data`

  :   The plotting data frame (observed points).

  `model`

  :   A data frame of fitted-line coordinates (`mml`) sharing the same
      x/y columns as `data`.

  `stats`

  :   Optional. A fitted model (e.g. an `nls` fit of
      `v ~ Vm * S / (K + S)`) or named coefficients from which K and
      Vmax are extracted for annotation. May be `NULL`.

  The list may also be unnamed with positions 1 = data, 2 = model, 3 =
  stats.

- hide.inputs:

  A character vector of input IDs to hide.

- hide.tabs:

  A character vector of tab names to hide.

- defaults:

  A named list of default values used when resetting the inputs.

## Value

The `moduleServer` function for the michaelisMenten module.

## Details

The K/Vmax annotations are added here in the server using plotly
[`plotly::add_annotations()`](https://rdrr.io/pkg/plotly/man/add_annotations.html)
rather than inside the plotting function, so the annotation logic is
kept separate from the ggplot construction.

## See also

[`michaelisMentenPlot()`](https://j-andrews7.github.io/sciVizModules/reference/michaelisMentenPlot.md),
[`michaelisMentenInputsUI()`](https://j-andrews7.github.io/sciVizModules/reference/michaelisMentenInputsUI.md),
[`michaelisMentenOutputUI()`](https://j-andrews7.github.io/sciVizModules/reference/michaelisMentenOutputUI.md),
[`michaelisMentenApp()`](https://j-andrews7.github.io/sciVizModules/reference/michaelisMentenApp.md)

## Author

Jacob Martin

## Examples

``` r
library(sciVizModules)
if (interactive()) michaelisMentenApp()
```
