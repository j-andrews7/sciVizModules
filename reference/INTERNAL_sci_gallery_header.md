# The gallery's header: its stylesheet, script, and navbar links

Every CSS rule is anchored on `.scivizmodules-gallery`, the class
[`.sci_gallery_ui()`](https://j-andrews7.github.io/sciVizModules/reference/INTERNAL_sci_gallery_ui.md)
wraps the page in, so the gallery restyles nothing outside itself (see
the CSS containment notes in AGENTS.md).

## Usage

``` r
.sci_gallery_header(info)
```

## Arguments

- info:

  The list from
  [`.sci_gallery_package_info()`](https://j-andrews7.github.io/sciVizModules/reference/INTERNAL_sci_gallery_package_info.md).

## Value

A
[`shiny::tagList()`](https://rstudio.github.io/htmltools/reference/tagList.html).

## Author

Jared Andrews
