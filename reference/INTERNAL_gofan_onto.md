# Detect the GO ontology category

Inspects a `ONTOLOGY`-style column (when present) and returns the most
common of `"BP"`, `"CC"`, or `"MF"`. Defaults to `"BP"` when no such
column exists.

## Usage

``` r
.gofan_onto(data)
```

## Arguments

- data:

  A data frame of enrichment results.

## Value

A length-one character: one of `"BP"`, `"CC"`, or `"MF"`.

## Author

Jacob Martin, Jared Andrews
