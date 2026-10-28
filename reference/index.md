# Package index

## Differential expression

Volcano and MA plots over a differential-expression results table. Both
wrap the VizModules scatter plot module, adding threshold controls and
an auto-generated Up/Down/n.s. grouping.

- [`volcanoPlotInputsUI()`](https://j-andrews7.github.io/sciVizModules/reference/volcanoPlotInputsUI.md)
  : Input UI components for the volcanoPlot module
- [`volcanoPlotOutputUI()`](https://j-andrews7.github.io/sciVizModules/reference/volcanoPlotOutputUI.md)
  : Output UI components for the volcanoPlot module
- [`volcanoPlotServer()`](https://j-andrews7.github.io/sciVizModules/reference/volcanoPlotServer.md)
  : Server logic for volcanoPlot module
- [`volcanoPlotApp()`](https://j-andrews7.github.io/sciVizModules/reference/volcanoPlotApp.md)
  : Create a standalone Shiny app for the volcanoPlot module
- [`maPlotInputsUI()`](https://j-andrews7.github.io/sciVizModules/reference/maPlotInputsUI.md)
  : Input UI components for the maPlot module
- [`maPlotOutputUI()`](https://j-andrews7.github.io/sciVizModules/reference/maPlotOutputUI.md)
  : Output UI components for the maPlot module
- [`maPlotServer()`](https://j-andrews7.github.io/sciVizModules/reference/maPlotServer.md)
  : Server logic for maPlot module
- [`maPlotApp()`](https://j-andrews7.github.io/sciVizModules/reference/maPlotApp.md)
  : Create a standalone Shiny app for the maPlot module

## Bulk expression

Sample-level views of a bulk RNA-seq (or array) experiment held in a
`SummarizedExperiment`: the sample PCA (feeding the PCAtools biplot),
the sample-distance heatmap, and the heatmap of the top differentially
expressed genes. The two heatmaps wrap VizModules’ ComplexHeatmap
module, so they are InteractiveComplexHeatmap widgets rather than plotly
figures.

- [`sample_pca()`](https://j-andrews7.github.io/sciVizModules/reference/sample_pca.md)
  : Principal component analysis of a bulk expression experiment
- [`samplePCAInputsUI()`](https://j-andrews7.github.io/sciVizModules/reference/samplePCAInputsUI.md)
  : Input UI components for the samplePCA module
- [`samplePCAOutputUI()`](https://j-andrews7.github.io/sciVizModules/reference/samplePCAOutputUI.md)
  : Output UI components for the samplePCA module
- [`samplePCAServer()`](https://j-andrews7.github.io/sciVizModules/reference/samplePCAServer.md)
  : Server logic for the samplePCA module
- [`samplePCAApp()`](https://j-andrews7.github.io/sciVizModules/reference/samplePCAApp.md)
  : Create a standalone Shiny app for the samplePCA module
- [`sampleDistanceHeatmapInputsUI()`](https://j-andrews7.github.io/sciVizModules/reference/sampleDistanceHeatmapInputsUI.md)
  : Input UI components for the sampleDistanceHeatmap module
- [`sampleDistanceHeatmapOutputUI()`](https://j-andrews7.github.io/sciVizModules/reference/sampleDistanceHeatmapOutputUI.md)
  : Output UI components for the sampleDistanceHeatmap module
- [`sampleDistanceHeatmapServer()`](https://j-andrews7.github.io/sciVizModules/reference/sampleDistanceHeatmapServer.md)
  : Server logic for the sampleDistanceHeatmap module
- [`sampleDistanceHeatmapApp()`](https://j-andrews7.github.io/sciVizModules/reference/sampleDistanceHeatmapApp.md)
  : Create a standalone Shiny app for the sampleDistanceHeatmap module
- [`deHeatmapInputsUI()`](https://j-andrews7.github.io/sciVizModules/reference/deHeatmapInputsUI.md)
  : Input UI components for the deHeatmap module
- [`deHeatmapOutputUI()`](https://j-andrews7.github.io/sciVizModules/reference/deHeatmapOutputUI.md)
  : Output UI components for the deHeatmap module
- [`deHeatmapServer()`](https://j-andrews7.github.io/sciVizModules/reference/deHeatmapServer.md)
  : Server logic for the deHeatmap module
- [`deHeatmapApp()`](https://j-andrews7.github.io/sciVizModules/reference/deHeatmapApp.md)
  : Create a standalone Shiny app for the deHeatmap module

## Functional enrichment

Dot plot and GO sunburst (“fan”) plot over over-representation or GSEA
results, and the GSEA running enrichment score plot.

- [`enrichmentDotPlotInputsUI()`](https://j-andrews7.github.io/sciVizModules/reference/enrichmentDotPlotInputsUI.md)
  : Input UI components for the enrichmentDotPlot module
- [`enrichmentDotPlotOutputUI()`](https://j-andrews7.github.io/sciVizModules/reference/enrichmentDotPlotOutputUI.md)
  : Output UI components for the enrichmentDotPlot module
- [`enrichmentDotPlotServer()`](https://j-andrews7.github.io/sciVizModules/reference/enrichmentDotPlotServer.md)
  : Server logic for the enrichmentDotPlot module
- [`enrichmentDotPlotApp()`](https://j-andrews7.github.io/sciVizModules/reference/enrichmentDotPlotApp.md)
  : Create a standalone Shiny app for the enrichmentDotPlot module
- [`goFanPlot()`](https://j-andrews7.github.io/sciVizModules/reference/goFanPlot.md)
  : Create an interactive GO enrichment sunburst ("fan") plot
- [`goFanPlotInputsUI()`](https://j-andrews7.github.io/sciVizModules/reference/goFanPlotInputsUI.md)
  : Input UI components for the goFanPlot module
- [`goFanPlotOutputUI()`](https://j-andrews7.github.io/sciVizModules/reference/goFanPlotOutputUI.md)
  : Output UI components for the goFanPlot module
- [`goFanPlotServer()`](https://j-andrews7.github.io/sciVizModules/reference/goFanPlotServer.md)
  : Server logic for the goFanPlot module
- [`goFanPlotApp()`](https://j-andrews7.github.io/sciVizModules/reference/goFanPlotApp.md)
  : Create a standalone Shiny app for the goFanPlot module
- [`gseaEnrichmentPlot()`](https://j-andrews7.github.io/sciVizModules/reference/gseaEnrichmentPlot.md)
  : GSEA enrichment plot
- [`gseaEnrichmentPlotInputsUI()`](https://j-andrews7.github.io/sciVizModules/reference/gseaEnrichmentPlotInputsUI.md)
  : Input UI components for the gseaEnrichmentPlot module
- [`gseaEnrichmentPlotOutputUI()`](https://j-andrews7.github.io/sciVizModules/reference/gseaEnrichmentPlotOutputUI.md)
  : Output UI components for the gseaEnrichmentPlot module
- [`gseaEnrichmentPlotServer()`](https://j-andrews7.github.io/sciVizModules/reference/gseaEnrichmentPlotServer.md)
  : Server logic for the gseaEnrichmentPlot module
- [`gseaEnrichmentPlotApp()`](https://j-andrews7.github.io/sciVizModules/reference/gseaEnrichmentPlotApp.md)
  : Create a standalone Shiny app for the gseaEnrichmentPlot module

## Genetics (GWAS)

Manhattan and QQ plots of GWAS summary statistics. Both wrap the
VizModules scatter plot module; columns are detected from the common
naming styles.

- [`manhattanPlotInputsUI()`](https://j-andrews7.github.io/sciVizModules/reference/manhattanPlotInputsUI.md)
  : Input UI components for the manhattanPlot module
- [`manhattanPlotOutputUI()`](https://j-andrews7.github.io/sciVizModules/reference/manhattanPlotOutputUI.md)
  : Output UI components for the manhattanPlot module
- [`manhattanPlotServer()`](https://j-andrews7.github.io/sciVizModules/reference/manhattanPlotServer.md)
  : Server logic for the manhattanPlot module
- [`manhattanPlotApp()`](https://j-andrews7.github.io/sciVizModules/reference/manhattanPlotApp.md)
  : Create a standalone Shiny app for the manhattanPlot module
- [`gwasQQPlotInputsUI()`](https://j-andrews7.github.io/sciVizModules/reference/gwasQQPlotInputsUI.md)
  : Input UI components for the gwasQQPlot module
- [`gwasQQPlotOutputUI()`](https://j-andrews7.github.io/sciVizModules/reference/gwasQQPlotOutputUI.md)
  : Output UI components for the gwasQQPlot module
- [`gwasQQPlotServer()`](https://j-andrews7.github.io/sciVizModules/reference/gwasQQPlotServer.md)
  : Server logic for the gwasQQPlot module
- [`gwasQQPlotApp()`](https://j-andrews7.github.io/sciVizModules/reference/gwasQQPlotApp.md)
  : Create a standalone Shiny app for the gwasQQPlot module

## Functional genomics screens

Pooled CRISPR screens summarised by MAGeCK: the gene rank plot, and the
reader for MAGeCK gene summaries.

- [`read_mageck()`](https://j-andrews7.github.io/sciVizModules/reference/read_mageck.md)
  : Read a MAGeCK gene summary
- [`crisprScreenRankInputsUI()`](https://j-andrews7.github.io/sciVizModules/reference/crisprScreenRankInputsUI.md)
  : Input UI components for the crisprScreenRank module
- [`crisprScreenRankOutputUI()`](https://j-andrews7.github.io/sciVizModules/reference/crisprScreenRankOutputUI.md)
  : Output UI components for the crisprScreenRank module
- [`crisprScreenRankServer()`](https://j-andrews7.github.io/sciVizModules/reference/crisprScreenRankServer.md)
  : Server logic for the crisprScreenRank module
- [`crisprScreenRankApp()`](https://j-andrews7.github.io/sciVizModules/reference/crisprScreenRankApp.md)
  : Create a standalone Shiny app for the crisprScreenRank module

## Somatic mutations

Cohort views of somatic mutations from a maftools `MAF` object or a data
frame in MAF columns - the oncoplot, the MAF summary dashboard and the
protein lollipop plot, built natively in plotly and checked against
maftools - and the 96-channel substitution spectrum of a mutational
count matrix.

- [`oncoPlot()`](https://j-andrews7.github.io/sciVizModules/reference/oncoPlot.md)
  : Interactive oncoplot of somatic mutations
- [`oncoPlotInputsUI()`](https://j-andrews7.github.io/sciVizModules/reference/oncoPlotInputsUI.md)
  : Input UI components for the oncoPlot module
- [`oncoPlotOutputUI()`](https://j-andrews7.github.io/sciVizModules/reference/oncoPlotOutputUI.md)
  : Output UI components for the oncoPlot module
- [`oncoPlotServer()`](https://j-andrews7.github.io/sciVizModules/reference/oncoPlotServer.md)
  : Server logic for the oncoPlot module
- [`oncoPlotApp()`](https://j-andrews7.github.io/sciVizModules/reference/oncoPlotApp.md)
  : Create a standalone Shiny app for the oncoPlot module
- [`mafSummary()`](https://j-andrews7.github.io/sciVizModules/reference/mafSummary.md)
  : Interactive summary of a MAF
- [`mafSummaryInputsUI()`](https://j-andrews7.github.io/sciVizModules/reference/mafSummaryInputsUI.md)
  : Input UI components for the mafSummary module
- [`mafSummaryOutputUI()`](https://j-andrews7.github.io/sciVizModules/reference/mafSummaryOutputUI.md)
  : Output UI components for the mafSummary module
- [`mafSummaryServer()`](https://j-andrews7.github.io/sciVizModules/reference/mafSummaryServer.md)
  : Server logic for the mafSummary module
- [`mafSummaryApp()`](https://j-andrews7.github.io/sciVizModules/reference/mafSummaryApp.md)
  : Create a standalone Shiny app for the mafSummary module
- [`mutationLollipop()`](https://j-andrews7.github.io/sciVizModules/reference/mutationLollipop.md)
  : Interactive lollipop plot of the mutations in a protein
- [`mutationLollipopInputsUI()`](https://j-andrews7.github.io/sciVizModules/reference/mutationLollipopInputsUI.md)
  : Input UI components for the mutationLollipop module
- [`mutationLollipopOutputUI()`](https://j-andrews7.github.io/sciVizModules/reference/mutationLollipopOutputUI.md)
  : Output UI components for the mutationLollipop module
- [`mutationLollipopServer()`](https://j-andrews7.github.io/sciVizModules/reference/mutationLollipopServer.md)
  : Server logic for the mutationLollipop module
- [`mutationLollipopApp()`](https://j-andrews7.github.io/sciVizModules/reference/mutationLollipopApp.md)
  : Create a standalone Shiny app for the mutationLollipop module
- [`mutationalProfileInputsUI()`](https://j-andrews7.github.io/sciVizModules/reference/mutationalProfileInputsUI.md)
  : Input UI components for the mutationalProfile module
- [`mutationalProfileOutputUI()`](https://j-andrews7.github.io/sciVizModules/reference/mutationalProfileOutputUI.md)
  : Output UI components for the mutationalProfile module
- [`mutationalProfileServer()`](https://j-andrews7.github.io/sciVizModules/reference/mutationalProfileServer.md)
  : Server logic for the mutationalProfile module
- [`mutationalProfileApp()`](https://j-andrews7.github.io/sciVizModules/reference/mutationalProfileApp.md)
  : Create a standalone Shiny app for the mutationalProfile module

## Survival analysis

Kaplan-Meier curves with confidence bands, censor marks and risk table.

- [`survivalCurve()`](https://j-andrews7.github.io/sciVizModules/reference/survivalCurve.md)
  : Create an interactive Kaplan-Meier survival curve
- [`survivalCurveInputsUI()`](https://j-andrews7.github.io/sciVizModules/reference/survivalCurveInputsUI.md)
  : Input UI components for the survivalCurve module
- [`survivalCurveOutputUI()`](https://j-andrews7.github.io/sciVizModules/reference/survivalCurveOutputUI.md)
  : Output UI components for the survivalCurve module
- [`survivalCurveServer()`](https://j-andrews7.github.io/sciVizModules/reference/survivalCurveServer.md)
  : Server logic for survivalCurve module
- [`survivalCurveApp()`](https://j-andrews7.github.io/sciVizModules/reference/survivalCurveApp.md)
  : Create a standalone Shiny app for the survivalCurve module

## Clinical models

Forest plots of hazard ratios, odds ratios or coefficients, fitted from
the raw data inside the module (Cox, logistic or linear regression), and
ROC curves with AUCs and optimal cut-offs for diagnostic markers.

- [`forestPlot()`](https://j-andrews7.github.io/sciVizModules/reference/forestPlot.md)
  : Forest plot of model effect estimates
- [`forestPlotInputsUI()`](https://j-andrews7.github.io/sciVizModules/reference/forestPlotInputsUI.md)
  : Input UI components for the forestPlot module
- [`forestPlotOutputUI()`](https://j-andrews7.github.io/sciVizModules/reference/forestPlotOutputUI.md)
  : Output UI components for the forestPlot module
- [`forestPlotServer()`](https://j-andrews7.github.io/sciVizModules/reference/forestPlotServer.md)
  : Server logic for the forestPlot module
- [`forestPlotApp()`](https://j-andrews7.github.io/sciVizModules/reference/forestPlotApp.md)
  : Create a standalone Shiny app for the forestPlot module
- [`rocCurve()`](https://j-andrews7.github.io/sciVizModules/reference/rocCurve.md)
  : ROC curves
- [`rocCurveInputsUI()`](https://j-andrews7.github.io/sciVizModules/reference/rocCurveInputsUI.md)
  : Input UI components for the rocCurve module
- [`rocCurveOutputUI()`](https://j-andrews7.github.io/sciVizModules/reference/rocCurveOutputUI.md)
  : Output UI components for the rocCurve module
- [`rocCurveServer()`](https://j-andrews7.github.io/sciVizModules/reference/rocCurveServer.md)
  : Server logic for the rocCurve module
- [`rocCurveApp()`](https://j-andrews7.github.io/sciVizModules/reference/rocCurveApp.md)
  : Create a standalone Shiny app for the rocCurve module

## Principal component analysis (PCAtools)

One module per PCAtools view, each taking a PCAtools `pca` object: the
biplot (wrapping the VizModules scatter module, with loading arrows),
the scree, loadings and pairs plots, and the PC-metadata correlation
heatmap.

- [`pcaBiplotInputsUI()`](https://j-andrews7.github.io/sciVizModules/reference/pcaBiplotInputsUI.md)
  : Input UI components for the pcaBiplot module

- [`pcaBiplotOutputUI()`](https://j-andrews7.github.io/sciVizModules/reference/pcaBiplotOutputUI.md)
  : Output UI components for the pcaBiplot module

- [`pcaBiplotServer()`](https://j-andrews7.github.io/sciVizModules/reference/pcaBiplotServer.md)
  : Server logic for the pcaBiplot module

- [`pcaBiplotApp()`](https://j-andrews7.github.io/sciVizModules/reference/pcaBiplotApp.md)
  : Create a standalone Shiny app for the pcaBiplot module

- [`pcaScreePlot()`](https://j-andrews7.github.io/sciVizModules/reference/pcaScreePlot.md)
  :

  Scree plot of a PCAtools `pca` object

- [`pcaScreePlotInputsUI()`](https://j-andrews7.github.io/sciVizModules/reference/pcaScreePlotInputsUI.md)
  : Input UI components for the pcaScreePlot module

- [`pcaScreePlotOutputUI()`](https://j-andrews7.github.io/sciVizModules/reference/pcaScreePlotOutputUI.md)
  : Output UI components for the pcaScreePlot module

- [`pcaScreePlotServer()`](https://j-andrews7.github.io/sciVizModules/reference/pcaScreePlotServer.md)
  : Server logic for the pcaScreePlot module

- [`pcaScreePlotApp()`](https://j-andrews7.github.io/sciVizModules/reference/pcaScreePlotApp.md)
  : Create a standalone Shiny app for the pcaScreePlot module

- [`pcaLoadingsPlot()`](https://j-andrews7.github.io/sciVizModules/reference/pcaLoadingsPlot.md)
  :

  Loadings plot of a PCAtools `pca` object

- [`pcaLoadingsPlotInputsUI()`](https://j-andrews7.github.io/sciVizModules/reference/pcaLoadingsPlotInputsUI.md)
  : Input UI components for the pcaLoadingsPlot module

- [`pcaLoadingsPlotOutputUI()`](https://j-andrews7.github.io/sciVizModules/reference/pcaLoadingsPlotOutputUI.md)
  : Output UI components for the pcaLoadingsPlot module

- [`pcaLoadingsPlotServer()`](https://j-andrews7.github.io/sciVizModules/reference/pcaLoadingsPlotServer.md)
  : Server logic for the pcaLoadingsPlot module

- [`pcaLoadingsPlotApp()`](https://j-andrews7.github.io/sciVizModules/reference/pcaLoadingsPlotApp.md)
  : Create a standalone Shiny app for the pcaLoadingsPlot module

- [`pcaPairsPlot()`](https://j-andrews7.github.io/sciVizModules/reference/pcaPairsPlot.md)
  :

  Pairs plot of a PCAtools `pca` object

- [`pcaPairsPlotInputsUI()`](https://j-andrews7.github.io/sciVizModules/reference/pcaPairsPlotInputsUI.md)
  : Input UI components for the pcaPairsPlot module

- [`pcaPairsPlotOutputUI()`](https://j-andrews7.github.io/sciVizModules/reference/pcaPairsPlotOutputUI.md)
  : Output UI components for the pcaPairsPlot module

- [`pcaPairsPlotServer()`](https://j-andrews7.github.io/sciVizModules/reference/pcaPairsPlotServer.md)
  : Server logic for the pcaPairsPlot module

- [`pcaPairsPlotApp()`](https://j-andrews7.github.io/sciVizModules/reference/pcaPairsPlotApp.md)
  : Create a standalone Shiny app for the pcaPairsPlot module

- [`pcaEigencorPlot()`](https://j-andrews7.github.io/sciVizModules/reference/pcaEigencorPlot.md)
  :

  PC-metadata correlation plot of a PCAtools `pca` object

- [`pcaEigencorPlotInputsUI()`](https://j-andrews7.github.io/sciVizModules/reference/pcaEigencorPlotInputsUI.md)
  : Input UI components for the pcaEigencorPlot module

- [`pcaEigencorPlotOutputUI()`](https://j-andrews7.github.io/sciVizModules/reference/pcaEigencorPlotOutputUI.md)
  : Output UI components for the pcaEigencorPlot module

- [`pcaEigencorPlotServer()`](https://j-andrews7.github.io/sciVizModules/reference/pcaEigencorPlotServer.md)
  : Server logic for the pcaEigencorPlot module

- [`pcaEigencorPlotApp()`](https://j-andrews7.github.io/sciVizModules/reference/pcaEigencorPlotApp.md)
  : Create a standalone Shiny app for the pcaEigencorPlot module

## Structural biology

AlphaFold prediction confidence (per-residue pLDDT and the predicted
aligned error), an interactive 3D structure viewer for PDB / mmCIF
files, and molecular dynamics trajectory metrics from GROMACS `.xvg`
output. `structureViewer` is the one module here that is not a plotly
figure: it is an NGL widget with its own PNG snapshot.

- [`read_alphafold()`](https://j-andrews7.github.io/sciVizModules/reference/read_alphafold.md)
  : Read AlphaFold confidence outputs
- [`alphafoldConfidence()`](https://j-andrews7.github.io/sciVizModules/reference/alphafoldConfidence.md)
  : AlphaFold confidence plot: pLDDT track and predicted aligned error
- [`alphafoldConfidenceInputsUI()`](https://j-andrews7.github.io/sciVizModules/reference/alphafoldConfidenceInputsUI.md)
  : Input UI components for the alphafoldConfidence module
- [`alphafoldConfidenceOutputUI()`](https://j-andrews7.github.io/sciVizModules/reference/alphafoldConfidenceOutputUI.md)
  : Output UI components for the alphafoldConfidence module
- [`alphafoldConfidenceServer()`](https://j-andrews7.github.io/sciVizModules/reference/alphafoldConfidenceServer.md)
  : Server logic for the alphafoldConfidence module
- [`alphafoldConfidenceApp()`](https://j-andrews7.github.io/sciVizModules/reference/alphafoldConfidenceApp.md)
  : Create a standalone Shiny app for the alphafoldConfidence module
- [`read_structure()`](https://j-andrews7.github.io/sciVizModules/reference/read_structure.md)
  : Read a macromolecular structure
- [`structureViewer()`](https://j-andrews7.github.io/sciVizModules/reference/structureViewer.md)
  : Interactive 3D structure viewer
- [`structureViewerInputsUI()`](https://j-andrews7.github.io/sciVizModules/reference/structureViewerInputsUI.md)
  : Input UI components for the structureViewer module
- [`structureViewerOutputUI()`](https://j-andrews7.github.io/sciVizModules/reference/structureViewerOutputUI.md)
  : Output UI components for the structureViewer module
- [`structureViewerServer()`](https://j-andrews7.github.io/sciVizModules/reference/structureViewerServer.md)
  : Server logic for the structureViewer module
- [`structureViewerApp()`](https://j-andrews7.github.io/sciVizModules/reference/structureViewerApp.md)
  : Create a standalone Shiny app for the structureViewer module
- [`read_xvg()`](https://j-andrews7.github.io/sciVizModules/reference/read_xvg.md)
  : Read a GROMACS .xvg file
- [`mdTrajectoryMetrics()`](https://j-andrews7.github.io/sciVizModules/reference/mdTrajectoryMetrics.md)
  : Molecular dynamics trajectory metrics plot
- [`mdTrajectoryMetricsInputsUI()`](https://j-andrews7.github.io/sciVizModules/reference/mdTrajectoryMetricsInputsUI.md)
  : Input UI components for the mdTrajectoryMetrics module
- [`mdTrajectoryMetricsOutputUI()`](https://j-andrews7.github.io/sciVizModules/reference/mdTrajectoryMetricsOutputUI.md)
  : Output UI components for the mdTrajectoryMetrics module
- [`mdTrajectoryMetricsServer()`](https://j-andrews7.github.io/sciVizModules/reference/mdTrajectoryMetricsServer.md)
  : Server logic for the mdTrajectoryMetrics module
- [`mdTrajectoryMetricsApp()`](https://j-andrews7.github.io/sciVizModules/reference/mdTrajectoryMetricsApp.md)
  : Create a standalone Shiny app for the mdTrajectoryMetrics module

## Pharmacology and kinetics

Dose-response curves, Michaelis-Menten enzyme kinetics, and
pharmacokinetic concentration-time profiles with non-compartmental
parameters.

- [`doseResponseInputsUI()`](https://j-andrews7.github.io/sciVizModules/reference/doseResponseInputsUI.md)
  : Input UI components for the dose-response module
- [`doseResponseOutputUI()`](https://j-andrews7.github.io/sciVizModules/reference/doseResponseOutputUI.md)
  : Output UI components for the dose-response module
- [`doseResponseServer()`](https://j-andrews7.github.io/sciVizModules/reference/doseResponseServer.md)
  : Server logic for the dose-response module
- [`doseResponseApp()`](https://j-andrews7.github.io/sciVizModules/reference/doseResponseApp.md)
  : Create a standalone Shiny app for the dose-response module
- [`michaelisMentenPlot()`](https://j-andrews7.github.io/sciVizModules/reference/michaelisMentenPlot.md)
  : Plot a Michaelis-Menten kinetics fit
- [`michaelisMentenInputsUI()`](https://j-andrews7.github.io/sciVizModules/reference/michaelisMentenInputsUI.md)
  : Input UI components for the michaelisMenten module
- [`michaelisMentenOutputUI()`](https://j-andrews7.github.io/sciVizModules/reference/michaelisMentenOutputUI.md)
  : Output UI components for the michaelisMenten module
- [`michaelisMentenServer()`](https://j-andrews7.github.io/sciVizModules/reference/michaelisMentenServer.md)
  : Server logic for the michaelisMenten module
- [`michaelisMentenApp()`](https://j-andrews7.github.io/sciVizModules/reference/michaelisMentenApp.md)
  : Create a standalone Shiny app for the michaelisMenten module
- [`pkConcentrationTime()`](https://j-andrews7.github.io/sciVizModules/reference/pkConcentrationTime.md)
  : Pharmacokinetic concentration-time plot
- [`pkConcentrationTimeInputsUI()`](https://j-andrews7.github.io/sciVizModules/reference/pkConcentrationTimeInputsUI.md)
  : Input UI components for the pkConcentrationTime module
- [`pkConcentrationTimeOutputUI()`](https://j-andrews7.github.io/sciVizModules/reference/pkConcentrationTimeOutputUI.md)
  : Output UI components for the pkConcentrationTime module
- [`pkConcentrationTimeServer()`](https://j-andrews7.github.io/sciVizModules/reference/pkConcentrationTimeServer.md)
  : Server logic for the pkConcentrationTime module
- [`pkConcentrationTimeApp()`](https://j-andrews7.github.io/sciVizModules/reference/pkConcentrationTimeApp.md)
  : Create a standalone Shiny app for the pkConcentrationTime module

## Screening and plate assays

Assay plate heatmaps in physical layout, raw or normalised per plate,
with control wells, Z’-factors and edge-effect margins.

- [`plateHeatmap()`](https://j-andrews7.github.io/sciVizModules/reference/plateHeatmap.md)
  : Assay plate heatmap
- [`plateHeatmapInputsUI()`](https://j-andrews7.github.io/sciVizModules/reference/plateHeatmapInputsUI.md)
  : Input UI components for the plateHeatmap module
- [`plateHeatmapOutputUI()`](https://j-andrews7.github.io/sciVizModules/reference/plateHeatmapOutputUI.md)
  : Output UI components for the plateHeatmap module
- [`plateHeatmapServer()`](https://j-andrews7.github.io/sciVizModules/reference/plateHeatmapServer.md)
  : Server logic for the plateHeatmap module
- [`plateHeatmapApp()`](https://j-andrews7.github.io/sciVizModules/reference/plateHeatmapApp.md)
  : Create a standalone Shiny app for the plateHeatmap module

## Copy number

Stacked genome-wide copy-number segment plots over `CNSegment` objects,
as returned by
[`sesame::cnSegmentation()`](https://rdrr.io/pkg/sesame/man/cnSegmentation.html).

- [`cnSegmentPlot()`](https://j-andrews7.github.io/sciVizModules/reference/cnSegmentPlot.md)
  : Plot DNA methylation array-based copy number segmentation
- [`cnSegmentPlotInputsUI()`](https://j-andrews7.github.io/sciVizModules/reference/cnSegmentPlotInputsUI.md)
  : Input UI components for the cnSegmentPlot module
- [`cnSegmentPlotOutputUI()`](https://j-andrews7.github.io/sciVizModules/reference/cnSegmentPlotOutputUI.md)
  : Output UI components for the cnSegmentPlot module
- [`cnSegmentPlotServer()`](https://j-andrews7.github.io/sciVizModules/reference/cnSegmentPlotServer.md)
  : Server logic for the cnSegmentPlot module
- [`cnSegmentPlotApp()`](https://j-andrews7.github.io/sciVizModules/reference/cnSegmentPlotApp.md)
  : Create a standalone Shiny app for the cnSegmentPlot module

## Single-cell and RNA-seq (dittoSeq)

Wrappers around the dittoSeq plotting functions. Each takes a
`SingleCellExperiment`, `Seurat` or `SummarizedExperiment` object rather
than a data frame, and so takes `object_list` in its `*App()`.
`dittoHeatmap` wraps VizModules’ ComplexHeatmap module, so it is an
InteractiveComplexHeatmap widget rather than a plotly figure.

- [`dittoDotPlotInputsUI()`](https://j-andrews7.github.io/sciVizModules/reference/dittoDotPlotInputsUI.md)
  : Input UI components for the dittoDotPlot module
- [`dittoDotPlotOutputUI()`](https://j-andrews7.github.io/sciVizModules/reference/dittoDotPlotOutputUI.md)
  : Output UI components for the dittoDotPlot module
- [`dittoDotPlotServer()`](https://j-andrews7.github.io/sciVizModules/reference/dittoDotPlotServer.md)
  : Server logic for the dittoDotPlot module
- [`dittoDotPlotApp()`](https://j-andrews7.github.io/sciVizModules/reference/dittoDotPlotApp.md)
  : Create a standalone Shiny app for the dittoDotPlot module
- [`dittoHeatmapInputsUI()`](https://j-andrews7.github.io/sciVizModules/reference/dittoHeatmapInputsUI.md)
  : Input UI components for the dittoHeatmap module
- [`dittoHeatmapOutputUI()`](https://j-andrews7.github.io/sciVizModules/reference/dittoHeatmapOutputUI.md)
  : Output UI components for the dittoHeatmap module
- [`dittoHeatmapServer()`](https://j-andrews7.github.io/sciVizModules/reference/dittoHeatmapServer.md)
  : Server logic for the dittoHeatmap module
- [`dittoHeatmapApp()`](https://j-andrews7.github.io/sciVizModules/reference/dittoHeatmapApp.md)
  : Create a standalone Shiny app for the dittoHeatmap module
- [`dittoDimPlotInputsUI()`](https://j-andrews7.github.io/sciVizModules/reference/dittoDimPlotInputsUI.md)
  : Input UI components for the dittoDimPlot module
- [`dittoDimPlotOutputUI()`](https://j-andrews7.github.io/sciVizModules/reference/dittoDimPlotOutputUI.md)
  : Output UI components for the dittoDimPlot module
- [`dittoDimPlotServer()`](https://j-andrews7.github.io/sciVizModules/reference/dittoDimPlotServer.md)
  : Server logic for the dittoDimPlot module
- [`dittoDimPlotApp()`](https://j-andrews7.github.io/sciVizModules/reference/dittoDimPlotApp.md)
  : Create a standalone Shiny app for the dittoDimPlot module
- [`dittoDimHexInputsUI()`](https://j-andrews7.github.io/sciVizModules/reference/dittoDimHexInputsUI.md)
  : Input UI components for the dittoDimHex module
- [`dittoDimHexOutputUI()`](https://j-andrews7.github.io/sciVizModules/reference/dittoDimHexOutputUI.md)
  : Output UI components for the dittoDimHex module
- [`dittoDimHexServer()`](https://j-andrews7.github.io/sciVizModules/reference/dittoDimHexServer.md)
  : Server logic for the dittoDimHex module
- [`dittoDimHexApp()`](https://j-andrews7.github.io/sciVizModules/reference/dittoDimHexApp.md)
  : Create a standalone Shiny app for the dittoDimHex module
- [`dittoScatterPlotInputsUI()`](https://j-andrews7.github.io/sciVizModules/reference/dittoScatterPlotInputsUI.md)
  : Input UI components for the dittoScatterPlot module
- [`dittoScatterPlotOutputUI()`](https://j-andrews7.github.io/sciVizModules/reference/dittoScatterPlotOutputUI.md)
  : Output UI components for the dittoScatterPlot module
- [`dittoScatterPlotServer()`](https://j-andrews7.github.io/sciVizModules/reference/dittoScatterPlotServer.md)
  : Server logic for the dittoScatterPlot module
- [`dittoScatterPlotApp()`](https://j-andrews7.github.io/sciVizModules/reference/dittoScatterPlotApp.md)
  : Create a standalone Shiny app for the dittoScatterPlot module
- [`dittoPlotInputsUI()`](https://j-andrews7.github.io/sciVizModules/reference/dittoPlotInputsUI.md)
  : Input UI components for the dittoPlot module
- [`dittoPlotOutputUI()`](https://j-andrews7.github.io/sciVizModules/reference/dittoPlotOutputUI.md)
  : Output UI components for the dittoPlot module
- [`dittoPlotServer()`](https://j-andrews7.github.io/sciVizModules/reference/dittoPlotServer.md)
  : Server logic for the dittoPlot module
- [`dittoPlotApp()`](https://j-andrews7.github.io/sciVizModules/reference/dittoPlotApp.md)
  : Create a standalone Shiny app for the dittoPlot module
- [`dittoRidgeJitterInputsUI()`](https://j-andrews7.github.io/sciVizModules/reference/dittoRidgeJitterInputsUI.md)
  : Input UI components for the dittoRidgeJitter module
- [`dittoRidgeJitterOutputUI()`](https://j-andrews7.github.io/sciVizModules/reference/dittoRidgeJitterOutputUI.md)
  : Output UI components for the dittoRidgeJitter module
- [`dittoRidgeJitterServer()`](https://j-andrews7.github.io/sciVizModules/reference/dittoRidgeJitterServer.md)
  : Server logic for the dittoRidgeJitter module
- [`dittoRidgeJitterApp()`](https://j-andrews7.github.io/sciVizModules/reference/dittoRidgeJitterApp.md)
  : Create a standalone Shiny app for the dittoRidgeJitter module
- [`dittoBarPlotInputsUI()`](https://j-andrews7.github.io/sciVizModules/reference/dittoBarPlotInputsUI.md)
  : Input UI components for the dittoBarPlot module
- [`dittoBarPlotOutputUI()`](https://j-andrews7.github.io/sciVizModules/reference/dittoBarPlotOutputUI.md)
  : Output UI components for the dittoBarPlot module
- [`dittoBarPlotServer()`](https://j-andrews7.github.io/sciVizModules/reference/dittoBarPlotServer.md)
  : Server logic for the dittoBarPlot module
- [`dittoBarPlotApp()`](https://j-andrews7.github.io/sciVizModules/reference/dittoBarPlotApp.md)
  : Create a standalone Shiny app for the dittoBarPlot module
- [`dittoFreqPlotInputsUI()`](https://j-andrews7.github.io/sciVizModules/reference/dittoFreqPlotInputsUI.md)
  : Input UI components for the dittoFreqPlot module
- [`dittoFreqPlotOutputUI()`](https://j-andrews7.github.io/sciVizModules/reference/dittoFreqPlotOutputUI.md)
  : Output UI components for the dittoFreqPlot module
- [`dittoFreqPlotServer()`](https://j-andrews7.github.io/sciVizModules/reference/dittoFreqPlotServer.md)
  : Server logic for the dittoFreqPlot module
- [`dittoFreqPlotApp()`](https://j-andrews7.github.io/sciVizModules/reference/dittoFreqPlotApp.md)
  : Create a standalone Shiny app for the dittoFreqPlot module

## Module Gallery & Figure Builder

Every module in one app, each on example data with its main features
switched on, and the VizModules Figure Builder for arranging several of
these modules into one multi-panel figure.

- [`sciModuleGalleryApp()`](https://j-andrews7.github.io/sciVizModules/reference/sciModuleGalleryApp.md)
  : Launch the sciVizModules module gallery
- [`sci_figure_builder_registry()`](https://j-andrews7.github.io/sciVizModules/reference/sci_figure_builder_registry.md)
  : Module registry for the VizModules Figure Builder
- [`sciFigureBuilderApp()`](https://j-andrews7.github.io/sciVizModules/reference/sciFigureBuilderApp.md)
  : Figure Builder app seeded with the sciVizModules modules

## Example data

Bundled datasets used by the example apps, the vignette and the tests.
This package sets no `LazyData`, so load them with
[`data()`](https://rdrr.io/r/utils/data.html).

- [`airway_deseq2`](https://j-andrews7.github.io/sciVizModules/reference/airway_deseq2.md)
  : Example DESeq2 results from airway dataset

- [`airway_edger`](https://j-andrews7.github.io/sciVizModules/reference/airway_edger.md)
  : Example edgeR results from airway dataset

- [`airway_voom`](https://j-andrews7.github.io/sciVizModules/reference/airway_voom.md)
  : Example limma-voom results from airway dataset

- [`dose_response`](https://j-andrews7.github.io/sciVizModules/reference/dose_response.md)
  : Example dose-response data (simulated)

- [`example_biomarkers`](https://j-andrews7.github.io/sciVizModules/reference/example_biomarkers.md)
  : Example diagnostic biomarker data (simulated)

- [`example_cn_segment`](https://j-andrews7.github.io/sciVizModules/reference/example_cn_segment.md)
  : Example copy number segmentation results from sesame

- [`example_enrichment`](https://j-andrews7.github.io/sciVizModules/reference/example_enrichment.md)
  : Example functional enrichment results (simulated)

- [`example_gsea`](https://j-andrews7.github.io/sciVizModules/reference/example_gsea.md)
  : Example GSEA input (fgsea example data)

- [`example_gwas`](https://j-andrews7.github.io/sciVizModules/reference/example_gwas.md)
  : Example GWAS summary statistics (simulated)

- [`example_pca`](https://j-andrews7.github.io/sciVizModules/reference/example_pca.md)
  :

  Example PCAtools `pca` object (airway RNA-seq)

- [`example_plate`](https://j-andrews7.github.io/sciVizModules/reference/example_plate.md)
  : Example assay plates

- [`example_sbs96`](https://j-andrews7.github.io/sciVizModules/reference/example_sbs96.md)
  : Example single-base-substitution spectra (simulated)

- [`example_sce`](https://j-andrews7.github.io/sciVizModules/reference/example_sce.md)
  : Example single-cell RNA-seq dataset (simulated)

- [`mm_kinetics`](https://j-andrews7.github.io/sciVizModules/reference/mm_kinetics.md)
  : Example Michaelis-Menten enzyme-kinetics observations (simulated)

- [`mm_kinetics_line`](https://j-andrews7.github.io/sciVizModules/reference/mm_kinetics_line.md)
  : Fitted Michaelis-Menten curve for the example kinetics data

- [`mm_kinetics_fit`](https://j-andrews7.github.io/sciVizModules/reference/mm_kinetics_fit.md)
  : Fitted Michaelis-Menten model for the example kinetics data

- [`survival_lung`](https://j-andrews7.github.io/sciVizModules/reference/survival_lung.md)
  : Example survival dataset (NCCTG lung cancer)
