# Server logic for the rocCurve module

Renders
[`rocCurve()`](https://j-andrews7.github.io/sciVizModules/reference/rocCurve.md).
The per-predictor table (AUC, confidence interval, Youden cut-off,
sensitivity, specificity) is included in the source-data download as the
statistics table.

## Usage

``` r
rocCurveServer(id, data, hide.inputs = NULL, hide.tabs = NULL, defaults = NULL)
```

## Arguments

- id:

  The ID for the Shiny module.

- data:

  A `reactive` containing the data frame.

- hide.inputs:

  A character vector of input IDs to hide.

- hide.tabs:

  A character vector of tab names to hide.

- defaults:

  A named list of default values used when resetting the inputs.
  Typically the same list passed to
  [`rocCurveInputsUI()`](https://j-andrews7.github.io/sciVizModules/reference/rocCurveInputsUI.md).

## Value

A `reactive` returning the source-data list.

## See also

[`rocCurve()`](https://j-andrews7.github.io/sciVizModules/reference/rocCurve.md),
[`rocCurveInputsUI()`](https://j-andrews7.github.io/sciVizModules/reference/rocCurveInputsUI.md),
[`rocCurveOutputUI()`](https://j-andrews7.github.io/sciVizModules/reference/rocCurveOutputUI.md),
[`rocCurveApp()`](https://j-andrews7.github.io/sciVizModules/reference/rocCurveApp.md)

## Author

Jared Andrews

## Examples

``` r
library(sciVizModules)
if (interactive()) rocCurveApp()
```
