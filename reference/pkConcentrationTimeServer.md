# Server logic for the pkConcentrationTime module

Renders
[`pkConcentrationTime()`](https://j-andrews7.github.io/sciVizModules/reference/pkConcentrationTime.md).
The per-subject non-compartmental parameters are included in the
source-data download as the statistics table.

## Usage

``` r
pkConcentrationTimeServer(
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

  A `reactive` containing the concentration-time data frame.

- hide.inputs:

  A character vector of input IDs to hide.

- hide.tabs:

  A character vector of tab names to hide.

- defaults:

  A named list of default values used when resetting the inputs.
  Typically the same list passed to
  [`pkConcentrationTimeInputsUI()`](https://j-andrews7.github.io/sciVizModules/reference/pkConcentrationTimeInputsUI.md).

## Value

A `reactive` returning the source-data list.

## See also

[`pkConcentrationTime()`](https://j-andrews7.github.io/sciVizModules/reference/pkConcentrationTime.md),
[`pkConcentrationTimeInputsUI()`](https://j-andrews7.github.io/sciVizModules/reference/pkConcentrationTimeInputsUI.md),
[`pkConcentrationTimeOutputUI()`](https://j-andrews7.github.io/sciVizModules/reference/pkConcentrationTimeOutputUI.md),
[`pkConcentrationTimeApp()`](https://j-andrews7.github.io/sciVizModules/reference/pkConcentrationTimeApp.md)

## Author

Jared Andrews

## Examples

``` r
library(sciVizModules)
if (interactive()) pkConcentrationTimeApp()
```
