# Figure Builder app seeded with the sciVizModules modules

A thin wrapper around
[`VizModules::figureBuilderApp()`](https://j-andrews7.github.io/VizModules/reference/figureBuilderApp.html)
that hands it
[`sci_figure_builder_registry()`](https://j-andrews7.github.io/sciVizModules/reference/sci_figure_builder_registry.md)
and this package's bundled datasets, so scientific panels can be
dragged, sized and exported as one multi-panel figure with a per-panel
source-data archive.

## Usage

``` r
sciFigureBuilderApp(
  data_list = NULL,
  module_registry = NULL,
  title = "sciVizModules Figure Builder",
  return_components = FALSE
)
```

## Arguments

- data_list:

  An optional named list of data frames seeding the dataset registry.
  Defaults to this package's bundled example data.

- module_registry:

  An optional registry overriding
  [`sci_figure_builder_registry()`](https://j-andrews7.github.io/sciVizModules/reference/sci_figure_builder_registry.md).

- title:

  The app title.

- return_components:

  Logical; when `TRUE`, return `list(ui =, server =)` instead of a
  [`shiny::shinyApp()`](https://rdrr.io/pkg/shiny/man/shinyApp.html)
  object, e.g. for a deployment `app.R`.

## Value

A [`shiny::shinyApp()`](https://rdrr.io/pkg/shiny/man/shinyApp.html)
object, or a list of `ui` and `server` components when
`return_components = TRUE`.

## Details

The builder offers only the modules in the registry it is given. To have
the VizModules panels available alongside these ones, pass a combined
registry and a combined dataset list (see the examples).

## See also

[`sci_figure_builder_registry()`](https://j-andrews7.github.io/sciVizModules/reference/sci_figure_builder_registry.md),
[`VizModules::figureBuilderApp()`](https://j-andrews7.github.io/VizModules/reference/figureBuilderApp.html)

## Author

Jared Andrews

## Examples

``` r
library(sciVizModules)
app <- sciFigureBuilderApp()
if (interactive()) shiny::runApp(app)

if (FALSE) { # \dontrun{
# Offer a VizModules panel alongside these ones. A registry entry is just a
# list of the module's trio plus a dataset name and its defaults.
data(airway_deseq2)
registry <- c(
    sci_figure_builder_registry(),
    list(box = list(
        label = "Box Plot", dataset = "airway_deseq2",
        inputs_ui = VizModules::plotthis_BoxPlotInputsUI,
        output_ui = VizModules::plotthis_BoxPlotOutputUI,
        server_fn = VizModules::plotthis_BoxPlotServer,
        defaults = list("y.data" = "log2FoldChange")
    ))
)
sciFigureBuilderApp(module_registry = registry)
} # }
```
