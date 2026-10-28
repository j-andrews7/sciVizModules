# Server logic for the mdTrajectoryMetrics module

Renders
[`mdTrajectoryMetrics()`](https://j-andrews7.github.io/sciVizModules/reference/mdTrajectoryMetrics.md).
The per-group summary (points, mean, SD and second-half mean) is
included in the source-data download as the statistics table.

## Usage

``` r
mdTrajectoryMetricsServer(
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

  A `reactive` returning a data frame, e.g. from
  [`read_xvg()`](https://j-andrews7.github.io/sciVizModules/reference/read_xvg.md).

- hide.inputs:

  A character vector of input IDs to hide.

- hide.tabs:

  A character vector of tab names to hide.

- defaults:

  A named list of default values used when resetting the inputs.
  Typically the same list passed to
  [`mdTrajectoryMetricsInputsUI()`](https://j-andrews7.github.io/sciVizModules/reference/mdTrajectoryMetricsInputsUI.md).

## Value

A `reactive` returning the source-data list.

## See also

[`mdTrajectoryMetrics()`](https://j-andrews7.github.io/sciVizModules/reference/mdTrajectoryMetrics.md),
[`read_xvg()`](https://j-andrews7.github.io/sciVizModules/reference/read_xvg.md),
[`mdTrajectoryMetricsInputsUI()`](https://j-andrews7.github.io/sciVizModules/reference/mdTrajectoryMetricsInputsUI.md),
[`mdTrajectoryMetricsOutputUI()`](https://j-andrews7.github.io/sciVizModules/reference/mdTrajectoryMetricsOutputUI.md),
[`mdTrajectoryMetricsApp()`](https://j-andrews7.github.io/sciVizModules/reference/mdTrajectoryMetricsApp.md)

## Author

Jared Andrews

## Examples

``` r
library(sciVizModules)
if (interactive()) mdTrajectoryMetricsApp()
```
