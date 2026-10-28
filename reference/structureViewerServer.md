# Server logic for the structureViewer module

Renders the structure once per structure, then applies every style
change - representation, colours, highlighted residues, background,
spin - through the viewer's proxy, so the structure is restyled in place
and the view is kept.

## Usage

``` r
structureViewerServer(
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
  [`read_structure()`](https://j-andrews7.github.io/sciVizModules/reference/read_structure.md).

- hide.inputs:

  A character vector of input IDs to hide.

- hide.tabs:

  A character vector of tab names to hide.

- defaults:

  A named list of default values used when resetting the inputs.
  Typically the same list passed to
  [`structureViewerInputsUI()`](https://j-andrews7.github.io/sciVizModules/reference/structureViewerInputsUI.md).

## Value

A `reactive` returning the structure.

## See also

[`structureViewer()`](https://j-andrews7.github.io/sciVizModules/reference/structureViewer.md),
[`read_structure()`](https://j-andrews7.github.io/sciVizModules/reference/read_structure.md),
[`structureViewerInputsUI()`](https://j-andrews7.github.io/sciVizModules/reference/structureViewerInputsUI.md),
[`structureViewerOutputUI()`](https://j-andrews7.github.io/sciVizModules/reference/structureViewerOutputUI.md),
[`structureViewerApp()`](https://j-andrews7.github.io/sciVizModules/reference/structureViewerApp.md)

## Author

Jared Andrews

## Examples

``` r
library(sciVizModules)
if (interactive()) structureViewerApp()
```
