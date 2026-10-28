# Output UI shared by the heatmap wrappers

The wrapped module's interactive heatmap, with a line above it that
shows why the wrapper could not build the matrix (the widget otherwise
keeps showing the last heatmap it drew).

## Usage

``` r
.heatmap_wrapper_output_ui(id, resizable = TRUE, ...)
```

## Arguments

- id:

  The module id.

- resizable:

  Passed to
  [`VizModules::ComplexHeatmap_HeatmapOutputUI()`](https://j-andrews7.github.io/VizModules/reference/ComplexHeatmap_HeatmapOutputUI.html),
  which ignores it.

- ...:

  Passed to
  [`VizModules::ComplexHeatmap_HeatmapOutputUI()`](https://j-andrews7.github.io/VizModules/reference/ComplexHeatmap_HeatmapOutputUI.html).

## Value

The output UI.

## Author

Jared Andrews
