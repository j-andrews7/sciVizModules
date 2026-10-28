# Input UI components for the dittoRidgeJitter module

This should be placed in the UI where the inputs should be shown, with
an `id` that matches the `id` used in the
[`dittoRidgeJitterServer()`](https://j-andrews7.github.io/sciVizModules/reference/dittoRidgeJitterServer.md)
and
[`dittoRidgeJitterOutputUI()`](https://j-andrews7.github.io/sciVizModules/reference/dittoRidgeJitterOutputUI.md)
functions.

## Usage

``` r
dittoRidgeJitterInputsUI(
  id,
  data,
  defaults = NULL,
  title = "RidgeJitter Settings",
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
[`dittoSeq::dittoRidgeJitter()`](https://rdrr.io/pkg/dittoSeq/man/dittoPlot.html)
(a convenience wrapper of
[`dittoSeq::dittoPlot()`](https://rdrr.io/pkg/dittoSeq/man/dittoPlot.html)
with `plots = c("ridgeplot", "jitter")`), drawing a ridgeline density
with overlaid jitter points for continuous data (gene expression or
numeric metadata) per discrete group. The resulting `ggplot` is
converted to an interactive `plotly` figure.

## Plot parameters and defaults

The following parameters can be accessed via UI inputs and/or the
`defaults` argument:

- `var` - Continuous variable to plot (gene or numeric metadata)

- `group.by` - Discrete metadata used for the ridge groups

- `color.by` - Discrete metadata used for fill colors (default:
  `group.by`)

- `split.by` - Discrete metadata to facet by (default: none)

- `ridgeplot.scale` - Ridge overlap scale (default: 1.25)

- `ridgeplot.shape` - Ridge shape: "smooth" density or "hist" (default:
  "smooth")

- `ridgeplot.bins` - Number of bins when `ridgeplot.shape` is "hist"
  (default: 30)

- `jitter.size` - Jitter point size (default: 1)

- `jitter.color` - Color of the jitter points (default: "#000000")

- `palette.selection` - Colors for discrete groups (multiColorPicker)

## See also

[`dittoSeq::dittoRidgeJitter()`](https://rdrr.io/pkg/dittoSeq/man/dittoPlot.html),
[`VizModules::organize_inputs()`](https://j-andrews7.github.io/VizModules/reference/organize_inputs.html),
[`dittoRidgeJitterOutputUI()`](https://j-andrews7.github.io/sciVizModules/reference/dittoRidgeJitterOutputUI.md),
[`dittoRidgeJitterServer()`](https://j-andrews7.github.io/sciVizModules/reference/dittoRidgeJitterServer.md),
[`dittoRidgeJitterApp()`](https://j-andrews7.github.io/sciVizModules/reference/dittoRidgeJitterApp.md)

## Author

Jacob Martin, Jared Andrews

## Examples

``` r
library(sciVizModules)
data(example_sce)
dittoRidgeJitterInputsUI("dittoRidgeJitter", example_sce)
#> <h3>RidgeJitter Settings</h3>
#> <div class="tabbable vizmodules-input-tabs">
#>   <ul class="nav nav-tabs shiny-tab-input" id="dittoRidgeJitter-dittoRidgeJitterTabsetPanel" data-tabsetid="1992">
#>     <li class="active">
#>       <a href="#tab-1992-1" data-toggle="tab" data-bs-toggle="tab" data-value="Data">Data</a>
#>     </li>
#>     <li>
#>       <a href="#tab-1992-2" data-toggle="tab" data-bs-toggle="tab" data-value="Aesthetics">Aesthetics</a>
#>     </li>
#>     <li>
#>       <a href="#tab-1992-3" data-toggle="tab" data-bs-toggle="tab" data-value="Plotly">Plotly</a>
#>     </li>
#>     <li>
#>       <a href="#tab-1992-4" data-toggle="tab" data-bs-toggle="tab" data-value="Axes">Axes</a>
#>     </li>
#>     <li>
#>       <a href="#tab-1992-5" data-toggle="tab" data-bs-toggle="tab" data-value="Legend">Legend</a>
#>     </li>
#>     <li>
#>       <a href="#tab-1992-6" data-toggle="tab" data-bs-toggle="tab" data-value="Lines">Lines</a>
#>     </li>
#>   </ul>
#>   <div class="tab-content" data-tabsetid="1992">
#>     <div class="tab-pane active" data-value="Data" id="tab-1992-1">
#>       <div class="vizmodules-input-grid" style="--viz-input-columns: 2;">
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" style="width:100%;" id="tipify6406805">
#>             <label class="control-label" id="dittoRidgeJitter-var-label" for="dittoRidgeJitter-var">Variable (gene / metadata)</label>
#>             <div id="dittoRidgeJitter-var" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="change">
#>               <script type="application/json" data-for="dittoRidgeJitter-var">{"stateInput":false,"options":{"type":["transpose_group"],"choices":[{"label":["Metadata"],"options":{"label":["nCount","percent.mito"],"value":["nCount","percent.mito"]}},{"label":["Genes"],"options":{"label":["Gene1","Gene2","Gene3","Gene4","Gene5","Gene6","Gene7","Gene8","Gene9","Gene10","Gene11","Gene12","Gene13","Gene14","Gene15","Gene16","Gene17","Gene18","Gene19","Gene20","Gene21","Gene22","Gene23","Gene24","Gene25","Gene26","Gene27","Gene28","Gene29","Gene30","Gene31","Gene32","Gene33","Gene34","Gene35","Gene36","Gene37","Gene38","Gene39","Gene40"],"value":["Gene1","Gene2","Gene3","Gene4","Gene5","Gene6","Gene7","Gene8","Gene9","Gene10","Gene11","Gene12","Gene13","Gene14","Gene15","Gene16","Gene17","Gene18","Gene19","Gene20","Gene21","Gene22","Gene23","Gene24","Gene25","Gene26","Gene27","Gene28","Gene29","Gene30","Gene31","Gene32","Gene33","Gene34","Gene35","Gene36","Gene37","Gene38","Gene39","Gene40"]}}]},"config":{"multiple":false,"search":true,"selectedValue":"nCount","hideClearButton":true,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":false,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":true,"disableOptionGroupCheckbox":true,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify6406805', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': ''})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" style="width:100%;" id="tipify2012385">
#>             <label class="control-label" id="dittoRidgeJitter-group.by-label" for="dittoRidgeJitter-group.by">Group By</label>
#>             <div id="dittoRidgeJitter-group.by" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="change">
#>               <script type="application/json" data-for="dittoRidgeJitter-group.by">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["clustering","celltype","condition","sample"],"value":["clustering","celltype","condition","sample"]}},"config":{"multiple":false,"search":false,"selectedValue":"clustering","hideClearButton":true,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":false,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":true,"disableOptionGroupCheckbox":true,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify2012385', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': ''})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" style="width:100%;" id="tipify7436213">
#>             <label class="control-label" id="dittoRidgeJitter-color.by-label" for="dittoRidgeJitter-color.by">Color By</label>
#>             <div id="dittoRidgeJitter-color.by" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="change">
#>               <script type="application/json" data-for="dittoRidgeJitter-color.by">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["(none)","clustering","celltype","condition","sample"],"value":["","clustering","celltype","condition","sample"]}},"config":{"multiple":false,"search":false,"selectedValue":"","hideClearButton":true,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":false,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":true,"disableOptionGroupCheckbox":true,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify7436213', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': ''})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" style="width:100%;" id="tipify8476374">
#>             <label class="control-label" id="dittoRidgeJitter-split.by-label" for="dittoRidgeJitter-split.by">Split By (facet)</label>
#>             <div id="dittoRidgeJitter-split.by" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="change">
#>               <script type="application/json" data-for="dittoRidgeJitter-split.by">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["(none)","clustering","celltype","condition","sample"],"value":["","clustering","celltype","condition","sample"]}},"config":{"multiple":false,"search":false,"selectedValue":"","hideClearButton":true,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":false,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":true,"disableOptionGroupCheckbox":true,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify8476374', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': ''})}, 500)});</script>
#>         </div>
#>       </div>
#>     </div>
#>     <div class="tab-pane" data-value="Aesthetics" id="tab-1992-2">
#>       <div class="vizmodules-input-grid" style="--viz-input-columns: 2;">
#>         <div class="vizmodules-input-cell">
#>           <div id="dittoRidgeJitter-palette.selection" class="shiny-html-output"></div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify8536358">
#>             <label class="control-label" id="dittoRidgeJitter-ridgeplot.scale-label" for="dittoRidgeJitter-ridgeplot.scale">Ridge Scale (overlap)</label>
#>             <input id="dittoRidgeJitter-ridgeplot.scale" type="number" class="shiny-input-number form-control" value="1.25" data-update-on="change" min="0.1" step="0.05"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify8536358', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': ''})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify8034125">
#>             <label class="control-label" id="dittoRidgeJitter-ridgeplot.lineweight-label" for="dittoRidgeJitter-ridgeplot.lineweight">Ridge Line Weight</label>
#>             <input id="dittoRidgeJitter-ridgeplot.lineweight" type="number" class="shiny-input-number form-control" value="1" data-update-on="change" min="0" step="0.1"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify8034125', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': ''})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" style="width:100%;" id="tipify238768">
#>             <label class="control-label" id="dittoRidgeJitter-ridgeplot.shape-label" for="dittoRidgeJitter-ridgeplot.shape">Ridge Shape</label>
#>             <div id="dittoRidgeJitter-ridgeplot.shape" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="change">
#>               <script type="application/json" data-for="dittoRidgeJitter-ridgeplot.shape">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["Smooth","Histogram"],"value":["smooth","hist"]}},"config":{"multiple":false,"search":false,"selectedValue":"smooth","hideClearButton":true,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":false,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":true,"disableOptionGroupCheckbox":true,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify238768', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': ''})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify7953777">
#>             <label class="control-label" id="dittoRidgeJitter-ridgeplot.bins-label" for="dittoRidgeJitter-ridgeplot.bins">Ridge Bins</label>
#>             <input id="dittoRidgeJitter-ridgeplot.bins" type="number" class="shiny-input-number form-control" value="30" data-update-on="change" min="2" step="1"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify7953777', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': ''})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify8865505">
#>             <label class="control-label" id="dittoRidgeJitter-jitter.size-label" for="dittoRidgeJitter-jitter.size">Jitter Size</label>
#>             <input id="dittoRidgeJitter-jitter.size" type="number" class="shiny-input-number form-control" value="1" data-update-on="change" min="0.1" step="0.1"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify8865505', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': ''})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify6000373">
#>             <label class="control-label" id="dittoRidgeJitter-jitter.width-label" for="dittoRidgeJitter-jitter.width">Jitter Width</label>
#>             <input id="dittoRidgeJitter-jitter.width" type="number" class="shiny-input-number form-control" value="0.2" data-update-on="change" min="0" step="0.05"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify6000373', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': ''})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour" id="tipify4327882">
#>             <label class="control-label" for="dittoRidgeJitter-jitter.color">Jitter Point Color</label>
#>             <input id="dittoRidgeJitter-jitter.color" type="text" class="form-control shiny-colour-input" data-init-value="#000000" data-show-colour="both" data-palette="square"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify4327882', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': ''})}, 500)});</script>
#>         </div>
#>       </div>
#>     </div>
#>     <div class="tab-pane" data-value="Plotly" id="tab-1992-3">
#>       <div class="vizmodules-input-grid" style="--viz-input-columns: 2;">
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" style="width:100%;">
#>             <label class="control-label" id="dittoRidgeJitter-download.format-label" for="dittoRidgeJitter-download.format">Download Format</label>
#>             <div id="dittoRidgeJitter-download.format" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="change">
#>               <script type="application/json" data-for="dittoRidgeJitter-download.format">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["svg","png","jpeg","webp"],"value":["svg","png","jpeg","webp"]}},"config":{"multiple":false,"search":false,"selectedValue":"svg","hideClearButton":true,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":false,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":true,"disableOptionGroupCheckbox":true,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>             </div>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify9202758">
#>             <label class="control-label" id="dittoRidgeJitter-margin.t-label" for="dittoRidgeJitter-margin.t">Margin Top</label>
#>             <input id="dittoRidgeJitter-margin.t" type="number" class="shiny-input-number form-control" value="70" data-update-on="change" min="0" step="5"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify9202758', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Top margin of the plot in pixels'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify6160144">
#>             <label class="control-label" id="dittoRidgeJitter-margin.b-label" for="dittoRidgeJitter-margin.b">Margin Bottom</label>
#>             <input id="dittoRidgeJitter-margin.b" type="number" class="shiny-input-number form-control" value="70" data-update-on="change" min="0" step="5"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify6160144', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Bottom margin of the plot in pixels'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify4357182">
#>             <label class="control-label" id="dittoRidgeJitter-margin.l-label" for="dittoRidgeJitter-margin.l">Margin Left</label>
#>             <input id="dittoRidgeJitter-margin.l" type="number" class="shiny-input-number form-control" value="70" data-update-on="change" min="0" step="5"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify4357182', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Left margin of the plot in pixels'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify8973044">
#>             <label class="control-label" id="dittoRidgeJitter-margin.r-label" for="dittoRidgeJitter-margin.r">Margin Right</label>
#>             <input id="dittoRidgeJitter-margin.r" type="number" class="shiny-input-number form-control" value="90" data-update-on="change" min="0" step="5"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify8973044', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Right margin of the plot in pixels'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour" id="tipify7690135">
#>             <label class="control-label" for="dittoRidgeJitter-shape.fill">Shape Fill</label>
#>             <input id="dittoRidgeJitter-shape.fill" type="text" class="form-control shiny-colour-input" data-init-value="rgba(0, 0, 0, 0)" data-show-colour="both" data-palette="square" data-allow-alpha="true"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify7690135', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Interior fill color for shapes drawn on the plot using Plotly&#39;s drawing tools'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour" id="tipify1281158">
#>             <label class="control-label" for="dittoRidgeJitter-shape.line.color">Shape Line Color</label>
#>             <input id="dittoRidgeJitter-shape.line.color" type="text" class="form-control shiny-colour-input" data-init-value="black" data-show-colour="both" data-palette="square" data-allow-alpha="true"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify1281158', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Outline color for shapes drawn on the plot using Plotly&#39;s drawing tools'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify5386331">
#>             <label class="control-label" id="dittoRidgeJitter-shape.line.width-label" for="dittoRidgeJitter-shape.line.width">Shape Line Width</label>
#>             <input id="dittoRidgeJitter-shape.line.width" type="number" class="shiny-input-number form-control" value="4" data-update-on="change" min="0" step="0.25"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify5386331', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Outline width for shapes drawn on the plot using Plotly&#39;s drawing tools'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" style="width:100%;" id="tipify1290163">
#>             <label class="control-label" id="dittoRidgeJitter-shape.linetype-label" for="dittoRidgeJitter-shape.linetype">Shape Linetype</label>
#>             <div id="dittoRidgeJitter-shape.linetype" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="change">
#>               <script type="application/json" data-for="dittoRidgeJitter-shape.linetype">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["solid","dot","dash","longdash","dashdot","longdashdot"],"value":["solid","dot","dash","longdash","dashdot","longdashdot"]}},"config":{"multiple":false,"search":false,"selectedValue":"solid","hideClearButton":true,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":false,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":true,"disableOptionGroupCheckbox":true,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify1290163', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Line dash style for shapes drawn on the plot using Plotly&#39;s drawing tools'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify5109649">
#>             <label class="control-label" id="dittoRidgeJitter-shape.opacity-label" for="dittoRidgeJitter-shape.opacity">Shape Opacity</label>
#>             <input id="dittoRidgeJitter-shape.opacity" type="number" class="shiny-input-number form-control" value="1" data-update-on="change" min="0" max="1" step="0.01"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify5109649', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Opacity of shapes drawn on the plot, where 0 is fully transparent and 1 is fully opaque'})}, 500)});</script>
#>         </div>
#>       </div>
#>     </div>
#>     <div class="tab-pane" data-value="Axes" id="tab-1992-4">
#>       <div class="vizmodules-input-grid" style="--viz-input-columns: 2;">
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" style="width:100%;">
#>             <label class="control-label" id="dittoRidgeJitter-title.font.family-label" for="dittoRidgeJitter-title.font.family">Title Font</label>
#>             <div id="dittoRidgeJitter-title.font.family" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="change">
#>               <script type="application/json" data-for="dittoRidgeJitter-title.font.family">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["Arial","Balto","Courier New","Droid Sans","Droid Serif","Droid Sans Mono","Gravitas One","Old Standard TT","Open Sans","Overpass","PT Sans Narrow","Raleway","Times New Roman","Verdana","sans-serif","serif","monospace"],"value":["Arial","Balto","Courier New","Droid Sans","Droid Serif","Droid Sans Mono","Gravitas One","Old Standard TT","Open Sans","Overpass","PT Sans Narrow","Raleway","Times New Roman","Verdana","sans-serif","serif","monospace"]}},"config":{"multiple":false,"search":true,"selectedValue":"Arial","hideClearButton":true,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":false,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":true,"disableOptionGroupCheckbox":true,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>             </div>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour">
#>             <label class="control-label" for="dittoRidgeJitter-title.font.color">Title Color</label>
#>             <input id="dittoRidgeJitter-title.font.color" type="text" class="form-control shiny-colour-input" data-init-value="#000000" data-show-colour="both" data-palette="square"/>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="dittoRidgeJitter-title.font.size-label" for="dittoRidgeJitter-title.font.size">Title Size</label>
#>             <input id="dittoRidgeJitter-title.font.size" type="number" class="shiny-input-number form-control" value="26" data-update-on="change" min="1" step="1"/>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="dittoRidgeJitter-axis.title.horizontal.position-label" for="dittoRidgeJitter-axis.title.horizontal.position">Title position</label>
#>             <input id="dittoRidgeJitter-axis.title.horizontal.position" type="number" class="shiny-input-number form-control" value="0.5" data-update-on="change" min="0" max="1" step="0.1"/>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="dittoRidgeJitter-axis.title.font.size-label" for="dittoRidgeJitter-axis.title.font.size">Axis Title Size</label>
#>             <input id="dittoRidgeJitter-axis.title.font.size" type="number" class="shiny-input-number form-control" value="18" data-update-on="change" min="1" step="1"/>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour">
#>             <label class="control-label" for="dittoRidgeJitter-axis.title.font.color">Axis Title Color</label>
#>             <input id="dittoRidgeJitter-axis.title.font.color" type="text" class="form-control shiny-colour-input" data-init-value="#000000" data-show-colour="both" data-palette="square"/>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" style="width:100%;">
#>             <label class="control-label" id="dittoRidgeJitter-axis.title.font.family-label" for="dittoRidgeJitter-axis.title.font.family">Axis Title Font</label>
#>             <div id="dittoRidgeJitter-axis.title.font.family" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="change">
#>               <script type="application/json" data-for="dittoRidgeJitter-axis.title.font.family">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["Arial","Balto","Courier New","Droid Sans","Droid Serif","Droid Sans Mono","Gravitas One","Old Standard TT","Open Sans","Overpass","PT Sans Narrow","Raleway","Times New Roman","Verdana","sans-serif","serif","monospace"],"value":["Arial","Balto","Courier New","Droid Sans","Droid Serif","Droid Sans Mono","Gravitas One","Old Standard TT","Open Sans","Overpass","PT Sans Narrow","Raleway","Times New Roman","Verdana","sans-serif","serif","monospace"]}},"config":{"multiple":false,"search":true,"selectedValue":"Arial","hideClearButton":true,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":false,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":true,"disableOptionGroupCheckbox":true,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>             </div>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container">
#>             <div class="checkbox">
#>               <label>
#>                 <input id="dittoRidgeJitter-axis.showline" type="checkbox" class="shiny-input-checkbox" checked="checked"/>
#>                 <span>Show Axis Borders</span>
#>               </label>
#>             </div>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container">
#>             <div class="checkbox">
#>               <label>
#>                 <input id="dittoRidgeJitter-axis.mirror" type="checkbox" class="shiny-input-checkbox" checked="checked"/>
#>                 <span>Mirror Axis Borders</span>
#>               </label>
#>             </div>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container">
#>             <div class="checkbox">
#>               <label>
#>                 <input id="dittoRidgeJitter-show.grid.x" type="checkbox" class="shiny-input-checkbox" checked="checked"/>
#>                 <span>Show X Gridlines</span>
#>               </label>
#>             </div>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container">
#>             <div class="checkbox">
#>               <label>
#>                 <input id="dittoRidgeJitter-show.grid.y" type="checkbox" class="shiny-input-checkbox" checked="checked"/>
#>                 <span>Show Y Gridlines</span>
#>               </label>
#>             </div>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour">
#>             <label class="control-label" for="dittoRidgeJitter-grid.color">Gridline Color</label>
#>             <input id="dittoRidgeJitter-grid.color" type="text" class="form-control shiny-colour-input" data-init-value="#CCCCCC" data-show-colour="both" data-palette="square"/>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour">
#>             <label class="control-label" for="dittoRidgeJitter-axis.linecolor">Axis Line Color</label>
#>             <input id="dittoRidgeJitter-axis.linecolor" type="text" class="form-control shiny-colour-input" data-init-value="black" data-show-colour="both" data-palette="square"/>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="dittoRidgeJitter-axis.linewidth-label" for="dittoRidgeJitter-axis.linewidth">Axis Line Width</label>
#>             <input id="dittoRidgeJitter-axis.linewidth" type="number" class="shiny-input-number form-control" value="0.5" data-update-on="change" min="0" step="0.1"/>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="dittoRidgeJitter-axis.tickfont.size-label" for="dittoRidgeJitter-axis.tickfont.size">Tick Label Size</label>
#>             <input id="dittoRidgeJitter-axis.tickfont.size" type="number" class="shiny-input-number form-control" value="12" data-update-on="change" min="1" step="1"/>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour">
#>             <label class="control-label" for="dittoRidgeJitter-axis.tickfont.color">Tick Label Color</label>
#>             <input id="dittoRidgeJitter-axis.tickfont.color" type="text" class="form-control shiny-colour-input" data-init-value="black" data-show-colour="both" data-palette="square"/>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" style="width:100%;">
#>             <label class="control-label" id="dittoRidgeJitter-axis.tickfont.family-label" for="dittoRidgeJitter-axis.tickfont.family">Tick Label Font</label>
#>             <div id="dittoRidgeJitter-axis.tickfont.family" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="change">
#>               <script type="application/json" data-for="dittoRidgeJitter-axis.tickfont.family">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["Arial","Balto","Courier New","Droid Sans","Droid Serif","Droid Sans Mono","Gravitas One","Old Standard TT","Open Sans","Overpass","PT Sans Narrow","Raleway","Times New Roman","Verdana","sans-serif","serif","monospace"],"value":["Arial","Balto","Courier New","Droid Sans","Droid Serif","Droid Sans Mono","Gravitas One","Old Standard TT","Open Sans","Overpass","PT Sans Narrow","Raleway","Times New Roman","Verdana","sans-serif","serif","monospace"]}},"config":{"multiple":false,"search":true,"selectedValue":"Arial","hideClearButton":true,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":false,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":true,"disableOptionGroupCheckbox":true,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>             </div>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="dittoRidgeJitter-axis.tickangle.x-label" for="dittoRidgeJitter-axis.tickangle.x">X Tick Label Angle</label>
#>             <input id="dittoRidgeJitter-axis.tickangle.x" type="number" class="shiny-input-number form-control" value="0" data-update-on="change" min="-180" max="180" step="15"/>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="dittoRidgeJitter-axis.tickangle.y-label" for="dittoRidgeJitter-axis.tickangle.y">Y Tick Label Angle</label>
#>             <input id="dittoRidgeJitter-axis.tickangle.y" type="number" class="shiny-input-number form-control" value="0" data-update-on="change" min="-180" max="180" step="15"/>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" style="width:100%;">
#>             <label class="control-label" id="dittoRidgeJitter-axis.ticks-label" for="dittoRidgeJitter-axis.ticks">Tick Position</label>
#>             <div id="dittoRidgeJitter-axis.ticks" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="change">
#>               <script type="application/json" data-for="dittoRidgeJitter-axis.ticks">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["Outside","Inside","(none)"],"value":["outside","inside",""]}},"config":{"multiple":false,"search":false,"selectedValue":"outside","hideClearButton":true,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":false,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":true,"disableOptionGroupCheckbox":true,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>             </div>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour">
#>             <label class="control-label" for="dittoRidgeJitter-axis.tickcolor">Tick Mark Color</label>
#>             <input id="dittoRidgeJitter-axis.tickcolor" type="text" class="form-control shiny-colour-input" data-init-value="black" data-show-colour="both" data-palette="square"/>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="dittoRidgeJitter-axis.ticklen-label" for="dittoRidgeJitter-axis.ticklen">Tick Mark Length</label>
#>             <input id="dittoRidgeJitter-axis.ticklen" type="number" class="shiny-input-number form-control" value="5" data-update-on="change" min="0" step="1"/>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="dittoRidgeJitter-axis.tickwidth-label" for="dittoRidgeJitter-axis.tickwidth">Tick Mark Width</label>
#>             <input id="dittoRidgeJitter-axis.tickwidth" type="number" class="shiny-input-number form-control" value="1" data-update-on="change" min="0" step="0.1"/>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="dittoRidgeJitter-facet.title.font.size-label" for="dittoRidgeJitter-facet.title.font.size">Facet Subplot Title Size</label>
#>             <input id="dittoRidgeJitter-facet.title.font.size" type="number" class="shiny-input-number form-control" value="18" data-update-on="change" min="1" step="1"/>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour">
#>             <label class="control-label" for="dittoRidgeJitter-facet.title.font.color">Facet Title Color</label>
#>             <input id="dittoRidgeJitter-facet.title.font.color" type="text" class="form-control shiny-colour-input" data-init-value="#000000" data-show-colour="both" data-palette="square"/>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" style="width:100%;">
#>             <label class="control-label" id="dittoRidgeJitter-facet.title.font.family-label" for="dittoRidgeJitter-facet.title.font.family">Facet Title Font</label>
#>             <div id="dittoRidgeJitter-facet.title.font.family" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="change">
#>               <script type="application/json" data-for="dittoRidgeJitter-facet.title.font.family">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["Arial","Balto","Courier New","Droid Sans","Droid Serif","Droid Sans Mono","Gravitas One","Old Standard TT","Open Sans","Overpass","PT Sans Narrow","Raleway","Times New Roman","Verdana","sans-serif","serif","monospace"],"value":["Arial","Balto","Courier New","Droid Sans","Droid Serif","Droid Sans Mono","Gravitas One","Old Standard TT","Open Sans","Overpass","PT Sans Narrow","Raleway","Times New Roman","Verdana","sans-serif","serif","monospace"]}},"config":{"multiple":false,"search":true,"selectedValue":"Arial","hideClearButton":true,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":false,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":true,"disableOptionGroupCheckbox":true,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>             </div>
#>           </div>
#>         </div>
#>       </div>
#>     </div>
#>     <div class="tab-pane" data-value="Legend" id="tab-1992-5">
#>       <div class="vizmodules-input-grid" style="--viz-input-columns: 2;">
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify5437927">
#>             <div class="material-switch">
#>               <label for="dittoRidgeJitter-legend.show" style="padding-right: 10px;">Show Legend</label>
#>               <input id="dittoRidgeJitter-legend.show" type="checkbox" checked="checked"/>
#>               <label class="switch label-success bg-success" for="dittoRidgeJitter-legend.show"></label>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify5437927', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Show the legend. Turning it off also hides colorbars and any point size legend.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" style="width:100%;" id="tipify2417761">
#>             <label class="control-label" id="dittoRidgeJitter-legend.font.family-label" for="dittoRidgeJitter-legend.font.family">Legend Font</label>
#>             <div id="dittoRidgeJitter-legend.font.family" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="change">
#>               <script type="application/json" data-for="dittoRidgeJitter-legend.font.family">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["Arial","Balto","Courier New","Droid Sans","Droid Serif","Droid Sans Mono","Gravitas One","Old Standard TT","Open Sans","Overpass","PT Sans Narrow","Raleway","Times New Roman","Verdana","sans-serif","serif","monospace"],"value":["Arial","Balto","Courier New","Droid Sans","Droid Serif","Droid Sans Mono","Gravitas One","Old Standard TT","Open Sans","Overpass","PT Sans Narrow","Raleway","Times New Roman","Verdana","sans-serif","serif","monospace"]}},"config":{"multiple":false,"search":true,"selectedValue":"Arial","hideClearButton":true,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":false,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":true,"disableOptionGroupCheckbox":true,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify2417761', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Font family of the legend title and entry labels.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour" id="tipify8031441">
#>             <label class="control-label" for="dittoRidgeJitter-legend.font.color">Legend Font Color</label>
#>             <input id="dittoRidgeJitter-legend.font.color" type="text" class="form-control shiny-colour-input" data-init-value="#000000" data-show-colour="both" data-palette="square"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify8031441', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Font color of the legend title and entry labels.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify9479137">
#>             <label class="control-label" id="dittoRidgeJitter-legend.title.size-label" for="dittoRidgeJitter-legend.title.size">Legend Title Size</label>
#>             <input id="dittoRidgeJitter-legend.title.size" type="number" class="shiny-input-number form-control" value="14" data-update-on="change" min="0" step="1"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify9479137', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Font size of the legend title.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify4073614">
#>             <label class="control-label" id="dittoRidgeJitter-legend.text.size-label" for="dittoRidgeJitter-legend.text.size">Legend Text Size</label>
#>             <input id="dittoRidgeJitter-legend.text.size" type="number" class="shiny-input-number form-control" value="12" data-update-on="change" min="0" step="1"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify4073614', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Font size of the legend entry labels.'})}, 500)});</script>
#>         </div>
#>       </div>
#>     </div>
#>     <div class="tab-pane" data-value="Lines" id="tab-1992-6">
#>       <div class="vizmodules-input-grid" style="--viz-input-columns: 2;">
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify5147446">
#>             <label class="control-label" id="dittoRidgeJitter-hline.intercepts-label" for="dittoRidgeJitter-hline.intercepts">Y-intercepts</label>
#>             <input id="dittoRidgeJitter-hline.intercepts" type="text" class="shiny-input-text form-control" value="" placeholder="e.g. 2, -2" data-update-on="change"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify5147446', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'For categorical or factor axes, enter the index (position) of the category rather than its name. For example, if the axis categories are &#39;Audi&#39;, &#39;Mercedes&#39;, &#39;Bugatti&#39;, enter 2 to place a line at &#39;Mercedes&#39;.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify9815418">
#>             <label class="control-label" id="dittoRidgeJitter-hline.colors-label" for="dittoRidgeJitter-hline.colors">Y Colors</label>
#>             <input id="dittoRidgeJitter-hline.colors" type="text" class="shiny-input-text form-control" value="#000000" data-update-on="change"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify9815418', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Color(s) for horizontal reference lines, as comma-separated hex codes or color names'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify3541867">
#>             <label class="control-label" id="dittoRidgeJitter-hline.widths-label" for="dittoRidgeJitter-hline.widths">Y Widths</label>
#>             <input id="dittoRidgeJitter-hline.widths" type="text" class="shiny-input-text form-control" value="1" data-update-on="change"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify3541867', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Width(s) for horizontal reference lines in pixels, as comma-separated values'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify4558402">
#>             <label class="control-label" id="dittoRidgeJitter-hline.linetypes-label" for="dittoRidgeJitter-hline.linetypes">Y Line Types</label>
#>             <input id="dittoRidgeJitter-hline.linetypes" type="text" class="shiny-input-text form-control" value="dashed" placeholder="solid, dashed, dotted, ..." data-update-on="change"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify4558402', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Line style(s) for horizontal reference lines (solid, dashed, dotted, dotdash, longdash, twodash)'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify2200247">
#>             <label class="control-label" id="dittoRidgeJitter-hline.opacities-label" for="dittoRidgeJitter-hline.opacities">Y Opacities (0-1)</label>
#>             <input id="dittoRidgeJitter-hline.opacities" type="text" class="shiny-input-text form-control" value="1" data-update-on="change"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify2200247', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Opacity of horizontal reference lines between 0 (transparent) and 1 (opaque), as comma-separated values'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify818331">
#>             <label class="control-label" id="dittoRidgeJitter-vline.intercepts-label" for="dittoRidgeJitter-vline.intercepts">X-intercepts</label>
#>             <input id="dittoRidgeJitter-vline.intercepts" type="text" class="shiny-input-text form-control" value="" placeholder="e.g. 2, -2" data-update-on="change"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify818331', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'For categorical or factor axes, enter the index (position) of the category rather than its name. For example, if the axis categories are &#39;Audi&#39;, &#39;Mercedes&#39;, &#39;Bugatti&#39;, enter 2 to place a line at &#39;Mercedes&#39;.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify3692361">
#>             <label class="control-label" id="dittoRidgeJitter-vline.colors-label" for="dittoRidgeJitter-vline.colors">X Colors</label>
#>             <input id="dittoRidgeJitter-vline.colors" type="text" class="shiny-input-text form-control" value="#000000" data-update-on="change"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify3692361', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Color(s) for vertical reference lines, as comma-separated hex codes or color names'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify1266666">
#>             <label class="control-label" id="dittoRidgeJitter-vline.widths-label" for="dittoRidgeJitter-vline.widths">X Widths</label>
#>             <input id="dittoRidgeJitter-vline.widths" type="text" class="shiny-input-text form-control" value="1" data-update-on="change"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify1266666', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Width(s) for vertical reference lines in pixels, as comma-separated values'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify7398725">
#>             <label class="control-label" id="dittoRidgeJitter-vline.linetypes-label" for="dittoRidgeJitter-vline.linetypes">X Line Types</label>
#>             <input id="dittoRidgeJitter-vline.linetypes" type="text" class="shiny-input-text form-control" value="dashed" placeholder="solid, dashed, dotted, ..." data-update-on="change"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify7398725', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Line style(s) for vertical reference lines (solid, dashed, dotted, dotdash, longdash, twodash)'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify9558662">
#>             <label class="control-label" id="dittoRidgeJitter-vline.opacities-label" for="dittoRidgeJitter-vline.opacities">X Opacities (0-1)</label>
#>             <input id="dittoRidgeJitter-vline.opacities" type="text" class="shiny-input-text form-control" value="1" data-update-on="change"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify9558662', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Opacity of vertical reference lines between 0 (transparent) and 1 (opaque), as comma-separated values'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify6686745">
#>             <label class="control-label" id="dittoRidgeJitter-abline.slopes-label" for="dittoRidgeJitter-abline.slopes">Ab Slopes</label>
#>             <input id="dittoRidgeJitter-abline.slopes" type="text" class="shiny-input-text form-control" value="" data-update-on="change"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify6686745', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Slope(s) of diagonal reference lines (rise/run), as comma-separated values'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify4680894">
#>             <label class="control-label" id="dittoRidgeJitter-abline.intercepts-label" for="dittoRidgeJitter-abline.intercepts">Ab Y-intercepts</label>
#>             <input id="dittoRidgeJitter-abline.intercepts" type="text" class="shiny-input-text form-control" value="" data-update-on="change"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify4680894', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'For categorical or factor axes, enter the index (position) of the category rather than its name. For example, if the axis categories are &#39;Audi&#39;, &#39;Mercedes&#39;, &#39;Bugatti&#39;, enter 2 to place a line at &#39;Mercedes&#39;.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify5381924">
#>             <label class="control-label" id="dittoRidgeJitter-abline.colors-label" for="dittoRidgeJitter-abline.colors">Ab Colors</label>
#>             <input id="dittoRidgeJitter-abline.colors" type="text" class="shiny-input-text form-control" value="#000000" data-update-on="change"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify5381924', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Color(s) for diagonal reference lines, as comma-separated hex codes or color names'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify3309537">
#>             <label class="control-label" id="dittoRidgeJitter-abline.widths-label" for="dittoRidgeJitter-abline.widths">Ab Widths</label>
#>             <input id="dittoRidgeJitter-abline.widths" type="text" class="shiny-input-text form-control" value="1" data-update-on="change"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify3309537', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Width(s) for diagonal reference lines in pixels, as comma-separated values'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify6286821">
#>             <label class="control-label" id="dittoRidgeJitter-abline.linetypes-label" for="dittoRidgeJitter-abline.linetypes">Ab Line Types</label>
#>             <input id="dittoRidgeJitter-abline.linetypes" type="text" class="shiny-input-text form-control" value="dashed" placeholder="solid, dashed, dotted, ..." data-update-on="change"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify6286821', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Line style(s) for diagonal reference lines (solid, dashed, dotted, dotdash, longdash, twodash)'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify4525525">
#>             <label class="control-label" id="dittoRidgeJitter-abline.opacities-label" for="dittoRidgeJitter-abline.opacities">Ab Opacities (0-1)</label>
#>             <input id="dittoRidgeJitter-abline.opacities" type="text" class="shiny-input-text form-control" value="1" data-update-on="change"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify4525525', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Opacity of diagonal reference lines between 0 (transparent) and 1 (opaque), as comma-separated values'})}, 500)});</script>
#>         </div>
#>       </div>
#>     </div>
#>   </div>
#> </div>
#> <div class="module-tack" style="margin-top: 12px;">
#>   <div class="module-tack-switch" style="margin-bottom: 4px;">
#>     <div class="form-group shiny-input-container">
#>       <div class="material-switch">
#>         <label for="dittoRidgeJitter-auto.update" style="padding-right: 10px;">Auto Update</label>
#>         <input id="dittoRidgeJitter-auto.update" type="checkbox" checked="checked"/>
#>         <label class="switch label-success bg-success" for="dittoRidgeJitter-auto.update"></label>
#>       </div>
#>     </div>
#>   </div>
#>   <div class="module-tack-buttons" style="display: flex; flex-wrap: wrap; gap: 8px;">
#>     <button class="btn btn-default action-button btn-primary" id="dittoRidgeJitter-update" style="flex: 1 1 45%;" type="button"><span class="action-label">Update</span></button>
#>     <button class="btn btn-default action-button btn-secondary" id="dittoRidgeJitter-reset" style="flex: 1 1 45%;" type="button"><span class="action-label">Reset</span></button>
#>     <a aria-disabled="true" class="btn btn-default shiny-download-link disabled btn-secondary viz-source-download" data-viz-source-ns="dittoRidgeJitter-" download href="" id="dittoRidgeJitter-download.source" style="flex: 1 1 100%;" tabindex="-1" target="_blank">
#>       <i class="far fa-file-code" role="presentation" aria-label="file-code icon"></i>
#>       Source Download
#>     </a>
#>     <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('dittoRidgeJitter-download.source', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Download the plot as a self-contained HTML file and as SVG and PNG images of it as it looks now, along with the plot source data and statistics (if applicable) as CSV files.'})}, 500)});</script>
#>   </div>
#> </div>
```
