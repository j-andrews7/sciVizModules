# Column selectors shared by the GWAS modules

Column selectors shared by the GWAS modules

## Usage

``` r
.gwas_column_inputs(
  ns,
  data,
  d,
  which = c("chr.col", "bp.col", "p.col", "snp.col")
)
```

## Arguments

- ns:

  Namespace function.

- data:

  The summary statistics.

- d:

  Resolved defaults.

- which:

  Which selectors to include.

## Value

A `tagList`.

## Author

Jared Andrews
