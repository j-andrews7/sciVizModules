# Input UI components for the survivalCurve module

This should be placed in the UI where the inputs should be shown, with
an `id` that matches the `id` used in the
[`survivalCurveServer()`](https://j-andrews7.github.io/sciVizModules/reference/survivalCurveServer.md)
and
[`survivalCurveOutputUI()`](https://j-andrews7.github.io/sciVizModules/reference/survivalCurveOutputUI.md)
functions.

## Usage

``` r
survivalCurveInputsUI(
  id,
  data,
  defaults = NULL,
  title = "Survival Curve Settings",
  columns = 2
)
```

## Arguments

- id:

  The ID for the Shiny module.

- data:

  The data frame used for plot generation.

- defaults:

  A named list of default values for the inputs.

- title:

  An optional title for the UI grid.

- columns:

  Number of columns for the UI grid.

## Value

A Shiny tagList containing the UI elements

## Details

The user inputs for this module are separated from the outputs to allow
for more flexible UI design.

The inputs are organized into tabs via the
[`VizModules::organize_inputs()`](https://j-andrews7.github.io/VizModules/reference/organize_inputs.html)
function, with `columns` controlling the number of columns in each tab's
grid.

Defaults can be set for each input by providing a named list of values
to the `defaults` argument. The module fits Kaplan-Meier survival curves
with
[`survival::survfit()`](https://rdrr.io/pkg/survival/man/survfit.html)
and draws them with
[`survivalCurve()`](https://j-andrews7.github.io/sciVizModules/reference/survivalCurve.md),
so it expects a "tidy" survival data frame with a numeric follow-up
`time` column and an event `status` column (and, optionally, a
categorical column to stratify by).

## Plot parameters and defaults

The following parameters can be accessed via UI inputs and/or the
`defaults` argument:

- `time` - Follow-up time column (auto-detected from columns named
  time/os/pfs/fu, else first numeric column)

- `status` - Event/status column (auto-detected from columns named
  status/event/vital/dead/censor, else a numeric 0/1 or 1/2 column)

- `group.by` - Optional stratification column (default: none)

- `conf.int` - Show a confidence band around each curve (UI: "Confidence
  Band", default: TRUE)

- `conf.int.opacity` - Fill opacity of the band, 0 to 1 (UI: "Band
  Opacity", default: 0.25; shown while the band is on)

- `conf.level` - Confidence level of the band (UI: "Confidence Level",
  default: 0.95; shown while the band is on)

- `conf.type` - How the band is computed: "log", "log-log" or "plain"
  (UI: "CI Transform", default: "log", the
  [`survival::survfit()`](https://rdrr.io/pkg/survival/man/survfit.html)
  default; shown while the band is on)

- `pval` - Show log-rank p-value (default: TRUE; only when stratified)

- `risk.table` - Show "number at risk" table (default: FALSE)

- `censor` - Show censoring marks (default: TRUE)

- `surv.median.line` - Median survival reference lines (default: "none")

- `pairwise` - With three or more groups, also test each pair of groups
  (UI: "Pairwise Comparisons", default: FALSE). The adjusted p-values
  are listed on the plot, each pair's hazard ratio is in its hover text,
  and the source download carries the full comparison table. See
  [`survivalCurve()`](https://j-andrews7.github.io/sciVizModules/reference/survivalCurve.md)'s
  Details for how to read them.

- `stat.pairs` - The pairs to test, as `"A vs B"` strings (UI:
  "Comparisons", default: all pairs; shown while comparisons are on)

- `stat.p.adjust` - Multiple-testing correction across the pairs, a
  [`stats::p.adjust()`](https://rdrr.io/r/stats/p.adjust.html) method
  (UI: "P-value Adjustment", default: "holm"; shown while comparisons
  are on)

- `fun` - Curve transformation: survival probability, "pct", "event", or
  "cumhaz" (default: survival probability)

- `line.size` - Line width in pixels (default: 2)

- `palette.colours` - Colors for the strata (multiColorPicker), a named
  character vector mapping stratum to color

- `break.time.by` - Spacing between x-axis ticks and risk table times
  (default: blank/auto)

## See also

[`survival::survfit()`](https://rdrr.io/pkg/survival/man/survfit.html),
[`VizModules::organize_inputs()`](https://j-andrews7.github.io/VizModules/reference/organize_inputs.html),
[`survivalCurveOutputUI()`](https://j-andrews7.github.io/sciVizModules/reference/survivalCurveOutputUI.md),
[`survivalCurveServer()`](https://j-andrews7.github.io/sciVizModules/reference/survivalCurveServer.md),
[`survivalCurveApp()`](https://j-andrews7.github.io/sciVizModules/reference/survivalCurveApp.md)

## Author

Jacob Martin

## Examples

``` r
library(sciVizModules)
data(survival_lung)
survivalCurveInputsUI("survivalCurve", survival_lung)
#> <h3>Survival Curve Settings</h3>
#> <div class="tabbable vizmodules-input-tabs">
#>   <ul class="nav nav-tabs shiny-tab-input" id="survivalCurve-survivalCurveTabsetPanel" data-tabsetid="9092">
#>     <li class="active">
#>       <a href="#tab-9092-1" data-toggle="tab" data-bs-toggle="tab" data-value="Data">Data</a>
#>     </li>
#>     <li>
#>       <a href="#tab-9092-2" data-toggle="tab" data-bs-toggle="tab" data-value="Statistics">Statistics</a>
#>     </li>
#>     <li>
#>       <a href="#tab-9092-3" data-toggle="tab" data-bs-toggle="tab" data-value="Aesthetics">Aesthetics</a>
#>     </li>
#>     <li>
#>       <a href="#tab-9092-4" data-toggle="tab" data-bs-toggle="tab" data-value="Plotly">Plotly</a>
#>     </li>
#>     <li>
#>       <a href="#tab-9092-5" data-toggle="tab" data-bs-toggle="tab" data-value="Axes">Axes</a>
#>     </li>
#>     <li>
#>       <a href="#tab-9092-6" data-toggle="tab" data-bs-toggle="tab" data-value="Legend">Legend</a>
#>     </li>
#>     <li>
#>       <a href="#tab-9092-7" data-toggle="tab" data-bs-toggle="tab" data-value="Lines">Lines</a>
#>     </li>
#>   </ul>
#>   <div class="tab-content" data-tabsetid="9092">
#>     <div class="tab-pane active" data-value="Data" id="tab-9092-1">
#>       <div class="vizmodules-input-grid" style="--viz-input-columns: 2;">
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" style="width:100%;" id="tipify2399817">
#>             <label class="control-label" id="survivalCurve-time-label" for="survivalCurve-time">Time</label>
#>             <div id="survivalCurve-time" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="change">
#>               <script type="application/json" data-for="survivalCurve-time">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["time","status","age"],"value":["time","status","age"]}},"config":{"multiple":false,"search":false,"selectedValue":"time","hideClearButton":true,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":false,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":true,"disableOptionGroupCheckbox":true,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify2399817', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Numeric follow-up time column.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" style="width:100%;" id="tipify4711367">
#>             <label class="control-label" id="survivalCurve-status-label" for="survivalCurve-status">Status (Event)</label>
#>             <div id="survivalCurve-status" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="change">
#>               <script type="application/json" data-for="survivalCurve-status">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["time","status","age","sex","ph.ecog"],"value":["time","status","age","sex","ph.ecog"]}},"config":{"multiple":false,"search":false,"selectedValue":"status","hideClearButton":true,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":false,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":true,"disableOptionGroupCheckbox":true,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify4711367', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Event indicator column. Accepts 0/1 (1 = event), 1/2 (2 = event), logical, or a two-level factor/character.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" style="width:100%;" id="tipify1010835">
#>             <label class="control-label" id="survivalCurve-group.by-label" for="survivalCurve-group.by">Group By</label>
#>             <div id="survivalCurve-group.by" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="change">
#>               <script type="application/json" data-for="survivalCurve-group.by">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["(none)","sex","ph.ecog"],"value":["","sex","ph.ecog"]}},"config":{"multiple":false,"search":false,"selectedValue":"","hideClearButton":true,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":false,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":true,"disableOptionGroupCheckbox":true,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify1010835', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Optional categorical column to stratify the curves by.'})}, 500)});</script>
#>         </div>
#>       </div>
#>     </div>
#>     <div class="tab-pane" data-value="Statistics" id="tab-9092-2">
#>       <div class="vizmodules-input-grid" style="--viz-input-columns: 2;">
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify7327638">
#>             <div class="material-switch">
#>               <label for="survivalCurve-conf.int" style="padding-right: 10px;">Confidence Band</label>
#>               <input id="survivalCurve-conf.int" type="checkbox" checked="checked"/>
#>               <label class="switch label-success bg-success" for="survivalCurve-conf.int"></label>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify7327638', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Shade the confidence interval of each curve, in its colour.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify7683000">
#>             <label class="control-label" id="survivalCurve-conf.level-label" for="survivalCurve-conf.level">Confidence Level</label>
#>             <input id="survivalCurve-conf.level" type="number" class="shiny-input-number form-control" value="0.95" data-update-on="change" min="0.5" max="0.999" step="0.01"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify7683000', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Confidence level of the band.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" style="width:100%;" id="tipify9567792">
#>             <label class="control-label" id="survivalCurve-conf.type-label" for="survivalCurve-conf.type">CI Transform</label>
#>             <div id="survivalCurve-conf.type" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="change">
#>               <script type="application/json" data-for="survivalCurve-conf.type">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["Log","Log-log","Plain"],"value":["log","log-log","plain"]}},"config":{"multiple":false,"search":false,"selectedValue":"log","hideClearButton":true,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":false,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":true,"disableOptionGroupCheckbox":true,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify9567792', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Scale the interval is computed on. Log (the survival package default) and log-log keep the band within 0 and 1; plain is the symmetric Greenwood interval.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify3371671">
#>             <label class="control-label" id="survivalCurve-conf.int.opacity-label" for="survivalCurve-conf.int.opacity">Band Opacity</label>
#>             <input id="survivalCurve-conf.int.opacity" type="number" class="shiny-input-number form-control" value="0.25" data-update-on="change" min="0" max="1" step="0.05"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify3371671', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Fill opacity of the confidence band.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify2775083">
#>             <div class="material-switch">
#>               <label for="survivalCurve-pval" style="padding-right: 10px;">Log-rank p-value</label>
#>               <input id="survivalCurve-pval" type="checkbox" checked="checked"/>
#>               <label class="switch label-success bg-success" for="survivalCurve-pval"></label>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify2775083', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Show the log-rank test p-value (only shown when stratified by a group).'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify3992167">
#>             <div class="material-switch">
#>               <label for="survivalCurve-risk.table" style="padding-right: 10px;">Risk Table</label>
#>               <input id="survivalCurve-risk.table" type="checkbox"/>
#>               <label class="switch label-success bg-success" for="survivalCurve-risk.table"></label>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify3992167', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Append a &#39;number at risk&#39; table beneath the curve.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify2399941">
#>             <div class="material-switch">
#>               <label for="survivalCurve-censor" style="padding-right: 10px;">Censoring Marks</label>
#>               <input id="survivalCurve-censor" type="checkbox" checked="checked"/>
#>               <label class="switch label-success bg-success" for="survivalCurve-censor"></label>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify2399941', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Draw marks where observations were censored.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" style="width:100%;" id="tipify3559751">
#>             <label class="control-label" id="survivalCurve-surv.median.line-label" for="survivalCurve-surv.median.line">Median Survival Line</label>
#>             <div id="survivalCurve-surv.median.line" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="change">
#>               <script type="application/json" data-for="survivalCurve-surv.median.line">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["none","hv","h","v"],"value":["none","hv","h","v"]}},"config":{"multiple":false,"search":false,"selectedValue":"none","hideClearButton":true,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":false,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":true,"disableOptionGroupCheckbox":true,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify3559751', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Draw reference lines at the median survival time (survival probability or percentage curves).'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify3122014">
#>             <div class="material-switch">
#>               <label for="survivalCurve-pairwise" style="padding-right: 10px;">Pairwise Comparisons</label>
#>               <input id="survivalCurve-pairwise" type="checkbox"/>
#>               <label class="switch label-success bg-success" for="survivalCurve-pairwise"></label>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify3122014', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'With three or more groups, also test each pair (log-rank, on that pair&#39;s subjects), adjusted for the number of comparisons. Hover the results for each pair&#39;s hazard ratio and its subjects and events; small groups give unreliable results.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" style="width:100%;" id="tipify8873296">
#>             <label class="control-label" id="survivalCurve-stat.pairs-label" for="survivalCurve-stat.pairs">Comparisons</label>
#>             <div id="survivalCurve-stat.pairs" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="close">
#>               <script type="application/json" data-for="survivalCurve-stat.pairs">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":[],"value":[]}},"config":{"multiple":true,"search":false,"selectedValue":"","hideClearButton":false,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":true,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":false,"disableOptionGroupCheckbox":false,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify8873296', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'The pairs to test. Empty tests every pair. Fewer, pre-specified comparisons (each group against a control) cost less adjustment.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" style="width:100%;" id="tipify2135708">
#>             <label class="control-label" id="survivalCurve-stat.p.adjust-label" for="survivalCurve-stat.p.adjust">P-value Adjustment</label>
#>             <div id="survivalCurve-stat.p.adjust" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="change">
#>               <script type="application/json" data-for="survivalCurve-stat.p.adjust">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["holm","hochberg","hommel","bonferroni","BH","BY","fdr","none"],"value":["holm","hochberg","hommel","bonferroni","BH","BY","fdr","none"]}},"config":{"multiple":false,"search":false,"selectedValue":"holm","hideClearButton":true,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":false,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":true,"disableOptionGroupCheckbox":true,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify2135708', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Correction for testing several pairs. Holm controls the chance of any false positive; BH controls the false discovery rate, for screening many groups; none overstates significance.'})}, 500)});</script>
#>         </div>
#>       </div>
#>     </div>
#>     <div class="tab-pane" data-value="Aesthetics" id="tab-9092-3">
#>       <div class="vizmodules-input-grid" style="--viz-input-columns: 2;">
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" style="width:100%;" id="tipify3280287">
#>             <label class="control-label" id="survivalCurve-fun-label" for="survivalCurve-fun">Curve Type</label>
#>             <div id="survivalCurve-fun" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="change">
#>               <script type="application/json" data-for="survivalCurve-fun">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["Survival probability","Survival percentage","Cumulative events","Cumulative hazard"],"value":["survival","pct","event","cumhaz"]}},"config":{"multiple":false,"search":false,"selectedValue":"survival","hideClearButton":true,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":false,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":true,"disableOptionGroupCheckbox":true,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify3280287', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Transformation applied to the survival curve and its band.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div id="survivalCurve-palette.selection" class="shiny-html-output"></div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify6603286">
#>             <label class="control-label" id="survivalCurve-line.size-label" for="survivalCurve-line.size">Line Width</label>
#>             <input id="survivalCurve-line.size" type="number" class="shiny-input-number form-control" value="2" data-update-on="change" min="0.1" step="0.5"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify6603286', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Width of the survival curve lines, in pixels.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify8725790">
#>             <label class="control-label" id="survivalCurve-break.time.by-label" for="survivalCurve-break.time.by">Time Axis Spacing</label>
#>             <input id="survivalCurve-break.time.by" type="number" class="shiny-input-number form-control" value="NA" data-update-on="change" min="0"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify8725790', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Spacing between time axis ticks, which the risk table also counts at. Blank for automatic.'})}, 500)});</script>
#>         </div>
#>       </div>
#>     </div>
#>     <div class="tab-pane" data-value="Plotly" id="tab-9092-4">
#>       <div class="vizmodules-input-grid" style="--viz-input-columns: 2;">
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" style="width:100%;">
#>             <label class="control-label" id="survivalCurve-download.format-label" for="survivalCurve-download.format">Download Format</label>
#>             <div id="survivalCurve-download.format" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="change">
#>               <script type="application/json" data-for="survivalCurve-download.format">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["svg","png","jpeg","webp"],"value":["svg","png","jpeg","webp"]}},"config":{"multiple":false,"search":false,"selectedValue":"svg","hideClearButton":true,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":false,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":true,"disableOptionGroupCheckbox":true,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>             </div>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify6705935">
#>             <label class="control-label" id="survivalCurve-margin.t-label" for="survivalCurve-margin.t">Margin Top</label>
#>             <input id="survivalCurve-margin.t" type="number" class="shiny-input-number form-control" value="70" data-update-on="change" min="0" step="5"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify6705935', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Top margin of the plot in pixels'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify5755505">
#>             <label class="control-label" id="survivalCurve-margin.b-label" for="survivalCurve-margin.b">Margin Bottom</label>
#>             <input id="survivalCurve-margin.b" type="number" class="shiny-input-number form-control" value="70" data-update-on="change" min="0" step="5"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify5755505', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Bottom margin of the plot in pixels'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify2578534">
#>             <label class="control-label" id="survivalCurve-margin.l-label" for="survivalCurve-margin.l">Margin Left</label>
#>             <input id="survivalCurve-margin.l" type="number" class="shiny-input-number form-control" value="70" data-update-on="change" min="0" step="5"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify2578534', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Left margin of the plot in pixels'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify859078">
#>             <label class="control-label" id="survivalCurve-margin.r-label" for="survivalCurve-margin.r">Margin Right</label>
#>             <input id="survivalCurve-margin.r" type="number" class="shiny-input-number form-control" value="90" data-update-on="change" min="0" step="5"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify859078', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Right margin of the plot in pixels'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour" id="tipify8432447">
#>             <label class="control-label" for="survivalCurve-shape.fill">Shape Fill</label>
#>             <input id="survivalCurve-shape.fill" type="text" class="form-control shiny-colour-input" data-init-value="rgba(0, 0, 0, 0)" data-show-colour="both" data-palette="square" data-allow-alpha="true"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify8432447', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Interior fill color for shapes drawn on the plot using Plotly&#39;s drawing tools'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour" id="tipify971261">
#>             <label class="control-label" for="survivalCurve-shape.line.color">Shape Line Color</label>
#>             <input id="survivalCurve-shape.line.color" type="text" class="form-control shiny-colour-input" data-init-value="black" data-show-colour="both" data-palette="square" data-allow-alpha="true"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify971261', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Outline color for shapes drawn on the plot using Plotly&#39;s drawing tools'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify4593261">
#>             <label class="control-label" id="survivalCurve-shape.line.width-label" for="survivalCurve-shape.line.width">Shape Line Width</label>
#>             <input id="survivalCurve-shape.line.width" type="number" class="shiny-input-number form-control" value="4" data-update-on="change" min="0" step="0.25"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify4593261', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Outline width for shapes drawn on the plot using Plotly&#39;s drawing tools'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" style="width:100%;" id="tipify162950">
#>             <label class="control-label" id="survivalCurve-shape.linetype-label" for="survivalCurve-shape.linetype">Shape Linetype</label>
#>             <div id="survivalCurve-shape.linetype" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="change">
#>               <script type="application/json" data-for="survivalCurve-shape.linetype">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["solid","dot","dash","longdash","dashdot","longdashdot"],"value":["solid","dot","dash","longdash","dashdot","longdashdot"]}},"config":{"multiple":false,"search":false,"selectedValue":"solid","hideClearButton":true,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":false,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":true,"disableOptionGroupCheckbox":true,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify162950', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Line dash style for shapes drawn on the plot using Plotly&#39;s drawing tools'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify6259620">
#>             <label class="control-label" id="survivalCurve-shape.opacity-label" for="survivalCurve-shape.opacity">Shape Opacity</label>
#>             <input id="survivalCurve-shape.opacity" type="number" class="shiny-input-number form-control" value="1" data-update-on="change" min="0" max="1" step="0.01"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify6259620', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Opacity of shapes drawn on the plot, where 0 is fully transparent and 1 is fully opaque'})}, 500)});</script>
#>         </div>
#>       </div>
#>     </div>
#>     <div class="tab-pane" data-value="Axes" id="tab-9092-5">
#>       <div class="vizmodules-input-grid" style="--viz-input-columns: 2;">
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" style="width:100%;">
#>             <label class="control-label" id="survivalCurve-title.font.family-label" for="survivalCurve-title.font.family">Title Font</label>
#>             <div id="survivalCurve-title.font.family" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="change">
#>               <script type="application/json" data-for="survivalCurve-title.font.family">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["Arial","Balto","Courier New","Droid Sans","Droid Serif","Droid Sans Mono","Gravitas One","Old Standard TT","Open Sans","Overpass","PT Sans Narrow","Raleway","Times New Roman","Verdana","sans-serif","serif","monospace"],"value":["Arial","Balto","Courier New","Droid Sans","Droid Serif","Droid Sans Mono","Gravitas One","Old Standard TT","Open Sans","Overpass","PT Sans Narrow","Raleway","Times New Roman","Verdana","sans-serif","serif","monospace"]}},"config":{"multiple":false,"search":true,"selectedValue":"Arial","hideClearButton":true,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":false,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":true,"disableOptionGroupCheckbox":true,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>             </div>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour">
#>             <label class="control-label" for="survivalCurve-title.font.color">Title Color</label>
#>             <input id="survivalCurve-title.font.color" type="text" class="form-control shiny-colour-input" data-init-value="#000000" data-show-colour="both" data-palette="square"/>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="survivalCurve-title.font.size-label" for="survivalCurve-title.font.size">Title Size</label>
#>             <input id="survivalCurve-title.font.size" type="number" class="shiny-input-number form-control" value="26" data-update-on="change" min="1" step="1"/>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="survivalCurve-axis.title.horizontal.position-label" for="survivalCurve-axis.title.horizontal.position">Title position</label>
#>             <input id="survivalCurve-axis.title.horizontal.position" type="number" class="shiny-input-number form-control" value="0.5" data-update-on="change" min="0" max="1" step="0.1"/>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="survivalCurve-axis.title.font.size-label" for="survivalCurve-axis.title.font.size">Axis Title Size</label>
#>             <input id="survivalCurve-axis.title.font.size" type="number" class="shiny-input-number form-control" value="18" data-update-on="change" min="1" step="1"/>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour">
#>             <label class="control-label" for="survivalCurve-axis.title.font.color">Axis Title Color</label>
#>             <input id="survivalCurve-axis.title.font.color" type="text" class="form-control shiny-colour-input" data-init-value="#000000" data-show-colour="both" data-palette="square"/>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" style="width:100%;">
#>             <label class="control-label" id="survivalCurve-axis.title.font.family-label" for="survivalCurve-axis.title.font.family">Axis Title Font</label>
#>             <div id="survivalCurve-axis.title.font.family" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="change">
#>               <script type="application/json" data-for="survivalCurve-axis.title.font.family">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["Arial","Balto","Courier New","Droid Sans","Droid Serif","Droid Sans Mono","Gravitas One","Old Standard TT","Open Sans","Overpass","PT Sans Narrow","Raleway","Times New Roman","Verdana","sans-serif","serif","monospace"],"value":["Arial","Balto","Courier New","Droid Sans","Droid Serif","Droid Sans Mono","Gravitas One","Old Standard TT","Open Sans","Overpass","PT Sans Narrow","Raleway","Times New Roman","Verdana","sans-serif","serif","monospace"]}},"config":{"multiple":false,"search":true,"selectedValue":"Arial","hideClearButton":true,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":false,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":true,"disableOptionGroupCheckbox":true,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>             </div>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container">
#>             <div class="checkbox">
#>               <label>
#>                 <input id="survivalCurve-axis.showline" type="checkbox" class="shiny-input-checkbox" checked="checked"/>
#>                 <span>Show Axis Borders</span>
#>               </label>
#>             </div>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container">
#>             <div class="checkbox">
#>               <label>
#>                 <input id="survivalCurve-axis.mirror" type="checkbox" class="shiny-input-checkbox" checked="checked"/>
#>                 <span>Mirror Axis Borders</span>
#>               </label>
#>             </div>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container">
#>             <div class="checkbox">
#>               <label>
#>                 <input id="survivalCurve-show.grid.x" type="checkbox" class="shiny-input-checkbox" checked="checked"/>
#>                 <span>Show X Gridlines</span>
#>               </label>
#>             </div>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container">
#>             <div class="checkbox">
#>               <label>
#>                 <input id="survivalCurve-show.grid.y" type="checkbox" class="shiny-input-checkbox" checked="checked"/>
#>                 <span>Show Y Gridlines</span>
#>               </label>
#>             </div>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour">
#>             <label class="control-label" for="survivalCurve-grid.color">Gridline Color</label>
#>             <input id="survivalCurve-grid.color" type="text" class="form-control shiny-colour-input" data-init-value="#CCCCCC" data-show-colour="both" data-palette="square"/>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour">
#>             <label class="control-label" for="survivalCurve-axis.linecolor">Axis Line Color</label>
#>             <input id="survivalCurve-axis.linecolor" type="text" class="form-control shiny-colour-input" data-init-value="black" data-show-colour="both" data-palette="square"/>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="survivalCurve-axis.linewidth-label" for="survivalCurve-axis.linewidth">Axis Line Width</label>
#>             <input id="survivalCurve-axis.linewidth" type="number" class="shiny-input-number form-control" value="0.5" data-update-on="change" min="0" step="0.1"/>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="survivalCurve-axis.tickfont.size-label" for="survivalCurve-axis.tickfont.size">Tick Label Size</label>
#>             <input id="survivalCurve-axis.tickfont.size" type="number" class="shiny-input-number form-control" value="12" data-update-on="change" min="1" step="1"/>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour">
#>             <label class="control-label" for="survivalCurve-axis.tickfont.color">Tick Label Color</label>
#>             <input id="survivalCurve-axis.tickfont.color" type="text" class="form-control shiny-colour-input" data-init-value="black" data-show-colour="both" data-palette="square"/>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" style="width:100%;">
#>             <label class="control-label" id="survivalCurve-axis.tickfont.family-label" for="survivalCurve-axis.tickfont.family">Tick Label Font</label>
#>             <div id="survivalCurve-axis.tickfont.family" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="change">
#>               <script type="application/json" data-for="survivalCurve-axis.tickfont.family">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["Arial","Balto","Courier New","Droid Sans","Droid Serif","Droid Sans Mono","Gravitas One","Old Standard TT","Open Sans","Overpass","PT Sans Narrow","Raleway","Times New Roman","Verdana","sans-serif","serif","monospace"],"value":["Arial","Balto","Courier New","Droid Sans","Droid Serif","Droid Sans Mono","Gravitas One","Old Standard TT","Open Sans","Overpass","PT Sans Narrow","Raleway","Times New Roman","Verdana","sans-serif","serif","monospace"]}},"config":{"multiple":false,"search":true,"selectedValue":"Arial","hideClearButton":true,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":false,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":true,"disableOptionGroupCheckbox":true,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>             </div>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="survivalCurve-axis.tickangle.x-label" for="survivalCurve-axis.tickangle.x">X Tick Label Angle</label>
#>             <input id="survivalCurve-axis.tickangle.x" type="number" class="shiny-input-number form-control" value="0" data-update-on="change" min="-180" max="180" step="15"/>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="survivalCurve-axis.tickangle.y-label" for="survivalCurve-axis.tickangle.y">Y Tick Label Angle</label>
#>             <input id="survivalCurve-axis.tickangle.y" type="number" class="shiny-input-number form-control" value="0" data-update-on="change" min="-180" max="180" step="15"/>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" style="width:100%;">
#>             <label class="control-label" id="survivalCurve-axis.ticks-label" for="survivalCurve-axis.ticks">Tick Position</label>
#>             <div id="survivalCurve-axis.ticks" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="change">
#>               <script type="application/json" data-for="survivalCurve-axis.ticks">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["Outside","Inside","(none)"],"value":["outside","inside",""]}},"config":{"multiple":false,"search":false,"selectedValue":"outside","hideClearButton":true,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":false,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":true,"disableOptionGroupCheckbox":true,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>             </div>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour">
#>             <label class="control-label" for="survivalCurve-axis.tickcolor">Tick Mark Color</label>
#>             <input id="survivalCurve-axis.tickcolor" type="text" class="form-control shiny-colour-input" data-init-value="black" data-show-colour="both" data-palette="square"/>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="survivalCurve-axis.ticklen-label" for="survivalCurve-axis.ticklen">Tick Mark Length</label>
#>             <input id="survivalCurve-axis.ticklen" type="number" class="shiny-input-number form-control" value="5" data-update-on="change" min="0" step="1"/>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="survivalCurve-axis.tickwidth-label" for="survivalCurve-axis.tickwidth">Tick Mark Width</label>
#>             <input id="survivalCurve-axis.tickwidth" type="number" class="shiny-input-number form-control" value="1" data-update-on="change" min="0" step="0.1"/>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="survivalCurve-facet.title.font.size-label" for="survivalCurve-facet.title.font.size">Facet Subplot Title Size</label>
#>             <input id="survivalCurve-facet.title.font.size" type="number" class="shiny-input-number form-control" value="18" data-update-on="change" min="1" step="1"/>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour">
#>             <label class="control-label" for="survivalCurve-facet.title.font.color">Facet Title Color</label>
#>             <input id="survivalCurve-facet.title.font.color" type="text" class="form-control shiny-colour-input" data-init-value="#000000" data-show-colour="both" data-palette="square"/>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" style="width:100%;">
#>             <label class="control-label" id="survivalCurve-facet.title.font.family-label" for="survivalCurve-facet.title.font.family">Facet Title Font</label>
#>             <div id="survivalCurve-facet.title.font.family" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="change">
#>               <script type="application/json" data-for="survivalCurve-facet.title.font.family">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["Arial","Balto","Courier New","Droid Sans","Droid Serif","Droid Sans Mono","Gravitas One","Old Standard TT","Open Sans","Overpass","PT Sans Narrow","Raleway","Times New Roman","Verdana","sans-serif","serif","monospace"],"value":["Arial","Balto","Courier New","Droid Sans","Droid Serif","Droid Sans Mono","Gravitas One","Old Standard TT","Open Sans","Overpass","PT Sans Narrow","Raleway","Times New Roman","Verdana","sans-serif","serif","monospace"]}},"config":{"multiple":false,"search":true,"selectedValue":"Arial","hideClearButton":true,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":false,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":true,"disableOptionGroupCheckbox":true,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>             </div>
#>           </div>
#>         </div>
#>       </div>
#>     </div>
#>     <div class="tab-pane" data-value="Legend" id="tab-9092-6">
#>       <div class="vizmodules-input-grid" style="--viz-input-columns: 2;">
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify4616787">
#>             <div class="material-switch">
#>               <label for="survivalCurve-legend.show" style="padding-right: 10px;">Show Legend</label>
#>               <input id="survivalCurve-legend.show" type="checkbox" checked="checked"/>
#>               <label class="switch label-success bg-success" for="survivalCurve-legend.show"></label>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify4616787', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Show the legend. Turning it off also hides colorbars and any point size legend.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" style="width:100%;" id="tipify3449301">
#>             <label class="control-label" id="survivalCurve-legend.font.family-label" for="survivalCurve-legend.font.family">Legend Font</label>
#>             <div id="survivalCurve-legend.font.family" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="change">
#>               <script type="application/json" data-for="survivalCurve-legend.font.family">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["Arial","Balto","Courier New","Droid Sans","Droid Serif","Droid Sans Mono","Gravitas One","Old Standard TT","Open Sans","Overpass","PT Sans Narrow","Raleway","Times New Roman","Verdana","sans-serif","serif","monospace"],"value":["Arial","Balto","Courier New","Droid Sans","Droid Serif","Droid Sans Mono","Gravitas One","Old Standard TT","Open Sans","Overpass","PT Sans Narrow","Raleway","Times New Roman","Verdana","sans-serif","serif","monospace"]}},"config":{"multiple":false,"search":true,"selectedValue":"Arial","hideClearButton":true,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":false,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":true,"disableOptionGroupCheckbox":true,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify3449301', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Font family of the legend title and entry labels.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour" id="tipify7563185">
#>             <label class="control-label" for="survivalCurve-legend.font.color">Legend Font Color</label>
#>             <input id="survivalCurve-legend.font.color" type="text" class="form-control shiny-colour-input" data-init-value="#000000" data-show-colour="both" data-palette="square"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify7563185', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Font color of the legend title and entry labels.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify777542">
#>             <label class="control-label" id="survivalCurve-legend.title.size-label" for="survivalCurve-legend.title.size">Legend Title Size</label>
#>             <input id="survivalCurve-legend.title.size" type="number" class="shiny-input-number form-control" value="14" data-update-on="change" min="0" step="1"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify777542', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Font size of the legend title.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify3175392">
#>             <label class="control-label" id="survivalCurve-legend.text.size-label" for="survivalCurve-legend.text.size">Legend Text Size</label>
#>             <input id="survivalCurve-legend.text.size" type="number" class="shiny-input-number form-control" value="12" data-update-on="change" min="0" step="1"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify3175392', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Font size of the legend entry labels.'})}, 500)});</script>
#>         </div>
#>       </div>
#>     </div>
#>     <div class="tab-pane" data-value="Lines" id="tab-9092-7">
#>       <div class="vizmodules-input-grid" style="--viz-input-columns: 2;">
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify1823221">
#>             <label class="control-label" id="survivalCurve-hline.intercepts-label" for="survivalCurve-hline.intercepts">Y-intercepts</label>
#>             <input id="survivalCurve-hline.intercepts" type="text" class="shiny-input-text form-control" value="" placeholder="e.g. 2, -2" data-update-on="change"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify1823221', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'For categorical or factor axes, enter the index (position) of the category rather than its name. For example, if the axis categories are &#39;Audi&#39;, &#39;Mercedes&#39;, &#39;Bugatti&#39;, enter 2 to place a line at &#39;Mercedes&#39;.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify9610607">
#>             <label class="control-label" id="survivalCurve-hline.colors-label" for="survivalCurve-hline.colors">Y Colors</label>
#>             <input id="survivalCurve-hline.colors" type="text" class="shiny-input-text form-control" value="#000000" data-update-on="change"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify9610607', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Color(s) for horizontal reference lines, as comma-separated hex codes or color names'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify7961235">
#>             <label class="control-label" id="survivalCurve-hline.widths-label" for="survivalCurve-hline.widths">Y Widths</label>
#>             <input id="survivalCurve-hline.widths" type="text" class="shiny-input-text form-control" value="1" data-update-on="change"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify7961235', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Width(s) for horizontal reference lines in pixels, as comma-separated values'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify9786097">
#>             <label class="control-label" id="survivalCurve-hline.linetypes-label" for="survivalCurve-hline.linetypes">Y Line Types</label>
#>             <input id="survivalCurve-hline.linetypes" type="text" class="shiny-input-text form-control" value="dashed" placeholder="solid, dashed, dotted, ..." data-update-on="change"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify9786097', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Line style(s) for horizontal reference lines (solid, dashed, dotted, dotdash, longdash, twodash)'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify948828">
#>             <label class="control-label" id="survivalCurve-hline.opacities-label" for="survivalCurve-hline.opacities">Y Opacities (0-1)</label>
#>             <input id="survivalCurve-hline.opacities" type="text" class="shiny-input-text form-control" value="1" data-update-on="change"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify948828', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Opacity of horizontal reference lines between 0 (transparent) and 1 (opaque), as comma-separated values'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify6655356">
#>             <label class="control-label" id="survivalCurve-vline.intercepts-label" for="survivalCurve-vline.intercepts">X-intercepts</label>
#>             <input id="survivalCurve-vline.intercepts" type="text" class="shiny-input-text form-control" value="" placeholder="e.g. 2, -2" data-update-on="change"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify6655356', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'For categorical or factor axes, enter the index (position) of the category rather than its name. For example, if the axis categories are &#39;Audi&#39;, &#39;Mercedes&#39;, &#39;Bugatti&#39;, enter 2 to place a line at &#39;Mercedes&#39;.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify8575061">
#>             <label class="control-label" id="survivalCurve-vline.colors-label" for="survivalCurve-vline.colors">X Colors</label>
#>             <input id="survivalCurve-vline.colors" type="text" class="shiny-input-text form-control" value="#000000" data-update-on="change"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify8575061', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Color(s) for vertical reference lines, as comma-separated hex codes or color names'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify2855340">
#>             <label class="control-label" id="survivalCurve-vline.widths-label" for="survivalCurve-vline.widths">X Widths</label>
#>             <input id="survivalCurve-vline.widths" type="text" class="shiny-input-text form-control" value="1" data-update-on="change"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify2855340', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Width(s) for vertical reference lines in pixels, as comma-separated values'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify5482236">
#>             <label class="control-label" id="survivalCurve-vline.linetypes-label" for="survivalCurve-vline.linetypes">X Line Types</label>
#>             <input id="survivalCurve-vline.linetypes" type="text" class="shiny-input-text form-control" value="dashed" placeholder="solid, dashed, dotted, ..." data-update-on="change"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify5482236', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Line style(s) for vertical reference lines (solid, dashed, dotted, dotdash, longdash, twodash)'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify2021869">
#>             <label class="control-label" id="survivalCurve-vline.opacities-label" for="survivalCurve-vline.opacities">X Opacities (0-1)</label>
#>             <input id="survivalCurve-vline.opacities" type="text" class="shiny-input-text form-control" value="1" data-update-on="change"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify2021869', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Opacity of vertical reference lines between 0 (transparent) and 1 (opaque), as comma-separated values'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify9424059">
#>             <label class="control-label" id="survivalCurve-abline.slopes-label" for="survivalCurve-abline.slopes">Ab Slopes</label>
#>             <input id="survivalCurve-abline.slopes" type="text" class="shiny-input-text form-control" value="" data-update-on="change"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify9424059', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Slope(s) of diagonal reference lines (rise/run), as comma-separated values'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify6547804">
#>             <label class="control-label" id="survivalCurve-abline.intercepts-label" for="survivalCurve-abline.intercepts">Ab Y-intercepts</label>
#>             <input id="survivalCurve-abline.intercepts" type="text" class="shiny-input-text form-control" value="" data-update-on="change"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify6547804', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'For categorical or factor axes, enter the index (position) of the category rather than its name. For example, if the axis categories are &#39;Audi&#39;, &#39;Mercedes&#39;, &#39;Bugatti&#39;, enter 2 to place a line at &#39;Mercedes&#39;.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify9437307">
#>             <label class="control-label" id="survivalCurve-abline.colors-label" for="survivalCurve-abline.colors">Ab Colors</label>
#>             <input id="survivalCurve-abline.colors" type="text" class="shiny-input-text form-control" value="#000000" data-update-on="change"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify9437307', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Color(s) for diagonal reference lines, as comma-separated hex codes or color names'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify701685">
#>             <label class="control-label" id="survivalCurve-abline.widths-label" for="survivalCurve-abline.widths">Ab Widths</label>
#>             <input id="survivalCurve-abline.widths" type="text" class="shiny-input-text form-control" value="1" data-update-on="change"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify701685', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Width(s) for diagonal reference lines in pixels, as comma-separated values'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify719735">
#>             <label class="control-label" id="survivalCurve-abline.linetypes-label" for="survivalCurve-abline.linetypes">Ab Line Types</label>
#>             <input id="survivalCurve-abline.linetypes" type="text" class="shiny-input-text form-control" value="dashed" placeholder="solid, dashed, dotted, ..." data-update-on="change"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify719735', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Line style(s) for diagonal reference lines (solid, dashed, dotted, dotdash, longdash, twodash)'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify3462587">
#>             <label class="control-label" id="survivalCurve-abline.opacities-label" for="survivalCurve-abline.opacities">Ab Opacities (0-1)</label>
#>             <input id="survivalCurve-abline.opacities" type="text" class="shiny-input-text form-control" value="1" data-update-on="change"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify3462587', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Opacity of diagonal reference lines between 0 (transparent) and 1 (opaque), as comma-separated values'})}, 500)});</script>
#>         </div>
#>       </div>
#>     </div>
#>   </div>
#> </div>
#> <div class="module-tack" style="margin-top: 12px;">
#>   <div class="module-tack-switch" style="margin-bottom: 4px;">
#>     <div class="form-group shiny-input-container">
#>       <div class="material-switch">
#>         <label for="survivalCurve-auto.update" style="padding-right: 10px;">Auto Update</label>
#>         <input id="survivalCurve-auto.update" type="checkbox" checked="checked"/>
#>         <label class="switch label-success bg-success" for="survivalCurve-auto.update"></label>
#>       </div>
#>     </div>
#>   </div>
#>   <div class="module-tack-buttons" style="display: flex; flex-wrap: wrap; gap: 8px;">
#>     <button class="btn btn-default action-button btn-primary" id="survivalCurve-update" style="flex: 1 1 45%;" type="button"><span class="action-label">Update</span></button>
#>     <button class="btn btn-default action-button btn-secondary" id="survivalCurve-reset" style="flex: 1 1 45%;" type="button"><span class="action-label">Reset</span></button>
#>     <a aria-disabled="true" class="btn btn-default shiny-download-link disabled btn-secondary viz-source-download" data-viz-source-ns="survivalCurve-" download href="" id="survivalCurve-download.source" style="flex: 1 1 100%;" tabindex="-1" target="_blank">
#>       <i class="far fa-file-code" role="presentation" aria-label="file-code icon"></i>
#>       Source Download
#>     </a>
#>     <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('survivalCurve-download.source', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Download the plot as a self-contained HTML file and as SVG and PNG images of it as it looks now, along with the plot source data and statistics (if applicable) as CSV files.'})}, 500)});</script>
#>   </div>
#> </div>
```
