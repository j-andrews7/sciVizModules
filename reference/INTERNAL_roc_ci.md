# DeLong confidence interval of an AUC

DeLong confidence interval of an AUC

## Usage

``` r
.roc_ci(case, x, direction, level = 0.95)
```

## Arguments

- case:

  Logical vector, `TRUE` for cases.

- x:

  Numeric predictor.

- direction:

  `"<"` or `">"`.

- level:

  Confidence level.

## Value

The lower and upper bounds, or `c(NA, NA)` when pROC is not installed.

## Author

Jared Andrews
