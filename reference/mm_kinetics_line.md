# Fitted Michaelis-Menten curve for the example kinetics data

The fitted Michaelis-Menten curve for
[mm_kinetics](https://j-andrews7.github.io/sciVizModules/reference/mm_kinetics.md),
predicted over a fine grid of substrate concentrations. This is the
pre-computed line (`mml`) passed as the `model` argument to
[`michaelisMentenPlot()`](https://j-andrews7.github.io/sciVizModules/reference/michaelisMentenPlot.md).

## Usage

``` r
data(mm_kinetics_line)
```

## Format

A data frame with 100 rows and 2 columns:

- S:

  Substrate concentration (mM)

- v:

  Predicted reaction velocity (dE/min)

## Source

Predicted from
[mm_kinetics_fit](https://j-andrews7.github.io/sciVizModules/reference/mm_kinetics_fit.md)
in `data-raw/generate_mm_kinetics.R`.

## See also

[mm_kinetics](https://j-andrews7.github.io/sciVizModules/reference/mm_kinetics.md),
[mm_kinetics_fit](https://j-andrews7.github.io/sciVizModules/reference/mm_kinetics_fit.md)

## Author

Jacob Martin

## Examples

``` r
library(sciVizModules)
data(mm_kinetics_line)
head(mm_kinetics_line)
#>            S            v
#> 1 0.00000000 0.0000000000
#> 2 0.03636364 0.0004143125
#> 3 0.07272727 0.0007698344
#> 4 0.10909091 0.0010782504
#> 5 0.14545455 0.0013483408
#> 6 0.18181818 0.0015868316
```
