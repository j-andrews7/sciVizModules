# Stop when the GWAS columns could not be found

Stop when the GWAS columns could not be found

## Usage

``` r
.gwas_require_columns(d, need = c("chr.col", "bp.col", "p.col"))
```

## Arguments

- d:

  Resolved defaults with `chr.col`, `bp.col`, `p.col`.

- need:

  Which of them are required.

## Value

`NULL`, invisibly; errors otherwise.

## Author

Jared Andrews
