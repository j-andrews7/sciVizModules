# Example single-cell RNA-seq dataset (simulated)

A small, simulated
[SingleCellExperiment::SingleCellExperiment](https://rdrr.io/pkg/SingleCellExperiment/man/SingleCellExperiment.html)
provided as a ready-to-use example for the dittoSeq-based modules
([`dittoDimPlotServer()`](https://j-andrews7.github.io/sciVizModules/reference/dittoDimPlotServer.md),
[`dittoScatterPlotServer()`](https://j-andrews7.github.io/sciVizModules/reference/dittoScatterPlotServer.md),
[`dittoPlotServer()`](https://j-andrews7.github.io/sciVizModules/reference/dittoPlotServer.md),
[`dittoBarPlotServer()`](https://j-andrews7.github.io/sciVizModules/reference/dittoBarPlotServer.md),
[`dittoDimHexServer()`](https://j-andrews7.github.io/sciVizModules/reference/dittoDimHexServer.md),
[`dittoFreqPlotServer()`](https://j-andrews7.github.io/sciVizModules/reference/dittoFreqPlotServer.md),
and
[`dittoRidgeJitterServer()`](https://j-andrews7.github.io/sciVizModules/reference/dittoRidgeJitterServer.md)).

## Usage

``` r
data(example_sce)
```

## Format

A
[SingleCellExperiment::SingleCellExperiment](https://rdrr.io/pkg/SingleCellExperiment/man/SingleCellExperiment.html)
with 40 genes and 240 cells containing:

- assays:

  `counts` and `logcounts`

- reducedDims:

  `PCA`, `TSNE`, and `UMAP` embeddings

- colData:

  `clustering`, `celltype`, `condition`, and `sample` (discrete), plus
  `nCount` and `percent.mito` (continuous)

## Source

Simulated in `data-raw/generate_example_sce.R`; no real biological data
are included.

## Author

Jacob Martin

## Examples

``` r
library(sciVizModules)
data(example_sce)
example_sce
#> class: SingleCellExperiment 
#> dim: 40 240 
#> metadata(0):
#> assays(2): counts logcounts
#> rownames(40): Gene1 Gene2 ... Gene39 Gene40
#> rowData names(0):
#> colnames(240): Cell1 Cell2 ... Cell239 Cell240
#> colData names(6): clustering celltype ... nCount percent.mito
#> reducedDimNames(3): PCA TSNE UMAP
#> mainExpName: NULL
#> altExpNames(0):
```
