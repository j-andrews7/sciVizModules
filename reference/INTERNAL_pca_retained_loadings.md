# Variables retained by PCAtools' `rangeRetain` rule

Variables retained by PCAtools' `rangeRetain` rule

## Usage

``` r
.pca_retained_loadings(ld, range.retain)
```

## Arguments

- ld:

  A data frame of loadings (variables x components).

- range.retain:

  Fraction of each component's loading range.

## Value

Integer row indices of the retained variables, in first-retained order.

## Author

Jared Andrews
