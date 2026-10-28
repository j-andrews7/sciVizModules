# The conditions of a MAGeCK MLE gene summary

The keys are shared by both summaries, so `defaults` and Reset do not
depend on which one is loaded; only what they plot differs.

Every statistic is signed by the direction of its effect, negative for
depletion and positive for enrichment, so depleted and enriched genes
share one plot: the most depleted gene ranks first and the most enriched
last. Genes are ranked by the statistic on the y-axis, so the curve
rises steadily.

## Usage

``` r
.mageck_conditions(df)

.crispr_metric_labels(type = "rra")

.crispr_prepare(df, metric = "lfc", fdr.threshold = 0.05, condition = NULL)
```

## Arguments

- df:

  A MAGeCK RRA or MLE gene summary, raw or tidied.

- type:

  `"rra"` or `"mle"`.

- metric:

  `"lfc"` (log2 fold change, or beta for MLE), `"score"` (signed -log10
  RRA score, or the z-score for MLE) or `"fdr"` (signed -log10 FDR).

- fdr.threshold:

  FDR below which a gene is a hit.

- condition:

  For an MLE summary, the condition to plot. Defaults to the first;
  ignored for RRA.

## Value

The conditions (the `<condition>` of each `<condition>.beta` column), or
`character(0)` for an RRA summary.

A named character vector, labels as names.

The tidy table with `screen.rank`, `screen.metric`, `screen.lfc` (beta
for MLE), `screen.fdr` (the FDR behind the gene's call) and
`screen.group` ("Depleted" / "Enriched" / "n.s.") added, sorted by rank.
The `"mageck_type"` attribute is kept, and an MLE table records the
plotted condition in `"mageck_condition"`.

## Details

An RRA summary tests each gene for depletion and for enrichment. Each
gene takes the side with the smaller RRA score, and its score and FDR
are that side's, negated for depletion. A hit is a gene whose FDR on
that side is below `fdr.threshold`. The log2 fold change needs no sign.

An MLE summary is plotted for one condition. Its beta and z-score are
signed already. Its FDR is two-sided, so it takes the sign of the beta,
and a hit is "Depleted" or "Enriched" by that sign.

## Author

Jared Andrews
