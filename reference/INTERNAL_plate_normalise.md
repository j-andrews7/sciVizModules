# Normalise one plate's readout

Normalise one plate's readout

## Usage

``` r
.plate_normalise(x, row, col, role, method = "raw")
```

## Arguments

- x:

  Numeric readout of each well.

- row, col:

  Integer row and column of each well.

- role:

  `"positive"`, `"negative"` or `"sample"` for each well.

- method:

  One of `"raw"`, `"percent.control"` (percent of the negative control
  mean), `"percent.inhibition"` (0 at the negative, 100 at the positive
  control mean), `"zscore"` and `"robust.z"` (against the sample wells'
  mean / SD or median / MAD), or `"bscore"` (Tukey median-polish
  residuals of the sample wells, over their MAD; Brideau et al. 2003).

## Value

The normalised readout.

## Author

Jared Andrews
