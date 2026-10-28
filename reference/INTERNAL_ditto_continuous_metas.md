# Identify continuous metadata columns in a dittoSeq object

Identify continuous metadata columns in a dittoSeq object

## Usage

``` r
.ditto_continuous_metas(object, max.levels = 30)
```

## Arguments

- object:

  A dittoSeq-compatible object.

- max.levels:

  Numeric columns with more than this many unique values are treated as
  continuous.

## Value

A character vector of continuous metadata names.

## Author

Jacob Martin, Jared Andrews
