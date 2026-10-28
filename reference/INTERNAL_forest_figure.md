# Draw a forest plot from a tidy estimates table

Draw a forest plot from a tidy estimates table

## Usage

``` r
.forest_figure(
  est,
  model,
  conf.level = 0.95,
  show.reference = TRUE,
  show.table = TRUE,
  sort.by = "input",
  digits = 2,
  point.color = "#000000",
  point.size = 10,
  ci.color = "#000000",
  ci.width = 2,
  main = NULL
)
```

## Arguments

- est:

  A data frame from
  [`.forest_estimates()`](https://j-andrews7.github.io/sciVizModules/reference/INTERNAL_forest_estimates.md).

- model:

  One of `"cox"`, `"logistic"` or `"linear"`.

- conf.level:

  Confidence level for the intervals.

- show.reference:

  Logical; include a row for each factor's reference level.

- show.table:

  Logical; print the estimate, interval and p-value beside each row.

- sort.by:

  `"input"` keeps the covariate order given; `"estimate"` sorts the rows
  by effect size.

- digits:

  Number of decimal places in the printed estimates.

- point.color, ci.color:

  Colours of the estimate markers and the interval lines.

- point.size:

  Marker size.

- ci.width:

  Interval line width.

- main:

  Optional plot title.

## Value

A `plotly` object with `est` (as drawn) attached as attribute
`"estimates"`.

## Author

Jared Andrews
