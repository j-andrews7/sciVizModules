# Derive centromere positions from a CNSegment's cytoBand

Internal helper for
[`cnSegmentPlot()`](https://j-andrews7.github.io/sciVizModules/reference/cnSegmentPlot.md).
Extracts one centromere position per chromosome from
`seg$genomeInfo$cytoBand`, using the end of each chromosome's p-arm
`"acen"` band (the p/q boundary). The `"acen"` stain marks the two
centromere-flanking bands; the p-arm band's end is the position drawn on
the plot.

## Usage

``` r
.cn_seg_centromeres(seg)
```

## Arguments

- seg:

  A `CNSegment` object. `seg$genomeInfo$cytoBand` is expected to be a
  `data.frame` with `chrom`, `chromStart`, `chromEnd`, `name`, and
  `gieStain` columns (as bundled by sesameData).

## Value

A `GRanges` of width-1 centromere positions (one per chromosome that has
a p-arm `"acen"` band), or `NULL` when no usable `cytoBand` is present.

## Author

Jared Andrews
