# Server logic for the mafSummary module

Renders
[`mafSummary()`](https://j-andrews7.github.io/sciVizModules/reference/mafSummary.md).
The per-sample variant counts by classification are included in the
source-data download as the statistics table.

## Usage

``` r
mafSummaryServer(
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

  A `reactive` returning a maftools `MAF` object or a data frame in MAF
  columns.

- hide.inputs:

  A character vector of input IDs to hide.

- hide.tabs:

  A character vector of tab names to hide.

- defaults:

  A named list of default values used when resetting the inputs.
  Typically the same list passed to
  [`mafSummaryInputsUI()`](https://j-andrews7.github.io/sciVizModules/reference/mafSummaryInputsUI.md).

## Value

A `reactive` returning the source-data list.

## See also

[`mafSummary()`](https://j-andrews7.github.io/sciVizModules/reference/mafSummary.md),
[`mafSummaryInputsUI()`](https://j-andrews7.github.io/sciVizModules/reference/mafSummaryInputsUI.md),
[`mafSummaryOutputUI()`](https://j-andrews7.github.io/sciVizModules/reference/mafSummaryOutputUI.md),
[`mafSummaryApp()`](https://j-andrews7.github.io/sciVizModules/reference/mafSummaryApp.md)

## Author

Jared Andrews

## Examples

``` r
library(sciVizModules)
if (interactive()) mafSummaryApp()
```
