# Z'-factor of an assay plate

`1 - 3 (sd_pos + sd_neg) / |mean_pos - mean_neg|` (Zhang et al. 1999).

## Usage

``` r
.plate_zprime(pos, neg)
```

## Arguments

- pos, neg:

  Readouts of the positive and negative control wells.

## Value

The Z'-factor, or `NA` without at least two of each.

## Author

Jared Andrews
