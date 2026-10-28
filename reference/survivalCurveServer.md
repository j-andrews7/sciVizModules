# Server logic for survivalCurve module

This module fits a Kaplan-Meier survival curve with
[`survival::survfit()`](https://rdrr.io/pkg/survival/man/survfit.html)
and renders it as an interactive `plotly` figure via
[`survivalCurve()`](https://j-andrews7.github.io/sciVizModules/reference/survivalCurve.md).
The per-stratum summary (subjects, events, median survival, log-rank
test) is included in the source-data download as the statistics table
(`<name>_stats_strata.csv` while pairwise comparisons are on, beside the
comparison table, `<name>_stats_pairwise.csv`).

## Usage

``` r
survivalCurveServer(
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

  A `reactive` containing the data frame to plot. Must contain a numeric
  follow-up time column and an event/status column. Values that are not
  data frames are coerced with
  [`as.data.frame()`](https://rdrr.io/r/base/as.data.frame.html); a
  `NULL` value is treated as "not ready yet" and the module waits for
  data.

- hide.inputs:

  A character vector of input IDs to hide. These will still be
  initialized and their values passed to the plot function, but the user
  will not be able to see/adjust them in the UI.

- hide.tabs:

  A character vector of tab names to hide.

- defaults:

  A named list of default values used when resetting the inputs.
  Typically the same list passed to
  [`survivalCurveInputsUI()`](https://j-andrews7.github.io/sciVizModules/reference/survivalCurveInputsUI.md).

## Value

A `reactive` returning the source-data list.

## See also

[`survival::survfit()`](https://rdrr.io/pkg/survival/man/survfit.html),
[`survivalCurve()`](https://j-andrews7.github.io/sciVizModules/reference/survivalCurve.md),
[`survivalCurveInputsUI()`](https://j-andrews7.github.io/sciVizModules/reference/survivalCurveInputsUI.md),
[`survivalCurveOutputUI()`](https://j-andrews7.github.io/sciVizModules/reference/survivalCurveOutputUI.md),
[`survivalCurveApp()`](https://j-andrews7.github.io/sciVizModules/reference/survivalCurveApp.md)

## Author

Jacob Martin, Jared Andrews

## Examples

``` r
library(sciVizModules)
if (interactive()) survivalCurveApp()
```
