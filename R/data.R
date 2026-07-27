#' Example DESeq2 results from airway dataset
#'
#' A dataset containing differential expression results from comparing treated vs untreated
#' samples in the airway dataset using DESeq2.
#'
#' @format A data frame with 63677 rows and 7 columns:
#' \describe{
#'   \item{baseMean}{Mean of normalized counts for all samples}
#'   \item{log2FoldChange}{Log2 fold change between treated and untreated conditions}
#'   \item{lfcSE}{Standard error of the log2 fold change estimate}
#'   \item{stat}{Wald statistic}
#'   \item{pvalue}{Wald test p-value}
#'   \item{padj}{Benjamini-Hochberg adjusted p-value}
#'   \item{symbol}{Gene symbol}
#'   \item{ensembl}{Ensembl gene ID}
#' }
#'
#' @source Generated from the `airway` Bioconductor package using DESeq2.
#' The contrast compares dexamethasone treatment ("trt") vs untreated ("untrt").
#'
#' @examples
#' library(VizModules)
#' head(airway_deseq2)
#'
#' @author Jacob Martin
#' @keywords datasets
"airway_deseq2"

#' Example edgeR results from airway dataset
#'
#' A dataset containing differential expression results from comparing treated vs untreated
#' samples in the airway dataset using edgeR (quasi-likelihood).
#'
#' @format A data frame with columns:
#' \describe{
#'   \item{logFC}{Log2 fold change between treated and untreated conditions}
#'   \item{logCPM}{Log2 counts per million}
#'   \item{F}{Quasi-likelihood F statistic}
#'   \item{PValue}{Quasi-likelihood F-test p-value}
#'   \item{FDR}{Benjamini-Hochberg adjusted p-value}
#'   \item{ensembl}{Ensembl gene ID}
#'   \item{symbol}{Gene symbol}
#' }
#'
#' @source Generated from the `airway` Bioconductor package using edgeR.
#' The contrast compares dexamethasone treatment ("trt") vs untreated ("untrt").
#'
#' @examples
#' library(VizModules)
#' head(airway_edger)
#'
#' @author Jacob Martin
#' @keywords datasets
"airway_edger"

#' Example limma-voom results from airway dataset
#'
#' A dataset containing differential expression results from comparing treated vs untreated
#' samples in the airway dataset using limma-voom.
#'
#' @format A data frame with columns:
#' \describe{
#'   \item{logFC}{Log2 fold change between treated and untreated conditions}
#'   \item{AveExpr}{Average log2 expression}
#'   \item{t}{Moderated t statistic}
#'   \item{P.Value}{Moderated t-test p-value}
#'   \item{adj.P.Val}{Benjamini-Hochberg adjusted p-value}
#'   \item{B}{Log-odds of differential expression}
#'   \item{ensembl}{Ensembl gene ID}
#'   \item{symbol}{Gene symbol}
#' }
#'
#' @source Generated from the `airway` Bioconductor package using limma.
#' The contrast compares dexamethasone treatment ("trt") vs untreated ("untrt").
#'
#' @examples
#' library(VizModules)
#' head(airway_voom)
#'
#' @author Jacob Martin
#' @keywords datasets
"airway_voom"

#' Example survival dataset (NCCTG lung cancer)
#'
#' A lightly cleaned version of the NCCTG lung cancer dataset from the
#' `survival` package, provided as a ready-to-use example for the
#' [survivalCurve()] module. Each row is one patient with a follow-up time,
#' an event indicator, and a couple of grouping variables.
#'
#' @format A data frame with 228 rows and 5 columns:
#' \describe{
#'   \item{time}{Follow-up time in days}
#'   \item{status}{Event indicator following the [survival::Surv()] convention
#'     (1 = censored, 2 = dead)}
#'   \item{age}{Patient age in years}
#'   \item{sex}{Patient sex ("Male" or "Female")}
#'   \item{ph.ecog}{ECOG performance status, as a labelled factor}
#' }
#'
#' @source Derived from `survival::lung` (Loprinzi et al., North Central
#' Cancer Treatment Group).
#'
#' @examples
#' library(sciVizModules)
#' head(survival_lung)
#'
#' @author Jacob Martin
#' @keywords datasets
"survival_lung"

