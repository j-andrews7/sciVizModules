# sciVizModules

<!-- badges: start -->
[![R-CMD-check](https://github.com/j-andrews7/sciVizModules/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/j-andrews7/sciVizModules/actions/workflows/R-CMD-check.yaml)
[![pkgdown](https://github.com/j-andrews7/sciVizModules/actions/workflows/pkgdown.yaml/badge.svg)](https://github.com/j-andrews7/sciVizModules/actions/workflows/pkgdown.yaml)
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

VizModules 0.6.0 or newer must be installed first:

```r
install.packages("VizModules")
# ... or, for the development version:
# remotes::install_github("j-andrews7/VizModules")

remotes::install_github("j-andrews7/sciVizModules")
```

## Module Gallery

To preview every module in one place, launch the bundled gallery app. It presents each
module on its own tab, wired to the relevant bundled example dataset, so you can explore
the plot types and their interactive controls without writing any code:

```r
library(shiny)
runApp(system.file("apps/module-gallery", package = "sciVizModules"))
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
- **`survivalCurve`** — Kaplan-Meier survival curve fitted with the
  [survival](https://cran.r-project.org/package=survival) package. Accepts a tidy survival
  data frame (a numeric follow-up `time` column, an event `status` column, and an optional
  grouping column) and renders an interactive plotly curve with optional confidence bands,
  censoring marks, log-rank p-value, median-survival lines, and a number-at-risk table.
- **`maPlot`** — differential-expression MA plot: mean abundance on the x-axis (log10 for
  DESeq2's `baseMean`, identity for the already-logged edgeR/limma columns) against log fold
  change, with the same interactive significance and fold-change thresholding as the volcano
  plot (wraps `VizModules::dittoViz_scatterPlot`).
- **`michaelisMenten`** — Michaelis-Menten plot for enzyme-substrate kinetics, built on the
  outputs of the [drc](https://cran.r-project.org/package=drc) package. The module takes a
  `data` (observed points), `model` (fitted line) and optional `stats` (an `nls` fit, or named
  `K` / `Vmax` coefficients) bundle produced by the **drc** Michaelis-Menten workflow.
- **`doseResponse`** — dose-response curve with the dose on a log10 axis and a log-logistic
  curve fitted with **drc**. The `drm` model backend is registered with VizModules at load, so
  the curve is one of the fit options on the wrapped scatter plot
  (wraps `VizModules::dittoViz_scatterPlot`).
- **`cnSegmentPlot`** — genome-wide array copy-number segment plot over a `CNSegment` object as
  returned by [`sesame::cnSegmentation()`](https://bioconductor.org/packages/sesame/). Bin-level
  log2 signal ratios are drawn across the genome with chromosome guides, centromere marks and
  optional gene labels; several samples stack vertically over a shared genomic x-axis.
- **`forestPlot`** — forest plot of hazard ratios (Cox), odds ratios (logistic) or
  coefficients (linear regression), fitted from the raw data inside the module. Choose the
  outcome and covariates interactively, and switch between one adjusted (multivariable) model
  and one model per covariate; factors show a row per level against their reference level.
- **`rocCurve`** — ROC curves for one or more numeric predictors of a binary outcome, with the
  AUC (and its DeLong 95% CI when [pROC](https://cran.r-project.org/package=pROC) is installed)
  in the legend and the Youden-optimal cut-off marked. Curves and AUCs are computed in the
  package and match pROC's.
- **`pkConcentrationTime`** — pharmacokinetic concentration-time profiles per subject or as the
  mean ± SD per group, on a linear or log axis, with the terminal elimination fits. Each
  subject's non-compartmental parameters (Cmax, Tmax, AUC, half-life, CL/F, Vz/F) are computed
  as [PKNCA](https://cran.r-project.org/package=PKNCA) computes them and go in the source-data
  download.
- **`plateHeatmap`** — 6- to 1536-well assay plates in their physical layout, raw or normalised
  per plate (percent of control, percent inhibition, z, robust z, B-score), with the control
  wells outlined, each plate's Z'-factor in its title, and optional row and column means for
  spotting edge effects.
- **`manhattanPlot`** / **`gwasQQPlot`** — GWAS summary statistics as a Manhattan plot
  (chromosomes end to end, genome-wide and suggestive lines) and a QQ plot (confidence band,
  lambda GC). Columns are detected from the usual names (qqman, PLINK, REGENIE, GWAS Catalog),
  and large files are thinned to keep the plot responsive (both wrap
  `VizModules::dittoViz_scatterPlot`).
- **`gseaEnrichmentPlot`** — the GSEA running enrichment score for one or more gene sets, with
  hit ticks and the ranked statistic, from fgsea output or a clusterProfiler `gseaResult`.
- **`crisprScreenRank`** — gene rank plot of a pooled CRISPR screen from a MAGeCK RRA or MLE
  gene summary (`read_mageck()`), with depletion and enrichment on one signed axis and FDR hits
  coloured (wraps `VizModules::dittoViz_scatterPlot`).
- **`alphafoldConfidence`** — AlphaFold prediction confidence: the per-residue pLDDT over the
  AlphaFold DB confidence bands, above the predicted aligned error (PAE) heatmap on the same
  residue axis, with chain boundaries for multimers. `read_alphafold()` reads AlphaFold DB
  PAE/confidence JSON, ColabFold score files, or the pLDDT stored in a model's PDB/mmCIF
  B-factors.
- **`structureViewer`** — an interactive 3D viewer for protein and molecule structures
  (PDB / mmCIF, read with `read_structure()`), coloured by AlphaFold pLDDT band, B-factor,
  chain, residue index, secondary structure or hydrophobicity, with residues highlighted by
  number. It is the one module that is not a plotly figure: it is an
  [NGL](https://nglviewer.org/) widget (via
  [NGLVieweR](https://cran.r-project.org/package=NGLVieweR)) with its own PNG snapshot, and it
  restyles in place without resetting the camera.
- **`mdTrajectoryMetrics`** — molecular dynamics trajectory metrics (RMSD, radius of gyration,
  RMSF, ...) from GROMACS `.xvg` files read with `read_xvg()`, one line per replica, with
  running-mean smoothing, ps/ns and nm/Å conversion, and a panel per metric.

### Somatic mutations

The cohort figures of [maftools](https://bioconductor.org/packages/maftools/), drawn natively in
plotly from a maftools `MAF` object or a plain data frame in Mutation Annotation Format columns
(so maftools is optional; its summaries are matched in the tests). The `*App()` functions open on
the TCGA LAML cohort maftools ships (so need maftools).

- **`oncoPlot`** — the oncoplot: genes by samples coloured by variant class (Multi_Hit where a
  gene carries several), each sample's mutation burden above, each gene's frequency beside, and
  sample annotations as tracks, with a hover per tile.
- **`mafSummary`** — the `plotmafSummary()` dashboard: counts per variant classification, type
  and substitution class, variants per sample, and the most mutated genes.
- **`mutationLollipop`** — one gene's mutations along its protein, over its Pfam/SMART domains
  (from maftools' table when installed).
- **`mutationalProfile`** — the 96-channel single-base-substitution spectrum of each sample,
  from a MutationalPatterns, maftools or SigProfiler count matrix (wraps
  `VizModules::plotthis_BarPlot`).

### Bulk expression

Sample-level views of a bulk experiment in a `SummarizedExperiment`, with the counts transformed
in the module (DESeq2's variance-stabilising transformation, log2 CPM or log2). The `*App()`
functions open on the [airway](https://bioconductor.org/packages/airway/) package's counts, so
need airway.

- **`samplePCA`** — the sample PCA over the most variable genes, drawn by `pcaBiplot`;
  `sample_pca()` builds the same PCA for the other PCAtools modules.
- **`sampleDistanceHeatmap`** — Euclidean distances (or correlations) between samples,
  clustered, with `colData` annotations.
- **`deHeatmap`** — per-gene z-scores of the top differentially expressed genes from a results
  table, split into up and down.

The two heatmaps, like `dittoHeatmap` below, wrap VizModules' `ComplexHeatmap_Heatmap` module:
they are [InteractiveComplexHeatmap](https://bioconductor.org/packages/InteractiveComplexHeatmap/)
widgets (hover, click, brush a sub-heatmap) rather than plotly figures, and need ComplexHeatmap,
InteractiveComplexHeatmap and circlize.

### Principal component analysis (PCAtools)

One module per [PCAtools](https://bioconductor.org/packages/PCAtools/) view, each taking a
PCAtools `pca` object (from `PCAtools::pca()`), so any data matrix with sample metadata works.
The bundled `example_pca` (airway RNA-seq) is the default in every `*App()`.

- **`pcaBiplot`** — sample scores with % variance in the axis titles and optional loading
  arrows (wraps `VizModules::dittoViz_scatterPlot`, so colour, shape, ellipses and point
  annotations all apply).
- **`pcaScreePlot`** — variance explained per component, the cumulative line, and markers for
  the elbow and any components you name.
- **`pcaLoadingsPlot`** — the variables loading most strongly on each component (PCAtools'
  `rangeRetain` rule).
- **`pcaPairsPlot`** — a lower-triangle grid of score scatters for every pair of components.
- **`pcaEigencorPlot`** — correlation of each component with each sample metadata variable,
  with significance.

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
- **`dittoDotPlot`** — marker dot plot: mean expression (colour) and fraction expressing (size)
  per gene and group (wraps `dittoSeq::dittoDotPlot`).
- **`dittoHeatmap`** — expression of chosen genes across cells, ordered and annotated by cell
  metadata (wraps `dittoSeq::dittoHeatmap`'s data through VizModules'
  `ComplexHeatmap_Heatmap`; an InteractiveComplexHeatmap widget, not plotly).

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

Note that this package sets no `LazyData`, so the bundled datasets need a
`data()` call before you can use them by name.

## Multi-panel Figures

The data-frame modules are registered with the [VizModules Figure
Builder](https://j-andrews7.github.io/VizModules/), so several panels can be dragged, sized
and exported as one figure, with a source-data archive per panel:

```r
library(sciVizModules)
sciFigureBuilderApp()
```

`sci_figure_builder_registry()` returns the registry itself, so you can combine it with your
own modules (or with the VizModules ones) and pass the result to
`VizModules::figureBuilderApp()`.

The single-cell modules, the bulk expression modules, `cnSegmentPlot`, `michaelisMenten`, the
PCAtools modules and `alphafoldConfidence` are not registered: the builder's dataset catalogue
holds data frames, and those take a `SingleCellExperiment`, a `SummarizedExperiment`, a
`CNSegment` object, a bundle carrying a model fit, a PCAtools `pca` object and a
`read_alphafold()` result respectively. `structureViewer` is a 3D widget rather than a plotly
figure. `mutationalProfile` is registered; `forestPlot` and the other newer data-frame modules
(GWAS, GSEA, CRISPR, the MAF modules, ROC, PK, plate and MD) are not registered yet. Run their
`*App()` functions instead.

## Working with an AI Coding Agent

This package builds on VizModules, which ships three agent skills describing its APIs. Install
them into your project once and any compatible agent (Claude Code, GitHub Copilot, OpenAI
Codex) will pick them up:

```r
VizModules::use_vizmodules_skills(".", client = "claude")  # or "agents" / "copilot"
```

- `vizmodules-app` — wiring modules into an app, with a generated inventory of every module's
  column-mapping keys, colour key and tab names.
- `vizmodules-custom-module` — building wrapper modules on top of a base module, which is what
  most of sciVizModules does.
- `vizmodules-new-module` — authoring a module inside VizModules itself.

`AGENTS.md` in this repository covers the sciVizModules-specific conventions on top of those.

