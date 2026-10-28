# Normalize the `seg` argument to a named list of CNSegment objects

Internal helper for
[`cnSegmentPlot()`](https://j-andrews7.github.io/sciVizModules/reference/cnSegmentPlot.md)
and its module. A `CNSegment` holds a single sample, so multi-sample
plots are driven by a list of them. This accepts either form and always
returns a named list, so callers can treat the single-sample case as a
stack of one.

## Usage

``` r
.cn_seg_as_list(seg)
```

## Arguments

- seg:

  A `CNSegment` object or a list of them.

## Value

A named list of `CNSegment` objects.

## Details

Panel names come from `names(seg)` where supplied, falling back per
element to the `seg.signals$ID` column (which
[`sesame::cnSegmentation()`](https://rdrr.io/pkg/sesame/man/cnSegmentation.html)
populates) and then to a positional `"Sample <i>"`. Names are made
unique.

## Author

Jared Andrews
