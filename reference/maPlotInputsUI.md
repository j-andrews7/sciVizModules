# Input UI components for the maPlot module

This should be placed in the UI where the inputs should be shown, with
an `id` that matches the `id` used in the
[`maPlotServer()`](https://j-andrews7.github.io/sciVizModules/reference/maPlotServer.md)
and
[`maPlotOutputUI()`](https://j-andrews7.github.io/sciVizModules/reference/maPlotOutputUI.md)
functions.

## Usage

``` r
maPlotInputsUI(id, data, defaults = NULL, title = "MA Settings", columns = 2)
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

The inputs will automatically be organized into a grid layout via the
[`VizModules::organize_inputs()`](https://j-andrews7.github.io/VizModules/reference/organize_inputs.html)
function, with `columns` controlling the number of columns in the grid.

Defaults can be set for each input by providing a named list of values
to the `defaults` argument. This module wraps
[`VizModules::dittoViz_scatterPlotInputsUI()`](https://j-andrews7.github.io/VizModules/reference/dittoViz_scatterPlotInputsUI.html)
and adds MA-specific controls. The base scatter plot UI components and
their input IDs (e.g. `x.by`, `y.by`, `color.by`, `hover.data`) are
documented in
[`VizModules::dittoViz_scatterPlotInputsUI()`](https://j-andrews7.github.io/VizModules/reference/dittoViz_scatterPlotInputsUI.html);
only the MA-specific additions are described here.

Additional inputs specific to MA plots are added to control significance
thresholds and colors:

- `sig.by`: Significance column used for grouping (auto-detected: padj,
  FDR, adj.P.Val, ...)

- `sig.thresh`: Significance threshold (default 0.05)

- `fc.thresh`: Log2 fold change threshold (default 0)

Group colors are the wrapped module's own "Color palette" picker on its
**Colors** tab, seeded from `color.up` / `color.down` / `color.ns`
(defaults: red / blue / lightgray) and therefore fully editable and
covered by Reset.

## Plot parameters and defaults

The following parameters can be accessed via UI inputs and/or the
`defaults` argument:

- `x.by` - X-axis variable (auto-detected from mean abundance columns:
  baseMean, logCPM, AveExpr)

- `y.by` - Y-axis variable (auto-detected from effect size columns:
  log2FoldChange, logFC, LFC)

- `color.by` - Coloring variable (default: "group", auto-generated from
  thresholds)

- `x.adj.fxn` - X adjustment function (default: "log10" for log10 mean
  abundance)

- `show.others` - Show others (default: FALSE)

- `hover.data` - Hover data columns (default: c("symbol", x.by, y.by))

- `sig.thresh` - Significance threshold (UI: "Significance Threshold",
  default: 0.05)

- `fc.thresh` - Log2 fold change threshold (UI: "LFC Threshold (log2)",
  default: 0)

- All other
  [`dittoViz::scatterPlot()`](https://rdrr.io/pkg/dittoViz/man/scatterPlot.html)
  parameters are also available via the wrapped UI

## Parameters controlling additional functionality

The following parameters implementing MA-specific features are also
available:

- `sig.by` - Significance column used for grouping (UI: "Significance
  Column")

- `color.up`, `color.down`, `color.ns` - Colors for the three
  significance groups, assembled into the wrapped module's `color.panel`
  mapping. A named `color.panel` vector may be given instead and takes
  precedence.

- `group` - Auto-generated grouping column based on sig.thresh and
  fc.thresh

## See also

[`dittoViz::scatterPlot()`](https://rdrr.io/pkg/dittoViz/man/scatterPlot.html),
[`VizModules::dittoViz_scatterPlotInputsUI()`](https://j-andrews7.github.io/VizModules/reference/dittoViz_scatterPlotInputsUI.html),
[`maPlotOutputUI()`](https://j-andrews7.github.io/sciVizModules/reference/maPlotOutputUI.md),
[`maPlotServer()`](https://j-andrews7.github.io/sciVizModules/reference/maPlotServer.md),
[`maPlotApp()`](https://j-andrews7.github.io/sciVizModules/reference/maPlotApp.md)

## Author

Jared Andrews

## Examples

``` r
library(sciVizModules)
data(airway_deseq2)
maPlotInputsUI("maPlot", airway_deseq2)
#> <div class="vizmodules-input-grid" style="--viz-input-columns: 2;">
#>   <div class="vizmodules-input-cell">
#>     <div class="form-group shiny-input-container" style="width:100%;" id="tipify7329705">
#>       <label class="control-label" id="maPlot-sig.by-label" for="maPlot-sig.by">Significance Column:</label>
#>       <div id="maPlot-sig.by" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="change">
#>         <script type="application/json" data-for="maPlot-sig.by">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["baseMean","log2FoldChange","lfcSE","stat","pvalue","padj"],"value":["baseMean","log2FoldChange","lfcSE","stat","pvalue","padj"]}},"config":{"multiple":false,"search":false,"selectedValue":"padj","hideClearButton":true,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":false,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":true,"disableOptionGroupCheckbox":true,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>       </div>
#>     </div>
#>     <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify7329705', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Column used to determine significance for Up/Down/n.s. grouping.'})}, 500)});</script>
#>   </div>
#>   <div class="vizmodules-input-cell">
#>     <div class="form-group shiny-input-container" id="tipify7279052">
#>       <label class="control-label" id="maPlot-sig.thresh-label" for="maPlot-sig.thresh">Significance Threshold:</label>
#>       <input id="maPlot-sig.thresh" type="number" class="shiny-input-number form-control" value="0.05" data-update-on="change" min="0" max="1" step="0.01"/>
#>     </div>
#>     <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify7279052', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Significance threshold for grouping genes as Up/Down/n.s.'})}, 500)});</script>
#>   </div>
#>   <div class="vizmodules-input-cell">
#>     <div class="form-group shiny-input-container" id="tipify5457234">
#>       <label class="control-label" id="maPlot-fc.thresh-label" for="maPlot-fc.thresh">LFC Threshold (log2):</label>
#>       <input id="maPlot-fc.thresh" type="number" class="shiny-input-number form-control" value="0" data-update-on="change" min="0" step="0.25"/>
#>     </div>
#>     <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify5457234', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Log2 fold change threshold for grouping genes as Up/Down/n.s.'})}, 500)});</script>
#>   </div>
#> </div>
#> <h3>MA Settings</h3>
#> <div class="tabbable vizmodules-input-tabs">
#>   <ul class="nav nav-tabs shiny-tab-input" id="maPlot-scatterPlotTabsetPanel" data-tabsetid="4096">
#>     <li class="active">
#>       <a href="#tab-4096-1" data-toggle="tab" data-bs-toggle="tab" data-value="Data">Data</a>
#>     </li>
#>     <li>
#>       <a href="#tab-4096-2" data-toggle="tab" data-bs-toggle="tab" data-value="Adjustments">Adjustments</a>
#>     </li>
#>     <li>
#>       <a href="#tab-4096-3" data-toggle="tab" data-bs-toggle="tab" data-value="Points">Points</a>
#>     </li>
#>     <li>
#>       <a href="#tab-4096-4" data-toggle="tab" data-bs-toggle="tab" data-value="Colors">Colors</a>
#>     </li>
#>     <li>
#>       <a href="#tab-4096-5" data-toggle="tab" data-bs-toggle="tab" data-value="Facet">Facet</a>
#>     </li>
#>     <li>
#>       <a href="#tab-4096-6" data-toggle="tab" data-bs-toggle="tab" data-value="Annotations">Annotations</a>
#>     </li>
#>     <li>
#>       <a href="#tab-4096-7" data-toggle="tab" data-bs-toggle="tab" data-value="Legend">Legend</a>
#>     </li>
#>     <li>
#>       <a href="#tab-4096-8" data-toggle="tab" data-bs-toggle="tab" data-value="Trajectory">Trajectory</a>
#>     </li>
#>     <li>
#>       <a href="#tab-4096-9" data-toggle="tab" data-bs-toggle="tab" data-value="Marginals">Marginals</a>
#>     </li>
#>     <li>
#>       <a href="#tab-4096-10" data-toggle="tab" data-bs-toggle="tab" data-value="Plotly">Plotly</a>
#>     </li>
#>     <li>
#>       <a href="#tab-4096-11" data-toggle="tab" data-bs-toggle="tab" data-value="Extras">Extras</a>
#>     </li>
#>     <li>
#>       <a href="#tab-4096-12" data-toggle="tab" data-bs-toggle="tab" data-value="Lines">Lines</a>
#>     </li>
#>     <li>
#>       <a href="#tab-4096-13" data-toggle="tab" data-bs-toggle="tab" data-value="Axes">Axes</a>
#>     </li>
#>   </ul>
#>   <div class="tab-content" data-tabsetid="4096">
#>     <div class="tab-pane active" data-value="Data" id="tab-4096-1">
#>       <div class="vizmodules-input-grid" style="--viz-input-columns: 2;">
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" style="width:100%;" id="tipify7337463">
#>             <label class="control-label" id="maPlot-x.by-label" for="maPlot-x.by">X Data</label>
#>             <div id="maPlot-x.by" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="change">
#>               <script type="application/json" data-for="maPlot-x.by">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["baseMean","log2FoldChange","lfcSE","stat","pvalue","padj","ensembl","symbol","group"],"value":["baseMean","log2FoldChange","lfcSE","stat","pvalue","padj","ensembl","symbol","group"]}},"config":{"multiple":false,"search":false,"selectedValue":"baseMean","hideClearButton":true,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":false,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":true,"disableOptionGroupCheckbox":true,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify7337463', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Single strings denoting the name of a column of `data_frame` containing numeric data to use for the x- and y-axis of the scatterplot.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" style="width:100%;" id="tipify9333583">
#>             <label class="control-label" id="maPlot-y.by-label" for="maPlot-y.by">Y Data</label>
#>             <div id="maPlot-y.by" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="change">
#>               <script type="application/json" data-for="maPlot-y.by">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["baseMean","log2FoldChange","lfcSE","stat","pvalue","padj","ensembl","symbol","group"],"value":["baseMean","log2FoldChange","lfcSE","stat","pvalue","padj","ensembl","symbol","group"]}},"config":{"multiple":false,"search":false,"selectedValue":"log2FoldChange","hideClearButton":true,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":false,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":true,"disableOptionGroupCheckbox":true,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify9333583', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Single strings denoting the name of a column of `data_frame` containing numeric data to use for the x- and y-axis of the scatterplot.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" style="width:100%;" id="tipify2433926">
#>             <label class="control-label" id="maPlot-color.by-label" for="maPlot-color.by">Color By</label>
#>             <div id="maPlot-color.by" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="change">
#>               <script type="application/json" data-for="maPlot-color.by">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["(none)","baseMean","log2FoldChange","lfcSE","stat","pvalue","padj","group"],"value":["","baseMean","log2FoldChange","lfcSE","stat","pvalue","padj","group"]}},"config":{"multiple":false,"search":false,"selectedValue":"group","hideClearButton":true,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":false,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":true,"disableOptionGroupCheckbox":true,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify2433926', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Single string denoting the name of a column of `data_frame` to use for setting the color of plotted points. Alternatively, a string vector naming multiple such columns of data to plot at once.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" style="width:100%;" id="tipify2829591">
#>             <label class="control-label" id="maPlot-size.by-label" for="maPlot-size.by">Size By</label>
#>             <div id="maPlot-size.by" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="change">
#>               <script type="application/json" data-for="maPlot-size.by">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["(none)","baseMean","log2FoldChange","lfcSE","stat","pvalue","padj"],"value":["","baseMean","log2FoldChange","lfcSE","stat","pvalue","padj"]}},"config":{"multiple":false,"search":false,"selectedValue":"","hideClearButton":true,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":false,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":true,"disableOptionGroupCheckbox":true,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify2829591', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Number which sets the size of data points. Default = 1. Alternatively, a single string denoting the name of a column of `data_frame` to use for setting the size of plotted points.  NOTE: When providing a column name and using `do.hover = TRUE`, the legend will not include meaningful size encoding information.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" style="width:100%;" id="tipify2166260">
#>             <label class="control-label" id="maPlot-shape.by-label" for="maPlot-shape.by">Shape By</label>
#>             <div id="maPlot-shape.by" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="change">
#>               <script type="application/json" data-for="maPlot-shape.by">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["(none)","group"],"value":["","group"]}},"config":{"multiple":false,"search":false,"selectedValue":"","hideClearButton":true,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":false,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":true,"disableOptionGroupCheckbox":true,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify2166260', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Single string denoting the name of a column of `data_frame` containing discrete data to use for setting the shape of plotted points.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" style="width:100%;" id="tipify1200415">
#>             <label class="control-label" id="maPlot-split.by-label" for="maPlot-split.by">Split By</label>
#>             <div id="maPlot-split.by" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="close">
#>               <script type="application/json" data-for="maPlot-split.by">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["(none)","group"],"value":["","group"]}},"config":{"multiple":true,"search":false,"selectedValue":"","hideClearButton":false,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":true,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":false,"disableOptionGroupCheckbox":false,"disabled":false,"dropboxWrapper":"body","zIndex":1060,"maxValues":2}}</script>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify1200415', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': '1 or 2 strings denoting the name(s) of column(s) of `data_frame` containing discrete data to use for faceting / separating data points into separate plots.  When 2 columns are named, c(row,col), the first is used as rows and the second is used for columns of the resulting facet grid.  When 1 column is named, shape control can be achieved with `split.nrow` and `split.ncol`'})}, 500)});</script>
#>         </div>
#>       </div>
#>     </div>
#>     <div class="tab-pane" data-value="Adjustments" id="tab-4096-2">
#>       <div class="vizmodules-input-grid" style="--viz-input-columns: 2;">
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" style="width:100%;" id="tipify1702637">
#>             <label class="control-label" id="maPlot-x.adjustment-label" for="maPlot-x.adjustment">X Adjustment</label>
#>             <div id="maPlot-x.adjustment" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="change">
#>               <script type="application/json" data-for="maPlot-x.adjustment">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["(none)","z-score","relative.to.max"],"value":["","z-score","relative.to.max"]}},"config":{"multiple":false,"search":false,"selectedValue":"","hideClearButton":true,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":false,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":true,"disableOptionGroupCheckbox":true,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify1702637', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'A recognized string indicating whether numeric `x.by`, `y.by`, and `color.by` data should be used directly (default) or should be adjusted to be itemize{ item{"z-score": scaled with the scale() function to produce a relative-to-mean z-score representation} item{"relative.to.max": divided by the maximum value to give percent of max values between [0,1]} }  Ignored if the target data is not numeric as these known adjustments target numeric data only.  In order to leave the unedited data available for use in other features, the adjusted data are put in a new column and that new column is used for plotting. The Adjustment Function is applied first, and the X Adjustment then rescales the result (e.g. log10, then z-score).'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" style="width:100%;" id="tipify5215289">
#>             <label class="control-label" id="maPlot-y.adjustment-label" for="maPlot-y.adjustment">Y Adjustment</label>
#>             <div id="maPlot-y.adjustment" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="change">
#>               <script type="application/json" data-for="maPlot-y.adjustment">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["(none)","z-score","relative.to.max"],"value":["","z-score","relative.to.max"]}},"config":{"multiple":false,"search":false,"selectedValue":"","hideClearButton":true,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":false,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":true,"disableOptionGroupCheckbox":true,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify5215289', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'A recognized string indicating whether numeric `x.by`, `y.by`, and `color.by` data should be used directly (default) or should be adjusted to be itemize{ item{"z-score": scaled with the scale() function to produce a relative-to-mean z-score representation} item{"relative.to.max": divided by the maximum value to give percent of max values between [0,1]} }  Ignored if the target data is not numeric as these known adjustments target numeric data only.  In order to leave the unedited data available for use in other features, the adjusted data are put in a new column and that new column is used for plotting. The Adjustment Function is applied first, and the Y Adjustment then rescales the result (e.g. log10, then z-score).'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" style="width:100%;" id="tipify9634940">
#>             <label class="control-label" id="maPlot-color.adjustment-label" for="maPlot-color.adjustment">Color Adjustment</label>
#>             <div id="maPlot-color.adjustment" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="change">
#>               <script type="application/json" data-for="maPlot-color.adjustment">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["(none)","z-score","relative.to.max"],"value":["","z-score","relative.to.max"]}},"config":{"multiple":false,"search":false,"selectedValue":"","hideClearButton":true,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":false,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":true,"disableOptionGroupCheckbox":true,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify9634940', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'A recognized string indicating whether numeric `x.by`, `y.by`, and `color.by` data should be used directly (default) or should be adjusted to be itemize{ item{"z-score": scaled with the scale() function to produce a relative-to-mean z-score representation} item{"relative.to.max": divided by the maximum value to give percent of max values between [0,1]} }  Ignored if the target data is not numeric as these known adjustments target numeric data only.  In order to leave the unedited data available for use in other features, the adjusted data are put in a new column and that new column is used for plotting. The Adjustment Function is applied first, and the Color Adjustment then rescales the result (e.g. log10, then z-score).'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" style="width:100%;" id="tipify8878725">
#>             <label class="control-label" id="maPlot-x.adj.fxn-label" for="maPlot-x.adj.fxn">X Adjustment Function</label>
#>             <div id="maPlot-x.adj.fxn" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="change">
#>               <script type="application/json" data-for="maPlot-x.adj.fxn">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["(none)","log2","log","log10","neg_log10","log1p","as.factor","abs","sqrt"],"value":["","log2","log","log10","neg_log10","log1p","as.factor","abs","sqrt"]}},"config":{"multiple":false,"search":false,"selectedValue":"log10","hideClearButton":true,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":false,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":true,"disableOptionGroupCheckbox":true,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify8878725', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'If you wish to apply a function to edit the `x.by`, `y.by`, or `color.by` data before use, in a way not possible with the `color.adjustment` input, this input can be given a function which takes in a vector of values as input and returns a vector of values of the same length as output.  For example, `function(x) {log2(x)`} or `as.factor`.  In order to leave the unedited data available for use in other features, the adjusted data are put in a new column and that new column is used for plotting. The Adjustment Function is applied first, and the X Adjustment then rescales the result (e.g. log10, then z-score).'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" style="width:100%;" id="tipify6364466">
#>             <label class="control-label" id="maPlot-y.adj.fxn-label" for="maPlot-y.adj.fxn">Y Adjustment Function</label>
#>             <div id="maPlot-y.adj.fxn" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="change">
#>               <script type="application/json" data-for="maPlot-y.adj.fxn">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["(none)","log2","log","log10","neg_log10","log1p","as.factor","abs","sqrt"],"value":["","log2","log","log10","neg_log10","log1p","as.factor","abs","sqrt"]}},"config":{"multiple":false,"search":false,"selectedValue":"","hideClearButton":true,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":false,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":true,"disableOptionGroupCheckbox":true,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify6364466', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'If you wish to apply a function to edit the `x.by`, `y.by`, or `color.by` data before use, in a way not possible with the `color.adjustment` input, this input can be given a function which takes in a vector of values as input and returns a vector of values of the same length as output.  For example, `function(x) {log2(x)`} or `as.factor`.  In order to leave the unedited data available for use in other features, the adjusted data are put in a new column and that new column is used for plotting. The Adjustment Function is applied first, and the Y Adjustment then rescales the result (e.g. log10, then z-score).'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" style="width:100%;" id="tipify3293803">
#>             <label class="control-label" id="maPlot-color.adj.fxn-label" for="maPlot-color.adj.fxn">Color Adjustment Function</label>
#>             <div id="maPlot-color.adj.fxn" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="change">
#>               <script type="application/json" data-for="maPlot-color.adj.fxn">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["(none)","log2","log","log10","neg_log10","log1p","as.factor","abs","sqrt"],"value":["","log2","log","log10","neg_log10","log1p","as.factor","abs","sqrt"]}},"config":{"multiple":false,"search":false,"selectedValue":"","hideClearButton":true,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":false,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":true,"disableOptionGroupCheckbox":true,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify3293803', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'If you wish to apply a function to edit the `x.by`, `y.by`, or `color.by` data before use, in a way not possible with the `color.adjustment` input, this input can be given a function which takes in a vector of values as input and returns a vector of values of the same length as output.  For example, `function(x) {log2(x)`} or `as.factor`.  In order to leave the unedited data available for use in other features, the adjusted data are put in a new column and that new column is used for plotting. The Adjustment Function is applied first, and the Color Adjustment then rescales the result (e.g. log10, then z-score).'})}, 500)});</script>
#>         </div>
#>       </div>
#>     </div>
#>     <div class="tab-pane" data-value="Points" id="tab-4096-3">
#>       <div class="vizmodules-input-grid" style="--viz-input-columns: 2;">
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify6022224">
#>             <label class="control-label" id="maPlot-size-label" for="maPlot-size">Point Size</label>
#>             <input id="maPlot-size" type="number" class="shiny-input-number form-control" value="1" data-update-on="change" min="0.1"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify6022224', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Number which sets the size of data points. Default = 1. Alternatively, a single string denoting the name of a column of `data_frame` to use for setting the size of plotted points.  NOTE: When providing a column name and using `do.hover = TRUE`, the legend will not include meaningful size encoding information.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify7721615">
#>             <label class="control-label" id="maPlot-size.min-label" for="maPlot-size.min">Min Point Size</label>
#>             <input id="maPlot-size.min" type="number" class="shiny-input-number form-control" value="1" data-update-on="change" min="0" step="0.5"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify7721615', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Smallest point size, drawn for the Size Scale Min value of the &#39;Size By&#39; column.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify2101353">
#>             <label class="control-label" id="maPlot-size.max-label" for="maPlot-size.max">Max Point Size</label>
#>             <input id="maPlot-size.max" type="number" class="shiny-input-number form-control" value="6" data-update-on="change" min="0" step="0.5"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify2101353', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Largest point size, drawn for the Size Scale Max value of the &#39;Size By&#39; column.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify5843084">
#>             <label class="control-label" id="maPlot-size.scale.min-label" for="maPlot-size.scale.min">Size Scale Min</label>
#>             <input id="maPlot-size.scale.min" type="number" class="shiny-input-number form-control" value="NA" data-update-on="change"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify5843084', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': '&#39;Size By&#39; value drawn at the Min Point Size, and where the size legend starts. Leave blank to use the column&#39;s minimum. Smaller values are drawn at the Min Point Size.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify5420758">
#>             <label class="control-label" id="maPlot-size.scale.max-label" for="maPlot-size.scale.max">Size Scale Max</label>
#>             <input id="maPlot-size.scale.max" type="number" class="shiny-input-number form-control" value="NA" data-update-on="change"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify5420758', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': '&#39;Size By&#39; value drawn at the Max Point Size, and where the size legend ends. Leave blank to use the column&#39;s maximum. Larger values are drawn at the Max Point Size.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify923967">
#>             <label class="control-label" id="maPlot-opacity-label" for="maPlot-opacity">Point Opacity</label>
#>             <input id="maPlot-opacity" type="number" class="shiny-input-number form-control" value="1" data-update-on="change" min="0" max="1" step="0.05"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify923967', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Number between 0 and 1. 1 = opaque. 0 = invisible. Default = 1. (In terms of typical ggplot variables, = alpha) Alternatively, a single string denoting the name of a column of `data_frame` to use for setting the opacity of plotted points.  NOTE: When providing a column name and using `do.hover = TRUE`, the legend will not include meaningful opacity encoding information.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify3693408">
#>             <div class="checkbox">
#>               <label>
#>                 <input id="maPlot-show.others" type="checkbox" class="shiny-input-checkbox"/>
#>                 <span>Show Others</span>
#>               </label>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify3693408', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Logical. TRUE by default, whether rows not targeted by `rows.use` should be shown in the background in light gray.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify9524294">
#>             <div class="checkbox">
#>               <label>
#>                 <input id="maPlot-split.show.all.others" type="checkbox" class="shiny-input-checkbox" checked="checked"/>
#>                 <span>Show Split Others</span>
#>               </label>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify9524294', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Logical which sets whether gray "others" points of facets should include all points of other facets (`TRUE`) versus just points left out by `rows.use` which would exist in the current facet (`FALSE`).'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" style="width:100%;" id="tipify9496892">
#>             <label class="control-label" id="maPlot-plot.order-label" for="maPlot-plot.order">Plot Order</label>
#>             <div id="maPlot-plot.order" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="change">
#>               <script type="application/json" data-for="maPlot-plot.order">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["unordered","increasing","decreasing","randomize"],"value":["unordered","increasing","decreasing","randomize"]}},"config":{"multiple":false,"search":false,"selectedValue":"unordered","hideClearButton":true,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":false,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":true,"disableOptionGroupCheckbox":true,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify9496892', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'String. If the data should be plotted based on the order of the color data, sets whether to plot in "increasing", "decreasing", or "randomize"d order.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify4497768">
#>             <label class="control-label" id="maPlot-shape.panel-label" for="maPlot-shape.panel">Shape Panel</label>
#>             <input id="maPlot-shape.panel" type="text" class="shiny-input-text form-control" value="16, 15, 17, 23, 25, 8" data-update-on="change"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify4497768', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Vector of integers, corresponding to ggplot shapes, which sets what shapes to use in conjunction with `shape.by`. When nothing is supplied to `shape.by`, only the first value is used. Default is a set of 6, `c(16,15,17,23,25,8)`, the first being a simple, solid, circle.'})}, 500)});</script>
#>         </div>
#>       </div>
#>     </div>
#>     <div class="tab-pane" data-value="Colors" id="tab-4096-4">
#>       <div class="vizmodules-input-grid" style="--viz-input-columns: 2;">
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour" id="tipify2598183">
#>             <label class="control-label" for="maPlot-min.color">Min Color</label>
#>             <input id="maPlot-min.color" type="text" class="form-control shiny-colour-input" data-init-value="#F0E442" data-show-colour="both" data-palette="square"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify2598183', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Color for `min` value of numeric `color.by`-data. Default = yellow'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour" id="tipify189062">
#>             <label class="control-label" for="maPlot-max.color">Max Color</label>
#>             <input id="maPlot-max.color" type="text" class="form-control shiny-colour-input" data-init-value="#0072B2" data-show-colour="both" data-palette="square"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify189062', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Color for `max` value of numeric `color.by`-data. Default = blue'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour" id="tipify7214050">
#>             <label class="control-label" for="maPlot-contour.color">Contour Color</label>
#>             <input id="maPlot-contour.color" type="text" class="form-control shiny-colour-input" data-init-value="black" data-show-colour="both" data-palette="square"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify7214050', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'String that sets the color of the `do.contour` contours.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" style="width:100%;" id="tipify9528096">
#>             <label class="control-label" id="maPlot-contour.linetype-label" for="maPlot-contour.linetype">Contour Linetype</label>
#>             <div id="maPlot-contour.linetype" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="change">
#>               <script type="application/json" data-for="maPlot-contour.linetype">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["solid","dashed","dotted","dotdash","longdash","twodash"],"value":["solid","dashed","dotted","dotdash","longdash","twodash"]}},"config":{"multiple":false,"search":false,"selectedValue":"solid","hideClearButton":true,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":false,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":true,"disableOptionGroupCheckbox":true,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify9528096', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'String or numeric which sets the type of line used for `do.contour` contours. Defaults to "solid", but see `link[ggplot2]{linetype`} for other options.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div id="maPlot-color.panel.ui" class="shiny-html-output"></div>
#>         </div>
#>       </div>
#>     </div>
#>     <div class="tab-pane" data-value="Facet" id="tab-4096-5">
#>       <div class="vizmodules-input-grid" style="--viz-input-columns: 2;">
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify4402233">
#>             <label class="control-label" id="maPlot-split.nrow-label" for="maPlot-split.nrow">Rows</label>
#>             <input id="maPlot-split.nrow" type="number" class="shiny-input-number form-control" value="NA" data-update-on="change" min="0" step="1"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify4402233', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Integers which set the dimensions of faceting/splitting when faceting by a single feature.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify5040124">
#>             <label class="control-label" id="maPlot-split.ncol-label" for="maPlot-split.ncol">Columns</label>
#>             <input id="maPlot-split.ncol" type="number" class="shiny-input-number form-control" value="NA" data-update-on="change" min="0" step="1"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify5040124', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Integers which set the dimensions of faceting/splitting when faceting by a single feature.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" style="width:100%;" id="tipify435570">
#>             <label class="control-label" id="maPlot-multivar.split.dir-label" for="maPlot-multivar.split.dir">Multivar Split Dir</label>
#>             <div id="maPlot-multivar.split.dir" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="change">
#>               <script type="application/json" data-for="maPlot-multivar.split.dir">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["col","row"],"value":["col","row"]}},"config":{"multiple":false,"search":false,"selectedValue":"col","hideClearButton":true,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":false,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":true,"disableOptionGroupCheckbox":true,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify435570', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': '"row" or "col", sets the direction of faceting used for &#39;var&#39; values when: itemize{ item `var` is given multiple column names item AND `split.by` is used to provide an additional feature to facet by }'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" style="width:100%;" id="tipify9224744">
#>             <label class="control-label" id="maPlot-split.adjust.scales-label" for="maPlot-split.adjust.scales">Facet Scales</label>
#>             <div id="maPlot-split.adjust.scales" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="change">
#>               <script type="application/json" data-for="maPlot-split.adjust.scales">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["fixed","free","free_x","free_y"],"value":["fixed","free","free_x","free_y"]}},"config":{"multiple":false,"search":false,"selectedValue":"fixed","hideClearButton":true,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":false,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":true,"disableOptionGroupCheckbox":true,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify9224744', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Control whether facet panels share the same axis scales or allow them to vary independently'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify9237895">
#>             <label class="control-label" id="maPlot-subplot.margin.x-label" for="maPlot-subplot.margin.x">Subplot Spacing (Horizontal)</label>
#>             <input id="maPlot-subplot.margin.x" type="number" class="shiny-input-number form-control" value="0.03" data-update-on="change" min="0" max="1" step="0.01"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify9237895', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Horizontal spacing between facet panel columns as a fraction of the plot area (e.g. 0.03). Only applies when faceting is active.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify6056477">
#>             <label class="control-label" id="maPlot-subplot.margin.y-label" for="maPlot-subplot.margin.y">Subplot Spacing (Vertical)</label>
#>             <input id="maPlot-subplot.margin.y" type="number" class="shiny-input-number form-control" value="0.1" data-update-on="change" min="0" max="1" step="0.01"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify6056477', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Vertical spacing between facet panel rows as a fraction of the plot area (e.g. 0.1). Only applies when faceting is active.'})}, 500)});</script>
#>         </div>
#>       </div>
#>     </div>
#>     <div class="tab-pane" data-value="Annotations" id="tab-4096-6">
#>       <div class="vizmodules-input-grid" style="--viz-input-columns: 2;">
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" style="width:100%;" id="tipify40820">
#>             <label class="control-label" id="maPlot-annotate.by-label" for="maPlot-annotate.by">Annotate By</label>
#>             <div id="maPlot-annotate.by" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="change">
#>               <script type="application/json" data-for="maPlot-annotate.by">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["(none)","baseMean","log2FoldChange","lfcSE","stat","pvalue","padj","ensembl","symbol","group"],"value":["","baseMean","log2FoldChange","lfcSE","stat","pvalue","padj","ensembl","symbol","group"]}},"config":{"multiple":false,"search":false,"selectedValue":"","hideClearButton":true,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":false,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":true,"disableOptionGroupCheckbox":true,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify40820', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Select a column whose values will be used to identify points for highlighting and annotation'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="shiny-input-textarea form-group shiny-input-container" id="tipify6568564">
#>             <label class="control-label" id="maPlot-highlight.points-label" for="maPlot-highlight.points">Points to Highlight</label>
#>             <textarea id="maPlot-highlight.points" class="form-control" placeholder="Values from &#39;Annotate by&#39; column&#10;(comma, space, or newline delimited)" rows="3" data-update-on="change"></textarea>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify6568564', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Enter specific values from the &#39;Annotate By&#39; column to highlight those points on the plot. Separate values that contain spaces with commas or new lines.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour" id="tipify1509290">
#>             <label class="control-label" for="maPlot-highlight.color">Highlight Fill</label>
#>             <input id="maPlot-highlight.color" type="text" class="form-control shiny-colour-input" data-init-value="#00FFF7" data-show-colour="both" data-palette="square" data-allow-alpha="true"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify1509290', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Choose the fill color for highlighted points'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify1991607">
#>             <label class="control-label" id="maPlot-highlight.size-label" for="maPlot-highlight.size">Highlight Size</label>
#>             <input id="maPlot-highlight.size" type="number" class="shiny-input-number form-control" value="7" data-update-on="change" min="0.1" step="0.5"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify1991607', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Set the size of highlighted points on the plot'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour" id="tipify2396384">
#>             <label class="control-label" for="maPlot-highlight.border.color">Highlight Border Color</label>
#>             <input id="maPlot-highlight.border.color" type="text" class="form-control shiny-colour-input" data-init-value="#000000" data-show-colour="both" data-palette="square"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify2396384', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Choose the border color for highlighted points'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify6615740">
#>             <label class="control-label" id="maPlot-highlight.border.width-label" for="maPlot-highlight.border.width">Highlight Border Width</label>
#>             <input id="maPlot-highlight.border.width" type="number" class="shiny-input-number form-control" value="1" data-update-on="change" min="0" step="0.25"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify6615740', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Set the width of the border around highlighted points'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify2417888">
#>             <div class="checkbox">
#>               <label>
#>                 <input id="maPlot-highlight.auto.annotate" type="checkbox" class="shiny-input-checkbox" checked="checked"/>
#>                 <span>Auto-annotate Highlights</span>
#>               </label>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify2417888', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'When enabled, automatically adds text labels to highlighted points using their &#39;Annotate By&#39; values'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour" id="tipify715498">
#>             <label class="control-label" for="maPlot-annotation.color">Annotation Color</label>
#>             <input id="maPlot-annotation.color" type="text" class="form-control shiny-colour-input" data-init-value="black" data-show-colour="both" data-palette="square"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify715498', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Set the text color for annotation labels'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify7046719">
#>             <label class="control-label" id="maPlot-annotation.ax-label" for="maPlot-annotation.ax">Annotation X Offset</label>
#>             <input id="maPlot-annotation.ax" type="number" class="shiny-input-number form-control" value="20" data-update-on="change" step="1"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify7046719', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Horizontal pixel offset of annotation labels from their target points'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify3153969">
#>             <label class="control-label" id="maPlot-annotation.ay-label" for="maPlot-annotation.ay">Annotation Y Offset</label>
#>             <input id="maPlot-annotation.ay" type="number" class="shiny-input-number form-control" value="-20" data-update-on="change" step="1"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify3153969', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Vertical pixel offset of annotation labels from their target points (negative values move up)'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify3758752">
#>             <label class="control-label" id="maPlot-annotation.size-label" for="maPlot-annotation.size">Annotation Size</label>
#>             <input id="maPlot-annotation.size" type="number" class="shiny-input-number form-control" value="10" data-update-on="change" min="1" step="0.5"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify3758752', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Set the font size of annotation text labels in points'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify8150977">
#>             <div class="checkbox">
#>               <label>
#>                 <input id="maPlot-annotation.showarrow" type="checkbox" class="shiny-input-checkbox" checked="checked"/>
#>                 <span>Show Arrow</span>
#>               </label>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify8150977', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Toggle whether an arrow is drawn from the annotation label to the target point'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour" id="tipify2005600">
#>             <label class="control-label" for="maPlot-annotation.arrowcolor">Arrow Color</label>
#>             <input id="maPlot-annotation.arrowcolor" type="text" class="form-control shiny-colour-input" data-init-value="black" data-show-colour="both" data-palette="square"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify2005600', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Set the color of the annotation arrow connecting the label to the point'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify3019302">
#>             <label class="control-label" id="maPlot-annotation.arrowhead-label" for="maPlot-annotation.arrowhead">Arrowhead Style</label>
#>             <input id="maPlot-annotation.arrowhead" type="number" class="shiny-input-number form-control" value="2" data-update-on="change" min="0" max="7" step="1"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify3019302', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Choose the arrowhead style (0-7) for annotation arrows, where 0 is no arrowhead'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify877203">
#>             <label class="control-label" id="maPlot-annotation.arrowwidth-label" for="maPlot-annotation.arrowwidth">Arrow Linewidth</label>
#>             <input id="maPlot-annotation.arrowwidth" type="number" class="shiny-input-number form-control" value="1.5" data-update-on="change" min="0.1" step="0.25"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify877203', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Set the line width of the annotation arrow'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <button id="maPlot-annotation.clear" type="button" class="btn btn-default action-button"><span class="action-label">Clear Annotations</span></button>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('maPlot-annotation.clear', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Remove all annotation labels and arrows from the current plot'})}, 500)});</script>
#>         </div>
#>       </div>
#>     </div>
#>     <div class="tab-pane" data-value="Legend" id="tab-4096-7">
#>       <div class="vizmodules-input-grid" style="--viz-input-columns: 2;">
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify1833202">
#>             <label class="control-label" id="maPlot-legend.color.title-label" for="maPlot-legend.color.title">Legend Title</label>
#>             <input id="maPlot-legend.color.title" type="text" class="shiny-input-text form-control" value="make" data-update-on="change"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify1833202', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Strings which set the title for the color or shape legends.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify2068019">
#>             <div class="material-switch">
#>               <label for="maPlot-legend.show" style="padding-right: 10px;">Show Legend</label>
#>               <input id="maPlot-legend.show" type="checkbox" checked="checked"/>
#>               <label class="switch label-success bg-success" for="maPlot-legend.show"></label>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify2068019', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Show the legend. Turning it off also hides colorbars and any point size legend.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" style="width:100%;" id="tipify8549595">
#>             <label class="control-label" id="maPlot-legend.font.family-label" for="maPlot-legend.font.family">Legend Font</label>
#>             <div id="maPlot-legend.font.family" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="change">
#>               <script type="application/json" data-for="maPlot-legend.font.family">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["Arial","Balto","Courier New","Droid Sans","Droid Serif","Droid Sans Mono","Gravitas One","Old Standard TT","Open Sans","Overpass","PT Sans Narrow","Raleway","Times New Roman","Verdana","sans-serif","serif","monospace"],"value":["Arial","Balto","Courier New","Droid Sans","Droid Serif","Droid Sans Mono","Gravitas One","Old Standard TT","Open Sans","Overpass","PT Sans Narrow","Raleway","Times New Roman","Verdana","sans-serif","serif","monospace"]}},"config":{"multiple":false,"search":true,"selectedValue":"Arial","hideClearButton":true,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":false,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":true,"disableOptionGroupCheckbox":true,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify8549595', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Font family of the legend title and entry labels.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour" id="tipify2629099">
#>             <label class="control-label" for="maPlot-legend.font.color">Legend Font Color</label>
#>             <input id="maPlot-legend.font.color" type="text" class="form-control shiny-colour-input" data-init-value="#000000" data-show-colour="both" data-palette="square"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify2629099', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Font color of the legend title and entry labels.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify9453342">
#>             <label class="control-label" id="maPlot-legend.title.size-label" for="maPlot-legend.title.size">Legend Title Size</label>
#>             <input id="maPlot-legend.title.size" type="number" class="shiny-input-number form-control" value="14" data-update-on="change" min="0" step="1"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify9453342', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Font size of the legend title.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify7927354">
#>             <label class="control-label" id="maPlot-legend.text.size-label" for="maPlot-legend.text.size">Legend Text Size</label>
#>             <input id="maPlot-legend.text.size" type="number" class="shiny-input-number form-control" value="12" data-update-on="change" min="0" step="1"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify7927354', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Font size of the legend entry labels.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify8315819">
#>             <label class="control-label" id="maPlot-legend.color.breaks-label" for="maPlot-legend.color.breaks">Color Tick Breaks</label>
#>             <input id="maPlot-legend.color.breaks" type="text" class="shiny-input-text form-control" value="" placeholder="e.g. -3, 0, 3" data-update-on="change"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify8315819', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Numeric vector which sets the discrete values to label in the color-scale legend for `color.by`-data.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify6189772">
#>             <label class="control-label" id="maPlot-size.legend.x-label" for="maPlot-size.legend.x">Size Legend X Position</label>
#>             <input id="maPlot-size.legend.x" type="number" class="shiny-input-number form-control" value="1.03" data-update-on="change" step="0.02"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify6189772', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Horizontal position (paper coordinates) of the custom size legend drawn when &#39;Size By&#39; is set. Values just above 1 sit to the right of the plot; lower it to pull the legend inward on narrow plots or raise it to push it further out.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify4437336">
#>             <label class="control-label" id="maPlot-size.legend.y-label" for="maPlot-size.legend.y">Size Legend Y Position</label>
#>             <input id="maPlot-size.legend.y" type="number" class="shiny-input-number form-control" value="0.35" data-update-on="change" step="0.05"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify4437336', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Vertical position (paper coordinates) of the custom size legend drawn when &#39;Size By&#39; is set. Lower it to offset the size legend from an overlapping color or shape legend.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify9646256">
#>             <label class="control-label" id="maPlot-min.value-label" for="maPlot-min.value">Color Min</label>
#>             <input id="maPlot-min.value" type="number" class="shiny-input-number form-control" value="NA" data-update-on="change"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify9646256', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Number which sets the `color.by`-data value associated with the minimum or maximum colors.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify1621987">
#>             <label class="control-label" id="maPlot-max.value-label" for="maPlot-max.value">Color Max</label>
#>             <input id="maPlot-max.value" type="number" class="shiny-input-number form-control" value="NA" data-update-on="change"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify1621987', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Number which sets the `color.by`-data value associated with the minimum or maximum colors.'})}, 500)});</script>
#>         </div>
#>       </div>
#>     </div>
#>     <div class="tab-pane" data-value="Trajectory" id="tab-4096-8">
#>       <div class="vizmodules-input-grid" style="--viz-input-columns: 2;">
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" style="width:100%;" id="tipify1856538">
#>             <label class="control-label" id="maPlot-trajectory.group.by-label" for="maPlot-trajectory.group.by">Trajectory Group By</label>
#>             <div id="maPlot-trajectory.group.by" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="change">
#>               <script type="application/json" data-for="maPlot-trajectory.group.by">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["(none)","group"],"value":["","group"]}},"config":{"multiple":false,"search":false,"selectedValue":"","hideClearButton":true,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":false,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":true,"disableOptionGroupCheckbox":true,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify1856538', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'String denoting the name of a column of `data_frame` to use for generating trajectories from data point groups.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify6131014">
#>             <label class="control-label" id="maPlot-trajectory.arrow.size-label" for="maPlot-trajectory.arrow.size">Trajectory Arrow Size</label>
#>             <input id="maPlot-trajectory.arrow.size" type="number" class="shiny-input-number form-control" value="0.1" data-update-on="change" min="0" step="0.05"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify6131014', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Number representing the size of trajectory arrows, in inches.  Default = 0.15.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div id="maPlot-add.trajectory.by.groups.ui" class="shiny-html-output"></div>
#>         </div>
#>       </div>
#>     </div>
#>     <div class="tab-pane" data-value="Marginals" id="tab-4096-9">
#>       <div class="vizmodules-input-grid" style="--viz-input-columns: 2;">
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" style="width:100%;" id="tipify4814845">
#>             <label class="control-label" id="maPlot-marginal.x-label" for="maPlot-marginal.x">Top Marginal (X)</label>
#>             <div id="maPlot-marginal.x" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="close">
#>               <script type="application/json" data-for="maPlot-marginal.x">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["Density","Histogram","Rug"],"value":["density","histogram","rug"]}},"config":{"multiple":true,"search":false,"selectedValue":[],"hideClearButton":false,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":true,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":false,"disableOptionGroupCheckbox":false,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify4814845', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Distribution of the X values drawn above the plot, one per Color By group. Pick any of density, histogram and rug.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" style="width:100%;" id="tipify3961379">
#>             <label class="control-label" id="maPlot-marginal.y-label" for="maPlot-marginal.y">Right Marginal (Y)</label>
#>             <div id="maPlot-marginal.y" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="close">
#>               <script type="application/json" data-for="maPlot-marginal.y">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["Density","Histogram","Rug"],"value":["density","histogram","rug"]}},"config":{"multiple":true,"search":false,"selectedValue":[],"hideClearButton":false,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":true,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":false,"disableOptionGroupCheckbox":false,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify3961379', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Distribution of the Y values drawn to the right of the plot, one per Color By group. Pick any of density, histogram and rug.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify3187564">
#>             <label class="control-label" id="maPlot-marginal.x.size-label" for="maPlot-marginal.x.size">Top Marginal Height</label>
#>             <input id="maPlot-marginal.x.size" type="number" class="shiny-input-number form-control" value="0.15" data-update-on="change" min="0.05" max="0.5" step="0.05"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify3187564', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Share of the plot&#39;s height given to the top marginal.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify8383750">
#>             <label class="control-label" id="maPlot-marginal.y.size-label" for="maPlot-marginal.y.size">Right Marginal Width</label>
#>             <input id="maPlot-marginal.y.size" type="number" class="shiny-input-number form-control" value="0.15" data-update-on="change" min="0.05" max="0.5" step="0.05"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify8383750', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Share of the plot&#39;s width given to the right marginal.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify2992035">
#>             <label class="control-label" id="maPlot-marginal.opacity-label" for="maPlot-marginal.opacity">Marginal Opacity</label>
#>             <input id="maPlot-marginal.opacity" type="number" class="shiny-input-number form-control" value="0.5" data-update-on="change" min="0" max="1" step="0.05"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify2992035', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Opacity of the density and histogram fills and of the rug lines.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify6160618">
#>             <label class="control-label" id="maPlot-marginal.bins-label" for="maPlot-marginal.bins">Histogram Bins</label>
#>             <input id="maPlot-marginal.bins" type="number" class="shiny-input-number form-control" value="30" data-update-on="change" min="1" step="1"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify6160618', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Number of histogram bins, shared by every group so their bins line up.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify4621038">
#>             <label class="control-label" id="maPlot-marginal.binwidth-label" for="maPlot-marginal.binwidth">Histogram Bin Width</label>
#>             <input id="maPlot-marginal.binwidth" type="number" class="shiny-input-number form-control" value="NA" data-update-on="change" min="0"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify4621038', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Width of each histogram bin, in the axis&#39; units. Overrides Histogram Bins when set. Leave blank to use Histogram Bins.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify9392059">
#>             <label class="control-label" id="maPlot-marginal.density.adjust-label" for="maPlot-marginal.density.adjust">Density Bandwidth Adjust</label>
#>             <input id="maPlot-marginal.density.adjust" type="number" class="shiny-input-number form-control" value="1" data-update-on="change" min="0.1" step="0.1"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify9392059', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Multiplier on the density bandwidth. Larger values give smoother curves.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify62914">
#>             <label class="control-label" id="maPlot-marginal.rug.height-label" for="maPlot-marginal.rug.height">Rug Height</label>
#>             <input id="maPlot-marginal.rug.height" type="number" class="shiny-input-number form-control" value="0.3" data-update-on="change" min="0.1" max="0.9" step="0.05"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify62914', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Share of a marginal given to its rug when the rug sits alongside a density or histogram. A rug on its own fills the marginal.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify3494275">
#>             <label class="control-label" id="maPlot-marginal.rug.width-label" for="maPlot-marginal.rug.width">Rug Line Width</label>
#>             <input id="maPlot-marginal.rug.width" type="number" class="shiny-input-number form-control" value="1" data-update-on="change" min="0.1" step="0.5"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify3494275', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Line width of each rug tick, in pixels.'})}, 500)});</script>
#>         </div>
#>       </div>
#>     </div>
#>     <div class="tab-pane" data-value="Plotly" id="tab-4096-10">
#>       <div class="vizmodules-input-grid" style="--viz-input-columns: 2;">
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" style="width:100%;">
#>             <label class="control-label" id="maPlot-download.format-label" for="maPlot-download.format">Download Format</label>
#>             <div id="maPlot-download.format" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="change">
#>               <script type="application/json" data-for="maPlot-download.format">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["svg","png","jpeg","webp"],"value":["svg","png","jpeg","webp"]}},"config":{"multiple":false,"search":false,"selectedValue":"svg","hideClearButton":true,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":false,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":true,"disableOptionGroupCheckbox":true,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>             </div>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify5662714">
#>             <label class="control-label" id="maPlot-margin.t-label" for="maPlot-margin.t">Margin Top</label>
#>             <input id="maPlot-margin.t" type="number" class="shiny-input-number form-control" value="70" data-update-on="change" min="0" step="5"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify5662714', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Top margin of the plot in pixels'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify5289571">
#>             <label class="control-label" id="maPlot-margin.b-label" for="maPlot-margin.b">Margin Bottom</label>
#>             <input id="maPlot-margin.b" type="number" class="shiny-input-number form-control" value="70" data-update-on="change" min="0" step="5"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify5289571', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Bottom margin of the plot in pixels'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify6370154">
#>             <label class="control-label" id="maPlot-margin.l-label" for="maPlot-margin.l">Margin Left</label>
#>             <input id="maPlot-margin.l" type="number" class="shiny-input-number form-control" value="70" data-update-on="change" min="0" step="5"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify6370154', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Left margin of the plot in pixels'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify3507959">
#>             <label class="control-label" id="maPlot-margin.r-label" for="maPlot-margin.r">Margin Right</label>
#>             <input id="maPlot-margin.r" type="number" class="shiny-input-number form-control" value="90" data-update-on="change" min="0" step="5"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify3507959', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Right margin of the plot in pixels'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour" id="tipify9241712">
#>             <label class="control-label" for="maPlot-shape.fill">Shape Fill</label>
#>             <input id="maPlot-shape.fill" type="text" class="form-control shiny-colour-input" data-init-value="rgba(0, 0, 0, 0)" data-show-colour="both" data-palette="square" data-allow-alpha="true"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify9241712', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Interior fill color for shapes drawn on the plot using Plotly&#39;s drawing tools'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour" id="tipify4740412">
#>             <label class="control-label" for="maPlot-shape.line.color">Shape Line Color</label>
#>             <input id="maPlot-shape.line.color" type="text" class="form-control shiny-colour-input" data-init-value="black" data-show-colour="both" data-palette="square" data-allow-alpha="true"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify4740412', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Outline color for shapes drawn on the plot using Plotly&#39;s drawing tools'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify7781341">
#>             <label class="control-label" id="maPlot-shape.line.width-label" for="maPlot-shape.line.width">Shape Line Width</label>
#>             <input id="maPlot-shape.line.width" type="number" class="shiny-input-number form-control" value="4" data-update-on="change" min="0" step="0.25"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify7781341', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Outline width for shapes drawn on the plot using Plotly&#39;s drawing tools'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" style="width:100%;" id="tipify7987365">
#>             <label class="control-label" id="maPlot-shape.linetype-label" for="maPlot-shape.linetype">Shape Linetype</label>
#>             <div id="maPlot-shape.linetype" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="change">
#>               <script type="application/json" data-for="maPlot-shape.linetype">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["solid","dot","dash","longdash","dashdot","longdashdot"],"value":["solid","dot","dash","longdash","dashdot","longdashdot"]}},"config":{"multiple":false,"search":false,"selectedValue":"solid","hideClearButton":true,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":false,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":true,"disableOptionGroupCheckbox":true,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify7987365', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Line dash style for shapes drawn on the plot using Plotly&#39;s drawing tools'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify8784999">
#>             <label class="control-label" id="maPlot-shape.opacity-label" for="maPlot-shape.opacity">Shape Opacity</label>
#>             <input id="maPlot-shape.opacity" type="number" class="shiny-input-number form-control" value="1" data-update-on="change" min="0" max="1" step="0.01"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify8784999', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Opacity of shapes drawn on the plot, where 0 is fully transparent and 1 is fully opaque'})}, 500)});</script>
#>         </div>
#>       </div>
#>     </div>
#>     <div class="tab-pane" data-value="Extras" id="tab-4096-11">
#>       <div class="vizmodules-input-grid" style="--viz-input-columns: 2;">
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify9098438">
#>             <div class="checkbox">
#>               <label>
#>                 <input id="maPlot-webgl" type="checkbox" class="shiny-input-checkbox" checked="checked"/>
#>                 <span>Plot with webGL</span>
#>               </label>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify9098438', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Enable WebGL rendering for improved performance with large datasets at the cost of some visual features'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify4455378">
#>             <div class="checkbox">
#>               <label>
#>                 <input id="maPlot-do.ellipse" type="checkbox" class="shiny-input-checkbox"/>
#>                 <span>Enable Ellipses</span>
#>               </label>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify4455378', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Logical. Whether `color.by` groups should be surrounded by median-centered ellipses.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify2895593">
#>             <div class="checkbox">
#>               <label>
#>                 <input id="maPlot-do.contour" type="checkbox" class="shiny-input-checkbox"/>
#>                 <span>Enable Contour</span>
#>               </label>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify2895593', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Logical. Whether density-based contours should be displayed.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" style="width:100%;" id="tipify3033108">
#>             <label class="control-label" id="maPlot-hover.data-label" for="maPlot-hover.data">Hover Data</label>
#>             <div id="maPlot-hover.data" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="close">
#>               <script type="application/json" data-for="maPlot-hover.data">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["(none)","baseMean","log2FoldChange","lfcSE","stat","pvalue","padj","ensembl","symbol","group"],"value":["","baseMean","log2FoldChange","lfcSE","stat","pvalue","padj","ensembl","symbol","group"]}},"config":{"multiple":true,"search":false,"selectedValue":["symbol","baseMean","log2FoldChange"],"hideClearButton":false,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":true,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":false,"disableOptionGroupCheckbox":false,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify3033108', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'String vector which denotes what data to show for each data point, upon hover, when `do.hover` is set to `TRUE`. Defaults to all data expected to be useful. Only values present in the plotting data are actually used. These can be column names of `data_frame` and any column names which will be created to accommodate multivar and data adjustment functionality. You can run the function with `data.out = TRUE` and inspect the `$Target_data` output&#39;s columns to view your available options.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify9190243">
#>             <label class="control-label" id="maPlot-hover.round.digits-label" for="maPlot-hover.round.digits">Hover Round Digits</label>
#>             <input id="maPlot-hover.round.digits" type="number" class="shiny-input-number form-control" value="5" data-update-on="change" min="1" step="1"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify9190243', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Integer number specifying the number of decimal digits to round displayed numeric values to, when `do.hover` is set to `TRUE`.'})}, 500)});</script>
#>         </div>
#>       </div>
#>     </div>
#>     <div class="tab-pane" data-value="Lines" id="tab-4096-12">
#>       <div class="vizmodules-input-grid" style="--viz-input-columns: 2;">
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify9357124">
#>             <label class="control-label" id="maPlot-hline.intercepts-label" for="maPlot-hline.intercepts">Y-intercepts</label>
#>             <input id="maPlot-hline.intercepts" type="text" class="shiny-input-text form-control" value="" placeholder="e.g. 2, -2" data-update-on="change"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify9357124', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'For categorical or factor axes, enter the index (position) of the category rather than its name. For example, if the axis categories are &#39;Audi&#39;, &#39;Mercedes&#39;, &#39;Bugatti&#39;, enter 2 to place a line at &#39;Mercedes&#39;.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify6716483">
#>             <label class="control-label" id="maPlot-hline.colors-label" for="maPlot-hline.colors">Y Colors</label>
#>             <input id="maPlot-hline.colors" type="text" class="shiny-input-text form-control" value="#000000" data-update-on="change"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify6716483', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Color(s) for horizontal reference lines, as comma-separated hex codes or color names'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify3712700">
#>             <label class="control-label" id="maPlot-hline.widths-label" for="maPlot-hline.widths">Y Widths</label>
#>             <input id="maPlot-hline.widths" type="text" class="shiny-input-text form-control" value="1" data-update-on="change"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify3712700', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Width(s) for horizontal reference lines in pixels, as comma-separated values'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify5671314">
#>             <label class="control-label" id="maPlot-hline.linetypes-label" for="maPlot-hline.linetypes">Y Line Types</label>
#>             <input id="maPlot-hline.linetypes" type="text" class="shiny-input-text form-control" value="dashed" placeholder="solid, dashed, dotted, ..." data-update-on="change"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify5671314', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Line style(s) for horizontal reference lines (solid, dashed, dotted, dotdash, longdash, twodash)'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify4785984">
#>             <label class="control-label" id="maPlot-hline.opacities-label" for="maPlot-hline.opacities">Y Opacities (0-1)</label>
#>             <input id="maPlot-hline.opacities" type="text" class="shiny-input-text form-control" value="1" data-update-on="change"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify4785984', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Opacity of horizontal reference lines between 0 (transparent) and 1 (opaque), as comma-separated values'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify5677488">
#>             <label class="control-label" id="maPlot-vline.intercepts-label" for="maPlot-vline.intercepts">X-intercepts</label>
#>             <input id="maPlot-vline.intercepts" type="text" class="shiny-input-text form-control" value="" placeholder="e.g. 2, -2" data-update-on="change"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify5677488', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'For categorical or factor axes, enter the index (position) of the category rather than its name. For example, if the axis categories are &#39;Audi&#39;, &#39;Mercedes&#39;, &#39;Bugatti&#39;, enter 2 to place a line at &#39;Mercedes&#39;.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify2865389">
#>             <label class="control-label" id="maPlot-vline.colors-label" for="maPlot-vline.colors">X Colors</label>
#>             <input id="maPlot-vline.colors" type="text" class="shiny-input-text form-control" value="#000000" data-update-on="change"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify2865389', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Color(s) for vertical reference lines, as comma-separated hex codes or color names'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify7595991">
#>             <label class="control-label" id="maPlot-vline.widths-label" for="maPlot-vline.widths">X Widths</label>
#>             <input id="maPlot-vline.widths" type="text" class="shiny-input-text form-control" value="1" data-update-on="change"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify7595991', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Width(s) for vertical reference lines in pixels, as comma-separated values'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify2284658">
#>             <label class="control-label" id="maPlot-vline.linetypes-label" for="maPlot-vline.linetypes">X Line Types</label>
#>             <input id="maPlot-vline.linetypes" type="text" class="shiny-input-text form-control" value="dashed" placeholder="solid, dashed, dotted, ..." data-update-on="change"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify2284658', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Line style(s) for vertical reference lines (solid, dashed, dotted, dotdash, longdash, twodash)'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify4265054">
#>             <label class="control-label" id="maPlot-vline.opacities-label" for="maPlot-vline.opacities">X Opacities (0-1)</label>
#>             <input id="maPlot-vline.opacities" type="text" class="shiny-input-text form-control" value="1" data-update-on="change"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify4265054', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Opacity of vertical reference lines between 0 (transparent) and 1 (opaque), as comma-separated values'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify4565847">
#>             <label class="control-label" id="maPlot-abline.slopes-label" for="maPlot-abline.slopes">Ab Slopes</label>
#>             <input id="maPlot-abline.slopes" type="text" class="shiny-input-text form-control" value="" data-update-on="change"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify4565847', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Slope(s) of diagonal reference lines (rise/run), as comma-separated values'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify7099067">
#>             <label class="control-label" id="maPlot-abline.intercepts-label" for="maPlot-abline.intercepts">Ab Y-intercepts</label>
#>             <input id="maPlot-abline.intercepts" type="text" class="shiny-input-text form-control" value="" data-update-on="change"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify7099067', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'For categorical or factor axes, enter the index (position) of the category rather than its name. For example, if the axis categories are &#39;Audi&#39;, &#39;Mercedes&#39;, &#39;Bugatti&#39;, enter 2 to place a line at &#39;Mercedes&#39;.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify2874570">
#>             <label class="control-label" id="maPlot-abline.colors-label" for="maPlot-abline.colors">Ab Colors</label>
#>             <input id="maPlot-abline.colors" type="text" class="shiny-input-text form-control" value="#000000" data-update-on="change"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify2874570', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Color(s) for diagonal reference lines, as comma-separated hex codes or color names'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify7730602">
#>             <label class="control-label" id="maPlot-abline.widths-label" for="maPlot-abline.widths">Ab Widths</label>
#>             <input id="maPlot-abline.widths" type="text" class="shiny-input-text form-control" value="1" data-update-on="change"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify7730602', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Width(s) for diagonal reference lines in pixels, as comma-separated values'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify5745623">
#>             <label class="control-label" id="maPlot-abline.linetypes-label" for="maPlot-abline.linetypes">Ab Line Types</label>
#>             <input id="maPlot-abline.linetypes" type="text" class="shiny-input-text form-control" value="dashed" placeholder="solid, dashed, dotted, ..." data-update-on="change"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify5745623', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Line style(s) for diagonal reference lines (solid, dashed, dotted, dotdash, longdash, twodash)'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify217958">
#>             <label class="control-label" id="maPlot-abline.opacities-label" for="maPlot-abline.opacities">Ab Opacities (0-1)</label>
#>             <input id="maPlot-abline.opacities" type="text" class="shiny-input-text form-control" value="1" data-update-on="change"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify217958', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Opacity of diagonal reference lines between 0 (transparent) and 1 (opaque), as comma-separated values'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify7730265">
#>             <div class="material-switch">
#>               <label for="maPlot-best.fit" style="padding-right: 10px;">Plot Best Fit Line</label>
#>               <input id="maPlot-best.fit" type="checkbox"/>
#>               <label class="switch label-success bg-success" for="maPlot-best.fit"></label>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify7730265', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Add a LOESS smoothed curve of best fit to the scatter plot'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify591290">
#>             <label class="control-label" id="maPlot-line.best.smoothness-label" for="maPlot-line.best.smoothness">Best Fit Line Smoothness</label>
#>             <input id="maPlot-line.best.smoothness" type="number" class="shiny-input-number form-control" value="1" data-update-on="change" min="0" max="10000"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify591290', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Smoothing span for the LOESS curve; higher values produce a smoother, less wiggly fit'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour" id="tipify276483">
#>             <label class="control-label" for="maPlot-line.best.colour">Best Fit Line Color</label>
#>             <input id="maPlot-line.best.colour" type="text" class="form-control shiny-colour-input" data-init-value="#000000" data-show-colour="both" data-palette="square"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify276483', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Color for the LOESS best fit line'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify7408466">
#>             <div class="material-switch">
#>               <label for="maPlot-linear.model" style="padding-right: 10px;">Linear Model Line</label>
#>               <input id="maPlot-linear.model" type="checkbox"/>
#>               <label class="switch label-success bg-success" for="maPlot-linear.model"></label>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify7408466', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Add a linear regression line to the scatter plot'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify5933208">
#>             <div class="material-switch">
#>               <label for="maPlot-custom.model.enable" style="padding-right: 10px;">Custom Model Lines</label>
#>               <input id="maPlot-custom.model.enable" type="checkbox"/>
#>               <label class="switch label-success bg-success" for="maPlot-custom.model.enable"></label>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify5933208', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Fit one or more custom models from formulas you define below and overlay them as lines. Only data columns and basic math/transform terms are allowed.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="multi-dynamic-input shiny-input-container form-group is-plain" id="maPlot-custom.models" data-keys="[&quot;model_type&quot;,&quot;formula&quot;,&quot;line_colour&quot;,&quot;line_width&quot;,&quot;drc_fct&quot;]" data-initial="[]" data-input-id="maPlot-custom.models" data-row-prefix="models">
#>             <div class="mdi-top">
#>               <label class="control-label" for="maPlot-custom.models">Models</label>
#>               <button type="button" class="mdi-add btn btn-default btn-sm">+ Add</button>
#>             </div>
#>             <div class="mdi-rows"></div>
#>             <template class="mdi-row-template">
#>               <div class="mdi-row">
#>                 <div class="mdi-fields">
#>                   <div class="mdi-field" data-key="model_type" style="flex: 1 1 calc(25% - 8px); min-width: 120px;">
#>                     <div class="form-group shiny-input-container">
#>                       <label class="control-label" id="maPlot-custom.models-__ROWIDX__-model_type-label" for="maPlot-custom.models-__ROWIDX__-model_type">Model type</label>
#>                       <div>
#>                         <select id="maPlot-custom.models-__ROWIDX__-model_type" class="shiny-input-select"><option value="drm">drm</option>
#> <option value="glm">glm</option>
#> <option value="lm" selected>lm</option>
#> <option value="loess">loess</option></select>
#>                         <script type="application/json" data-for="maPlot-custom.models-__ROWIDX__-model_type" data-nonempty="">{"plugins":["selectize-plugin-a11y"]}</script>
#>                       </div>
#>                     </div>
#>                   </div>
#>                   <div class="mdi-field" data-key="formula" style="flex: 1 1 calc(25% - 8px); min-width: 120px;">
#>                     <div class="form-group shiny-input-container">
#>                       <label class="control-label" id="maPlot-custom.models-__ROWIDX__-formula-label" for="maPlot-custom.models-__ROWIDX__-formula">Formula</label>
#>                       <input id="maPlot-custom.models-__ROWIDX__-formula" type="text" class="shiny-input-text form-control" value="" placeholder="e.g. y ~ poly(x, 2)" data-update-on="change"/>
#>                     </div>
#>                   </div>
#>                   <div class="mdi-field" data-key="line_colour" style="flex: 1 1 calc(25% - 8px); min-width: 120px;">
#>                     <div class="form-group shiny-input-container" data-shiny-input-type="colour">
#>                       <label class="control-label" for="maPlot-custom.models-__ROWIDX__-line_colour">Line colour</label>
#>                       <input id="maPlot-custom.models-__ROWIDX__-line_colour" type="text" class="form-control shiny-colour-input" data-init-value="#000000" data-show-colour="both" data-palette="square"/>
#>                     </div>
#>                   </div>
#>                   <div class="mdi-field" data-key="line_width" style="flex: 1 1 calc(25% - 8px); min-width: 120px;">
#>                     <div class="form-group shiny-input-container">
#>                       <label class="control-label" id="maPlot-custom.models-__ROWIDX__-line_width-label" for="maPlot-custom.models-__ROWIDX__-line_width">Line width</label>
#>                       <input id="maPlot-custom.models-__ROWIDX__-line_width" type="number" class="shiny-input-number form-control" value="2" data-update-on="change" min="0.5" max="20" step="0.5"/>
#>                     </div>
#>                   </div>
#>                   <div class="mdi-field" data-key="drc_fct" data-backend="drm" style="flex: 1 1 calc(25% - 8px); min-width: 120px; display: none;">
#>                     <div class="form-group shiny-input-container">
#>                       <label class="control-label" id="maPlot-custom.models-__ROWIDX__-drc_fct-label" for="maPlot-custom.models-__ROWIDX__-drc_fct">Drc fct</label>
#>                       <div>
#>                         <select id="maPlot-custom.models-__ROWIDX__-drc_fct" class="shiny-input-select"><option value="LL.4" selected>LL.4</option>
#> <option value="LL.3">LL.3</option>
#> <option value="LL.2">LL.2</option>
#> <option value="W1.4">W1.4</option>
#> <option value="W2.4">W2.4</option></select>
#>                         <script type="application/json" data-for="maPlot-custom.models-__ROWIDX__-drc_fct" data-nonempty="">{"plugins":["selectize-plugin-a11y"]}</script>
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
#>     <div class="tab-pane" data-value="Axes" id="tab-4096-13">
#>       <div class="vizmodules-input-grid" style="--viz-input-columns: 2;">
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" style="width:100%;">
#>             <label class="control-label" id="maPlot-title.font.family-label" for="maPlot-title.font.family">Title Font</label>
#>             <div id="maPlot-title.font.family" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="change">
#>               <script type="application/json" data-for="maPlot-title.font.family">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["Arial","Balto","Courier New","Droid Sans","Droid Serif","Droid Sans Mono","Gravitas One","Old Standard TT","Open Sans","Overpass","PT Sans Narrow","Raleway","Times New Roman","Verdana","sans-serif","serif","monospace"],"value":["Arial","Balto","Courier New","Droid Sans","Droid Serif","Droid Sans Mono","Gravitas One","Old Standard TT","Open Sans","Overpass","PT Sans Narrow","Raleway","Times New Roman","Verdana","sans-serif","serif","monospace"]}},"config":{"multiple":false,"search":true,"selectedValue":"Arial","hideClearButton":true,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":false,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":true,"disableOptionGroupCheckbox":true,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>             </div>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour">
#>             <label class="control-label" for="maPlot-title.font.color">Title Color</label>
#>             <input id="maPlot-title.font.color" type="text" class="form-control shiny-colour-input" data-init-value="#000000" data-show-colour="both" data-palette="square"/>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="maPlot-title.font.size-label" for="maPlot-title.font.size">Title Size</label>
#>             <input id="maPlot-title.font.size" type="number" class="shiny-input-number form-control" value="26" data-update-on="change" min="1" step="1"/>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="maPlot-axis.title.horizontal.position-label" for="maPlot-axis.title.horizontal.position">Title position</label>
#>             <input id="maPlot-axis.title.horizontal.position" type="number" class="shiny-input-number form-control" value="0.5" data-update-on="change" min="0" max="1" step="0.1"/>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="maPlot-axis.title.font.size-label" for="maPlot-axis.title.font.size">Axis Title Size</label>
#>             <input id="maPlot-axis.title.font.size" type="number" class="shiny-input-number form-control" value="18" data-update-on="change" min="1" step="1"/>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour">
#>             <label class="control-label" for="maPlot-axis.title.font.color">Axis Title Color</label>
#>             <input id="maPlot-axis.title.font.color" type="text" class="form-control shiny-colour-input" data-init-value="#000000" data-show-colour="both" data-palette="square"/>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" style="width:100%;">
#>             <label class="control-label" id="maPlot-axis.title.font.family-label" for="maPlot-axis.title.font.family">Axis Title Font</label>
#>             <div id="maPlot-axis.title.font.family" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="change">
#>               <script type="application/json" data-for="maPlot-axis.title.font.family">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["Arial","Balto","Courier New","Droid Sans","Droid Serif","Droid Sans Mono","Gravitas One","Old Standard TT","Open Sans","Overpass","PT Sans Narrow","Raleway","Times New Roman","Verdana","sans-serif","serif","monospace"],"value":["Arial","Balto","Courier New","Droid Sans","Droid Serif","Droid Sans Mono","Gravitas One","Old Standard TT","Open Sans","Overpass","PT Sans Narrow","Raleway","Times New Roman","Verdana","sans-serif","serif","monospace"]}},"config":{"multiple":false,"search":true,"selectedValue":"Arial","hideClearButton":true,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":false,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":true,"disableOptionGroupCheckbox":true,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>             </div>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container">
#>             <div class="checkbox">
#>               <label>
#>                 <input id="maPlot-axis.showline" type="checkbox" class="shiny-input-checkbox" checked="checked"/>
#>                 <span>Show Axis Borders</span>
#>               </label>
#>             </div>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container">
#>             <div class="checkbox">
#>               <label>
#>                 <input id="maPlot-axis.mirror" type="checkbox" class="shiny-input-checkbox" checked="checked"/>
#>                 <span>Mirror Axis Borders</span>
#>               </label>
#>             </div>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container">
#>             <div class="checkbox">
#>               <label>
#>                 <input id="maPlot-show.grid.x" type="checkbox" class="shiny-input-checkbox" checked="checked"/>
#>                 <span>Show X Gridlines</span>
#>               </label>
#>             </div>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container">
#>             <div class="checkbox">
#>               <label>
#>                 <input id="maPlot-show.grid.y" type="checkbox" class="shiny-input-checkbox" checked="checked"/>
#>                 <span>Show Y Gridlines</span>
#>               </label>
#>             </div>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour">
#>             <label class="control-label" for="maPlot-grid.color">Gridline Color</label>
#>             <input id="maPlot-grid.color" type="text" class="form-control shiny-colour-input" data-init-value="#CCCCCC" data-show-colour="both" data-palette="square"/>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour">
#>             <label class="control-label" for="maPlot-axis.linecolor">Axis Line Color</label>
#>             <input id="maPlot-axis.linecolor" type="text" class="form-control shiny-colour-input" data-init-value="black" data-show-colour="both" data-palette="square"/>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="maPlot-axis.linewidth-label" for="maPlot-axis.linewidth">Axis Line Width</label>
#>             <input id="maPlot-axis.linewidth" type="number" class="shiny-input-number form-control" value="0.5" data-update-on="change" min="0" step="0.1"/>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="maPlot-axis.tickfont.size-label" for="maPlot-axis.tickfont.size">Tick Label Size</label>
#>             <input id="maPlot-axis.tickfont.size" type="number" class="shiny-input-number form-control" value="12" data-update-on="change" min="1" step="1"/>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour">
#>             <label class="control-label" for="maPlot-axis.tickfont.color">Tick Label Color</label>
#>             <input id="maPlot-axis.tickfont.color" type="text" class="form-control shiny-colour-input" data-init-value="black" data-show-colour="both" data-palette="square"/>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" style="width:100%;">
#>             <label class="control-label" id="maPlot-axis.tickfont.family-label" for="maPlot-axis.tickfont.family">Tick Label Font</label>
#>             <div id="maPlot-axis.tickfont.family" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="change">
#>               <script type="application/json" data-for="maPlot-axis.tickfont.family">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["Arial","Balto","Courier New","Droid Sans","Droid Serif","Droid Sans Mono","Gravitas One","Old Standard TT","Open Sans","Overpass","PT Sans Narrow","Raleway","Times New Roman","Verdana","sans-serif","serif","monospace"],"value":["Arial","Balto","Courier New","Droid Sans","Droid Serif","Droid Sans Mono","Gravitas One","Old Standard TT","Open Sans","Overpass","PT Sans Narrow","Raleway","Times New Roman","Verdana","sans-serif","serif","monospace"]}},"config":{"multiple":false,"search":true,"selectedValue":"Arial","hideClearButton":true,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":false,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":true,"disableOptionGroupCheckbox":true,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>             </div>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="maPlot-axis.tickangle.x-label" for="maPlot-axis.tickangle.x">X Tick Label Angle</label>
#>             <input id="maPlot-axis.tickangle.x" type="number" class="shiny-input-number form-control" value="0" data-update-on="change" min="-180" max="180" step="15"/>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="maPlot-axis.tickangle.y-label" for="maPlot-axis.tickangle.y">Y Tick Label Angle</label>
#>             <input id="maPlot-axis.tickangle.y" type="number" class="shiny-input-number form-control" value="0" data-update-on="change" min="-180" max="180" step="15"/>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" style="width:100%;">
#>             <label class="control-label" id="maPlot-axis.ticks-label" for="maPlot-axis.ticks">Tick Position</label>
#>             <div id="maPlot-axis.ticks" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="change">
#>               <script type="application/json" data-for="maPlot-axis.ticks">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["Outside","Inside","(none)"],"value":["outside","inside",""]}},"config":{"multiple":false,"search":false,"selectedValue":"outside","hideClearButton":true,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":false,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":true,"disableOptionGroupCheckbox":true,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>             </div>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour">
#>             <label class="control-label" for="maPlot-axis.tickcolor">Tick Mark Color</label>
#>             <input id="maPlot-axis.tickcolor" type="text" class="form-control shiny-colour-input" data-init-value="black" data-show-colour="both" data-palette="square"/>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="maPlot-axis.ticklen-label" for="maPlot-axis.ticklen">Tick Mark Length</label>
#>             <input id="maPlot-axis.ticklen" type="number" class="shiny-input-number form-control" value="5" data-update-on="change" min="0" step="1"/>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="maPlot-axis.tickwidth-label" for="maPlot-axis.tickwidth">Tick Mark Width</label>
#>             <input id="maPlot-axis.tickwidth" type="number" class="shiny-input-number form-control" value="1" data-update-on="change" min="0" step="0.1"/>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="maPlot-facet.title.font.size-label" for="maPlot-facet.title.font.size">Facet Subplot Title Size</label>
#>             <input id="maPlot-facet.title.font.size" type="number" class="shiny-input-number form-control" value="18" data-update-on="change" min="1" step="1"/>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour">
#>             <label class="control-label" for="maPlot-facet.title.font.color">Facet Title Color</label>
#>             <input id="maPlot-facet.title.font.color" type="text" class="form-control shiny-colour-input" data-init-value="#000000" data-show-colour="both" data-palette="square"/>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" style="width:100%;">
#>             <label class="control-label" id="maPlot-facet.title.font.family-label" for="maPlot-facet.title.font.family">Facet Title Font</label>
#>             <div id="maPlot-facet.title.font.family" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="change">
#>               <script type="application/json" data-for="maPlot-facet.title.font.family">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["Arial","Balto","Courier New","Droid Sans","Droid Serif","Droid Sans Mono","Gravitas One","Old Standard TT","Open Sans","Overpass","PT Sans Narrow","Raleway","Times New Roman","Verdana","sans-serif","serif","monospace"],"value":["Arial","Balto","Courier New","Droid Sans","Droid Serif","Droid Sans Mono","Gravitas One","Old Standard TT","Open Sans","Overpass","PT Sans Narrow","Raleway","Times New Roman","Verdana","sans-serif","serif","monospace"]}},"config":{"multiple":false,"search":true,"selectedValue":"Arial","hideClearButton":true,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":false,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":true,"disableOptionGroupCheckbox":true,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
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
#>         <label for="maPlot-auto.update" style="padding-right: 10px;">Auto Update</label>
#>         <input id="maPlot-auto.update" type="checkbox" checked="checked"/>
#>         <label class="switch label-success bg-success" for="maPlot-auto.update"></label>
#>       </div>
#>     </div>
#>   </div>
#>   <div class="module-tack-buttons" style="display: flex; flex-wrap: wrap; gap: 8px;">
#>     <button class="btn btn-default action-button btn-primary" id="maPlot-update" style="flex: 1 1 45%;" type="button"><span class="action-label">Update</span></button>
#>     <button class="btn btn-default action-button btn-secondary" id="maPlot-reset" style="flex: 1 1 45%;" type="button"><span class="action-label">Reset</span></button>
#>     <a aria-disabled="true" class="btn btn-default shiny-download-link disabled btn-secondary viz-source-download" data-viz-source-ns="maPlot-" download href="" id="maPlot-download.source" style="flex: 1 1 100%;" tabindex="-1" target="_blank">
#>       <i class="far fa-file-code" role="presentation" aria-label="file-code icon"></i>
#>       Source Download
#>     </a>
#>     <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('maPlot-download.source', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Download the plot as a self-contained HTML file and as SVG and PNG images of it as it looks now, along with the plot source data and statistics (if applicable) as CSV files.'})}, 500)});</script>
#>   </div>
#> </div>
```
