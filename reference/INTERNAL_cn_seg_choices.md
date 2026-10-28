# Shared input choices for the cnSegmentPlot module

Internal helpers shared by
[`cnSegmentPlotInputsUI()`](https://j-andrews7.github.io/sciVizModules/reference/cnSegmentPlotInputsUI.md)
and
[`cnSegmentPlotServer()`](https://j-andrews7.github.io/sciVizModules/reference/cnSegmentPlotServer.md),
which must offer the same choices when building and when resetting the
controls.

## Usage

``` r
.cn_seg_genes(seg.list)

.cn_seg_seq_choices(seg.list)

.cn_seg_hover_choices(seg.list)
```

## Arguments

- seg.list:

  A named list of `CNSegment` objects, from
  [`.cn_seg_as_list()`](https://j-andrews7.github.io/sciVizModules/reference/INTERNAL_cn_seg_as_list.md).

## Value

A `GRanges` (or `NULL`) for `.cn_seg_genes()`, otherwise a character
vector of input choices.

## Details

`.cn_seg_genes()` returns the gene annotation of the first sample that
has one – gene labels are shared across the stack, so a single
annotation drives every panel. `.cn_seg_seq_choices()` returns the
standard chromosomes found across the samples, and
`.cn_seg_hover_choices()` the union of their bin metadata column names.

## Author

Jared Andrews
