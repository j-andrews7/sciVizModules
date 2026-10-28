# The showcase registry: each module, its example dataset, and its defaults

The showcase registry: each module, its example dataset, and its
defaults

## Usage

``` r
.sci_module_showcase()
```

## Value

A named list of entries, keyed by module id.

## Details

One entry per module in the package, whatever is installed; see
[`.sci_showcase_entry()`](https://j-andrews7.github.io/sciVizModules/reference/INTERNAL_sci_showcase_entry.md)
for the fields. Entries whose packages are missing
([`.sci_showcase_missing()`](https://j-andrews7.github.io/sciVizModules/reference/INTERNAL_sci_showcase_missing.md))
are left out of the gallery and the Figure Builder when those are built,
so the registry itself stays complete and
`tests/testthat/test-showcase.R` can check it against the package's
modules.

## Author

Jared Andrews
