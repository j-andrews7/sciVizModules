# Non-compartmental analysis of one concentration-time profile

Computes the standard NCA parameters the way PKNCA does by default:

- Cmax / Tmax (first time of the maximum), Clast / Tlast (last
  measurable concentration).

- AUC from the first to the last measurable time by the linear
  trapezoid, or "linear-up / log-down" (log trapezoid on decreasing
  segments between positive concentrations).

- lambda-z by log-linear regression on the terminal points after Tmax:
  the last 3 or more points with the best adjusted R-squared, preferring
  more points among fits within `adj.r2.tolerance` of the best, and
  requiring a positive slope estimate of elimination.

- Half-life = ln 2 / lambda-z; AUC to infinity = AUClast + Clast /
  lambda-z; CL/F = dose / AUCinf and Vz/F = dose / (lambda-z AUCinf)
  when a dose is given.

## Usage

``` r
.pk_nca(
  time,
  conc,
  dose = NULL,
  auc.method = "lin up/log down",
  min.points = 3,
  adj.r2.tolerance = 1e-04
)
```

## Arguments

- time, conc:

  Numeric vectors of one subject's sampling times and concentrations.

- dose:

  Dose, or `NULL`.

- auc.method:

  `"lin up/log down"` or `"linear"`.

- min.points:

  Minimum points in the terminal regression.

- adj.r2.tolerance:

  Tolerance on adjusted R-squared when preferring more points.

## Value

A one-row data frame of NCA parameters, with the terminal fit's
intercept and first time for drawing it.

## Author

Jared Andrews
