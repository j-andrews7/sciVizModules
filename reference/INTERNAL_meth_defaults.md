# The gene names of a cohort's transcripts

Shared by the module's UI and its Reset, so the two cannot drift.

Beta values run from 0 to 1, so the colour scale does too, and column
labels stand upright to fit their narrow columns.

## Usage

``` r
.meth_gene_names(cohort)

.meth_txn_types(cohort)

.meth_filter_levels(samples, col)

.meth_anno_groups(cohort, columns)

.meth_defaults(cohort, defaults = NULL)

.meth_axes_defaults(defaults)
```

## Arguments

- cohort:

  A `methylationCohort`.

- samples:

  A cohort's sample table.

- col:

  A column, or `""`.

- columns:

  The sample and CpG annotations drawn.

- defaults:

  A named list of user defaults, or `NULL`.

## Value

Sorted gene names.

Sorted transcript types.

The column's levels.

Strings of `"column: level"`, for the discrete ones.

A named list of defaults.

`defaults`, with those set where the caller did not set them.

## Author

Jared Andrews
