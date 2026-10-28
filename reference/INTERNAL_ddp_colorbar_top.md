# Keep the dot plot's colour bar in the upper half of the legend area

`ggplotly()` gives the colour bar the full plot height, where the size
legend (default `size.legend.y` 0.35) would overlap it.

## Usage

``` r
.ddp_colorbar_top(fig)
```

## Arguments

- fig:

  The `ggplotly()` figure.

## Value

The figure with its colour bar anchored at the top, half the height.

## Author

Jared Andrews
