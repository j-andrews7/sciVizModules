# Transform the assay of a SummarizedExperiment once, for the heatmap wrappers

Transform the assay of a SummarizedExperiment once, for the heatmap
wrappers

## Usage

``` r
.se_stage(se, assay, transform)
```

## Arguments

- se:

  A `SummarizedExperiment`.

- assay, transform:

  As for
  [`.se_transform()`](https://j-andrews7.github.io/sciVizModules/reference/INTERNAL_se_transform.md).

## Value

`list(se =, mat =)`, the object and its transformed assay.

## Author

Jared Andrews
