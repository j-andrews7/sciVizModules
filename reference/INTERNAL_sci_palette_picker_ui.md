# Render a group colour picker backed by a server-side store

The [`renderUI()`](https://rdrr.io/pkg/shiny/man/renderUI.html) the
native modules use for their group colours: the picker is built from the
same
[`resolve_palette()`](https://j-andrews7.github.io/VizModules/reference/resolve_palette.html)
result it seeds the store with, so its first report back is a no-op
rather than a redraw (see
[`setup_group_colors()`](https://j-andrews7.github.io/VizModules/reference/setup_group_colors.html)).

## Usage

``` r
.sci_palette_picker_ui(
  input,
  session,
  groups,
  store,
  default_palette_values,
  defaults,
  label = "Group Colors",
  key = "palette.colours"
)
```

## Arguments

- input, session:

  The module's input and session.

- groups:

  A reactive returning the group levels.

- store:

  The store from
  [`setup_group_colors()`](https://j-andrews7.github.io/VizModules/reference/setup_group_colors.html).

- default_palette_values:

  Fallback colours.

- defaults:

  The module defaults (for a caller-supplied mapping).

- label:

  Picker label.

- key:

  The picker's input id.

## Value

A [`renderUI()`](https://rdrr.io/pkg/shiny/man/renderUI.html) output.

## Author

Jared Andrews
