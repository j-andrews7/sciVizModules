# Check whether an object is a dittoSeq-compatible object

Check whether an object is a dittoSeq-compatible object

## Usage

``` r
.is_ditto_object(object)
```

## Arguments

- object:

  An object to test.

## Value

`TRUE` when `object` is a `SingleCellExperiment`,
`SummarizedExperiment`, or `Seurat` object, otherwise `FALSE`.

## Author

Jacob Martin, Jared Andrews
