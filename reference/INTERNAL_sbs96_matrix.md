# Read a 96-channel substitution matrix into a channels-by-samples matrix

Accepts the 96 x samples matrix MutationalPatterns' `mut_matrix()`
returns, the samples x 96 `nmf_matrix` of maftools'
`trinucleotideMatrix()`, or a data frame with a column of channel names
and one numeric column per sample (the SigProfiler layout). Channels are
matched by name, so their order does not matter; channels that are
missing count zero.

## Usage

``` r
.sbs96_matrix(x)
```

## Arguments

- x:

  A matrix or data frame.

## Value

A numeric matrix, the 96 channels (in canonical order) by samples.

## Author

Jared Andrews
