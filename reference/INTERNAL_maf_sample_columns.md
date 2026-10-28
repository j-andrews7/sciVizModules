# Sample-level columns of a MAF data frame

Sample-level columns of a MAF data frame

## Usage

``` r
.maf_sample_columns(d)
```

## Arguments

- d:

  The standard MAF table.

## Value

A data frame with `Tumor_Sample_Barcode` and every non-variant column
whose value is constant within each sample.

## Author

Jared Andrews
