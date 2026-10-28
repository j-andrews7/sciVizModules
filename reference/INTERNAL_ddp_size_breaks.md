# The percentages the dot plot's size legend shows

Round values across the size scale. dittoSeq sizes its dots from 0 at
`min.percent`, so a circle there would be empty and is left out.

## Usage

``` r
.ddp_size_breaks(percent, limits)
```

## Arguments

- percent:

  The drawn dots' percentages (0-100).

- limits:

  The size scale's limits in percent; an `NA` upper limit is the largest
  dot drawn.

## Value

A numeric vector of breaks.

## Author

Jared Andrews
