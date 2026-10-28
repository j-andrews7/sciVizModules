# A module's example datasets and showcase defaults, for its `*App()`

A module's example datasets and showcase defaults, for its `*App()`

## Usage

``` r
.sci_module_example(id, defaults = NULL)
```

## Arguments

- id:

  A module id in
  [`.sci_module_showcase()`](https://j-andrews7.github.io/sciVizModules/reference/INTERNAL_sci_module_showcase.md).

- defaults:

  The caller's defaults, layered over the showcase ones with
  [`.sci_merge_defaults()`](https://j-andrews7.github.io/sciVizModules/reference/INTERNAL_sci_merge_defaults.md).

## Value

A list with `data_list` (the module's example dataset, then any further
ones its app offers, named by their catalogue labels) and `defaults`.

## Author

Jared Andrews
