# The coding part of each exon

As sesame's `exonToCDS()`, for every transcript at once.

## Usage

``` r
.meth_cds(exons, meta)
```

## Arguments

- exons:

  A data frame of `owner`, `start` and `end`.

- meta:

  The transcripts' `mcols()`.

## Value

The same columns, for the coding exons, clipped to the coding region.

## Author

Jared Andrews
