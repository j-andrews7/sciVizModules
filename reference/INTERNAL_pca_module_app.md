# Build a standalone Shiny app for a PCAtools module

[`.sci_object_app()`](https://j-andrews7.github.io/sciVizModules/reference/INTERNAL_sci_object_app.md)
over a named list of `pca` objects, previewing each object's sample
metadata.

## Usage

``` r
.pca_module_app(
  inputs_ui_fn,
  output_ui_fn,
  server_fn,
  pca_list,
  title,
  defaults = NULL,
  hide.inputs = NULL,
  hide.tabs = NULL
)
```

## Arguments

- inputs_ui_fn, output_ui_fn, server_fn:

  The module's functions.

- pca_list:

  A named list of PCAtools `pca` objects.

- title:

  Page title.

- defaults, hide.inputs, hide.tabs:

  Passed to the module.

## Value

A [`shiny::shinyApp()`](https://rdrr.io/pkg/shiny/man/shinyApp.html)
object.

## Author

Jared Andrews
