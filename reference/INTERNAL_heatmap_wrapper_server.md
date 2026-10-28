# Server shared by the heatmap wrappers

Prepares the wrapper's frame inside its own
[`moduleServer()`](https://rdrr.io/pkg/shiny/man/moduleServer.html) and
hands it to
[`VizModules::ComplexHeatmap_HeatmapServer()`](https://j-andrews7.github.io/VizModules/reference/ComplexHeatmap_HeatmapServer.html),
called outside with the same id. The frame's column order reaches the
base as a reactive `matrix.cols` default, since the base takes the
column order from that input rather than from the data. The base's
source reactive is returned unchanged: its `vector_svg` / `raster_png`
attributes carry the Figure Builder export.

## Usage

``` r
.heatmap_wrapper_server(
  id,
  data,
  hide.inputs,
  hide.tabs,
  heat.defaults,
  prepare,
  stage = NULL,
  reactive.defaults = NULL,
  reset = NULL
)
```

## Arguments

- id, data, hide.inputs, hide.tabs:

  As for the module servers.

- heat.defaults:

  Defaults for the wrapped module.

- prepare:

  `function(staged, input, isolate_fn)` returning a
  [`.heatmap_frame()`](https://j-andrews7.github.io/sciVizModules/reference/INTERNAL_heatmap_frame.md)
  result, where `staged` is the result of `stage` (or the data itself).
  Inputs must be read as `isolate_fn(input$key)`.

- stage:

  Optional `function(obj, input, isolate_fn)` for the expensive first
  step (e.g. a variance-stabilising transformation), kept in its own
  reactive so changing only what `prepare` reads does not repeat it.

- reactive.defaults:

  Optional `function(input, prepared)` returning a named list of
  reactives that drive further base inputs from the wrapper's own (e.g.
  the legend title). They are read when the base server is constructed,
  before the wrapper's inputs exist, so they must fall back rather than
  pause.

- reset:

  Optional `function(session, obj)` restoring the wrapper's own inputs.

## Value

The wrapped module's source-data reactive.

## Author

Jared Andrews
