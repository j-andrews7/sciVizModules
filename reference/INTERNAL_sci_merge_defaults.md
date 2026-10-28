# Layer a caller's defaults over a module's showcase defaults

A key the caller sets replaces the showcase value whole, rather than
being merged into it as
[`utils::modifyList()`](https://rdrr.io/r/utils/modifyList.html) would
merge a nested list (an annotation-track list, say).

## Usage

``` r
.sci_merge_defaults(base, over)
```

## Arguments

- base:

  The showcase defaults.

- over:

  The caller's defaults, or `NULL`.

## Value

The combined list, or `NULL` when both are empty.

## Author

Jared Andrews
