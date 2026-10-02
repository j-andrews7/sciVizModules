# sciVizModules 0.99.0

* Submitted to Bioconductor.

## New modules

* `forestPlot`: forest plots of hazard ratios (Cox), odds ratios (logistic) or coefficients (linear regression), fitted from the raw data inside the module, with univariable or multivariable models and a reference row per factor level. The estimates table is in the source-data download.
* The PCAtools family, one module per PCAtools view, each taking a PCAtools `pca` object: `pcaBiplot` (wraps the VizModules scatter module and adds % variance axis titles and loading arrows through its new `fig.fn` hook), `pcaScreePlot`, `pcaLoadingsPlot`, `pcaPairsPlot` and `pcaEigencorPlot`. A new `example_pca` dataset (airway RNA-seq) backs their apps.
* `alphafoldConfidence`: per-residue pLDDT over the AlphaFold DB confidence bands, above the predicted aligned error heatmap, with chain boundaries for multimers. `read_alphafold()` reads AlphaFold DB and ColabFold output, or the pLDDT in a model's PDB/mmCIF B-factors. The AlphaFold DB prediction for p53 is bundled as an example (CC-BY 4.0).

* `manhattanPlot` and `gwasQQPlot`: GWAS summary statistics as a Manhattan plot (chromosome tick labels, genome-wide and suggestive lines) and a QQ plot (confidence band, lambda GC), wrapping the VizModules scatter module through its `fig.fn` hook. Columns are detected from the common naming styles, and large files are thinned while keeping every significant variant. A simulated `example_gwas` backs their apps.
* `gseaEnrichmentPlot`: the GSEA running enrichment score of one or more gene sets, with hit ticks and the ranked statistic, from fgsea output or a clusterProfiler `gseaResult`. The running score is computed in the package and matches fgsea's. `example_gsea` is built from fgsea's example data.
* `crisprScreenRank` and `read_mageck()`: the gene rank plot of a pooled CRISPR screen from a MAGeCK RRA gene summary, with FDR hits coloured and the top genes labelled. `read_mageck()` also reads `mageck mle` summaries. A simulated MAGeCK gene summary is bundled as the example.

* `structureViewer` and `read_structure()`: an interactive 3D viewer for PDB / mmCIF structures, built on NGLVieweR, coloured by AlphaFold pLDDT band, B-factor, chain, residue index, secondary structure or hydrophobicity, with residues highlighted by number. Style changes are applied in place without resetting the camera. It is the package's one non-plotly module, with its own PNG snapshot. The AlphaFold DB model of p53 is bundled (CC-BY 4.0).
* `mdTrajectoryMetrics` and `read_xvg()`: molecular dynamics metrics (RMSD, radius of gyration, RMSF, ...) from GROMACS `.xvg` files, one line per replica, with running-mean smoothing, unit conversion and a panel per metric. Simulated example files are bundled.
* `rocCurve`: ROC curves for one or more predictors of a binary outcome, with AUC (and a DeLong CI when pROC is installed) and the Youden cut-off. The curves and AUCs are computed in the package and match pROC's. A simulated `example_biomarkers` backs its app.
* `pkConcentrationTime`: pharmacokinetic concentration-time profiles per subject or as group means with SD, linear or log, with terminal elimination fits. Each subject's non-compartmental parameters are computed in the package and match PKNCA's; they are in the source-data download.
* `plateHeatmap`: assay plates in their physical layout (6 to 1536 wells), raw or normalised per plate (percent of control, percent inhibition, z, robust z, B-score), with control wells outlined, the Z'-factor in each plate's title and row/column means for spotting edge effects. A simulated two-plate screen, `example_plate`, backs its app.

## Changes

* Requires VizModules (>= 0.6.0), and uses its newly exported helpers in place of local copies (`default_group_colors()`, `toggle_facet_title_inputs()`, `blank_to_null()`, `nz_value()`, `require_data_frame()`).
* The Reset button of the dittoSeq modules and `survivalCurve` now restores the group colours too.
* Jittered points (`dittoPlot`, `dittoFreqPlot`, `dittoRidgeJitter`, `michaelisMenten`) keep their positions when the plot is rebuilt.
* `survivalCurve` and `goFanPlot` accept data that is coercible to a data frame, and wait quietly while their data reactive is `NULL`.
