# Default UI values for the volcano plot module

Computes the volcano-specific defaults handed to both the volcano UI and
the underlying
[`VizModules::dittoViz_scatterPlotServer()`](https://j-andrews7.github.io/VizModules/reference/dittoViz_scatterPlotServer.html):
the effect-size column on the x-axis, the significance column on the
y-axis (drawn as -log10), the auto-generated `group` colouring, and the
significance / fold-change thresholds. Sharing this between the UI and
server keeps the initial state and the reset state identical.

## Usage

``` r
.volcano_defaults(data, defaults = NULL)
```

## Arguments

- data:

  A differential-expression results data frame.

- defaults:

  An optional named list of user overrides.

## Value

A named list of scatter plot module defaults.

## Details

User-supplied `defaults` take precedence over the auto-detected values.

## Author

Jacob Martin
