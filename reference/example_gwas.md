# Example GWAS summary statistics (simulated)

Simulated genome-wide association summary statistics for the
[`manhattanPlotServer()`](https://j-andrews7.github.io/sciVizModules/reference/manhattanPlotServer.md)
and
[`gwasQQPlotServer()`](https://j-andrews7.github.io/sciVizModules/reference/gwasQQPlotServer.md)
modules: about 15,000 variants across the 22 autosomes, spread in
proportion to chromosome length, with null p-values except for a
genome-wide significant locus on chromosome 3, a weaker one on
chromosome 11 and a suggestive one on chromosome 7. The columns follow
qqman's naming. No real genotypes or individuals are involved.

## Usage

``` r
data(example_gwas)
```

## Format

A data frame with 15,098 rows and 4 columns:

- SNP:

  Variant identifier

- CHR:

  Chromosome (1-22)

- BP:

  Base-pair position

- P:

  Association p-value

## Source

Simulated in `data-raw/generate_example_gwas.R`.

## Author

Jared Andrews

## Examples

``` r
data(example_gwas)
head(example_gwas)
#>        SNP CHR     BP      P
#> 1 rs100001   1  27432 0.1130
#> 2 rs100002   1  88856 0.0603
#> 3 rs100003   1 128682 0.3480
#> 4 rs100004   1 178196 0.9110
#> 5 rs100005   1 224926 0.5090
#> 6 rs100006   1 278944 0.4660
```
