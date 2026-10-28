# Server logic for the mutationLollipop module

Renders
[`mutationLollipop()`](https://j-andrews7.github.io/sciVizModules/reference/mutationLollipop.md).
The plotted counts (one row per position, protein change and class) are
included in the source-data download as the statistics table.

## Usage

``` r
mutationLollipopServer(
  id,
  data,
  hide.inputs = NULL,
  hide.tabs = NULL,
  defaults = NULL,
  domains = NULL
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
  [`mutationLollipopInputsUI()`](https://j-andrews7.github.io/sciVizModules/reference/mutationLollipopInputsUI.md).

- domains:

  Optional domain table used in place of maftools' (see
  [`mutationLollipop()`](https://j-andrews7.github.io/sciVizModules/reference/mutationLollipop.md)):
  a data frame with `gene`, `start`, `end` and `label` columns, or a
  `reactive` returning one. Rows for the drawn gene are used.

## Value

A `reactive` returning the source-data list.

## See also

[`mutationLollipop()`](https://j-andrews7.github.io/sciVizModules/reference/mutationLollipop.md),
[`mutationLollipopInputsUI()`](https://j-andrews7.github.io/sciVizModules/reference/mutationLollipopInputsUI.md),
[`mutationLollipopOutputUI()`](https://j-andrews7.github.io/sciVizModules/reference/mutationLollipopOutputUI.md),
[`mutationLollipopApp()`](https://j-andrews7.github.io/sciVizModules/reference/mutationLollipopApp.md)

## Author

Jared Andrews

## Examples

``` r
library(sciVizModules)
if (interactive()) mutationLollipopApp()
```
