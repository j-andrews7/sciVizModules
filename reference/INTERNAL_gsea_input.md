# Normalise a GSEA input to the bundle the GSEA module plots

Accepts either an fgsea bundle - a list with `stats` (a named numeric
vector of gene-level statistics), `pathways` (a named list of gene sets)
and optionally `results` (the
[`fgsea::fgsea()`](https://rdrr.io/pkg/fgsea/man/fgsea.html) table) - or
a clusterProfiler `gseaResult`, whose `geneList`, `geneSets` and
`result` slots hold the same three things. The clusterProfiler object is
read through its slots, so neither clusterProfiler nor DOSE is needed.

## Usage

``` r
.gsea_input(x, arg = "data")
```

## Arguments

- x:

  The input.

- arg:

  Argument name for error messages.

## Value

A list with `stats`, `pathways`, `results` (a data frame with `pathway`,
`ES`, `NES`, `pval`, `padj`, `size`, or `NULL`) and `labels` (display
names for the pathways).

## Author

Jared Andrews
