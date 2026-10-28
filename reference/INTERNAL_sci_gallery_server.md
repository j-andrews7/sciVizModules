# The gallery's server

Each module's server, data table or preview, and inputs start the first
time its tab is opened, as does the Figure Builder. Datasets are read
once per app and shared between the tabs, and the sessions, that use
them.

## Usage

``` r
.sci_gallery_server(showcase, load = .sci_example_dataset)
```

## Arguments

- showcase:

  A
  [`.sci_module_showcase()`](https://j-andrews7.github.io/sciVizModules/reference/INTERNAL_sci_module_showcase.md)
  registry.

- load:

  A function loading a dataset by its catalogue key.

## Value

A Shiny server function.

## Author

Jared Andrews
