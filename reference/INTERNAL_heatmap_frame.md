# Assemble the data the wrapped heatmap module takes

Assemble the data the wrapped heatmap module takes

## Usage

``` r
.heatmap_frame(
  mat,
  col.meta = NULL,
  label = "feature",
  row.annotations = NULL,
  key = "sample"
)
```

## Arguments

- mat:

  A numeric matrix; its column names become the matrix columns and its
  row names the row labels.

- col.meta:

  A data frame of column (sample or cell) metadata with row names
  matching `colnames(mat)`, or `NULL`.

- label:

  Preferred name of the row-label column.

- row.annotations:

  A data frame of per-row annotations, one row per row of `mat`, or
  `NULL`.

- key:

  Preferred name of the column-annotation key column.

## Value

`list(matrix =, column_annotations =)`, with attribute `"keys"` holding
the `label`, `key` and `matrix.cols` names actually used.

## Author

Jared Andrews
