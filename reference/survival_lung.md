# Example survival dataset (NCCTG lung cancer)

A lightly cleaned version of the NCCTG lung cancer dataset from the
`survival` package, provided as a ready-to-use example for the
[`survivalCurve()`](https://j-andrews7.github.io/sciVizModules/reference/survivalCurve.md)
module. Each row is one patient with a follow-up time, an event
indicator, and a couple of grouping variables.

## Usage

``` r
data(survival_lung)
```

## Format

A data frame with 228 rows and 5 columns:

- time:

  Follow-up time in days

- status:

  Event indicator following the
  [`survival::Surv()`](https://rdrr.io/pkg/survival/man/Surv.html)
  convention (1 = censored, 2 = dead)

- age:

  Patient age in years

- sex:

  Patient sex ("Male" or "Female")

- ph.ecog:

  ECOG performance status, as a labelled factor

## Source

Derived from
[`survival::lung`](https://rdrr.io/pkg/survival/man/lung.html) (Loprinzi
et al., North Central Cancer Treatment Group).

## Author

Jacob Martin

## Examples

``` r
data(survival_lung)
head(survival_lung)
#>   time status age  sex      ph.ecog
#> 1  306      2  74 Male  Symptomatic
#> 2  455      2  68 Male Asymptomatic
#> 3 1010      1  56 Male Asymptomatic
#> 4  210      2  57 Male  Symptomatic
#> 5  883      2  60 Male Asymptomatic
#> 6 1022      1  74 Male  Symptomatic
```
