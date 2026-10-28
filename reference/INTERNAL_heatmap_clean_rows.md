# Drop the rows a heatmap cannot cluster or scale

Rows holding a missing or non-finite value, or with no variance, make
Pearson distances and row z-scores undefined, and ComplexHeatmap then
fails inside the base module's observer.

## Usage

``` r
.heatmap_clean_rows(mat, min.rows = 2)
```

## Arguments

- mat:

  A numeric matrix.

- min.rows:

  The fewest rows to accept.

## Value

`mat` without those rows.

## Author

Jared Andrews
