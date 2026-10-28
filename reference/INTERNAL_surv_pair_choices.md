# Comparisons offered for a set of strata

Shared by
[`survivalCurveInputsUI()`](https://j-andrews7.github.io/sciVizModules/reference/survivalCurveInputsUI.md)
and the module server, which refills the Comparisons select when the
grouping changes.

## Usage

``` r
.surv_pair_choices(levels)
```

## Arguments

- levels:

  The strata, as from
  [`.surv_levels()`](https://j-andrews7.github.io/sciVizModules/reference/INTERNAL_surv_levels.md).

## Value

`"A vs B"` strings for every pair, in level order, or `character(0)` for
fewer than three strata, where the one comparison is the global test.

## Author

Jared Andrews
