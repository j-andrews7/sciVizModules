# One module's gallery tab

Its controls beside the plot, with the module's description and docs
link above the plot and, beneath it, the filterable data table that
feeds it or a read-only preview of the object it is bound to.

## Usage

``` r
.sci_gallery_module_tab(id, entry, info)
```

## Arguments

- id:

  The module id, used as the module's namespace.

- entry:

  The module's
  [`.sci_module_showcase()`](https://j-andrews7.github.io/sciVizModules/reference/INTERNAL_sci_module_showcase.md)
  entry.

- info:

  The list from
  [`.sci_gallery_package_info()`](https://j-andrews7.github.io/sciVizModules/reference/INTERNAL_sci_gallery_package_info.md).

## Value

A [`shiny::tabPanel()`](https://rdrr.io/pkg/shiny/man/tabPanel.html).

## Author

Jared Andrews
