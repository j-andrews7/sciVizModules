# NGL selection string for a set of residues

Collapses consecutive residue numbers within each chain into ranges,
e.g. `"1-40:A or 95-290:A"`.

## Usage

``` r
.structure_sele(res)
```

## Arguments

- res:

  A data frame with `chain` and `residue`.

## Value

A selection string, or `NULL` for no residues.

## Author

Jared Andrews
