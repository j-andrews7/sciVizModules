# What a dittoSeq module's Annotations tab labels

Call once in the server body. The cells picked with the lasso or box
tools add up until Clear Annotations, or until `redrawn()` changes:
plotly reports each by its place in its trace, so a plot grouped
differently would have them label other cells. Nothing is recorded
without an Annotate By column, so a selection then does not redraw the
plot. Both values are reactives the draw step reads, so both belong in
its `extra`.

## Usage

``` r
.ditto_annotation_state(input, plot_source, params, redrawn)
```

## Arguments

- input:

  The module's input.

- plot_source:

  The event source from
  [`VizModules::setup_manual_edits()`](https://j-andrews7.github.io/VizModules/reference/setup_manual_edits.html).

- params:

  The reactive-defaults store, or `NULL`.

- redrawn:

  A function reading whatever regroups the module's traces.

## Value

A list of `highlights`, the debounced Points to Highlight text (free
text, see
[`.sci_debounced_input()`](https://j-andrews7.github.io/sciVizModules/reference/INTERNAL_sci_debounced_input.md)),
and `selected`, the picked cells.

## Author

Jared Andrews
