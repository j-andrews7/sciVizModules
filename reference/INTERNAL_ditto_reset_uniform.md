# Build the module reset handler shared by dittoSeq modules

Resets the uniform Plotly/Axes/Legend/Lines tabs to their defaults.
Individual modules add their own data-tab resets on top of this.

## Usage

``` r
.ditto_reset_uniform(session, defaults = NULL)
```

## Arguments

- session:

  The Shiny module session.

- defaults:

  A named list of default input values (may be `NULL`).

## Value

Invisibly `NULL`.

## Author

Jacob Martin, Jared Andrews
