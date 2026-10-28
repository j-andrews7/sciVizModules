# The most variable genes of a dittoSeq object

Variances are computed with matrix products, so a sparse or delayed
assay is never expanded to a dense matrix.

## Usage

``` r
.ditto_top_variable_genes(object, assay = NULL, n = 20)
```

## Arguments

- object:

  A dittoSeq-compatible object.

- assay:

  The assay to use.

- n:

  The number of genes to return.

## Value

Gene names. Objects that are not a `SummarizedExperiment`, or whose
assay cannot be read, give the first `n` genes.

## Author

Jared Andrews
