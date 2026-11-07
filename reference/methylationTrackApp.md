# Create a standalone Shiny app for the methylationTrack module

Generates a Shiny application with a selector over the supplied cohorts,
a read-only preview of the selected cohort's samples, and the track view
with its settings.

## Usage

``` r
methylationTrackApp(
  cohort_list = NULL,
  defaults = NULL,
  hide.inputs = NULL,
  hide.tabs = NULL
)
```

## Arguments

- cohort_list:

  An optional
  [`methylationCohort()`](https://j-andrews7.github.io/sciVizModules/reference/methylationCohort.md),
  anything that takes, or a named list of those.

- defaults:

  A named list of input IDs and their default values to apply on
  startup. With the example data, they are applied over the settings the
  module gallery opens the module on, a key given here replacing its
  showcase value.

- hide.inputs:

  A character vector of input IDs to hide. Their values are still
  initialized and used, but the controls are not shown in the UI.

- hide.tabs:

  A character vector of tab names to hide. Inputs in these tabs are
  still initialized and used. `NULL` (the default) keeps the module's
  own default.

## Value

A Shiny app object.

## Details

When `cohort_list` is not provided (or `NULL`), the app launches with
the bundled
[example_methylation](https://j-andrews7.github.io/sciVizModules/reference/example_methylation.md)
cohort, on the settings the module gallery
([`sciModuleGalleryApp()`](https://j-andrews7.github.io/sciVizModules/reference/sciModuleGalleryApp.md))
opens this module on.

## See also

[`methylationTrack()`](https://j-andrews7.github.io/sciVizModules/reference/methylationTrack.md),
[`methylationCohort()`](https://j-andrews7.github.io/sciVizModules/reference/methylationCohort.md),
[`methylationTrackInputsUI()`](https://j-andrews7.github.io/sciVizModules/reference/methylationTrackInputsUI.md),
[`methylationTrackOutputUI()`](https://j-andrews7.github.io/sciVizModules/reference/methylationTrackOutputUI.md),
[`methylationTrackServer()`](https://j-andrews7.github.io/sciVizModules/reference/methylationTrackServer.md)

## Author

Jared Andrews

## Examples

``` r
library(sciVizModules)
app <- methylationTrackApp()
if (interactive()) shiny::runApp(app)
```
