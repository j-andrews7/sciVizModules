# Box each panel of a figure stacked with shared axes

`subplot()` with `shareX` or `shareY` gives each column (or row) one
axis, anchored to a single panel, so plotly draws that axis's line, and
its mirror, on that panel only: a curve stacked over a risk table loses
its top and bottom border. This adds paper-anchored borders around every
panel that shares an axis, drawn as
[`build_facet_panel_borders()`](https://j-andrews7.github.io/VizModules/reference/build_facet_panel_borders.html)
draws a facet's (a rectangle when mirrored, the left and bottom edges
when not), and turns off those panels' axis lines so no edge is drawn
twice. A panel with axes of its own is boxed by its axis lines and gets
none.

## Usage

``` r
.sci_shared_panel_borders(
  fig,
  showline = TRUE,
  mirror = TRUE,
  linecolor = "black",
  linewidth = 0.5
)
```

## Arguments

- fig:

  A built `plotly` figure.

- showline, mirror:

  Logical; the Axes tab's border settings.

- linecolor, linewidth:

  Colour and width of the borders.

## Value

The figure, with the borders appended to its shapes.

## Details

The panels are found from the traces that carry data, so an empty filler
trace (a grid's blank corner) is not boxed.

## Author

Jared Andrews
