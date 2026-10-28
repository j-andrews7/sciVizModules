# Example functional enrichment results (simulated)

A small, simulated `clusterProfiler`-style GO over-representation table
provided as ready-to-use example data for the
[`enrichmentDotPlotServer()`](https://j-andrews7.github.io/sciVizModules/reference/enrichmentDotPlotServer.md)
module. Enrichment terms are tested across two gene clusters, mimicking
the output of `clusterProfiler::compareCluster()`.

## Usage

``` r
data(example_enrichment)
```

## Format

A data frame with 14 rows and 10 columns:

- Cluster:

  Gene cluster the term was enriched in ("Upregulated" or
  "Downregulated"); used for the dot plot x-axis

- ONTOLOGY:

  GO ontology ("BP")

- ID:

  GO term identifier

- Description:

  Human-readable enrichment term; used for the dot plot y-axis

- GeneRatio:

  Fraction of query genes in the term, as a "count/total" string; parsed
  to a numeric ratio for dot size

- BgRatio:

  Fraction of background genes in the term, as a "count/total" string

- pvalue:

  Over-representation p-value

- p.adjust:

  Benjamini-Hochberg adjusted p-value

- qvalue:

  q-value

- Count:

  Number of query genes in the term

## Source

Simulated in `data-raw/generate_example_enrichment.R`; no real
biological data are included.

## Author

Jacob Martin

## Examples

``` r
library(sciVizModules)
data(example_enrichment)
head(example_enrichment)
#>       Cluster ONTOLOGY         ID                         Description GeneRatio
#> 1 Upregulated       BP GO:0006955                     immune response    22/210
#> 2 Upregulated       BP GO:0002250            adaptive immune response    20/210
#> 3 Upregulated       BP GO:0006954               inflammatory response    29/210
#> 4 Upregulated       BP GO:0002376               immune system process    12/210
#> 5 Upregulated       BP GO:0050900                 leukocyte migration     9/210
#> 6 Upregulated       BP GO:0019221 cytokine-mediated signaling pathway    30/210
#>     BgRatio       pvalue     p.adjust       qvalue Count
#> 1  99/18000 4.505989e-09 3.604791e-08 3.244312e-08    22
#> 2 376/18000 1.477704e-08 5.910816e-08 5.319734e-08    20
#> 3 168/18000 5.218546e-07 1.391612e-06 1.252451e-06    29
#> 4 362/18000 8.904282e-06 1.780856e-05 1.602771e-05    12
#> 5 188/18000 2.203359e-05 3.525375e-05 3.172837e-05     9
#> 6  84/18000 3.518740e-04 4.691653e-04 4.222488e-04    30
```
