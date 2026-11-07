# Draw one strip's cells and legend entries

Draw one strip's cells and legend entries

Draw a set of sample strips beside the heatmap

## Usage

``` r
.meth_add_strip(fig, strip, x, y, text, title, xaxis, yaxis, legend = TRUE)

.meth_add_sample_strips(
  fig,
  columns,
  plotted,
  rows,
  ny,
  colors,
  low,
  high,
  xaxis,
  yaxis,
  legended = NULL
)
```

## Arguments

- fig:

  The figure so far.

- strip:

  A strip, from
  [`.meth_strip()`](https://j-andrews7.github.io/sciVizModules/reference/INTERNAL_meth_strips.md),
  with `z` already shaped as a matrix.

- x, y:

  The strip's cell positions.

- text:

  Hover text.

- title:

  The legend group's title.

- xaxis, yaxis:

  The panel's axis references.

- legend:

  Logical; add the strip's legend entries.

- columns:

  Sample table columns.

- plotted:

  The plotted samples' rows of the table.

- rows:

  Each plotted sample's heatmap row.

- ny:

  The heatmap rows.

- colors, low, high:

  Passed to
  [`.meth_strip()`](https://j-andrews7.github.io/sciVizModules/reference/INTERNAL_meth_strips.md).

- legended:

  Columns already in the legend, from the other side.

## Value

The figure.

The figure.

## Author

Jared Andrews
