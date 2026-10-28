# Example Michaelis-Menten enzyme-kinetics observations (simulated)

A small, self-contained set of enzyme-kinetics observations (substrate
concentration versus reaction velocity) provided as ready-to-use example
data for the
[`michaelisMentenServer()`](https://j-andrews7.github.io/sciVizModules/reference/michaelisMentenServer.md)
module and
[`michaelisMentenPlot()`](https://j-andrews7.github.io/sciVizModules/reference/michaelisMentenPlot.md).

## Usage

``` r
data(mm_kinetics)
```

## Format

A data frame with 19 rows and 2 columns:

- S:

  Substrate concentration (mM)

- v:

  Reaction velocity (dE/min)

## Source

Simulated in `data-raw/generate_mm_kinetics.R`; no real biological data
are included.

## See also

[mm_kinetics_line](https://j-andrews7.github.io/sciVizModules/reference/mm_kinetics_line.md),
[mm_kinetics_fit](https://j-andrews7.github.io/sciVizModules/reference/mm_kinetics_fit.md)

## Author

Jacob Martin

## Examples

``` r
library(sciVizModules)
data(mm_kinetics)
head(mm_kinetics)
#>        S           v
#> 1 3.6000 0.004407692
#> 2 1.8000 0.004192308
#> 3 0.9000 0.003553846
#> 4 0.4500 0.002576923
#> 5 0.2250 0.001661538
#> 6 0.1125 0.001064286
```
