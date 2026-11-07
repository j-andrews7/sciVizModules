# Build the module reset handler shared by dittoSeq modules

Resets the uniform Plotly/Axes/Legend/Lines tabs to their defaults, and
drops any manual edits to the plot. Individual modules add their own
data-tab resets on top of this.

## Usage

``` r
.ditto_reset_uniform(session, defaults = NULL, edit_store = NULL)
```

## Arguments

- session:

  The Shiny module session.

- defaults:

  A named list of default input values (may be `NULL`).

- edit_store:

  The store from
  [`VizModules::setup_manual_edits()`](https://j-andrews7.github.io/VizModules/reference/setup_manual_edits.html).

## Value

Invisibly `NULL`.

## Author

Jacob Martin, Jared Andrews
