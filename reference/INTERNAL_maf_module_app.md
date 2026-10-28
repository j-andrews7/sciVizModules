# Build a standalone Shiny app for a mutation module

[`VizModules::createModuleApp()`](https://j-andrews7.github.io/VizModules/reference/createModuleApp.html)
over the supplied MAFs (maftools `MAF` objects become data frames first,
since the app's table holds data frames).

## Usage

``` r
.maf_module_app(
  inputs_ui_fn,
  output_ui_fn,
  server_fn,
  data_list,
  title,
  defaults = NULL,
  hide.inputs = NULL,
  hide.tabs = NULL
)
```

## Arguments

- inputs_ui_fn, output_ui_fn, server_fn:

  The module's functions.

- data_list:

  A named list of MAF data frames or maftools `MAF` objects, or `NULL`
  for maftools' TCGA LAML example (see
  [`.maf_example()`](https://j-andrews7.github.io/sciVizModules/reference/INTERNAL_maf_example.md)).

- title:

  Page title.

- defaults, hide.inputs, hide.tabs:

  Passed to the module.

## Value

A [`shiny::shinyApp()`](https://rdrr.io/pkg/shiny/man/shinyApp.html)
object.

## Author

Jared Andrews
