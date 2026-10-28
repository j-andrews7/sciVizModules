# Input UI components for the dittoPlot module

This should be placed in the UI where the inputs should be shown, with
an `id` that matches the `id` used in the
[`dittoPlotServer()`](https://j-andrews7.github.io/sciVizModules/reference/dittoPlotServer.md)
and
[`dittoPlotOutputUI()`](https://j-andrews7.github.io/sciVizModules/reference/dittoPlotOutputUI.md)
functions.

## Usage

``` r
dittoPlotInputsUI(
  id,
  data,
  defaults = NULL,
  title = "dittoPlot Settings",
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
[`dittoSeq::dittoPlot()`](https://rdrr.io/pkg/dittoSeq/man/dittoPlot.html),
plotting continuous data (gene expression or numeric metadata) per
discrete group as any combination of jitter, violin, box, and ridge
representations. The resulting `ggplot` is converted to an interactive
`plotly` figure.

## Plot parameters and defaults

The following parameters can be accessed via UI inputs and/or the
`defaults` argument:

- `var` - Continuous variable to plot (gene or numeric metadata)

- `group.by` - Discrete metadata used for the x-axis groups

- `color.by` - Discrete metadata used for fill colors (default:
  `group.by`)

- `plots` - Representations to draw (default: c("jitter", "vlnplot"))

- `split.by` - Discrete metadata to facet by (default: none)

- `jitter.size` - Jitter point size (default: 1)

- `jitter.color` - Color of the jitter points (default: "#000000")

- `vlnplot.width` - Width of the violins (default: 1)

- `vlnplot.scaling` - Violin scaling method: "area", "count", or "width"
  (default: "area")

- `boxplot.lineweight` - Line weight of the boxplot outlines (default:
  1)

- `ridgeplot.scale` - Ridge overlap scale (default: 1.25)

- `ridgeplot.lineweight` - Line weight of the ridge outlines (default:
  1)

- `palette.selection` - Colors for discrete groups (multiColorPicker)

## See also

[`dittoSeq::dittoPlot()`](https://rdrr.io/pkg/dittoSeq/man/dittoPlot.html),
[`VizModules::organize_inputs()`](https://j-andrews7.github.io/VizModules/reference/organize_inputs.html),
[`dittoPlotOutputUI()`](https://j-andrews7.github.io/sciVizModules/reference/dittoPlotOutputUI.md),
[`dittoPlotServer()`](https://j-andrews7.github.io/sciVizModules/reference/dittoPlotServer.md),
[`dittoPlotApp()`](https://j-andrews7.github.io/sciVizModules/reference/dittoPlotApp.md)

## Author

Jacob Martin, Jared Andrews

## Examples

``` r
library(sciVizModules)
data(example_sce)
dittoPlotInputsUI("dittoPlot", example_sce)
#> <h3>dittoPlot Settings</h3>
#> <div class="tabbable vizmodules-input-tabs">
#>   <ul class="nav nav-tabs shiny-tab-input" id="dittoPlot-dittoPlotTabsetPanel" data-tabsetid="7945">
#>     <li class="active">
#>       <a href="#tab-7945-1" data-toggle="tab" data-bs-toggle="tab" data-value="Data">Data</a>
#>     </li>
#>     <li>
#>       <a href="#tab-7945-2" data-toggle="tab" data-bs-toggle="tab" data-value="Aesthetics">Aesthetics</a>
#>     </li>
#>     <li>
#>       <a href="#tab-7945-3" data-toggle="tab" data-bs-toggle="tab" data-value="Plotly">Plotly</a>
#>     </li>
#>     <li>
#>       <a href="#tab-7945-4" data-toggle="tab" data-bs-toggle="tab" data-value="Axes">Axes</a>
#>     </li>
#>     <li>
#>       <a href="#tab-7945-5" data-toggle="tab" data-bs-toggle="tab" data-value="Legend">Legend</a>
#>     </li>
#>     <li>
#>       <a href="#tab-7945-6" data-toggle="tab" data-bs-toggle="tab" data-value="Lines">Lines</a>
#>     </li>
#>   </ul>
#>   <div class="tab-content" data-tabsetid="7945">
#>     <div class="tab-pane active" data-value="Data" id="tab-7945-1">
#>       <div class="vizmodules-input-grid" style="--viz-input-columns: 2;">
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" style="width:100%;" id="tipify7311036">
#>             <label class="control-label" id="dittoPlot-var-label" for="dittoPlot-var">Variable (gene / metadata)</label>
#>             <div id="dittoPlot-var" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="change">
#>               <script type="application/json" data-for="dittoPlot-var">{"stateInput":false,"options":{"type":["transpose_group"],"choices":[{"label":["Metadata"],"options":{"label":["nCount","percent.mito"],"value":["nCount","percent.mito"]}},{"label":["Genes"],"options":{"label":["Gene1","Gene2","Gene3","Gene4","Gene5","Gene6","Gene7","Gene8","Gene9","Gene10","Gene11","Gene12","Gene13","Gene14","Gene15","Gene16","Gene17","Gene18","Gene19","Gene20","Gene21","Gene22","Gene23","Gene24","Gene25","Gene26","Gene27","Gene28","Gene29","Gene30","Gene31","Gene32","Gene33","Gene34","Gene35","Gene36","Gene37","Gene38","Gene39","Gene40"],"value":["Gene1","Gene2","Gene3","Gene4","Gene5","Gene6","Gene7","Gene8","Gene9","Gene10","Gene11","Gene12","Gene13","Gene14","Gene15","Gene16","Gene17","Gene18","Gene19","Gene20","Gene21","Gene22","Gene23","Gene24","Gene25","Gene26","Gene27","Gene28","Gene29","Gene30","Gene31","Gene32","Gene33","Gene34","Gene35","Gene36","Gene37","Gene38","Gene39","Gene40"]}}]},"config":{"multiple":false,"search":true,"selectedValue":"nCount","hideClearButton":true,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":false,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":true,"disableOptionGroupCheckbox":true,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify7311036', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Single string representing the name of a metadata or gene, OR a vector with length equal to the total number of cells/samples in the dataset. Alternatively, a string vector naming multiple genes or metadata. This is the primary data that will be displayed.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" style="width:100%;" id="tipify8524323">
#>             <label class="control-label" id="dittoPlot-group.by-label" for="dittoPlot-group.by">Group By</label>
#>             <div id="dittoPlot-group.by" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="change">
#>               <script type="application/json" data-for="dittoPlot-group.by">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["clustering","celltype","condition","sample"],"value":["clustering","celltype","condition","sample"]}},"config":{"multiple":false,"search":false,"selectedValue":"clustering","hideClearButton":true,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":false,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":true,"disableOptionGroupCheckbox":true,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify8524323', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'String representing the name of a metadata to use for separating the cells/samples into discrete groups.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" style="width:100%;" id="tipify9758180">
#>             <label class="control-label" id="dittoPlot-color.by-label" for="dittoPlot-color.by">Color By</label>
#>             <div id="dittoPlot-color.by" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="change">
#>               <script type="application/json" data-for="dittoPlot-color.by">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["(none)","clustering","celltype","condition","sample"],"value":["","clustering","celltype","condition","sample"]}},"config":{"multiple":false,"search":false,"selectedValue":"","hideClearButton":true,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":false,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":true,"disableOptionGroupCheckbox":true,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify9758180', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'String representing the name of a metadata to use for setting fills. Great for highlighting supersets or subgroups when wanted, but it defaults to `group.by` so this input can be skipped otherwise.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div id="dittoPlot-plots" class="form-group shiny-input-checkboxgroup shiny-input-container" role="group" aria-labelledby="dittoPlot-plots-label">
#>             <label class="control-label" id="dittoPlot-plots-label" for="dittoPlot-plots">Representations</label>
#>             <div class="shiny-options-group">
#>               <div class="checkbox">
#>                 <label>
#>                   <input type="checkbox" name="dittoPlot-plots" value="jitter" checked="checked"/>
#>                   <span>Jitter</span>
#>                 </label>
#>               </div>
#>               <div class="checkbox">
#>                 <label>
#>                   <input type="checkbox" name="dittoPlot-plots" value="vlnplot" checked="checked"/>
#>                   <span>Violin</span>
#>                 </label>
#>               </div>
#>               <div class="checkbox">
#>                 <label>
#>                   <input type="checkbox" name="dittoPlot-plots" value="boxplot"/>
#>                   <span>Box</span>
#>                 </label>
#>               </div>
#>               <div class="checkbox">
#>                 <label>
#>                   <input type="checkbox" name="dittoPlot-plots" value="ridgeplot"/>
#>                   <span>Ridge</span>
#>                 </label>
#>               </div>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('dittoPlot-plots', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'String vector which sets the types of plots to include: possibilities = "jitter", "boxplot", "vlnplot", "ridgeplot".  Order matters: c("vlnplot", "boxplot", "jitter") will put a violin plot in the back, boxplot in the middle, and then individual dots in the front.  See details section for more info.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" style="width:100%;" id="tipify1130475">
#>             <label class="control-label" id="dittoPlot-split.by-label" for="dittoPlot-split.by">Split By (facet)</label>
#>             <div id="dittoPlot-split.by" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="change">
#>               <script type="application/json" data-for="dittoPlot-split.by">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["(none)","clustering","celltype","condition","sample"],"value":["","clustering","celltype","condition","sample"]}},"config":{"multiple":false,"search":false,"selectedValue":"","hideClearButton":true,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":false,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":true,"disableOptionGroupCheckbox":true,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify1130475', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': '1 or 2 strings naming discrete metadata to use for splitting the cells/samples into multiple plots with ggplot faceting.  When 2 metadatas are named, c(row,col), the first is used as rows and the second is used for columns of the resulting grid.  When 1 metadata is named, shape control can be achieved with `split.nrow` and `split.ncol`'})}, 500)});</script>
#>         </div>
#>       </div>
#>     </div>
#>     <div class="tab-pane" data-value="Aesthetics" id="tab-7945-2">
#>       <div class="vizmodules-input-grid" style="--viz-input-columns: 2;">
#>         <div class="vizmodules-input-cell">
#>           <div id="dittoPlot-palette.selection" class="shiny-html-output"></div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify9702622">
#>             <label class="control-label" id="dittoPlot-jitter.size-label" for="dittoPlot-jitter.size">Jitter Size</label>
#>             <input id="dittoPlot-jitter.size" type="number" class="shiny-input-number form-control" value="1" data-update-on="change" min="0.1" step="0.1"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify9702622', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': ''})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify6480828">
#>             <label class="control-label" id="dittoPlot-jitter.width-label" for="dittoPlot-jitter.width">Jitter Width</label>
#>             <input id="dittoPlot-jitter.width" type="number" class="shiny-input-number form-control" value="0.2" data-update-on="change" min="0" step="0.05"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify6480828', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': ''})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour" id="tipify560731">
#>             <label class="control-label" for="dittoPlot-jitter.color">Jitter Point Color</label>
#>             <input id="dittoPlot-jitter.color" type="text" class="form-control shiny-colour-input" data-init-value="#000000" data-show-colour="both" data-palette="square"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify560731', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': ''})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify4731371">
#>             <label class="control-label" id="dittoPlot-vlnplot.lineweight-label" for="dittoPlot-vlnplot.lineweight">Violin Line Weight</label>
#>             <input id="dittoPlot-vlnplot.lineweight" type="number" class="shiny-input-number form-control" value="1" data-update-on="change" min="0" step="0.1"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify4731371', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Scalar which sets the thickness of the line that outlines the violin plots.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify2946250">
#>             <label class="control-label" id="dittoPlot-boxplot.width-label" for="dittoPlot-boxplot.width">Box Width</label>
#>             <input id="dittoPlot-boxplot.width" type="number" class="shiny-input-number form-control" value="0.2" data-update-on="change" min="0" step="0.05"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify2946250', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': ''})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify6102996">
#>             <label class="control-label" id="dittoPlot-boxplot.lineweight-label" for="dittoPlot-boxplot.lineweight">Box Line Weight</label>
#>             <input id="dittoPlot-boxplot.lineweight" type="number" class="shiny-input-number form-control" value="1" data-update-on="change" min="0" step="0.1"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify6102996', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': ''})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify1211089">
#>             <label class="control-label" id="dittoPlot-vlnplot.width-label" for="dittoPlot-vlnplot.width">Violin Width</label>
#>             <input id="dittoPlot-vlnplot.width" type="number" class="shiny-input-number form-control" value="1" data-update-on="change" min="0" step="0.05"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify1211089', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': ''})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" style="width:100%;" id="tipify6294165">
#>             <label class="control-label" id="dittoPlot-vlnplot.scaling-label" for="dittoPlot-vlnplot.scaling">Violin Scaling</label>
#>             <div id="dittoPlot-vlnplot.scaling" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="change">
#>               <script type="application/json" data-for="dittoPlot-vlnplot.scaling">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["Area","Count","Width"],"value":["area","count","width"]}},"config":{"multiple":false,"search":false,"selectedValue":"area","hideClearButton":true,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":false,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":true,"disableOptionGroupCheckbox":true,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify6294165', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': ''})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify7119553">
#>             <label class="control-label" id="dittoPlot-ridgeplot.scale-label" for="dittoPlot-ridgeplot.scale">Ridge Scale (overlap)</label>
#>             <input id="dittoPlot-ridgeplot.scale" type="number" class="shiny-input-number form-control" value="1.25" data-update-on="change" min="0.1" step="0.05"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify7119553', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': ''})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify6120828">
#>             <label class="control-label" id="dittoPlot-ridgeplot.lineweight-label" for="dittoPlot-ridgeplot.lineweight">Ridge Line Weight</label>
#>             <input id="dittoPlot-ridgeplot.lineweight" type="number" class="shiny-input-number form-control" value="1" data-update-on="change" min="0" step="0.1"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify6120828', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': ''})}, 500)});</script>
#>         </div>
#>       </div>
#>     </div>
#>     <div class="tab-pane" data-value="Plotly" id="tab-7945-3">
#>       <div class="vizmodules-input-grid" style="--viz-input-columns: 2;">
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" style="width:100%;">
#>             <label class="control-label" id="dittoPlot-download.format-label" for="dittoPlot-download.format">Download Format</label>
#>             <div id="dittoPlot-download.format" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="change">
#>               <script type="application/json" data-for="dittoPlot-download.format">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["svg","png","jpeg","webp"],"value":["svg","png","jpeg","webp"]}},"config":{"multiple":false,"search":false,"selectedValue":"svg","hideClearButton":true,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":false,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":true,"disableOptionGroupCheckbox":true,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>             </div>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify344293">
#>             <label class="control-label" id="dittoPlot-margin.t-label" for="dittoPlot-margin.t">Margin Top</label>
#>             <input id="dittoPlot-margin.t" type="number" class="shiny-input-number form-control" value="70" data-update-on="change" min="0" step="5"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify344293', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Top margin of the plot in pixels'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify6658908">
#>             <label class="control-label" id="dittoPlot-margin.b-label" for="dittoPlot-margin.b">Margin Bottom</label>
#>             <input id="dittoPlot-margin.b" type="number" class="shiny-input-number form-control" value="70" data-update-on="change" min="0" step="5"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify6658908', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Bottom margin of the plot in pixels'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify6529673">
#>             <label class="control-label" id="dittoPlot-margin.l-label" for="dittoPlot-margin.l">Margin Left</label>
#>             <input id="dittoPlot-margin.l" type="number" class="shiny-input-number form-control" value="70" data-update-on="change" min="0" step="5"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify6529673', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Left margin of the plot in pixels'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify4518584">
#>             <label class="control-label" id="dittoPlot-margin.r-label" for="dittoPlot-margin.r">Margin Right</label>
#>             <input id="dittoPlot-margin.r" type="number" class="shiny-input-number form-control" value="90" data-update-on="change" min="0" step="5"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify4518584', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Right margin of the plot in pixels'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour" id="tipify5168041">
#>             <label class="control-label" for="dittoPlot-shape.fill">Shape Fill</label>
#>             <input id="dittoPlot-shape.fill" type="text" class="form-control shiny-colour-input" data-init-value="rgba(0, 0, 0, 0)" data-show-colour="both" data-palette="square" data-allow-alpha="true"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify5168041', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Interior fill color for shapes drawn on the plot using Plotly&#39;s drawing tools'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour" id="tipify6766108">
#>             <label class="control-label" for="dittoPlot-shape.line.color">Shape Line Color</label>
#>             <input id="dittoPlot-shape.line.color" type="text" class="form-control shiny-colour-input" data-init-value="black" data-show-colour="both" data-palette="square" data-allow-alpha="true"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify6766108', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Outline color for shapes drawn on the plot using Plotly&#39;s drawing tools'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify8809331">
#>             <label class="control-label" id="dittoPlot-shape.line.width-label" for="dittoPlot-shape.line.width">Shape Line Width</label>
#>             <input id="dittoPlot-shape.line.width" type="number" class="shiny-input-number form-control" value="4" data-update-on="change" min="0" step="0.25"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify8809331', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Outline width for shapes drawn on the plot using Plotly&#39;s drawing tools'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" style="width:100%;" id="tipify7312291">
#>             <label class="control-label" id="dittoPlot-shape.linetype-label" for="dittoPlot-shape.linetype">Shape Linetype</label>
#>             <div id="dittoPlot-shape.linetype" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="change">
#>               <script type="application/json" data-for="dittoPlot-shape.linetype">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["solid","dot","dash","longdash","dashdot","longdashdot"],"value":["solid","dot","dash","longdash","dashdot","longdashdot"]}},"config":{"multiple":false,"search":false,"selectedValue":"solid","hideClearButton":true,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":false,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":true,"disableOptionGroupCheckbox":true,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify7312291', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Line dash style for shapes drawn on the plot using Plotly&#39;s drawing tools'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify3986198">
#>             <label class="control-label" id="dittoPlot-shape.opacity-label" for="dittoPlot-shape.opacity">Shape Opacity</label>
#>             <input id="dittoPlot-shape.opacity" type="number" class="shiny-input-number form-control" value="1" data-update-on="change" min="0" max="1" step="0.01"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify3986198', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Opacity of shapes drawn on the plot, where 0 is fully transparent and 1 is fully opaque'})}, 500)});</script>
#>         </div>
#>       </div>
#>     </div>
#>     <div class="tab-pane" data-value="Axes" id="tab-7945-4">
#>       <div class="vizmodules-input-grid" style="--viz-input-columns: 2;">
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" style="width:100%;">
#>             <label class="control-label" id="dittoPlot-title.font.family-label" for="dittoPlot-title.font.family">Title Font</label>
#>             <div id="dittoPlot-title.font.family" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="change">
#>               <script type="application/json" data-for="dittoPlot-title.font.family">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["Arial","Balto","Courier New","Droid Sans","Droid Serif","Droid Sans Mono","Gravitas One","Old Standard TT","Open Sans","Overpass","PT Sans Narrow","Raleway","Times New Roman","Verdana","sans-serif","serif","monospace"],"value":["Arial","Balto","Courier New","Droid Sans","Droid Serif","Droid Sans Mono","Gravitas One","Old Standard TT","Open Sans","Overpass","PT Sans Narrow","Raleway","Times New Roman","Verdana","sans-serif","serif","monospace"]}},"config":{"multiple":false,"search":true,"selectedValue":"Arial","hideClearButton":true,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":false,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":true,"disableOptionGroupCheckbox":true,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>             </div>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour">
#>             <label class="control-label" for="dittoPlot-title.font.color">Title Color</label>
#>             <input id="dittoPlot-title.font.color" type="text" class="form-control shiny-colour-input" data-init-value="#000000" data-show-colour="both" data-palette="square"/>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="dittoPlot-title.font.size-label" for="dittoPlot-title.font.size">Title Size</label>
#>             <input id="dittoPlot-title.font.size" type="number" class="shiny-input-number form-control" value="26" data-update-on="change" min="1" step="1"/>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="dittoPlot-axis.title.horizontal.position-label" for="dittoPlot-axis.title.horizontal.position">Title position</label>
#>             <input id="dittoPlot-axis.title.horizontal.position" type="number" class="shiny-input-number form-control" value="0.5" data-update-on="change" min="0" max="1" step="0.1"/>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="dittoPlot-axis.title.font.size-label" for="dittoPlot-axis.title.font.size">Axis Title Size</label>
#>             <input id="dittoPlot-axis.title.font.size" type="number" class="shiny-input-number form-control" value="18" data-update-on="change" min="1" step="1"/>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour">
#>             <label class="control-label" for="dittoPlot-axis.title.font.color">Axis Title Color</label>
#>             <input id="dittoPlot-axis.title.font.color" type="text" class="form-control shiny-colour-input" data-init-value="#000000" data-show-colour="both" data-palette="square"/>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" style="width:100%;">
#>             <label class="control-label" id="dittoPlot-axis.title.font.family-label" for="dittoPlot-axis.title.font.family">Axis Title Font</label>
#>             <div id="dittoPlot-axis.title.font.family" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="change">
#>               <script type="application/json" data-for="dittoPlot-axis.title.font.family">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["Arial","Balto","Courier New","Droid Sans","Droid Serif","Droid Sans Mono","Gravitas One","Old Standard TT","Open Sans","Overpass","PT Sans Narrow","Raleway","Times New Roman","Verdana","sans-serif","serif","monospace"],"value":["Arial","Balto","Courier New","Droid Sans","Droid Serif","Droid Sans Mono","Gravitas One","Old Standard TT","Open Sans","Overpass","PT Sans Narrow","Raleway","Times New Roman","Verdana","sans-serif","serif","monospace"]}},"config":{"multiple":false,"search":true,"selectedValue":"Arial","hideClearButton":true,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":false,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":true,"disableOptionGroupCheckbox":true,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>             </div>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container">
#>             <div class="checkbox">
#>               <label>
#>                 <input id="dittoPlot-axis.showline" type="checkbox" class="shiny-input-checkbox" checked="checked"/>
#>                 <span>Show Axis Borders</span>
#>               </label>
#>             </div>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container">
#>             <div class="checkbox">
#>               <label>
#>                 <input id="dittoPlot-axis.mirror" type="checkbox" class="shiny-input-checkbox" checked="checked"/>
#>                 <span>Mirror Axis Borders</span>
#>               </label>
#>             </div>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container">
#>             <div class="checkbox">
#>               <label>
#>                 <input id="dittoPlot-show.grid.x" type="checkbox" class="shiny-input-checkbox" checked="checked"/>
#>                 <span>Show X Gridlines</span>
#>               </label>
#>             </div>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container">
#>             <div class="checkbox">
#>               <label>
#>                 <input id="dittoPlot-show.grid.y" type="checkbox" class="shiny-input-checkbox" checked="checked"/>
#>                 <span>Show Y Gridlines</span>
#>               </label>
#>             </div>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour">
#>             <label class="control-label" for="dittoPlot-grid.color">Gridline Color</label>
#>             <input id="dittoPlot-grid.color" type="text" class="form-control shiny-colour-input" data-init-value="#CCCCCC" data-show-colour="both" data-palette="square"/>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour">
#>             <label class="control-label" for="dittoPlot-axis.linecolor">Axis Line Color</label>
#>             <input id="dittoPlot-axis.linecolor" type="text" class="form-control shiny-colour-input" data-init-value="black" data-show-colour="both" data-palette="square"/>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="dittoPlot-axis.linewidth-label" for="dittoPlot-axis.linewidth">Axis Line Width</label>
#>             <input id="dittoPlot-axis.linewidth" type="number" class="shiny-input-number form-control" value="0.5" data-update-on="change" min="0" step="0.1"/>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="dittoPlot-axis.tickfont.size-label" for="dittoPlot-axis.tickfont.size">Tick Label Size</label>
#>             <input id="dittoPlot-axis.tickfont.size" type="number" class="shiny-input-number form-control" value="12" data-update-on="change" min="1" step="1"/>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour">
#>             <label class="control-label" for="dittoPlot-axis.tickfont.color">Tick Label Color</label>
#>             <input id="dittoPlot-axis.tickfont.color" type="text" class="form-control shiny-colour-input" data-init-value="black" data-show-colour="both" data-palette="square"/>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" style="width:100%;">
#>             <label class="control-label" id="dittoPlot-axis.tickfont.family-label" for="dittoPlot-axis.tickfont.family">Tick Label Font</label>
#>             <div id="dittoPlot-axis.tickfont.family" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="change">
#>               <script type="application/json" data-for="dittoPlot-axis.tickfont.family">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["Arial","Balto","Courier New","Droid Sans","Droid Serif","Droid Sans Mono","Gravitas One","Old Standard TT","Open Sans","Overpass","PT Sans Narrow","Raleway","Times New Roman","Verdana","sans-serif","serif","monospace"],"value":["Arial","Balto","Courier New","Droid Sans","Droid Serif","Droid Sans Mono","Gravitas One","Old Standard TT","Open Sans","Overpass","PT Sans Narrow","Raleway","Times New Roman","Verdana","sans-serif","serif","monospace"]}},"config":{"multiple":false,"search":true,"selectedValue":"Arial","hideClearButton":true,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":false,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":true,"disableOptionGroupCheckbox":true,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>             </div>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="dittoPlot-axis.tickangle.x-label" for="dittoPlot-axis.tickangle.x">X Tick Label Angle</label>
#>             <input id="dittoPlot-axis.tickangle.x" type="number" class="shiny-input-number form-control" value="0" data-update-on="change" min="-180" max="180" step="15"/>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="dittoPlot-axis.tickangle.y-label" for="dittoPlot-axis.tickangle.y">Y Tick Label Angle</label>
#>             <input id="dittoPlot-axis.tickangle.y" type="number" class="shiny-input-number form-control" value="0" data-update-on="change" min="-180" max="180" step="15"/>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" style="width:100%;">
#>             <label class="control-label" id="dittoPlot-axis.ticks-label" for="dittoPlot-axis.ticks">Tick Position</label>
#>             <div id="dittoPlot-axis.ticks" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="change">
#>               <script type="application/json" data-for="dittoPlot-axis.ticks">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["Outside","Inside","(none)"],"value":["outside","inside",""]}},"config":{"multiple":false,"search":false,"selectedValue":"outside","hideClearButton":true,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":false,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":true,"disableOptionGroupCheckbox":true,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>             </div>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour">
#>             <label class="control-label" for="dittoPlot-axis.tickcolor">Tick Mark Color</label>
#>             <input id="dittoPlot-axis.tickcolor" type="text" class="form-control shiny-colour-input" data-init-value="black" data-show-colour="both" data-palette="square"/>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="dittoPlot-axis.ticklen-label" for="dittoPlot-axis.ticklen">Tick Mark Length</label>
#>             <input id="dittoPlot-axis.ticklen" type="number" class="shiny-input-number form-control" value="5" data-update-on="change" min="0" step="1"/>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="dittoPlot-axis.tickwidth-label" for="dittoPlot-axis.tickwidth">Tick Mark Width</label>
#>             <input id="dittoPlot-axis.tickwidth" type="number" class="shiny-input-number form-control" value="1" data-update-on="change" min="0" step="0.1"/>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="dittoPlot-facet.title.font.size-label" for="dittoPlot-facet.title.font.size">Facet Subplot Title Size</label>
#>             <input id="dittoPlot-facet.title.font.size" type="number" class="shiny-input-number form-control" value="18" data-update-on="change" min="1" step="1"/>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour">
#>             <label class="control-label" for="dittoPlot-facet.title.font.color">Facet Title Color</label>
#>             <input id="dittoPlot-facet.title.font.color" type="text" class="form-control shiny-colour-input" data-init-value="#000000" data-show-colour="both" data-palette="square"/>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" style="width:100%;">
#>             <label class="control-label" id="dittoPlot-facet.title.font.family-label" for="dittoPlot-facet.title.font.family">Facet Title Font</label>
#>             <div id="dittoPlot-facet.title.font.family" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="change">
#>               <script type="application/json" data-for="dittoPlot-facet.title.font.family">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["Arial","Balto","Courier New","Droid Sans","Droid Serif","Droid Sans Mono","Gravitas One","Old Standard TT","Open Sans","Overpass","PT Sans Narrow","Raleway","Times New Roman","Verdana","sans-serif","serif","monospace"],"value":["Arial","Balto","Courier New","Droid Sans","Droid Serif","Droid Sans Mono","Gravitas One","Old Standard TT","Open Sans","Overpass","PT Sans Narrow","Raleway","Times New Roman","Verdana","sans-serif","serif","monospace"]}},"config":{"multiple":false,"search":true,"selectedValue":"Arial","hideClearButton":true,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":false,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":true,"disableOptionGroupCheckbox":true,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>             </div>
#>           </div>
#>         </div>
#>       </div>
#>     </div>
#>     <div class="tab-pane" data-value="Legend" id="tab-7945-5">
#>       <div class="vizmodules-input-grid" style="--viz-input-columns: 2;">
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify4305207">
#>             <div class="material-switch">
#>               <label for="dittoPlot-legend.show" style="padding-right: 10px;">Show Legend</label>
#>               <input id="dittoPlot-legend.show" type="checkbox" checked="checked"/>
#>               <label class="switch label-success bg-success" for="dittoPlot-legend.show"></label>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify4305207', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Show the legend. Turning it off also hides colorbars and any point size legend.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" style="width:100%;" id="tipify1454074">
#>             <label class="control-label" id="dittoPlot-legend.font.family-label" for="dittoPlot-legend.font.family">Legend Font</label>
#>             <div id="dittoPlot-legend.font.family" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="change">
#>               <script type="application/json" data-for="dittoPlot-legend.font.family">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["Arial","Balto","Courier New","Droid Sans","Droid Serif","Droid Sans Mono","Gravitas One","Old Standard TT","Open Sans","Overpass","PT Sans Narrow","Raleway","Times New Roman","Verdana","sans-serif","serif","monospace"],"value":["Arial","Balto","Courier New","Droid Sans","Droid Serif","Droid Sans Mono","Gravitas One","Old Standard TT","Open Sans","Overpass","PT Sans Narrow","Raleway","Times New Roman","Verdana","sans-serif","serif","monospace"]}},"config":{"multiple":false,"search":true,"selectedValue":"Arial","hideClearButton":true,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":false,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":true,"disableOptionGroupCheckbox":true,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify1454074', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Font family of the legend title and entry labels.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour" id="tipify4511203">
#>             <label class="control-label" for="dittoPlot-legend.font.color">Legend Font Color</label>
#>             <input id="dittoPlot-legend.font.color" type="text" class="form-control shiny-colour-input" data-init-value="#000000" data-show-colour="both" data-palette="square"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify4511203', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Font color of the legend title and entry labels.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify5787815">
#>             <label class="control-label" id="dittoPlot-legend.title.size-label" for="dittoPlot-legend.title.size">Legend Title Size</label>
#>             <input id="dittoPlot-legend.title.size" type="number" class="shiny-input-number form-control" value="14" data-update-on="change" min="0" step="1"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify5787815', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Font size of the legend title.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify704172">
#>             <label class="control-label" id="dittoPlot-legend.text.size-label" for="dittoPlot-legend.text.size">Legend Text Size</label>
#>             <input id="dittoPlot-legend.text.size" type="number" class="shiny-input-number form-control" value="12" data-update-on="change" min="0" step="1"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify704172', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Font size of the legend entry labels.'})}, 500)});</script>
#>         </div>
#>       </div>
#>     </div>
#>     <div class="tab-pane" data-value="Lines" id="tab-7945-6">
#>       <div class="vizmodules-input-grid" style="--viz-input-columns: 2;">
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify7423262">
#>             <label class="control-label" id="dittoPlot-hline.intercepts-label" for="dittoPlot-hline.intercepts">Y-intercepts</label>
#>             <input id="dittoPlot-hline.intercepts" type="text" class="shiny-input-text form-control" value="" placeholder="e.g. 2, -2" data-update-on="change"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify7423262', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'For categorical or factor axes, enter the index (position) of the category rather than its name. For example, if the axis categories are &#39;Audi&#39;, &#39;Mercedes&#39;, &#39;Bugatti&#39;, enter 2 to place a line at &#39;Mercedes&#39;.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify5492207">
#>             <label class="control-label" id="dittoPlot-hline.colors-label" for="dittoPlot-hline.colors">Y Colors</label>
#>             <input id="dittoPlot-hline.colors" type="text" class="shiny-input-text form-control" value="#000000" data-update-on="change"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify5492207', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Color(s) for horizontal reference lines, as comma-separated hex codes or color names'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify6345443">
#>             <label class="control-label" id="dittoPlot-hline.widths-label" for="dittoPlot-hline.widths">Y Widths</label>
#>             <input id="dittoPlot-hline.widths" type="text" class="shiny-input-text form-control" value="1" data-update-on="change"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify6345443', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Width(s) for horizontal reference lines in pixels, as comma-separated values'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify1366286">
#>             <label class="control-label" id="dittoPlot-hline.linetypes-label" for="dittoPlot-hline.linetypes">Y Line Types</label>
#>             <input id="dittoPlot-hline.linetypes" type="text" class="shiny-input-text form-control" value="dashed" placeholder="solid, dashed, dotted, ..." data-update-on="change"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify1366286', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Line style(s) for horizontal reference lines (solid, dashed, dotted, dotdash, longdash, twodash)'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify9302335">
#>             <label class="control-label" id="dittoPlot-hline.opacities-label" for="dittoPlot-hline.opacities">Y Opacities (0-1)</label>
#>             <input id="dittoPlot-hline.opacities" type="text" class="shiny-input-text form-control" value="1" data-update-on="change"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify9302335', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Opacity of horizontal reference lines between 0 (transparent) and 1 (opaque), as comma-separated values'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify6511186">
#>             <label class="control-label" id="dittoPlot-vline.intercepts-label" for="dittoPlot-vline.intercepts">X-intercepts</label>
#>             <input id="dittoPlot-vline.intercepts" type="text" class="shiny-input-text form-control" value="" placeholder="e.g. 2, -2" data-update-on="change"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify6511186', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'For categorical or factor axes, enter the index (position) of the category rather than its name. For example, if the axis categories are &#39;Audi&#39;, &#39;Mercedes&#39;, &#39;Bugatti&#39;, enter 2 to place a line at &#39;Mercedes&#39;.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify5287093">
#>             <label class="control-label" id="dittoPlot-vline.colors-label" for="dittoPlot-vline.colors">X Colors</label>
#>             <input id="dittoPlot-vline.colors" type="text" class="shiny-input-text form-control" value="#000000" data-update-on="change"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify5287093', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Color(s) for vertical reference lines, as comma-separated hex codes or color names'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify2251154">
#>             <label class="control-label" id="dittoPlot-vline.widths-label" for="dittoPlot-vline.widths">X Widths</label>
#>             <input id="dittoPlot-vline.widths" type="text" class="shiny-input-text form-control" value="1" data-update-on="change"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify2251154', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Width(s) for vertical reference lines in pixels, as comma-separated values'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify9832668">
#>             <label class="control-label" id="dittoPlot-vline.linetypes-label" for="dittoPlot-vline.linetypes">X Line Types</label>
#>             <input id="dittoPlot-vline.linetypes" type="text" class="shiny-input-text form-control" value="dashed" placeholder="solid, dashed, dotted, ..." data-update-on="change"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify9832668', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Line style(s) for vertical reference lines (solid, dashed, dotted, dotdash, longdash, twodash)'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify1090488">
#>             <label class="control-label" id="dittoPlot-vline.opacities-label" for="dittoPlot-vline.opacities">X Opacities (0-1)</label>
#>             <input id="dittoPlot-vline.opacities" type="text" class="shiny-input-text form-control" value="1" data-update-on="change"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify1090488', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Opacity of vertical reference lines between 0 (transparent) and 1 (opaque), as comma-separated values'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify699456">
#>             <label class="control-label" id="dittoPlot-abline.slopes-label" for="dittoPlot-abline.slopes">Ab Slopes</label>
#>             <input id="dittoPlot-abline.slopes" type="text" class="shiny-input-text form-control" value="" data-update-on="change"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify699456', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Slope(s) of diagonal reference lines (rise/run), as comma-separated values'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify7776455">
#>             <label class="control-label" id="dittoPlot-abline.intercepts-label" for="dittoPlot-abline.intercepts">Ab Y-intercepts</label>
#>             <input id="dittoPlot-abline.intercepts" type="text" class="shiny-input-text form-control" value="" data-update-on="change"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify7776455', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'For categorical or factor axes, enter the index (position) of the category rather than its name. For example, if the axis categories are &#39;Audi&#39;, &#39;Mercedes&#39;, &#39;Bugatti&#39;, enter 2 to place a line at &#39;Mercedes&#39;.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify6583222">
#>             <label class="control-label" id="dittoPlot-abline.colors-label" for="dittoPlot-abline.colors">Ab Colors</label>
#>             <input id="dittoPlot-abline.colors" type="text" class="shiny-input-text form-control" value="#000000" data-update-on="change"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify6583222', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Color(s) for diagonal reference lines, as comma-separated hex codes or color names'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify2592028">
#>             <label class="control-label" id="dittoPlot-abline.widths-label" for="dittoPlot-abline.widths">Ab Widths</label>
#>             <input id="dittoPlot-abline.widths" type="text" class="shiny-input-text form-control" value="1" data-update-on="change"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify2592028', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Width(s) for diagonal reference lines in pixels, as comma-separated values'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify9183378">
#>             <label class="control-label" id="dittoPlot-abline.linetypes-label" for="dittoPlot-abline.linetypes">Ab Line Types</label>
#>             <input id="dittoPlot-abline.linetypes" type="text" class="shiny-input-text form-control" value="dashed" placeholder="solid, dashed, dotted, ..." data-update-on="change"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify9183378', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Line style(s) for diagonal reference lines (solid, dashed, dotted, dotdash, longdash, twodash)'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify1487104">
#>             <label class="control-label" id="dittoPlot-abline.opacities-label" for="dittoPlot-abline.opacities">Ab Opacities (0-1)</label>
#>             <input id="dittoPlot-abline.opacities" type="text" class="shiny-input-text form-control" value="1" data-update-on="change"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify1487104', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Opacity of diagonal reference lines between 0 (transparent) and 1 (opaque), as comma-separated values'})}, 500)});</script>
#>         </div>
#>       </div>
#>     </div>
#>   </div>
#> </div>
#> <div class="module-tack" style="margin-top: 12px;">
#>   <div class="module-tack-switch" style="margin-bottom: 4px;">
#>     <div class="form-group shiny-input-container">
#>       <div class="material-switch">
#>         <label for="dittoPlot-auto.update" style="padding-right: 10px;">Auto Update</label>
#>         <input id="dittoPlot-auto.update" type="checkbox" checked="checked"/>
#>         <label class="switch label-success bg-success" for="dittoPlot-auto.update"></label>
#>       </div>
#>     </div>
#>   </div>
#>   <div class="module-tack-buttons" style="display: flex; flex-wrap: wrap; gap: 8px;">
#>     <button class="btn btn-default action-button btn-primary" id="dittoPlot-update" style="flex: 1 1 45%;" type="button"><span class="action-label">Update</span></button>
#>     <button class="btn btn-default action-button btn-secondary" id="dittoPlot-reset" style="flex: 1 1 45%;" type="button"><span class="action-label">Reset</span></button>
#>     <a aria-disabled="true" class="btn btn-default shiny-download-link disabled btn-secondary viz-source-download" data-viz-source-ns="dittoPlot-" download href="" id="dittoPlot-download.source" style="flex: 1 1 100%;" tabindex="-1" target="_blank">
#>       <i class="far fa-file-code" role="presentation" aria-label="file-code icon"></i>
#>       Source Download
#>     </a>
#>     <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('dittoPlot-download.source', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Download the plot as a self-contained HTML file and as SVG and PNG images of it as it looks now, along with the plot source data and statistics (if applicable) as CSV files.'})}, 500)});</script>
#>   </div>
#> </div>
```
