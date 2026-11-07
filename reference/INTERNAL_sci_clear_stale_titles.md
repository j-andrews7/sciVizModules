# Forget a typed axis title once the axis it named has changed

A captured title's text is restored on every render, but it only makes
sense for the variable it was typed for. The VizModules modules drop it
when their axis column changes; a native module's axis title can follow
any of its inputs, so this compares the title each render draws instead.
The figure's text here is the freshly built one, since captured edits
are restored after this, in
[`VizModules::finalize_manual_edits()`](https://j-andrews7.github.io/VizModules/reference/finalize_manual_edits.html).
The position stays either way.

## Usage

``` r
.sci_clear_stale_titles(fig, store, seen)
```

## Arguments

- fig:

  The styled figure. Its axis titles are annotations by now.

- store:

  The store from
  [`VizModules::setup_manual_edits()`](https://j-andrews7.github.io/VizModules/reference/setup_manual_edits.html).

- seen:

  An environment holding the titles last drawn.

## Value

`NULL`, invisibly.

## Author

Jared Andrews
