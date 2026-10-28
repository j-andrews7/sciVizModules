# Match genes to plotted copy number bins

Internal helper for
[`cnSegmentPlot()`](https://j-andrews7.github.io/sciVizModules/reference/cnSegmentPlot.md).
Each gene is assigned to its plotted bin with the largest overlap so
annotations point to observed bin signals.

## Usage

``` r
.cn_seg_gene_bin_data(genes, id.col, bin.coords, totlen, seq.names)
```

## Arguments

- genes:

  A `GRanges` of gene coordinates.

- id.col:

  Name of the metadata column in `genes` holding the label. If `NULL`,
  `names(genes)` is used.

- bin.coords:

  A `GRanges` of plotted bins with `bin.x` and `signal` metadata
  columns.

- totlen:

  Total genome length (sum of plotted chromosome lengths).

- seq.names:

  Character vector of chromosome names being plotted.

## Value

A data frame containing bin indices, annotation positions, and labels,
or `NULL` when no genes overlap plotted bins with signal values.

## Author

Jared Andrews
