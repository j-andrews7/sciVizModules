# sciVizModules

<!-- badges: start -->
[![R-CMD-check](https://github.com/j-andrews7/sciVizModules/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/j-andrews7/sciVizModules/actions/workflows/R-CMD-check.yaml)
<!-- badges: end -->

sciVizModules extends [VizModules](https://github.com/j-andrews7/VizModules) with a curated
collection of domain-specific Shiny modules tailored for the biological, chemical, and physical
sciences. Built on the flexible foundations of VizModules, these modules introduce plot types
and interactive controls commonly needed in scientific research. Each module preserves the
interactivity-first philosophy of its parent package while incorporating scientifically meaningful
defaults, axis conventions, and annotation layers relevant to each domain. sciVizModules enables
researchers to rapidly deploy publication-ready, interactive visualizations with minimal code,
bridging the gap between raw experimental data and interpretable scientific figures.

Developed by [Jared Andrews](https://github.com/j-andrews7) and [Jacob Martin](https://github.com/Jacob1106)

## Install

Note that this package is in development and may break at any time.

VizModules must be installed first:

```r
devtools::install_github("j-andrews7/VizModules")
devtools::install_github("j-andrews7/sciVizModules")
```

## Available Modules

Each module follows the VizModules trio contract: `*InputsUI(id, data, ...)` renders the
controls, `*OutputUI(id)` renders the interactive plotly output, and `*Server(id, data, ...)`
holds the logic. Every module also ships a standalone `*App()` you can run to see it in action.

- **`volcanoPlot`** — differential-expression volcano plot with interactive significance and
  fold-change thresholding (wraps `VizModules::dittoViz_scatterPlot`).
- **`enrichmentDotPlot`** — functional-enrichment dot plot for over-representation / GSEA
  results (e.g. `clusterProfiler` output). Enrichment terms sit on the y-axis, a grouping
  variable (e.g. `Cluster`) on the x-axis, dot size encodes the gene ratio, and dot color
  encodes significance (`-log10` p-value) (wraps `VizModules::plotthis_DotPlot`).
- **`goFanPlot`** — Gene Ontology (GO) enrichment **sunburst** ("fan") plot that converts
  the GO DAG into a clean circular layout, where each ring is a hierarchy level and each
  segment is a GO term. Accepts an enrichment table with a GO-ID column and a numeric column
  (e.g. `qvalue`) to colour by, and renders an interactive plotly sunburst (wraps
  `GOfan::sunburstGO`). Requires the [GOfan](https://github.com/jianhong/GOfan) package and the
  relevant organism annotation (`OrgDb`) package (e.g. `org.Hs.eg.db`).
- **`survivalCurve`** — Kaplan-Meier survival curve built on the
  [survminer](https://cran.r-project.org/package=survminer) package. Accepts a tidy survival
  data frame (a numeric follow-up `time` column, an event `status` column, and an optional
  grouping column) and renders an interactive plotly curve with optional confidence intervals,
  censoring marks, log-rank p-value, median-survival lines, and a number-at-risk table.

### RNA-seq / single-cell modules (dittoSeq)

These modules wrap [dittoSeq](https://bioconductor.org/packages/dittoSeq/) and accept a
`SingleCellExperiment`, `Seurat`, or `SummarizedExperiment` object (passed to `*Server()` as a
`reactive()`). Each renders the corresponding `dittoSeq` figure as an interactive plotly output
and reuses the standard VizModules aesthetic/axis/legend/reference-line controls. The bundled
`example_sce` dataset is used as the default in every `*App()`.

- **`dittoDimPlot`** — dimensionality-reduction (UMAP/tSNE/PCA) embedding colored by a gene or
  metadata variable (wraps `dittoSeq::dittoDimPlot`).
- **`dittoScatterPlot`** — scatter plot of any two genes/metadata with optional color variable
  (wraps `dittoSeq::dittoScatterPlot`).
- **`dittoPlot`** — per-group violin/box/jitter/ridge distribution of a gene or continuous
  variable (wraps `dittoSeq::dittoPlot`).
- **`dittoBarPlot`** — composition bar plot of a discrete variable per group, as counts or
  proportions (wraps `dittoSeq::dittoBarPlot`).
- **`dittoDimHex`** — hex-binned embedding summarising a color variable over cells
  (wraps `dittoSeq::dittoDimHex`).
- **`dittoFreqPlot`** — per-sample frequency of a discrete variable across groups
  (wraps `dittoSeq::dittoFreqPlot`).
- **`dittoRidgeJitter`** — ridgeline-with-jitter distribution plot
  (wraps `dittoSeq::dittoRidgeJitter`).

### Example

```r
library(sciVizModules)

# Launch the survival curve app with the bundled example data:
survivalCurveApp()

# Or build a figure directly:
data(survival_lung)
survivalCurve(survival_lung, time = "time", status = "status", group.by = "sex")

# Launch an RNA-seq module app with the bundled example SingleCellExperiment:
dittoDimPlotApp()
```

