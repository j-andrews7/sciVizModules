# Shared server for the native plot modules that take a non-data-frame object

The PCAtools scree, loadings, pairs and correlation modules and the
AlphaFold module differ only in the inputs they read and the plot
function they call, so they share this server: reactive defaults,
input/tab hiding, the Reset handler for the uniform tabs, the plot
reactive (finished with
[`.sci_finalize_plotly()`](https://j-andrews7.github.io/sciVizModules/reference/INTERNAL_sci_finalize_plotly.md)),
the render, and the source download, whose statistics table is the
plotted table attached to the figure.

## Usage

``` r
.sci_plot_server(
  id,
  data,
  hide.inputs,
  hide.tabs,
  defaults,
  name,
  build,
  reset,
  validate,
  setup = NULL
)
```

## Arguments

- id, data, hide.inputs, hide.tabs, defaults:

  As for the module servers.

- name:

  The module name, which is also the plot output's id and the stem of
  its tabset id (`<name>TabsetPanel`).

- build:

  `function(obj, input, isolate_fn, state)` returning the figure. Inputs
  must be read in the literal form `isolate_fn(input$key)`.

- reset:

  `function(session, obj, defaults, state)` restoring the module's own
  inputs.

- validate:

  A function returning the object, or erroring on one the module cannot
  take.

- setup:

  Optional `function(input, output, session, object, params)` run once
  in the server body, returning a list (`state`) of reactives or stores
  the build and reset functions need.

## Value

The source-data reactive.

## Author

Jared Andrews
