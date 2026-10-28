# Fill inputs that have not reported yet

A wrapper reads its own inputs before its UI may exist (or an empty
[`numericInput()`](https://rdrr.io/pkg/shiny/man/numericInput.html)
reports `NA`); each such value falls back to the module's default.

## Usage

``` r
.sci_fill_inputs(vals, fallback)
```

## Arguments

- vals:

  A named list of input values.

- fallback:

  A named list of defaults covering the same names.

## Value

`vals`, with `NULL` and `NA` numeric entries replaced from `fallback`.

## Author

Jared Andrews
