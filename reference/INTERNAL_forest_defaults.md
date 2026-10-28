# Default inputs for the forest plot module

Shared by
[`forestPlotInputsUI()`](https://j-andrews7.github.io/sciVizModules/reference/forestPlotInputsUI.md)
and
[`forestPlotServer()`](https://j-andrews7.github.io/sciVizModules/reference/forestPlotServer.md)
so the initial and reset states agree. Time and status are detected the
way the survival curve module detects them, and the first three
remaining columns become the covariates. User-supplied values win.

## Usage

``` r
.forest_defaults(data, defaults = NULL)
```

## Arguments

- data:

  The data frame.

- defaults:

  A named list of user defaults, or `NULL`.

## Value

A named list of defaults.

## Author

Jared Andrews
