# Standard plate formats

Standard plate formats

Resolve the plate format

## Usage

``` r
.plate_formats

.plate_format(row, col, format = NULL)
```

## Arguments

- row, col:

  Integer rows and columns of the wells present.

- format:

  A plate size (`96`, `384`, ...), or `NULL` / `"auto"` for the smallest
  standard plate that holds every well.

## Value

A list with `wells`, `nrow` and `ncol`.

## Author

Jared Andrews
