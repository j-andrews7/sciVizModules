# Transform a bulk expression assay

Transform a bulk expression assay

## Usage

``` r
.se_transform(se, assay = NULL, method = c("vst", "log2cpm", "log2", "none"))
```

## Arguments

- se:

  A `SummarizedExperiment`.

- assay:

  The assay to use.

- method:

  `"vst"` ([`DESeq2::vst()`](https://rdrr.io/pkg/DESeq2/man/vst.html)),
  `"log2cpm"` (as
  [`edgeR::cpm()`](https://rdrr.io/pkg/edgeR/man/cpm.html) with
  `log = TRUE`), `"log2"` (`log2(x + 1)`) or `"none"`.

## Value

A numeric matrix, features by samples.

## Author

Jared Andrews
