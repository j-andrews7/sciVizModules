# Require a data frame for a native module

The `validate` function the data-frame modules built on
[`.sci_plot_server()`](https://j-andrews7.github.io/sciVizModules/reference/INTERNAL_sci_plot_server.md)
pass to it.

## Usage

``` r
.sci_require_df(x, arg = "data")
```

## Arguments

- x:

  The module's data.

- arg:

  Argument name for the error message.

## Value

`x` as a data frame.

## Author

Jared Andrews
