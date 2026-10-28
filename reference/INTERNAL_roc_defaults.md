# Default inputs for the rocCurve module

The response is the first two-valued column (preferring names such as
outcome, disease, status, class or label), the case its second value,
and the predictors up to three numeric columns.

## Usage

``` r
.roc_defaults(data, defaults = NULL)
```

## Arguments

- data:

  The data frame.

- defaults:

  A named list of user defaults, or `NULL`.

## Value

A named list of defaults.

## Author

Jared Andrews
