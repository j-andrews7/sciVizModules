# Forest plot of model effect estimates

Fits a Cox proportional hazards, logistic, or linear regression model to
`data` and draws each covariate's effect estimate with its confidence
interval as an interactive forest plot. Hazard and odds ratios are drawn
on a log axis with a reference line at 1; linear coefficients on a
linear axis with a reference line at 0.

## Usage

``` r
forestPlot(
  data,
  model = c("cox", "logistic", "linear"),
  covariates,
  time = NULL,
  status = NULL,
  outcome = NULL,
  multivariable = TRUE,
  conf.level = 0.95,
  show.reference = TRUE,
  show.table = TRUE,
  sort.by = c("input", "estimate"),
  digits = 2,
  point.color = "#000000",
  point.size = 10,
  ci.color = "#000000",
  ci.width = 2,
  main = NULL
)
```

## Arguments

- data:

  A data frame.

- model:

  One of `"cox"`, `"logistic"` or `"linear"`.

- covariates:

  Character vector of covariate column names.

- time, status:

  For `model = "cox"`, the follow-up time column and the event column.
  The event column may be 0/1 (1 = event), 1/2 (2 = event, the
  [`survival::Surv()`](https://rdrr.io/pkg/survival/man/Surv.html)
  convention), logical, or a factor/character with an event label such
  as `"dead"`.

- outcome:

  For `"logistic"`, a binary outcome column (0/1, logical, or a
  two-level factor/character whose second level is the event); for
  `"linear"`, a numeric outcome column.

- multivariable:

  Logical; fit all covariates in one model (`TRUE`) or each on its own
  (`FALSE`).

- conf.level:

  Confidence level for the intervals.

- show.reference:

  Logical; include a row for each factor's reference level.

- show.table:

  Logical; print the estimate, interval and p-value beside each row.

- sort.by:

  `"input"` keeps the covariate order given; `"estimate"` sorts the rows
  by effect size.

- digits:

  Number of decimal places in the printed estimates.

- point.color, ci.color:

  Colours of the estimate markers and the interval lines.

- point.size:

  Marker size.

- ci.width:

  Interval line width.

- main:

  Optional plot title.

## Value

A `plotly` object. The estimates table it draws is attached as the
`"estimates"` attribute.

## Details

Covariates may be numeric (one row, the effect per unit) or categorical
(one row per level, plus a row for the reference level, which is the
first factor level). Character and logical columns are treated as
factors. With `multivariable = TRUE` all covariates enter one model, so
each estimate is adjusted for the others; with `FALSE` each covariate is
fitted on its own (univariable estimates). Rows with a missing value in
any variable a model uses are dropped from that model.

Confidence intervals are Wald intervals for every model type, so the
three are comparable; for logistic models these can differ slightly from
the profile-likelihood intervals
[`confint()`](https://rdrr.io/r/stats/confint.html) gives.

## See also

[`forestPlotInputsUI()`](https://j-andrews7.github.io/sciVizModules/reference/forestPlotInputsUI.md),
[`forestPlotServer()`](https://j-andrews7.github.io/sciVizModules/reference/forestPlotServer.md),
[`forestPlotApp()`](https://j-andrews7.github.io/sciVizModules/reference/forestPlotApp.md),
[`survival::coxph()`](https://rdrr.io/pkg/survival/man/coxph.html),
[`stats::glm()`](https://rdrr.io/r/stats/glm.html),
[`stats::lm()`](https://rdrr.io/r/stats/lm.html)

## Author

Jared Andrews

## Examples

``` r
data(survival_lung)
forestPlot(survival_lung,
    model = "cox", time = "time", status = "status",
    covariates = c("age", "sex", "ph.ecog")
)

{"x":{"visdat":{"192d16a55722":["function () ","plotlyVisDat"]},"cur_data":"192d16a55722","attrs":{"192d16a55722":{"x":{},"y":{},"mode":"markers","text":{},"hoverinfo":"text","showlegend":false,"marker":{"color":["#000000","rgba(0,0,0,0)","#000000","rgba(0,0,0,0)","#000000","#000000","#000000"],"size":10,"symbol":"square","line":{"color":"#000000","width":1.5}},"error_x":{"type":"data","symmetric":false,"array":[0.018618908026278413,0,0.22628629680237677,0,0.72146819552688757,1.3909527066137364,46.068191739352017],"arrayminus":[0.01828216869083088,0,0.16272805537442586,0,0.48788082779697794,0.88955255366355668,6.1223458627894578],"color":"#000000","thickness":2,"width":0},"alpha_stroke":1,"sizes":[10,100],"spans":[1,20],"type":"scatter"}},"layout":{"margin":{"b":40,"l":60,"t":25,"r":10},"title":{"text":""},"xaxis":{"domain":[0,1],"automargin":true,"title":{"text":"Hazard ratio (95% CI)"},"type":"log","zeroline":false},"yaxis":{"domain":[0,1],"automargin":true,"title":{"text":""},"type":"category","categoryorder":"array","categoryarray":["ph.ecog: In bed >50%","ph.ecog: In bed <50%","ph.ecog: Symptomatic","ph.ecog: Asymptomatic","sex: Female","sex: Male","age"]},"shapes":[{"type":"line","x0":1,"x1":1,"xref":"x","y0":0,"y1":1,"yref":"paper","line":{"color":"#7F7F7F","dash":"dash","width":1}}],"annotations":[{"x":1.02,"xref":"paper","xanchor":"left","y":"age","yref":"y","text":"1.01 (0.99, 1.03)   p = 0.2464","showarrow":false,"align":"left"},{"x":1.02,"xref":"paper","xanchor":"left","y":"sex: Male","yref":"y","text":"Reference","showarrow":false,"align":"left"},{"x":1.02,"xref":"paper","xanchor":"left","y":"sex: Female","yref":"y","text":"0.58 (0.42, 0.81)   p = 0.0012","showarrow":false,"align":"left"},{"x":1.02,"xref":"paper","xanchor":"left","y":"ph.ecog: Asymptomatic","yref":"y","text":"Reference","showarrow":false,"align":"left"},{"x":1.02,"xref":"paper","xanchor":"left","y":"ph.ecog: Symptomatic","yref":"y","text":"1.51 (1.02, 2.23)   p = 0.0399","showarrow":false,"align":"left"},{"x":1.02,"xref":"paper","xanchor":"left","y":"ph.ecog: In bed <50%","yref":"y","text":"2.47 (1.58, 3.86)   p = <0.001","showarrow":false,"align":"left"},{"x":1.02,"xref":"paper","xanchor":"left","y":"ph.ecog: In bed >50%","yref":"y","text":"7.06 (0.94, 53.13)   p = 0.0577","showarrow":false,"align":"left"}],"hovermode":"closest","showlegend":false},"source":"A","config":{"modeBarButtonsToAdd":["hoverclosest","hovercompare"],"showSendToCloud":false},"data":[{"x":[1.0108531482467271,1,0.57936041352360679,1,1.5068901365841272,2.4677406357241938,7.0606942201992],"y":["age","sex: Male","sex: Female","ph.ecog: Asymptomatic","ph.ecog: Symptomatic","ph.ecog: In bed <50%","ph.ecog: In bed >50%"],"mode":"markers","text":["<b>age<\/b><br>1.01 (0.99, 1.03)<br>p = 0.2464<br>n = 227","<b>sex: Male<\/b><br>Reference<br>n = 137","<b>sex: Female<\/b><br>0.58 (0.42, 0.81)<br>p = 0.0012<br>n = 90","<b>ph.ecog: Asymptomatic<\/b><br>Reference<br>n = 63","<b>ph.ecog: Symptomatic<\/b><br>1.51 (1.02, 2.23)<br>p = 0.0399<br>n = 113","<b>ph.ecog: In bed <50%<\/b><br>2.47 (1.58, 3.86)<br>p = <0.001<br>n = 50","<b>ph.ecog: In bed >50%<\/b><br>7.06 (0.94, 53.13)<br>p = 0.0577<br>n = 1"],"hoverinfo":["text","text","text","text","text","text","text"],"showlegend":false,"marker":{"color":["#000000","rgba(0,0,0,0)","#000000","rgba(0,0,0,0)","#000000","#000000","#000000"],"size":10,"symbol":"square","line":{"color":"#000000","width":1.5}},"error_x":{"color":"#000000","type":"data","symmetric":false,"array":[0.018618908026278413,0,0.22628629680237677,0,0.72146819552688757,1.3909527066137364,46.068191739352017],"arrayminus":[0.01828216869083088,0,0.16272805537442586,0,0.48788082779697794,0.88955255366355668,6.1223458627894578],"thickness":2,"width":0},"type":"scatter","error_y":{"color":"rgba(31,119,180,1)"},"line":{"color":"rgba(31,119,180,1)"},"xaxis":"x","yaxis":"y","frame":null}],"highlight":{"on":"plotly_click","persistent":false,"dynamic":false,"selectize":false,"opacityDim":0.20000000000000001,"selected":{"opacity":1},"debounce":0},"shinyEvents":["plotly_hover","plotly_click","plotly_selected","plotly_relayout","plotly_brushed","plotly_brushing","plotly_clickannotation","plotly_doubleclick","plotly_deselect","plotly_afterplot","plotly_sunburstclick"],"base_url":"https://plot.ly"},"evals":[],"jsHooks":[]}
```
