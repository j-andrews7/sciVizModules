# Build one sample's plotting data for a copy number segment plot

Internal helper for
[`cnSegmentPlot()`](https://j-andrews7.github.io/sciVizModules/reference/cnSegmentPlot.md).
Places a single `CNSegment`'s bins and called segments onto the shared
genomic coordinate system (`seqstart` / `totlen`) computed once across
all samples, and builds the point hover text.

## Usage

``` r
.cn_seg_panel_data(
  seg,
  seq.names,
  seqstart,
  totlen,
  hover.text.cols,
  genes = NULL,
  id.col = NULL
)
```

## Arguments

- seg:

  A `CNSegment` object.

- seq.names:

  Character vector of chromosome names being plotted.

- seqstart:

  Named numeric vector of per-chromosome genomic offsets.

- totlen:

  Total length of the plotted chromosomes, used to scale x into a genome
  fraction.

- hover.text.cols:

  Character vector of `bin.coords` metadata column names to include in
  the hover text.

- genes:

  An optional `GRanges` of gene coordinates to label.

- id.col:

  Name of the metadata column in `genes` holding the label.

## Value

A list with `df` (the per-bin plotting frame), `seg.df` (the segment
mean overlay, or `NULL`), and `label.df` (gene/bin matches, or `NULL`).

## Author

Jared Andrews
