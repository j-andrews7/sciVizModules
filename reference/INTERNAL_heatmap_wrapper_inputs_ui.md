# Input UI shared by the heatmap wrappers

The wrapper's own controls above the wrapped module's tabs.

## Usage

``` r
.heatmap_wrapper_inputs_ui(id, extras, frame, heat.defaults, title, columns)
```

## Arguments

- id:

  The module id.

- extras:

  A `tagList` of the wrapper's inputs.

- frame:

  A result of
  [`.heatmap_frame()`](https://j-andrews7.github.io/sciVizModules/reference/INTERNAL_heatmap_frame.md)
  for the initial data.

- heat.defaults:

  Defaults for the wrapped module.

- title, columns:

  As for the module UIs.

## Value

The UI.

## Author

Jared Andrews
