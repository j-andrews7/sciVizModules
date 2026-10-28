# Variance-stabilise a count matrix with DESeq2

Uses [`DESeq2::vst()`](https://rdrr.io/pkg/DESeq2/man/vst.html), falling
back to
[`DESeq2::varianceStabilizingTransformation()`](https://rdrr.io/pkg/DESeq2/man/varianceStabilizingTransformation.html)
when the matrix has too few genes for `vst()`'s subsampled dispersion
fit.

## Usage

``` r
.vst_counts(counts)
```

## Arguments

- counts:

  A matrix of non-negative integer counts, features by samples.

## Value

The transformed matrix.

## Author

Jared Andrews
