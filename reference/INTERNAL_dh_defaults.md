# Default inputs for the dittoHeatmap module

Shared by the UI, the server and the Reset handler. User values win.

## Usage

``` r
.dh_defaults(object, defaults = NULL)
```

## Arguments

- object:

  A dittoSeq-compatible object, or `NULL`.

- defaults:

  A named list of user defaults, or `NULL`.

## Value

A named list with the wrapper's own defaults (`dh.genes`, `dh.assay`,
`dh.order.by`, `annot.by`).

## Author

Jared Andrews
