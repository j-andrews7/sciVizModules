# Running enrichment score of one gene set

Ranks the genes by decreasing statistic and walks down the list,
stepping up at each gene in the set by its weight (`|stat|^gsea.param`,
normalised over the set) and down at every other gene by `1 / (N - k)`.
The top and bottom of each step are those of
[`fgsea::calcGseaStat()`](https://rdrr.io/pkg/fgsea/man/calcGseaStat.html),
and the curve those of
[`fgsea::plotEnrichmentData()`](https://rdrr.io/pkg/fgsea/man/plotEnrichmentData.html),
so the enrichment score matches fgsea's.

## Usage

``` r
.gsea_running(stats, genes, gsea.param = 1)
```

## Arguments

- stats:

  Named numeric gene-level statistics.

- genes:

  The gene set.

- gsea.param:

  Weight exponent (1 is the standard weighted statistic).

## Value

A list with `curve` (rank, running ES), `hits` (rank, gene, stat), `es`,
and `leading.edge` (the genes up to the peak), or `NULL` when no gene of
the set is ranked.

## Author

Jared Andrews
