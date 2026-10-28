# A 96-channel substitution matrix as a long table

A 96-channel substitution matrix as a long table

## Usage

``` r
.sbs96_long(x)
```

## Arguments

- x:

  Anything
  [`.sbs96_matrix()`](https://j-andrews7.github.io/sciVizModules/reference/INTERNAL_sbs96_matrix.md)
  reads.

## Value

A data frame with one row per sample and channel: `context` (a factor in
canonical channel order), `substitution` (its class), `sample`, `count`
and `fraction` (of the sample's substitutions).

## Author

Jared Andrews
