# Parse a "GeneRatio"-style fraction string to a numeric ratio

Converts values such as `"8/196"` to `8 / 196`. Values that are already
numeric are returned unchanged; anything that cannot be parsed becomes
`NA`.

## Usage

``` r
.parse_ratio(x)
```

## Arguments

- x:

  A character or numeric vector.

## Value

A numeric vector of ratios.

## Author

Jacob Martin
