# Legend title and colour ramp for a sample distance measure

Distances are dark where samples are close, as in the DESeq2 vignette,
and correlations dark where they are similar, so the ramp runs the other
way.

## Usage

``` r
.sd_style(method)
```

## Arguments

- method:

  `"euclidean"`, `"pearson"` or `"spearman"`.

## Value

A list with `name`, `low_color`, `mid_color` and `high_color`.

## Author

Jared Andrews
