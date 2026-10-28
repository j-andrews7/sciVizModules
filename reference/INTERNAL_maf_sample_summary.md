# Non-synonymous variant counts per sample

maftools' `getSampleSummary()`.

## Usage

``` r
.maf_sample_summary(m)
```

## Arguments

- m:

  A result of
  [`.maf_table()`](https://j-andrews7.github.io/sciVizModules/reference/INTERNAL_maf_table.md).

## Value

A data frame: `Tumor_Sample_Barcode`, one column per variant class
present, and `total`, with every sample (zeros for those without
variants), most mutated first.

## Author

Jared Andrews
