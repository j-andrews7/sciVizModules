# Choose samples from a column's levels and a filter expression

Both apply when both are given. Levels no longer in the column are
ignored: the choices trail a change of column by a round trip to the
browser.

## Usage

``` r
.meth_select_samples(
  samples,
  filter.col = "",
  filter.levels = NULL,
  expression = ""
)

.meth_sample_status(samples, keep)

.meth_levels(x)
```

## Arguments

- samples:

  A cohort's sample table.

- filter.col:

  A column of `samples`, or `""`.

- filter.levels:

  The levels of it to keep; none keeps all.

- expression:

  A filter over the columns of `samples`, or `""`.

- keep:

  The logical vector from `.meth_select_samples()`.

- x:

  A vector.

## Value

A logical vector over the rows of `samples`.

A string such as `"14 of 23 samples: HM450 6, EPIC 5, EPICv2 3"`.

Factor levels in use, or the sorted values, as strings.

## Author

Jared Andrews
