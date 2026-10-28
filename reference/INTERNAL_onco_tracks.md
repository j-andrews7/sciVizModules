# Sample annotation tracks for an oncoplot

One heatmap row per track: discrete annotations on dittoSeq's palette
(each track offset so two never share colours), numeric ones on a
viridis scale.

## Usage

``` r
.onco_tracks(m, samples, tracks)
```

## Arguments

- m:

  A result of
  [`.maf_table()`](https://j-andrews7.github.io/sciVizModules/reference/INTERNAL_maf_table.md).

- samples:

  The samples, in plot order.

- tracks:

  The annotation columns.

## Value

A `plotly` object.

## Author

Jared Andrews
