# Thin the non-significant variants of large summary statistics

Keeps every variant with p below `p.keep` and a reproducible random
`fraction` of the rest, so plots of millions of variants stay responsive
without losing any signal worth looking at.

## Usage

``` r
.gwas_thin(df, p, p.keep = 0.01, fraction = 0.1)
```

## Arguments

- df:

  A data frame.

- p:

  The p-value column.

- p.keep:

  Variants below this p-value are always kept.

- fraction:

  Fraction of the remaining variants to keep.

## Value

The thinned data frame, in the original order.

## Author

Jared Andrews
