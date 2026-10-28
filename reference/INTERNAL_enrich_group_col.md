# Detect a categorical grouping column for the enrichment x-axis

Detect a categorical grouping column for the enrichment x-axis

## Usage

``` r
.enrich_group_col(data, exclude = NULL)
```

## Arguments

- data:

  A data frame of enrichment results.

- exclude:

  Column names to ignore (e.g. the term column).

## Value

The name of a discrete grouping column, or `NULL` when none is found.

## Author

Jacob Martin
