# Stack a number-at-risk table beneath a survival curve

The table gets an x axis of its own, matched to the curve's so the two
zoom together: a shared axis would draw the curve's gridlines through
the table and its border lines around the table only. The table's
gridlines are kept off through the figure's `"fixed.axes"` attribute
(see
[`.sci_finalize_plotly()`](https://j-andrews7.github.io/sciVizModules/reference/INTERNAL_sci_finalize_plotly.md)).

## Usage

``` r
.km_add_risk_table(fig, fit, levels, km, break.time.by = NULL)
```

## Arguments

- fig:

  The built survival curve figure.

- fit:

  The `survfit` object.

- levels:

  The strata, in the fit's order.

- km:

  A frame from
  [`.km_frame()`](https://j-andrews7.github.io/sciVizModules/reference/INTERNAL_km_frame.md),
  for the time range.

- break.time.by:

  Spacing of the counting times, or `NULL` for pretty breaks.

## Value

The two-panel figure.

## Author

Jared Andrews
