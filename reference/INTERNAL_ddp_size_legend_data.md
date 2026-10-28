# The dots the size legend describes

The dots dittoDotPlot draws: those whose fraction of cells expressing
lies within `min.percent` and `max.percent` (ggplot2 drops the rest).

## Usage

``` r
.ddp_size_legend_data(dat, min.percent = 0.01, max.percent = NA)
```

## Arguments

- dat:

  The `data` element of `dittoDotPlot(data.out = TRUE)`.

- min.percent, max.percent:

  The size-scale limits (`max.percent` may be `NA`).

## Value

A data frame with a `percent` column (0-100), one row per drawn dot.

## Author

Jared Andrews
