# Example single-base-substitution spectra (simulated)

Simulated 96-channel mutational spectra for six tumours, for the
[`mutationalProfileServer()`](https://j-andrews7.github.io/sciVizModules/reference/mutationalProfileServer.md)
module. Each tumour mixes three synthetic processes (an ageing-like C\>T
at CpG, an APOBEC-like C\>T and C\>G in TpCpW, and a smoking-like broad
C\>A) in different proportions, plus a flat background. The profiles are
shaped after familiar ones but are not copied from any published
signature catalogue.

## Usage

``` r
data(example_sbs96)
```

## Format

A data frame with 96 rows and 7 columns:

- context:

  Trinucleotide channel, e.g. `"A[C>A]A"`, in the order
  MutationalPatterns and maftools use

- Tumour_1, Tumour_2, Tumour_3, Tumour_4, Tumour_5, Tumour_6:

  Substitution counts per channel, one column per tumour

## Source

Simulated in `data-raw/generate_example_sbs96.R`.

## Author

Jared Andrews

## Examples

``` r
data(example_sbs96)
head(example_sbs96)
#>   context Tumour_1 Tumour_2 Tumour_3 Tumour_4 Tumour_5 Tumour_6
#> 1 A[C>A]A        6        2        6       67      104       14
#> 2 A[C>A]C        4        1       10       84       96        8
#> 3 A[C>A]G        5        2        3       82       87       17
#> 4 A[C>A]T        3        3        6       69       93       19
#> 5 C[C>A]A        2        6        5       71       96       24
#> 6 C[C>A]C        2        0        2       69      113       28
colSums(example_sbs96[-1])
#> Tumour_1 Tumour_2 Tumour_3 Tumour_4 Tumour_5 Tumour_6 
#>      450      820     1600     2400     3100     1200 
```
