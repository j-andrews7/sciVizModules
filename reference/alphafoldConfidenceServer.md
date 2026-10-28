# Server logic for the alphafoldConfidence module

Renders
[`alphafoldConfidence()`](https://j-andrews7.github.io/sciVizModules/reference/alphafoldConfidence.md)
for an object from
[`read_alphafold()`](https://j-andrews7.github.io/sciVizModules/reference/read_alphafold.md).
The per-residue pLDDT table is included in the source-data download as
the statistics table.

## Usage

``` r
alphafoldConfidenceServer(
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

  A `reactive` returning an object from
  [`read_alphafold()`](https://j-andrews7.github.io/sciVizModules/reference/read_alphafold.md).

- hide.inputs:

  A character vector of input IDs to hide.

- hide.tabs:

  A character vector of tab names to hide.

- defaults:

  A named list of default values used when resetting the inputs.
  Typically the same list passed to
  [`alphafoldConfidenceInputsUI()`](https://j-andrews7.github.io/sciVizModules/reference/alphafoldConfidenceInputsUI.md).

## Value

A `reactive` returning the source-data list.

## See also

[`alphafoldConfidence()`](https://j-andrews7.github.io/sciVizModules/reference/alphafoldConfidence.md),
[`read_alphafold()`](https://j-andrews7.github.io/sciVizModules/reference/read_alphafold.md),
[`alphafoldConfidenceInputsUI()`](https://j-andrews7.github.io/sciVizModules/reference/alphafoldConfidenceInputsUI.md),
[`alphafoldConfidenceOutputUI()`](https://j-andrews7.github.io/sciVizModules/reference/alphafoldConfidenceOutputUI.md),
[`alphafoldConfidenceApp()`](https://j-andrews7.github.io/sciVizModules/reference/alphafoldConfidenceApp.md)

## Author

Jared Andrews

## Examples

``` r
library(sciVizModules)
if (interactive()) alphafoldConfidenceApp()
```
