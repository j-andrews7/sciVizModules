# Example dose-response data (simulated)

A small, self-contained dose-response dataset: a serial dilution of
doses with triplicate percent-response readings and per-dose mean and
standard deviation. Provided as ready-to-use example data for the
[`doseResponseServer()`](https://j-andrews7.github.io/sciVizModules/reference/doseResponseServer.md)
module. The response follows a smooth sigmoidal (log-logistic) shape
suitable for [`drc::drm()`](https://rdrr.io/pkg/drc/man/drm.html)
fitting.

## Usage

``` r
data(dose_response)
```

## Format

A data frame with 9 rows and 6 columns:

- dose_uM:

  Dose / concentration (uM)

- rep1_response_pct:

  Percent response, replicate 1

- rep2_response_pct:

  Percent response, replicate 2

- rep3_response_pct:

  Percent response, replicate 3

- mean_response_pct:

  Mean percent response across replicates

- sd_response_pct:

  Standard deviation of percent response

## Source

Simulated in `data-raw/generate_dose_response.R`; no real biological
data are included.

## See also

[`doseResponseApp()`](https://j-andrews7.github.io/sciVizModules/reference/doseResponseApp.md)

## Author

Jacob Martin

## Examples

``` r
library(sciVizModules)
data(dose_response)
head(dose_response)
#>   dose_uM rep1_response_pct rep2_response_pct rep3_response_pct
#> 1     0.1                99               100                98
#> 2     0.3                98                97                99
#> 3     1.0                95                94                96
#> 4     3.0                89                91                88
#> 5    10.0                80                78                81
#> 6    30.0                65                68                63
#>   mean_response_pct sd_response_pct
#> 1             99.00            1.00
#> 2             98.00            1.00
#> 3             95.00            1.00
#> 4             89.33            1.53
#> 5             79.67            1.53
#> 6             65.33            2.52
```
