# Extract Michaelis-Menten parameters (K and Vmax) from a stats object

Pulls the Michaelis constant (`K`) and maximum velocity (`Vmax`) from a
fitted model or a supplied set of coefficients, for use in plot
annotations.

## Usage

``` r
.mm_params(stats)
```

## Arguments

- stats:

  A fitted model whose
  [`stats::coef()`](https://rdrr.io/r/stats/coef.html) returns named `K`
  and `Vm` / `Vmax` coefficients (e.g. an `nls` fit of
  `v ~ Vm * S / (K + S)`), or a named numeric vector / list containing
  those values. `NULL` returns `NULL`.

## Value

A named list with elements `K` and `Vmax` (each possibly `NA` when not
found), or `NULL` when `stats` is `NULL`.

## Author

Jacob Martin
