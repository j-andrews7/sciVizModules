# Prepare enrichment data and default mappings for the dot plot module

Augments an enrichment results table with a numeric `GeneRatio` column
and a `neg_log10_pvalue` column, guarantees a categorical grouping
column for the x-axis, and returns sensible default UI mappings for
[`plotthis::DotPlot()`](https://pwwang.github.io/plotthis/reference/dotplot.html).

## Usage

``` r
.prepare_enrichment(data)
```

## Arguments

- data:

  A data frame of enrichment results.

## Value

A list with elements `data` (the augmented data frame) and `mapping` (a
named list with `x`, `y`, `size`, and `fill` column names, and
`size.scale.min`: 0 when the size column is a ratio or count that cannot
be negative, so dot area is proportional to it, else `NULL`).

## Author

Jacob Martin
