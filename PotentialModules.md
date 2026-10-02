# Potential modules for sciVizModules

A researched registry of candidate modules, compiled 2026-10-01. Omics first, then
microbiology, structural biology, clinical, bench and physical-science plots. Everything here
is a candidate, not a commitment.

**Implemented** (2026-10-01): `pcaPlot` (#17, as five modules: `pcaBiplot`, `pcaScreePlot`,
`pcaLoadingsPlot`, `pcaPairsPlot`, `pcaEigencorPlot`), `alphafoldConfidence` (#70, with
`read_alphafold()`) and `forestPlot` (#78, fitting Cox / logistic / linear models from raw data).
Also implemented: `manhattanPlot` and `gwasQQPlot` (#11, #12; wrappers on the VizModules scatter module using its `fig.fn` hook for chromosome ticks, significance lines, the QQ band and lambda GC; simulated `example_gwas`).
Also implemented: `gseaEnrichmentPlot` (#22; native, from an fgsea bundle or a clusterProfiler `gseaResult`; running score computed in-package and tested equal to fgsea's; `example_gsea` from fgsea's MIT-licensed example data).
Also implemented: `crisprScreenRank` (#29, with `read_mageck()`, which also reads `mageck mle` summaries ready for `crisprBetaScatter`; simulated MAGeCK example, since no MAGeCK output carries a licence to redistribute).
Also implemented: `structureViewer` (#71, with `read_structure()`; the package's one non-plotly widget, built on NGLVieweR, restyling in place through its proxy, colouring by AlphaFold pLDDT bands, B-factor, chain, rainbow, secondary structure or hydrophobicity; `ramachandranPlot` and `contactMap` could reuse `read_structure()`).
Also implemented: `mdTrajectoryMetrics` (#74, with `read_xvg()` for GROMACS output; replicas and metrics combine with `rbind()`; running-mean smoothing and ps/ns, nm/Angstrom conversion; simulated example files).
Also implemented: `rocCurve` (#79; native; curves, AUCs and Youden cut-offs computed in-package and tested equal to pROC's, DeLong CI via pROC when installed; simulated `example_biomarkers`).
Also implemented: `pkConcentrationTime` (#83; native; per-subject or mean +/- SD profiles, linear or log, with terminal fits; NCA parameters computed in-package and tested equal to PKNCA's on `Theoph`).
Also implemented: `plateHeatmap` (#89; native; plates in physical layout from any 6- to 1536-well format, raw, percent-of-control, percent-inhibition, z, robust-z or B-score per plate, outlined controls, Z' per plate, row/column means for edge effects; simulated `example_plate`).
Their rows are marked **Done**.

**How candidates were chosen.** Popular packages with a standard input structure (a MAF
object, a `SummarizedExperiment`, a `phyloseq`, GWAS summary statistics, a tidy model
table) rank above bespoke formats. Popularity comes from the Bioconductor download score
(distinct IPs over the last 12 months, ranked across ~3,100 packages) and CRAN downloads
for September 2026 (cranlogs). Command-line and Python tools (MAGeCK, Kraken2, AlphaFold,
GROMACS, ...) are in scope where their outputs are common, stable files; their popularity is
GitHub stars, and each comes with a small reader (see
[Readers for non-R tool outputs](#readers-for-non-r-tool-outputs)). Each plotting function's graphics system (ggplot vs
base/grid) was checked in the package source, because that decides the build path.

Not listed: anything already shipped (`cnSegmentPlot`, the seven dittoSeq modules,
`doseResponse`, `enrichmentDotPlot`, `goFanPlot`, `maPlot`, `michaelisMenten`,
`survivalCurve`, `volcanoPlot`). Ideas that only extend one of those are under
[Extensions to existing modules](#extensions-to-existing-modules).

## Legend

**Build path**

- **VM base** - wrap a VizModules base module with science-specific data preparation and
  `defaults`, the way `volcanoPlot` wraps `dittoViz_scatterPlot`. The base is named. Cheapest
  path, and inherits stats, annotations, downloads and manual-edit persistence.
- **ggplotly** - the source function returns a ggplot that survives `plotly::ggplotly()`; wrap
  it the way the dittoSeq modules do.
- **Native** - draw with plotly directly in a standalone plotting function, the way
  `cnSegmentPlot()` is built. Needed when the source plot is base or grid graphics (no
  `ggplotly()` route), stitches panels together (`aplot`/`patchwork`), or uses geoms plotly
  cannot translate.
- **Widget** - a non-plotly htmlwidget with Shiny bindings (3D structure). Allowed where plotly
  has no equivalent, but it forgoes the shared plotly finishing helpers and the Figure Builder.

**Tier**

- **1** - popular, standard structure, cheap build. Do these first.
- **2** - clearly useful, but heavier dependencies, a native build, or a narrower audience.
- **3** - niche or costly; build on demand.

**New Suggests** - "none (reader)" means the module needs only a small file reader shipped in
this package.

**FB** - Figure Builder: **Y** when the module's input is a data frame, so it can be registered
in `sci_figure_builder_registry()`; **N** for S4 inputs (MAF, SE, phyloseq, ...).

**Upstream?** - the plot is generic enough that it may belong in VizModules rather than here.

## Summary

| # | Module | Plot | Source package(s) | Input | Build path | Popularity | New Suggests | FB | Tier |
|---|---|---|---|---|---|---|---|---|---|
| 1 | `oncoPlot` | Oncoprint: gene x sample mutation tiles, TMB and frequency bars, clinical tracks | maftools | MAF | Native | Bioc #154 | maftools | N | 1 |
| 2 | `mutationLollipop` | Protein lollipop with domains | maftools | MAF | Native | Bioc #154 | maftools | N | 1 |
| 3 | `mafSummary` | Variant classification / type / SNV class / per-sample counts | maftools | MAF | VM base: `plotthis_BarPlot` | Bioc #154 | maftools | N | 1 |
| 4 | `mutationalProfile` | SBS96 trinucleotide spectrum | MutationalPatterns, maftools, sigminer | 96 x sample matrix | VM base: `plotthis_BarPlot` | Bioc #371 | none | Y | 1 |
| 5 | `signatureContribution` | Signature exposure per sample | MutationalPatterns, sigminer | signature x sample matrix | VM base: `plotthis_BarPlot` | Bioc #371 | none | Y | 2 |
| 6 | `tiTvPlot` | Transition/transversion fractions | maftools | MAF | VM base: `plotthis_BarPlot`, `dittoViz_yPlot` | Bioc #154 | maftools | N | 2 |
| 7 | `vafPlot` | VAF distribution of top genes | maftools | MAF | VM base: `dittoViz_yPlot` | Bioc #154 | maftools | N | 2 |
| 8 | `rainfallPlot` | Inter-mutation distance along the genome (kataegis) | maftools | MAF | VM base: `dittoViz_scatterPlot` | Bioc #154 | maftools | N | 2 |
| 9 | `somaticInteractions` | Pairwise co-occurrence / exclusivity triangle | maftools | MAF | Native | Bioc #154 | maftools | N | 2 |
| 10 | `tmbComparison` | Cohort TMB against TCGA cohorts | maftools | MAF | Native | Bioc #154 | maftools | N | 2 |
| 11 | `manhattanPlot` | GWAS Manhattan | qqman, CMplot, MungeSumstats | summary stats df | VM base: `dittoViz_scatterPlot` | qqman 4.7k/mo | none | Y | Done |
| 12 | `gwasQQPlot` | P-value QQ with lambda GC | qqman | summary stats df | VM base: `dittoViz_scatterPlot` | qqman 4.7k/mo | none | Y | Done |
| 13 | `regionalAssociationPlot` | LocusZoom-style regional plot | locuszoomr | summary stats df + EnsDb | Native (`locus_plotly()`) | 2.2k/mo | locuszoomr, ensembldb | Y | 2 |
| 14 | `variantQC` | QUAL / DP / allele-frequency distributions | VariantAnnotation | VCF | VM base: `plotthis_Histogram` | Bioc #79 | VariantAnnotation | N | 3 |
| 15 | `admixturePlot` | Ancestry proportions per individual (structure plot) | ADMIXTURE, LEA (sNMF), pophelper (reference) | `.Q` matrix + sample/population labels | VM base: `plotthis_BarPlot` | LEA Bioc #303 | none (reader) | Y | 2 |
| 16 | `samplePCA` | Sample PCA / MDS from counts; front-end to `pcaPlot` | DESeq2, PCAtools, limma | SE / DESeqDataSet / DGEList | VM base via `pcaPlot` | DESeq2 Bioc #21 | none | N | 1 |
| 17 | `pcaPlot` | Scores biplot (+ loading vectors), scree with elbow/Horn markers, loadings, pairs, PC-metadata correlations | PCAtools | PCAtools `pca` object | VM base: `dittoViz_scatterPlot`, `plotthis_BarPlot`, `ComplexHeatmap_Heatmap`; native pairs grid | Bioc #247 | PCAtools | N | Done |
| 18 | `sampleDistanceHeatmap` | Sample distance or correlation heatmap | DESeq2, stats | SE | VM base: `ComplexHeatmap_Heatmap` | Bioc #41 | none | N | 1 |
| 19 | `deHeatmap` | Top DE genes, z-scored, annotated | DESeq2, edgeR, limma | SE + DE results | VM base: `ComplexHeatmap_Heatmap` | Bioc #17-24 | none | N | 1 |
| 20 | `pValueHistogram` | DE p-value histogram (diagnostic) | any DE tool | DE results df | VM base: `plotthis_Histogram` | n/a | none | Y | 2 |
| 21 | `countDistributions` | Library sizes, log-CPM boxes/densities, before/after normalisation | edgeR, DESeq2 | SE / DGEList | VM base: `plotthis_BoxPlot`, `plotthis_DensityPlot` | Bioc #24 | none | N | 2 |
| 22 | `meanVariance` | Mean-SD / dispersion / voom trend | vsn, DESeq2, limma | SE / DESeqDataSet | VM base: `dittoViz_scatterPlot` | vsn Bioc #91 | none | N | 3 |
| 23 | `wgcnaModuleTrait` | Module-trait correlations, eigengenes, module dendrogram | WGCNA | `blockwiseModules()` result + trait df | VM base: `ComplexHeatmap_Heatmap`; native dendrogram | 32.8k/mo | WGCNA | N | 2 |
| 24 | `expressionTrajectories` | Time-course expression clusters | Mfuzz, DEGreport, TCseq | SE + cluster assignments | VM base: `linePlot` | Mfuzz Bioc #215 | none | N | 2 |
| 25 | `rmatsSplicing` | Splicing dPSI volcano, event-type counts, PSI by group | rMATS (non-R), maser (reference) | rMATS `*.MATS.JC.txt` | VM base: `volcanoPlot`, `plotthis_BarPlot`, `dittoViz_yPlot` | rmats-turbo GitHub 312 stars; maser Bioc #727 | none (reader) | Y | 2 |
| 26 | `gseaEnrichmentPlot` | GSEA running enrichment score, hits, ranked metric | fgsea, clusterProfiler | fgsea result + ranks, `gseaResult` | Native | fgsea Bioc #27 | fgsea | N | Done |
| 27 | `geneConceptNetwork` | Gene-concept network (cnetplot) | enrichplot / ggtangle | `enrichResult` | Native | enrichplot Bioc #26 | enrichplot | N | 2 |
| 28 | `enrichmentMap` | Term similarity network (emapplot) | enrichplot | `enrichResult` | Native | Bioc #26 | enrichplot | N | 2 |
| 29 | `gseaRidge` | Fold-change distributions of core genes per term | enrichplot, fgsea | `gseaResult` | VM base: `dittoViz_yPlot` (ridge) | Bioc #26 | none | N | 2 |
| 30 | `gsvaHeatmap` | Per-sample pathway scores | GSVA | SE / matrix | VM base: `ComplexHeatmap_Heatmap` | Bioc #69 | GSVA | N | 2 |
| 31 | `setOverlapUpset` | UpSet of gene-set or DE-list overlaps | UpSetR, ComplexUpset | named list / df | Native | UpSetR 27k/mo | none | Y | 3 (upstream?) |
| 32 | `crisprScreenRank` | Gene rank vs LFC/score with labelled hits | MAGeCK (non-R), MAGeCKFlute | MAGeCK `gene_summary.txt` | VM base: `dittoViz_scatterPlot` | MAGeCK: de facto screen tool | none (reader) | Y | Done |
| 33 | `crisprBetaScatter` | MLE beta scores, treatment vs control, nine-square view | MAGeCK MLE, MAGeCKFlute | MAGeCK MLE `gene_summary.txt` | VM base: `dittoViz_scatterPlot` | as above | none (reader) | Y | 2 |
| 34 | `screenQC` | sgRNA count distributions, Gini index, zero-count guides, mapping rate | MAGeCK count | `countsummary.txt`, `count.txt` | VM base: `plotthis_BarPlot`, `plotthis_DensityPlot` | as above | none (reader) | Y | 2 |
| 35 | `dittoDotPlot` | Marker dot plot (expression x percent) | dittoSeq | SCE / SE / Seurat | ggplotly | Bioc #240 | none (Imports) | N | 1 |
| 36 | `dittoHeatmap` | Expression heatmap with cell/sample annotations | dittoSeq | SCE / SE | VM base: `ComplexHeatmap_Heatmap` | Bioc #240 | none (Imports) | N | 1 |
| 37 | `scQC` | Per-cell QC metrics with MAD outlier thresholds | scuttle, scater | SCE | VM base: `dittoViz_yPlot`, `dittoViz_scatterPlot` | scuttle Bioc #66 | scuttle | N | 1 |
| 38 | `dittoScatterHex` | Binned scatter of two features | dittoSeq | SCE / SE | ggplotly | Bioc #240 | none (Imports) | N | 2 |
| 39 | `dittoPlotVarsAcrossGroups` | Gene-set scores across groups | dittoSeq | SCE / SE | ggplotly | Bioc #240 | none (Imports) | N | 2 |
| 40 | `clonotypePlots` | Clonal homeostasis / quant / diversity | scRepertoire | contig list / SCE | VM base: `plotthis_BarPlot`, `dittoViz_yPlot` | Bioc #299 | scRepertoire | N | 2 |
| 41 | `daNeighbourhood` | Differential-abundance beeswarm | miloR | Milo / results df | VM base: `dittoViz_yPlot` | Bioc #235 | miloR | Y | 3 |
| 42 | `spatialSpotPlot` | Spots/cells on tissue coordinates, optional H&E underlay | SpatialExperiment, ggspavis | SpatialExperiment | VM base: `dittoViz_scatterPlot` (+ native image layer) | Bioc #80 | SpatialExperiment | N | 2 |
| 43 | `spatialDeconvolution` | Per-spot cell-type proportions on tissue; composition by domain | spacexr (RCTD), SPOTlight, cell2location (Python) | SpatialExperiment + proportions | VM base: `spatialSpotPlot`, `plotthis_BarPlot` | spacexr Bioc #583, SPOTlight #442 | none | N | 2 |
| 44 | `spatialNeighborhood` | Cell-type neighbourhood enrichment / interaction z-scores | imcRtools, squidpy (Python) | `testInteractions()` df / AnnData | VM base: `ComplexHeatmap_Heatmap` | imcRtools Bioc #582; squidpy GitHub 599 stars | imcRtools | Y | 2 |
| 45 | `spatialSVG` | Spatially variable gene ranking linked to the spot plot | nnSVG, Voyager, squidpy | SpatialExperiment `rowData` | VM base: `dittoViz_scatterPlot` | nnSVG Bioc #1006 | none | N | 3 |
| 46 | `peakAnnotation` | Genomic feature and TSS-distance distribution of peaks | ChIPseeker | `csAnno` | VM base: `plotthis_BarPlot` | Bioc #151 | ChIPseeker, a TxDb | N | 2 |
| 47 | `tssProfile` | Average peak/read profile around TSS with CI | ChIPseeker | tag matrix | VM base: `linePlot` | Bioc #151 | ChIPseeker | N | 2 |
| 48 | `methylationDistributions` | Beta-value densities and MDS per sample | minfi, sesame | beta matrix / SE | VM base: `plotthis_DensityPlot`, `dittoViz_scatterPlot` | minfi Bioc #149 | minfi | N | 2 |
| 49 | `peakHeatmap` | Signal heatmap around peak centres | EnrichedHeatmap, ChIPseeker | tag matrix | VM base: `ComplexHeatmap_Heatmap` | Bioc #245 | ChIPseeker | N | 3 |
| 50 | `genomeTrack` | Coverage + gene-model tracks over a locus | Gviz, ggbio, trackViewer (reference) | GRanges / BigWig | Native | Gviz Bioc #130 | rtracklayer | N | 3 |
| 51 | `karyogramDensity` | Feature density on an ideogram | karyoploteR (reference) | GRanges | Native | Bioc #234 | none | N | 3 |
| 52 | `hicContactMap` | Hi-C / Micro-C contact matrix with TADs and loops | HiCExperiment, HiContacts, cooler (Python) | `.cool` / `.mcool` / `.hic` | Native | HiCExperiment Bioc #1273; cooler GitHub 245 stars | HiCExperiment | N | 3 |
| 53 | `multiqcSummary` | General stats per sample, FastQC curves, tool QC panels | MultiQC (non-R) | `multiqc_data/` TSVs / `multiqc.parquet` | VM base: `plotthis_BarPlot`, `linePlot` | GitHub 1.5k stars | nanoparquet (optional) | Y | 2 |
| 54 | `coverageQC` | Cumulative coverage distribution; per-chromosome/target depth | mosdepth (non-R), samtools | `.mosdepth.global.dist.txt`, `.regions.bed.gz` | VM base: `linePlot`, `plotthis_BarPlot` | GitHub 877 stars | none (reader) | Y | 2 |
| 55 | `readLengthQuality` | Long-read length vs quality, length distribution, N50 | ONT `sequencing_summary.txt`, NanoPlot (reference) | summary table | VM base: `dittoViz_scatterPlot`, `plotthis_Histogram` | NanoPlot GitHub 560 stars | none (reader) | Y | 2 |
| 56 | `proteomicsQC` | Intensity distributions, IDs per sample, missingness pattern | QFeatures, DEP | QFeatures / SE | VM base: `plotthis_BoxPlot`, `plotthis_BarPlot`, `ComplexHeatmap_Heatmap` | QFeatures Bioc #128 | QFeatures | N | 2 |
| 57 | `massSpectrum` | MS/MS spectrum with labelled peaks; mirror for library matches | Spectra | `Spectra` | Native | Bioc #132 | Spectra | N | 2 |
| 58 | `chromatogram` | TIC / BPC / extracted-ion chromatograms per sample | xcms, Spectra, MsExperiment | `MsExperiment` / chromatogram df | VM base: `linePlot` | xcms Bioc #161 | xcms or Spectra | Y | 2 |
| 59 | `multivariateScores` | PLS-DA / OPLS-DA score plots | ropls, mixOmics | model object | VM base: `dittoViz_scatterPlot` | ropls Bioc #182 | ropls | N | 3 |
| 60 | `taxaAbundanceBar` | Stacked relative abundance, top-N taxa + Other | phyloseq, mia | phyloseq / TreeSE | VM base: `plotthis_BarPlot` | phyloseq Bioc #87 | phyloseq or mia | N | 1 |
| 61 | `alphaDiversity` | Richness/Shannon by group, with stats | phyloseq, mia, vegan | phyloseq / TreeSE | VM base: `dittoViz_yPlot` (Stats tab) | vegan 146k/mo | vegan | N | 1 |
| 62 | `betaOrdination` | PCoA / NMDS on Bray-Curtis etc. | vegan, mia, phyloseq | phyloseq / TreeSE | VM base: `dittoViz_scatterPlot` | vegan 146k/mo | vegan | N | 1 |
| 63 | `phyloTree` | Phylogenetic tree with tip annotations | ape, treeio, ggtree (reference) | `phylo` / `treedata` | Native | ggtree Bioc #20 | ape | N | 2 |
| 64 | `rarefactionCurves` | Richness vs sequencing depth per sample | vegan, iNEXT | counts / phyloseq / TreeSE | VM base: `linePlot` | vegan 146k/mo | vegan | N | 1 |
| 65 | `differentialAbundance` | Taxon log-fold changes with CIs | ANCOMBC, Maaslin2 | results df | VM base via `forestPlot` | ANCOMBC Bioc #178, Maaslin2 #266 | none | Y | 2 |
| 66 | `taxonomySunburst` | Krona-style taxonomic composition | Kraken2 / Bracken (non-R), Krona (reference) | Kraken2 report | Native (plotly sunburst / icicle) | Kraken2 GitHub 939 stars, Krona 502 | none (reader) | Y | 1 |
| 67 | `amrGenePresence` | AMR genes and drug classes per isolate | AMRFinderPlus, ABRicate, RGI (non-R) | tool TSV | VM base: `ComplexHeatmap_Heatmap`, `plotthis_BarPlot` | ncbi/amr 389, abricate 514, rgi 434 GitHub stars | none (reader) | Y | 1 |
| 68 | `antibiogram` | % susceptible per organism x antibiotic; S/I/R proportions | AMR | AST df | VM base: `ComplexHeatmap_Heatmap`, `plotthis_BarPlot` | 1.7k/mo | AMR | Y | 2 |
| 69 | `pangenomePresence` | Core/accessory partition, gene frequency, presence matrix | Panaroo, Roary (non-R) | `gene_presence_absence.Rtab` | VM base: `piePlot`, `plotthis_Histogram`, `ComplexHeatmap_Heatmap` | Panaroo 375, Roary 380 GitHub stars | none (reader) | Y | 2 |
| 70 | `alphafoldConfidence` | Per-residue pLDDT and PAE heatmap | AlphaFold, ColabFold (non-R) | PAE / scores JSON + PDB/mmCIF | VM base: `linePlot`; native PAE heatmap | AlphaFold GitHub 14.9k stars, ColabFold 2.9k | jsonlite | N | Done |
| 71 | `structureViewer` | Interactive 3D cartoon coloured by pLDDT, B-factor or chain | NGLVieweR, r3dmol | PDB / mmCIF | Widget (non-plotly exception) | NGLVieweR 373/mo, r3dmol 537/mo | NGLVieweR | N | Done |
| 72 | `ramachandranPlot` | Backbone phi/psi with allowed regions | bio3d | PDB | VM base: `dittoViz_scatterPlot` | 2.7k/mo | bio3d | N | 2 |
| 73 | `contactMap` | Residue distance / contact map | bio3d | PDB / trajectory | Native | 2.7k/mo | bio3d | N | 3 |
| 74 | `mdTrajectoryMetrics` | RMSD, RMSF, radius of gyration, H-bonds over time | GROMACS, MDAnalysis, mdtraj (non-R); bio3d | `.xvg` / CSV | VM base: `linePlot` | gromacs 965, MDAnalysis 1.7k GitHub stars | none (reader) | Y | Done |
| 75 | `fscCurve` | Fourier shell correlation vs resolution | RELION, cryoSPARC (non-R) | RELION `postprocess.star` / FSC table | VM base: `linePlot` | relion GitHub 558 stars | none (reader) | Y | 3 |
| 76 | `cytometryBiaxial` | Biaxial scatter/density on transformed channels with gates | flowCore, CATALYST, ggcyto | flowFrame / flowSet / SCE | VM base: `dittoViz_scatterPlot` | flowCore Bioc #133 | flowCore | N | 2 |
| 77 | `cytometryMedianHeatmap` | Median marker expression per cluster | CATALYST, FlowSOM | SCE | VM base: `ComplexHeatmap_Heatmap` | CATALYST Bioc #354, FlowSOM #231 | CATALYST | N | 2 |
| 78 | `forestPlot` | Effect estimates with CIs (Cox, logistic, meta-analysis) | survival, forestplot, metafor | model / tidy df | Native | survival 237k/mo | none | Y | Done |
| 79 | `rocCurve` | ROC with AUC and CI, several predictors | pROC | df (response + predictors) | VM base: `linePlot` | pROC 149k/mo | pROC | Y | Done |
| 80 | `waterfallPlot` | Best % change per patient, RECIST thresholds | none standard | df | VM base: `plotthis_BarPlot` | n/a | none | Y | 2 |
| 81 | `swimmerPlot` | Per-patient time on treatment with events | swimplot (reference) | df | Native | 1k/mo | none | Y | 2 |
| 82 | `decisionCurve` | Net benefit across threshold probabilities | dcurves | df / `dca` | VM base: `linePlot` | 3.7k/mo | dcurves | Y | 3 |
| 83 | `pkConcentrationTime` | Concentration-time curves with NCA parameters | PKNCA | df | VM base: `linePlot` | 2.4k/mo | PKNCA | Y | Done |
| 84 | `signalOverlay` | Spectra (UV-vis/IR/Raman/NMR), XRD, DSC/TGA and stress-strain traces | hyperSpec, ChemoSpec, rxylib | spectra object / long df | VM base: `linePlot` | 2.4k/mo | none | Y | 2 |
| 85 | `growthCurve` | Microbial growth curves with logistic fits | growthcurver | df | VM base: `dittoViz_scatterPlot` + model backend | 0.8k/mo | growthcurver | Y | 2 |
| 86 | `blandAltman` | Method-agreement plot | BlandAltmanLeh (reference) | df | VM base: `dittoViz_scatterPlot` | 1.3k/mo | none | Y | 2 (upstream?) |
| 87 | `ternaryPlot` | Three-component compositions | ggtern (reference) | df | Native (`scatterternary`) | 3.4k/mo | none | Y | 3 (upstream?) |
| 88 | `qpcrAnalysis` | Amplification and melt curves; delta-delta-Ct fold change | qpcR, pcr; instrument exports | Ct / fluorescence tables | VM base: `linePlot`, `plotthis_BarPlot` | qpcR 1.2k/mo | none | Y | 2 |
| 89 | `plateHeatmap` | 96/384/1536-well plate map with Z'-factor and edge effects | platetools (reference), CellProfiler (non-R) | df with well IDs | Native (plotly heatmap) | CellProfiler GitHub 1.1k stars | none | Y | Done |
| 90 | `epiCurve` | Incidence over time by group | incidence2 | case linelist df | VM base: `plotthis_BarPlot` | incidence 1.9k/mo | incidence2 | Y | 2 |

"Reference" in the Source column means the package is the conventional tool, but the module
would not depend on it.

## Somatic variants (MAF)

maftools is the de facto reader for MAF files (Bioc #154). **All of its plots are base
graphics**: `oncoplot()`, `lollipopPlot()`, `rainfallPlot()`, `plotTiTv()` and
`somaticInteractions()` were checked in the source, and none call ggplot. No `ggplotly()`
route exists, so each module takes the MAF object (`read.maf()`), pulls the tables
maftools computes, and draws them itself. A shared helper converting a MAF into tidy
tables would serve every module in this section. Example data: maftools ships
`tcga_laml.maf.gz` with clinical annotations (`tcga_laml_annot.tsv`) in `inst/extdata`.

1. **`oncoPlot`** - the most recognisable cancer-genomics figure. Gene x sample tiles
   coloured by variant classification, with a top bar of mutations per sample, a side bar of
   gene frequency, and optional clinical tracks. Build natively as plotly subplots sharing
   axes; the tile layer is a heatmap on a categorical matrix (`getGeneSummary()`,
   `getSampleSummary()`, `subsetMaf()`). Tracks come from `getClinicalData()`. Hover per
   tile is the big win over the static plot.

2. **`mutationLollipop`** - mutation positions along a protein, stem height by count,
   domains as rectangles. maftools reads domains from its bundled `protein_domains.RDs`;
   positions come from the amino-acid change column. Native (segments + markers + shapes).

3. **`mafSummary`** - the panels of `plotmafSummary()`: variant classification, variant type,
   SNV class and per-sample counts, each a `plotthis_BarPlot` from `getSampleSummary()` /
   `getGeneSummary()`. One module with a panel selector, or a set of thin wrappers.

4. **`mutationalProfile`** - the SBS96 bar chart (six substitution classes x 16 contexts).
   The input is the standard 96 x sample count matrix produced by MutationalPatterns
   (`mut_matrix()`), maftools (`trinucleotideMatrix()`) or SigProfiler. Taking the matrix
   (a data frame) rather than the VCFs avoids a `BSgenome` dependency and makes it Figure
   Builder compatible. `plotthis_BarPlot` faceted by substitution class, with the COSMIC
   colours as `defaults`. MutationalPatterns ships example matrices under `inst/states`.

5. **`signatureContribution`** - stacked bars of signature exposures per sample (absolute or
   relative), from `fit_to_signatures()` or an NMF result. `plotthis_BarPlot`.

6. **`tiTvPlot`** - transition/transversion fractions: stacked per-sample bars plus a box plot
   of the six SNV classes. `titv(plot = FALSE)` returns the tables.

7. **`vafPlot`** - VAF distributions for the top mutated genes; a box/jitter plot from the
   MAF's VAF column. `dittoViz_yPlot`, so the Stats tab comes for free.

8. **`rainfallPlot`** - log10 inter-mutation distance against genomic position, coloured by
   SNV class, revealing kataegis. The distances are a sorted `diff()` per chromosome;
   positions are concatenated like `cnSegmentPlot`'s x-axis (reuse its seqlengths helpers).
   `dittoViz_scatterPlot`.

9. **`somaticInteractions`** - lower-triangle matrix of pairwise co-occurrence/exclusivity
   (Fisher test). `somaticInteractions()` returns the pair table (`sigPairsTblSig`); draw it
   as a native heatmap with significance markers.

10. **`tmbComparison`** - a cohort's tumour mutation burden against the TCGA cohorts.
    `tcgaCompare()` returns `median_mutation_burden`, `mutation_burden_perSample` and pairwise
    tests; draw sorted per-sample points per cohort with median bars, natively.

## Germline and population genetics

GWAS summary statistics are a de facto standard data frame (chromosome, position, p-value,
SNP id; MungeSumstats, Bioc #341, harmonises them). qqman's `manhattan()` and `qq()` are
base graphics, but the plots are plain scatters. Example data: qqman's `gwasResults`.

11. **`manhattanPlot`** - **Done.** `-log10(p)` against cumulative genomic position, alternating
    chromosome colours, genome-wide significance lines. A data-prep wrapper around
    `dittoViz_scatterPlot`, structurally like `volcanoPlot`. Real summary statistics run to
    millions of rows, so thin points well below significance before plotting and rely on
    WebGL. Highlight/label lead SNPs via the scatter module's annotation inputs. Nothing is
    p-value specific beyond the default transform, so any per-position statistic (Fst,
    Tajima's D, methylation difference, CRISPR tiling scores) plots the same way.

12. **`gwasQQPlot`** - **Done.** observed against expected `-log10(p)` with a null diagonal,
    confidence band and genomic inflation (lambda GC) in the title. `dittoViz_scatterPlot`
    plus a reference line. Pairs naturally with `manhattanPlot` (same input).

13. **`regionalAssociationPlot`** - LocusZoom-style view: association around a lead SNP,
    coloured by LD, over gene tracks. locuszoomr already provides `locus_plotly()`, which
    returns a plotly object, so this is a thin wrapper plus the finalise stack. It needs an
    `EnsDb` (ensembldb / AnnotationHub) for genes and, for LD, an LDlink token. Hence tier 2.

14. **`variantQC`** - QUAL, depth and allele-frequency distributions and per-sample Ti/Tv from a
    VCF (`VariantAnnotation::readVcf()`, `info()`, `geno()`). Histograms/densities via
    plotthis. Niche because most users QC upstream with bcftools.

15. **`admixturePlot`** - the population-genetics "structure plot": one stacked bar per
    individual of its ancestry proportions over K clusters, grouped and sorted by population
    and dominant component, with a K selector across runs. ADMIXTURE writes plain `.Q`
    matrices (one row per sample, in `.fam` order), and LEA's `snmf()` / STRUCTURE give the
    same shape. A reader joins the `.Q` to sample and population labels; the bars are
    `plotthis_BarPlot`.

## Bulk expression (RNA-seq, arrays)

The package already ships DE *results* (`airway_deseq2`, `airway_edger`, `airway_voom`);
these modules need the counts too. The `airway` data package's `SummarizedExperiment` is
the natural example. Gene-by-group expression is already covered: `dittoPlot` accepts a
`SummarizedExperiment` (see Extensions).

16. **`samplePCA`** - the first plot of every bulk analysis, as a thin front-end to
    `pcaPlot`. It takes a `SummarizedExperiment` / `DESeqDataSet` / `DGEList`, applies a
    variance-stabilising or log-CPM transform, keeps the most variable genes, and builds a
    PCAtools-shaped `pca` object (`PCAtools::pca()` when installed, otherwise `prcomp()` packed
    into the same list) with `colData` as its metadata. An MDS option (`limma::plotMDS()`
    coordinates) feeds the scores view only.

17. **`pcaPlot`** - **Done.** plots any PCAtools `pca` object, so any omics matrix with sample metadata
    works, not just what is stored on a `SingleCellExperiment`. It overlaps `dittoDimPlot` on
    the scores view, but adds the scree, loadings and PC-metadata views that a reduction
    stored in an SCE does not carry. The object is a plain S3 list (`rotated` scores,
    `loadings`, `variance` in %, `sdev`, `metadata`, `xvars`, `yvars`, `components`;
    checked in `pca()`), so the module needs no PCAtools code to read it. PCAtools stays a
    Suggests, used for the component-selection helpers and the examples. Views:
    - **Biplot** - `cbind(rotated, metadata)` into `dittoViz_scatterPlot`, with PC selectors,
      % variance in the axis titles, colour/shape by metadata, and optional loading vectors
      for the top variables as native arrow annotations. `biplot()` is ggplot, but rebuilding
      on the scatter module keeps stats, labels and source download consistent.
    - **Scree** - `variance` as `plotthis_BarPlot` with the cumulative % as a line, and
      reference lines at `findElbowPoint()`, `parallelPCA()` (Horn) and
      `chooseGavishDonoho()` / `chooseMarchenkoPastur()` where installed.
    - **Loadings** - the top-N variables by absolute loading per selected PC
      (`plotloadings()`'s view), as a dot or bar plot from `loadings`.
    - **Pairs** - a scatter grid of the first k PCs. `pairsplot()` assembles ggplots with
      cowplot, which `ggplotly()` cannot convert, so draw it natively as plotly subplots.
    - **PC-metadata correlation** - `eigencorplot()`'s correlation of each PC with each
      numeric/encoded metadata column, with p-values. It is lattice graphics, so compute
      the matrix and render it with `ComplexHeatmap_Heatmap` (or a native heatmap if it
      should stay plotly for the Figure Builder).

    PLINK's `--pca` output (`.eigenvec` / `.eigenval`) converts to the same shape with a
    small reader, which brings population-genetics PCA in at no extra cost.

    Example data: `PCAtools::pca()` on the `airway` counts, or on the package's own
    `example_sce` logcounts with its `colData`.

18. **`sampleDistanceHeatmap`** - Euclidean or correlation distances between samples, with
    `colData` annotations; the standard DESeq2-vignette QC. `ComplexHeatmap_Heatmap` fed a
    distance matrix as a data frame.

19. **`deHeatmap`** - z-scored expression of the top-N DE genes (by padj/LFC from a results
    table) across samples, with condition annotations. `ComplexHeatmap_Heatmap`; the module's
    job is the gene selection and scaling.

20. **`pValueHistogram`** - raw p-value histogram per contrast, the check for a well-calibrated
    test. `plotthis_Histogram`. Cheap; uses the DE-results data frames the package already
    ships.

21. **`countDistributions`** - library sizes, per-sample log-CPM box/density plots, and
    before/after normalisation side by side. plotthis box, density and bar modules.

22. **`meanVariance`** - `vsn::meanSdPlot`, the DESeq2 dispersion plot, or the voom
    mean-variance trend as a scatter with a fitted line. `dittoViz_scatterPlot`. Mostly of
    interest to analysts debugging normalisation.

23. **`wgcnaModuleTrait`** - WGCNA (32.8k CRAN downloads a month) is the standard
    co-expression network tool, and its signature figure is the module-trait heatmap:
    correlation of each module eigengene with each trait, with p-values in the cells.
    `labeledHeatmap()` is base graphics (checked), so compute `cor(MEs, traits)` and
    render it with `ComplexHeatmap_Heatmap`. Further views: eigengene expression by group
    (`dittoViz_yPlot`), and the gene dendrogram with module colour bars (native, from the
    `hclust` object).

24. **`expressionTrajectories`** - time-course or dose-series clusters: one panel per
    cluster, each gene a faint line with the cluster mean on top (Mfuzz soft clusters,
    DEGreport `degPatterns()`, TCseq). `linePlot` with `group.by = gene`,
    `facet.by = cluster`, on z-scored expression.

25. **`rmatsSplicing`** - rMATS is the most used differential-splicing tool; it writes one
    table per event type (`SE`, `RI`, `MXE`, `A5SS`, `A3SS`, `*.MATS.JC.txt`). Views: dPSI
    against FDR through `volcanoPlot` with `defaults`; event counts by type and direction
    (`plotthis_BarPlot`); and per-event PSI by group from the comma-separated
    `IncLevel1` / `IncLevel2` columns (`dittoViz_yPlot`). Sashimi plots (read coverage with
    junction arcs) are a natural native follow-on but need BAMs, so they are left out.

## Enrichment

The enrichplot / clusterProfiler / DOSE family (Bioc #26, #29, #31) and fgsea (#27) dominate.
enrichplot's plots are ggplot but rarely `ggplotly()`-friendly: `gseaplot2()` stacks its panels
with `aplot::gglist()`, and `cnetplot()` / `emapplot()` are graph layouts (`ggtangle`,
igraph). Build those natively from the underlying data.

26. **`gseaEnrichmentPlot`** - **Done.** running enrichment score, hit ticks and ranked metric for one
    or more gene sets: the canonical GSEA figure. fgsea exports `plotEnrichmentData()`, which
    returns the curve and ticks, so a native three-row subplot draws it directly. For
    clusterProfiler's `gseaResult` the running score can be recomputed from `geneList` and the
    core genes. Example data: fgsea's `examplePathways` / `exampleRanks`.

27. **`geneConceptNetwork`** - cnetplot: terms and genes as a bipartite network, gene nodes
    coloured by fold change. Native plotly network: igraph layout, edges as line segments,
    nodes as markers with hover.

28. **`enrichmentMap`** - emapplot: terms as nodes, edges weighted by gene overlap
    (`pairwise_termsim()`), clusters of related terms. Shares the network-drawing helper with
    `geneConceptNetwork`, so build them together.

29. **`gseaRidge`** - per-term distribution of the core genes' fold changes (enrichplot
    `ridgeplot()`). enrichplot uses ggridges, which `ggplotly()` does not translate, but
    `dittoViz_yPlot` already draws ridges natively, so build on that with a long table of
    term x gene x fold change.

30. **`gsvaHeatmap`** - GSVA/ssGSEA scores (pathway x sample) as an annotated heatmap.
    `ComplexHeatmap_Heatmap`; GSVA returns a matrix or SE.

31. **`setOverlapUpset`** - UpSet of overlaps between gene lists (DE contrasts, enriched-term
    genes). Native bars plus a dot-matrix subplot. Generic, so a VizModules candidate
    (**upstream?**); Venn diagrams deliberately omitted in favour of UpSet.

## Functional genomics screens

Pooled CRISPR screens are analysed almost universally with MAGeCK (Python), whose outputs
are stable, documented TSVs: `gene_summary.txt` (RRA: `neg|score`, `neg|p-value`,
`neg|fdr`, `neg|rank`, `neg|lfc` and the `pos|` mirror; checked), `sgrna_summary.txt`,
`count.txt` and `countsummary.txt`. MAGeCKFlute (Bioc) post-processes them, but its
download rank (#2182) undersells MAGeCK's reach. One reader serves all three modules.

32. **`crisprScreenRank`** - **Done.** genes ranked by RRA score or LFC with the top hits labelled,
    split by negative (depletion) and positive (enrichment) selection, coloured by FDR.
    `dittoViz_scatterPlot` with x = rank, y = LFC or `-log10(score)`; labelling uses the
    scatter module's highlight inputs. Drill-down to the gene's guides from
    `sgrna_summary.txt` as a second view.

33. **`crisprBetaScatter`** - MAGeCK MLE beta scores for treatment against control, with the
    nine-square partition MAGeCKFlute popularised (positive/negative selection in one
    condition, both, or neither). `dittoViz_scatterPlot` plus reference lines at
    +/- k SD.

34. **`screenQC`** - library-level QC: mapped and zero-count guides, Gini index, and
    normalised count distributions per sample (`countsummary.txt`, `count.txt`). plotthis
    bar and density modules.

## Single-cell (beyond the shipped dittoSeq modules)

35. **`dittoDotPlot`** - expression (colour) x percent expressing (size) per gene per group,
    the standard marker figure. `dittoSeq::dittoDotPlot()` returns a ggplot (checked), so it
    fits the existing dittoSeq wrapper pattern exactly, with no new dependencies. The
    cheapest high-value module on this list.

36. **`dittoHeatmap`** - `dittoHeatmap(data.out = TRUE)` returns the matrix and annotations
    (checked), which `ComplexHeatmap_Heatmap` can render with the cell/sample metadata as
    annotation tracks. No new dependencies.

37. **`scQC`** - per-cell library size, detected features and mitochondrial %, with
    MAD-based outlier thresholds drawn as reference lines (`scuttle::perCellQCMetrics()`,
    `isOutlier()`). Violin/jitter by sample via `dittoViz_yPlot`, plus
    detected-vs-library-size scatters. Example data: the package's `example_sce`.

38. **`dittoScatterHex`** - binned two-feature scatter; the companion to `dittoDimHex`.
    ggplotly wrap.

39. **`dittoPlotVarsAcrossGroups`** - module/gene-set scores summarised across groups. ggplotly
    wrap.

40. **`clonotypePlots`** - immune-repertoire summaries (`clonalHomeostasis()`, `clonalQuant()`,
    `clonalDiversity()`). scRepertoire's functions return ggplots but can also return their
    tables (`export.table`), so build on plotthis bars and `dittoViz_yPlot` rather than
    `ggplotly()`. Example data: scRepertoire's `contig_list`.

41. **`daNeighbourhood`** - miloR's differential-abundance beeswarm (log fold change per
    neighbourhood, by cell type). `dittoViz_yPlot` jitter on the results table.

## Spatial

42. **`spatialSpotPlot`** - spots/cells at `spatialCoords()` coloured by gene or cluster, with
    the tissue image underneath. The points are a `dittoViz_scatterPlot` (y reversed); the
    image (`imgRaster()`) needs a native `layout.images` layer, since ggspavis'
    raster-based `plotVisium()` will not go through `ggplotly()` cleanly. SpatialExperiment
    is Bioc #80 and growing; its `inst/extdata` has a small Visium example. Imaging-based
    platforms (Xenium, CosMx, MERFISH) and imaging mass cytometry (cytomapper, Bioc #408)
    give single cells rather than spots: the same scatter with cell centroids, plus
    segmentation polygons as an optional native layer. Python results (scanpy, squidpy)
    arrive as AnnData and convert with zellkonverter (Bioc #137).

43. **`spatialDeconvolution`** - per-spot cell-type proportions from RCTD (spacexr,
    now Bioc #583), SPOTlight (Bioc #442) or cell2location (Python, via AnnData). A
    selected cell type's proportion as the colour scale on `spatialSpotPlot`, the dominant
    type as a discrete colour, and mean composition per spatial domain as stacked
    `plotthis_BarPlot`. Per-spot scatter-pies (SPOTlight's `plotSpatialScatterpie()`) have
    no plotly equivalent and would be a costly native extra.

44. **`spatialNeighborhood`** - which cell types sit next to which more than chance:
    imcRtools `testInteractions()` returns a tidy per-pair table (exported, checked), and
    squidpy's `nhood_enrichment` z-scores arrive through AnnData. A cell-type x cell-type
    `ComplexHeatmap_Heatmap` with significance markers.

45. **`spatialSVG`** - spatially variable genes ranked by nnSVG / Moran's I (Voyager,
    squidpy `spatial_autocorr`), as a rank scatter whose selection drives
    `spatialSpotPlot`. Cheap once `spatialSpotPlot` exists, but niche.

## Epigenomics and genomic ranges

46. **`peakAnnotation`** - share of peaks per genomic feature and distance-to-TSS bins, one bar
    per sample (`ChIPseeker::annotatePeak()` -> `csAnno` statistics). `plotAnnoPie()` is
    base graphics, while `plotAnnoBar()` / `plotDistToTSS()` are ggplot; `plotthis_BarPlot`
    from the stats table covers all three. Needs a TxDb, hence tier 2.

47. **`tssProfile`** - average signal around TSSs with a confidence band (`getTagMatrix()` ->
    column means / bootstrap). `linePlot` with error bands.

48. **`methylationDistributions`** - beta-value densities per sample and an MDS of the most
    variable CpGs (minfi `getBeta()`; sesame is already a Suggests). `plotthis_DensityPlot` and
    `dittoViz_scatterPlot`. minfi's `densityPlot()` is base graphics.

49. **`peakHeatmap`** - signal heatmap around peak centres (EnrichedHeatmap style).
    `ComplexHeatmap_Heatmap` on the tag matrix. The matrices are large (peaks x bins), so it
    needs downsampling.

50. **`genomeTrack`** - coverage (BigWig via rtracklayer) and gene models over a locus, the
    Gviz/ggbio/trackViewer role. Gviz is grid graphics, so build natively as stacked
    subplots on a shared genomic axis. Costly but broadly useful; `cnSegmentPlot`'s axis
    helpers are a start.

51. **`karyogramDensity`** - feature density (peaks, CNVs, variants) along each chromosome
    ideogram. karyoploteR is base graphics, so build natively. `cnSegmentPlot()` already
    parses cytobands.

52. **`hicContactMap`** - Hi-C / Micro-C contact matrices as a rotated triangle or square
    heatmap over a locus, with TAD and loop calls overlaid. Matrices come from `.cool` /
    `.mcool` (cooler, Python) or `.hic` (Juicer), read into Bioconductor by HiCExperiment.
    Native plotly heatmap; matrices at fine resolution are large, so read only the visible
    region.

## Sequencing QC

Read- and alignment-level QC is the first thing every sequencing project looks at, and it is
dominated by command-line tools whose outputs are plain tables. Nothing here needs an R
package beyond a reader.

53. **`multiqcSummary`** - MultiQC (GitHub 1.5k stars) aggregates FastQC, STAR, Salmon,
    Picard, samtools and dozens more into one report, and writes its data to
    `multiqc_data/`: a general-statistics TSV, per-tool TSVs, and since 1.29 a stable
    `multiqc.parquet` (checked) holding every plot's data. Views: general stats per sample
    (bars, coloured by group from a sample sheet), and the FastQC per-base quality, GC and
    duplication curves (`linePlot`). The TSVs need no dependency; the parquet path would
    use nanoparquet (CRAN, dependency-free) as an optional Suggests.

54. **`coverageQC`** - mosdepth (GitHub 877 stars) is the standard coverage tool; its
    `.mosdepth.global.dist.txt` gives the fraction of bases at or above each depth, per
    chromosome. Cumulative coverage curves per sample (`linePlot`) and mean depth per
    chromosome or target (`plotthis_BarPlot`, from `.regions.bed.gz` / `summary.txt`).

55. **`readLengthQuality`** - long-read QC: read length against mean quality (binned
    scatter), length distribution with N50, and yield over time, from ONT's
    `sequencing_summary.txt` (written by MinKNOW/dorado) or a NanoPlot-style table.
    `dittoViz_scatterPlot` and `plotthis_Histogram`; files run to millions of reads, so
    subsample for the scatter.

## Proteomics and metabolomics

56. **`proteomicsQC`** - intensity distributions per sample (before/after normalisation),
    identifications per sample, and the missing-value pattern (the DEP `plot_missval()` view).
    Plotthis box/bar plus `ComplexHeatmap_Heatmap` for missingness. Takes a QFeatures or
    SummarizedExperiment.

57. **`massSpectrum`** - centroided spectrum as sticks with m/z labels on the top peaks, and a
    mirror plot for a query-vs-library match. `Spectra::plotSpectra()` /
    `plotSpectraMirror()` are base graphics, so build natively. Example data: the `msdata`
    package's mzML files.

58. **`chromatogram`** - TIC, base-peak and extracted-ion chromatograms per sample (retention
    time vs intensity). xcms' plotting is base graphics, but the chromatogram data extracts
    cleanly to a long data frame for `linePlot`. FB-compatible once in that form.

59. **`multivariateScores`** - PLS-DA / OPLS-DA score plots with group ellipses (ropls
    `getScoreMN()`, mixOmics). `dittoViz_scatterPlot`. Niche outside metabolomics.

## Microbiome

phyloseq (Bioc #87) and mia's `TreeSummarizedExperiment` (Bioc #177, the newer standard) are
both well-defined structures, and all three core microbiome plots map directly onto VizModules
bases. Example data: `GlobalPatterns`, shipped by both phyloseq and mia.

60. **`taxaAbundanceBar`** - stacked relative abundance per sample at a chosen rank, top-N taxa
    plus "Other" (`mia::agglomerateByRank()`, `getTop()`; `phyloseq::tax_glom()`).
    `plotthis_BarPlot`. The single most common microbiome figure. Bracken abundance tables and HUMAnN pathway
    tables (both non-R) are the same feature x sample shape and reuse it via readers.

61. **`alphaDiversity`** - richness / Shannon / Simpson by group (`mia::addAlpha()`,
    `phyloseq::estimate_richness()`, `vegan::diversity()`). `dittoViz_yPlot`, whose Stats tab
    gives the pairwise tests reviewers ask for.

62. **`betaOrdination`** - PCoA/NMDS on Bray-Curtis/UniFrac/Jaccard (`vegan::vegdist()`,
    `metaMDS()`, `mia::runMDS()`), with group colouring and optional PERMANOVA in the title.
    `dittoViz_scatterPlot`.

63. **`phyloTree`** - phylogenetic tree (rectangular/circular) with tip colours and annotation
    strips. ggtree (Bioc #20) is the standard, but since v4 its branches use a ggiraph geom
    that `ggplotly()` renders blank
    ([ggtree#682](https://github.com/YuLab-SMU/ggtree/issues/682)). Compute the layout
    (ape / treeio node coordinates) and draw the segments natively.

64. **`rarefactionCurves`** - observed richness against sequencing depth per sample, the
    check that sampling was deep enough. `vegan::rarecurve()` is base graphics and iNEXT's
    `ggiNEXT()` is ggplot (checked), but both compute a table first (`rarecurve(tidy =
    TRUE)`, iNEXT's `iNextEst`), so this is `linePlot` with a depth line.

65. **`differentialAbundance`** - ANCOM-BC (Bioc #178) and MaAsLin2 (#266) results as
    log-fold changes with CIs per taxon, sorted, coloured by significance. Structurally a
    forest plot, so build it as a thin wrapper on `forestPlot`.

## Microbiology: isolates and pathogens

Pathogen and isolate genomics runs on command-line tools with stable tabular outputs, and is
a gap the R plotting ecosystem barely covers. Readers make these first-class.

66. **`taxonomySunburst`** - Krona-style interactive taxonomy from Kraken2 reports (GitHub
    939 stars; Bracken re-estimates on the same format). The report is a fixed-column TSV
    (percent, clade reads, direct reads, rank code, taxid, indented name; checked in the
    Kraken2 manual), with an 8-column variant when `--report-minimizer-data` is used, so
    the reader handles both. Native plotly `sunburst` / `icicle` from the parent-child
    table, the same trace type `goFanPlot` uses. Comparing samples falls to
    `taxaAbundanceBar`.

67. **`amrGenePresence`** - antimicrobial-resistance genes per isolate from AMRFinderPlus
    (NCBI), ABRicate or RGI (CARD). An isolate x gene presence heatmap annotated by drug
    class (`ComplexHeatmap_Heatmap`), plus counts per class (`plotthis_BarPlot`).
    AMRFinderPlus 4 renamed `Gene symbol` to `Element symbol` (checked in its README), so
    the reader accepts both.

68. **`antibiogram`** - phenotypic susceptibility: % susceptible per organism x antibiotic,
    the clinical microbiology lab's standard summary, and S/I/R proportions per drug. The
    AMR package (CRAN) interprets MIC and disk values with EUCAST/CLSI breakpoints
    (`as.sir()`) and builds the table (`antibiogram()`, exported, checked). Heatmap via
    `ComplexHeatmap_Heatmap`, proportions via `plotthis_BarPlot`.

69. **`pangenomePresence`** - Panaroo / Roary write `gene_presence_absence.Rtab`, a binary
    gene x isolate matrix. Core / soft-core / shell / cloud partition (`piePlot`), gene
    frequency histogram (`plotthis_Histogram`), and the presence matrix ordered by a tree or
    clustering (`ComplexHeatmap_Heatmap`). Matrices run to tens of thousands of genes, so
    the matrix view filters to accessory genes.

## Structural biology

No structural-biology output is covered yet, and AlphaFold made per-residue confidence
plots routine. The 2D views fit the existing stack; a 3D viewer is the one module here
that would not be plotly (allowed as a flagged exception).

70. **`alphafoldConfidence`** - **Done.** per-residue pLDDT along the sequence, banded by the standard
    confidence thresholds (`linePlot` with reference lines), and the predicted aligned
    error (PAE) as a residue x residue heatmap, where domains show as low-error blocks
    (native plotly heatmap). Inputs: AlphaFold DB / AlphaFold PAE JSON
    (`predicted_aligned_error`) with pLDDT from the B-factor column, or ColabFold's
    `*_scores_*.json`, which carries `plddt`, `pae` and `max_pae` (both checked in source).
    Multimer predictions add chain boundaries to the heatmap. jsonlite (already installed
    with plotly) reads the JSON.

71. **`structureViewer`** - **Done.** interactive 3D cartoon/surface of a PDB or mmCIF, coloured by
    pLDDT, B-factor, chain or a user column, with residue selection linked to the 2D
    plots. NGLVieweR and r3dmol both export Shiny bindings (`NGLVieweROutput()` /
    `renderNGLVieweR()`, `r3dmolOutput()` / `renderR3dmol()`; checked). **Not plotly**: no
    Figure Builder panel and no plotly export, so the module needs its own snapshot and
    download path.

72. **`ramachandranPlot`** - backbone phi/psi per residue over the favoured/allowed regions,
    for model validation. `bio3d::torsion.pdb()` computes the angles; reference regions as
    a background density or contour. `dittoViz_scatterPlot`, coloured by residue type or
    pLDDT.

73. **`contactMap`** - residue-residue distance or contact map from a structure or an MD
    trajectory (`bio3d::cmap()`, `dm()`; its plot is base graphics, checked). Native
    heatmap, sharing code with the PAE view.

74. **`mdTrajectoryMetrics`** - **Done.** the standard molecular-dynamics summaries: RMSD and radius
    of gyration over time, RMSF per residue, hydrogen-bond counts, several replicas
    overlaid. GROMACS writes these as `.xvg` (whitespace columns with `#` comments and `@`
    Grace directives that carry the axis labels and legends); MDAnalysis and mdtraj users
    export CSV; bio3d computes `rmsd()` / `rmsf()` in R. `linePlot` with an xvg reader.

75. **`fscCurve`** - cryo-EM Fourier shell correlation against spatial frequency, with the
    0.143 threshold and the reported resolution, for half-maps and masked/unmasked
    variants. RELION writes it in `postprocess.star` (STAR format), and cryoSPARC exports
    the curve as a table. `linePlot`; the STAR reader is the main cost.

## Cytometry

76. **`cytometryBiaxial`** - biaxial scatter or density of two channels after arcsinh/logicle
    transformation, with gates drawn as plotly shapes. Input is a `flowFrame`/`flowSet`
    (flowCore, Bioc #133) or CATALYST's SCE. `dittoViz_scatterPlot` with transformation
    controls; CATALYST's `plotExprs()` densities map onto `plotthis_DensityPlot` in a second
    tab. Example data: flowCore's `GvHD`. FlowJo
    workspaces (`.wsp`) import through CytoML into a flowWorkspace `GatingSet`, whose gates
    (`gs_pop_get_gate()`) can be drawn as the same shapes, so manual gating from FlowJo shows
    up without re-gating.

77. **`cytometryMedianHeatmap`** - median (arcsinh) marker expression per cluster, the
    figure used to name FlowSOM / CATALYST clusters (`plotExprHeatmap()` view).
    `ComplexHeatmap_Heatmap` on the per-cluster medians, with cluster sizes as an
    annotation. Differential cluster abundance needs no new module: `dittoFreqPlot`
    already takes CATALYST's SCE (see Extensions).

## Clinical and translational

78. **`forestPlot`** - **Done.** hazard/odds ratios with CIs per term or subgroup, with a reference line
    at 1 and an estimate table. Input is a `coxph`/`glm` fit (tidied in the module) or a tidy
    data frame (`term`, `estimate`, `conf.low`, `conf.high`). forestplot/forestploter are grid
    graphics, so build natively (horizontal error bars + log x-axis). Example data: the
    package's `survival_lung`.

79. **`rocCurve`** - **Done.** ROC for one or more predictors with AUC (+ DeLong CI) in the legend
    (`pROC::roc()`, `coords()`, `ci.auc()`). pROC's `ggroc()` is ggplot, but the coordinates
    are what matter: `linePlot`, with the chance diagonal from the Lines tab. Example data:
    pROC's `aSAH`.

80. **`waterfallPlot`** - best percentage change per patient, sorted, coloured by response,
    with RECIST -30%/+20% lines. `plotthis_BarPlot` with reference lines. No standard package,
    but a standard trial figure.

81. **`swimmerPlot`** - per-patient horizontal bars of time on treatment, with markers for
    events (response, progression, ongoing). Native (bars + markers), from a tidy table.

82. **`decisionCurve`** - net benefit against threshold probability for models vs
    treat-all/none (`dcurves::dca()`). `linePlot` on its tidy output.

## Bench, applied and physical sciences

Wet-lab, applied and physical-science plots. Most are x-y traces or binned counts, so they sit on
`linePlot` and the plotthis bars; instrument exports are read with small readers or `readxl`
(already an Import).

83. **`pkConcentrationTime`** - **Done.** plasma concentration vs time per subject or as mean +/- SD,
    linear/log y, with Cmax/Tmax/AUC/half-life from `PKNCA::pk.nca()` in a table or
    annotation. `linePlot` (its error bars already do mean +/- SD/SEM). Example data: base R's
    `datasets::Theoph`. Cheap.

84. **`signalOverlay`** - a generic x-y trace overlay for instrument data: UV-vis, IR, Raman
    and 1D-NMR spectra, powder XRD diffractograms (2-theta), DSC/TGA thermograms, and
    stress-strain or rheology curves. Normalisation, baseline offset/stacking, reversed x
    for wavenumber/ppm, derivative traces, and peak labels. `linePlot` on a long
    table; hyperSpec / ChemoSpec objects convert directly, and rxylib (CRAN) reads the
    common XRD and spectroscopy instrument formats (`.xy`, Bruker `.raw`, ...).

85. **`growthCurve`** - optical-density growth curves per well/strain with logistic fits and
    growth rate, carrying capacity and doubling time (`growthcurver::SummarizeGrowth()`).
    Build like `doseResponse`: `dittoViz_scatterPlot` with a registered model backend
    (`register_model_backend()`).

86. **`blandAltman`** - difference vs mean of two methods, with bias and limits of agreement as
    reference lines. `dittoViz_scatterPlot` + computed hlines. Generic (**upstream?**).

87. **`ternaryPlot`** - three-part compositions (soil texture, alloys, mineral and phase
    diagrams). ggtern has no `ggplotly()` route, but plotly has `scatterternary`, so build
    natively. Generic (**upstream?**).

88. **`qpcrAnalysis`** - qPCR in three views: amplification curves (fluorescence vs cycle,
    log y, threshold line), melt curves (-dF/dT vs temperature, for specificity), and
    delta-delta-Ct relative expression with error bars against a reference gene and control
    condition. `linePlot` for the curves; `plotthis_BarPlot` (or `linePlot`'s error bars)
    for fold change. Instrument exports (QuantStudio, Bio-Rad CFX, LightCycler) are
    CSV/XLSX with vendor headers; read them with `readxl` plus a documented long format.
    qpcR / pcr (CRAN) are reference implementations for efficiency correction.

89. **`plateHeatmap`** - **Done.** 96/384/1536-well plate maps of raw or normalised readouts, with
    control wells marked, Z'-factor per plate, and row/column edge-effect summaries. Input
    is any table with a well ID (`A01`, `P24`): plate-reader exports, CellProfiler's
    per-image CSVs (`Metadata_Well`), or screening data. Native plotly heatmap (rows A-P
    reversed, hover per well). It pairs naturally with `doseResponse` for plate-based
    assays. platetools (CRAN) is the reference.

90. **`epiCurve`** - epidemic curves: case counts per day/week/month, stacked by a group
    (site, serotype, outcome), with an optional rolling average. incidence2 (CRAN) bins a
    case line list; `plotthis_BarPlot` draws it. The `outbreaks` package provides example
    line lists.

## Readers for non-R tool outputs

The modules above that take a command-line or Python tool's output would share a family of
small `read_*()` helpers: base R plus jsonlite (installed with plotly, but it would still
need declaring here), each
returning a tidy data frame (or, for `read_plink_pca()`, a PCAtools-shaped list). Each
reader is tested against a real output file checked into `tests/testthat/`, since these
formats drift between tool versions.

| Reader | Tool | File(s) | Feeds |
|---|---|---|---|
| `read_mageck()` | MAGeCK | `gene_summary.txt`, `sgrna_summary.txt`, `count.txt`, `countsummary.txt` | `crisprScreenRank`, `crisprBetaScatter`, `screenQC` |
| `read_kraken_report()` | Kraken2 / Bracken | report (6- and 8-column) | `taxonomySunburst`, `taxaAbundanceBar` |
| `read_amr()` | AMRFinderPlus, ABRicate, RGI | per-isolate TSV | `amrGenePresence` |
| `read_pangenome()` | Panaroo, Roary | `gene_presence_absence.Rtab` | `pangenomePresence` |
| `read_alphafold()` | AlphaFold, ColabFold | PAE / scores JSON, PDB / mmCIF B-factors | `alphafoldConfidence`, `structureViewer` |
| `read_xvg()` | GROMACS | `.xvg` | `mdTrajectoryMetrics` |
| `read_star_fsc()` | RELION | `postprocess.star` | `fscCurve` |
| `read_admixture()` | ADMIXTURE, sNMF | `.Q` (+ `.fam`) | `admixturePlot` |
| `read_plink_pca()` | PLINK | `.eigenvec`, `.eigenval` | `pcaPlot` |
| `read_rmats()` | rMATS | `*.MATS.JC.txt` | `rmatsSplicing` |
| `read_multiqc()` | MultiQC | `multiqc_data/` TSVs, `multiqc.parquet` | `multiqcSummary` |
| `read_mosdepth()` | mosdepth | `.mosdepth.global.dist.txt`, `.regions.bed.gz` | `coverageQC` |
| `read_cnvkit()` | CNVkit | `.cnr`, `.cns` | `cnSegmentPlot` (see Extensions) |

Python objects (scanpy / squidpy / cell2location AnnData) are not re-parsed: they convert
with zellkonverter (Bioc #137) into a `SingleCellExperiment` / `SpatialExperiment`.

## Extensions to existing modules

Ideas that belong in a shipped module rather than a new one:

- **`volcanoPlot` / `maPlot`** - EnhancedVolcano (Bioc #90) is the popular static
  alternative; its extras (labelled genes, connectors, custom thresholds) are what to match
  rather than a new module.
- **`dittoFreqPlot`** - document CATALYST's `SingleCellExperiment` (`cluster_id`, `sample_id`,
  `condition`) as an input, which gives cytometry differential-abundance plots for free.
- **`enrichmentDotPlot`** - a bar-chart mode (clusterProfiler `barplot()`), since it is the
  same data.
- **`cnSegmentPlot`** - accept DNAcopy/CBS segment tables (maftools ships
  `LAML_CBS_segments.tsv.gz`) and CNVkit's bin-level `.cnr` plus segment `.cns` (GitHub 616
  stars; the same bins-and-segments pair the module already draws from sesame) as well as
  sesame `CNSegment`. GISTIC2 amplification/deletion G-scores along the genome are a
  natural second layout of the same genomic axis.
- **`survivalCurve`** - competing-risks cumulative incidence (cmprsk / tidycmprsk) and a risk
  table.
- **`doseResponse`** - IC50/EC50 reporting with CIs, and a 4PL standard-curve preset for
  ELISA.
- **`dittoPlot`** - document that it accepts a bulk `SummarizedExperiment`, which covers
  "expression of gene X by condition" for RNA-seq.
- **`dittoDimPlot`** - trajectories via dittoSeq's `add.trajectory.lineages` /
  `add.trajectory.curves` (slingshot output) rather than a separate trajectory module.

## Considered and rejected

- **Cell-cell communication (CellChat, nichenetr, LIANA)** - none is on CRAN or
  Bioconductor, and a Bioconductor package cannot depend on GitHub-only packages.
- **Pathway diagrams (pathview)** - renders KEGG raster images; nothing interactive to gain.
- **Circos plots (circlize)** - no plotly equivalent; a native polar rebuild is costly for a
  figure most users export statically anyway.
- **Isoform switch plots (IsoformSwitchAnalyzeR), fusion plots (chimeraviz)** - grid-composite
  figures with narrow audiences.
- **Multiple sequence alignments (ggmsa)** - ~30 CRAN downloads a month.
- **Sequence logos (ggseqlogo, motifStack)** - polygon glyphs survive `ggplotly()` poorly, and
  the static figure is what people publish.
- **TCGAbiolinks** - data access, not plotting; its outputs feed `oncoPlot`, `survivalCurve`,
  etc.
- **DiffBind / DEXSeq / DRIMSeq** - their headline plots are MA/volcano/heatmap views already
  covered by shipped modules or `deHeatmap`.
- **MOFA2** - factor plots are scatters/heatmaps reachable through `dittoViz_scatterPlot` and
  `ComplexHeatmap_Heatmap` on its outputs; not worth a dedicated module unless asked.
- **Venn diagrams** - superseded by `setOverlapUpset`.
- **MLST / serotype summaries** - a bar chart of sequence types; `plotthis_BarPlot` on the
  `mlst` table already does it, with no module needed.
- **Sashimi plots** - need BAM access and a native coverage-plus-arcs build; revisit after
  `genomeTrack`.

## Sources

- Bioconductor download scores: <https://bioconductor.org/packages/stats/bioc/bioc_pkg_scores.tab>
- CRAN downloads (September 2026): <https://cranlogs.r-pkg.org/>
- maftools source and example data: <https://github.com/PoisonAlien/maftools> (R/, inst/extdata);
  `tcgaCompare()` value: <https://rdrr.io/bioc/maftools/man/tcgaCompare.html>
- enrichplot (`gseaplot2()` via `aplot::gglist`, `cnetplot` via ggtangle):
  <https://github.com/YuLab-SMU/enrichplot>
- fgsea `plotEnrichmentData()`: <https://github.com/ctlab/fgsea/blob/master/R/plot.R>
- ChIPseeker plotting: <https://github.com/YuLab-SMU/ChIPseeker>
- MutationalPatterns: <https://github.com/UMCUGenetics/MutationalPatterns>
- phyloseq / mia / miaViz: <https://github.com/joey711/phyloseq>, <https://github.com/microbiome/mia>
- locuszoomr `locus_plotly()`: <https://github.com/myles-lewis/locuszoomr>
- ggtree and `ggplotly()`: <https://github.com/YuLab-SMU/ggtree/issues/682>,
  <https://github.com/YuLab-SMU/ggtree/issues/712>
- Spectra / xcms plotting: <https://github.com/rformassspectrometry/Spectra>,
  <https://github.com/sneumann/xcms>
- PCAtools `pca()` object and plot functions: <https://github.com/kevinblighe/PCAtools>
- ggspavis, scRepertoire, miloR, dcurves, pROC, scater, CATALYST: their GitHub
  sources, checked for ggplot vs base/grid graphics.
- Non-R tool formats: MAGeCK output wiki <https://sourceforge.net/p/mageck/wiki/output/>,
  Kraken2 manual <https://github.com/DerrickWood/kraken2/blob/master/docs/MANUAL.markdown>,
  AMRFinderPlus <https://github.com/ncbi/amr/wiki/Running-AMRFinderPlus>,
  CNVkit file formats <https://cnvkit.readthedocs.io/en/stable/fileformats.html>,
  MultiQC changelog (parquet) <https://github.com/MultiQC/MultiQC/blob/main/CHANGELOG.md>,
  ColabFold `batch.py` <https://github.com/sokrypton/ColabFold>,
  AlphaFold `confidence.py` <https://github.com/google-deepmind/alphafold>
- GitHub stars via the GitHub API, 2026-10-01.
- WGCNA `labeledHeatmap()`, bio3d `plot.cmap()`, iNEXT `ggiNEXT()`, incidence2, AMR
  `antibiogram()`, imcRtools, NGLVieweR / r3dmol Shiny bindings: CRAN/Bioc sources.
- VizModules base modules and mapping keys: `inst/skills/vizmodules-app/references/module-inventory.md`
  in the VizModules source.
