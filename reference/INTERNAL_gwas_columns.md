# Detect the columns of GWAS summary statistics

Recognises the usual names for the chromosome, position, p-value and
variant columns across qqman, PLINK, REGENIE and the GWAS Catalog
harmonised format.

## Usage

``` r
.gwas_columns(data)
```

## Arguments

- data:

  A data frame of summary statistics.

## Value

A list with `chr`, `bp`, `p` and `snp`, each a column name or `NULL`.

## Author

Jared Andrews
