# Input UI components for the pcaBiplot module

This should be placed in the UI where the inputs should be shown, with
an `id` that matches the `id` used in the
[`pcaBiplotServer()`](https://j-andrews7.github.io/sciVizModules/reference/pcaBiplotServer.md)
and
[`pcaBiplotOutputUI()`](https://j-andrews7.github.io/sciVizModules/reference/pcaBiplotOutputUI.md)
functions.

## Usage

``` r
pcaBiplotInputsUI(
  id,
  data,
  defaults = NULL,
  title = "PCA Biplot Settings",
  columns = 2
)
```

## Arguments

- id:

  The ID for the Shiny module.

- data:

  A PCAtools `pca` object.

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

The module plots the sample scores of a PCAtools `pca` object (from
[`PCAtools::pca()`](https://rdrr.io/pkg/PCAtools/man/pca.html)), the
interactive counterpart of
[`PCAtools::biplot()`](https://rdrr.io/pkg/PCAtools/man/biplot.html). It
wraps
[`VizModules::dittoViz_scatterPlotInputsUI()`](https://j-andrews7.github.io/VizModules/reference/dittoViz_scatterPlotInputsUI.html)
on a table of the scores joined to the object's sample metadata, so
colour, shape, faceting, ellipses, point annotations and the rest of the
scatter module's controls all apply. Those inputs are documented there;
only the biplot additions are listed here.

When both axes show components and no axis adjustment is active, the
axis titles carry the variance each component explains, and the loading
arrows can be drawn.

## Plot parameters and defaults

The following parameters can be accessed via UI inputs and/or the
`defaults` argument:

- `x.by`, `y.by` - Components on the axes (default: `"PC1"`, `"PC2"`)

- `color.by` - Colour column (default: the first discrete metadata
  column)

- `show.loadings` - Draw loading arrows (default: FALSE; PCAtools
  `showLoadings`)

- `n.top.loadings` - Variables with the largest absolute loading on each
  axis to draw (default: 5; PCAtools `ntopLoadings`)

- `loadings.length.factor` - Arrow length multiplier (default: 0.5;
  PCAtools `lengthLoadingsArrowsFactor`)

- `loadings.color` - Arrow and label colour (default: "#000000")

- `loadings.label.size` - Arrow label font size (default: 12)

- All other
  [`VizModules::dittoViz_scatterPlotInputsUI()`](https://j-andrews7.github.io/VizModules/reference/dittoViz_scatterPlotInputsUI.html)
  parameters

## See also

[`PCAtools::biplot()`](https://rdrr.io/pkg/PCAtools/man/biplot.html),
[`VizModules::dittoViz_scatterPlotInputsUI()`](https://j-andrews7.github.io/VizModules/reference/dittoViz_scatterPlotInputsUI.html),
[`pcaBiplotOutputUI()`](https://j-andrews7.github.io/sciVizModules/reference/pcaBiplotOutputUI.md),
[`pcaBiplotServer()`](https://j-andrews7.github.io/sciVizModules/reference/pcaBiplotServer.md),
[`pcaBiplotApp()`](https://j-andrews7.github.io/sciVizModules/reference/pcaBiplotApp.md)

## Author

Jared Andrews

## Examples

``` r
library(sciVizModules)
data(example_pca)
pcaBiplotInputsUI("biplot", example_pca)
#> <div class="vizmodules-input-grid" style="--viz-input-columns: 2;">
#>   <div class="vizmodules-input-cell">
#>     <div class="form-group shiny-input-container" id="tipify3050290">
#>       <div class="material-switch">
#>         <label for="biplot-show.loadings" style="padding-right: 10px;">Loading Arrows</label>
#>         <input id="biplot-show.loadings" type="checkbox"/>
#>         <label class="switch label-success bg-success" for="biplot-show.loadings"></label>
#>       </div>
#>     </div>
#>     <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify3050290', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Draw arrows for the variables loading most strongly on the two components. Shown when both axes are components and no axis adjustment is set.'})}, 500)});</script>
#>   </div>
#>   <div class="vizmodules-input-cell">
#>     <div class="form-group shiny-input-container" id="tipify7363630">
#>       <label class="control-label" id="biplot-n.top.loadings-label" for="biplot-n.top.loadings">Top Loadings per Axis</label>
#>       <input id="biplot-n.top.loadings" type="number" class="shiny-input-number form-control" value="5" data-update-on="change" min="1" step="1"/>
#>     </div>
#>     <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify7363630', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Number of variables with the largest absolute loading on each axis to draw.'})}, 500)});</script>
#>   </div>
#>   <div class="vizmodules-input-cell">
#>     <div class="form-group shiny-input-container" id="tipify9409625">
#>       <label class="control-label" id="biplot-loadings.length.factor-label" for="biplot-loadings.length.factor">Arrow Length Factor</label>
#>       <input id="biplot-loadings.length.factor" type="number" class="shiny-input-number form-control" value="0.5" data-update-on="change" min="0.1" step="0.1"/>
#>     </div>
#>     <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify9409625', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Multiplier on the arrow lengths after scaling the loadings to the scores.'})}, 500)});</script>
#>   </div>
#>   <div class="vizmodules-input-cell">
#>     <div class="form-group shiny-input-container" data-shiny-input-type="colour" id="tipify8610232">
#>       <label class="control-label" for="biplot-loadings.color">Arrow Color</label>
#>       <input id="biplot-loadings.color" type="text" class="form-control shiny-colour-input" data-init-value="#000000" data-show-colour="both" data-palette="square"/>
#>     </div>
#>     <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify8610232', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Colour of the loading arrows and their labels.'})}, 500)});</script>
#>   </div>
#>   <div class="vizmodules-input-cell">
#>     <div class="form-group shiny-input-container" id="tipify3641701">
#>       <label class="control-label" id="biplot-loadings.label.size-label" for="biplot-loadings.label.size">Arrow Label Size</label>
#>       <input id="biplot-loadings.label.size" type="number" class="shiny-input-number form-control" value="12" data-update-on="change" min="4" step="1"/>
#>     </div>
#>     <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify3641701', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Font size of the loading arrow labels.'})}, 500)});</script>
#>   </div>
#> </div>
#> <h3>PCA Biplot Settings</h3>
#> <div class="tabbable vizmodules-input-tabs">
#>   <ul class="nav nav-tabs shiny-tab-input" id="biplot-scatterPlotTabsetPanel" data-tabsetid="5857">
#>     <li class="active">
#>       <a href="#tab-5857-1" data-toggle="tab" data-bs-toggle="tab" data-value="Data">Data</a>
#>     </li>
#>     <li>
#>       <a href="#tab-5857-2" data-toggle="tab" data-bs-toggle="tab" data-value="Adjustments">Adjustments</a>
#>     </li>
#>     <li>
#>       <a href="#tab-5857-3" data-toggle="tab" data-bs-toggle="tab" data-value="Points">Points</a>
#>     </li>
#>     <li>
#>       <a href="#tab-5857-4" data-toggle="tab" data-bs-toggle="tab" data-value="Colors">Colors</a>
#>     </li>
#>     <li>
#>       <a href="#tab-5857-5" data-toggle="tab" data-bs-toggle="tab" data-value="Facet">Facet</a>
#>     </li>
#>     <li>
#>       <a href="#tab-5857-6" data-toggle="tab" data-bs-toggle="tab" data-value="Annotations">Annotations</a>
#>     </li>
#>     <li>
#>       <a href="#tab-5857-7" data-toggle="tab" data-bs-toggle="tab" data-value="Legend">Legend</a>
#>     </li>
#>     <li>
#>       <a href="#tab-5857-8" data-toggle="tab" data-bs-toggle="tab" data-value="Trajectory">Trajectory</a>
#>     </li>
#>     <li>
#>       <a href="#tab-5857-9" data-toggle="tab" data-bs-toggle="tab" data-value="Marginals">Marginals</a>
#>     </li>
#>     <li>
#>       <a href="#tab-5857-10" data-toggle="tab" data-bs-toggle="tab" data-value="Plotly">Plotly</a>
#>     </li>
#>     <li>
#>       <a href="#tab-5857-11" data-toggle="tab" data-bs-toggle="tab" data-value="Extras">Extras</a>
#>     </li>
#>     <li>
#>       <a href="#tab-5857-12" data-toggle="tab" data-bs-toggle="tab" data-value="Lines">Lines</a>
#>     </li>
#>     <li>
#>       <a href="#tab-5857-13" data-toggle="tab" data-bs-toggle="tab" data-value="Axes">Axes</a>
#>     </li>
#>   </ul>
#>   <div class="tab-content" data-tabsetid="5857">
#>     <div class="tab-pane active" data-value="Data" id="tab-5857-1">
#>       <div class="vizmodules-input-grid" style="--viz-input-columns: 2;">
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" style="width:100%;" id="tipify9125234">
#>             <label class="control-label" id="biplot-x.by-label" for="biplot-x.by">X Data</label>
#>             <div id="biplot-x.by" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="change">
#>               <script type="application/json" data-for="biplot-x.by">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["sample","PC1","PC2","PC3","PC4","PC5","PC6","PC7","PC8","dex","cell","avgLength","lib.size","size.factor"],"value":["sample","PC1","PC2","PC3","PC4","PC5","PC6","PC7","PC8","dex","cell","avgLength","lib.size","size.factor"]}},"config":{"multiple":false,"search":true,"selectedValue":"PC1","hideClearButton":true,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":false,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":true,"disableOptionGroupCheckbox":true,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify9125234', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Single strings denoting the name of a column of `data_frame` containing numeric data to use for the x- and y-axis of the scatterplot.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" style="width:100%;" id="tipify7529222">
#>             <label class="control-label" id="biplot-y.by-label" for="biplot-y.by">Y Data</label>
#>             <div id="biplot-y.by" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="change">
#>               <script type="application/json" data-for="biplot-y.by">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["sample","PC1","PC2","PC3","PC4","PC5","PC6","PC7","PC8","dex","cell","avgLength","lib.size","size.factor"],"value":["sample","PC1","PC2","PC3","PC4","PC5","PC6","PC7","PC8","dex","cell","avgLength","lib.size","size.factor"]}},"config":{"multiple":false,"search":true,"selectedValue":"PC2","hideClearButton":true,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":false,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":true,"disableOptionGroupCheckbox":true,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify7529222', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Single strings denoting the name of a column of `data_frame` containing numeric data to use for the x- and y-axis of the scatterplot.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" style="width:100%;" id="tipify6414824">
#>             <label class="control-label" id="biplot-color.by-label" for="biplot-color.by">Color By</label>
#>             <div id="biplot-color.by" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="change">
#>               <script type="application/json" data-for="biplot-color.by">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["(none)","sample","PC1","PC2","PC3","PC4","PC5","PC6","PC7","PC8","dex","cell","avgLength","lib.size","size.factor"],"value":["","sample","PC1","PC2","PC3","PC4","PC5","PC6","PC7","PC8","dex","cell","avgLength","lib.size","size.factor"]}},"config":{"multiple":false,"search":true,"selectedValue":"dex","hideClearButton":true,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":false,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":true,"disableOptionGroupCheckbox":true,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify6414824', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Single string denoting the name of a column of `data_frame` to use for setting the color of plotted points. Alternatively, a string vector naming multiple such columns of data to plot at once.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" style="width:100%;" id="tipify7954503">
#>             <label class="control-label" id="biplot-size.by-label" for="biplot-size.by">Size By</label>
#>             <div id="biplot-size.by" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="change">
#>               <script type="application/json" data-for="biplot-size.by">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["(none)","PC1","PC2","PC3","PC4","PC5","PC6","PC7","PC8","avgLength","lib.size","size.factor"],"value":["","PC1","PC2","PC3","PC4","PC5","PC6","PC7","PC8","avgLength","lib.size","size.factor"]}},"config":{"multiple":false,"search":true,"selectedValue":"","hideClearButton":true,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":false,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":true,"disableOptionGroupCheckbox":true,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify7954503', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Number which sets the size of data points. Default = 1. Alternatively, a single string denoting the name of a column of `data_frame` to use for setting the size of plotted points.  NOTE: When providing a column name and using `do.hover = TRUE`, the legend will not include meaningful size encoding information.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" style="width:100%;" id="tipify9849717">
#>             <label class="control-label" id="biplot-shape.by-label" for="biplot-shape.by">Shape By</label>
#>             <div id="biplot-shape.by" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="change">
#>               <script type="application/json" data-for="biplot-shape.by">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["(none)","sample","dex","cell"],"value":["","sample","dex","cell"]}},"config":{"multiple":false,"search":false,"selectedValue":"","hideClearButton":true,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":false,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":true,"disableOptionGroupCheckbox":true,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify9849717', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Single string denoting the name of a column of `data_frame` containing discrete data to use for setting the shape of plotted points.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" style="width:100%;" id="tipify6223692">
#>             <label class="control-label" id="biplot-split.by-label" for="biplot-split.by">Split By</label>
#>             <div id="biplot-split.by" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="close">
#>               <script type="application/json" data-for="biplot-split.by">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["(none)","sample","dex","cell"],"value":["","sample","dex","cell"]}},"config":{"multiple":true,"search":false,"selectedValue":"","hideClearButton":false,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":true,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":false,"disableOptionGroupCheckbox":false,"disabled":false,"dropboxWrapper":"body","zIndex":1060,"maxValues":2}}</script>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify6223692', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': '1 or 2 strings denoting the name(s) of column(s) of `data_frame` containing discrete data to use for faceting / separating data points into separate plots.  When 2 columns are named, c(row,col), the first is used as rows and the second is used for columns of the resulting facet grid.  When 1 column is named, shape control can be achieved with `split.nrow` and `split.ncol`'})}, 500)});</script>
#>         </div>
#>       </div>
#>     </div>
#>     <div class="tab-pane" data-value="Adjustments" id="tab-5857-2">
#>       <div class="vizmodules-input-grid" style="--viz-input-columns: 2;">
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" style="width:100%;" id="tipify5553265">
#>             <label class="control-label" id="biplot-x.adjustment-label" for="biplot-x.adjustment">X Adjustment</label>
#>             <div id="biplot-x.adjustment" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="change">
#>               <script type="application/json" data-for="biplot-x.adjustment">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["(none)","z-score","relative.to.max"],"value":["","z-score","relative.to.max"]}},"config":{"multiple":false,"search":false,"selectedValue":"","hideClearButton":true,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":false,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":true,"disableOptionGroupCheckbox":true,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify5553265', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'A recognized string indicating whether numeric `x.by`, `y.by`, and `color.by` data should be used directly (default) or should be adjusted to be itemize{ item{"z-score": scaled with the scale() function to produce a relative-to-mean z-score representation} item{"relative.to.max": divided by the maximum value to give percent of max values between [0,1]} }  Ignored if the target data is not numeric as these known adjustments target numeric data only.  In order to leave the unedited data available for use in other features, the adjusted data are put in a new column and that new column is used for plotting. The Adjustment Function is applied first, and the X Adjustment then rescales the result (e.g. log10, then z-score).'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" style="width:100%;" id="tipify9610665">
#>             <label class="control-label" id="biplot-y.adjustment-label" for="biplot-y.adjustment">Y Adjustment</label>
#>             <div id="biplot-y.adjustment" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="change">
#>               <script type="application/json" data-for="biplot-y.adjustment">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["(none)","z-score","relative.to.max"],"value":["","z-score","relative.to.max"]}},"config":{"multiple":false,"search":false,"selectedValue":"","hideClearButton":true,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":false,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":true,"disableOptionGroupCheckbox":true,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify9610665', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'A recognized string indicating whether numeric `x.by`, `y.by`, and `color.by` data should be used directly (default) or should be adjusted to be itemize{ item{"z-score": scaled with the scale() function to produce a relative-to-mean z-score representation} item{"relative.to.max": divided by the maximum value to give percent of max values between [0,1]} }  Ignored if the target data is not numeric as these known adjustments target numeric data only.  In order to leave the unedited data available for use in other features, the adjusted data are put in a new column and that new column is used for plotting. The Adjustment Function is applied first, and the Y Adjustment then rescales the result (e.g. log10, then z-score).'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" style="width:100%;" id="tipify9156397">
#>             <label class="control-label" id="biplot-color.adjustment-label" for="biplot-color.adjustment">Color Adjustment</label>
#>             <div id="biplot-color.adjustment" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="change">
#>               <script type="application/json" data-for="biplot-color.adjustment">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["(none)","z-score","relative.to.max"],"value":["","z-score","relative.to.max"]}},"config":{"multiple":false,"search":false,"selectedValue":"","hideClearButton":true,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":false,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":true,"disableOptionGroupCheckbox":true,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify9156397', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'A recognized string indicating whether numeric `x.by`, `y.by`, and `color.by` data should be used directly (default) or should be adjusted to be itemize{ item{"z-score": scaled with the scale() function to produce a relative-to-mean z-score representation} item{"relative.to.max": divided by the maximum value to give percent of max values between [0,1]} }  Ignored if the target data is not numeric as these known adjustments target numeric data only.  In order to leave the unedited data available for use in other features, the adjusted data are put in a new column and that new column is used for plotting. The Adjustment Function is applied first, and the Color Adjustment then rescales the result (e.g. log10, then z-score).'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" style="width:100%;" id="tipify6032756">
#>             <label class="control-label" id="biplot-x.adj.fxn-label" for="biplot-x.adj.fxn">X Adjustment Function</label>
#>             <div id="biplot-x.adj.fxn" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="change">
#>               <script type="application/json" data-for="biplot-x.adj.fxn">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["(none)","log2","log","log10","neg_log10","log1p","as.factor","abs","sqrt"],"value":["","log2","log","log10","neg_log10","log1p","as.factor","abs","sqrt"]}},"config":{"multiple":false,"search":false,"selectedValue":"","hideClearButton":true,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":false,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":true,"disableOptionGroupCheckbox":true,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify6032756', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'If you wish to apply a function to edit the `x.by`, `y.by`, or `color.by` data before use, in a way not possible with the `color.adjustment` input, this input can be given a function which takes in a vector of values as input and returns a vector of values of the same length as output.  For example, `function(x) {log2(x)`} or `as.factor`.  In order to leave the unedited data available for use in other features, the adjusted data are put in a new column and that new column is used for plotting. The Adjustment Function is applied first, and the X Adjustment then rescales the result (e.g. log10, then z-score).'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" style="width:100%;" id="tipify3115541">
#>             <label class="control-label" id="biplot-y.adj.fxn-label" for="biplot-y.adj.fxn">Y Adjustment Function</label>
#>             <div id="biplot-y.adj.fxn" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="change">
#>               <script type="application/json" data-for="biplot-y.adj.fxn">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["(none)","log2","log","log10","neg_log10","log1p","as.factor","abs","sqrt"],"value":["","log2","log","log10","neg_log10","log1p","as.factor","abs","sqrt"]}},"config":{"multiple":false,"search":false,"selectedValue":"","hideClearButton":true,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":false,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":true,"disableOptionGroupCheckbox":true,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify3115541', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'If you wish to apply a function to edit the `x.by`, `y.by`, or `color.by` data before use, in a way not possible with the `color.adjustment` input, this input can be given a function which takes in a vector of values as input and returns a vector of values of the same length as output.  For example, `function(x) {log2(x)`} or `as.factor`.  In order to leave the unedited data available for use in other features, the adjusted data are put in a new column and that new column is used for plotting. The Adjustment Function is applied first, and the Y Adjustment then rescales the result (e.g. log10, then z-score).'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" style="width:100%;" id="tipify5551521">
#>             <label class="control-label" id="biplot-color.adj.fxn-label" for="biplot-color.adj.fxn">Color Adjustment Function</label>
#>             <div id="biplot-color.adj.fxn" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="change">
#>               <script type="application/json" data-for="biplot-color.adj.fxn">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["(none)","log2","log","log10","neg_log10","log1p","as.factor","abs","sqrt"],"value":["","log2","log","log10","neg_log10","log1p","as.factor","abs","sqrt"]}},"config":{"multiple":false,"search":false,"selectedValue":"","hideClearButton":true,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":false,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":true,"disableOptionGroupCheckbox":true,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify5551521', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'If you wish to apply a function to edit the `x.by`, `y.by`, or `color.by` data before use, in a way not possible with the `color.adjustment` input, this input can be given a function which takes in a vector of values as input and returns a vector of values of the same length as output.  For example, `function(x) {log2(x)`} or `as.factor`.  In order to leave the unedited data available for use in other features, the adjusted data are put in a new column and that new column is used for plotting. The Adjustment Function is applied first, and the Color Adjustment then rescales the result (e.g. log10, then z-score).'})}, 500)});</script>
#>         </div>
#>       </div>
#>     </div>
#>     <div class="tab-pane" data-value="Points" id="tab-5857-3">
#>       <div class="vizmodules-input-grid" style="--viz-input-columns: 2;">
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify9375977">
#>             <label class="control-label" id="biplot-size-label" for="biplot-size">Point Size</label>
#>             <input id="biplot-size" type="number" class="shiny-input-number form-control" value="1" data-update-on="change" min="0.1"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify9375977', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Number which sets the size of data points. Default = 1. Alternatively, a single string denoting the name of a column of `data_frame` to use for setting the size of plotted points.  NOTE: When providing a column name and using `do.hover = TRUE`, the legend will not include meaningful size encoding information.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify3650372">
#>             <label class="control-label" id="biplot-size.min-label" for="biplot-size.min">Min Point Size</label>
#>             <input id="biplot-size.min" type="number" class="shiny-input-number form-control" value="1" data-update-on="change" min="0" step="0.5"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify3650372', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Smallest point size, drawn for the Size Scale Min value of the &#39;Size By&#39; column.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify3386323">
#>             <label class="control-label" id="biplot-size.max-label" for="biplot-size.max">Max Point Size</label>
#>             <input id="biplot-size.max" type="number" class="shiny-input-number form-control" value="6" data-update-on="change" min="0" step="0.5"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify3386323', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Largest point size, drawn for the Size Scale Max value of the &#39;Size By&#39; column.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify7696835">
#>             <label class="control-label" id="biplot-size.scale.min-label" for="biplot-size.scale.min">Size Scale Min</label>
#>             <input id="biplot-size.scale.min" type="number" class="shiny-input-number form-control" value="NA" data-update-on="change"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify7696835', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': '&#39;Size By&#39; value drawn at the Min Point Size, and where the size legend starts. Leave blank to use the column&#39;s minimum. Smaller values are drawn at the Min Point Size.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify3013423">
#>             <label class="control-label" id="biplot-size.scale.max-label" for="biplot-size.scale.max">Size Scale Max</label>
#>             <input id="biplot-size.scale.max" type="number" class="shiny-input-number form-control" value="NA" data-update-on="change"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify3013423', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': '&#39;Size By&#39; value drawn at the Max Point Size, and where the size legend ends. Leave blank to use the column&#39;s maximum. Larger values are drawn at the Max Point Size.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify6296409">
#>             <label class="control-label" id="biplot-opacity-label" for="biplot-opacity">Point Opacity</label>
#>             <input id="biplot-opacity" type="number" class="shiny-input-number form-control" value="1" data-update-on="change" min="0" max="1" step="0.05"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify6296409', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Number between 0 and 1. 1 = opaque. 0 = invisible. Default = 1. (In terms of typical ggplot variables, = alpha) Alternatively, a single string denoting the name of a column of `data_frame` to use for setting the opacity of plotted points.  NOTE: When providing a column name and using `do.hover = TRUE`, the legend will not include meaningful opacity encoding information.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify8024997">
#>             <div class="checkbox">
#>               <label>
#>                 <input id="biplot-show.others" type="checkbox" class="shiny-input-checkbox" checked="checked"/>
#>                 <span>Show Others</span>
#>               </label>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify8024997', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Logical. TRUE by default, whether rows not targeted by `rows.use` should be shown in the background in light gray.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify5422356">
#>             <div class="checkbox">
#>               <label>
#>                 <input id="biplot-split.show.all.others" type="checkbox" class="shiny-input-checkbox" checked="checked"/>
#>                 <span>Show Split Others</span>
#>               </label>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify5422356', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Logical which sets whether gray "others" points of facets should include all points of other facets (`TRUE`) versus just points left out by `rows.use` which would exist in the current facet (`FALSE`).'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" style="width:100%;" id="tipify6309976">
#>             <label class="control-label" id="biplot-plot.order-label" for="biplot-plot.order">Plot Order</label>
#>             <div id="biplot-plot.order" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="change">
#>               <script type="application/json" data-for="biplot-plot.order">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["unordered","increasing","decreasing","randomize"],"value":["unordered","increasing","decreasing","randomize"]}},"config":{"multiple":false,"search":false,"selectedValue":"unordered","hideClearButton":true,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":false,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":true,"disableOptionGroupCheckbox":true,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify6309976', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'String. If the data should be plotted based on the order of the color data, sets whether to plot in "increasing", "decreasing", or "randomize"d order.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify1897889">
#>             <label class="control-label" id="biplot-shape.panel-label" for="biplot-shape.panel">Shape Panel</label>
#>             <input id="biplot-shape.panel" type="text" class="shiny-input-text form-control" value="16, 15, 17, 23, 25, 8" data-update-on="change"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify1897889', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Vector of integers, corresponding to ggplot shapes, which sets what shapes to use in conjunction with `shape.by`. When nothing is supplied to `shape.by`, only the first value is used. Default is a set of 6, `c(16,15,17,23,25,8)`, the first being a simple, solid, circle.'})}, 500)});</script>
#>         </div>
#>       </div>
#>     </div>
#>     <div class="tab-pane" data-value="Colors" id="tab-5857-4">
#>       <div class="vizmodules-input-grid" style="--viz-input-columns: 2;">
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour" id="tipify2034527">
#>             <label class="control-label" for="biplot-min.color">Min Color</label>
#>             <input id="biplot-min.color" type="text" class="form-control shiny-colour-input" data-init-value="#F0E442" data-show-colour="both" data-palette="square"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify2034527', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Color for `min` value of numeric `color.by`-data. Default = yellow'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour" id="tipify9283512">
#>             <label class="control-label" for="biplot-max.color">Max Color</label>
#>             <input id="biplot-max.color" type="text" class="form-control shiny-colour-input" data-init-value="#0072B2" data-show-colour="both" data-palette="square"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify9283512', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Color for `max` value of numeric `color.by`-data. Default = blue'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour" id="tipify4134435">
#>             <label class="control-label" for="biplot-contour.color">Contour Color</label>
#>             <input id="biplot-contour.color" type="text" class="form-control shiny-colour-input" data-init-value="black" data-show-colour="both" data-palette="square"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify4134435', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'String that sets the color of the `do.contour` contours.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" style="width:100%;" id="tipify1309699">
#>             <label class="control-label" id="biplot-contour.linetype-label" for="biplot-contour.linetype">Contour Linetype</label>
#>             <div id="biplot-contour.linetype" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="change">
#>               <script type="application/json" data-for="biplot-contour.linetype">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["solid","dashed","dotted","dotdash","longdash","twodash"],"value":["solid","dashed","dotted","dotdash","longdash","twodash"]}},"config":{"multiple":false,"search":false,"selectedValue":"solid","hideClearButton":true,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":false,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":true,"disableOptionGroupCheckbox":true,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify1309699', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'String or numeric which sets the type of line used for `do.contour` contours. Defaults to "solid", but see `link[ggplot2]{linetype`} for other options.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div id="biplot-color.panel.ui" class="shiny-html-output"></div>
#>         </div>
#>       </div>
#>     </div>
#>     <div class="tab-pane" data-value="Facet" id="tab-5857-5">
#>       <div class="vizmodules-input-grid" style="--viz-input-columns: 2;">
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify611630">
#>             <label class="control-label" id="biplot-split.nrow-label" for="biplot-split.nrow">Rows</label>
#>             <input id="biplot-split.nrow" type="number" class="shiny-input-number form-control" value="NA" data-update-on="change" min="0" step="1"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify611630', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Integers which set the dimensions of faceting/splitting when faceting by a single feature.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify8860738">
#>             <label class="control-label" id="biplot-split.ncol-label" for="biplot-split.ncol">Columns</label>
#>             <input id="biplot-split.ncol" type="number" class="shiny-input-number form-control" value="NA" data-update-on="change" min="0" step="1"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify8860738', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Integers which set the dimensions of faceting/splitting when faceting by a single feature.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" style="width:100%;" id="tipify5922085">
#>             <label class="control-label" id="biplot-multivar.split.dir-label" for="biplot-multivar.split.dir">Multivar Split Dir</label>
#>             <div id="biplot-multivar.split.dir" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="change">
#>               <script type="application/json" data-for="biplot-multivar.split.dir">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["col","row"],"value":["col","row"]}},"config":{"multiple":false,"search":false,"selectedValue":"col","hideClearButton":true,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":false,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":true,"disableOptionGroupCheckbox":true,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify5922085', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': '"row" or "col", sets the direction of faceting used for &#39;var&#39; values when: itemize{ item `var` is given multiple column names item AND `split.by` is used to provide an additional feature to facet by }'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" style="width:100%;" id="tipify7224122">
#>             <label class="control-label" id="biplot-split.adjust.scales-label" for="biplot-split.adjust.scales">Facet Scales</label>
#>             <div id="biplot-split.adjust.scales" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="change">
#>               <script type="application/json" data-for="biplot-split.adjust.scales">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["fixed","free","free_x","free_y"],"value":["fixed","free","free_x","free_y"]}},"config":{"multiple":false,"search":false,"selectedValue":"fixed","hideClearButton":true,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":false,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":true,"disableOptionGroupCheckbox":true,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify7224122', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Control whether facet panels share the same axis scales or allow them to vary independently'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify5123930">
#>             <label class="control-label" id="biplot-subplot.margin.x-label" for="biplot-subplot.margin.x">Subplot Spacing (Horizontal)</label>
#>             <input id="biplot-subplot.margin.x" type="number" class="shiny-input-number form-control" value="0.03" data-update-on="change" min="0" max="1" step="0.01"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify5123930', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Horizontal spacing between facet panel columns as a fraction of the plot area (e.g. 0.03). Only applies when faceting is active.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify2960687">
#>             <label class="control-label" id="biplot-subplot.margin.y-label" for="biplot-subplot.margin.y">Subplot Spacing (Vertical)</label>
#>             <input id="biplot-subplot.margin.y" type="number" class="shiny-input-number form-control" value="0.1" data-update-on="change" min="0" max="1" step="0.01"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify2960687', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Vertical spacing between facet panel rows as a fraction of the plot area (e.g. 0.1). Only applies when faceting is active.'})}, 500)});</script>
#>         </div>
#>       </div>
#>     </div>
#>     <div class="tab-pane" data-value="Annotations" id="tab-5857-6">
#>       <div class="vizmodules-input-grid" style="--viz-input-columns: 2;">
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" style="width:100%;" id="tipify6397781">
#>             <label class="control-label" id="biplot-annotate.by-label" for="biplot-annotate.by">Annotate By</label>
#>             <div id="biplot-annotate.by" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="change">
#>               <script type="application/json" data-for="biplot-annotate.by">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["(none)","sample","PC1","PC2","PC3","PC4","PC5","PC6","PC7","PC8","dex","cell","avgLength","lib.size","size.factor"],"value":["","sample","PC1","PC2","PC3","PC4","PC5","PC6","PC7","PC8","dex","cell","avgLength","lib.size","size.factor"]}},"config":{"multiple":false,"search":true,"selectedValue":"","hideClearButton":true,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":false,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":true,"disableOptionGroupCheckbox":true,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify6397781', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Select a column whose values will be used to identify points for highlighting and annotation'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="shiny-input-textarea form-group shiny-input-container" id="tipify8825434">
#>             <label class="control-label" id="biplot-highlight.points-label" for="biplot-highlight.points">Points to Highlight</label>
#>             <textarea id="biplot-highlight.points" class="form-control" placeholder="Values from &#39;Annotate by&#39; column&#10;(comma, space, or newline delimited)" rows="3" data-update-on="change"></textarea>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify8825434', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Enter specific values from the &#39;Annotate By&#39; column to highlight those points on the plot. Separate values that contain spaces with commas or new lines.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour" id="tipify9461507">
#>             <label class="control-label" for="biplot-highlight.color">Highlight Fill</label>
#>             <input id="biplot-highlight.color" type="text" class="form-control shiny-colour-input" data-init-value="#00FFF7" data-show-colour="both" data-palette="square" data-allow-alpha="true"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify9461507', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Choose the fill color for highlighted points'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify7094167">
#>             <label class="control-label" id="biplot-highlight.size-label" for="biplot-highlight.size">Highlight Size</label>
#>             <input id="biplot-highlight.size" type="number" class="shiny-input-number form-control" value="7" data-update-on="change" min="0.1" step="0.5"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify7094167', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Set the size of highlighted points on the plot'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour" id="tipify9236205">
#>             <label class="control-label" for="biplot-highlight.border.color">Highlight Border Color</label>
#>             <input id="biplot-highlight.border.color" type="text" class="form-control shiny-colour-input" data-init-value="#000000" data-show-colour="both" data-palette="square"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify9236205', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Choose the border color for highlighted points'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify162216">
#>             <label class="control-label" id="biplot-highlight.border.width-label" for="biplot-highlight.border.width">Highlight Border Width</label>
#>             <input id="biplot-highlight.border.width" type="number" class="shiny-input-number form-control" value="1" data-update-on="change" min="0" step="0.25"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify162216', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Set the width of the border around highlighted points'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify1714783">
#>             <div class="checkbox">
#>               <label>
#>                 <input id="biplot-highlight.auto.annotate" type="checkbox" class="shiny-input-checkbox" checked="checked"/>
#>                 <span>Auto-annotate Highlights</span>
#>               </label>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify1714783', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'When enabled, automatically adds text labels to highlighted points using their &#39;Annotate By&#39; values'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour" id="tipify2139898">
#>             <label class="control-label" for="biplot-annotation.color">Annotation Color</label>
#>             <input id="biplot-annotation.color" type="text" class="form-control shiny-colour-input" data-init-value="black" data-show-colour="both" data-palette="square"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify2139898', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Set the text color for annotation labels'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify8451152">
#>             <label class="control-label" id="biplot-annotation.ax-label" for="biplot-annotation.ax">Annotation X Offset</label>
#>             <input id="biplot-annotation.ax" type="number" class="shiny-input-number form-control" value="20" data-update-on="change" step="1"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify8451152', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Horizontal pixel offset of annotation labels from their target points'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify2433217">
#>             <label class="control-label" id="biplot-annotation.ay-label" for="biplot-annotation.ay">Annotation Y Offset</label>
#>             <input id="biplot-annotation.ay" type="number" class="shiny-input-number form-control" value="-20" data-update-on="change" step="1"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify2433217', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Vertical pixel offset of annotation labels from their target points (negative values move up)'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify5150504">
#>             <label class="control-label" id="biplot-annotation.size-label" for="biplot-annotation.size">Annotation Size</label>
#>             <input id="biplot-annotation.size" type="number" class="shiny-input-number form-control" value="10" data-update-on="change" min="1" step="0.5"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify5150504', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Set the font size of annotation text labels in points'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify8631875">
#>             <div class="checkbox">
#>               <label>
#>                 <input id="biplot-annotation.showarrow" type="checkbox" class="shiny-input-checkbox" checked="checked"/>
#>                 <span>Show Arrow</span>
#>               </label>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify8631875', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Toggle whether an arrow is drawn from the annotation label to the target point'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour" id="tipify405587">
#>             <label class="control-label" for="biplot-annotation.arrowcolor">Arrow Color</label>
#>             <input id="biplot-annotation.arrowcolor" type="text" class="form-control shiny-colour-input" data-init-value="black" data-show-colour="both" data-palette="square"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify405587', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Set the color of the annotation arrow connecting the label to the point'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify4600282">
#>             <label class="control-label" id="biplot-annotation.arrowhead-label" for="biplot-annotation.arrowhead">Arrowhead Style</label>
#>             <input id="biplot-annotation.arrowhead" type="number" class="shiny-input-number form-control" value="2" data-update-on="change" min="0" max="7" step="1"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify4600282', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Choose the arrowhead style (0-7) for annotation arrows, where 0 is no arrowhead'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify1660049">
#>             <label class="control-label" id="biplot-annotation.arrowwidth-label" for="biplot-annotation.arrowwidth">Arrow Linewidth</label>
#>             <input id="biplot-annotation.arrowwidth" type="number" class="shiny-input-number form-control" value="1.5" data-update-on="change" min="0.1" step="0.25"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify1660049', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Set the line width of the annotation arrow'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <button id="biplot-annotation.clear" type="button" class="btn btn-default action-button"><span class="action-label">Clear Annotations</span></button>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('biplot-annotation.clear', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Remove all annotation labels and arrows from the current plot'})}, 500)});</script>
#>         </div>
#>       </div>
#>     </div>
#>     <div class="tab-pane" data-value="Legend" id="tab-5857-7">
#>       <div class="vizmodules-input-grid" style="--viz-input-columns: 2;">
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify9153843">
#>             <label class="control-label" id="biplot-legend.color.title-label" for="biplot-legend.color.title">Legend Title</label>
#>             <input id="biplot-legend.color.title" type="text" class="shiny-input-text form-control" value="make" data-update-on="change"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify9153843', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Strings which set the title for the color or shape legends.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify4094238">
#>             <div class="material-switch">
#>               <label for="biplot-legend.show" style="padding-right: 10px;">Show Legend</label>
#>               <input id="biplot-legend.show" type="checkbox" checked="checked"/>
#>               <label class="switch label-success bg-success" for="biplot-legend.show"></label>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify4094238', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Show the legend. Turning it off also hides colorbars and any point size legend.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" style="width:100%;" id="tipify6405322">
#>             <label class="control-label" id="biplot-legend.font.family-label" for="biplot-legend.font.family">Legend Font</label>
#>             <div id="biplot-legend.font.family" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="change">
#>               <script type="application/json" data-for="biplot-legend.font.family">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["Arial","Balto","Courier New","Droid Sans","Droid Serif","Droid Sans Mono","Gravitas One","Old Standard TT","Open Sans","Overpass","PT Sans Narrow","Raleway","Times New Roman","Verdana","sans-serif","serif","monospace"],"value":["Arial","Balto","Courier New","Droid Sans","Droid Serif","Droid Sans Mono","Gravitas One","Old Standard TT","Open Sans","Overpass","PT Sans Narrow","Raleway","Times New Roman","Verdana","sans-serif","serif","monospace"]}},"config":{"multiple":false,"search":true,"selectedValue":"Arial","hideClearButton":true,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":false,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":true,"disableOptionGroupCheckbox":true,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify6405322', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Font family of the legend title and entry labels.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour" id="tipify1648184">
#>             <label class="control-label" for="biplot-legend.font.color">Legend Font Color</label>
#>             <input id="biplot-legend.font.color" type="text" class="form-control shiny-colour-input" data-init-value="#000000" data-show-colour="both" data-palette="square"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify1648184', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Font color of the legend title and entry labels.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify1809802">
#>             <label class="control-label" id="biplot-legend.title.size-label" for="biplot-legend.title.size">Legend Title Size</label>
#>             <input id="biplot-legend.title.size" type="number" class="shiny-input-number form-control" value="14" data-update-on="change" min="0" step="1"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify1809802', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Font size of the legend title.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify9964527">
#>             <label class="control-label" id="biplot-legend.text.size-label" for="biplot-legend.text.size">Legend Text Size</label>
#>             <input id="biplot-legend.text.size" type="number" class="shiny-input-number form-control" value="12" data-update-on="change" min="0" step="1"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify9964527', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Font size of the legend entry labels.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify6451109">
#>             <label class="control-label" id="biplot-legend.color.breaks-label" for="biplot-legend.color.breaks">Color Tick Breaks</label>
#>             <input id="biplot-legend.color.breaks" type="text" class="shiny-input-text form-control" value="" placeholder="e.g. -3, 0, 3" data-update-on="change"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify6451109', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Numeric vector which sets the discrete values to label in the color-scale legend for `color.by`-data.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify9180984">
#>             <label class="control-label" id="biplot-size.legend.x-label" for="biplot-size.legend.x">Size Legend X Position</label>
#>             <input id="biplot-size.legend.x" type="number" class="shiny-input-number form-control" value="1.03" data-update-on="change" step="0.02"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify9180984', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Horizontal position (paper coordinates) of the custom size legend drawn when &#39;Size By&#39; is set. Values just above 1 sit to the right of the plot; lower it to pull the legend inward on narrow plots or raise it to push it further out.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify7950654">
#>             <label class="control-label" id="biplot-size.legend.y-label" for="biplot-size.legend.y">Size Legend Y Position</label>
#>             <input id="biplot-size.legend.y" type="number" class="shiny-input-number form-control" value="0.35" data-update-on="change" step="0.05"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify7950654', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Vertical position (paper coordinates) of the custom size legend drawn when &#39;Size By&#39; is set. Lower it to offset the size legend from an overlapping color or shape legend.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify9130970">
#>             <label class="control-label" id="biplot-min.value-label" for="biplot-min.value">Color Min</label>
#>             <input id="biplot-min.value" type="number" class="shiny-input-number form-control" value="NA" data-update-on="change"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify9130970', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Number which sets the `color.by`-data value associated with the minimum or maximum colors.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify3905596">
#>             <label class="control-label" id="biplot-max.value-label" for="biplot-max.value">Color Max</label>
#>             <input id="biplot-max.value" type="number" class="shiny-input-number form-control" value="NA" data-update-on="change"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify3905596', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Number which sets the `color.by`-data value associated with the minimum or maximum colors.'})}, 500)});</script>
#>         </div>
#>       </div>
#>     </div>
#>     <div class="tab-pane" data-value="Trajectory" id="tab-5857-8">
#>       <div class="vizmodules-input-grid" style="--viz-input-columns: 2;">
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" style="width:100%;" id="tipify3574005">
#>             <label class="control-label" id="biplot-trajectory.group.by-label" for="biplot-trajectory.group.by">Trajectory Group By</label>
#>             <div id="biplot-trajectory.group.by" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="change">
#>               <script type="application/json" data-for="biplot-trajectory.group.by">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["(none)","sample","dex","cell"],"value":["","sample","dex","cell"]}},"config":{"multiple":false,"search":false,"selectedValue":"","hideClearButton":true,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":false,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":true,"disableOptionGroupCheckbox":true,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify3574005', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'String denoting the name of a column of `data_frame` to use for generating trajectories from data point groups.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify6143616">
#>             <label class="control-label" id="biplot-trajectory.arrow.size-label" for="biplot-trajectory.arrow.size">Trajectory Arrow Size</label>
#>             <input id="biplot-trajectory.arrow.size" type="number" class="shiny-input-number form-control" value="0.1" data-update-on="change" min="0" step="0.05"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify6143616', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Number representing the size of trajectory arrows, in inches.  Default = 0.15.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div id="biplot-add.trajectory.by.groups.ui" class="shiny-html-output"></div>
#>         </div>
#>       </div>
#>     </div>
#>     <div class="tab-pane" data-value="Marginals" id="tab-5857-9">
#>       <div class="vizmodules-input-grid" style="--viz-input-columns: 2;">
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" style="width:100%;" id="tipify1924408">
#>             <label class="control-label" id="biplot-marginal.x-label" for="biplot-marginal.x">Top Marginal (X)</label>
#>             <div id="biplot-marginal.x" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="close">
#>               <script type="application/json" data-for="biplot-marginal.x">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["Density","Histogram","Rug"],"value":["density","histogram","rug"]}},"config":{"multiple":true,"search":false,"selectedValue":[],"hideClearButton":false,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":true,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":false,"disableOptionGroupCheckbox":false,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify1924408', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Distribution of the X values drawn above the plot, one per Color By group. Pick any of density, histogram and rug.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" style="width:100%;" id="tipify718385">
#>             <label class="control-label" id="biplot-marginal.y-label" for="biplot-marginal.y">Right Marginal (Y)</label>
#>             <div id="biplot-marginal.y" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="close">
#>               <script type="application/json" data-for="biplot-marginal.y">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["Density","Histogram","Rug"],"value":["density","histogram","rug"]}},"config":{"multiple":true,"search":false,"selectedValue":[],"hideClearButton":false,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":true,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":false,"disableOptionGroupCheckbox":false,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify718385', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Distribution of the Y values drawn to the right of the plot, one per Color By group. Pick any of density, histogram and rug.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify3062330">
#>             <label class="control-label" id="biplot-marginal.x.size-label" for="biplot-marginal.x.size">Top Marginal Height</label>
#>             <input id="biplot-marginal.x.size" type="number" class="shiny-input-number form-control" value="0.15" data-update-on="change" min="0.05" max="0.5" step="0.05"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify3062330', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Share of the plot&#39;s height given to the top marginal.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify1745764">
#>             <label class="control-label" id="biplot-marginal.y.size-label" for="biplot-marginal.y.size">Right Marginal Width</label>
#>             <input id="biplot-marginal.y.size" type="number" class="shiny-input-number form-control" value="0.15" data-update-on="change" min="0.05" max="0.5" step="0.05"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify1745764', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Share of the plot&#39;s width given to the right marginal.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify8877611">
#>             <label class="control-label" id="biplot-marginal.opacity-label" for="biplot-marginal.opacity">Marginal Opacity</label>
#>             <input id="biplot-marginal.opacity" type="number" class="shiny-input-number form-control" value="0.5" data-update-on="change" min="0" max="1" step="0.05"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify8877611', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Opacity of the density and histogram fills and of the rug lines.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify4978482">
#>             <label class="control-label" id="biplot-marginal.bins-label" for="biplot-marginal.bins">Histogram Bins</label>
#>             <input id="biplot-marginal.bins" type="number" class="shiny-input-number form-control" value="30" data-update-on="change" min="1" step="1"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify4978482', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Number of histogram bins, shared by every group so their bins line up.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify6939081">
#>             <label class="control-label" id="biplot-marginal.binwidth-label" for="biplot-marginal.binwidth">Histogram Bin Width</label>
#>             <input id="biplot-marginal.binwidth" type="number" class="shiny-input-number form-control" value="NA" data-update-on="change" min="0"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify6939081', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Width of each histogram bin, in the axis&#39; units. Overrides Histogram Bins when set. Leave blank to use Histogram Bins.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify8742160">
#>             <label class="control-label" id="biplot-marginal.density.adjust-label" for="biplot-marginal.density.adjust">Density Bandwidth Adjust</label>
#>             <input id="biplot-marginal.density.adjust" type="number" class="shiny-input-number form-control" value="1" data-update-on="change" min="0.1" step="0.1"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify8742160', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Multiplier on the density bandwidth. Larger values give smoother curves.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify180868">
#>             <label class="control-label" id="biplot-marginal.rug.height-label" for="biplot-marginal.rug.height">Rug Height</label>
#>             <input id="biplot-marginal.rug.height" type="number" class="shiny-input-number form-control" value="0.3" data-update-on="change" min="0.1" max="0.9" step="0.05"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify180868', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Share of a marginal given to its rug when the rug sits alongside a density or histogram. A rug on its own fills the marginal.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify3819871">
#>             <label class="control-label" id="biplot-marginal.rug.width-label" for="biplot-marginal.rug.width">Rug Line Width</label>
#>             <input id="biplot-marginal.rug.width" type="number" class="shiny-input-number form-control" value="1" data-update-on="change" min="0.1" step="0.5"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify3819871', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Line width of each rug tick, in pixels.'})}, 500)});</script>
#>         </div>
#>       </div>
#>     </div>
#>     <div class="tab-pane" data-value="Plotly" id="tab-5857-10">
#>       <div class="vizmodules-input-grid" style="--viz-input-columns: 2;">
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" style="width:100%;">
#>             <label class="control-label" id="biplot-download.format-label" for="biplot-download.format">Download Format</label>
#>             <div id="biplot-download.format" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="change">
#>               <script type="application/json" data-for="biplot-download.format">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["svg","png","jpeg","webp"],"value":["svg","png","jpeg","webp"]}},"config":{"multiple":false,"search":false,"selectedValue":"svg","hideClearButton":true,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":false,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":true,"disableOptionGroupCheckbox":true,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>             </div>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify5135930">
#>             <label class="control-label" id="biplot-margin.t-label" for="biplot-margin.t">Margin Top</label>
#>             <input id="biplot-margin.t" type="number" class="shiny-input-number form-control" value="70" data-update-on="change" min="0" step="5"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify5135930', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Top margin of the plot in pixels'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify472227">
#>             <label class="control-label" id="biplot-margin.b-label" for="biplot-margin.b">Margin Bottom</label>
#>             <input id="biplot-margin.b" type="number" class="shiny-input-number form-control" value="70" data-update-on="change" min="0" step="5"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify472227', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Bottom margin of the plot in pixels'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify8030951">
#>             <label class="control-label" id="biplot-margin.l-label" for="biplot-margin.l">Margin Left</label>
#>             <input id="biplot-margin.l" type="number" class="shiny-input-number form-control" value="70" data-update-on="change" min="0" step="5"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify8030951', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Left margin of the plot in pixels'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify6340869">
#>             <label class="control-label" id="biplot-margin.r-label" for="biplot-margin.r">Margin Right</label>
#>             <input id="biplot-margin.r" type="number" class="shiny-input-number form-control" value="90" data-update-on="change" min="0" step="5"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify6340869', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Right margin of the plot in pixels'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour" id="tipify7713282">
#>             <label class="control-label" for="biplot-shape.fill">Shape Fill</label>
#>             <input id="biplot-shape.fill" type="text" class="form-control shiny-colour-input" data-init-value="rgba(0, 0, 0, 0)" data-show-colour="both" data-palette="square" data-allow-alpha="true"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify7713282', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Interior fill color for shapes drawn on the plot using Plotly&#39;s drawing tools'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour" id="tipify5017637">
#>             <label class="control-label" for="biplot-shape.line.color">Shape Line Color</label>
#>             <input id="biplot-shape.line.color" type="text" class="form-control shiny-colour-input" data-init-value="black" data-show-colour="both" data-palette="square" data-allow-alpha="true"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify5017637', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Outline color for shapes drawn on the plot using Plotly&#39;s drawing tools'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify7112887">
#>             <label class="control-label" id="biplot-shape.line.width-label" for="biplot-shape.line.width">Shape Line Width</label>
#>             <input id="biplot-shape.line.width" type="number" class="shiny-input-number form-control" value="4" data-update-on="change" min="0" step="0.25"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify7112887', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Outline width for shapes drawn on the plot using Plotly&#39;s drawing tools'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" style="width:100%;" id="tipify918984">
#>             <label class="control-label" id="biplot-shape.linetype-label" for="biplot-shape.linetype">Shape Linetype</label>
#>             <div id="biplot-shape.linetype" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="change">
#>               <script type="application/json" data-for="biplot-shape.linetype">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["solid","dot","dash","longdash","dashdot","longdashdot"],"value":["solid","dot","dash","longdash","dashdot","longdashdot"]}},"config":{"multiple":false,"search":false,"selectedValue":"solid","hideClearButton":true,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":false,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":true,"disableOptionGroupCheckbox":true,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify918984', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Line dash style for shapes drawn on the plot using Plotly&#39;s drawing tools'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify1059088">
#>             <label class="control-label" id="biplot-shape.opacity-label" for="biplot-shape.opacity">Shape Opacity</label>
#>             <input id="biplot-shape.opacity" type="number" class="shiny-input-number form-control" value="1" data-update-on="change" min="0" max="1" step="0.01"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify1059088', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Opacity of shapes drawn on the plot, where 0 is fully transparent and 1 is fully opaque'})}, 500)});</script>
#>         </div>
#>       </div>
#>     </div>
#>     <div class="tab-pane" data-value="Extras" id="tab-5857-11">
#>       <div class="vizmodules-input-grid" style="--viz-input-columns: 2;">
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify2249139">
#>             <div class="checkbox">
#>               <label>
#>                 <input id="biplot-webgl" type="checkbox" class="shiny-input-checkbox" checked="checked"/>
#>                 <span>Plot with webGL</span>
#>               </label>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify2249139', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Enable WebGL rendering for improved performance with large datasets at the cost of some visual features'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify4176636">
#>             <div class="checkbox">
#>               <label>
#>                 <input id="biplot-do.ellipse" type="checkbox" class="shiny-input-checkbox"/>
#>                 <span>Enable Ellipses</span>
#>               </label>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify4176636', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Logical. Whether `color.by` groups should be surrounded by median-centered ellipses.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify3440131">
#>             <div class="checkbox">
#>               <label>
#>                 <input id="biplot-do.contour" type="checkbox" class="shiny-input-checkbox"/>
#>                 <span>Enable Contour</span>
#>               </label>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify3440131', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Logical. Whether density-based contours should be displayed.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" style="width:100%;" id="tipify6642059">
#>             <label class="control-label" id="biplot-hover.data-label" for="biplot-hover.data">Hover Data</label>
#>             <div id="biplot-hover.data" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="close">
#>               <script type="application/json" data-for="biplot-hover.data">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["(none)","sample","PC1","PC2","PC3","PC4","PC5","PC6","PC7","PC8","dex","cell","avgLength","lib.size","size.factor"],"value":["","sample","PC1","PC2","PC3","PC4","PC5","PC6","PC7","PC8","dex","cell","avgLength","lib.size","size.factor"]}},"config":{"multiple":true,"search":true,"selectedValue":"sample","hideClearButton":false,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":true,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":false,"disableOptionGroupCheckbox":false,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify6642059', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'String vector which denotes what data to show for each data point, upon hover, when `do.hover` is set to `TRUE`. Defaults to all data expected to be useful. Only values present in the plotting data are actually used. These can be column names of `data_frame` and any column names which will be created to accommodate multivar and data adjustment functionality. You can run the function with `data.out = TRUE` and inspect the `$Target_data` output&#39;s columns to view your available options.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify4433637">
#>             <label class="control-label" id="biplot-hover.round.digits-label" for="biplot-hover.round.digits">Hover Round Digits</label>
#>             <input id="biplot-hover.round.digits" type="number" class="shiny-input-number form-control" value="5" data-update-on="change" min="1" step="1"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify4433637', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Integer number specifying the number of decimal digits to round displayed numeric values to, when `do.hover` is set to `TRUE`.'})}, 500)});</script>
#>         </div>
#>       </div>
#>     </div>
#>     <div class="tab-pane" data-value="Lines" id="tab-5857-12">
#>       <div class="vizmodules-input-grid" style="--viz-input-columns: 2;">
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify3061836">
#>             <label class="control-label" id="biplot-hline.intercepts-label" for="biplot-hline.intercepts">Y-intercepts</label>
#>             <input id="biplot-hline.intercepts" type="text" class="shiny-input-text form-control" value="" placeholder="e.g. 2, -2" data-update-on="change"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify3061836', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'For categorical or factor axes, enter the index (position) of the category rather than its name. For example, if the axis categories are &#39;Audi&#39;, &#39;Mercedes&#39;, &#39;Bugatti&#39;, enter 2 to place a line at &#39;Mercedes&#39;.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify2693460">
#>             <label class="control-label" id="biplot-hline.colors-label" for="biplot-hline.colors">Y Colors</label>
#>             <input id="biplot-hline.colors" type="text" class="shiny-input-text form-control" value="#000000" data-update-on="change"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify2693460', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Color(s) for horizontal reference lines, as comma-separated hex codes or color names'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify2704266">
#>             <label class="control-label" id="biplot-hline.widths-label" for="biplot-hline.widths">Y Widths</label>
#>             <input id="biplot-hline.widths" type="text" class="shiny-input-text form-control" value="1" data-update-on="change"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify2704266', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Width(s) for horizontal reference lines in pixels, as comma-separated values'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify976897">
#>             <label class="control-label" id="biplot-hline.linetypes-label" for="biplot-hline.linetypes">Y Line Types</label>
#>             <input id="biplot-hline.linetypes" type="text" class="shiny-input-text form-control" value="dashed" placeholder="solid, dashed, dotted, ..." data-update-on="change"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify976897', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Line style(s) for horizontal reference lines (solid, dashed, dotted, dotdash, longdash, twodash)'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify9920599">
#>             <label class="control-label" id="biplot-hline.opacities-label" for="biplot-hline.opacities">Y Opacities (0-1)</label>
#>             <input id="biplot-hline.opacities" type="text" class="shiny-input-text form-control" value="1" data-update-on="change"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify9920599', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Opacity of horizontal reference lines between 0 (transparent) and 1 (opaque), as comma-separated values'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify1045266">
#>             <label class="control-label" id="biplot-vline.intercepts-label" for="biplot-vline.intercepts">X-intercepts</label>
#>             <input id="biplot-vline.intercepts" type="text" class="shiny-input-text form-control" value="" placeholder="e.g. 2, -2" data-update-on="change"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify1045266', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'For categorical or factor axes, enter the index (position) of the category rather than its name. For example, if the axis categories are &#39;Audi&#39;, &#39;Mercedes&#39;, &#39;Bugatti&#39;, enter 2 to place a line at &#39;Mercedes&#39;.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify4344885">
#>             <label class="control-label" id="biplot-vline.colors-label" for="biplot-vline.colors">X Colors</label>
#>             <input id="biplot-vline.colors" type="text" class="shiny-input-text form-control" value="#000000" data-update-on="change"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify4344885', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Color(s) for vertical reference lines, as comma-separated hex codes or color names'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify6846876">
#>             <label class="control-label" id="biplot-vline.widths-label" for="biplot-vline.widths">X Widths</label>
#>             <input id="biplot-vline.widths" type="text" class="shiny-input-text form-control" value="1" data-update-on="change"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify6846876', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Width(s) for vertical reference lines in pixels, as comma-separated values'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify3298215">
#>             <label class="control-label" id="biplot-vline.linetypes-label" for="biplot-vline.linetypes">X Line Types</label>
#>             <input id="biplot-vline.linetypes" type="text" class="shiny-input-text form-control" value="dashed" placeholder="solid, dashed, dotted, ..." data-update-on="change"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify3298215', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Line style(s) for vertical reference lines (solid, dashed, dotted, dotdash, longdash, twodash)'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify3995427">
#>             <label class="control-label" id="biplot-vline.opacities-label" for="biplot-vline.opacities">X Opacities (0-1)</label>
#>             <input id="biplot-vline.opacities" type="text" class="shiny-input-text form-control" value="1" data-update-on="change"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify3995427', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Opacity of vertical reference lines between 0 (transparent) and 1 (opaque), as comma-separated values'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify6991565">
#>             <label class="control-label" id="biplot-abline.slopes-label" for="biplot-abline.slopes">Ab Slopes</label>
#>             <input id="biplot-abline.slopes" type="text" class="shiny-input-text form-control" value="" data-update-on="change"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify6991565', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Slope(s) of diagonal reference lines (rise/run), as comma-separated values'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify2425231">
#>             <label class="control-label" id="biplot-abline.intercepts-label" for="biplot-abline.intercepts">Ab Y-intercepts</label>
#>             <input id="biplot-abline.intercepts" type="text" class="shiny-input-text form-control" value="" data-update-on="change"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify2425231', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'For categorical or factor axes, enter the index (position) of the category rather than its name. For example, if the axis categories are &#39;Audi&#39;, &#39;Mercedes&#39;, &#39;Bugatti&#39;, enter 2 to place a line at &#39;Mercedes&#39;.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify275351">
#>             <label class="control-label" id="biplot-abline.colors-label" for="biplot-abline.colors">Ab Colors</label>
#>             <input id="biplot-abline.colors" type="text" class="shiny-input-text form-control" value="#000000" data-update-on="change"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify275351', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Color(s) for diagonal reference lines, as comma-separated hex codes or color names'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify700901">
#>             <label class="control-label" id="biplot-abline.widths-label" for="biplot-abline.widths">Ab Widths</label>
#>             <input id="biplot-abline.widths" type="text" class="shiny-input-text form-control" value="1" data-update-on="change"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify700901', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Width(s) for diagonal reference lines in pixels, as comma-separated values'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify237033">
#>             <label class="control-label" id="biplot-abline.linetypes-label" for="biplot-abline.linetypes">Ab Line Types</label>
#>             <input id="biplot-abline.linetypes" type="text" class="shiny-input-text form-control" value="dashed" placeholder="solid, dashed, dotted, ..." data-update-on="change"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify237033', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Line style(s) for diagonal reference lines (solid, dashed, dotted, dotdash, longdash, twodash)'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify2066011">
#>             <label class="control-label" id="biplot-abline.opacities-label" for="biplot-abline.opacities">Ab Opacities (0-1)</label>
#>             <input id="biplot-abline.opacities" type="text" class="shiny-input-text form-control" value="1" data-update-on="change"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify2066011', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Opacity of diagonal reference lines between 0 (transparent) and 1 (opaque), as comma-separated values'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify6988863">
#>             <div class="material-switch">
#>               <label for="biplot-best.fit" style="padding-right: 10px;">Plot Best Fit Line</label>
#>               <input id="biplot-best.fit" type="checkbox"/>
#>               <label class="switch label-success bg-success" for="biplot-best.fit"></label>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify6988863', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Add a LOESS smoothed curve of best fit to the scatter plot'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify9813835">
#>             <label class="control-label" id="biplot-line.best.smoothness-label" for="biplot-line.best.smoothness">Best Fit Line Smoothness</label>
#>             <input id="biplot-line.best.smoothness" type="number" class="shiny-input-number form-control" value="1" data-update-on="change" min="0" max="10000"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify9813835', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Smoothing span for the LOESS curve; higher values produce a smoother, less wiggly fit'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour" id="tipify7816516">
#>             <label class="control-label" for="biplot-line.best.colour">Best Fit Line Color</label>
#>             <input id="biplot-line.best.colour" type="text" class="form-control shiny-colour-input" data-init-value="#000000" data-show-colour="both" data-palette="square"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify7816516', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Color for the LOESS best fit line'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify6054746">
#>             <div class="material-switch">
#>               <label for="biplot-linear.model" style="padding-right: 10px;">Linear Model Line</label>
#>               <input id="biplot-linear.model" type="checkbox"/>
#>               <label class="switch label-success bg-success" for="biplot-linear.model"></label>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify6054746', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Add a linear regression line to the scatter plot'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify2083617">
#>             <div class="material-switch">
#>               <label for="biplot-custom.model.enable" style="padding-right: 10px;">Custom Model Lines</label>
#>               <input id="biplot-custom.model.enable" type="checkbox"/>
#>               <label class="switch label-success bg-success" for="biplot-custom.model.enable"></label>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify2083617', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Fit one or more custom models from formulas you define below and overlay them as lines. Only data columns and basic math/transform terms are allowed.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="multi-dynamic-input shiny-input-container form-group is-plain" id="biplot-custom.models" data-keys="[&quot;model_type&quot;,&quot;formula&quot;,&quot;line_colour&quot;,&quot;line_width&quot;,&quot;drc_fct&quot;]" data-initial="[]" data-input-id="biplot-custom.models" data-row-prefix="models">
#>             <div class="mdi-top">
#>               <label class="control-label" for="biplot-custom.models">Models</label>
#>               <button type="button" class="mdi-add btn btn-default btn-sm">+ Add</button>
#>             </div>
#>             <div class="mdi-rows"></div>
#>             <template class="mdi-row-template">
#>               <div class="mdi-row">
#>                 <div class="mdi-fields">
#>                   <div class="mdi-field" data-key="model_type" style="flex: 1 1 calc(25% - 8px); min-width: 120px;">
#>                     <div class="form-group shiny-input-container">
#>                       <label class="control-label" id="biplot-custom.models-__ROWIDX__-model_type-label" for="biplot-custom.models-__ROWIDX__-model_type">Model type</label>
#>                       <div>
#>                         <select id="biplot-custom.models-__ROWIDX__-model_type" class="shiny-input-select"><option value="drm">drm</option>
#> <option value="glm">glm</option>
#> <option value="lm" selected>lm</option>
#> <option value="loess">loess</option></select>
#>                         <script type="application/json" data-for="biplot-custom.models-__ROWIDX__-model_type" data-nonempty="">{"plugins":["selectize-plugin-a11y"]}</script>
#>                       </div>
#>                     </div>
#>                   </div>
#>                   <div class="mdi-field" data-key="formula" style="flex: 1 1 calc(25% - 8px); min-width: 120px;">
#>                     <div class="form-group shiny-input-container">
#>                       <label class="control-label" id="biplot-custom.models-__ROWIDX__-formula-label" for="biplot-custom.models-__ROWIDX__-formula">Formula</label>
#>                       <input id="biplot-custom.models-__ROWIDX__-formula" type="text" class="shiny-input-text form-control" value="" placeholder="e.g. y ~ poly(x, 2)" data-update-on="change"/>
#>                     </div>
#>                   </div>
#>                   <div class="mdi-field" data-key="line_colour" style="flex: 1 1 calc(25% - 8px); min-width: 120px;">
#>                     <div class="form-group shiny-input-container" data-shiny-input-type="colour">
#>                       <label class="control-label" for="biplot-custom.models-__ROWIDX__-line_colour">Line colour</label>
#>                       <input id="biplot-custom.models-__ROWIDX__-line_colour" type="text" class="form-control shiny-colour-input" data-init-value="#000000" data-show-colour="both" data-palette="square"/>
#>                     </div>
#>                   </div>
#>                   <div class="mdi-field" data-key="line_width" style="flex: 1 1 calc(25% - 8px); min-width: 120px;">
#>                     <div class="form-group shiny-input-container">
#>                       <label class="control-label" id="biplot-custom.models-__ROWIDX__-line_width-label" for="biplot-custom.models-__ROWIDX__-line_width">Line width</label>
#>                       <input id="biplot-custom.models-__ROWIDX__-line_width" type="number" class="shiny-input-number form-control" value="2" data-update-on="change" min="0.5" max="20" step="0.5"/>
#>                     </div>
#>                   </div>
#>                   <div class="mdi-field" data-key="drc_fct" data-backend="drm" style="flex: 1 1 calc(25% - 8px); min-width: 120px; display: none;">
#>                     <div class="form-group shiny-input-container">
#>                       <label class="control-label" id="biplot-custom.models-__ROWIDX__-drc_fct-label" for="biplot-custom.models-__ROWIDX__-drc_fct">Drc fct</label>
#>                       <div>
#>                         <select id="biplot-custom.models-__ROWIDX__-drc_fct" class="shiny-input-select"><option value="LL.4" selected>LL.4</option>
#> <option value="LL.3">LL.3</option>
#> <option value="LL.2">LL.2</option>
#> <option value="W1.4">W1.4</option>
#> <option value="W2.4">W2.4</option></select>
#>                         <script type="application/json" data-for="biplot-custom.models-__ROWIDX__-drc_fct" data-nonempty="">{"plugins":["selectize-plugin-a11y"]}</script>
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
#>     <div class="tab-pane" data-value="Axes" id="tab-5857-13">
#>       <div class="vizmodules-input-grid" style="--viz-input-columns: 2;">
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" style="width:100%;">
#>             <label class="control-label" id="biplot-title.font.family-label" for="biplot-title.font.family">Title Font</label>
#>             <div id="biplot-title.font.family" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="change">
#>               <script type="application/json" data-for="biplot-title.font.family">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["Arial","Balto","Courier New","Droid Sans","Droid Serif","Droid Sans Mono","Gravitas One","Old Standard TT","Open Sans","Overpass","PT Sans Narrow","Raleway","Times New Roman","Verdana","sans-serif","serif","monospace"],"value":["Arial","Balto","Courier New","Droid Sans","Droid Serif","Droid Sans Mono","Gravitas One","Old Standard TT","Open Sans","Overpass","PT Sans Narrow","Raleway","Times New Roman","Verdana","sans-serif","serif","monospace"]}},"config":{"multiple":false,"search":true,"selectedValue":"Arial","hideClearButton":true,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":false,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":true,"disableOptionGroupCheckbox":true,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>             </div>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour">
#>             <label class="control-label" for="biplot-title.font.color">Title Color</label>
#>             <input id="biplot-title.font.color" type="text" class="form-control shiny-colour-input" data-init-value="#000000" data-show-colour="both" data-palette="square"/>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="biplot-title.font.size-label" for="biplot-title.font.size">Title Size</label>
#>             <input id="biplot-title.font.size" type="number" class="shiny-input-number form-control" value="26" data-update-on="change" min="1" step="1"/>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="biplot-axis.title.horizontal.position-label" for="biplot-axis.title.horizontal.position">Title position</label>
#>             <input id="biplot-axis.title.horizontal.position" type="number" class="shiny-input-number form-control" value="0.5" data-update-on="change" min="0" max="1" step="0.1"/>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="biplot-axis.title.font.size-label" for="biplot-axis.title.font.size">Axis Title Size</label>
#>             <input id="biplot-axis.title.font.size" type="number" class="shiny-input-number form-control" value="18" data-update-on="change" min="1" step="1"/>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour">
#>             <label class="control-label" for="biplot-axis.title.font.color">Axis Title Color</label>
#>             <input id="biplot-axis.title.font.color" type="text" class="form-control shiny-colour-input" data-init-value="#000000" data-show-colour="both" data-palette="square"/>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" style="width:100%;">
#>             <label class="control-label" id="biplot-axis.title.font.family-label" for="biplot-axis.title.font.family">Axis Title Font</label>
#>             <div id="biplot-axis.title.font.family" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="change">
#>               <script type="application/json" data-for="biplot-axis.title.font.family">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["Arial","Balto","Courier New","Droid Sans","Droid Serif","Droid Sans Mono","Gravitas One","Old Standard TT","Open Sans","Overpass","PT Sans Narrow","Raleway","Times New Roman","Verdana","sans-serif","serif","monospace"],"value":["Arial","Balto","Courier New","Droid Sans","Droid Serif","Droid Sans Mono","Gravitas One","Old Standard TT","Open Sans","Overpass","PT Sans Narrow","Raleway","Times New Roman","Verdana","sans-serif","serif","monospace"]}},"config":{"multiple":false,"search":true,"selectedValue":"Arial","hideClearButton":true,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":false,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":true,"disableOptionGroupCheckbox":true,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>             </div>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container">
#>             <div class="checkbox">
#>               <label>
#>                 <input id="biplot-axis.showline" type="checkbox" class="shiny-input-checkbox" checked="checked"/>
#>                 <span>Show Axis Borders</span>
#>               </label>
#>             </div>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container">
#>             <div class="checkbox">
#>               <label>
#>                 <input id="biplot-axis.mirror" type="checkbox" class="shiny-input-checkbox" checked="checked"/>
#>                 <span>Mirror Axis Borders</span>
#>               </label>
#>             </div>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container">
#>             <div class="checkbox">
#>               <label>
#>                 <input id="biplot-show.grid.x" type="checkbox" class="shiny-input-checkbox" checked="checked"/>
#>                 <span>Show X Gridlines</span>
#>               </label>
#>             </div>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container">
#>             <div class="checkbox">
#>               <label>
#>                 <input id="biplot-show.grid.y" type="checkbox" class="shiny-input-checkbox" checked="checked"/>
#>                 <span>Show Y Gridlines</span>
#>               </label>
#>             </div>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour">
#>             <label class="control-label" for="biplot-grid.color">Gridline Color</label>
#>             <input id="biplot-grid.color" type="text" class="form-control shiny-colour-input" data-init-value="#CCCCCC" data-show-colour="both" data-palette="square"/>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour">
#>             <label class="control-label" for="biplot-axis.linecolor">Axis Line Color</label>
#>             <input id="biplot-axis.linecolor" type="text" class="form-control shiny-colour-input" data-init-value="black" data-show-colour="both" data-palette="square"/>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="biplot-axis.linewidth-label" for="biplot-axis.linewidth">Axis Line Width</label>
#>             <input id="biplot-axis.linewidth" type="number" class="shiny-input-number form-control" value="0.5" data-update-on="change" min="0" step="0.1"/>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="biplot-axis.tickfont.size-label" for="biplot-axis.tickfont.size">Tick Label Size</label>
#>             <input id="biplot-axis.tickfont.size" type="number" class="shiny-input-number form-control" value="12" data-update-on="change" min="1" step="1"/>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour">
#>             <label class="control-label" for="biplot-axis.tickfont.color">Tick Label Color</label>
#>             <input id="biplot-axis.tickfont.color" type="text" class="form-control shiny-colour-input" data-init-value="black" data-show-colour="both" data-palette="square"/>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" style="width:100%;">
#>             <label class="control-label" id="biplot-axis.tickfont.family-label" for="biplot-axis.tickfont.family">Tick Label Font</label>
#>             <div id="biplot-axis.tickfont.family" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="change">
#>               <script type="application/json" data-for="biplot-axis.tickfont.family">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["Arial","Balto","Courier New","Droid Sans","Droid Serif","Droid Sans Mono","Gravitas One","Old Standard TT","Open Sans","Overpass","PT Sans Narrow","Raleway","Times New Roman","Verdana","sans-serif","serif","monospace"],"value":["Arial","Balto","Courier New","Droid Sans","Droid Serif","Droid Sans Mono","Gravitas One","Old Standard TT","Open Sans","Overpass","PT Sans Narrow","Raleway","Times New Roman","Verdana","sans-serif","serif","monospace"]}},"config":{"multiple":false,"search":true,"selectedValue":"Arial","hideClearButton":true,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":false,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":true,"disableOptionGroupCheckbox":true,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>             </div>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="biplot-axis.tickangle.x-label" for="biplot-axis.tickangle.x">X Tick Label Angle</label>
#>             <input id="biplot-axis.tickangle.x" type="number" class="shiny-input-number form-control" value="0" data-update-on="change" min="-180" max="180" step="15"/>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="biplot-axis.tickangle.y-label" for="biplot-axis.tickangle.y">Y Tick Label Angle</label>
#>             <input id="biplot-axis.tickangle.y" type="number" class="shiny-input-number form-control" value="0" data-update-on="change" min="-180" max="180" step="15"/>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" style="width:100%;">
#>             <label class="control-label" id="biplot-axis.ticks-label" for="biplot-axis.ticks">Tick Position</label>
#>             <div id="biplot-axis.ticks" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="change">
#>               <script type="application/json" data-for="biplot-axis.ticks">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["Outside","Inside","(none)"],"value":["outside","inside",""]}},"config":{"multiple":false,"search":false,"selectedValue":"outside","hideClearButton":true,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":false,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":true,"disableOptionGroupCheckbox":true,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>             </div>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour">
#>             <label class="control-label" for="biplot-axis.tickcolor">Tick Mark Color</label>
#>             <input id="biplot-axis.tickcolor" type="text" class="form-control shiny-colour-input" data-init-value="black" data-show-colour="both" data-palette="square"/>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="biplot-axis.ticklen-label" for="biplot-axis.ticklen">Tick Mark Length</label>
#>             <input id="biplot-axis.ticklen" type="number" class="shiny-input-number form-control" value="5" data-update-on="change" min="0" step="1"/>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="biplot-axis.tickwidth-label" for="biplot-axis.tickwidth">Tick Mark Width</label>
#>             <input id="biplot-axis.tickwidth" type="number" class="shiny-input-number form-control" value="1" data-update-on="change" min="0" step="0.1"/>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="biplot-facet.title.font.size-label" for="biplot-facet.title.font.size">Facet Subplot Title Size</label>
#>             <input id="biplot-facet.title.font.size" type="number" class="shiny-input-number form-control" value="18" data-update-on="change" min="1" step="1"/>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour">
#>             <label class="control-label" for="biplot-facet.title.font.color">Facet Title Color</label>
#>             <input id="biplot-facet.title.font.color" type="text" class="form-control shiny-colour-input" data-init-value="#000000" data-show-colour="both" data-palette="square"/>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" style="width:100%;">
#>             <label class="control-label" id="biplot-facet.title.font.family-label" for="biplot-facet.title.font.family">Facet Title Font</label>
#>             <div id="biplot-facet.title.font.family" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="change">
#>               <script type="application/json" data-for="biplot-facet.title.font.family">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["Arial","Balto","Courier New","Droid Sans","Droid Serif","Droid Sans Mono","Gravitas One","Old Standard TT","Open Sans","Overpass","PT Sans Narrow","Raleway","Times New Roman","Verdana","sans-serif","serif","monospace"],"value":["Arial","Balto","Courier New","Droid Sans","Droid Serif","Droid Sans Mono","Gravitas One","Old Standard TT","Open Sans","Overpass","PT Sans Narrow","Raleway","Times New Roman","Verdana","sans-serif","serif","monospace"]}},"config":{"multiple":false,"search":true,"selectedValue":"Arial","hideClearButton":true,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":false,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":true,"disableOptionGroupCheckbox":true,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
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
#>         <label for="biplot-auto.update" style="padding-right: 10px;">Auto Update</label>
#>         <input id="biplot-auto.update" type="checkbox" checked="checked"/>
#>         <label class="switch label-success bg-success" for="biplot-auto.update"></label>
#>       </div>
#>     </div>
#>   </div>
#>   <div class="module-tack-buttons" style="display: flex; flex-wrap: wrap; gap: 8px;">
#>     <button class="btn btn-default action-button btn-primary" id="biplot-update" style="flex: 1 1 45%;" type="button"><span class="action-label">Update</span></button>
#>     <button class="btn btn-default action-button btn-secondary" id="biplot-reset" style="flex: 1 1 45%;" type="button"><span class="action-label">Reset</span></button>
#>     <a aria-disabled="true" class="btn btn-default shiny-download-link disabled btn-secondary viz-source-download" data-viz-source-ns="biplot-" download href="" id="biplot-download.source" style="flex: 1 1 100%;" tabindex="-1" target="_blank">
#>       <i class="far fa-file-code" role="presentation" aria-label="file-code icon"></i>
#>       Source Download
#>     </a>
#>     <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('biplot-download.source', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Download the plot as a self-contained HTML file and as SVG and PNG images of it as it looks now, along with the plot source data and statistics (if applicable) as CSV files.'})}, 500)});</script>
#>   </div>
#> </div>
```
