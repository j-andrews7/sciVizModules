# Fitted Michaelis-Menten model for the example kinetics data

An [`stats::nls()`](https://rdrr.io/r/stats/nls.html) fit of \\v = V_m S
/ (K + S)\\ to
[mm_kinetics](https://j-andrews7.github.io/sciVizModules/reference/mm_kinetics.md).
Its coefficients (`K` and `Vm`) provide the Michaelis constant and
maximum velocity used for the K / Vmax annotations in the
[`michaelisMentenServer()`](https://j-andrews7.github.io/sciVizModules/reference/michaelisMentenServer.md)
module.

## Usage

``` r
data(mm_kinetics_fit)
```

## Format

An object of class `nls`.

## Source

Fitted in `data-raw/generate_mm_kinetics.R`.

## See also

[mm_kinetics](https://j-andrews7.github.io/sciVizModules/reference/mm_kinetics.md),
[mm_kinetics_line](https://j-andrews7.github.io/sciVizModules/reference/mm_kinetics_line.md)

## Author

Jacob Martin

## Examples

``` r
library(sciVizModules)
data(mm_kinetics_fit)
coef(mm_kinetics_fit)
#>           K          Vm 
#> 0.439801572 0.005425232 
```
