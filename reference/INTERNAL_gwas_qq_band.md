# Confidence band of a QQ plot as an SVG path

The `ci.level` interval of the i-th smallest of `n` uniform p-values is
given by the Beta(i, n - i + 1) quantiles. It is evaluated at up to
`points` log-spaced ranks, which is plenty for a smooth outline and
keeps the shape small for millions of variants.

## Usage

``` r
.gwas_qq_band(n, ci.level = 0.95, points = 300)
```

## Arguments

- n:

  Number of variants.

- ci.level:

  Confidence level.

- points:

  Number of ranks to evaluate.

## Value

An SVG path string in data coordinates (expected, observed -log10 p).

## Author

Jared Andrews
