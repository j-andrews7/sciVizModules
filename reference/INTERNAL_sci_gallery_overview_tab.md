# The gallery's Overview tab

The package's description, then every module as a card under its menu's
heading. A card opens its module's tab; one whose packages are missing
is greyed out and names them instead.

## Usage

``` r
.sci_gallery_overview_tab(showcase, info)
```

## Arguments

- showcase:

  A
  [`.sci_module_showcase()`](https://j-andrews7.github.io/sciVizModules/reference/INTERNAL_sci_module_showcase.md)
  registry.

- info:

  The list from
  [`.sci_gallery_package_info()`](https://j-andrews7.github.io/sciVizModules/reference/INTERNAL_sci_gallery_package_info.md).

## Value

A [`shiny::tabPanel()`](https://rdrr.io/pkg/shiny/man/tabPanel.html).

## Author

Jared Andrews
