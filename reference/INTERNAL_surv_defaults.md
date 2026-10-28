# Default inputs for the survivalCurve module

Shared by
[`survivalCurveInputsUI()`](https://j-andrews7.github.io/sciVizModules/reference/survivalCurveInputsUI.md)
and the module's Reset, so the two cannot drift. The time and status
columns are detected from the data unless given.

## Usage

``` r
.surv_defaults(data, defaults = NULL)
```

## Arguments

- data:

  The survival data frame.

- defaults:

  A named list of user defaults, or `NULL`.

## Value

A named list of defaults.

## Author

Jared Andrews
