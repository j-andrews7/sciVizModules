# Parse a typed list of components

Accepts numbers or component names separated by commas or spaces, e.g.
`"3, 5"` or `"PC3 PC5"`.

## Usage

``` r
.pca_parse_components(x, n)
```

## Arguments

- x:

  A character string, or `NULL`.

- n:

  The number of components available.

## Value

A sorted integer vector of valid component indices, possibly empty.

## Author

Jared Andrews
