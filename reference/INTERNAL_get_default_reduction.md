# Choose a default dimensional reduction for a dittoSeq object

Returns the name of the reduction to use by default: the first available
reduction on the object, or an empty string when none are present.

## Usage

``` r
get_default_reduction(object)
```

## Arguments

- object:

  A dittoSeq-compatible object.

## Value

A length-one character naming a reduction, or `""` when none exist.

## Author

Jacob Martin, Jared Andrews
