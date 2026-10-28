# Sample-metadata columns that group samples

The discrete columns
([`.sci_discrete_cols()`](https://j-andrews7.github.io/sciVizModules/reference/INTERNAL_sci_discrete_cols.md))
with at least two values and fewer values than samples, so sample IDs
(one value per sample) and constants are left out of default annotations
and colours.

## Usage

``` r
.se_group_cols(meta)
```

## Arguments

- meta:

  A sample metadata data frame.

## Value

Column names.

## Author

Jared Andrews
