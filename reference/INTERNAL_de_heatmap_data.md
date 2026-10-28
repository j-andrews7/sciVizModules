# Build the heatmap data for the deHeatmap module

Build the heatmap data for the deHeatmap module

## Usage

``` r
.de_heatmap_data(staged, res, d)
```

## Arguments

- staged:

  A
  [`.se_stage()`](https://j-andrews7.github.io/sciVizModules/reference/INTERNAL_se_stage.md)
  result.

- res:

  The results data frame.

- d:

  The wrapper's resolved inputs (as from
  [`.de_defaults()`](https://j-andrews7.github.io/sciVizModules/reference/INTERNAL_de_defaults.md)).

## Value

A
[`.heatmap_frame()`](https://j-andrews7.github.io/sciVizModules/reference/INTERNAL_heatmap_frame.md)
result: the selected genes by samples, row labels in `gene`, `direction`
and `log2FC` row annotations, the sample metadata as the column
annotation table.

## Author

Jared Andrews
