# Step coordinates of a Kaplan-Meier curve

A survival curve holds each estimate until the next time, so it is drawn
as steps. Each time after the first gets two rows, the previous estimate
and then its own, so straight segments through the rows draw the steps
exactly, for the curve and for both bounds of its band. A missing bound
(where the curve reaches zero, say) leaves a gap in the band from that
time on.

## Usage

``` r
.km_steps(km)
```

## Arguments

- km:

  A frame from
  [`.km_frame()`](https://j-andrews7.github.io/sciVizModules/reference/INTERNAL_km_frame.md).

## Value

A data frame with columns `.stratum`, `time`, `surv`, `lower` and
`upper`, each stratum's rows in drawing order.

## Author

Jared Andrews
