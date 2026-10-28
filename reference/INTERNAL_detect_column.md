# Detect a column by matching a list of candidate names

Shared column-detection primitive used by the GO enrichment sunburst
([`goFanPlot()`](https://j-andrews7.github.io/sciVizModules/reference/goFanPlot.md))
and dot plot ([enrichmentDotPlot
module](https://j-andrews7.github.io/sciVizModules/reference/INTERNAL_prepare_enrichment.md))
helpers. Returns the first candidate that is present in `names(data)`,
optionally requiring the column to be numeric.

## Usage

``` r
.detect_column(data, candidates, numeric = FALSE, exclude = NULL)
```

## Arguments

- data:

  A data frame.

- candidates:

  A character vector of candidate column names, in priority order.

- numeric:

  Logical; when `TRUE`, only numeric columns are considered.

- exclude:

  Column names to ignore.

## Value

The name of the first matching column, or `NULL` when none match.

## Author

Jacob Martin, Jared Andrews
