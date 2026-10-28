# Normalize a survival status/event indicator to 0/1

Coerces a variety of status encodings to a numeric 0 (censored) / 1
(event) vector suitable for
[`survival::Surv()`](https://rdrr.io/pkg/survival/man/Surv.html).

## Usage

``` r
.normalize_survival_status(x)
```

## Arguments

- x:

  A status vector: numeric (`0`/`1` or `1`/`2`), logical, or a two-level
  factor/character.

## Value

A numeric vector of 0 (censored) and 1 (event) values.

## Author

Jacob Martin
