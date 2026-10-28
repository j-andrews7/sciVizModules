# One plate's heatmap (and margins)

One plate's heatmap (and margins)

Per-plate quality statistics

## Usage

``` r
.plate_panel(d, fmt, colorscale, zmin, zmax, scale_title, showscale, marginals)

.plate_stats(d, fmt, plate)
```

## Arguments

- d:

  One plate's wells.

- fmt:

  The plate format.

- colorscale, zmin, zmax, scale_title:

  Shared colour scale.

- showscale:

  Logical; draw the colour bar.

- marginals:

  Logical; add the row and column means.

- plate:

  The plate name.

## Value

A `plotly` object.

A one-row data frame.

## Author

Jared Andrews
