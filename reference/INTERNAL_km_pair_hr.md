# Hazard ratio of a pair of strata

Hazard ratio of a pair of strata

## Usage

``` r
.km_pair_hr(d)
```

## Arguments

- d:

  One pair's subjects, `.stratum` a factor with the reference first.

## Value

The hazard ratio of the second level against the first and its 95% Wald
interval, or three `NA`s when the Cox model has no finite estimate.

## Author

Jared Andrews
