# Add the cell names to an object's metadata

dittoSeq draws its hover text from metadata, so this is how the cells'
own names reach it. A `cell.id` column the object already has is left
alone.

## Usage

``` r
.ditto_with_cell_ids(object)
```

## Arguments

- object:

  A dittoSeq-compatible object.

## Value

The object, with a `cell.id` metadata column.

## Author

Jared Andrews
