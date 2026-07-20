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
#' @source Generated from the \code{airway} Bioconductor package using DESeq2.
#' The contrast compares dexamethasone treatment ("trt") vs untreated ("untrt").
#'
#' @examples
#' library(VizModules)
#' head(airway_deseq2)
#'
#' @author Jacob Martin, Jared Andrews
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
#' @source Generated from the \code{airway} Bioconductor package using edgeR.
#' The contrast compares dexamethasone treatment ("trt") vs untreated ("untrt").
#'
#' @examples
#' library(VizModules)
#' head(airway_edger)
#'
#' @author Jacob Martin, Jared Andrews
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
#' @source Generated from the \code{airway} Bioconductor package using limma.
#' The contrast compares dexamethasone treatment ("trt") vs untreated ("untrt").
#'
#' @examples
#' library(VizModules)
#' head(airway_voom)
#'
#' @author Jacob Martin, Jared Andrews
#' @keywords datasets
"airway_voom"

#' Example survival dataset (NCCTG lung cancer)
#'
#' A lightly cleaned version of the NCCTG lung cancer dataset from the
#' \code{survival} package, provided as a ready-to-use example for the
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
#' @source Derived from \code{survival::lung} (Loprinzi et al., North Central
#' Cancer Treatment Group).
#'
#' @examples
#' library(sciVizModules)
#' head(survival_lung)
#'
#' @author Jacob Martin, Jared Andrews
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
#'   \item{assays}{\code{counts} and \code{logcounts}}
#'   \item{reducedDims}{\code{PCA}, \code{TSNE}, and \code{UMAP} embeddings}
#'   \item{colData}{\code{clustering}, \code{celltype}, \code{condition}, and
#'     \code{sample} (discrete), plus \code{nCount} and \code{percent.mito}
#'     (continuous)}
#' }
#'
#' @source Simulated in \code{data-raw/generate_example_sce.R}; no real
#' biological data are included.
#'
#' @examples
#' library(sciVizModules)
#' data(example_sce)
#' example_sce
#'
#' @author Jacob Martin, Jared Andrews
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
#' @source Simulated in \code{data-raw/generate_example_enrichment.R}; no real
#' biological data are included.
#'
#' @examples
#' library(sciVizModules)
#' data(example_enrichment)
#' head(example_enrichment)
#'
#' @author Jacob Martin, Jared Andrews
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
#' @source Simulated in \code{data-raw/generate_mm_kinetics.R}; no real
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
#' \code{data-raw/generate_mm_kinetics.R}.
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
#' @format An object of class \code{nls}.
#'
#' @source Fitted in \code{data-raw/generate_mm_kinetics.R}.
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