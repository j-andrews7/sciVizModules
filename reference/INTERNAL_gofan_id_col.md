# Detect the GO identifier column

Finds the first column whose values contain GO identifiers matching
`GO:[0-9]+` (either exactly, e.g. `"GO:0006955"`, or embedded in free
text, e.g. `"immune response (GO:0006955)"`). Falls back to a column
literally named `"ID"` when no GO-like values are found.

## Usage

``` r
.gofan_id_col(data)
```

## Arguments

- data:

  A data frame of enrichment results.

## Value

The name of the GO ID column, or `NULL` when none is found.

## Author

Jacob Martin
