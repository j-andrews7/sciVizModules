# Launch the sciVizModules module gallery

Builds the **sciVizModules Gallery**: every module on its own tab, each
opening on an example dataset with the module's main features already
switched on (labelled genes and variants, risk tables, trajectories,
terminal fits, annotation tracks, splits and so on), plus a **Figure
Builder** tab for composing the data-frame modules into one multi-panel
figure.

## Usage

``` r
sciModuleGalleryApp(title = "sciVizModules Gallery", return_components = FALSE)
```

## Arguments

- title:

  A character string used as the navbar title and page title.

- return_components:

  Logical. When `FALSE` (the default) a
  [`shiny::shinyApp()`](https://rdrr.io/pkg/shiny/man/shinyApp.html)
  object is returned. When `TRUE` a named list with `ui` and `server`
  elements is returned instead, which is convenient for deployment
  scripts that need an explicit `shinyApp(ui, server)` call.

## Value

Either a
[`shiny::shinyApp()`](https://rdrr.io/pkg/shiny/man/shinyApp.html)
object, or (when `return_components = TRUE`) a list with elements `ui`
and `server`.

## Details

The tabs sit in navbar menus by field (Expression, Enrichment,
Single-cell, PCA, Genomics, Mutations, Clinical, Pharmacology,
Structure), and an **Overview** page lists every module as a card that
opens its tab. Each tab carries the module's full set of controls, a
link to its reference documentation, and beneath the plot either a
filterable data table that feeds it (for the modules that take a data
frame) or a read-only preview of the object it is bound to.

A module's server starts the first time its tab is opened, so the
gallery launches quickly and a module that is never visited costs
nothing. Example datasets are read once and shared between the tabs that
use them.

The settings each tab opens on are the ones the module's own `*App()`
function (e.g.
[`volcanoPlotApp()`](https://j-andrews7.github.io/sciVizModules/reference/volcanoPlotApp.md))
and the Figure Builder start from, so any of them can be reproduced by
passing the same `defaults` to the module in your own app.

Modules whose optional packages are not installed are left out, and
their cards on the Overview name the packages to install: the heatmap
modules need ComplexHeatmap, InteractiveComplexHeatmap and circlize; the
bulk expression modules the airway data package; the somatic-mutation
modules maftools; `goFanPlot` GOfan and org.Hs.eg.db; and `doseResponse`
drc.

The same app ships as
`system.file("apps/module-gallery", package = "sciVizModules")` for
deployment to a Shiny server, shinyapps.io or Posit Connect.

## See also

[`sciFigureBuilderApp()`](https://j-andrews7.github.io/sciVizModules/reference/sciFigureBuilderApp.md),
[`VizModules::moduleGalleryApp()`](https://j-andrews7.github.io/VizModules/reference/moduleGalleryApp.html)
for the VizModules modules.

## Author

Jared Andrews

## Examples

``` r
library(sciVizModules)
app <- sciModuleGalleryApp()
if (interactive()) shiny::runApp(app)

# The UI and server separately, e.g. for a deployment app.R:
parts <- sciModuleGalleryApp(return_components = TRUE)
if (interactive()) shiny::shinyApp(parts$ui, parts$server)
```
