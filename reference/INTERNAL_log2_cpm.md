# Log2 counts per million

Computed as [`edgeR::cpm()`](https://rdrr.io/pkg/edgeR/man/cpm.html)
does with `log = TRUE`: the prior count is scaled by each library's size
relative to the mean, and twice it is added to the library size, so a
zero count maps to a finite value and libraries of different depth are
treated alike.

## Usage

``` r
.log2_cpm(counts, prior.count = 2)
```

## Arguments

- counts:

  A numeric matrix of counts, features by samples.

- prior.count:

  The average prior count added to each observation.

## Value

A matrix of log2 CPM values.

## Author

Jared Andrews
