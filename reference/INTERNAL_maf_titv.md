# Transition and transversion counts per sample

maftools' `titv()$raw.counts`.

## Usage

``` r
.maf_titv(m, use.syn = TRUE)
```

## Arguments

- m:

  A result of
  [`.maf_table()`](https://j-andrews7.github.io/sciVizModules/reference/INTERNAL_maf_table.md).

- use.syn:

  Logical; count silent substitutions too (as maftools' summary plot
  does).

## Value

A data frame: `Tumor_Sample_Barcode` and one count column per class, for
the samples with at least one substitution.

## Author

Jared Andrews
