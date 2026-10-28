# Input UI components for the pcaEigencorPlot module

This should be placed in the UI where the inputs should be shown, with
an `id` that matches the `id` used in the
[`pcaEigencorPlotServer()`](https://j-andrews7.github.io/sciVizModules/reference/pcaEigencorPlotServer.md)
and
[`pcaEigencorPlotOutputUI()`](https://j-andrews7.github.io/sciVizModules/reference/pcaEigencorPlotOutputUI.md)
functions.

## Usage

``` r
pcaEigencorPlotInputsUI(
  id,
  data,
  defaults = NULL,
  title = "PC-Metadata Correlation Settings",
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

The module draws
[`pcaEigencorPlot()`](https://j-andrews7.github.io/sciVizModules/reference/pcaEigencorPlot.md)
for a PCAtools `pca` object: the correlation of each component with each
sample metadata variable, to see which components track which covariates
(treatment, batch, sequencing depth). The inputs are organised into tabs
via
[`VizModules::organize_inputs()`](https://j-andrews7.github.io/VizModules/reference/organize_inputs.html).

## Plot parameters and defaults

The following parameters can be accessed via UI inputs and/or the
`defaults` argument:

- `components` - Components to correlate (default: the first 10;
  PCAtools `components`)

- `metavars` - Metadata variables (default: all; PCAtools `metavars`).
  Non-numeric ones are converted to integer codes.

- `cor.method` - `"pearson"`, `"spearman"` or `"kendall"` (default:
  `"pearson"`; PCAtools `corFUN`)

- `p.adjust.method` - Multiple-testing correction across all cells
  (default: `"none"`; PCAtools `corMultipleTestCorrection`)

- `plot.rsquared` - Show R-squared rather than r (default: FALSE;
  PCAtools `plotRsquared`)

- `low.color`, `mid.color`, `high.color` - Colour scale (defaults: dark
  blue, white, dark red; PCAtools `col`)

- `show.values` - Print values and significance stars in the cells
  (default: TRUE)

- `digits` - Decimal places of the printed values (default: 2)

The Legend, Axes and Plotly tabs carry the shared VizModules inputs.

## See also

[`pcaEigencorPlot()`](https://j-andrews7.github.io/sciVizModules/reference/pcaEigencorPlot.md),
[`PCAtools::eigencorplot()`](https://rdrr.io/pkg/PCAtools/man/eigencorplot.html),
[`pcaEigencorPlotOutputUI()`](https://j-andrews7.github.io/sciVizModules/reference/pcaEigencorPlotOutputUI.md),
[`pcaEigencorPlotServer()`](https://j-andrews7.github.io/sciVizModules/reference/pcaEigencorPlotServer.md),
[`pcaEigencorPlotApp()`](https://j-andrews7.github.io/sciVizModules/reference/pcaEigencorPlotApp.md)

## Author

Jared Andrews

## Examples

``` r
library(sciVizModules)
data(example_pca)
pcaEigencorPlotInputsUI("eigencor", example_pca)
#> <h3>PC-Metadata Correlation Settings</h3>
#> <div class="tabbable vizmodules-input-tabs">
#>   <ul class="nav nav-tabs shiny-tab-input" id="eigencor-pcaEigencorPlotTabsetPanel" data-tabsetid="8195">
#>     <li class="active">
#>       <a href="#tab-8195-1" data-toggle="tab" data-bs-toggle="tab" data-value="Data">Data</a>
#>     </li>
#>     <li>
#>       <a href="#tab-8195-2" data-toggle="tab" data-bs-toggle="tab" data-value="Aesthetics">Aesthetics</a>
#>     </li>
#>     <li>
#>       <a href="#tab-8195-3" data-toggle="tab" data-bs-toggle="tab" data-value="Legend">Legend</a>
#>     </li>
#>     <li>
#>       <a href="#tab-8195-4" data-toggle="tab" data-bs-toggle="tab" data-value="Axes">Axes</a>
#>     </li>
#>     <li>
#>       <a href="#tab-8195-5" data-toggle="tab" data-bs-toggle="tab" data-value="Plotly">Plotly</a>
#>     </li>
#>   </ul>
#>   <div class="tab-content" data-tabsetid="8195">
#>     <div class="tab-pane active" data-value="Data" id="tab-8195-1">
#>       <div class="vizmodules-input-grid" style="--viz-input-columns: 2;">
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" style="width:100%;" id="tipify7636785">
#>             <label class="control-label" id="eigencor-components-label" for="eigencor-components">Components</label>
#>             <div id="eigencor-components" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="close">
#>               <script type="application/json" data-for="eigencor-components">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["PC1","PC2","PC3","PC4","PC5","PC6","PC7","PC8"],"value":["PC1","PC2","PC3","PC4","PC5","PC6","PC7","PC8"]}},"config":{"multiple":true,"search":false,"selectedValue":["PC1","PC2","PC3","PC4","PC5","PC6","PC7","PC8"],"hideClearButton":false,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":true,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":false,"disableOptionGroupCheckbox":false,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify7636785', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Components to correlate with the metadata.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" style="width:100%;" id="tipify8187860">
#>             <label class="control-label" id="eigencor-metavars-label" for="eigencor-metavars">Metadata Variables</label>
#>             <div id="eigencor-metavars" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="close">
#>               <script type="application/json" data-for="eigencor-metavars">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["dex","cell","avgLength","lib.size","size.factor"],"value":["dex","cell","avgLength","lib.size","size.factor"]}},"config":{"multiple":true,"search":false,"selectedValue":["dex","cell","avgLength","lib.size","size.factor"],"hideClearButton":false,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":true,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":false,"disableOptionGroupCheckbox":false,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify8187860', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Metadata variables to correlate. Non-numeric variables are converted to integer codes.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" style="width:100%;" id="tipify7611123">
#>             <label class="control-label" id="eigencor-cor.method-label" for="eigencor-cor.method">Correlation</label>
#>             <div id="eigencor-cor.method" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="change">
#>               <script type="application/json" data-for="eigencor-cor.method">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["Pearson","Spearman","Kendall"],"value":["pearson","spearman","kendall"]}},"config":{"multiple":false,"search":false,"selectedValue":"pearson","hideClearButton":true,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":false,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":true,"disableOptionGroupCheckbox":true,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify7611123', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Correlation coefficient.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" style="width:100%;" id="tipify8286271">
#>             <label class="control-label" id="eigencor-p.adjust.method-label" for="eigencor-p.adjust.method">P-value Adjustment</label>
#>             <div id="eigencor-p.adjust.method" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="change">
#>               <script type="application/json" data-for="eigencor-p.adjust.method">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["holm","hochberg","hommel","bonferroni","BH","BY","fdr","none"],"value":["holm","hochberg","hommel","bonferroni","BH","BY","fdr","none"]}},"config":{"multiple":false,"search":false,"selectedValue":"none","hideClearButton":true,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":false,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":true,"disableOptionGroupCheckbox":true,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify8286271', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Multiple-testing correction, applied across every cell.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify85093">
#>             <div class="material-switch">
#>               <label for="eigencor-plot.rsquared" style="padding-right: 10px;">R-squared</label>
#>               <input id="eigencor-plot.rsquared" type="checkbox"/>
#>               <label class="switch label-success bg-success" for="eigencor-plot.rsquared"></label>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify85093', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Show R-squared rather than the signed coefficient.'})}, 500)});</script>
#>         </div>
#>       </div>
#>     </div>
#>     <div class="tab-pane" data-value="Aesthetics" id="tab-8195-2">
#>       <div class="vizmodules-input-grid" style="--viz-input-columns: 2;">
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour" id="tipify888213">
#>             <label class="control-label" for="eigencor-low.color">Low Color</label>
#>             <input id="eigencor-low.color" type="text" class="form-control shiny-colour-input" data-init-value="#00008B" data-show-colour="both" data-palette="square"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify888213', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Colour of the strongest negative correlations.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour" id="tipify9198801">
#>             <label class="control-label" for="eigencor-mid.color">Mid Color</label>
#>             <input id="eigencor-mid.color" type="text" class="form-control shiny-colour-input" data-init-value="#FFFFFF" data-show-colour="both" data-palette="square"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify9198801', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Colour of no correlation.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour" id="tipify6383964">
#>             <label class="control-label" for="eigencor-high.color">High Color</label>
#>             <input id="eigencor-high.color" type="text" class="form-control shiny-colour-input" data-init-value="#8B0000" data-show-colour="both" data-palette="square"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify6383964', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Colour of the strongest positive correlations.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify4169858">
#>             <div class="material-switch">
#>               <label for="eigencor-show.values" style="padding-right: 10px;">Cell Values</label>
#>               <input id="eigencor-show.values" type="checkbox" checked="checked"/>
#>               <label class="switch label-success bg-success" for="eigencor-show.values"></label>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify4169858', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Print the value and significance stars (* < 0.05, ** < 0.01, *** < 0.001) in each cell.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify7020355">
#>             <label class="control-label" id="eigencor-digits-label" for="eigencor-digits">Decimal Places</label>
#>             <input id="eigencor-digits" type="number" class="shiny-input-number form-control" value="2" data-update-on="change" min="0" max="4" step="1"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify7020355', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Decimal places of the printed values.'})}, 500)});</script>
#>         </div>
#>       </div>
#>     </div>
#>     <div class="tab-pane" data-value="Legend" id="tab-8195-3">
#>       <div class="vizmodules-input-grid" style="--viz-input-columns: 2;">
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify1610262">
#>             <div class="material-switch">
#>               <label for="eigencor-legend.show" style="padding-right: 10px;">Show Legend</label>
#>               <input id="eigencor-legend.show" type="checkbox" checked="checked"/>
#>               <label class="switch label-success bg-success" for="eigencor-legend.show"></label>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify1610262', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Show the legend. Turning it off also hides colorbars and any point size legend.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" style="width:100%;" id="tipify3779098">
#>             <label class="control-label" id="eigencor-legend.font.family-label" for="eigencor-legend.font.family">Legend Font</label>
#>             <div id="eigencor-legend.font.family" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="change">
#>               <script type="application/json" data-for="eigencor-legend.font.family">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["Arial","Balto","Courier New","Droid Sans","Droid Serif","Droid Sans Mono","Gravitas One","Old Standard TT","Open Sans","Overpass","PT Sans Narrow","Raleway","Times New Roman","Verdana","sans-serif","serif","monospace"],"value":["Arial","Balto","Courier New","Droid Sans","Droid Serif","Droid Sans Mono","Gravitas One","Old Standard TT","Open Sans","Overpass","PT Sans Narrow","Raleway","Times New Roman","Verdana","sans-serif","serif","monospace"]}},"config":{"multiple":false,"search":true,"selectedValue":"Arial","hideClearButton":true,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":false,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":true,"disableOptionGroupCheckbox":true,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify3779098', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Font family of the legend title and entry labels.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour" id="tipify9751168">
#>             <label class="control-label" for="eigencor-legend.font.color">Legend Font Color</label>
#>             <input id="eigencor-legend.font.color" type="text" class="form-control shiny-colour-input" data-init-value="#000000" data-show-colour="both" data-palette="square"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify9751168', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Font color of the legend title and entry labels.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify4035552">
#>             <label class="control-label" id="eigencor-legend.title.size-label" for="eigencor-legend.title.size">Legend Title Size</label>
#>             <input id="eigencor-legend.title.size" type="number" class="shiny-input-number form-control" value="14" data-update-on="change" min="0" step="1"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify4035552', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Font size of the legend title.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify7237593">
#>             <label class="control-label" id="eigencor-legend.text.size-label" for="eigencor-legend.text.size">Legend Text Size</label>
#>             <input id="eigencor-legend.text.size" type="number" class="shiny-input-number form-control" value="12" data-update-on="change" min="0" step="1"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify7237593', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Font size of the legend entry labels.'})}, 500)});</script>
#>         </div>
#>       </div>
#>     </div>
#>     <div class="tab-pane" data-value="Axes" id="tab-8195-4">
#>       <div class="vizmodules-input-grid" style="--viz-input-columns: 2;">
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" style="width:100%;">
#>             <label class="control-label" id="eigencor-title.font.family-label" for="eigencor-title.font.family">Title Font</label>
#>             <div id="eigencor-title.font.family" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="change">
#>               <script type="application/json" data-for="eigencor-title.font.family">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["Arial","Balto","Courier New","Droid Sans","Droid Serif","Droid Sans Mono","Gravitas One","Old Standard TT","Open Sans","Overpass","PT Sans Narrow","Raleway","Times New Roman","Verdana","sans-serif","serif","monospace"],"value":["Arial","Balto","Courier New","Droid Sans","Droid Serif","Droid Sans Mono","Gravitas One","Old Standard TT","Open Sans","Overpass","PT Sans Narrow","Raleway","Times New Roman","Verdana","sans-serif","serif","monospace"]}},"config":{"multiple":false,"search":true,"selectedValue":"Arial","hideClearButton":true,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":false,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":true,"disableOptionGroupCheckbox":true,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>             </div>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour">
#>             <label class="control-label" for="eigencor-title.font.color">Title Color</label>
#>             <input id="eigencor-title.font.color" type="text" class="form-control shiny-colour-input" data-init-value="#000000" data-show-colour="both" data-palette="square"/>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="eigencor-title.font.size-label" for="eigencor-title.font.size">Title Size</label>
#>             <input id="eigencor-title.font.size" type="number" class="shiny-input-number form-control" value="26" data-update-on="change" min="1" step="1"/>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="eigencor-axis.title.horizontal.position-label" for="eigencor-axis.title.horizontal.position">Title position</label>
#>             <input id="eigencor-axis.title.horizontal.position" type="number" class="shiny-input-number form-control" value="0.5" data-update-on="change" min="0" max="1" step="0.1"/>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="eigencor-axis.title.font.size-label" for="eigencor-axis.title.font.size">Axis Title Size</label>
#>             <input id="eigencor-axis.title.font.size" type="number" class="shiny-input-number form-control" value="18" data-update-on="change" min="1" step="1"/>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour">
#>             <label class="control-label" for="eigencor-axis.title.font.color">Axis Title Color</label>
#>             <input id="eigencor-axis.title.font.color" type="text" class="form-control shiny-colour-input" data-init-value="#000000" data-show-colour="both" data-palette="square"/>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" style="width:100%;">
#>             <label class="control-label" id="eigencor-axis.title.font.family-label" for="eigencor-axis.title.font.family">Axis Title Font</label>
#>             <div id="eigencor-axis.title.font.family" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="change">
#>               <script type="application/json" data-for="eigencor-axis.title.font.family">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["Arial","Balto","Courier New","Droid Sans","Droid Serif","Droid Sans Mono","Gravitas One","Old Standard TT","Open Sans","Overpass","PT Sans Narrow","Raleway","Times New Roman","Verdana","sans-serif","serif","monospace"],"value":["Arial","Balto","Courier New","Droid Sans","Droid Serif","Droid Sans Mono","Gravitas One","Old Standard TT","Open Sans","Overpass","PT Sans Narrow","Raleway","Times New Roman","Verdana","sans-serif","serif","monospace"]}},"config":{"multiple":false,"search":true,"selectedValue":"Arial","hideClearButton":true,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":false,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":true,"disableOptionGroupCheckbox":true,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>             </div>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container">
#>             <div class="checkbox">
#>               <label>
#>                 <input id="eigencor-axis.showline" type="checkbox" class="shiny-input-checkbox" checked="checked"/>
#>                 <span>Show Axis Borders</span>
#>               </label>
#>             </div>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container">
#>             <div class="checkbox">
#>               <label>
#>                 <input id="eigencor-axis.mirror" type="checkbox" class="shiny-input-checkbox" checked="checked"/>
#>                 <span>Mirror Axis Borders</span>
#>               </label>
#>             </div>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container">
#>             <div class="checkbox">
#>               <label>
#>                 <input id="eigencor-show.grid.x" type="checkbox" class="shiny-input-checkbox" checked="checked"/>
#>                 <span>Show X Gridlines</span>
#>               </label>
#>             </div>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container">
#>             <div class="checkbox">
#>               <label>
#>                 <input id="eigencor-show.grid.y" type="checkbox" class="shiny-input-checkbox" checked="checked"/>
#>                 <span>Show Y Gridlines</span>
#>               </label>
#>             </div>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour">
#>             <label class="control-label" for="eigencor-grid.color">Gridline Color</label>
#>             <input id="eigencor-grid.color" type="text" class="form-control shiny-colour-input" data-init-value="#CCCCCC" data-show-colour="both" data-palette="square"/>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour">
#>             <label class="control-label" for="eigencor-axis.linecolor">Axis Line Color</label>
#>             <input id="eigencor-axis.linecolor" type="text" class="form-control shiny-colour-input" data-init-value="black" data-show-colour="both" data-palette="square"/>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="eigencor-axis.linewidth-label" for="eigencor-axis.linewidth">Axis Line Width</label>
#>             <input id="eigencor-axis.linewidth" type="number" class="shiny-input-number form-control" value="0.5" data-update-on="change" min="0" step="0.1"/>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="eigencor-axis.tickfont.size-label" for="eigencor-axis.tickfont.size">Tick Label Size</label>
#>             <input id="eigencor-axis.tickfont.size" type="number" class="shiny-input-number form-control" value="12" data-update-on="change" min="1" step="1"/>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour">
#>             <label class="control-label" for="eigencor-axis.tickfont.color">Tick Label Color</label>
#>             <input id="eigencor-axis.tickfont.color" type="text" class="form-control shiny-colour-input" data-init-value="black" data-show-colour="both" data-palette="square"/>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" style="width:100%;">
#>             <label class="control-label" id="eigencor-axis.tickfont.family-label" for="eigencor-axis.tickfont.family">Tick Label Font</label>
#>             <div id="eigencor-axis.tickfont.family" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="change">
#>               <script type="application/json" data-for="eigencor-axis.tickfont.family">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["Arial","Balto","Courier New","Droid Sans","Droid Serif","Droid Sans Mono","Gravitas One","Old Standard TT","Open Sans","Overpass","PT Sans Narrow","Raleway","Times New Roman","Verdana","sans-serif","serif","monospace"],"value":["Arial","Balto","Courier New","Droid Sans","Droid Serif","Droid Sans Mono","Gravitas One","Old Standard TT","Open Sans","Overpass","PT Sans Narrow","Raleway","Times New Roman","Verdana","sans-serif","serif","monospace"]}},"config":{"multiple":false,"search":true,"selectedValue":"Arial","hideClearButton":true,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":false,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":true,"disableOptionGroupCheckbox":true,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>             </div>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="eigencor-axis.tickangle.x-label" for="eigencor-axis.tickangle.x">X Tick Label Angle</label>
#>             <input id="eigencor-axis.tickangle.x" type="number" class="shiny-input-number form-control" value="0" data-update-on="change" min="-180" max="180" step="15"/>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="eigencor-axis.tickangle.y-label" for="eigencor-axis.tickangle.y">Y Tick Label Angle</label>
#>             <input id="eigencor-axis.tickangle.y" type="number" class="shiny-input-number form-control" value="0" data-update-on="change" min="-180" max="180" step="15"/>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" style="width:100%;">
#>             <label class="control-label" id="eigencor-axis.ticks-label" for="eigencor-axis.ticks">Tick Position</label>
#>             <div id="eigencor-axis.ticks" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="change">
#>               <script type="application/json" data-for="eigencor-axis.ticks">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["Outside","Inside","(none)"],"value":["outside","inside",""]}},"config":{"multiple":false,"search":false,"selectedValue":"outside","hideClearButton":true,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":false,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":true,"disableOptionGroupCheckbox":true,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>             </div>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour">
#>             <label class="control-label" for="eigencor-axis.tickcolor">Tick Mark Color</label>
#>             <input id="eigencor-axis.tickcolor" type="text" class="form-control shiny-colour-input" data-init-value="black" data-show-colour="both" data-palette="square"/>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="eigencor-axis.ticklen-label" for="eigencor-axis.ticklen">Tick Mark Length</label>
#>             <input id="eigencor-axis.ticklen" type="number" class="shiny-input-number form-control" value="5" data-update-on="change" min="0" step="1"/>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="eigencor-axis.tickwidth-label" for="eigencor-axis.tickwidth">Tick Mark Width</label>
#>             <input id="eigencor-axis.tickwidth" type="number" class="shiny-input-number form-control" value="1" data-update-on="change" min="0" step="0.1"/>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="eigencor-facet.title.font.size-label" for="eigencor-facet.title.font.size">Facet Subplot Title Size</label>
#>             <input id="eigencor-facet.title.font.size" type="number" class="shiny-input-number form-control" value="18" data-update-on="change" min="1" step="1"/>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour">
#>             <label class="control-label" for="eigencor-facet.title.font.color">Facet Title Color</label>
#>             <input id="eigencor-facet.title.font.color" type="text" class="form-control shiny-colour-input" data-init-value="#000000" data-show-colour="both" data-palette="square"/>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" style="width:100%;">
#>             <label class="control-label" id="eigencor-facet.title.font.family-label" for="eigencor-facet.title.font.family">Facet Title Font</label>
#>             <div id="eigencor-facet.title.font.family" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="change">
#>               <script type="application/json" data-for="eigencor-facet.title.font.family">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["Arial","Balto","Courier New","Droid Sans","Droid Serif","Droid Sans Mono","Gravitas One","Old Standard TT","Open Sans","Overpass","PT Sans Narrow","Raleway","Times New Roman","Verdana","sans-serif","serif","monospace"],"value":["Arial","Balto","Courier New","Droid Sans","Droid Serif","Droid Sans Mono","Gravitas One","Old Standard TT","Open Sans","Overpass","PT Sans Narrow","Raleway","Times New Roman","Verdana","sans-serif","serif","monospace"]}},"config":{"multiple":false,"search":true,"selectedValue":"Arial","hideClearButton":true,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":false,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":true,"disableOptionGroupCheckbox":true,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>             </div>
#>           </div>
#>         </div>
#>       </div>
#>     </div>
#>     <div class="tab-pane" data-value="Plotly" id="tab-8195-5">
#>       <div class="vizmodules-input-grid" style="--viz-input-columns: 2;">
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" style="width:100%;">
#>             <label class="control-label" id="eigencor-download.format-label" for="eigencor-download.format">Download Format</label>
#>             <div id="eigencor-download.format" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="change">
#>               <script type="application/json" data-for="eigencor-download.format">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["svg","png","jpeg","webp"],"value":["svg","png","jpeg","webp"]}},"config":{"multiple":false,"search":false,"selectedValue":"svg","hideClearButton":true,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":false,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":true,"disableOptionGroupCheckbox":true,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>             </div>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify3851899">
#>             <label class="control-label" id="eigencor-margin.t-label" for="eigencor-margin.t">Margin Top</label>
#>             <input id="eigencor-margin.t" type="number" class="shiny-input-number form-control" value="70" data-update-on="change" min="0" step="5"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify3851899', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Top margin of the plot in pixels'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify3890885">
#>             <label class="control-label" id="eigencor-margin.b-label" for="eigencor-margin.b">Margin Bottom</label>
#>             <input id="eigencor-margin.b" type="number" class="shiny-input-number form-control" value="70" data-update-on="change" min="0" step="5"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify3890885', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Bottom margin of the plot in pixels'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify1296418">
#>             <label class="control-label" id="eigencor-margin.l-label" for="eigencor-margin.l">Margin Left</label>
#>             <input id="eigencor-margin.l" type="number" class="shiny-input-number form-control" value="70" data-update-on="change" min="0" step="5"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify1296418', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Left margin of the plot in pixels'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify2847507">
#>             <label class="control-label" id="eigencor-margin.r-label" for="eigencor-margin.r">Margin Right</label>
#>             <input id="eigencor-margin.r" type="number" class="shiny-input-number form-control" value="90" data-update-on="change" min="0" step="5"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify2847507', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Right margin of the plot in pixels'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour" id="tipify1307439">
#>             <label class="control-label" for="eigencor-shape.fill">Shape Fill</label>
#>             <input id="eigencor-shape.fill" type="text" class="form-control shiny-colour-input" data-init-value="rgba(0, 0, 0, 0)" data-show-colour="both" data-palette="square" data-allow-alpha="true"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify1307439', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Interior fill color for shapes drawn on the plot using Plotly&#39;s drawing tools'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour" id="tipify4740490">
#>             <label class="control-label" for="eigencor-shape.line.color">Shape Line Color</label>
#>             <input id="eigencor-shape.line.color" type="text" class="form-control shiny-colour-input" data-init-value="black" data-show-colour="both" data-palette="square" data-allow-alpha="true"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify4740490', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Outline color for shapes drawn on the plot using Plotly&#39;s drawing tools'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify9800091">
#>             <label class="control-label" id="eigencor-shape.line.width-label" for="eigencor-shape.line.width">Shape Line Width</label>
#>             <input id="eigencor-shape.line.width" type="number" class="shiny-input-number form-control" value="4" data-update-on="change" min="0" step="0.25"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify9800091', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Outline width for shapes drawn on the plot using Plotly&#39;s drawing tools'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" style="width:100%;" id="tipify1683405">
#>             <label class="control-label" id="eigencor-shape.linetype-label" for="eigencor-shape.linetype">Shape Linetype</label>
#>             <div id="eigencor-shape.linetype" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="change">
#>               <script type="application/json" data-for="eigencor-shape.linetype">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["solid","dot","dash","longdash","dashdot","longdashdot"],"value":["solid","dot","dash","longdash","dashdot","longdashdot"]}},"config":{"multiple":false,"search":false,"selectedValue":"solid","hideClearButton":true,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":false,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":true,"disableOptionGroupCheckbox":true,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify1683405', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Line dash style for shapes drawn on the plot using Plotly&#39;s drawing tools'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify1815383">
#>             <label class="control-label" id="eigencor-shape.opacity-label" for="eigencor-shape.opacity">Shape Opacity</label>
#>             <input id="eigencor-shape.opacity" type="number" class="shiny-input-number form-control" value="1" data-update-on="change" min="0" max="1" step="0.01"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify1815383', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Opacity of shapes drawn on the plot, where 0 is fully transparent and 1 is fully opaque'})}, 500)});</script>
#>         </div>
#>       </div>
#>     </div>
#>   </div>
#> </div>
#> <div class="module-tack" style="margin-top: 12px;">
#>   <div class="module-tack-switch" style="margin-bottom: 4px;">
#>     <div class="form-group shiny-input-container">
#>       <div class="material-switch">
#>         <label for="eigencor-auto.update" style="padding-right: 10px;">Auto Update</label>
#>         <input id="eigencor-auto.update" type="checkbox" checked="checked"/>
#>         <label class="switch label-success bg-success" for="eigencor-auto.update"></label>
#>       </div>
#>     </div>
#>   </div>
#>   <div class="module-tack-buttons" style="display: flex; flex-wrap: wrap; gap: 8px;">
#>     <button class="btn btn-default action-button btn-primary" id="eigencor-update" style="flex: 1 1 45%;" type="button"><span class="action-label">Update</span></button>
#>     <button class="btn btn-default action-button btn-secondary" id="eigencor-reset" style="flex: 1 1 45%;" type="button"><span class="action-label">Reset</span></button>
#>     <a aria-disabled="true" class="btn btn-default shiny-download-link disabled btn-secondary viz-source-download" data-viz-source-ns="eigencor-" download href="" id="eigencor-download.source" style="flex: 1 1 100%;" tabindex="-1" target="_blank">
#>       <i class="far fa-file-code" role="presentation" aria-label="file-code icon"></i>
#>       Source Download
#>     </a>
#>     <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('eigencor-download.source', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Download the plot as a self-contained HTML file and as SVG and PNG images of it as it looks now, along with the plot source data and statistics (if applicable) as CSV files.'})}, 500)});</script>
#>   </div>
#> </div>
```
