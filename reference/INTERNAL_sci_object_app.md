# Build a standalone Shiny app for a module that takes a non-data-frame object

The counterpart of
[`.ditto_module_app()`](https://j-andrews7.github.io/sciVizModules/reference/INTERNAL_ditto_module_app.md)
for the PCAtools and AlphaFold modules: an object selector over a named
list of objects and a read-only preview table, since such objects cannot
be edited in a data table.

## Usage

``` r
.sci_object_app(
  inputs_ui_fn,
  output_ui_fn,
  server_fn,
  object_list,
  title,
  validate,
  preview,
  select_label = "Select Object:",
  preview_title = "Preview",
  preview_note = "",
  defaults = NULL,
  hide.inputs = NULL,
  hide.tabs = NULL
)
```

## Arguments

- inputs_ui_fn, output_ui_fn, server_fn:

  The module's functions.

- object_list:

  A named list of objects.

- title:

  Page title.

- validate:

  A function erroring on an object the module cannot take.

- preview:

  A function returning the data frame to preview for an object.

- select_label, preview_title, preview_note:

  Labels for the selector and the preview.

- defaults, hide.inputs, hide.tabs:

  Passed to the module; `NULL` ones are left to the module's own
  defaults (see
  [`.sci_server_args()`](https://j-andrews7.github.io/sciVizModules/reference/INTERNAL_sci_server_args.md)).

## Value

A [`shiny::shinyApp()`](https://rdrr.io/pkg/shiny/man/shinyApp.html)
object.

## Author

Jared Andrews
