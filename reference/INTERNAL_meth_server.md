# The table previewed for a cohort

Neither this nor the gene select is frozen around an update: a value
that does not change is never echoed back, which would hold the plot
forever. Stale levels are ignored where they are read, by
[`.meth_select_samples()`](https://j-andrews7.github.io/sciVizModules/reference/INTERNAL_meth_samples.md).

## Usage

``` r
.meth_preview(cohort)

.meth_lookup_toggle(input, session, hidden)

.meth_filter_updates(input, session, object)
```

## Arguments

- cohort:

  A `methylationCohort`.

- input, session:

  The module's input and session.

- hidden:

  Inputs the app hides, which stay hidden.

- object:

  The reactive cohort.

## Value

Its sample table.

An observer.

An observer.

## Author

Jared Andrews
