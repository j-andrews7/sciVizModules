# Shared input layout for the native plot modules

Shared input layout for the native plot modules

## Usage

``` r
.sci_plot_inputs_ui(
  ns,
  name,
  data_tab,
  aes_tab,
  defaults,
  title,
  columns,
  lines = TRUE,
  legend = TRUE
)
```

## Arguments

- ns:

  The module's namespace function.

- name:

  The module name (stem of the tabset id).

- data_tab, aes_tab:

  `tagList`s for the module's Data and Aesthetics tabs.

- defaults:

  Defaults for the uniform tabs.

- title, columns:

  As for the module UIs.

- lines:

  Logical; include the Lines tab.

- legend:

  Logical; include the Legend tab.

## Value

The organised inputs.

## Author

Jared Andrews
