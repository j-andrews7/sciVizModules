# Fit the forest plot's model(s) and tidy the estimates

Covariates are renamed to syntactic placeholders before fitting so that
any column name works in the formula and every coefficient maps back to
exactly one covariate and level.

## Usage

``` r
.forest_estimates(
  data,
  model,
  covariates,
  time = NULL,
  status = NULL,
  outcome = NULL,
  multivariable = TRUE,
  conf.level = 0.95
)
```

## Arguments

- data:

  A data frame.

- model:

  One of `"cox"`, `"logistic"` or `"linear"`.

- covariates:

  Character vector of covariate column names.

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

- multivariable:

  Logical; fit all covariates in one model (`TRUE`) or each on its own
  (`FALSE`).

- conf.level:

  Confidence level for the intervals.

## Value

A data frame with one row per estimate: `variable`, `level`, `label`,
`estimate`, `conf.low`, `conf.high`, `p.value`, `n`, `reference`.

## Author

Jared Andrews
