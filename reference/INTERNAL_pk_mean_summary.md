# Group means and their intervals at each nominal time

The frame
[`pkConcentrationTime()`](https://j-andrews7.github.io/sciVizModules/reference/pkConcentrationTime.md)'s
mean mode hands
[`VizModules::linePlot()`](https://j-andrews7.github.io/VizModules/reference/linePlot.html):
each group's mean concentration at each nominal time, with the interval
[`VizModules::error_bar_halfwidth()`](https://j-andrews7.github.io/VizModules/reference/error_bar_halfwidth.html)
gives around it as bound columns. A time with one sample has no
interval. On a log axis, a lower bound at or below zero is raised to the
smallest concentration plotted, so the bar runs to the foot of the axis
instead of stretching it towards zero.

## Usage

``` r
.pk_mean_summary(plotted, type = "sd", ci.method = "t", log.y = FALSE)
```

## Arguments

- plotted:

  The concentrations being plotted, with `.group`, `.nominal` and
  `.conc` columns.

- type, ci.method:

  The interval, as for
  [`VizModules::error_bar_halfwidth()`](https://j-andrews7.github.io/VizModules/reference/error_bar_halfwidth.html).

- log.y:

  Logical; whether the concentration axis is logarithmic.

## Value

A data frame with columns `group`, `time`, `mean`, `sd`, `n`,
`halfwidth`, `lower` and `upper`, ordered by group and time.

## Author

Jared Andrews
