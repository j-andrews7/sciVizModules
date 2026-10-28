# Columns fit to colour, shape or group by

[`VizModules::discrete_choices()`](https://j-andrews7.github.io/VizModules/reference/discrete_choices.html)
(the categorical columns
[`VizModules::facet_check()`](https://j-andrews7.github.io/VizModules/reference/facet_check.html)
accepts, plus the logical columns and any named in `keep`), in data
order, for any input
[`as.data.frame()`](https://rdrr.io/r/base/as.data.frame.html) accepts.
A column of IDs or gene names would otherwise ask for one colour, shape
or group per row, which can bring an app down.

## Usage

``` r
.sci_discrete_cols(data, numeric = FALSE, max.levels = 50, keep = NULL)
```

## Arguments

- data:

  A data frame (or anything
  [`as.data.frame()`](https://rdrr.io/r/base/as.data.frame.html)
  accepts).

- numeric:

  Whether to also keep numeric columns with fewer than `max.levels`
  distinct values, e.g. a dose.

- max.levels:

  Columns with this many or more distinct values are left out. Passed to
  [`VizModules::discrete_choices()`](https://j-andrews7.github.io/VizModules/reference/discrete_choices.html).

- keep:

  Column names to keep whatever their size, such as the column a caller
  named in `defaults`. Passed to
  [`VizModules::discrete_choices()`](https://j-andrews7.github.io/VizModules/reference/discrete_choices.html).

## Value

A character vector of column names.

## Author

Jared Andrews
