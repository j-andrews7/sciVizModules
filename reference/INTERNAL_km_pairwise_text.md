# On-plot lines and hover text of the pairwise comparisons

On-plot lines and hover text of the pairwise comparisons

## Usage

``` r
.km_pairwise_text(pw, max.lines = .km_pairwise_max_lines)

.km_pairwise_hover(pw)
```

## Arguments

- pw:

  A table from
  [`.km_pairwise()`](https://j-andrews7.github.io/sciVizModules/reference/INTERNAL_km_pairwise.md).

- max.lines:

  Most comparisons to list on the plot; more are summarised in one line
  pointing to the statistics table.

## Value

`.km_pairwise_text()`: a character vector, a header and then a line per
comparison. `.km_pairwise_hover()`: one string, a line per comparison
with its hazard ratio, p-values, subjects and events.

## Author

Jared Andrews
