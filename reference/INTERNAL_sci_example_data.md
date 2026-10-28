# Load a bundled example dataset

The package's example datasets live in `data/` and `DESCRIPTION` sets no
`LazyData`, deliberately: Bioconductor asks packages not to, and these
`.rda` files are large. That means they are *not* promises in the
package namespace, so package code cannot reach them by name – a
`*App()` whose default data is a bare `example_sce` fails with "object
not found" for anyone who has not run
[`utils::data()`](https://rdrr.io/r/utils/data.html) themselves first.

## Usage

``` r
.sci_example_data(name)
```

## Arguments

- name:

  Character string naming a dataset in this package's `data/`.

## Value

The dataset object.

## Details

This loads one into a throwaway environment and returns it, so the
default arguments and `data_list` fallbacks in the `*App()` functions
work without attaching anything to the caller's workspace.

## Author

Jared Andrews
