# Merge enrichment default mappings into a user-supplied defaults list

User-supplied defaults take precedence over the auto-detected mappings.

## Usage

``` r
.enrich_defaults(defaults, mapping)
```

## Arguments

- defaults:

  A named list of user defaults (or `NULL`).

- mapping:

  The mapping list produced by
  [`.prepare_enrichment()`](https://j-andrews7.github.io/sciVizModules/reference/INTERNAL_prepare_enrichment.md).

## Value

A named list of defaults keyed by DotPlot UI input IDs.

## Author

Jacob Martin, Jared Andrews
