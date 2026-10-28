# Apply the shared VizModules plotly styling stack to a module figure

Applies the title, axis, legend, reference-line, config, and annotation
post-processing shared by the sciVizModules modules that build their own
figure (the dittoSeq wrappers and the native plotly modules), so the
figure respects the module's Axes, Legend, Lines and Plotly tab
controls.

## Usage

``` r
.sci_finalize_plotly(fig, input, isolate_fn, faceted = FALSE)
```

## Arguments

- fig:

  A `plotly` figure.

- input:

  The Shiny module `input` object.

- isolate_fn:

  The isolation helper returned by
  [`VizModules::setup_auto_update_logic()`](https://j-andrews7.github.io/VizModules/reference/setup_auto_update_logic.html).

- faceted:

  Logical, whether the figure is split into panels (`split.by` is set,
  or the plot always facets). A faceted figure titles each panel, so its
  main title is not editable in place, and its shared axis titles and
  panel titles are annotations styled from the Axes tab.

## Value

The styled `plotly` figure.

## Details

The Axes tab styles every axis of the figure. A panel whose axes must
keep their own settings whatever the Axes tab says (a risk table's or a
tick strip's gridlines) names them in the figure's `"fixed.axes"`
attribute, a named list of axis properties
(`list(yaxis2 = list(showgrid = FALSE))`), which is applied last.

The panels of a figure stacked with shared axes are boxed by
[`.sci_shared_panel_borders()`](https://j-andrews7.github.io/sciVizModules/reference/INTERNAL_sci_shared_panel_borders.md),
since plotly draws a shared axis's lines on one panel only. A faceted
figure takes its panel borders from its ggplot theme instead.

## Author

Jacob Martin, Jared Andrews
