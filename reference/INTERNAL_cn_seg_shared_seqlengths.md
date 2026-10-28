# Merge chromosome lengths across CNSegment samples

Internal helper for
[`cnSegmentPlot()`](https://j-andrews7.github.io/sciVizModules/reference/cnSegmentPlot.md).
Stacked samples must share one set of chromosome offsets for their
x-axes to line up, so this merges the samples' `seqlengths` into a
single named vector: the first sample's `seqinfo` order, with any
chromosomes only later samples define appended.

## Usage

``` r
.cn_seg_shared_seqlengths(seg.list)
```

## Arguments

- seg.list:

  A named list of `CNSegment` objects, from
  [`.cn_seg_as_list()`](https://j-andrews7.github.io/sciVizModules/reference/INTERNAL_cn_seg_as_list.md).

## Value

A named numeric vector of chromosome lengths.

## Author

Jared Andrews
