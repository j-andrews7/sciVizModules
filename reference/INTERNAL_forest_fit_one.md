# Fit one forest model and return its tidy rows

Fit one forest model and return its tidy rows

## Usage

``` r
.forest_fit_one(data, model, covs, time, status, outcome, conf.level)
```

## Arguments

- data:

  A data frame.

- model:

  One of `"cox"`, `"logistic"` or `"linear"`.

- covs:

  The covariates in this model.

- time, status:

  For `model = "cox"`, the follow-up time column and the event column.
  The event column may be 0/1 (1 = event), 1/2 (2 = event, the
  [`survival::Surv()`](https://rdrr.io/pkg/survival/man/Surv.html)
  convention), logical, or a factor/character with an event label such
  as `"dead"`.

- outcome:

  For `"logistic"`, a binary outcome column (0/1, logical, or a
  two-level factor/character whose second level is the event); for
  `"linear"`, a numeric outcome column.

- conf.level:

  Confidence level for the intervals.

## Value

A data frame as described in
[`.forest_estimates()`](https://j-andrews7.github.io/sciVizModules/reference/INTERNAL_forest_estimates.md).

## Author

Jared Andrews
