# The example-data catalogue

Each entry loads one example dataset on demand, so an `*App()` reads
only the data it opens on. `needs` names the Suggests packages a dataset
is read from, and `label` is the name an `*App()`'s dataset selector
shows.

## Usage

``` r
.sci_example_catalogue()
```

## Value

A named list of `list(load =, needs =, label =)` entries.

## Author

Jared Andrews
