# Identify discrete metadata columns in a dittoSeq object

Metadata are treated as discrete when they are logicals, numeric columns
with a small number of unique values (\<= `max.levels`), or factors and
characters with fewer than `max.categories` levels. A character column
of cell barcodes is left out, since it would ask for one colour per
cell.

## Usage

``` r
.ditto_discrete_metas(object, max.levels = 30, max.categories = 50)
```

## Arguments

- object:

  A dittoSeq-compatible object.

- max.levels:

  Maximum number of unique values for a numeric column to be treated as
  discrete.

- max.categories:

  Factor and character columns with this many or more levels are left
  out. Passed to
  [`VizModules::facet_check()`](https://j-andrews7.github.io/VizModules/reference/facet_check.html).

## Value

A character vector of discrete metadata names.

## Author

Jacob Martin, Jared Andrews
