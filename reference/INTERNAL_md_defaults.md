# Default inputs for the mdTrajectoryMetrics module

Picks the
[`read_xvg()`](https://j-andrews7.github.io/sciVizModules/reference/read_xvg.md)
columns when present, otherwise the first two numeric columns, and
panels by `metric` only when there is more than one.

## Usage

``` r
.md_defaults(data, defaults = NULL)
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
