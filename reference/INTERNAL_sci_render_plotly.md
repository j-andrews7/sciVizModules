# Render a native module's figure

The `renderPlotly()` of every module that builds its own figure. It
shows why a plot cannot be drawn (no metadata, an empty range) rather
than leaving it blank, while
[`req()`](https://rdrr.io/pkg/shiny/man/req.html)'s silent pause stays a
pause, and finishes with
[`VizModules::finalize_manual_edits()`](https://j-andrews7.github.io/VizModules/reference/finalize_manual_edits.html),
which is what updates the plot in place and sends only the layout when
its traces have not changed. That call cancels the render on such an
update, so it has to stay last and outside the
[`tryCatch()`](https://rdrr.io/r/base/conditions.html).

## Usage

``` r
.sci_render_plotly(
  generate,
  input,
  plot_source,
  edit_store,
  session,
  guard = NULL
)
```

## Arguments

- generate:

  The module's styled figure reactive.

- input, session:

  The module's input and session.

- plot_source, edit_store:

  The event source and the store from
  [`VizModules::setup_manual_edits()`](https://j-andrews7.github.io/VizModules/reference/setup_manual_edits.html).

- guard:

  Optional function run first, for the render's own
  [`req()`](https://rdrr.io/pkg/shiny/man/req.html)s. Inside the
  [`tryCatch()`](https://rdrr.io/r/base/conditions.html), so an error in
  it (a malformed `data`) shows as a message.

## Value

A `renderPlotly()` output.

## Author

Jared Andrews