#' Example single-cell RNA-seq dataset (simulated)
#'
#' A small, simulated [SingleCellExperiment::SingleCellExperiment] provided as a
#' ready-to-use example for the dittoSeq-based modules ([dittoDimPlotServer()],
#' [dittoScatterPlotServer()], [dittoPlotServer()], [dittoBarPlotServer()],
#' [dittoDimHexServer()], [dittoFreqPlotServer()], and
#' [dittoRidgeJitterServer()]).
#'
#' @format A [SingleCellExperiment::SingleCellExperiment] with 40 genes and 240
#' cells containing:
#' \describe{
#'   \item{assays}{`counts` and `logcounts`}
#'   \item{reducedDims}{`PCA`, `TSNE`, and `UMAP` embeddings}
#'   \item{colData}{`clustering`, `celltype`, `condition`, and
#'     `sample` (discrete), plus `nCount` and `percent.mito`
#'     (continuous)}
#' }
#'
#' @source Simulated in `data-raw/generate_example_sce.R`; no real
#' biological data are included.
#'
#' @examples
#' library(sciVizModules)
#' data(example_sce)
#' example_sce
#'
#' @author Jacob Martin
#' @keywords datasets
"example_sce"

#' Example functional enrichment results (simulated)
#'
#' A small, simulated `clusterProfiler`-style GO over-representation table
#' provided as ready-to-use example data for the [enrichmentDotPlotServer()]
#' module. Enrichment terms are tested across two gene clusters, mimicking the
#' output of `clusterProfiler::compareCluster()`.
#'
#' @format A data frame with 14 rows and 10 columns:
#' \describe{
#'   \item{Cluster}{Gene cluster the term was enriched in ("Upregulated" or
#'     "Downregulated"); used for the dot plot x-axis}
#'   \item{ONTOLOGY}{GO ontology ("BP")}
#'   \item{ID}{GO term identifier}
#'   \item{Description}{Human-readable enrichment term; used for the dot plot
#'     y-axis}
#'   \item{GeneRatio}{Fraction of query genes in the term, as a "count/total"
#'     string; parsed to a numeric ratio for dot size}
#'   \item{BgRatio}{Fraction of background genes in the term, as a
#'     "count/total" string}
#'   \item{pvalue}{Over-representation p-value}
#'   \item{p.adjust}{Benjamini-Hochberg adjusted p-value}
#'   \item{qvalue}{q-value}
#'   \item{Count}{Number of query genes in the term}
#' }
#'
#' @source Simulated in `data-raw/generate_example_enrichment.R`; no real
#' biological data are included.
#'
#' @examples
#' library(sciVizModules)
#' data(example_enrichment)
#' head(example_enrichment)
#'
#' @author Jacob Martin
#' @keywords datasets
"example_enrichment"

#' Example Michaelis-Menten enzyme-kinetics observations (simulated)
#'
#' A small, self-contained set of enzyme-kinetics observations (substrate
#' concentration versus reaction velocity) provided as ready-to-use example
#' data for the [michaelisMentenServer()] module and [michaelisMentenPlot()].
#'
#' @format A data frame with 19 rows and 2 columns:
#' \describe{
#'   \item{S}{Substrate concentration (mM)}
#'   \item{v}{Reaction velocity (dE/min)}
#' }
#'
#' @source Simulated in `data-raw/generate_mm_kinetics.R`; no real
#' biological data are included.
#'
#' @seealso [sciVizModules::mm_kinetics_line],
#' [sciVizModules::mm_kinetics_fit]
#'
#' @examples
#' library(sciVizModules)
#' data(mm_kinetics)
#' head(mm_kinetics)
#'
#' @author Jacob Martin
#' @keywords datasets
"mm_kinetics"

#' Fitted Michaelis-Menten curve for the example kinetics data
#'
#' The fitted Michaelis-Menten curve for [mm_kinetics], predicted over a fine
#' grid of substrate concentrations. This is the pre-computed line (`mml`)
#' passed as the `model` argument to [michaelisMentenPlot()].
#'
#' @format A data frame with 100 rows and 2 columns:
#' \describe{
#'   \item{S}{Substrate concentration (mM)}
#'   \item{v}{Predicted reaction velocity (dE/min)}
#' }
#'
#' @source Predicted from [mm_kinetics_fit] in
#' `data-raw/generate_mm_kinetics.R`.
#'
#' @seealso [sciVizModules::mm_kinetics], [sciVizModules::mm_kinetics_fit]
#'
#' @examples
#' library(sciVizModules)
#' data(mm_kinetics_line)
#' head(mm_kinetics_line)
#'
#' @author Jacob Martin
#' @keywords datasets
"mm_kinetics_line"

