# The assay dittoSeq uses by default

The assay dittoSeq uses by default

## Usage

``` r
.ditto_default_assay(object)
```

## Arguments

- object:

  A dittoSeq-compatible object.

## Value

The first of `logcounts`, `normcounts` and `counts` present (as dittoSeq
chooses), otherwise the first assay, or `""`.

## Author

Jared Andrews
