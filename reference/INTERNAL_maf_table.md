# Read somatic mutations into the modules' standard table

Read somatic mutations into the modules' standard table

## Usage

``` r
.maf_table(x)
```

## Arguments

- x:

  A maftools `MAF` object (from
  [`maftools::read.maf()`](https://rdrr.io/pkg/maftools/man/read.maf.html)),
  a data frame in MAF columns (`Hugo_Symbol`, `Tumor_Sample_Barcode`,
  `Variant_Classification`, and for some views `Variant_Type`,
  `Reference_Allele`, `Tumor_Seq_Allele2` and a protein-change column),
  or a result of this function.

## Value

A list of class `"sci_maf"`: `data` (every variant, character columns,
with a logical `nonsyn` column flagging maftools' non-synonymous
classes), `samples` (every sample, including those without
non-synonymous variants) and `clinical` (one row per sample:
`Tumor_Sample_Barcode` plus the sample annotations - the MAF object's
clinical data, or for a data frame the columns that are constant within
each sample).

## Author

Jared Andrews
