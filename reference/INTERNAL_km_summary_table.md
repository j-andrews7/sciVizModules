# Per-stratum summary of a survival fit

The statistics table
[`survivalCurve()`](https://j-andrews7.github.io/sciVizModules/reference/survivalCurve.md)
attaches to its figure: subjects, events, median survival and its
confidence interval for each stratum, and the log-rank test across them.

## Usage

``` r
.km_summary_table(fit, levels, logrank = NULL)
```

## Arguments

- fit:

  The `survfit` object.

- levels:

  The strata, in the fit's order.

- logrank:

  The result of
  [`.km_logrank()`](https://j-andrews7.github.io/sciVizModules/reference/INTERNAL_km_logrank.md),
  or `NULL`.

## Value

A data frame with one row per stratum.

## Author

Jared Andrews
