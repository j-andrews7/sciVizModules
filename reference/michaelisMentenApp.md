# Create a standalone Shiny app for the michaelisMenten module

This function generates a Shiny application with the modular
Michaelis-Menten plotting components: an inputs panel for configuring
the plot and an output panel showing the interactive `plotly` figure.

## Usage

``` r
michaelisMentenApp(
  data = NULL,
  model = NULL,
  stats = NULL,
  defaults = NULL,
  hide.inputs = NULL,
  hide.tabs = NULL,
  title = "Modular Michaelis-Menten Plot"
)
```

## Arguments

- data:

  The plotting data frame of observed points. If `NULL` (the default),
  the bundled
  [mm_kinetics](https://j-andrews7.github.io/sciVizModules/reference/mm_kinetics.md)
  is used, with
  [mm_kinetics_line](https://j-andrews7.github.io/sciVizModules/reference/mm_kinetics_line.md)
  as `model` and
  [mm_kinetics_fit](https://j-andrews7.github.io/sciVizModules/reference/mm_kinetics_fit.md)
  as `stats`.

- model:

  A data frame of fitted-line coordinates (e.g. `mml`) sharing the same
  x/y columns as `data`. Required when `data` is given.

- stats:

  Optional fitted model (e.g. an `nls` fit of `v ~ Vm * S / (K + S)`) or
  named coefficients from which K and Vmax are extracted for annotation.
  `NULL` (the default, when `data` is given) disables the annotation.

- defaults:

  An optional named list of default input values, applied over the
  gallery's settings when the example data is used.

- hide.inputs:

  A character vector of input IDs to hide. Their values are still
  initialized and used, but the controls are not shown in the UI.

- hide.tabs:

  A character vector of tab names to hide. Inputs in these tabs are
  still initialized and used.

- title:

  The app title.

## Value

A Shiny app object.

## Details

Unlike the upload-driven
[`VizModules::createModuleApp()`](https://j-andrews7.github.io/VizModules/reference/createModuleApp.html)
wrapper, this app takes the three data inputs directly because the
module needs more than a single data frame: the observed data, the
fitted line, and (optionally) the stats object used for K / Vmax
annotations.

When called with no arguments, the app launches with the bundled example
kinetics data
([mm_kinetics](https://j-andrews7.github.io/sciVizModules/reference/mm_kinetics.md),
[mm_kinetics_line](https://j-andrews7.github.io/sciVizModules/reference/mm_kinetics_line.md),
and
[mm_kinetics_fit](https://j-andrews7.github.io/sciVizModules/reference/mm_kinetics_fit.md)),
on the settings the module gallery
([`sciModuleGalleryApp()`](https://j-andrews7.github.io/sciVizModules/reference/sciModuleGalleryApp.md))
opens this module on.

## See also

[`michaelisMentenInputsUI()`](https://j-andrews7.github.io/sciVizModules/reference/michaelisMentenInputsUI.md),
[`michaelisMentenOutputUI()`](https://j-andrews7.github.io/sciVizModules/reference/michaelisMentenOutputUI.md),
[`michaelisMentenServer()`](https://j-andrews7.github.io/sciVizModules/reference/michaelisMentenServer.md),
[`michaelisMentenPlot()`](https://j-andrews7.github.io/sciVizModules/reference/michaelisMentenPlot.md)

## Author

Jacob Martin

## Examples

``` r
library(sciVizModules)
# Launch with the bundled example kinetics data:
app <- michaelisMentenApp()
if (interactive()) shiny::runApp(app)

# Launch with custom data:
data(mm_kinetics)
if (requireNamespace("drc", quietly = TRUE)) {
    library(drc)
    mm_model <- drm(v ~ S, data = mm_kinetics, fct = MM.2())
    mml <- data.frame(S = seq(min(mm_kinetics$S), max(mm_kinetics$S), length.out = 100))
    mml$v <- predict(mm_model, newdata = mml)
    stats <- nls(v ~ Vm * S / (K + S), data = mm_kinetics,
        start = list(K = max(mm_kinetics$v) / 2, Vm = max(mm_kinetics$v)))
    app2 <- michaelisMentenApp(mm_kinetics, mml, stats)
    if (interactive()) shiny::runApp(app2)
}
#> Loading required package: MASS
#> 
#> Attaching package: ‘MASS’
#> The following object is masked from ‘package:plotly’:
#> 
#>     select
#> 
#> 'drc' has been loaded.
#> Please cite R and 'drc' if used for a publication,
#> for references type 'citation()' and 'citation('drc')'.
#> 
#> Attaching package: ‘drc’
#> The following objects are masked from ‘package:stats’:
#> 
#>     gaussian, getInitial
```
