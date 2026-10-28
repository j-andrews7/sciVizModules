# Censoring mark traces of a survival curve

One trace per stratum with censored subjects: a tick on the curve at
each time a subject was censored, in the stratum's colour and legend
group.

## Usage

``` r
.km_censor_traces(km, palette)
```

## Arguments

- km:

  A frame from
  [`.km_frame()`](https://j-andrews7.github.io/sciVizModules/reference/INTERNAL_km_frame.md).

- palette:

  Colours named by stratum.

## Value

A list of plotly trace lists, for a built figure's `x$data`.

## Author

Jared Andrews
