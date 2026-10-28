# Plate normalisation choices

Gridlines drawn over the wells (and the row and column means) carry no
information, so they are off unless the caller asks for them, and their
inputs (`.plate_grid_inputs`) are hidden.

## Usage

``` r
.plate_methods

.plate_defaults(data, defaults = NULL)

.plate_axes_defaults(defaults)

.plate_control_labels(data, col)
```

## Arguments

- data:

  The plate data frame.

- defaults:

  A named list of user defaults, or `NULL`.

- col:

  The control column, or `""`.

## Value

A named list of defaults.

`defaults` with `show.grid.x` and `show.grid.y` set to FALSE where the
caller did not set them.

The sorted unique labels.

## Author

Jared Andrews
