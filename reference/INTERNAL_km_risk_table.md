# Number at risk in each stratum at given times

Number at risk in each stratum at given times

## Usage

``` r
.km_risk_table(fit, levels, times)
```

## Arguments

- fit:

  The `survfit` object.

- levels:

  The strata, in the fit's order.

- times:

  The times to count at.

## Value

A data frame with columns `stratum`, `time` and `n.risk`.

## Author

Jared Andrews
