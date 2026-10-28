# Tag a faceted figure's shared y-axis title as an axis annotation

Internal helper for
[`cnSegmentPlot()`](https://j-andrews7.github.io/sciVizModules/reference/cnSegmentPlot.md).
`ggplotly()` renders a faceted plot's shared axis titles as
paper-anchored annotations that are otherwise indistinguishable from
facet strip labels, so
[`VizModules::apply_axis_title_to_annotations()`](https://j-andrews7.github.io/VizModules/reference/apply_axis_title_to_annotations.html)
would style the y-axis title with the facet title font. Tagging it
`annotationType = "axis"` routes it to the axis title font instead, and
keys its dragged position by axis side.

## Usage

``` r
.cn_seg_tag_axis_title(fig, y.title)
```

## Arguments

- fig:

  A plotly figure produced from a faceted ggplot.

- y.title:

  The y-axis title text to look for.

## Value

The figure, with the matching annotation tagged.

## Author

Jared Andrews
