# Default inputs for the Manhattan plot module

The GWAS column defaults plus the wrapped scatter module's: the
cumulative position on x, the p-value column on y drawn as -log10,
points coloured by chromosome in two alternating colours, variant ids
for hover and labels, and no legend (one entry per chromosome says
nothing the axis does not).

## Usage

``` r
.manhattan_defaults(data, defaults = NULL)
```

## Arguments

- data:

  The summary statistics.

- defaults:

  A named list of user defaults, or `NULL`.

## Value

A named list of defaults.

## Author

Jared Andrews
