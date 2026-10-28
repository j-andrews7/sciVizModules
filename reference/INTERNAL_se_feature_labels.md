# Feature labels from a rowData column, falling back to the row names

Feature labels from a rowData column, falling back to the row names

## Usage

``` r
.se_feature_labels(se, ids, col = NULL)
```

## Arguments

- se:

  A `SummarizedExperiment`.

- ids:

  The feature identifiers (row names) to label.

- col:

  A `rowData` column, or `NULL` / `""` for the row names.

## Value

A character vector of labels, made unique.

## Author

Jared Andrews
