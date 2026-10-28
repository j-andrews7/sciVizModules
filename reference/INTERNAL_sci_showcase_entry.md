# Build one showcase entry

Looks the module's `*InputsUI()`, `*OutputUI()` and `*Server()` up by
name, so an entry cannot name one module and wire another.

## Usage

``` r
.sci_showcase_entry(
  module,
  label,
  tab_label,
  group,
  description,
  dataset,
  kind = c("df", "object"),
  defaults = list(),
  needs = character(0),
  preview = NULL,
  ui_data = NULL,
  app_datasets = NULL,
  figure_builder = FALSE
)
```

## Arguments

- module:

  The module's base name, e.g. `"volcanoPlot"`.

- label:

  The module's name in the Figure Builder's picker and on its gallery
  card.

- tab_label:

  The shorter name on its gallery tab.

- group:

  The gallery menu it sits under, one of `.sci_gallery_groups`.

- description:

  One line for its gallery card and tab.

- dataset:

  The
  [`.sci_example_catalogue()`](https://j-andrews7.github.io/sciVizModules/reference/INTERNAL_sci_example_catalogue.md)
  key its `defaults` are written for.

- kind:

  `"df"` for a data frame fed through a filterable data table, or
  `"object"` for an object shown in a read-only preview.

- defaults:

  The input defaults it opens on.

- needs:

  Suggests packages the module needs beyond its dataset's.

- preview:

  For `"object"` entries, a function returning the data frame the
  gallery previews.

- ui_data:

  Optional function returning what `*InputsUI()` is given from the
  dataset, when that differs from what the server takes.

- app_datasets:

  Further catalogue keys its `*App()` also offers.

- figure_builder:

  Whether it is offered by the Figure Builder.

## Value

A showcase entry.

## Author

Jared Andrews
