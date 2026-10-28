# Pairwise log-rank tests between strata

Each pair of strata is compared on its own subjects, as survminer's
`pairwise_survdiff()` does: a log-rank test, its p-value adjusted across
the comparisons made. Each pair also gets the hazard ratio of its second
group against its first, from a Cox model of the pair, with a 95% Wald
interval. The hazard ratio is `NA` when either group has no events, or
when the model's estimate runs off to infinity (a tiny group whose
events all come first, say), since there is no finite estimate to
report.

## Usage

``` r
.km_pairwise(df, levels, pairs = NULL, p.adjust.method = "holm")
```

## Arguments

- df:

  The fitted data, with `.surv_time`, `.surv_status` and `.stratum`.

- levels:

  The strata, in the fit's order.

- pairs:

  A list of length-2 character vectors naming the pairs to test, or
  `NULL` for every pair, in level order. A pair naming a stratum not in
  `levels`, or repeating another in either order, is dropped.

- p.adjust.method:

  A [`stats::p.adjust()`](https://rdrr.io/r/stats/p.adjust.html) method.

## Value

A data frame with one row per pair: `group1`, `group2`, `n1`, `n2`,
`events1`, `events2`, `test`, `chisq`, `p.value`, `p.adj`,
`p.adjust.method`, `hr` (`group2` relative to `group1`), `hr.lower` and
`hr.upper`. `NULL` when there is no pair to test.

## Author

Jared Andrews
