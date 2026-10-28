# ROC curve, AUC and Youden cut-off of one predictor

Thresholds are the midpoints between consecutive distinct predictor
values, plus -Inf and Inf, as in pROC. With direction `"<"`, a value
above the threshold is called a case.

## Usage

``` r
.roc_curve(case, x, direction = "auto")
```

## Arguments

- case:

  Logical vector, `TRUE` for cases.

- x:

  Numeric predictor.

- direction:

  `"auto"`, `"<"` or `">"`.

## Value

A list with `curve` (threshold, sensitivity, specificity, from (0, 0) to
(1, 1)), `auc`, `direction` and `youden` (the row maximising
sensitivity + specificity - 1).

## Author

Jared Andrews
