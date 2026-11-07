# Highlight and label the cells the Annotations tab names

The VizModules helpers match a point on its `annotate.by` line of hover
text, so the figure must have been drawn with that field, and only its
marker traces are looked at (an ellipse or contour comes from the same
data).

## Usage

``` r
.ditto_annotate(
  fig,
  object,
  annotate.by,
  highlights,
  selected,
  input,
  isolate_fn,
  size
)
```

## Arguments

- fig:

  A built plotly figure.

- object:

  The object it was drawn from.

- annotate.by:

  The Annotate By column, or `NULL`, which leaves `fig` alone.

- highlights:

  The Points to Highlight text.

- selected:

  The cells picked on the plot, as `event_data()` reports them.

- input, isolate_fn:

  The module's input and isolation helper.

- size:

  The plot's point size.

## Value

The figure, with its highlighted points restyled and the labels appended
to its annotations.

## Author

Jared Andrews
