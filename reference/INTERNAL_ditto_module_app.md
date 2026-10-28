# Build a standalone Shiny app for a dittoSeq-based module

Internal factory that mirrors
[`VizModules::createModuleApp()`](https://j-andrews7.github.io/VizModules/reference/createModuleApp.html)
but for modules whose data are `SingleCellExperiment`, `Seurat`, or
`SummarizedExperiment` objects rather than data frames. Because those
objects cannot be edited in the interactive data-table used by
[`VizModules::createModuleApp()`](https://j-andrews7.github.io/VizModules/reference/createModuleApp.html),
this factory instead offers an object selector and a read-only metadata
(`colData`) preview.

## Usage

``` r
.ditto_module_app(
  inputs_ui_fn,
  output_ui_fn,
  server_fn,
  object_list,
  title,
  defaults = NULL,
  hide.inputs = NULL,
  hide.tabs = NULL
)
```

## Arguments

- inputs_ui_fn:

  A module `*InputsUI(id, data, ...)` function.

- output_ui_fn:

  A module `*OutputUI(id)` function.

- server_fn:

  A module `*Server(id, data, ...)` function.

- object_list:

  A named list of dittoSeq-compatible objects.

- title:

  A character string used as the page title.

- defaults, hide.inputs, hide.tabs:

  Passed to the module; `NULL` ones are left to the module's own
  defaults (see
  [`.sci_server_args()`](https://j-andrews7.github.io/sciVizModules/reference/INTERNAL_sci_server_args.md)).

## Value

A [`shiny::shinyApp()`](https://rdrr.io/pkg/shiny/man/shinyApp.html)
object.

## Author

Jacob Martin
