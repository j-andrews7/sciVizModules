# Where each panel of the figure goes

Where each panel of the figure goes

## Usage

``` r
.meth_domains(
  n.left = 0,
  n.right = 0,
  dendrogram = FALSE,
  label.width = 0.15,
  txn.rows = NULL,
  txn.labels = TRUE,
  map = TRUE,
  ideogram = TRUE,
  n.bottom = 0,
  labelled = FALSE
)
```

## Arguments

- n.left, n.right:

  Annotation strips each side of the heatmap.

- dendrogram:

  Logical; whether a dendrogram is drawn.

- label.width:

  The share of the width kept for sample names.

- txn.rows:

  The transcript rows, or `NULL` for no transcript panel.

- txn.labels:

  Logical; whether transcripts are labelled.

- map, ideogram:

  Logical; whether those panels are drawn.

- n.bottom:

  Strips under the heatmap.

- labelled:

  Logical; whether columns are labelled.

## Value

A list of `x` and `y`, each a list of panel domains. A panel not drawn
has none.

## Author

Jared Andrews
