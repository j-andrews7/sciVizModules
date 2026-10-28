# Read a MAGeCK gene summary

Reads the gene-level output of MAGeCK, the standard tool for pooled
CRISPR screens, into a tidy data frame. Both summaries are recognised:

- `mageck test` (robust rank aggregation) `<prefix>.gene_summary.txt`,
  with `id`, `num` and, for each of negative (depletion) and positive
  (enrichment) selection, `score`, `p-value`, `fdr`, `rank`, `goodsgrna`
  and `lfc`.

- `mageck mle` `<prefix>.gene_summary.txt`, with `Gene`, `sgRNA` and,
  for each condition, `beta`, `z`, `p-value`, `fdr`, `wald-p-value` and
  `wald-fdr`.

The file may be gzip-compressed. A table read with
[`read.delim()`](https://rdrr.io/r/utils/read.table.html)'s default
`check.names = TRUE` (`neg.p.value` rather than `neg|p-value`), as a
Shiny file upload reads it, is recognised too.

## Usage

``` r
read_mageck(file)
```

## Arguments

- file:

  Path to a MAGeCK `gene_summary.txt`.

## Value

A data frame. For RRA: `gene`, `n.sgrna`, then `neg.score`, `neg.p`,
`neg.fdr`, `neg.rank`, `neg.goodsgrna`, `neg.lfc` and the matching
`pos.*` columns. For MLE: `gene`, `n.sgrna`, then `<condition>.beta`,
`.z`, `.p`, `.fdr`, `.wald.p`, `.wald.fdr` per condition. The attribute
`"mageck_type"` is `"rra"` or `"mle"`.

## See also

[`crisprScreenRankServer()`](https://j-andrews7.github.io/sciVizModules/reference/crisprScreenRankServer.md)

## Author

Jared Andrews

## Examples

``` r
screen <- read_mageck(system.file("extdata", "example_mageck.gene_summary.txt.gz",
    package = "sciVizModules"))
head(screen)
#>    gene n.sgrna neg.score     neg.p   neg.fdr neg.rank neg.goodsgrna  neg.lfc
#> 1 U2AF2       4 6.026e-08 1.423e-07 4.318e-05        1             3 -1.12776
#> 2  PLK1       4 6.613e-08 1.564e-07 4.318e-05        2             4 -2.97251
#> 3 ERCC3       4 6.815e-08 1.114e-07 4.318e-05        3             3 -3.18427
#> 4 RAD21       4 7.291e-08 1.592e-07 4.318e-05        4             3 -1.87583
#> 5 HCFC1       4 8.055e-08 1.259e-07 4.318e-05        5             4 -2.30199
#> 6 SRSF2       4 8.852e-08 1.892e-07 4.318e-05        6             3 -0.72129
#>   pos.score  pos.p pos.fdr pos.rank pos.goodsgrna  pos.lfc
#> 1    0.4400 0.9047  0.9964     1406             2 -1.12776
#> 2    0.4758 0.9141  0.9964     1484             2 -2.97251
#> 3    0.5808 0.9586  0.9964     1674             2 -3.18427
#> 4    0.3119 0.9184  0.9964     1059             2 -1.87583
#> 5    0.7400 0.9045  0.9964     1892             1 -2.30199
#> 6    0.8416 0.9260  0.9964     1947             2 -0.72129

mle <- read_mageck(system.file("extdata", "example_mageck_mle.gene_summary.txt.gz",
    package = "sciVizModules"))
head(mle)
#>    gene n.sgrna dmso.beta   dmso.z dmso.p  dmso.fdr dmso.wald.p dmso.wald.fdr
#> 1  RPL3       4  -1.01714 -11.0802  2e-05 0.0004348   1.566e-28     1.842e-26
#> 2  RPL4       4  -0.99510  -8.6662  2e-05 0.0004348   4.468e-18     2.482e-16
#> 3  RPL7       4  -0.77943  -4.5163  2e-05 0.0004348   6.292e-06     1.383e-04
#> 4 RPL11       4  -1.02996  -5.9491  2e-05 0.0004348   2.696e-09     7.930e-08
#> 5  RPS3       4  -1.31606 -13.3639  2e-05 0.0004348   9.828e-41     2.808e-38
#> 6  RPS6       4  -0.86912  -5.3997  2e-05 0.0004348   6.677e-08     1.781e-06
#>   drug.beta   drug.z drug.p  drug.fdr drug.wald.p drug.wald.fdr
#> 1  -0.83302  -5.8637  2e-05 0.0003571   4.527e-09     9.632e-08
#> 2  -1.20288  -7.5863  2e-05 0.0003571   3.291e-14     9.539e-13
#> 3  -1.22790 -14.0076  2e-05 0.0003571   1.401e-44     3.009e-42
#> 4  -1.13309 -11.0022  2e-05 0.0003571   3.728e-28     3.550e-26
#> 5  -0.57265  -5.9164  2e-05 0.0003571   3.291e-09     7.200e-08
#> 6  -1.56217 -13.5256  2e-05 0.0003571   1.104e-41     2.007e-39
```
