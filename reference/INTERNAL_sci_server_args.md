# A module server's arguments, leaving out the ones not given

Several servers hide tabs by default
([`volcanoPlotServer()`](https://j-andrews7.github.io/sciVizModules/reference/volcanoPlotServer.md)
hides "Trajectory" and "Facet"), so a `hide.tabs = NULL` passed through
would show them; an argument that is `NULL` is left to the server's own
default.

## Usage

``` r
.sci_server_args(
  id,
  data,
  defaults = NULL,
  hide.inputs = NULL,
  hide.tabs = NULL
)
```

## Arguments

- id:

  The module id.

- data:

  The data reactive.

- defaults, hide.inputs, hide.tabs:

  Passed on when not `NULL`.

## Value

A named list for [`do.call()`](https://rdrr.io/r/base/do.call.html).

## Author

Jared Andrews
