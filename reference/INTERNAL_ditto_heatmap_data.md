# Build the heatmap data for the dittoHeatmap module

Pulls the expression of `genes` with
[`dittoSeq::dittoHeatmap()`](https://rdrr.io/pkg/dittoSeq/man/dittoHeatmap.html)
(`data.out = TRUE`, unscaled; the wrapped module scales), drops genes
that do not vary across the cells, and attaches every cell's metadata as
the column annotation table.

## Usage

``` r
.ditto_heatmap_data(object, genes, assay = NULL, order.by = "")
```

## Arguments

- object:

  A dittoSeq-compatible object.

- genes:

  The genes to show.

- assay:

  The assay, or `NULL` / `""` for dittoSeq's default.

- order.by:

  A metadata column the cells are ordered by, or `""` for the object's
  order.

## Value

A
[`.heatmap_frame()`](https://j-andrews7.github.io/sciVizModules/reference/INTERNAL_heatmap_frame.md)
result: genes by cells, row labels in `gene`, column key `cell`.

## Author

Jared Andrews
