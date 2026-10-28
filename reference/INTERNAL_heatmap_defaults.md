# Defaults for the wrapped heatmap module

Fixes the base's matrix columns, row-name column and annotation key to
the wrapper's frame; `base` carries the wrapper's own heatmap defaults,
which a caller's `defaults` override entry by entry.

## Usage

``` r
.heatmap_defaults(
  frame,
  defaults = NULL,
  base = list(),
  wrapper.keys = character(0)
)
```

## Arguments

- frame:

  A result of
  [`.heatmap_frame()`](https://j-andrews7.github.io/sciVizModules/reference/INTERNAL_heatmap_frame.md).

- defaults:

  The caller's defaults, or `NULL`.

- base:

  The wrapper's heatmap defaults.

- wrapper.keys:

  The wrapper's own input ids, dropped before the list reaches the base
  module.

## Value

A named list of defaults for
[`VizModules::ComplexHeatmap_HeatmapServer()`](https://j-andrews7.github.io/VizModules/reference/ComplexHeatmap_HeatmapServer.html).

## Author

Jared Andrews
