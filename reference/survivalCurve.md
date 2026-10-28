# Create an interactive Kaplan-Meier survival curve

Fits a Kaplan-Meier survival curve with
[`survival::survfit()`](https://rdrr.io/pkg/survival/man/survfit.html)
and draws it as an interactive `plotly` figure. The curves and their
confidence bands are drawn by
[`VizModules::linePlot()`](https://j-andrews7.github.io/VizModules/reference/linePlot.html)
from the curve's step coordinates, so the band takes its line's colour,
sits underneath it and toggles with it from the legend.

## Usage

``` r
survivalCurve(
  data,
  time,
  status,
  group.by = NULL,
  conf.int = TRUE,
  conf.level = 0.95,
  conf.type = c("log", "log-log", "plain"),
  conf.int.opacity = 0.25,
  pval = TRUE,
  risk.table = FALSE,
  censor = TRUE,
  surv.median.line = "none",
  fun = NULL,
  palette.selection = NULL,
  line.size = 2,
  break.time.by = NULL,
  legend.title = NULL,
  pairwise = FALSE,
  pairs = NULL,
  p.adjust.method = "holm"
)
```

## Arguments

- data:

  A data frame containing at least the `time` and `status` columns.

- time:

  The name of the numeric follow-up time column.

- status:

  The name of the event/status indicator column.

- group.by:

  Optional name of a categorical column to stratify the curves by. When
  `NULL` or `""` a single overall survival curve (named "All") is drawn.

- conf.int:

  Logical; draw a confidence band around each curve (default `TRUE`).

- conf.level:

  Confidence level of the band, between 0 and 1 (default 0.95), passed
  to
  [`survival::survfit()`](https://rdrr.io/pkg/survival/man/survfit.html)
  as its `conf.int`.

- conf.type:

  How the band is computed, one of `"log"` (the
  [`survival::survfit()`](https://rdrr.io/pkg/survival/man/survfit.html)
  default), `"log-log"` or `"plain"`.

- conf.int.opacity:

  Fill opacity of the band, between 0 and 1 (default 0.25).

- pval:

  Logical; display the log-rank test p-value. Only applied when
  `group.by` defines more than one group (default `TRUE`).

- risk.table:

  Logical; append a "number at risk" table beneath the curve (default
  `FALSE`). The table has no gridlines; its time axis zooms with the
  curve's.

- censor:

  Logical; draw censoring marks (default `TRUE`).

- surv.median.line:

  Character; draw median survival reference lines. One of `"none"`,
  `"hv"`, `"h"`, or `"v"` (default `"none"`). Drawn only for the
  survival probability and percentage curves.

- fun:

  Optional transformation of the survival curve. One of `NULL` or
  `"survival"` (survival probability), `"pct"` (survival percentage),
  `"event"` (cumulative events, `1 - S`), or `"cumhaz"` (cumulative
  hazard, `-log(S)`). The band is transformed with the curve.

- palette.selection:

  Optional vector of colors for the strata, named by stratum level (an
  unnamed vector is used in level order).

- line.size:

  Numeric width of the survival curves in pixels (default `2`).

- break.time.by:

  Optional numeric spacing between x-axis tick marks, which also sets
  the times the risk table counts at.

- legend.title:

  Legend title. Defaults to `group.by` when stratified.

- pairwise:

  Logical; also test each pair of groups (default `FALSE`). Only applied
  when `group.by` defines three or more groups; with two, the pairwise
  test is the global one. See Details for how to read the results.

- pairs:

  Optional list of length-2 character vectors naming the pairs to test,
  e.g. `list(c("Asymptomatic", "Symptomatic"))`, as for
  [`VizModules::compute_pairwise_stats()`](https://j-andrews7.github.io/VizModules/reference/compute_pairwise_stats.html).
  `NULL` (the default) tests every pair. The p-values are adjusted
  across the pairs tested.

- p.adjust.method:

  A [`stats::p.adjust()`](https://rdrr.io/r/stats/p.adjust.html) method
  for the pairwise p-values (default `"holm"`).

## Value

A [`plotly::plot_ly()`](https://rdrr.io/pkg/plotly/man/plot_ly.html)
object containing the interactive survival curve, with a per-stratum
summary (subjects, events, median survival and its confidence interval,
and the log-rank test) as attribute `"table"`. With `pairwise`,
attribute `"pairwise"` holds a row per comparison: `group1`, `group2`,
their subjects (`n1`, `n2`) and events (`events1`, `events2`), the
log-rank `chisq` and `p.value`, the adjusted `p.adj` and its
`p.adjust.method`, and the hazard ratio of `group2` relative to `group1`
(`hr`) with its 95% confidence interval (`hr.lower`, `hr.upper`), `NA`
when a group has no events or the model has no finite estimate.

## Details

The input `data` should be in the "tidy" survival format: one row per
subject with a numeric follow-up `time` column and a `status` (event)
indicator. The status column may be numeric (`0`/`1` where `1` = event,
or `1`/`2` where `2` = event, following the
[`survival::Surv()`](https://rdrr.io/pkg/survival/man/Surv.html)
conventions), logical (`TRUE` = event), or a two-level factor/character
where the level containing "dead"/"death"/"event"/"yes"/"true"/"1" is
treated as the event.

When `group.by` is supplied the curve is stratified by that column and
the log-rank test p-value (from
[`survival::survdiff()`](https://rdrr.io/pkg/survival/man/survdiff.html))
can be shown via `pval`.

**Comparing three or more groups.** The log-rank test above is a global
test: it asks whether survival differs anywhere among the groups, not
which groups differ. With `pairwise = TRUE` and three or more groups,
each pair is also tested on its own subjects (a log-rank test of the two
groups, as survminer's `pairwise_survdiff()` computes), and the results
are listed on the plot and returned as attribute `"pairwise"`. To read
them:

- The p-values are adjusted for the number of comparisons made
  (`p.adjust.method`, default Holm, which keeps the chance of any false
  positive among them at the nominal level; `"BH"` controls the false
  discovery rate instead and suits screening many groups; `"none"`
  overstates significance). Testing only the comparisons that matter
  (`pairs`, each group against a control, say) costs less power. The
  adjustment covers only the comparisons in this call: picking them
  after looking at the curves, or regrouping the data until something is
  significant, is not accounted for.

- A p-value does not say how large a difference is. Each pair also gets
  the hazard ratio (`hr`) of `group2` relative to `group1`, from a Cox
  model of the pair, with its 95% confidence interval: above 1, `group2`
  has the higher hazard (shorter survival). The interval is not adjusted
  for multiplicity, and being a Wald interval it can disagree slightly
  with the log-rank p-value near the significance cut-off.

- The log-rank test is most sensitive when one group's hazard is a
  constant multiple of the other's (proportional hazards). Curves that
  cross can hide a real difference, and the hazard ratio then averages
  over opposite effects, so read the tests against the curves.

- Groups with few subjects or events give unstable results; in
  `survival_lung`, `ph.ecog`'s "In bed \>50%" group is a single subject,
  yet its comparisons come out "significant". Check `n1`, `n2`,
  `events1` and `events2`, and drop or merge sparse groups before
  testing.

- The tests ignore any order among the groups (stage, dose), for which a
  trend test is more powerful, and they are unadjusted for other
  covariates: see
  [`forestPlot()`](https://j-andrews7.github.io/sciVizModules/reference/forestPlot.md)
  for a Cox model with covariates.

The figure is built natively in plotly rather than converted from a
ggplot:
[`plotly::ggplotly()`](https://rdrr.io/pkg/plotly/man/ggplotly.html)
cannot draw the stepped confidence band survminer uses.

## See also

[`survival::survfit()`](https://rdrr.io/pkg/survival/man/survfit.html),
[`VizModules::linePlot()`](https://j-andrews7.github.io/VizModules/reference/linePlot.html),
[`survivalCurveInputsUI()`](https://j-andrews7.github.io/sciVizModules/reference/survivalCurveInputsUI.md),
[`survivalCurveServer()`](https://j-andrews7.github.io/sciVizModules/reference/survivalCurveServer.md),
[`survivalCurveApp()`](https://j-andrews7.github.io/sciVizModules/reference/survivalCurveApp.md)

## Author

Jacob Martin, Jared Andrews

## Examples

``` r
library(sciVizModules)
data(survival_lung)
fig <- survivalCurve(survival_lung,
    time = "time", status = "status", group.by = "sex"
)
if (interactive()) fig

# Cumulative events with a number-at-risk table.
fig2 <- survivalCurve(survival_lung,
    time = "time", status = "status", group.by = "sex",
    fun = "event", risk.table = TRUE
)

# Four performance-status groups, each pair compared.
fig3 <- survivalCurve(survival_lung,
    time = "time", status = "status", group.by = "ph.ecog", pairwise = TRUE
)
attr(fig3, "pairwise")
#>         group1      group2  n1  n2 events1 events2     test     chisq
#> 1 Asymptomatic Symptomatic  63 113      37      82 log-rank  3.456831
#> 2 Asymptomatic In bed <50%  63  50      37      44 log-rank 16.682328
#> 3 Asymptomatic In bed >50%  63   1      37       1 log-rank  5.779873
#> 4  Symptomatic In bed <50% 113  50      82      44 log-rank  8.433446
#> 5  Symptomatic In bed >50% 113   1      82       1 log-rank  5.333335
#> 6  In bed <50% In bed >50%  50   1      44       1 log-rank  1.242310
#>        p.value        p.adj p.adjust.method       hr  hr.lower  hr.upper
#> 1 6.299095e-02 0.1259818981            holm 1.443870 0.9781363  2.131361
#> 2 4.419074e-05 0.0002651444            holm 2.453994 1.5723268  3.830049
#> 3 1.621072e-02 0.0648428617            holm 8.488960 1.0442578 69.008280
#> 4 3.683815e-03 0.0184190743            holm 1.713596 1.1862416  2.475389
#> 5 2.092132e-02 0.0648428617            holm 7.559676 0.9939859 57.494471
#> 6 2.650263e-01 0.2650263152            holm 2.998818 0.3939819 22.825694
```
