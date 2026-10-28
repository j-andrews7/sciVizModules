# Single-nucleotide substitution classes

The six pyrimidine-centred classes, collapsing each substitution with
its reverse complement (G\>A is C\>T, and so on).

## Usage

``` r
.maf_snv_class(ref, alt)
```

## Arguments

- ref, alt:

  Reference and alternate bases.

## Value

A character vector of classes, `NA` where the change is not a
single-base substitution.

## Author

Jared Andrews
