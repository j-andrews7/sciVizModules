# Server logic for the mutationalProfile module

Reshapes a 96-channel substitution count matrix into a long table (see
[`mutationalProfileInputsUI()`](https://j-andrews7.github.io/sciVizModules/reference/mutationalProfileInputsUI.md))
and draws it with
[`VizModules::plotthis_BarPlotServer()`](https://j-andrews7.github.io/VizModules/reference/plotthis_BarPlotServer.html).

## Usage

``` r
mutationalProfileServer(
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

  A `reactive` returning a 96-channel substitution count matrix or data
  frame.

- hide.inputs:

  A character vector of input IDs to hide.

- hide.tabs:

  A character vector of tab names to hide.

- defaults:

  A named list of default values, merged over the spectrum defaults
  (user values win) and used to restore state on reset.

## Value

The value returned by
[`VizModules::plotthis_BarPlotServer()`](https://j-andrews7.github.io/VizModules/reference/plotthis_BarPlotServer.html).

## See also

[`mutationalProfileInputsUI()`](https://j-andrews7.github.io/sciVizModules/reference/mutationalProfileInputsUI.md),
[`mutationalProfileOutputUI()`](https://j-andrews7.github.io/sciVizModules/reference/mutationalProfileOutputUI.md),
[`mutationalProfileApp()`](https://j-andrews7.github.io/sciVizModules/reference/mutationalProfileApp.md)

## Author

Jared Andrews

## Examples

``` r
library(sciVizModules)
if (interactive()) mutationalProfileApp()
```
