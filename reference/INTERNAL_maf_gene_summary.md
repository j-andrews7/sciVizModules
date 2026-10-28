# Non-synonymous variant counts per gene

maftools' `getGeneSummary()`.

## Usage

``` r
.maf_gene_summary(m)
```

## Arguments

- m:

  A result of
  [`.maf_table()`](https://j-andrews7.github.io/sciVizModules/reference/INTERNAL_maf_table.md).

## Value

A data frame: `Hugo_Symbol`, one column per variant class present,
`total` (variants) and `MutatedSamples`, most frequently mutated first.

## Author

Jared Andrews
