# The gene-by-sample alteration matrix of an oncoplot

Each cell holds the variant class of the gene in the sample,
`"Multi_Hit"` when it carries more than one variant (as maftools'
`createOncoMatrix()`), or `""`. Genes run from most to least often
mutated; samples are sorted so that those mutated in the first gene come
first, then the second, and so on (the oncoplot "waterfall").

## Usage

``` r
.maf_onco_matrix(
  m,
  genes = NULL,
  top.n = 20,
  include.unmutated = TRUE,
  sort = TRUE
)
```

## Arguments

- m:

  A result of
  [`.maf_table()`](https://j-andrews7.github.io/sciVizModules/reference/INTERNAL_maf_table.md).

- genes:

  The genes, or `NULL` for the `top.n` most mutated.

- top.n:

  The number of genes when `genes` is `NULL`.

- include.unmutated:

  Logical; keep samples with none of the genes mutated (at the right).

- sort:

  Logical; sort the samples. Otherwise they keep their order.

## Value

A list with `classes` (the character matrix), `changes` (a matrix of the
protein changes, for hover text) and `counts` (the number of variants).

## Author

Jared Andrews