#' Fitted Michaelis-Menten model for the example kinetics data
#'
#' An [stats::nls()] fit of \eqn{v = V_m S / (K + S)} to [mm_kinetics]. Its
#' coefficients (`K` and `Vm`) provide the Michaelis constant and maximum
#' velocity used for the K / Vmax annotations in the [michaelisMentenServer()]
#' module.
#'
#' @format An object of class `nls`.
#'
#' @source Fitted in `data-raw/generate_mm_kinetics.R`.
#'
#' @seealso [sciVizModules::mm_kinetics], [sciVizModules::mm_kinetics_line]
#'
#' @examples
#' library(sciVizModules)
#' data(mm_kinetics_fit)
#' coef(mm_kinetics_fit)
#'
#' @author Jacob Martin
#' @keywords datasets
"mm_kinetics_fit"

#' Example copy number segmentation results from sesame
#'
#' A self-contained `CNSegment` object generated by [sesame::cnSegmentation()]
#' from sesameData's `EPIC.1.SigDF` example and `EPIC.5.SigDF.normal` reference
#' samples. It carries everything the [cnSegmentPlot()] module needs from a
#' single object: platform `cytoBand` information for centromere placement, a
#' gene-level annotation for labeling, and per-bin gene overlaps for hover text.
#'
#' @format A list of class `"CNSegment"` with elements:
#' \describe{
#'   \item{seg.signals}{A data frame of called segments with `chrom`,
#'     `loc.start`, `loc.end`, and `seg.mean` columns (plus `ID`, `num.mark`,
#'     `pval`, `lcl`, and `ucl`, matching [sesame::cnSegmentation()]'s output)}
#'   \item{bin.coords}{A `GRanges` of hg38 genomic bins with chromosome
#'     `seqinfo`, plus `signal` (per-bin log2 signal ratio) and `genes` (a
#'     `CharacterList` of gene symbols overlapping the bin) metadata columns}
#'   \item{bin.signals}{A named numeric vector of per-bin log2 signal ratios}
#'   \item{genomeInfo}{A list with `seqLength`, `gapInfo`, `cytoBand` (a data
#'     frame with `chrom`, `chromStart`, `chromEnd`, `name`, and `gieStain`
#'     columns), and `genes` (a gene-level `GRanges` with a `gene_name` column)
#'     elements}
#' }
#'
#' @source Generated from `EPIC.1.SigDF`, `EPIC.5.SigDF.normal`, and
#' `genomeInfo.hg38` in the sesameData package by
#' \code{data-raw/generate_example_cn_segment.R}.
#'
#' @examples
#' library(sciVizModules)
#' data(example_cn_segment)
#' cnSegmentPlot(example_cn_segment)
#'
#' @author Jared Andrews
#' @keywords datasets
"example_cn_segment"
#' Example dose-response data (simulated)
#'
#' A small, self-contained dose-response dataset: a serial dilution of doses
#' with triplicate percent-response readings and per-dose mean and standard
#' deviation. Provided as ready-to-use example data for the
#' [doseResponseServer()] module. The response follows a smooth sigmoidal
#' (log-logistic) shape suitable for [drc::drm()] fitting.
#'
#' @format A data frame with 9 rows and 6 columns:
#' \describe{
#'   \item{dose_uM}{Dose / concentration (uM)}
#'   \item{rep1_response_pct}{Percent response, replicate 1}
#'   \item{rep2_response_pct}{Percent response, replicate 2}
#'   \item{rep3_response_pct}{Percent response, replicate 3}
#'   \item{mean_response_pct}{Mean percent response across replicates}
#'   \item{sd_response_pct}{Standard deviation of percent response}
#' }
#'
#' @source Simulated in `data-raw/generate_dose_response.R`; no real
#' biological data are included.
#'
#' @seealso [sciVizModules::doseResponseApp()]
#'
#' @examples
#' library(sciVizModules)
#' data(dose_response)
#' head(dose_response)
#'
#' @author Jacob Martin
#' @keywords datasets
"dose_response"
