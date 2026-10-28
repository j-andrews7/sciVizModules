# Metadata columns of a `pca` object, by type

Metadata columns of a `pca` object, by type

## Usage

``` r
.pca_metadata_cols(p, type = c("discrete", "numeric"), keep = NULL)
```

## Arguments

- p:

  A `pca` object.

- type:

  `"discrete"` (logical, or factor and character with fewer than 50
  levels; see
  [`.sci_discrete_cols()`](https://j-andrews7.github.io/sciVizModules/reference/INTERNAL_sci_discrete_cols.md))
  or `"numeric"`.

- keep:

  Discrete column names to keep whatever their size, such as the columns
  a caller named in `defaults`.

## Value

A character vector of column names, possibly empty.

## Author

Jared Andrews
