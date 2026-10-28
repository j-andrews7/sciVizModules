# Build the heatmap data for the sampleDistanceHeatmap module

Build the heatmap data for the sampleDistanceHeatmap module

## Usage

``` r
.sample_distance_data(
  staged,
  ntop = 500,
  method = "euclidean",
  order = "cluster"
)
```

## Arguments

- staged:

  A
  [`.se_stage()`](https://j-andrews7.github.io/sciVizModules/reference/INTERNAL_se_stage.md)
  result.

- ntop:

  The number of most variable features the distances use.

- method:

  `"euclidean"`, `"pearson"` or `"spearman"`.

- order:

  `"cluster"` to order the samples by hierarchical clustering (complete
  linkage) of the distances, or `"data"` to keep their order.

## Value

A
[`.heatmap_frame()`](https://j-andrews7.github.io/sciVizModules/reference/INTERNAL_heatmap_frame.md)
result: samples by samples, row labels in `sample`, every
sample-metadata column as a row annotation and in the column annotation
table.

## Author

Jared Andrews
