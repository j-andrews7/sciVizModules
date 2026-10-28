# Input UI components for the crisprScreenRank module

This should be placed in the UI where the inputs should be shown, with
an `id` that matches the `id` used in the
[`crisprScreenRankServer()`](https://j-andrews7.github.io/sciVizModules/reference/crisprScreenRankServer.md)
and
[`crisprScreenRankOutputUI()`](https://j-andrews7.github.io/sciVizModules/reference/crisprScreenRankOutputUI.md)
functions.

## Usage

``` r
crisprScreenRankInputsUI(
  id,
  data,
  defaults = NULL,
  title = "CRISPR Screen Settings",
  columns = 2
)
```

## Arguments

- id:

  The ID for the Shiny module.

- data:

  A MAGeCK RRA or MLE gene summary, from
  [`read_mageck()`](https://j-andrews7.github.io/sciVizModules/reference/read_mageck.md)
  or read with
  [`read.delim()`](https://rdrr.io/r/utils/read.table.html).

- defaults:

  A named list of default values for the inputs.

- title:

  An optional title for the UI grid.

- columns:

  Number of columns for the UI grid.

## Value

A Shiny tagList containing the UI elements

## Details

The module draws the gene rank plot of a pooled CRISPR screen from a
MAGeCK gene summary
([`read_mageck()`](https://j-andrews7.github.io/sciVizModules/reference/read_mageck.md)):
every gene, ranked by the statistic on the y-axis, with depleted
(negative selection) genes on the left, enriched (positive selection)
genes on the right and hits below the FDR cut-off coloured. Every
statistic is signed: negative for depletion, positive for enrichment.

A `mageck test` (RRA) summary plots the log2 fold change, or the RRA
score or FDR of the side (depletion or enrichment) each gene scores
better on. A `mageck mle` summary plots the beta, z-score or FDR of one
condition, the FDR signed by the beta. It wraps
[`VizModules::dittoViz_scatterPlotInputsUI()`](https://j-andrews7.github.io/VizModules/reference/dittoViz_scatterPlotInputsUI.html),
so the scatter controls (point highlighting by gene, hover data,
colours) all apply; those inputs are documented there. Genes are
labelled through its Annotations tab: list them under "Points to
Highlight" (matched against the `gene` column, the default "Annotate
By"), or select points on the plot.

## Plot parameters and defaults

The following parameters can be accessed via UI inputs and/or the
`defaults` argument:

- `metric` - y-axis, and the statistic genes are ranked by: `"lfc"`
  (log2 fold change; beta for MLE), `"score"` (signed -log10 RRA score;
  z-score for MLE) or `"fdr"` (signed -log10 FDR) (default: `"lfc"`)

- `condition` - MLE only: the condition plotted (default: the first)

- `fdr.threshold` - FDR below which a gene is a hit (default: 0.05)

- `color.panel` - Colours of "Depleted", "Enriched" and "n.s." (scatter
  colour picker)

- All other
  [`VizModules::dittoViz_scatterPlotInputsUI()`](https://j-andrews7.github.io/VizModules/reference/dittoViz_scatterPlotInputsUI.html)
  parameters

## See also

[`read_mageck()`](https://j-andrews7.github.io/sciVizModules/reference/read_mageck.md),
[`crisprScreenRankOutputUI()`](https://j-andrews7.github.io/sciVizModules/reference/crisprScreenRankOutputUI.md),
[`crisprScreenRankServer()`](https://j-andrews7.github.io/sciVizModules/reference/crisprScreenRankServer.md),
[`crisprScreenRankApp()`](https://j-andrews7.github.io/sciVizModules/reference/crisprScreenRankApp.md)

## Author

Jared Andrews

## Examples

``` r
library(sciVizModules)
screen <- read_mageck(system.file("extdata", "example_mageck.gene_summary.txt.gz",
    package = "sciVizModules"))
crisprScreenRankInputsUI("crispr", screen)
#> <div class="vizmodules-input-grid" style="--viz-input-columns: 2;">
#>   <div class="vizmodules-input-cell">
#>     <div class="form-group shiny-input-container" style="width:100%;" id="tipify4848028">
#>       <label class="control-label" id="crispr-metric-label" for="crispr-metric">Y-axis</label>
#>       <div id="crispr-metric" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="change">
#>         <script type="application/json" data-for="crispr-metric">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["Log2 fold change","Signed -log10(RRA score)","Signed -log10(FDR)"],"value":["lfc","score","fdr"]}},"config":{"multiple":false,"search":false,"selectedValue":"lfc","hideClearButton":true,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":false,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":true,"disableOptionGroupCheckbox":true,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>       </div>
#>     </div>
#>     <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify4848028', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Gene-level statistic on the y-axis, negative for depletion and positive for enrichment. Genes are ranked by it.'})}, 500)});</script>
#>   </div>
#>   <div class="vizmodules-input-cell">
#>     <div class="form-group shiny-input-container" id="tipify2472191">
#>       <label class="control-label" id="crispr-fdr.threshold-label" for="crispr-fdr.threshold">FDR Threshold</label>
#>       <input id="crispr-fdr.threshold" type="number" class="shiny-input-number form-control" value="0.05" data-update-on="change" min="0" max="1" step="0.01"/>
#>     </div>
#>     <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify2472191', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Genes below this FDR are hits, depleted or enriched.'})}, 500)});</script>
#>   </div>
#> </div>
#> <h3>CRISPR Screen Settings</h3>
#> <div class="tabbable vizmodules-input-tabs">
#>   <ul class="nav nav-tabs shiny-tab-input" id="crispr-scatterPlotTabsetPanel" data-tabsetid="2966">
#>     <li class="active">
#>       <a href="#tab-2966-1" data-toggle="tab" data-bs-toggle="tab" data-value="Data">Data</a>
#>     </li>
#>     <li>
#>       <a href="#tab-2966-2" data-toggle="tab" data-bs-toggle="tab" data-value="Adjustments">Adjustments</a>
#>     </li>
#>     <li>
#>       <a href="#tab-2966-3" data-toggle="tab" data-bs-toggle="tab" data-value="Points">Points</a>
#>     </li>
#>     <li>
#>       <a href="#tab-2966-4" data-toggle="tab" data-bs-toggle="tab" data-value="Colors">Colors</a>
#>     </li>
#>     <li>
#>       <a href="#tab-2966-5" data-toggle="tab" data-bs-toggle="tab" data-value="Facet">Facet</a>
#>     </li>
#>     <li>
#>       <a href="#tab-2966-6" data-toggle="tab" data-bs-toggle="tab" data-value="Annotations">Annotations</a>
#>     </li>
#>     <li>
#>       <a href="#tab-2966-7" data-toggle="tab" data-bs-toggle="tab" data-value="Legend">Legend</a>
#>     </li>
#>     <li>
#>       <a href="#tab-2966-8" data-toggle="tab" data-bs-toggle="tab" data-value="Trajectory">Trajectory</a>
#>     </li>
#>     <li>
#>       <a href="#tab-2966-9" data-toggle="tab" data-bs-toggle="tab" data-value="Marginals">Marginals</a>
#>     </li>
#>     <li>
#>       <a href="#tab-2966-10" data-toggle="tab" data-bs-toggle="tab" data-value="Plotly">Plotly</a>
#>     </li>
#>     <li>
#>       <a href="#tab-2966-11" data-toggle="tab" data-bs-toggle="tab" data-value="Extras">Extras</a>
#>     </li>
#>     <li>
#>       <a href="#tab-2966-12" data-toggle="tab" data-bs-toggle="tab" data-value="Lines">Lines</a>
#>     </li>
#>     <li>
#>       <a href="#tab-2966-13" data-toggle="tab" data-bs-toggle="tab" data-value="Axes">Axes</a>
#>     </li>
#>   </ul>
#>   <div class="tab-content" data-tabsetid="2966">
#>     <div class="tab-pane active" data-value="Data" id="tab-2966-1">
#>       <div class="vizmodules-input-grid" style="--viz-input-columns: 2;">
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" style="width:100%;" id="tipify6865692">
#>             <label class="control-label" id="crispr-x.by-label" for="crispr-x.by">X Data</label>
#>             <div id="crispr-x.by" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="change">
#>               <script type="application/json" data-for="crispr-x.by">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["gene","n.sgrna","neg.score","neg.p","neg.fdr","neg.rank","neg.goodsgrna","neg.lfc","pos.score","pos.p","pos.fdr","pos.rank","pos.goodsgrna","pos.lfc","screen.rank","screen.lfc","screen.fdr","screen.metric","screen.group"],"value":["gene","n.sgrna","neg.score","neg.p","neg.fdr","neg.rank","neg.goodsgrna","neg.lfc","pos.score","pos.p","pos.fdr","pos.rank","pos.goodsgrna","pos.lfc","screen.rank","screen.lfc","screen.fdr","screen.metric","screen.group"]}},"config":{"multiple":false,"search":true,"selectedValue":"screen.rank","hideClearButton":true,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":false,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":true,"disableOptionGroupCheckbox":true,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify6865692', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Single strings denoting the name of a column of `data_frame` containing numeric data to use for the x- and y-axis of the scatterplot.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" style="width:100%;" id="tipify1636232">
#>             <label class="control-label" id="crispr-y.by-label" for="crispr-y.by">Y Data</label>
#>             <div id="crispr-y.by" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="change">
#>               <script type="application/json" data-for="crispr-y.by">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["gene","n.sgrna","neg.score","neg.p","neg.fdr","neg.rank","neg.goodsgrna","neg.lfc","pos.score","pos.p","pos.fdr","pos.rank","pos.goodsgrna","pos.lfc","screen.rank","screen.lfc","screen.fdr","screen.metric","screen.group"],"value":["gene","n.sgrna","neg.score","neg.p","neg.fdr","neg.rank","neg.goodsgrna","neg.lfc","pos.score","pos.p","pos.fdr","pos.rank","pos.goodsgrna","pos.lfc","screen.rank","screen.lfc","screen.fdr","screen.metric","screen.group"]}},"config":{"multiple":false,"search":true,"selectedValue":"screen.metric","hideClearButton":true,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":false,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":true,"disableOptionGroupCheckbox":true,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify1636232', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Single strings denoting the name of a column of `data_frame` containing numeric data to use for the x- and y-axis of the scatterplot.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" style="width:100%;" id="tipify9528248">
#>             <label class="control-label" id="crispr-color.by-label" for="crispr-color.by">Color By</label>
#>             <div id="crispr-color.by" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="change">
#>               <script type="application/json" data-for="crispr-color.by">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["(none)","n.sgrna","neg.score","neg.p","neg.fdr","neg.rank","neg.goodsgrna","neg.lfc","pos.score","pos.p","pos.fdr","pos.rank","pos.goodsgrna","pos.lfc","screen.rank","screen.lfc","screen.fdr","screen.metric","screen.group"],"value":["","n.sgrna","neg.score","neg.p","neg.fdr","neg.rank","neg.goodsgrna","neg.lfc","pos.score","pos.p","pos.fdr","pos.rank","pos.goodsgrna","pos.lfc","screen.rank","screen.lfc","screen.fdr","screen.metric","screen.group"]}},"config":{"multiple":false,"search":true,"selectedValue":"screen.group","hideClearButton":true,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":false,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":true,"disableOptionGroupCheckbox":true,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify9528248', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Single string denoting the name of a column of `data_frame` to use for setting the color of plotted points. Alternatively, a string vector naming multiple such columns of data to plot at once.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" style="width:100%;" id="tipify3218546">
#>             <label class="control-label" id="crispr-size.by-label" for="crispr-size.by">Size By</label>
#>             <div id="crispr-size.by" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="change">
#>               <script type="application/json" data-for="crispr-size.by">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["(none)","n.sgrna","neg.score","neg.p","neg.fdr","neg.rank","neg.goodsgrna","neg.lfc","pos.score","pos.p","pos.fdr","pos.rank","pos.goodsgrna","pos.lfc","screen.rank","screen.lfc","screen.fdr","screen.metric"],"value":["","n.sgrna","neg.score","neg.p","neg.fdr","neg.rank","neg.goodsgrna","neg.lfc","pos.score","pos.p","pos.fdr","pos.rank","pos.goodsgrna","pos.lfc","screen.rank","screen.lfc","screen.fdr","screen.metric"]}},"config":{"multiple":false,"search":true,"selectedValue":"","hideClearButton":true,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":false,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":true,"disableOptionGroupCheckbox":true,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify3218546', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Number which sets the size of data points. Default = 1. Alternatively, a single string denoting the name of a column of `data_frame` to use for setting the size of plotted points.  NOTE: When providing a column name and using `do.hover = TRUE`, the legend will not include meaningful size encoding information.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" style="width:100%;" id="tipify3615341">
#>             <label class="control-label" id="crispr-shape.by-label" for="crispr-shape.by">Shape By</label>
#>             <div id="crispr-shape.by" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="change">
#>               <script type="application/json" data-for="crispr-shape.by">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["(none)","screen.group"],"value":["","screen.group"]}},"config":{"multiple":false,"search":false,"selectedValue":"","hideClearButton":true,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":false,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":true,"disableOptionGroupCheckbox":true,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify3615341', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Single string denoting the name of a column of `data_frame` containing discrete data to use for setting the shape of plotted points.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" style="width:100%;" id="tipify8877234">
#>             <label class="control-label" id="crispr-split.by-label" for="crispr-split.by">Split By</label>
#>             <div id="crispr-split.by" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="close">
#>               <script type="application/json" data-for="crispr-split.by">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["(none)","screen.group"],"value":["","screen.group"]}},"config":{"multiple":true,"search":false,"selectedValue":"","hideClearButton":false,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":true,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":false,"disableOptionGroupCheckbox":false,"disabled":false,"dropboxWrapper":"body","zIndex":1060,"maxValues":2}}</script>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify8877234', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': '1 or 2 strings denoting the name(s) of column(s) of `data_frame` containing discrete data to use for faceting / separating data points into separate plots.  When 2 columns are named, c(row,col), the first is used as rows and the second is used for columns of the resulting facet grid.  When 1 column is named, shape control can be achieved with `split.nrow` and `split.ncol`'})}, 500)});</script>
#>         </div>
#>       </div>
#>     </div>
#>     <div class="tab-pane" data-value="Adjustments" id="tab-2966-2">
#>       <div class="vizmodules-input-grid" style="--viz-input-columns: 2;">
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" style="width:100%;" id="tipify8280144">
#>             <label class="control-label" id="crispr-x.adjustment-label" for="crispr-x.adjustment">X Adjustment</label>
#>             <div id="crispr-x.adjustment" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="change">
#>               <script type="application/json" data-for="crispr-x.adjustment">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["(none)","z-score","relative.to.max"],"value":["","z-score","relative.to.max"]}},"config":{"multiple":false,"search":false,"selectedValue":"","hideClearButton":true,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":false,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":true,"disableOptionGroupCheckbox":true,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify8280144', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'A recognized string indicating whether numeric `x.by`, `y.by`, and `color.by` data should be used directly (default) or should be adjusted to be itemize{ item{"z-score": scaled with the scale() function to produce a relative-to-mean z-score representation} item{"relative.to.max": divided by the maximum value to give percent of max values between [0,1]} }  Ignored if the target data is not numeric as these known adjustments target numeric data only.  In order to leave the unedited data available for use in other features, the adjusted data are put in a new column and that new column is used for plotting. The Adjustment Function is applied first, and the X Adjustment then rescales the result (e.g. log10, then z-score).'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" style="width:100%;" id="tipify1006565">
#>             <label class="control-label" id="crispr-y.adjustment-label" for="crispr-y.adjustment">Y Adjustment</label>
#>             <div id="crispr-y.adjustment" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="change">
#>               <script type="application/json" data-for="crispr-y.adjustment">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["(none)","z-score","relative.to.max"],"value":["","z-score","relative.to.max"]}},"config":{"multiple":false,"search":false,"selectedValue":"","hideClearButton":true,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":false,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":true,"disableOptionGroupCheckbox":true,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify1006565', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'A recognized string indicating whether numeric `x.by`, `y.by`, and `color.by` data should be used directly (default) or should be adjusted to be itemize{ item{"z-score": scaled with the scale() function to produce a relative-to-mean z-score representation} item{"relative.to.max": divided by the maximum value to give percent of max values between [0,1]} }  Ignored if the target data is not numeric as these known adjustments target numeric data only.  In order to leave the unedited data available for use in other features, the adjusted data are put in a new column and that new column is used for plotting. The Adjustment Function is applied first, and the Y Adjustment then rescales the result (e.g. log10, then z-score).'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" style="width:100%;" id="tipify9060515">
#>             <label class="control-label" id="crispr-color.adjustment-label" for="crispr-color.adjustment">Color Adjustment</label>
#>             <div id="crispr-color.adjustment" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="change">
#>               <script type="application/json" data-for="crispr-color.adjustment">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["(none)","z-score","relative.to.max"],"value":["","z-score","relative.to.max"]}},"config":{"multiple":false,"search":false,"selectedValue":"","hideClearButton":true,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":false,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":true,"disableOptionGroupCheckbox":true,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify9060515', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'A recognized string indicating whether numeric `x.by`, `y.by`, and `color.by` data should be used directly (default) or should be adjusted to be itemize{ item{"z-score": scaled with the scale() function to produce a relative-to-mean z-score representation} item{"relative.to.max": divided by the maximum value to give percent of max values between [0,1]} }  Ignored if the target data is not numeric as these known adjustments target numeric data only.  In order to leave the unedited data available for use in other features, the adjusted data are put in a new column and that new column is used for plotting. The Adjustment Function is applied first, and the Color Adjustment then rescales the result (e.g. log10, then z-score).'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" style="width:100%;" id="tipify7727303">
#>             <label class="control-label" id="crispr-x.adj.fxn-label" for="crispr-x.adj.fxn">X Adjustment Function</label>
#>             <div id="crispr-x.adj.fxn" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="change">
#>               <script type="application/json" data-for="crispr-x.adj.fxn">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["(none)","log2","log","log10","neg_log10","log1p","as.factor","abs","sqrt"],"value":["","log2","log","log10","neg_log10","log1p","as.factor","abs","sqrt"]}},"config":{"multiple":false,"search":false,"selectedValue":"","hideClearButton":true,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":false,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":true,"disableOptionGroupCheckbox":true,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify7727303', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'If you wish to apply a function to edit the `x.by`, `y.by`, or `color.by` data before use, in a way not possible with the `color.adjustment` input, this input can be given a function which takes in a vector of values as input and returns a vector of values of the same length as output.  For example, `function(x) {log2(x)`} or `as.factor`.  In order to leave the unedited data available for use in other features, the adjusted data are put in a new column and that new column is used for plotting. The Adjustment Function is applied first, and the X Adjustment then rescales the result (e.g. log10, then z-score).'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" style="width:100%;" id="tipify3833707">
#>             <label class="control-label" id="crispr-y.adj.fxn-label" for="crispr-y.adj.fxn">Y Adjustment Function</label>
#>             <div id="crispr-y.adj.fxn" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="change">
#>               <script type="application/json" data-for="crispr-y.adj.fxn">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["(none)","log2","log","log10","neg_log10","log1p","as.factor","abs","sqrt"],"value":["","log2","log","log10","neg_log10","log1p","as.factor","abs","sqrt"]}},"config":{"multiple":false,"search":false,"selectedValue":"","hideClearButton":true,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":false,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":true,"disableOptionGroupCheckbox":true,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify3833707', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'If you wish to apply a function to edit the `x.by`, `y.by`, or `color.by` data before use, in a way not possible with the `color.adjustment` input, this input can be given a function which takes in a vector of values as input and returns a vector of values of the same length as output.  For example, `function(x) {log2(x)`} or `as.factor`.  In order to leave the unedited data available for use in other features, the adjusted data are put in a new column and that new column is used for plotting. The Adjustment Function is applied first, and the Y Adjustment then rescales the result (e.g. log10, then z-score).'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" style="width:100%;" id="tipify9996524">
#>             <label class="control-label" id="crispr-color.adj.fxn-label" for="crispr-color.adj.fxn">Color Adjustment Function</label>
#>             <div id="crispr-color.adj.fxn" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="change">
#>               <script type="application/json" data-for="crispr-color.adj.fxn">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["(none)","log2","log","log10","neg_log10","log1p","as.factor","abs","sqrt"],"value":["","log2","log","log10","neg_log10","log1p","as.factor","abs","sqrt"]}},"config":{"multiple":false,"search":false,"selectedValue":"","hideClearButton":true,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":false,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":true,"disableOptionGroupCheckbox":true,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify9996524', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'If you wish to apply a function to edit the `x.by`, `y.by`, or `color.by` data before use, in a way not possible with the `color.adjustment` input, this input can be given a function which takes in a vector of values as input and returns a vector of values of the same length as output.  For example, `function(x) {log2(x)`} or `as.factor`.  In order to leave the unedited data available for use in other features, the adjusted data are put in a new column and that new column is used for plotting. The Adjustment Function is applied first, and the Color Adjustment then rescales the result (e.g. log10, then z-score).'})}, 500)});</script>
#>         </div>
#>       </div>
#>     </div>
#>     <div class="tab-pane" data-value="Points" id="tab-2966-3">
#>       <div class="vizmodules-input-grid" style="--viz-input-columns: 2;">
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify3492991">
#>             <label class="control-label" id="crispr-size-label" for="crispr-size">Point Size</label>
#>             <input id="crispr-size" type="number" class="shiny-input-number form-control" value="1" data-update-on="change" min="0.1"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify3492991', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Number which sets the size of data points. Default = 1. Alternatively, a single string denoting the name of a column of `data_frame` to use for setting the size of plotted points.  NOTE: When providing a column name and using `do.hover = TRUE`, the legend will not include meaningful size encoding information.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify9473182">
#>             <label class="control-label" id="crispr-size.min-label" for="crispr-size.min">Min Point Size</label>
#>             <input id="crispr-size.min" type="number" class="shiny-input-number form-control" value="1" data-update-on="change" min="0" step="0.5"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify9473182', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Smallest point size, drawn for the Size Scale Min value of the &#39;Size By&#39; column.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify2161000">
#>             <label class="control-label" id="crispr-size.max-label" for="crispr-size.max">Max Point Size</label>
#>             <input id="crispr-size.max" type="number" class="shiny-input-number form-control" value="6" data-update-on="change" min="0" step="0.5"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify2161000', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Largest point size, drawn for the Size Scale Max value of the &#39;Size By&#39; column.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify320928">
#>             <label class="control-label" id="crispr-size.scale.min-label" for="crispr-size.scale.min">Size Scale Min</label>
#>             <input id="crispr-size.scale.min" type="number" class="shiny-input-number form-control" value="NA" data-update-on="change"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify320928', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': '&#39;Size By&#39; value drawn at the Min Point Size, and where the size legend starts. Leave blank to use the column&#39;s minimum. Smaller values are drawn at the Min Point Size.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify1453159">
#>             <label class="control-label" id="crispr-size.scale.max-label" for="crispr-size.scale.max">Size Scale Max</label>
#>             <input id="crispr-size.scale.max" type="number" class="shiny-input-number form-control" value="NA" data-update-on="change"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify1453159', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': '&#39;Size By&#39; value drawn at the Max Point Size, and where the size legend ends. Leave blank to use the column&#39;s maximum. Larger values are drawn at the Max Point Size.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify8543839">
#>             <label class="control-label" id="crispr-opacity-label" for="crispr-opacity">Point Opacity</label>
#>             <input id="crispr-opacity" type="number" class="shiny-input-number form-control" value="1" data-update-on="change" min="0" max="1" step="0.05"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify8543839', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Number between 0 and 1. 1 = opaque. 0 = invisible. Default = 1. (In terms of typical ggplot variables, = alpha) Alternatively, a single string denoting the name of a column of `data_frame` to use for setting the opacity of plotted points.  NOTE: When providing a column name and using `do.hover = TRUE`, the legend will not include meaningful opacity encoding information.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify2131493">
#>             <div class="checkbox">
#>               <label>
#>                 <input id="crispr-show.others" type="checkbox" class="shiny-input-checkbox" checked="checked"/>
#>                 <span>Show Others</span>
#>               </label>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify2131493', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Logical. TRUE by default, whether rows not targeted by `rows.use` should be shown in the background in light gray.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify2103108">
#>             <div class="checkbox">
#>               <label>
#>                 <input id="crispr-split.show.all.others" type="checkbox" class="shiny-input-checkbox" checked="checked"/>
#>                 <span>Show Split Others</span>
#>               </label>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify2103108', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Logical which sets whether gray "others" points of facets should include all points of other facets (`TRUE`) versus just points left out by `rows.use` which would exist in the current facet (`FALSE`).'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" style="width:100%;" id="tipify395207">
#>             <label class="control-label" id="crispr-plot.order-label" for="crispr-plot.order">Plot Order</label>
#>             <div id="crispr-plot.order" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="change">
#>               <script type="application/json" data-for="crispr-plot.order">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["unordered","increasing","decreasing","randomize"],"value":["unordered","increasing","decreasing","randomize"]}},"config":{"multiple":false,"search":false,"selectedValue":"unordered","hideClearButton":true,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":false,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":true,"disableOptionGroupCheckbox":true,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify395207', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'String. If the data should be plotted based on the order of the color data, sets whether to plot in "increasing", "decreasing", or "randomize"d order.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify9447748">
#>             <label class="control-label" id="crispr-shape.panel-label" for="crispr-shape.panel">Shape Panel</label>
#>             <input id="crispr-shape.panel" type="text" class="shiny-input-text form-control" value="16, 15, 17, 23, 25, 8" data-update-on="change"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify9447748', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Vector of integers, corresponding to ggplot shapes, which sets what shapes to use in conjunction with `shape.by`. When nothing is supplied to `shape.by`, only the first value is used. Default is a set of 6, `c(16,15,17,23,25,8)`, the first being a simple, solid, circle.'})}, 500)});</script>
#>         </div>
#>       </div>
#>     </div>
#>     <div class="tab-pane" data-value="Colors" id="tab-2966-4">
#>       <div class="vizmodules-input-grid" style="--viz-input-columns: 2;">
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour" id="tipify2449280">
#>             <label class="control-label" for="crispr-min.color">Min Color</label>
#>             <input id="crispr-min.color" type="text" class="form-control shiny-colour-input" data-init-value="#F0E442" data-show-colour="both" data-palette="square"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify2449280', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Color for `min` value of numeric `color.by`-data. Default = yellow'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour" id="tipify7811225">
#>             <label class="control-label" for="crispr-max.color">Max Color</label>
#>             <input id="crispr-max.color" type="text" class="form-control shiny-colour-input" data-init-value="#0072B2" data-show-colour="both" data-palette="square"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify7811225', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Color for `max` value of numeric `color.by`-data. Default = blue'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour" id="tipify2882372">
#>             <label class="control-label" for="crispr-contour.color">Contour Color</label>
#>             <input id="crispr-contour.color" type="text" class="form-control shiny-colour-input" data-init-value="black" data-show-colour="both" data-palette="square"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify2882372', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'String that sets the color of the `do.contour` contours.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" style="width:100%;" id="tipify8753579">
#>             <label class="control-label" id="crispr-contour.linetype-label" for="crispr-contour.linetype">Contour Linetype</label>
#>             <div id="crispr-contour.linetype" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="change">
#>               <script type="application/json" data-for="crispr-contour.linetype">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["solid","dashed","dotted","dotdash","longdash","twodash"],"value":["solid","dashed","dotted","dotdash","longdash","twodash"]}},"config":{"multiple":false,"search":false,"selectedValue":"solid","hideClearButton":true,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":false,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":true,"disableOptionGroupCheckbox":true,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify8753579', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'String or numeric which sets the type of line used for `do.contour` contours. Defaults to "solid", but see `link[ggplot2]{linetype`} for other options.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div id="crispr-color.panel.ui" class="shiny-html-output"></div>
#>         </div>
#>       </div>
#>     </div>
#>     <div class="tab-pane" data-value="Facet" id="tab-2966-5">
#>       <div class="vizmodules-input-grid" style="--viz-input-columns: 2;">
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify2957501">
#>             <label class="control-label" id="crispr-split.nrow-label" for="crispr-split.nrow">Rows</label>
#>             <input id="crispr-split.nrow" type="number" class="shiny-input-number form-control" value="NA" data-update-on="change" min="0" step="1"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify2957501', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Integers which set the dimensions of faceting/splitting when faceting by a single feature.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify9835254">
#>             <label class="control-label" id="crispr-split.ncol-label" for="crispr-split.ncol">Columns</label>
#>             <input id="crispr-split.ncol" type="number" class="shiny-input-number form-control" value="NA" data-update-on="change" min="0" step="1"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify9835254', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Integers which set the dimensions of faceting/splitting when faceting by a single feature.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" style="width:100%;" id="tipify5898375">
#>             <label class="control-label" id="crispr-multivar.split.dir-label" for="crispr-multivar.split.dir">Multivar Split Dir</label>
#>             <div id="crispr-multivar.split.dir" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="change">
#>               <script type="application/json" data-for="crispr-multivar.split.dir">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["col","row"],"value":["col","row"]}},"config":{"multiple":false,"search":false,"selectedValue":"col","hideClearButton":true,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":false,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":true,"disableOptionGroupCheckbox":true,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify5898375', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': '"row" or "col", sets the direction of faceting used for &#39;var&#39; values when: itemize{ item `var` is given multiple column names item AND `split.by` is used to provide an additional feature to facet by }'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" style="width:100%;" id="tipify7591584">
#>             <label class="control-label" id="crispr-split.adjust.scales-label" for="crispr-split.adjust.scales">Facet Scales</label>
#>             <div id="crispr-split.adjust.scales" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="change">
#>               <script type="application/json" data-for="crispr-split.adjust.scales">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["fixed","free","free_x","free_y"],"value":["fixed","free","free_x","free_y"]}},"config":{"multiple":false,"search":false,"selectedValue":"fixed","hideClearButton":true,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":false,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":true,"disableOptionGroupCheckbox":true,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify7591584', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Control whether facet panels share the same axis scales or allow them to vary independently'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify8360753">
#>             <label class="control-label" id="crispr-subplot.margin.x-label" for="crispr-subplot.margin.x">Subplot Spacing (Horizontal)</label>
#>             <input id="crispr-subplot.margin.x" type="number" class="shiny-input-number form-control" value="0.03" data-update-on="change" min="0" max="1" step="0.01"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify8360753', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Horizontal spacing between facet panel columns as a fraction of the plot area (e.g. 0.03). Only applies when faceting is active.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify7628194">
#>             <label class="control-label" id="crispr-subplot.margin.y-label" for="crispr-subplot.margin.y">Subplot Spacing (Vertical)</label>
#>             <input id="crispr-subplot.margin.y" type="number" class="shiny-input-number form-control" value="0.1" data-update-on="change" min="0" max="1" step="0.01"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify7628194', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Vertical spacing between facet panel rows as a fraction of the plot area (e.g. 0.1). Only applies when faceting is active.'})}, 500)});</script>
#>         </div>
#>       </div>
#>     </div>
#>     <div class="tab-pane" data-value="Annotations" id="tab-2966-6">
#>       <div class="vizmodules-input-grid" style="--viz-input-columns: 2;">
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" style="width:100%;" id="tipify4172699">
#>             <label class="control-label" id="crispr-annotate.by-label" for="crispr-annotate.by">Annotate By</label>
#>             <div id="crispr-annotate.by" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="change">
#>               <script type="application/json" data-for="crispr-annotate.by">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["(none)","gene","n.sgrna","neg.score","neg.p","neg.fdr","neg.rank","neg.goodsgrna","neg.lfc","pos.score","pos.p","pos.fdr","pos.rank","pos.goodsgrna","pos.lfc","screen.rank","screen.lfc","screen.fdr","screen.metric","screen.group"],"value":["","gene","n.sgrna","neg.score","neg.p","neg.fdr","neg.rank","neg.goodsgrna","neg.lfc","pos.score","pos.p","pos.fdr","pos.rank","pos.goodsgrna","pos.lfc","screen.rank","screen.lfc","screen.fdr","screen.metric","screen.group"]}},"config":{"multiple":false,"search":true,"selectedValue":"gene","hideClearButton":true,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":false,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":true,"disableOptionGroupCheckbox":true,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify4172699', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Select a column whose values will be used to identify points for highlighting and annotation'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="shiny-input-textarea form-group shiny-input-container" id="tipify1380749">
#>             <label class="control-label" id="crispr-highlight.points-label" for="crispr-highlight.points">Points to Highlight</label>
#>             <textarea id="crispr-highlight.points" class="form-control" placeholder="Values from &#39;Annotate by&#39; column&#10;(comma, space, or newline delimited)" rows="3" data-update-on="change"></textarea>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify1380749', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Enter specific values from the &#39;Annotate By&#39; column to highlight those points on the plot. Separate values that contain spaces with commas or new lines.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour" id="tipify808450">
#>             <label class="control-label" for="crispr-highlight.color">Highlight Fill</label>
#>             <input id="crispr-highlight.color" type="text" class="form-control shiny-colour-input" data-init-value="#00FFF7" data-show-colour="both" data-palette="square" data-allow-alpha="true"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify808450', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Choose the fill color for highlighted points'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify6559826">
#>             <label class="control-label" id="crispr-highlight.size-label" for="crispr-highlight.size">Highlight Size</label>
#>             <input id="crispr-highlight.size" type="number" class="shiny-input-number form-control" value="7" data-update-on="change" min="0.1" step="0.5"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify6559826', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Set the size of highlighted points on the plot'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour" id="tipify6020038">
#>             <label class="control-label" for="crispr-highlight.border.color">Highlight Border Color</label>
#>             <input id="crispr-highlight.border.color" type="text" class="form-control shiny-colour-input" data-init-value="#000000" data-show-colour="both" data-palette="square"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify6020038', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Choose the border color for highlighted points'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify6569958">
#>             <label class="control-label" id="crispr-highlight.border.width-label" for="crispr-highlight.border.width">Highlight Border Width</label>
#>             <input id="crispr-highlight.border.width" type="number" class="shiny-input-number form-control" value="1" data-update-on="change" min="0" step="0.25"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify6569958', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Set the width of the border around highlighted points'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify3293172">
#>             <div class="checkbox">
#>               <label>
#>                 <input id="crispr-highlight.auto.annotate" type="checkbox" class="shiny-input-checkbox" checked="checked"/>
#>                 <span>Auto-annotate Highlights</span>
#>               </label>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify3293172', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'When enabled, automatically adds text labels to highlighted points using their &#39;Annotate By&#39; values'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour" id="tipify9794742">
#>             <label class="control-label" for="crispr-annotation.color">Annotation Color</label>
#>             <input id="crispr-annotation.color" type="text" class="form-control shiny-colour-input" data-init-value="black" data-show-colour="both" data-palette="square"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify9794742', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Set the text color for annotation labels'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify7151861">
#>             <label class="control-label" id="crispr-annotation.ax-label" for="crispr-annotation.ax">Annotation X Offset</label>
#>             <input id="crispr-annotation.ax" type="number" class="shiny-input-number form-control" value="20" data-update-on="change" step="1"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify7151861', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Horizontal pixel offset of annotation labels from their target points'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify8726303">
#>             <label class="control-label" id="crispr-annotation.ay-label" for="crispr-annotation.ay">Annotation Y Offset</label>
#>             <input id="crispr-annotation.ay" type="number" class="shiny-input-number form-control" value="-20" data-update-on="change" step="1"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify8726303', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Vertical pixel offset of annotation labels from their target points (negative values move up)'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify9832837">
#>             <label class="control-label" id="crispr-annotation.size-label" for="crispr-annotation.size">Annotation Size</label>
#>             <input id="crispr-annotation.size" type="number" class="shiny-input-number form-control" value="10" data-update-on="change" min="1" step="0.5"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify9832837', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Set the font size of annotation text labels in points'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify2185630">
#>             <div class="checkbox">
#>               <label>
#>                 <input id="crispr-annotation.showarrow" type="checkbox" class="shiny-input-checkbox" checked="checked"/>
#>                 <span>Show Arrow</span>
#>               </label>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify2185630', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Toggle whether an arrow is drawn from the annotation label to the target point'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour" id="tipify6645300">
#>             <label class="control-label" for="crispr-annotation.arrowcolor">Arrow Color</label>
#>             <input id="crispr-annotation.arrowcolor" type="text" class="form-control shiny-colour-input" data-init-value="black" data-show-colour="both" data-palette="square"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify6645300', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Set the color of the annotation arrow connecting the label to the point'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify3895640">
#>             <label class="control-label" id="crispr-annotation.arrowhead-label" for="crispr-annotation.arrowhead">Arrowhead Style</label>
#>             <input id="crispr-annotation.arrowhead" type="number" class="shiny-input-number form-control" value="2" data-update-on="change" min="0" max="7" step="1"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify3895640', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Choose the arrowhead style (0-7) for annotation arrows, where 0 is no arrowhead'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify460637">
#>             <label class="control-label" id="crispr-annotation.arrowwidth-label" for="crispr-annotation.arrowwidth">Arrow Linewidth</label>
#>             <input id="crispr-annotation.arrowwidth" type="number" class="shiny-input-number form-control" value="1.5" data-update-on="change" min="0.1" step="0.25"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify460637', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Set the line width of the annotation arrow'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <button id="crispr-annotation.clear" type="button" class="btn btn-default action-button"><span class="action-label">Clear Annotations</span></button>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('crispr-annotation.clear', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Remove all annotation labels and arrows from the current plot'})}, 500)});</script>
#>         </div>
#>       </div>
#>     </div>
#>     <div class="tab-pane" data-value="Legend" id="tab-2966-7">
#>       <div class="vizmodules-input-grid" style="--viz-input-columns: 2;">
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify6169145">
#>             <label class="control-label" id="crispr-legend.color.title-label" for="crispr-legend.color.title">Legend Title</label>
#>             <input id="crispr-legend.color.title" type="text" class="shiny-input-text form-control" value="make" data-update-on="change"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify6169145', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Strings which set the title for the color or shape legends.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify5984750">
#>             <div class="material-switch">
#>               <label for="crispr-legend.show" style="padding-right: 10px;">Show Legend</label>
#>               <input id="crispr-legend.show" type="checkbox" checked="checked"/>
#>               <label class="switch label-success bg-success" for="crispr-legend.show"></label>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify5984750', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Show the legend. Turning it off also hides colorbars and any point size legend.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" style="width:100%;" id="tipify4068536">
#>             <label class="control-label" id="crispr-legend.font.family-label" for="crispr-legend.font.family">Legend Font</label>
#>             <div id="crispr-legend.font.family" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="change">
#>               <script type="application/json" data-for="crispr-legend.font.family">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["Arial","Balto","Courier New","Droid Sans","Droid Serif","Droid Sans Mono","Gravitas One","Old Standard TT","Open Sans","Overpass","PT Sans Narrow","Raleway","Times New Roman","Verdana","sans-serif","serif","monospace"],"value":["Arial","Balto","Courier New","Droid Sans","Droid Serif","Droid Sans Mono","Gravitas One","Old Standard TT","Open Sans","Overpass","PT Sans Narrow","Raleway","Times New Roman","Verdana","sans-serif","serif","monospace"]}},"config":{"multiple":false,"search":true,"selectedValue":"Arial","hideClearButton":true,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":false,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":true,"disableOptionGroupCheckbox":true,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify4068536', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Font family of the legend title and entry labels.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour" id="tipify8583281">
#>             <label class="control-label" for="crispr-legend.font.color">Legend Font Color</label>
#>             <input id="crispr-legend.font.color" type="text" class="form-control shiny-colour-input" data-init-value="#000000" data-show-colour="both" data-palette="square"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify8583281', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Font color of the legend title and entry labels.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify5176812">
#>             <label class="control-label" id="crispr-legend.title.size-label" for="crispr-legend.title.size">Legend Title Size</label>
#>             <input id="crispr-legend.title.size" type="number" class="shiny-input-number form-control" value="14" data-update-on="change" min="0" step="1"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify5176812', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Font size of the legend title.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify9792934">
#>             <label class="control-label" id="crispr-legend.text.size-label" for="crispr-legend.text.size">Legend Text Size</label>
#>             <input id="crispr-legend.text.size" type="number" class="shiny-input-number form-control" value="12" data-update-on="change" min="0" step="1"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify9792934', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Font size of the legend entry labels.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify170157">
#>             <label class="control-label" id="crispr-legend.color.breaks-label" for="crispr-legend.color.breaks">Color Tick Breaks</label>
#>             <input id="crispr-legend.color.breaks" type="text" class="shiny-input-text form-control" value="" placeholder="e.g. -3, 0, 3" data-update-on="change"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify170157', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Numeric vector which sets the discrete values to label in the color-scale legend for `color.by`-data.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify6734478">
#>             <label class="control-label" id="crispr-size.legend.x-label" for="crispr-size.legend.x">Size Legend X Position</label>
#>             <input id="crispr-size.legend.x" type="number" class="shiny-input-number form-control" value="1.03" data-update-on="change" step="0.02"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify6734478', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Horizontal position (paper coordinates) of the custom size legend drawn when &#39;Size By&#39; is set. Values just above 1 sit to the right of the plot; lower it to pull the legend inward on narrow plots or raise it to push it further out.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify3712699">
#>             <label class="control-label" id="crispr-size.legend.y-label" for="crispr-size.legend.y">Size Legend Y Position</label>
#>             <input id="crispr-size.legend.y" type="number" class="shiny-input-number form-control" value="0.35" data-update-on="change" step="0.05"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify3712699', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Vertical position (paper coordinates) of the custom size legend drawn when &#39;Size By&#39; is set. Lower it to offset the size legend from an overlapping color or shape legend.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify9180106">
#>             <label class="control-label" id="crispr-min.value-label" for="crispr-min.value">Color Min</label>
#>             <input id="crispr-min.value" type="number" class="shiny-input-number form-control" value="NA" data-update-on="change"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify9180106', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Number which sets the `color.by`-data value associated with the minimum or maximum colors.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify6779781">
#>             <label class="control-label" id="crispr-max.value-label" for="crispr-max.value">Color Max</label>
#>             <input id="crispr-max.value" type="number" class="shiny-input-number form-control" value="NA" data-update-on="change"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify6779781', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Number which sets the `color.by`-data value associated with the minimum or maximum colors.'})}, 500)});</script>
#>         </div>
#>       </div>
#>     </div>
#>     <div class="tab-pane" data-value="Trajectory" id="tab-2966-8">
#>       <div class="vizmodules-input-grid" style="--viz-input-columns: 2;">
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" style="width:100%;" id="tipify6651524">
#>             <label class="control-label" id="crispr-trajectory.group.by-label" for="crispr-trajectory.group.by">Trajectory Group By</label>
#>             <div id="crispr-trajectory.group.by" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="change">
#>               <script type="application/json" data-for="crispr-trajectory.group.by">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["(none)","screen.group"],"value":["","screen.group"]}},"config":{"multiple":false,"search":false,"selectedValue":"","hideClearButton":true,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":false,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":true,"disableOptionGroupCheckbox":true,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify6651524', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'String denoting the name of a column of `data_frame` to use for generating trajectories from data point groups.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify7560411">
#>             <label class="control-label" id="crispr-trajectory.arrow.size-label" for="crispr-trajectory.arrow.size">Trajectory Arrow Size</label>
#>             <input id="crispr-trajectory.arrow.size" type="number" class="shiny-input-number form-control" value="0.1" data-update-on="change" min="0" step="0.05"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify7560411', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Number representing the size of trajectory arrows, in inches.  Default = 0.15.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div id="crispr-add.trajectory.by.groups.ui" class="shiny-html-output"></div>
#>         </div>
#>       </div>
#>     </div>
#>     <div class="tab-pane" data-value="Marginals" id="tab-2966-9">
#>       <div class="vizmodules-input-grid" style="--viz-input-columns: 2;">
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" style="width:100%;" id="tipify5428372">
#>             <label class="control-label" id="crispr-marginal.x-label" for="crispr-marginal.x">Top Marginal (X)</label>
#>             <div id="crispr-marginal.x" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="close">
#>               <script type="application/json" data-for="crispr-marginal.x">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["Density","Histogram","Rug"],"value":["density","histogram","rug"]}},"config":{"multiple":true,"search":false,"selectedValue":[],"hideClearButton":false,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":true,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":false,"disableOptionGroupCheckbox":false,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify5428372', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Distribution of the X values drawn above the plot, one per Color By group. Pick any of density, histogram and rug.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" style="width:100%;" id="tipify2392881">
#>             <label class="control-label" id="crispr-marginal.y-label" for="crispr-marginal.y">Right Marginal (Y)</label>
#>             <div id="crispr-marginal.y" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="close">
#>               <script type="application/json" data-for="crispr-marginal.y">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["Density","Histogram","Rug"],"value":["density","histogram","rug"]}},"config":{"multiple":true,"search":false,"selectedValue":[],"hideClearButton":false,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":true,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":false,"disableOptionGroupCheckbox":false,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify2392881', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Distribution of the Y values drawn to the right of the plot, one per Color By group. Pick any of density, histogram and rug.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify5088936">
#>             <label class="control-label" id="crispr-marginal.x.size-label" for="crispr-marginal.x.size">Top Marginal Height</label>
#>             <input id="crispr-marginal.x.size" type="number" class="shiny-input-number form-control" value="0.15" data-update-on="change" min="0.05" max="0.5" step="0.05"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify5088936', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Share of the plot&#39;s height given to the top marginal.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify4172644">
#>             <label class="control-label" id="crispr-marginal.y.size-label" for="crispr-marginal.y.size">Right Marginal Width</label>
#>             <input id="crispr-marginal.y.size" type="number" class="shiny-input-number form-control" value="0.15" data-update-on="change" min="0.05" max="0.5" step="0.05"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify4172644', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Share of the plot&#39;s width given to the right marginal.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify7269488">
#>             <label class="control-label" id="crispr-marginal.opacity-label" for="crispr-marginal.opacity">Marginal Opacity</label>
#>             <input id="crispr-marginal.opacity" type="number" class="shiny-input-number form-control" value="0.5" data-update-on="change" min="0" max="1" step="0.05"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify7269488', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Opacity of the density and histogram fills and of the rug lines.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify6376855">
#>             <label class="control-label" id="crispr-marginal.bins-label" for="crispr-marginal.bins">Histogram Bins</label>
#>             <input id="crispr-marginal.bins" type="number" class="shiny-input-number form-control" value="30" data-update-on="change" min="1" step="1"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify6376855', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Number of histogram bins, shared by every group so their bins line up.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify3964100">
#>             <label class="control-label" id="crispr-marginal.binwidth-label" for="crispr-marginal.binwidth">Histogram Bin Width</label>
#>             <input id="crispr-marginal.binwidth" type="number" class="shiny-input-number form-control" value="NA" data-update-on="change" min="0"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify3964100', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Width of each histogram bin, in the axis&#39; units. Overrides Histogram Bins when set. Leave blank to use Histogram Bins.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify9594826">
#>             <label class="control-label" id="crispr-marginal.density.adjust-label" for="crispr-marginal.density.adjust">Density Bandwidth Adjust</label>
#>             <input id="crispr-marginal.density.adjust" type="number" class="shiny-input-number form-control" value="1" data-update-on="change" min="0.1" step="0.1"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify9594826', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Multiplier on the density bandwidth. Larger values give smoother curves.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify2986581">
#>             <label class="control-label" id="crispr-marginal.rug.height-label" for="crispr-marginal.rug.height">Rug Height</label>
#>             <input id="crispr-marginal.rug.height" type="number" class="shiny-input-number form-control" value="0.3" data-update-on="change" min="0.1" max="0.9" step="0.05"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify2986581', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Share of a marginal given to its rug when the rug sits alongside a density or histogram. A rug on its own fills the marginal.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify502012">
#>             <label class="control-label" id="crispr-marginal.rug.width-label" for="crispr-marginal.rug.width">Rug Line Width</label>
#>             <input id="crispr-marginal.rug.width" type="number" class="shiny-input-number form-control" value="1" data-update-on="change" min="0.1" step="0.5"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify502012', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Line width of each rug tick, in pixels.'})}, 500)});</script>
#>         </div>
#>       </div>
#>     </div>
#>     <div class="tab-pane" data-value="Plotly" id="tab-2966-10">
#>       <div class="vizmodules-input-grid" style="--viz-input-columns: 2;">
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" style="width:100%;">
#>             <label class="control-label" id="crispr-download.format-label" for="crispr-download.format">Download Format</label>
#>             <div id="crispr-download.format" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="change">
#>               <script type="application/json" data-for="crispr-download.format">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["svg","png","jpeg","webp"],"value":["svg","png","jpeg","webp"]}},"config":{"multiple":false,"search":false,"selectedValue":"svg","hideClearButton":true,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":false,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":true,"disableOptionGroupCheckbox":true,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>             </div>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify5761874">
#>             <label class="control-label" id="crispr-margin.t-label" for="crispr-margin.t">Margin Top</label>
#>             <input id="crispr-margin.t" type="number" class="shiny-input-number form-control" value="70" data-update-on="change" min="0" step="5"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify5761874', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Top margin of the plot in pixels'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify2179058">
#>             <label class="control-label" id="crispr-margin.b-label" for="crispr-margin.b">Margin Bottom</label>
#>             <input id="crispr-margin.b" type="number" class="shiny-input-number form-control" value="70" data-update-on="change" min="0" step="5"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify2179058', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Bottom margin of the plot in pixels'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify1258563">
#>             <label class="control-label" id="crispr-margin.l-label" for="crispr-margin.l">Margin Left</label>
#>             <input id="crispr-margin.l" type="number" class="shiny-input-number form-control" value="70" data-update-on="change" min="0" step="5"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify1258563', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Left margin of the plot in pixels'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify9381526">
#>             <label class="control-label" id="crispr-margin.r-label" for="crispr-margin.r">Margin Right</label>
#>             <input id="crispr-margin.r" type="number" class="shiny-input-number form-control" value="90" data-update-on="change" min="0" step="5"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify9381526', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Right margin of the plot in pixels'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour" id="tipify8012751">
#>             <label class="control-label" for="crispr-shape.fill">Shape Fill</label>
#>             <input id="crispr-shape.fill" type="text" class="form-control shiny-colour-input" data-init-value="rgba(0, 0, 0, 0)" data-show-colour="both" data-palette="square" data-allow-alpha="true"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify8012751', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Interior fill color for shapes drawn on the plot using Plotly&#39;s drawing tools'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour" id="tipify7580536">
#>             <label class="control-label" for="crispr-shape.line.color">Shape Line Color</label>
#>             <input id="crispr-shape.line.color" type="text" class="form-control shiny-colour-input" data-init-value="black" data-show-colour="both" data-palette="square" data-allow-alpha="true"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify7580536', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Outline color for shapes drawn on the plot using Plotly&#39;s drawing tools'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify5325652">
#>             <label class="control-label" id="crispr-shape.line.width-label" for="crispr-shape.line.width">Shape Line Width</label>
#>             <input id="crispr-shape.line.width" type="number" class="shiny-input-number form-control" value="4" data-update-on="change" min="0" step="0.25"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify5325652', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Outline width for shapes drawn on the plot using Plotly&#39;s drawing tools'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" style="width:100%;" id="tipify5468048">
#>             <label class="control-label" id="crispr-shape.linetype-label" for="crispr-shape.linetype">Shape Linetype</label>
#>             <div id="crispr-shape.linetype" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="change">
#>               <script type="application/json" data-for="crispr-shape.linetype">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["solid","dot","dash","longdash","dashdot","longdashdot"],"value":["solid","dot","dash","longdash","dashdot","longdashdot"]}},"config":{"multiple":false,"search":false,"selectedValue":"solid","hideClearButton":true,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":false,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":true,"disableOptionGroupCheckbox":true,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify5468048', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Line dash style for shapes drawn on the plot using Plotly&#39;s drawing tools'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify959265">
#>             <label class="control-label" id="crispr-shape.opacity-label" for="crispr-shape.opacity">Shape Opacity</label>
#>             <input id="crispr-shape.opacity" type="number" class="shiny-input-number form-control" value="1" data-update-on="change" min="0" max="1" step="0.01"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify959265', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Opacity of shapes drawn on the plot, where 0 is fully transparent and 1 is fully opaque'})}, 500)});</script>
#>         </div>
#>       </div>
#>     </div>
#>     <div class="tab-pane" data-value="Extras" id="tab-2966-11">
#>       <div class="vizmodules-input-grid" style="--viz-input-columns: 2;">
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify3883498">
#>             <div class="checkbox">
#>               <label>
#>                 <input id="crispr-webgl" type="checkbox" class="shiny-input-checkbox" checked="checked"/>
#>                 <span>Plot with webGL</span>
#>               </label>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify3883498', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Enable WebGL rendering for improved performance with large datasets at the cost of some visual features'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify1723519">
#>             <div class="checkbox">
#>               <label>
#>                 <input id="crispr-do.ellipse" type="checkbox" class="shiny-input-checkbox"/>
#>                 <span>Enable Ellipses</span>
#>               </label>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify1723519', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Logical. Whether `color.by` groups should be surrounded by median-centered ellipses.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify6907258">
#>             <div class="checkbox">
#>               <label>
#>                 <input id="crispr-do.contour" type="checkbox" class="shiny-input-checkbox"/>
#>                 <span>Enable Contour</span>
#>               </label>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify6907258', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Logical. Whether density-based contours should be displayed.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" style="width:100%;" id="tipify6752085">
#>             <label class="control-label" id="crispr-hover.data-label" for="crispr-hover.data">Hover Data</label>
#>             <div id="crispr-hover.data" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="close">
#>               <script type="application/json" data-for="crispr-hover.data">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["(none)","gene","n.sgrna","neg.score","neg.p","neg.fdr","neg.rank","neg.goodsgrna","neg.lfc","pos.score","pos.p","pos.fdr","pos.rank","pos.goodsgrna","pos.lfc","screen.rank","screen.lfc","screen.fdr","screen.metric","screen.group"],"value":["","gene","n.sgrna","neg.score","neg.p","neg.fdr","neg.rank","neg.goodsgrna","neg.lfc","pos.score","pos.p","pos.fdr","pos.rank","pos.goodsgrna","pos.lfc","screen.rank","screen.lfc","screen.fdr","screen.metric","screen.group"]}},"config":{"multiple":true,"search":true,"selectedValue":["gene","n.sgrna","screen.lfc","screen.fdr"],"hideClearButton":false,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":true,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":false,"disableOptionGroupCheckbox":false,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify6752085', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'String vector which denotes what data to show for each data point, upon hover, when `do.hover` is set to `TRUE`. Defaults to all data expected to be useful. Only values present in the plotting data are actually used. These can be column names of `data_frame` and any column names which will be created to accommodate multivar and data adjustment functionality. You can run the function with `data.out = TRUE` and inspect the `$Target_data` output&#39;s columns to view your available options.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify9462948">
#>             <label class="control-label" id="crispr-hover.round.digits-label" for="crispr-hover.round.digits">Hover Round Digits</label>
#>             <input id="crispr-hover.round.digits" type="number" class="shiny-input-number form-control" value="5" data-update-on="change" min="1" step="1"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify9462948', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Integer number specifying the number of decimal digits to round displayed numeric values to, when `do.hover` is set to `TRUE`.'})}, 500)});</script>
#>         </div>
#>       </div>
#>     </div>
#>     <div class="tab-pane" data-value="Lines" id="tab-2966-12">
#>       <div class="vizmodules-input-grid" style="--viz-input-columns: 2;">
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify1962196">
#>             <label class="control-label" id="crispr-hline.intercepts-label" for="crispr-hline.intercepts">Y-intercepts</label>
#>             <input id="crispr-hline.intercepts" type="text" class="shiny-input-text form-control" value="" placeholder="e.g. 2, -2" data-update-on="change"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify1962196', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'For categorical or factor axes, enter the index (position) of the category rather than its name. For example, if the axis categories are &#39;Audi&#39;, &#39;Mercedes&#39;, &#39;Bugatti&#39;, enter 2 to place a line at &#39;Mercedes&#39;.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify9686375">
#>             <label class="control-label" id="crispr-hline.colors-label" for="crispr-hline.colors">Y Colors</label>
#>             <input id="crispr-hline.colors" type="text" class="shiny-input-text form-control" value="#000000" data-update-on="change"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify9686375', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Color(s) for horizontal reference lines, as comma-separated hex codes or color names'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify3870963">
#>             <label class="control-label" id="crispr-hline.widths-label" for="crispr-hline.widths">Y Widths</label>
#>             <input id="crispr-hline.widths" type="text" class="shiny-input-text form-control" value="1" data-update-on="change"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify3870963', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Width(s) for horizontal reference lines in pixels, as comma-separated values'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify6503439">
#>             <label class="control-label" id="crispr-hline.linetypes-label" for="crispr-hline.linetypes">Y Line Types</label>
#>             <input id="crispr-hline.linetypes" type="text" class="shiny-input-text form-control" value="dashed" placeholder="solid, dashed, dotted, ..." data-update-on="change"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify6503439', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Line style(s) for horizontal reference lines (solid, dashed, dotted, dotdash, longdash, twodash)'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify8145962">
#>             <label class="control-label" id="crispr-hline.opacities-label" for="crispr-hline.opacities">Y Opacities (0-1)</label>
#>             <input id="crispr-hline.opacities" type="text" class="shiny-input-text form-control" value="1" data-update-on="change"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify8145962', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Opacity of horizontal reference lines between 0 (transparent) and 1 (opaque), as comma-separated values'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify709648">
#>             <label class="control-label" id="crispr-vline.intercepts-label" for="crispr-vline.intercepts">X-intercepts</label>
#>             <input id="crispr-vline.intercepts" type="text" class="shiny-input-text form-control" value="" placeholder="e.g. 2, -2" data-update-on="change"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify709648', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'For categorical or factor axes, enter the index (position) of the category rather than its name. For example, if the axis categories are &#39;Audi&#39;, &#39;Mercedes&#39;, &#39;Bugatti&#39;, enter 2 to place a line at &#39;Mercedes&#39;.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify5268303">
#>             <label class="control-label" id="crispr-vline.colors-label" for="crispr-vline.colors">X Colors</label>
#>             <input id="crispr-vline.colors" type="text" class="shiny-input-text form-control" value="#000000" data-update-on="change"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify5268303', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Color(s) for vertical reference lines, as comma-separated hex codes or color names'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify7634748">
#>             <label class="control-label" id="crispr-vline.widths-label" for="crispr-vline.widths">X Widths</label>
#>             <input id="crispr-vline.widths" type="text" class="shiny-input-text form-control" value="1" data-update-on="change"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify7634748', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Width(s) for vertical reference lines in pixels, as comma-separated values'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify4353866">
#>             <label class="control-label" id="crispr-vline.linetypes-label" for="crispr-vline.linetypes">X Line Types</label>
#>             <input id="crispr-vline.linetypes" type="text" class="shiny-input-text form-control" value="dashed" placeholder="solid, dashed, dotted, ..." data-update-on="change"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify4353866', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Line style(s) for vertical reference lines (solid, dashed, dotted, dotdash, longdash, twodash)'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify5524723">
#>             <label class="control-label" id="crispr-vline.opacities-label" for="crispr-vline.opacities">X Opacities (0-1)</label>
#>             <input id="crispr-vline.opacities" type="text" class="shiny-input-text form-control" value="1" data-update-on="change"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify5524723', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Opacity of vertical reference lines between 0 (transparent) and 1 (opaque), as comma-separated values'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify2040307">
#>             <label class="control-label" id="crispr-abline.slopes-label" for="crispr-abline.slopes">Ab Slopes</label>
#>             <input id="crispr-abline.slopes" type="text" class="shiny-input-text form-control" value="" data-update-on="change"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify2040307', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Slope(s) of diagonal reference lines (rise/run), as comma-separated values'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify310261">
#>             <label class="control-label" id="crispr-abline.intercepts-label" for="crispr-abline.intercepts">Ab Y-intercepts</label>
#>             <input id="crispr-abline.intercepts" type="text" class="shiny-input-text form-control" value="" data-update-on="change"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify310261', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'For categorical or factor axes, enter the index (position) of the category rather than its name. For example, if the axis categories are &#39;Audi&#39;, &#39;Mercedes&#39;, &#39;Bugatti&#39;, enter 2 to place a line at &#39;Mercedes&#39;.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify9697070">
#>             <label class="control-label" id="crispr-abline.colors-label" for="crispr-abline.colors">Ab Colors</label>
#>             <input id="crispr-abline.colors" type="text" class="shiny-input-text form-control" value="#000000" data-update-on="change"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify9697070', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Color(s) for diagonal reference lines, as comma-separated hex codes or color names'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify1786131">
#>             <label class="control-label" id="crispr-abline.widths-label" for="crispr-abline.widths">Ab Widths</label>
#>             <input id="crispr-abline.widths" type="text" class="shiny-input-text form-control" value="1" data-update-on="change"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify1786131', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Width(s) for diagonal reference lines in pixels, as comma-separated values'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify7782928">
#>             <label class="control-label" id="crispr-abline.linetypes-label" for="crispr-abline.linetypes">Ab Line Types</label>
#>             <input id="crispr-abline.linetypes" type="text" class="shiny-input-text form-control" value="dashed" placeholder="solid, dashed, dotted, ..." data-update-on="change"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify7782928', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Line style(s) for diagonal reference lines (solid, dashed, dotted, dotdash, longdash, twodash)'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify8857108">
#>             <label class="control-label" id="crispr-abline.opacities-label" for="crispr-abline.opacities">Ab Opacities (0-1)</label>
#>             <input id="crispr-abline.opacities" type="text" class="shiny-input-text form-control" value="1" data-update-on="change"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify8857108', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Opacity of diagonal reference lines between 0 (transparent) and 1 (opaque), as comma-separated values'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify8364462">
#>             <div class="material-switch">
#>               <label for="crispr-best.fit" style="padding-right: 10px;">Plot Best Fit Line</label>
#>               <input id="crispr-best.fit" type="checkbox"/>
#>               <label class="switch label-success bg-success" for="crispr-best.fit"></label>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify8364462', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Add a LOESS smoothed curve of best fit to the scatter plot'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify6053684">
#>             <label class="control-label" id="crispr-line.best.smoothness-label" for="crispr-line.best.smoothness">Best Fit Line Smoothness</label>
#>             <input id="crispr-line.best.smoothness" type="number" class="shiny-input-number form-control" value="1" data-update-on="change" min="0" max="10000"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify6053684', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Smoothing span for the LOESS curve; higher values produce a smoother, less wiggly fit'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour" id="tipify9068794">
#>             <label class="control-label" for="crispr-line.best.colour">Best Fit Line Color</label>
#>             <input id="crispr-line.best.colour" type="text" class="form-control shiny-colour-input" data-init-value="#000000" data-show-colour="both" data-palette="square"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify9068794', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Color for the LOESS best fit line'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify359099">
#>             <div class="material-switch">
#>               <label for="crispr-linear.model" style="padding-right: 10px;">Linear Model Line</label>
#>               <input id="crispr-linear.model" type="checkbox"/>
#>               <label class="switch label-success bg-success" for="crispr-linear.model"></label>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify359099', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Add a linear regression line to the scatter plot'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify1314185">
#>             <div class="material-switch">
#>               <label for="crispr-custom.model.enable" style="padding-right: 10px;">Custom Model Lines</label>
#>               <input id="crispr-custom.model.enable" type="checkbox"/>
#>               <label class="switch label-success bg-success" for="crispr-custom.model.enable"></label>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify1314185', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Fit one or more custom models from formulas you define below and overlay them as lines. Only data columns and basic math/transform terms are allowed.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="multi-dynamic-input shiny-input-container form-group is-plain" id="crispr-custom.models" data-keys="[&quot;model_type&quot;,&quot;formula&quot;,&quot;line_colour&quot;,&quot;line_width&quot;,&quot;drc_fct&quot;]" data-initial="[]" data-input-id="crispr-custom.models" data-row-prefix="models">
#>             <div class="mdi-top">
#>               <label class="control-label" for="crispr-custom.models">Models</label>
#>               <button type="button" class="mdi-add btn btn-default btn-sm">+ Add</button>
#>             </div>
#>             <div class="mdi-rows"></div>
#>             <template class="mdi-row-template">
#>               <div class="mdi-row">
#>                 <div class="mdi-fields">
#>                   <div class="mdi-field" data-key="model_type" style="flex: 1 1 calc(25% - 8px); min-width: 120px;">
#>                     <div class="form-group shiny-input-container">
#>                       <label class="control-label" id="crispr-custom.models-__ROWIDX__-model_type-label" for="crispr-custom.models-__ROWIDX__-model_type">Model type</label>
#>                       <div>
#>                         <select id="crispr-custom.models-__ROWIDX__-model_type" class="shiny-input-select"><option value="drm">drm</option>
#> <option value="glm">glm</option>
#> <option value="lm" selected>lm</option>
#> <option value="loess">loess</option></select>
#>                         <script type="application/json" data-for="crispr-custom.models-__ROWIDX__-model_type" data-nonempty="">{"plugins":["selectize-plugin-a11y"]}</script>
#>                       </div>
#>                     </div>
#>                   </div>
#>                   <div class="mdi-field" data-key="formula" style="flex: 1 1 calc(25% - 8px); min-width: 120px;">
#>                     <div class="form-group shiny-input-container">
#>                       <label class="control-label" id="crispr-custom.models-__ROWIDX__-formula-label" for="crispr-custom.models-__ROWIDX__-formula">Formula</label>
#>                       <input id="crispr-custom.models-__ROWIDX__-formula" type="text" class="shiny-input-text form-control" value="" placeholder="e.g. y ~ poly(x, 2)" data-update-on="change"/>
#>                     </div>
#>                   </div>
#>                   <div class="mdi-field" data-key="line_colour" style="flex: 1 1 calc(25% - 8px); min-width: 120px;">
#>                     <div class="form-group shiny-input-container" data-shiny-input-type="colour">
#>                       <label class="control-label" for="crispr-custom.models-__ROWIDX__-line_colour">Line colour</label>
#>                       <input id="crispr-custom.models-__ROWIDX__-line_colour" type="text" class="form-control shiny-colour-input" data-init-value="#000000" data-show-colour="both" data-palette="square"/>
#>                     </div>
#>                   </div>
#>                   <div class="mdi-field" data-key="line_width" style="flex: 1 1 calc(25% - 8px); min-width: 120px;">
#>                     <div class="form-group shiny-input-container">
#>                       <label class="control-label" id="crispr-custom.models-__ROWIDX__-line_width-label" for="crispr-custom.models-__ROWIDX__-line_width">Line width</label>
#>                       <input id="crispr-custom.models-__ROWIDX__-line_width" type="number" class="shiny-input-number form-control" value="2" data-update-on="change" min="0.5" max="20" step="0.5"/>
#>                     </div>
#>                   </div>
#>                   <div class="mdi-field" data-key="drc_fct" data-backend="drm" style="flex: 1 1 calc(25% - 8px); min-width: 120px; display: none;">
#>                     <div class="form-group shiny-input-container">
#>                       <label class="control-label" id="crispr-custom.models-__ROWIDX__-drc_fct-label" for="crispr-custom.models-__ROWIDX__-drc_fct">Drc fct</label>
#>                       <div>
#>                         <select id="crispr-custom.models-__ROWIDX__-drc_fct" class="shiny-input-select"><option value="LL.4" selected>LL.4</option>
#> <option value="LL.3">LL.3</option>
#> <option value="LL.2">LL.2</option>
#> <option value="W1.4">W1.4</option>
#> <option value="W2.4">W2.4</option></select>
#>                         <script type="application/json" data-for="crispr-custom.models-__ROWIDX__-drc_fct" data-nonempty="">{"plugins":["selectize-plugin-a11y"]}</script>
#>                       </div>
#>                     </div>
#>                   </div>
#>                 </div>
#>                 <button type="button" class="mdi-delete" title="Delete this row" aria-label="Delete this row">&times;</button>
#>               </div>
#>             </template>
#>           </div>
#>         </div>
#>       </div>
#>     </div>
#>     <div class="tab-pane" data-value="Axes" id="tab-2966-13">
#>       <div class="vizmodules-input-grid" style="--viz-input-columns: 2;">
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" style="width:100%;">
#>             <label class="control-label" id="crispr-title.font.family-label" for="crispr-title.font.family">Title Font</label>
#>             <div id="crispr-title.font.family" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="change">
#>               <script type="application/json" data-for="crispr-title.font.family">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["Arial","Balto","Courier New","Droid Sans","Droid Serif","Droid Sans Mono","Gravitas One","Old Standard TT","Open Sans","Overpass","PT Sans Narrow","Raleway","Times New Roman","Verdana","sans-serif","serif","monospace"],"value":["Arial","Balto","Courier New","Droid Sans","Droid Serif","Droid Sans Mono","Gravitas One","Old Standard TT","Open Sans","Overpass","PT Sans Narrow","Raleway","Times New Roman","Verdana","sans-serif","serif","monospace"]}},"config":{"multiple":false,"search":true,"selectedValue":"Arial","hideClearButton":true,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":false,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":true,"disableOptionGroupCheckbox":true,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>             </div>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour">
#>             <label class="control-label" for="crispr-title.font.color">Title Color</label>
#>             <input id="crispr-title.font.color" type="text" class="form-control shiny-colour-input" data-init-value="#000000" data-show-colour="both" data-palette="square"/>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="crispr-title.font.size-label" for="crispr-title.font.size">Title Size</label>
#>             <input id="crispr-title.font.size" type="number" class="shiny-input-number form-control" value="26" data-update-on="change" min="1" step="1"/>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="crispr-axis.title.horizontal.position-label" for="crispr-axis.title.horizontal.position">Title position</label>
#>             <input id="crispr-axis.title.horizontal.position" type="number" class="shiny-input-number form-control" value="0.5" data-update-on="change" min="0" max="1" step="0.1"/>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="crispr-axis.title.font.size-label" for="crispr-axis.title.font.size">Axis Title Size</label>
#>             <input id="crispr-axis.title.font.size" type="number" class="shiny-input-number form-control" value="18" data-update-on="change" min="1" step="1"/>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour">
#>             <label class="control-label" for="crispr-axis.title.font.color">Axis Title Color</label>
#>             <input id="crispr-axis.title.font.color" type="text" class="form-control shiny-colour-input" data-init-value="#000000" data-show-colour="both" data-palette="square"/>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" style="width:100%;">
#>             <label class="control-label" id="crispr-axis.title.font.family-label" for="crispr-axis.title.font.family">Axis Title Font</label>
#>             <div id="crispr-axis.title.font.family" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="change">
#>               <script type="application/json" data-for="crispr-axis.title.font.family">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["Arial","Balto","Courier New","Droid Sans","Droid Serif","Droid Sans Mono","Gravitas One","Old Standard TT","Open Sans","Overpass","PT Sans Narrow","Raleway","Times New Roman","Verdana","sans-serif","serif","monospace"],"value":["Arial","Balto","Courier New","Droid Sans","Droid Serif","Droid Sans Mono","Gravitas One","Old Standard TT","Open Sans","Overpass","PT Sans Narrow","Raleway","Times New Roman","Verdana","sans-serif","serif","monospace"]}},"config":{"multiple":false,"search":true,"selectedValue":"Arial","hideClearButton":true,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":false,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":true,"disableOptionGroupCheckbox":true,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>             </div>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container">
#>             <div class="checkbox">
#>               <label>
#>                 <input id="crispr-axis.showline" type="checkbox" class="shiny-input-checkbox" checked="checked"/>
#>                 <span>Show Axis Borders</span>
#>               </label>
#>             </div>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container">
#>             <div class="checkbox">
#>               <label>
#>                 <input id="crispr-axis.mirror" type="checkbox" class="shiny-input-checkbox" checked="checked"/>
#>                 <span>Mirror Axis Borders</span>
#>               </label>
#>             </div>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container">
#>             <div class="checkbox">
#>               <label>
#>                 <input id="crispr-show.grid.x" type="checkbox" class="shiny-input-checkbox" checked="checked"/>
#>                 <span>Show X Gridlines</span>
#>               </label>
#>             </div>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container">
#>             <div class="checkbox">
#>               <label>
#>                 <input id="crispr-show.grid.y" type="checkbox" class="shiny-input-checkbox" checked="checked"/>
#>                 <span>Show Y Gridlines</span>
#>               </label>
#>             </div>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour">
#>             <label class="control-label" for="crispr-grid.color">Gridline Color</label>
#>             <input id="crispr-grid.color" type="text" class="form-control shiny-colour-input" data-init-value="#CCCCCC" data-show-colour="both" data-palette="square"/>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour">
#>             <label class="control-label" for="crispr-axis.linecolor">Axis Line Color</label>
#>             <input id="crispr-axis.linecolor" type="text" class="form-control shiny-colour-input" data-init-value="black" data-show-colour="both" data-palette="square"/>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="crispr-axis.linewidth-label" for="crispr-axis.linewidth">Axis Line Width</label>
#>             <input id="crispr-axis.linewidth" type="number" class="shiny-input-number form-control" value="0.5" data-update-on="change" min="0" step="0.1"/>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="crispr-axis.tickfont.size-label" for="crispr-axis.tickfont.size">Tick Label Size</label>
#>             <input id="crispr-axis.tickfont.size" type="number" class="shiny-input-number form-control" value="12" data-update-on="change" min="1" step="1"/>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour">
#>             <label class="control-label" for="crispr-axis.tickfont.color">Tick Label Color</label>
#>             <input id="crispr-axis.tickfont.color" type="text" class="form-control shiny-colour-input" data-init-value="black" data-show-colour="both" data-palette="square"/>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" style="width:100%;">
#>             <label class="control-label" id="crispr-axis.tickfont.family-label" for="crispr-axis.tickfont.family">Tick Label Font</label>
#>             <div id="crispr-axis.tickfont.family" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="change">
#>               <script type="application/json" data-for="crispr-axis.tickfont.family">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["Arial","Balto","Courier New","Droid Sans","Droid Serif","Droid Sans Mono","Gravitas One","Old Standard TT","Open Sans","Overpass","PT Sans Narrow","Raleway","Times New Roman","Verdana","sans-serif","serif","monospace"],"value":["Arial","Balto","Courier New","Droid Sans","Droid Serif","Droid Sans Mono","Gravitas One","Old Standard TT","Open Sans","Overpass","PT Sans Narrow","Raleway","Times New Roman","Verdana","sans-serif","serif","monospace"]}},"config":{"multiple":false,"search":true,"selectedValue":"Arial","hideClearButton":true,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":false,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":true,"disableOptionGroupCheckbox":true,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>             </div>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="crispr-axis.tickangle.x-label" for="crispr-axis.tickangle.x">X Tick Label Angle</label>
#>             <input id="crispr-axis.tickangle.x" type="number" class="shiny-input-number form-control" value="0" data-update-on="change" min="-180" max="180" step="15"/>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="crispr-axis.tickangle.y-label" for="crispr-axis.tickangle.y">Y Tick Label Angle</label>
#>             <input id="crispr-axis.tickangle.y" type="number" class="shiny-input-number form-control" value="0" data-update-on="change" min="-180" max="180" step="15"/>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" style="width:100%;">
#>             <label class="control-label" id="crispr-axis.ticks-label" for="crispr-axis.ticks">Tick Position</label>
#>             <div id="crispr-axis.ticks" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="change">
#>               <script type="application/json" data-for="crispr-axis.ticks">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["Outside","Inside","(none)"],"value":["outside","inside",""]}},"config":{"multiple":false,"search":false,"selectedValue":"outside","hideClearButton":true,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":false,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":true,"disableOptionGroupCheckbox":true,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>             </div>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour">
#>             <label class="control-label" for="crispr-axis.tickcolor">Tick Mark Color</label>
#>             <input id="crispr-axis.tickcolor" type="text" class="form-control shiny-colour-input" data-init-value="black" data-show-colour="both" data-palette="square"/>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="crispr-axis.ticklen-label" for="crispr-axis.ticklen">Tick Mark Length</label>
#>             <input id="crispr-axis.ticklen" type="number" class="shiny-input-number form-control" value="5" data-update-on="change" min="0" step="1"/>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="crispr-axis.tickwidth-label" for="crispr-axis.tickwidth">Tick Mark Width</label>
#>             <input id="crispr-axis.tickwidth" type="number" class="shiny-input-number form-control" value="1" data-update-on="change" min="0" step="0.1"/>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="crispr-facet.title.font.size-label" for="crispr-facet.title.font.size">Facet Subplot Title Size</label>
#>             <input id="crispr-facet.title.font.size" type="number" class="shiny-input-number form-control" value="18" data-update-on="change" min="1" step="1"/>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour">
#>             <label class="control-label" for="crispr-facet.title.font.color">Facet Title Color</label>
#>             <input id="crispr-facet.title.font.color" type="text" class="form-control shiny-colour-input" data-init-value="#000000" data-show-colour="both" data-palette="square"/>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" style="width:100%;">
#>             <label class="control-label" id="crispr-facet.title.font.family-label" for="crispr-facet.title.font.family">Facet Title Font</label>
#>             <div id="crispr-facet.title.font.family" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="change">
#>               <script type="application/json" data-for="crispr-facet.title.font.family">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["Arial","Balto","Courier New","Droid Sans","Droid Serif","Droid Sans Mono","Gravitas One","Old Standard TT","Open Sans","Overpass","PT Sans Narrow","Raleway","Times New Roman","Verdana","sans-serif","serif","monospace"],"value":["Arial","Balto","Courier New","Droid Sans","Droid Serif","Droid Sans Mono","Gravitas One","Old Standard TT","Open Sans","Overpass","PT Sans Narrow","Raleway","Times New Roman","Verdana","sans-serif","serif","monospace"]}},"config":{"multiple":false,"search":true,"selectedValue":"Arial","hideClearButton":true,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":false,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":true,"disableOptionGroupCheckbox":true,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>             </div>
#>           </div>
#>         </div>
#>       </div>
#>     </div>
#>   </div>
#> </div>
#> <div class="module-tack" style="margin-top: 12px;">
#>   <div class="module-tack-switch" style="margin-bottom: 4px;">
#>     <div class="form-group shiny-input-container">
#>       <div class="material-switch">
#>         <label for="crispr-auto.update" style="padding-right: 10px;">Auto Update</label>
#>         <input id="crispr-auto.update" type="checkbox" checked="checked"/>
#>         <label class="switch label-success bg-success" for="crispr-auto.update"></label>
#>       </div>
#>     </div>
#>   </div>
#>   <div class="module-tack-buttons" style="display: flex; flex-wrap: wrap; gap: 8px;">
#>     <button class="btn btn-default action-button btn-primary" id="crispr-update" style="flex: 1 1 45%;" type="button"><span class="action-label">Update</span></button>
#>     <button class="btn btn-default action-button btn-secondary" id="crispr-reset" style="flex: 1 1 45%;" type="button"><span class="action-label">Reset</span></button>
#>     <a aria-disabled="true" class="btn btn-default shiny-download-link disabled btn-secondary viz-source-download" data-viz-source-ns="crispr-" download href="" id="crispr-download.source" style="flex: 1 1 100%;" tabindex="-1" target="_blank">
#>       <i class="far fa-file-code" role="presentation" aria-label="file-code icon"></i>
#>       Source Download
#>     </a>
#>     <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('crispr-download.source', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Download the plot as a self-contained HTML file and as SVG and PNG images of it as it looks now, along with the plot source data and statistics (if applicable) as CSV files.'})}, 500)});</script>
#>   </div>
#> </div>
```
