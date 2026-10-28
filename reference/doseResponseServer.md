# Server logic for the dose-response module

Dose-response curve fitting built on the VizModules scatter plot module
([`VizModules::dittoViz_scatterPlotServer()`](https://j-andrews7.github.io/VizModules/reference/dittoViz_scatterPlotServer.html)).
The module registers a **drc** `"drm"` model backend and delegates to
the scatter plot server with dose-response defaults (dose on a log10
x-axis, response on the y-axis, and a `drc` log-logistic model drawn as
the fitted curve). Tabs and inputs that are not relevant to a single
dose-response curve are hidden.

## Usage

``` r
doseResponseServer(
  id,
  data,
  hide.inputs = NULL,
  hide.tabs = NULL,
  defaults = NULL
)
```

## Arguments

- id:

  The ID for the Shiny module.

- data:

  A `reactive` returning the dose-response data frame.

- hide.inputs:

  Additional input IDs to hide, on top of the module's built-in
  dose-response hidden set.

- hide.tabs:

  Additional tab names to hide, on top of the module's built-in
  dose-response hidden set.

- defaults:

  A named list of default values. Merged over the module's dose-response
  defaults (user values win).

## Value

The value returned by
[`VizModules::dittoViz_scatterPlotServer()`](https://j-andrews7.github.io/VizModules/reference/dittoViz_scatterPlotServer.html).

## See also

[`doseResponseInputsUI()`](https://j-andrews7.github.io/sciVizModules/reference/doseResponseInputsUI.md),
[`doseResponseOutputUI()`](https://j-andrews7.github.io/sciVizModules/reference/doseResponseOutputUI.md),
[`doseResponseApp()`](https://j-andrews7.github.io/sciVizModules/reference/doseResponseApp.md)

## Author

Jacob Martin

## Examples

``` r
library(sciVizModules)
if (interactive()) doseResponseApp()
```
