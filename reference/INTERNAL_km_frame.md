# Kaplan-Meier estimates of a survival fit, one row per time

Unpacks a
[`survival::survfit()`](https://rdrr.io/pkg/survival/man/survfit.html)
fit into a frame per stratum, with a row at time 0 (survival 1) leading
each stratum, and applies a curve transformation to the estimate and its
bounds as survminer does. A transformation that reverses the scale
(`"event"`, `"cumhaz"`) swaps the bounds back so `lower <= upper`, and a
value it cannot represent (`-log(0)`) becomes `NA`.

## Usage

``` r
.km_frame(fit, levels, fun = NULL)
```

## Arguments

- fit:

  A `survfit` object fitted with one stratum per level of `levels`.

- levels:

  The strata, in the fit's order.

- fun:

  `NULL` (survival probability), `"pct"`, `"event"` or `"cumhaz"`.

## Value

A data frame with columns `stratum` (a factor), `time`, `surv`, `lower`,
`upper`, `n.risk`, `n.event` and `n.censor`.

## Author

Jared Andrews
