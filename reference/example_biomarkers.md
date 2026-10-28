# Example diagnostic biomarker data (simulated)

A simulated diagnostic study for the
[`rocCurveServer()`](https://j-andrews7.github.io/sciVizModules/reference/rocCurveServer.md)
module: 300 patients with a binary disease outcome and three serum
markers that separate the groups strongly, moderately and weakly. No
real patients are involved.

## Usage

``` r
data(example_biomarkers)
```

## Format

A data frame with 300 rows and 7 columns:

- id:

  Patient identifier

- disease:

  Outcome, a factor: "Healthy" or "Disease"

- marker_strong:

  Marker with strong discrimination (AUC about 0.93)

- marker_moderate:

  Marker with moderate discrimination (AUC about 0.75)

- marker_weak:

  Marker with weak discrimination (AUC about 0.62)

- age:

  Age in years

- sex:

  Sex, a factor

## Source

Simulated in `data-raw/generate_example_biomarkers.R`.

## Author

Jared Andrews

## Examples

``` r
data(example_biomarkers)
head(example_biomarkers)
#>     id disease marker_strong marker_moderate marker_weak age  sex
#> 1 P001 Disease         18.76            41.6        0.94  62 Male
#> 2 P002 Healthy          3.64            43.8        0.82  33 Male
#> 3 P003 Healthy          9.16            54.3        1.23  66 Male
#> 4 P004 Disease         13.52            62.6        1.44  63 Male
#> 5 P005 Healthy          3.48            64.6        0.43  63 Male
#> 6 P006 Disease         18.74            51.8        1.46  53 Male
```
