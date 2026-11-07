# The body of a native module's render

Apart from
[`.sci_render_plotly()`](https://j-andrews7.github.io/sciVizModules/reference/INTERNAL_sci_render_plotly.md)
so it can be tested: a plotly output cannot be driven from
[`shiny::testServer()`](https://rdrr.io/pkg/shiny/man/testServer.html).

## Usage

``` r
.sci_rendered_figure(
  generate,
  input,
  plot_source,
  edit_store,
  session,
  guard,
  titles
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

- titles:

  The environment
  [`.sci_clear_stale_titles()`](https://j-andrews7.github.io/sciVizModules/reference/INTERNAL_sci_clear_stale_titles.md)
  keeps its titles in.

## Value

The figure to send. On a layout-only update the render is cancelled
instead.

## Author

Jared Andrews
