# Build the choices for a continuous selector (numeric metadata + genes)

Build the choices for a continuous selector (numeric metadata + genes)

## Usage

``` r
.ditto_continuous_choices(object, include.blank = TRUE)
```

## Arguments

- object:

  A dittoSeq-compatible object.

- include.blank:

  Whether to prepend an empty choice.

## Value

A named character vector suitable for
[`VizModules::viz_select_input()`](https://j-andrews7.github.io/VizModules/reference/viz_select_input.html)
choices.

## Author

Jacob Martin, Jared Andrews
