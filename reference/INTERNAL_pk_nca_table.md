# Non-compartmental analysis per subject

Non-compartmental analysis per subject

## Usage

``` r
.pk_nca_table(
  data,
  time,
  conc,
  subject,
  dose = NULL,
  group = NULL,
  auc.method = "lin up/log down"
)
```

## Arguments

- data:

  The concentration-time data.

- time, conc, subject:

  Column names.

- dose:

  Dose column, or `NULL`.

- group:

  Group column, or `NULL`.

- auc.method:

  Passed to
  [`.pk_nca()`](https://j-andrews7.github.io/sciVizModules/reference/INTERNAL_pk_nca.md).

## Value

A data frame with one row per subject: `subject`, `group`, then the
[`.pk_nca()`](https://j-andrews7.github.io/sciVizModules/reference/INTERNAL_pk_nca.md)
parameters.

## Author

Jared Andrews
