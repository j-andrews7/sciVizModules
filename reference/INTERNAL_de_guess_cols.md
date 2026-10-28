# Guess the columns of a DE results table

Recognises DESeq2, edgeR, limma and Seurat names.

## Usage

``` r
.de_guess_cols(res, se)
```

## Arguments

- res:

  A results data frame.

- se:

  The experiment, whose row names the identifier column must match.

## Value

A list with `id` (`""` for the row names), `label`, `padj` and `lfc`.

## Author

Jared Andrews
