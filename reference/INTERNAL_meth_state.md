# The module's reactive state

Each reactive here is a step between the inputs and the draw function.
All are named in the cache key, as
[`.sci_plot_server()`](https://j-andrews7.github.io/sciVizModules/reference/INTERNAL_sci_plot_server.md)
does for anything in `state`, and each reads its inputs as the draw
function does, so Auto Update and reactive defaults reach them too.

## Usage

``` r
.meth_state(input, output, session, object, params, given.colors = NULL)
```

## Arguments

- input, output, session:

  The module's input, output and session.

- object:

  The reactive cohort.

- params:

  The store of reactive defaults.

- given.colors:

  The `anno.colors` in `defaults`, or `NULL`.

## Value

A list of `selected_samples`, `target`, `region_data`, `palette_groups`,
`palette_store`, `anno.defaults` and `palette`.

## Author

Jared Andrews
