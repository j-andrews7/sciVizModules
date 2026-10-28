# Observed against expected -log10(p) for a QQ plot

Observed against expected -log10(p) for a QQ plot

## Usage

``` r
.gwas_qq_frame(data, p, snp = NULL)
```

## Arguments

- data:

  A data frame of summary statistics.

- p:

  The p-value column.

- snp:

  The variant column, or `NULL`.

## Value

A data frame sorted from the most significant variant: `qq.rank`,
`qq.expected`, `qq.observed`, the p-value as `qq.p`, and the variant id
as `variant` when given. The variant count and lambda GC are attached as
attributes `"n"` and `"lambda"`.

## Author

Jared Andrews
