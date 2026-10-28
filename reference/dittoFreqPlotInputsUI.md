# Input UI components for the dittoFreqPlot module

This should be placed in the UI where the inputs should be shown, with
an `id` that matches the `id` used in the
[`dittoFreqPlotServer()`](https://j-andrews7.github.io/sciVizModules/reference/dittoFreqPlotServer.md)
and
[`dittoFreqPlotOutputUI()`](https://j-andrews7.github.io/sciVizModules/reference/dittoFreqPlotOutputUI.md)
functions.

## Usage

``` r
dittoFreqPlotInputsUI(
  id,
  data,
  defaults = NULL,
  title = "FreqPlot Settings",
  columns = 2
)
```

## Arguments

- id:

  The ID for the Shiny module.

- data:

  A `SingleCellExperiment`, `Seurat`, or `SummarizedExperiment` object
  used to populate the input choices.

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

This module wraps
[`dittoSeq::dittoFreqPlot()`](https://rdrr.io/pkg/dittoSeq/man/dittoFreqPlot.html),
which computes the per-sample frequency (or count) of each level of a
discrete `var` and plots those frequencies across groups as
jitter/box/violin/ridge representations. The resulting `ggplot` is
converted to an interactive `plotly` figure.

## Plot parameters and defaults

The following parameters can be accessed via UI inputs and/or the
`defaults` argument:

- `var` - Discrete metadata whose frequencies are computed

- `sample.by` - Discrete metadata identifying individual samples

- `group.by` - Discrete metadata used for the x-axis groups

- `color.by` - Discrete metadata used for fill colors (default:
  `group.by`)

- `scale` - "percent" or "count" (default: "percent")

- `plots` - Representations to draw (default: c("boxplot", "jitter"))

- `max.normalize` - Scale each facet to its own max (default: FALSE)

- `jitter.size` - Jitter point size (default: 1)

- `jitter.width` - Horizontal spread of the jitter points (default: 0.2)

- `jitter.color` - Color of the jitter points (default: "#000000")

- `boxplot.width` - Width of the boxplots (default: 0.4)

- `vlnplot.width` - Relative width of the violins (default: 1)

- `palette.selection` - Colors for discrete groups (multiColorPicker)

## See also

[`dittoSeq::dittoFreqPlot()`](https://rdrr.io/pkg/dittoSeq/man/dittoFreqPlot.html),
[`VizModules::organize_inputs()`](https://j-andrews7.github.io/VizModules/reference/organize_inputs.html),
[`dittoFreqPlotOutputUI()`](https://j-andrews7.github.io/sciVizModules/reference/dittoFreqPlotOutputUI.md),
[`dittoFreqPlotServer()`](https://j-andrews7.github.io/sciVizModules/reference/dittoFreqPlotServer.md),
[`dittoFreqPlotApp()`](https://j-andrews7.github.io/sciVizModules/reference/dittoFreqPlotApp.md)

## Author

Jacob Martin, Jared Andrews

## Examples

``` r
library(sciVizModules)
data(example_sce)
dittoFreqPlotInputsUI("dittoFreqPlot", example_sce)
#> <h3>FreqPlot Settings</h3>
#> <div class="tabbable vizmodules-input-tabs">
#>   <ul class="nav nav-tabs shiny-tab-input" id="dittoFreqPlot-dittoFreqPlotTabsetPanel" data-tabsetid="2979">
#>     <li class="active">
#>       <a href="#tab-2979-1" data-toggle="tab" data-bs-toggle="tab" data-value="Data">Data</a>
#>     </li>
#>     <li>
#>       <a href="#tab-2979-2" data-toggle="tab" data-bs-toggle="tab" data-value="Aesthetics">Aesthetics</a>
#>     </li>
#>     <li>
#>       <a href="#tab-2979-3" data-toggle="tab" data-bs-toggle="tab" data-value="Plotly">Plotly</a>
#>     </li>
#>     <li>
#>       <a href="#tab-2979-4" data-toggle="tab" data-bs-toggle="tab" data-value="Axes">Axes</a>
#>     </li>
#>     <li>
#>       <a href="#tab-2979-5" data-toggle="tab" data-bs-toggle="tab" data-value="Legend">Legend</a>
#>     </li>
#>     <li>
#>       <a href="#tab-2979-6" data-toggle="tab" data-bs-toggle="tab" data-value="Lines">Lines</a>
#>     </li>
#>   </ul>
#>   <div class="tab-content" data-tabsetid="2979">
#>     <div class="tab-pane active" data-value="Data" id="tab-2979-1">
#>       <div class="vizmodules-input-grid" style="--viz-input-columns: 2;">
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" style="width:100%;" id="tipify758831">
#>             <label class="control-label" id="dittoFreqPlot-var-label" for="dittoFreqPlot-var">Variable</label>
#>             <div id="dittoFreqPlot-var" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="change">
#>               <script type="application/json" data-for="dittoFreqPlot-var">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["clustering","celltype","condition","sample"],"value":["clustering","celltype","condition","sample"]}},"config":{"multiple":false,"search":false,"selectedValue":"clustering","hideClearButton":true,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":false,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":true,"disableOptionGroupCheckbox":true,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify758831', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'String name of a metadata that contains discrete data, or a factor or vector containing such data for all cells/samples in the target `object`.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" style="width:100%;" id="tipify2058289">
#>             <label class="control-label" id="dittoFreqPlot-sample.by-label" for="dittoFreqPlot-sample.by">Sample By</label>
#>             <div id="dittoFreqPlot-sample.by" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="change">
#>               <script type="application/json" data-for="dittoFreqPlot-sample.by">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["(none)","clustering","celltype","condition","sample"],"value":["","clustering","celltype","condition","sample"]}},"config":{"multiple":false,"search":false,"selectedValue":"","hideClearButton":true,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":false,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":true,"disableOptionGroupCheckbox":true,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify2058289', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'String name of a metadata containing which samples each cell belongs to.  Note that when this is not provided, there will only be one data point per grouping. A warning can be expected then for all `plots` options except `"jitter"`, but this can be a useful exercise when simply trying to quantify cell type frequency fluctuations among 2 particular metadata (given to group.by & color.by) combinations.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" style="width:100%;" id="tipify4958896">
#>             <label class="control-label" id="dittoFreqPlot-group.by-label" for="dittoFreqPlot-group.by">Group By</label>
#>             <div id="dittoFreqPlot-group.by" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="change">
#>               <script type="application/json" data-for="dittoFreqPlot-group.by">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["clustering","celltype","condition","sample"],"value":["clustering","celltype","condition","sample"]}},"config":{"multiple":false,"search":false,"selectedValue":"celltype","hideClearButton":true,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":false,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":true,"disableOptionGroupCheckbox":true,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify4958896', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'String representing the name of a metadata to use for separating the cells/samples into discrete groups.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" style="width:100%;" id="tipify2618570">
#>             <label class="control-label" id="dittoFreqPlot-color.by-label" for="dittoFreqPlot-color.by">Color By</label>
#>             <div id="dittoFreqPlot-color.by" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="change">
#>               <script type="application/json" data-for="dittoFreqPlot-color.by">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["(none)","clustering","celltype","condition","sample"],"value":["","clustering","celltype","condition","sample"]}},"config":{"multiple":false,"search":false,"selectedValue":"","hideClearButton":true,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":false,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":true,"disableOptionGroupCheckbox":true,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify2618570', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'String representing the name of a metadata to use for setting fills. Great for highlighting supersets or subgroups when wanted, but it defaults to `group.by` so this input can be skipped otherwise.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" style="width:100%;" id="tipify4159615">
#>             <label class="control-label" id="dittoFreqPlot-scale-label" for="dittoFreqPlot-scale">Scale</label>
#>             <div id="dittoFreqPlot-scale" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="change">
#>               <script type="application/json" data-for="dittoFreqPlot-scale">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["Percent","Count"],"value":["percent","count"]}},"config":{"multiple":false,"search":false,"selectedValue":"percent","hideClearButton":true,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":false,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":true,"disableOptionGroupCheckbox":true,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify4159615', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': '"count" or "percent". Sets whether data should be shown as counts versus percentage.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" style="width:100%;" id="tipify4391500">
#>             <label class="control-label" id="dittoFreqPlot-plots-label" for="dittoFreqPlot-plots">Plots</label>
#>             <div id="dittoFreqPlot-plots" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="close">
#>               <script type="application/json" data-for="dittoFreqPlot-plots">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["Violin","Box","Jitter","Ridge"],"value":["vlnplot","boxplot","jitter","ridgeplot"]}},"config":{"multiple":true,"search":false,"selectedValue":["boxplot","jitter"],"hideClearButton":false,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":true,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":false,"disableOptionGroupCheckbox":false,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify4391500', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'String vector which sets the types of plots to include: possibilities = "jitter", "boxplot", "vlnplot", "ridgeplot".  Order matters: c("vlnplot", "boxplot", "jitter") will put a violin plot in the back, boxplot in the middle, and then individual dots in the front.  See details section for more info.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <span class="help-block">Order not currently respected</span>
#>         </div>
#>       </div>
#>     </div>
#>     <div class="tab-pane" data-value="Aesthetics" id="tab-2979-2">
#>       <div class="vizmodules-input-grid" style="--viz-input-columns: 2;">
#>         <div class="vizmodules-input-cell">
#>           <div id="dittoFreqPlot-palette.selection" class="shiny-html-output"></div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify1823780">
#>             <div class="material-switch">
#>               <label for="dittoFreqPlot-max.normalize" style="padding-right: 10px;">Max Normalize</label>
#>               <input id="dittoFreqPlot-max.normalize" type="checkbox"/>
#>               <label class="switch label-success bg-success" for="dittoFreqPlot-max.normalize"></label>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify1823780', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Logical which sets whether the data for each `var`-data value (each facet) should be normalized to have the same maximum value.  When set to `TRUE`, lower frequency `var`-values will make use of just as much plot space as higher frequency vars.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify783283">
#>             <label class="control-label" id="dittoFreqPlot-jitter.size-label" for="dittoFreqPlot-jitter.size">Jitter Size</label>
#>             <input id="dittoFreqPlot-jitter.size" type="number" class="shiny-input-number form-control" value="1" data-update-on="change" min="0.1" step="0.1"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify783283', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': ''})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify177700">
#>             <label class="control-label" id="dittoFreqPlot-jitter.width-label" for="dittoFreqPlot-jitter.width">Jitter Width</label>
#>             <input id="dittoFreqPlot-jitter.width" type="number" class="shiny-input-number form-control" value="0.2" data-update-on="change" min="0" step="0.05"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify177700', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': ''})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour" id="tipify7281800">
#>             <label class="control-label" for="dittoFreqPlot-jitter.color">Jitter Point Color</label>
#>             <input id="dittoFreqPlot-jitter.color" type="text" class="form-control shiny-colour-input" data-init-value="#000000" data-show-colour="both" data-palette="square"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify7281800', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': ''})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify9708450">
#>             <label class="control-label" id="dittoFreqPlot-boxplot.width-label" for="dittoFreqPlot-boxplot.width">Box Width</label>
#>             <input id="dittoFreqPlot-boxplot.width" type="number" class="shiny-input-number form-control" value="0.4" data-update-on="change" min="0" step="0.05"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify9708450', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': ''})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify5352176">
#>             <label class="control-label" id="dittoFreqPlot-vlnplot.width-label" for="dittoFreqPlot-vlnplot.width">Violin Width</label>
#>             <input id="dittoFreqPlot-vlnplot.width" type="number" class="shiny-input-number form-control" value="1" data-update-on="change" min="0" step="0.05"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify5352176', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': ''})}, 500)});</script>
#>         </div>
#>       </div>
#>     </div>
#>     <div class="tab-pane" data-value="Plotly" id="tab-2979-3">
#>       <div class="vizmodules-input-grid" style="--viz-input-columns: 2;">
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" style="width:100%;">
#>             <label class="control-label" id="dittoFreqPlot-download.format-label" for="dittoFreqPlot-download.format">Download Format</label>
#>             <div id="dittoFreqPlot-download.format" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="change">
#>               <script type="application/json" data-for="dittoFreqPlot-download.format">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["svg","png","jpeg","webp"],"value":["svg","png","jpeg","webp"]}},"config":{"multiple":false,"search":false,"selectedValue":"svg","hideClearButton":true,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":false,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":true,"disableOptionGroupCheckbox":true,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>             </div>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify1664908">
#>             <label class="control-label" id="dittoFreqPlot-margin.t-label" for="dittoFreqPlot-margin.t">Margin Top</label>
#>             <input id="dittoFreqPlot-margin.t" type="number" class="shiny-input-number form-control" value="70" data-update-on="change" min="0" step="5"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify1664908', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Top margin of the plot in pixels'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify581757">
#>             <label class="control-label" id="dittoFreqPlot-margin.b-label" for="dittoFreqPlot-margin.b">Margin Bottom</label>
#>             <input id="dittoFreqPlot-margin.b" type="number" class="shiny-input-number form-control" value="70" data-update-on="change" min="0" step="5"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify581757', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Bottom margin of the plot in pixels'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify4591390">
#>             <label class="control-label" id="dittoFreqPlot-margin.l-label" for="dittoFreqPlot-margin.l">Margin Left</label>
#>             <input id="dittoFreqPlot-margin.l" type="number" class="shiny-input-number form-control" value="70" data-update-on="change" min="0" step="5"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify4591390', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Left margin of the plot in pixels'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify6227988">
#>             <label class="control-label" id="dittoFreqPlot-margin.r-label" for="dittoFreqPlot-margin.r">Margin Right</label>
#>             <input id="dittoFreqPlot-margin.r" type="number" class="shiny-input-number form-control" value="90" data-update-on="change" min="0" step="5"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify6227988', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Right margin of the plot in pixels'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour" id="tipify5948192">
#>             <label class="control-label" for="dittoFreqPlot-shape.fill">Shape Fill</label>
#>             <input id="dittoFreqPlot-shape.fill" type="text" class="form-control shiny-colour-input" data-init-value="rgba(0, 0, 0, 0)" data-show-colour="both" data-palette="square" data-allow-alpha="true"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify5948192', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Interior fill color for shapes drawn on the plot using Plotly&#39;s drawing tools'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour" id="tipify7430182">
#>             <label class="control-label" for="dittoFreqPlot-shape.line.color">Shape Line Color</label>
#>             <input id="dittoFreqPlot-shape.line.color" type="text" class="form-control shiny-colour-input" data-init-value="black" data-show-colour="both" data-palette="square" data-allow-alpha="true"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify7430182', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Outline color for shapes drawn on the plot using Plotly&#39;s drawing tools'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify5242801">
#>             <label class="control-label" id="dittoFreqPlot-shape.line.width-label" for="dittoFreqPlot-shape.line.width">Shape Line Width</label>
#>             <input id="dittoFreqPlot-shape.line.width" type="number" class="shiny-input-number form-control" value="4" data-update-on="change" min="0" step="0.25"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify5242801', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Outline width for shapes drawn on the plot using Plotly&#39;s drawing tools'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" style="width:100%;" id="tipify4968253">
#>             <label class="control-label" id="dittoFreqPlot-shape.linetype-label" for="dittoFreqPlot-shape.linetype">Shape Linetype</label>
#>             <div id="dittoFreqPlot-shape.linetype" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="change">
#>               <script type="application/json" data-for="dittoFreqPlot-shape.linetype">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["solid","dot","dash","longdash","dashdot","longdashdot"],"value":["solid","dot","dash","longdash","dashdot","longdashdot"]}},"config":{"multiple":false,"search":false,"selectedValue":"solid","hideClearButton":true,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":false,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":true,"disableOptionGroupCheckbox":true,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify4968253', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Line dash style for shapes drawn on the plot using Plotly&#39;s drawing tools'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify147189">
#>             <label class="control-label" id="dittoFreqPlot-shape.opacity-label" for="dittoFreqPlot-shape.opacity">Shape Opacity</label>
#>             <input id="dittoFreqPlot-shape.opacity" type="number" class="shiny-input-number form-control" value="1" data-update-on="change" min="0" max="1" step="0.01"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify147189', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Opacity of shapes drawn on the plot, where 0 is fully transparent and 1 is fully opaque'})}, 500)});</script>
#>         </div>
#>       </div>
#>     </div>
#>     <div class="tab-pane" data-value="Axes" id="tab-2979-4">
#>       <div class="vizmodules-input-grid" style="--viz-input-columns: 2;">
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" style="width:100%;">
#>             <label class="control-label" id="dittoFreqPlot-title.font.family-label" for="dittoFreqPlot-title.font.family">Title Font</label>
#>             <div id="dittoFreqPlot-title.font.family" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="change">
#>               <script type="application/json" data-for="dittoFreqPlot-title.font.family">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["Arial","Balto","Courier New","Droid Sans","Droid Serif","Droid Sans Mono","Gravitas One","Old Standard TT","Open Sans","Overpass","PT Sans Narrow","Raleway","Times New Roman","Verdana","sans-serif","serif","monospace"],"value":["Arial","Balto","Courier New","Droid Sans","Droid Serif","Droid Sans Mono","Gravitas One","Old Standard TT","Open Sans","Overpass","PT Sans Narrow","Raleway","Times New Roman","Verdana","sans-serif","serif","monospace"]}},"config":{"multiple":false,"search":true,"selectedValue":"Arial","hideClearButton":true,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":false,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":true,"disableOptionGroupCheckbox":true,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>             </div>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour">
#>             <label class="control-label" for="dittoFreqPlot-title.font.color">Title Color</label>
#>             <input id="dittoFreqPlot-title.font.color" type="text" class="form-control shiny-colour-input" data-init-value="#000000" data-show-colour="both" data-palette="square"/>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="dittoFreqPlot-title.font.size-label" for="dittoFreqPlot-title.font.size">Title Size</label>
#>             <input id="dittoFreqPlot-title.font.size" type="number" class="shiny-input-number form-control" value="26" data-update-on="change" min="1" step="1"/>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="dittoFreqPlot-axis.title.horizontal.position-label" for="dittoFreqPlot-axis.title.horizontal.position">Title position</label>
#>             <input id="dittoFreqPlot-axis.title.horizontal.position" type="number" class="shiny-input-number form-control" value="0.5" data-update-on="change" min="0" max="1" step="0.1"/>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="dittoFreqPlot-axis.title.font.size-label" for="dittoFreqPlot-axis.title.font.size">Axis Title Size</label>
#>             <input id="dittoFreqPlot-axis.title.font.size" type="number" class="shiny-input-number form-control" value="18" data-update-on="change" min="1" step="1"/>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour">
#>             <label class="control-label" for="dittoFreqPlot-axis.title.font.color">Axis Title Color</label>
#>             <input id="dittoFreqPlot-axis.title.font.color" type="text" class="form-control shiny-colour-input" data-init-value="#000000" data-show-colour="both" data-palette="square"/>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" style="width:100%;">
#>             <label class="control-label" id="dittoFreqPlot-axis.title.font.family-label" for="dittoFreqPlot-axis.title.font.family">Axis Title Font</label>
#>             <div id="dittoFreqPlot-axis.title.font.family" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="change">
#>               <script type="application/json" data-for="dittoFreqPlot-axis.title.font.family">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["Arial","Balto","Courier New","Droid Sans","Droid Serif","Droid Sans Mono","Gravitas One","Old Standard TT","Open Sans","Overpass","PT Sans Narrow","Raleway","Times New Roman","Verdana","sans-serif","serif","monospace"],"value":["Arial","Balto","Courier New","Droid Sans","Droid Serif","Droid Sans Mono","Gravitas One","Old Standard TT","Open Sans","Overpass","PT Sans Narrow","Raleway","Times New Roman","Verdana","sans-serif","serif","monospace"]}},"config":{"multiple":false,"search":true,"selectedValue":"Arial","hideClearButton":true,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":false,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":true,"disableOptionGroupCheckbox":true,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>             </div>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container">
#>             <div class="checkbox">
#>               <label>
#>                 <input id="dittoFreqPlot-axis.showline" type="checkbox" class="shiny-input-checkbox" checked="checked"/>
#>                 <span>Show Axis Borders</span>
#>               </label>
#>             </div>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container">
#>             <div class="checkbox">
#>               <label>
#>                 <input id="dittoFreqPlot-axis.mirror" type="checkbox" class="shiny-input-checkbox" checked="checked"/>
#>                 <span>Mirror Axis Borders</span>
#>               </label>
#>             </div>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container">
#>             <div class="checkbox">
#>               <label>
#>                 <input id="dittoFreqPlot-show.grid.x" type="checkbox" class="shiny-input-checkbox" checked="checked"/>
#>                 <span>Show X Gridlines</span>
#>               </label>
#>             </div>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container">
#>             <div class="checkbox">
#>               <label>
#>                 <input id="dittoFreqPlot-show.grid.y" type="checkbox" class="shiny-input-checkbox" checked="checked"/>
#>                 <span>Show Y Gridlines</span>
#>               </label>
#>             </div>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour">
#>             <label class="control-label" for="dittoFreqPlot-grid.color">Gridline Color</label>
#>             <input id="dittoFreqPlot-grid.color" type="text" class="form-control shiny-colour-input" data-init-value="#CCCCCC" data-show-colour="both" data-palette="square"/>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour">
#>             <label class="control-label" for="dittoFreqPlot-axis.linecolor">Axis Line Color</label>
#>             <input id="dittoFreqPlot-axis.linecolor" type="text" class="form-control shiny-colour-input" data-init-value="black" data-show-colour="both" data-palette="square"/>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="dittoFreqPlot-axis.linewidth-label" for="dittoFreqPlot-axis.linewidth">Axis Line Width</label>
#>             <input id="dittoFreqPlot-axis.linewidth" type="number" class="shiny-input-number form-control" value="0.5" data-update-on="change" min="0" step="0.1"/>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="dittoFreqPlot-axis.tickfont.size-label" for="dittoFreqPlot-axis.tickfont.size">Tick Label Size</label>
#>             <input id="dittoFreqPlot-axis.tickfont.size" type="number" class="shiny-input-number form-control" value="12" data-update-on="change" min="1" step="1"/>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour">
#>             <label class="control-label" for="dittoFreqPlot-axis.tickfont.color">Tick Label Color</label>
#>             <input id="dittoFreqPlot-axis.tickfont.color" type="text" class="form-control shiny-colour-input" data-init-value="black" data-show-colour="both" data-palette="square"/>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" style="width:100%;">
#>             <label class="control-label" id="dittoFreqPlot-axis.tickfont.family-label" for="dittoFreqPlot-axis.tickfont.family">Tick Label Font</label>
#>             <div id="dittoFreqPlot-axis.tickfont.family" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="change">
#>               <script type="application/json" data-for="dittoFreqPlot-axis.tickfont.family">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["Arial","Balto","Courier New","Droid Sans","Droid Serif","Droid Sans Mono","Gravitas One","Old Standard TT","Open Sans","Overpass","PT Sans Narrow","Raleway","Times New Roman","Verdana","sans-serif","serif","monospace"],"value":["Arial","Balto","Courier New","Droid Sans","Droid Serif","Droid Sans Mono","Gravitas One","Old Standard TT","Open Sans","Overpass","PT Sans Narrow","Raleway","Times New Roman","Verdana","sans-serif","serif","monospace"]}},"config":{"multiple":false,"search":true,"selectedValue":"Arial","hideClearButton":true,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":false,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":true,"disableOptionGroupCheckbox":true,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>             </div>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="dittoFreqPlot-axis.tickangle.x-label" for="dittoFreqPlot-axis.tickangle.x">X Tick Label Angle</label>
#>             <input id="dittoFreqPlot-axis.tickangle.x" type="number" class="shiny-input-number form-control" value="0" data-update-on="change" min="-180" max="180" step="15"/>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="dittoFreqPlot-axis.tickangle.y-label" for="dittoFreqPlot-axis.tickangle.y">Y Tick Label Angle</label>
#>             <input id="dittoFreqPlot-axis.tickangle.y" type="number" class="shiny-input-number form-control" value="0" data-update-on="change" min="-180" max="180" step="15"/>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" style="width:100%;">
#>             <label class="control-label" id="dittoFreqPlot-axis.ticks-label" for="dittoFreqPlot-axis.ticks">Tick Position</label>
#>             <div id="dittoFreqPlot-axis.ticks" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="change">
#>               <script type="application/json" data-for="dittoFreqPlot-axis.ticks">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["Outside","Inside","(none)"],"value":["outside","inside",""]}},"config":{"multiple":false,"search":false,"selectedValue":"outside","hideClearButton":true,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":false,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":true,"disableOptionGroupCheckbox":true,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>             </div>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour">
#>             <label class="control-label" for="dittoFreqPlot-axis.tickcolor">Tick Mark Color</label>
#>             <input id="dittoFreqPlot-axis.tickcolor" type="text" class="form-control shiny-colour-input" data-init-value="black" data-show-colour="both" data-palette="square"/>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="dittoFreqPlot-axis.ticklen-label" for="dittoFreqPlot-axis.ticklen">Tick Mark Length</label>
#>             <input id="dittoFreqPlot-axis.ticklen" type="number" class="shiny-input-number form-control" value="5" data-update-on="change" min="0" step="1"/>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="dittoFreqPlot-axis.tickwidth-label" for="dittoFreqPlot-axis.tickwidth">Tick Mark Width</label>
#>             <input id="dittoFreqPlot-axis.tickwidth" type="number" class="shiny-input-number form-control" value="1" data-update-on="change" min="0" step="0.1"/>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="dittoFreqPlot-facet.title.font.size-label" for="dittoFreqPlot-facet.title.font.size">Facet Subplot Title Size</label>
#>             <input id="dittoFreqPlot-facet.title.font.size" type="number" class="shiny-input-number form-control" value="18" data-update-on="change" min="1" step="1"/>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour">
#>             <label class="control-label" for="dittoFreqPlot-facet.title.font.color">Facet Title Color</label>
#>             <input id="dittoFreqPlot-facet.title.font.color" type="text" class="form-control shiny-colour-input" data-init-value="#000000" data-show-colour="both" data-palette="square"/>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" style="width:100%;">
#>             <label class="control-label" id="dittoFreqPlot-facet.title.font.family-label" for="dittoFreqPlot-facet.title.font.family">Facet Title Font</label>
#>             <div id="dittoFreqPlot-facet.title.font.family" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="change">
#>               <script type="application/json" data-for="dittoFreqPlot-facet.title.font.family">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["Arial","Balto","Courier New","Droid Sans","Droid Serif","Droid Sans Mono","Gravitas One","Old Standard TT","Open Sans","Overpass","PT Sans Narrow","Raleway","Times New Roman","Verdana","sans-serif","serif","monospace"],"value":["Arial","Balto","Courier New","Droid Sans","Droid Serif","Droid Sans Mono","Gravitas One","Old Standard TT","Open Sans","Overpass","PT Sans Narrow","Raleway","Times New Roman","Verdana","sans-serif","serif","monospace"]}},"config":{"multiple":false,"search":true,"selectedValue":"Arial","hideClearButton":true,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":false,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":true,"disableOptionGroupCheckbox":true,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>             </div>
#>           </div>
#>         </div>
#>       </div>
#>     </div>
#>     <div class="tab-pane" data-value="Legend" id="tab-2979-5">
#>       <div class="vizmodules-input-grid" style="--viz-input-columns: 2;">
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify9579191">
#>             <div class="material-switch">
#>               <label for="dittoFreqPlot-legend.show" style="padding-right: 10px;">Show Legend</label>
#>               <input id="dittoFreqPlot-legend.show" type="checkbox" checked="checked"/>
#>               <label class="switch label-success bg-success" for="dittoFreqPlot-legend.show"></label>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify9579191', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Show the legend. Turning it off also hides colorbars and any point size legend.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" style="width:100%;" id="tipify4530892">
#>             <label class="control-label" id="dittoFreqPlot-legend.font.family-label" for="dittoFreqPlot-legend.font.family">Legend Font</label>
#>             <div id="dittoFreqPlot-legend.font.family" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="change">
#>               <script type="application/json" data-for="dittoFreqPlot-legend.font.family">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["Arial","Balto","Courier New","Droid Sans","Droid Serif","Droid Sans Mono","Gravitas One","Old Standard TT","Open Sans","Overpass","PT Sans Narrow","Raleway","Times New Roman","Verdana","sans-serif","serif","monospace"],"value":["Arial","Balto","Courier New","Droid Sans","Droid Serif","Droid Sans Mono","Gravitas One","Old Standard TT","Open Sans","Overpass","PT Sans Narrow","Raleway","Times New Roman","Verdana","sans-serif","serif","monospace"]}},"config":{"multiple":false,"search":true,"selectedValue":"Arial","hideClearButton":true,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":false,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":true,"disableOptionGroupCheckbox":true,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify4530892', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Font family of the legend title and entry labels.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour" id="tipify9815318">
#>             <label class="control-label" for="dittoFreqPlot-legend.font.color">Legend Font Color</label>
#>             <input id="dittoFreqPlot-legend.font.color" type="text" class="form-control shiny-colour-input" data-init-value="#000000" data-show-colour="both" data-palette="square"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify9815318', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Font color of the legend title and entry labels.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify5447052">
#>             <label class="control-label" id="dittoFreqPlot-legend.title.size-label" for="dittoFreqPlot-legend.title.size">Legend Title Size</label>
#>             <input id="dittoFreqPlot-legend.title.size" type="number" class="shiny-input-number form-control" value="14" data-update-on="change" min="0" step="1"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify5447052', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Font size of the legend title.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify3600424">
#>             <label class="control-label" id="dittoFreqPlot-legend.text.size-label" for="dittoFreqPlot-legend.text.size">Legend Text Size</label>
#>             <input id="dittoFreqPlot-legend.text.size" type="number" class="shiny-input-number form-control" value="12" data-update-on="change" min="0" step="1"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify3600424', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Font size of the legend entry labels.'})}, 500)});</script>
#>         </div>
#>       </div>
#>     </div>
#>     <div class="tab-pane" data-value="Lines" id="tab-2979-6">
#>       <div class="vizmodules-input-grid" style="--viz-input-columns: 2;">
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify5031461">
#>             <label class="control-label" id="dittoFreqPlot-hline.intercepts-label" for="dittoFreqPlot-hline.intercepts">Y-intercepts</label>
#>             <input id="dittoFreqPlot-hline.intercepts" type="text" class="shiny-input-text form-control" value="" placeholder="e.g. 2, -2" data-update-on="change"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify5031461', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'For categorical or factor axes, enter the index (position) of the category rather than its name. For example, if the axis categories are &#39;Audi&#39;, &#39;Mercedes&#39;, &#39;Bugatti&#39;, enter 2 to place a line at &#39;Mercedes&#39;.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify746337">
#>             <label class="control-label" id="dittoFreqPlot-hline.colors-label" for="dittoFreqPlot-hline.colors">Y Colors</label>
#>             <input id="dittoFreqPlot-hline.colors" type="text" class="shiny-input-text form-control" value="#000000" data-update-on="change"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify746337', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Color(s) for horizontal reference lines, as comma-separated hex codes or color names'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify9697918">
#>             <label class="control-label" id="dittoFreqPlot-hline.widths-label" for="dittoFreqPlot-hline.widths">Y Widths</label>
#>             <input id="dittoFreqPlot-hline.widths" type="text" class="shiny-input-text form-control" value="1" data-update-on="change"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify9697918', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Width(s) for horizontal reference lines in pixels, as comma-separated values'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify6485013">
#>             <label class="control-label" id="dittoFreqPlot-hline.linetypes-label" for="dittoFreqPlot-hline.linetypes">Y Line Types</label>
#>             <input id="dittoFreqPlot-hline.linetypes" type="text" class="shiny-input-text form-control" value="dashed" placeholder="solid, dashed, dotted, ..." data-update-on="change"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify6485013', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Line style(s) for horizontal reference lines (solid, dashed, dotted, dotdash, longdash, twodash)'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify9845654">
#>             <label class="control-label" id="dittoFreqPlot-hline.opacities-label" for="dittoFreqPlot-hline.opacities">Y Opacities (0-1)</label>
#>             <input id="dittoFreqPlot-hline.opacities" type="text" class="shiny-input-text form-control" value="1" data-update-on="change"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify9845654', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Opacity of horizontal reference lines between 0 (transparent) and 1 (opaque), as comma-separated values'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify5361333">
#>             <label class="control-label" id="dittoFreqPlot-vline.intercepts-label" for="dittoFreqPlot-vline.intercepts">X-intercepts</label>
#>             <input id="dittoFreqPlot-vline.intercepts" type="text" class="shiny-input-text form-control" value="" placeholder="e.g. 2, -2" data-update-on="change"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify5361333', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'For categorical or factor axes, enter the index (position) of the category rather than its name. For example, if the axis categories are &#39;Audi&#39;, &#39;Mercedes&#39;, &#39;Bugatti&#39;, enter 2 to place a line at &#39;Mercedes&#39;.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify7610594">
#>             <label class="control-label" id="dittoFreqPlot-vline.colors-label" for="dittoFreqPlot-vline.colors">X Colors</label>
#>             <input id="dittoFreqPlot-vline.colors" type="text" class="shiny-input-text form-control" value="#000000" data-update-on="change"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify7610594', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Color(s) for vertical reference lines, as comma-separated hex codes or color names'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify5643857">
#>             <label class="control-label" id="dittoFreqPlot-vline.widths-label" for="dittoFreqPlot-vline.widths">X Widths</label>
#>             <input id="dittoFreqPlot-vline.widths" type="text" class="shiny-input-text form-control" value="1" data-update-on="change"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify5643857', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Width(s) for vertical reference lines in pixels, as comma-separated values'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify7784543">
#>             <label class="control-label" id="dittoFreqPlot-vline.linetypes-label" for="dittoFreqPlot-vline.linetypes">X Line Types</label>
#>             <input id="dittoFreqPlot-vline.linetypes" type="text" class="shiny-input-text form-control" value="dashed" placeholder="solid, dashed, dotted, ..." data-update-on="change"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify7784543', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Line style(s) for vertical reference lines (solid, dashed, dotted, dotdash, longdash, twodash)'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify6390610">
#>             <label class="control-label" id="dittoFreqPlot-vline.opacities-label" for="dittoFreqPlot-vline.opacities">X Opacities (0-1)</label>
#>             <input id="dittoFreqPlot-vline.opacities" type="text" class="shiny-input-text form-control" value="1" data-update-on="change"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify6390610', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Opacity of vertical reference lines between 0 (transparent) and 1 (opaque), as comma-separated values'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify3789607">
#>             <label class="control-label" id="dittoFreqPlot-abline.slopes-label" for="dittoFreqPlot-abline.slopes">Ab Slopes</label>
#>             <input id="dittoFreqPlot-abline.slopes" type="text" class="shiny-input-text form-control" value="" data-update-on="change"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify3789607', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Slope(s) of diagonal reference lines (rise/run), as comma-separated values'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify3595307">
#>             <label class="control-label" id="dittoFreqPlot-abline.intercepts-label" for="dittoFreqPlot-abline.intercepts">Ab Y-intercepts</label>
#>             <input id="dittoFreqPlot-abline.intercepts" type="text" class="shiny-input-text form-control" value="" data-update-on="change"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify3595307', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'For categorical or factor axes, enter the index (position) of the category rather than its name. For example, if the axis categories are &#39;Audi&#39;, &#39;Mercedes&#39;, &#39;Bugatti&#39;, enter 2 to place a line at &#39;Mercedes&#39;.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify8442314">
#>             <label class="control-label" id="dittoFreqPlot-abline.colors-label" for="dittoFreqPlot-abline.colors">Ab Colors</label>
#>             <input id="dittoFreqPlot-abline.colors" type="text" class="shiny-input-text form-control" value="#000000" data-update-on="change"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify8442314', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Color(s) for diagonal reference lines, as comma-separated hex codes or color names'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify4567492">
#>             <label class="control-label" id="dittoFreqPlot-abline.widths-label" for="dittoFreqPlot-abline.widths">Ab Widths</label>
#>             <input id="dittoFreqPlot-abline.widths" type="text" class="shiny-input-text form-control" value="1" data-update-on="change"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify4567492', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Width(s) for diagonal reference lines in pixels, as comma-separated values'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify1790343">
#>             <label class="control-label" id="dittoFreqPlot-abline.linetypes-label" for="dittoFreqPlot-abline.linetypes">Ab Line Types</label>
#>             <input id="dittoFreqPlot-abline.linetypes" type="text" class="shiny-input-text form-control" value="dashed" placeholder="solid, dashed, dotted, ..." data-update-on="change"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify1790343', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Line style(s) for diagonal reference lines (solid, dashed, dotted, dotdash, longdash, twodash)'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify9662091">
#>             <label class="control-label" id="dittoFreqPlot-abline.opacities-label" for="dittoFreqPlot-abline.opacities">Ab Opacities (0-1)</label>
#>             <input id="dittoFreqPlot-abline.opacities" type="text" class="shiny-input-text form-control" value="1" data-update-on="change"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify9662091', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Opacity of diagonal reference lines between 0 (transparent) and 1 (opaque), as comma-separated values'})}, 500)});</script>
#>         </div>
#>       </div>
#>     </div>
#>   </div>
#> </div>
#> <div class="module-tack" style="margin-top: 12px;">
#>   <div class="module-tack-switch" style="margin-bottom: 4px;">
#>     <div class="form-group shiny-input-container">
#>       <div class="material-switch">
#>         <label for="dittoFreqPlot-auto.update" style="padding-right: 10px;">Auto Update</label>
#>         <input id="dittoFreqPlot-auto.update" type="checkbox" checked="checked"/>
#>         <label class="switch label-success bg-success" for="dittoFreqPlot-auto.update"></label>
#>       </div>
#>     </div>
#>   </div>
#>   <div class="module-tack-buttons" style="display: flex; flex-wrap: wrap; gap: 8px;">
#>     <button class="btn btn-default action-button btn-primary" id="dittoFreqPlot-update" style="flex: 1 1 45%;" type="button"><span class="action-label">Update</span></button>
#>     <button class="btn btn-default action-button btn-secondary" id="dittoFreqPlot-reset" style="flex: 1 1 45%;" type="button"><span class="action-label">Reset</span></button>
#>     <a aria-disabled="true" class="btn btn-default shiny-download-link disabled btn-secondary viz-source-download" data-viz-source-ns="dittoFreqPlot-" download href="" id="dittoFreqPlot-download.source" style="flex: 1 1 100%;" tabindex="-1" target="_blank">
#>       <i class="far fa-file-code" role="presentation" aria-label="file-code icon"></i>
#>       Source Download
#>     </a>
#>     <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('dittoFreqPlot-download.source', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Download the plot as a self-contained HTML file and as SVG and PNG images of it as it looks now, along with the plot source data and statistics (if applicable) as CSV files.'})}, 500)});</script>
#>   </div>
#> </div>
```
