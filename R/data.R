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
#' @author Jared Andrews
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
#' @author Jared Andrews
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
#' @author Jared Andrews
#' @keywords datasets
"airway_voom"

#' Single-group Kaplan-Meier survival example dataset
#'
#' A simulated survival dataset for a single cohort, matching the summary table
#' format produced by the \code{survival} R package.  Suitable for demonstrating
#' [survivalCurvePlotApp()] without grouping.
#'
#' @format A data frame with 11 rows and 8 columns:
#' \describe{
#'   \item{time}{Time point (arbitrary units, e.g. days).}
#'   \item{n.risk}{Number of subjects still at risk at each time point.}
#'   \item{n.event}{Number of events (e.g. deaths) at each time point.}
#'   \item{survival}{Kaplan-Meier survival probability estimate (0–1 scale).}
#'   \item{std.err}{Standard error of the survival estimate.}
#'   \item{lower}{Lower bound of the 95\% confidence interval (0–1 scale).}
#'   \item{upper}{Upper bound of the 95\% confidence interval (0–1 scale).}
#'   \item{censor}{Censoring indicator: \code{0} = event occurred;
#'     \code{1} = observation censored (patient left study or study ended).
#'     Rows where \code{censor == 1} are displayed as markers on the survival
#'     curve when the Censor Column is selected in the app.}
#' }
#'
#' @source Simulated data inspired by the example in the problem description.
#'   See \code{data-raw/generate_survival_data.R} for the generation script.
#'
#' @examples
#' library(sciVizModules)
#' head(km_survival_single)
#'
#' @author Jacob Martin, Jared Andrews
#' @keywords datasets
"km_survival_single"

#' Two-group Kaplan-Meier survival example dataset
#'
#' A simulated survival dataset containing two groups (low-risk and high-risk),
#' useful for demonstrating grouped Kaplan-Meier curves in
#' [survivalCurvePlotApp()].
#'
#' @format A data frame with 16 rows and 9 columns:
#' \describe{
#'   \item{time}{Time point (months).}
#'   \item{n.risk}{Number of subjects still at risk at each time point.}
#'   \item{n.event}{Number of events at each time point.}
#'   \item{survival}{Kaplan-Meier survival probability estimate (0–1 scale).}
#'   \item{std.err}{Standard error of the survival estimate.}
#'   \item{lower}{Lower bound of the 95\% confidence interval (0–1 scale).}
#'   \item{upper}{Upper bound of the 95\% confidence interval (0–1 scale).}
#'   \item{group}{Group label: \code{"Group 1 (low risk)"} or
#'     \code{"Group 2 (high risk)"}.}
#'   \item{censor}{Censoring indicator: \code{0} = event occurred;
#'     \code{1} = observation censored.
#'     Rows where \code{censor == 1} are displayed as markers on the survival
#'     curve when the Censor Column is selected in the app.}
#' }
#'
#' @source Simulated to illustrate a typical two-arm KM comparison.
#'   See \code{data-raw/generate_survival_data.R} for the generation script.
#'
#' @examples
#' library(sciVizModules)
#' head(km_survival_groups)
#'
#' @author Jacob Martin, Jared Andrews
#' @keywords datasets
"km_survival_groups"