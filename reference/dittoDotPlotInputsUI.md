# Input UI components for the dittoDotPlot module

This should be placed in the UI where the inputs should be shown, with
an `id` that matches the `id` used in the
[`dittoDotPlotServer()`](https://j-andrews7.github.io/sciVizModules/reference/dittoDotPlotServer.md)
and
[`dittoDotPlotOutputUI()`](https://j-andrews7.github.io/sciVizModules/reference/dittoDotPlotOutputUI.md)
functions.

## Usage

``` r
dittoDotPlotInputsUI(
  id,
  data,
  defaults = NULL,
  title = "dittoDotPlot Settings",
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
[`dittoSeq::dittoDotPlot()`](https://rdrr.io/pkg/dittoSeq/man/dittoDotPlot.html),
the standard marker figure: for each gene (or numeric metadata) and
group, a dot whose colour is the mean expression of the cells expressing
it and whose size is the fraction of cells expressing it. The resulting
`ggplot` is converted to an interactive `plotly` figure. `ggplotly()`
drops ggplot's size legend, so the dot-size legend is redrawn with
[`VizModules::add_size_legend()`](https://j-andrews7.github.io/VizModules/reference/add_size_legend.html),
as the VizModules DotPlot module draws its own: circles sized from the
plotted dots, labelled with the percentage of cells expressing.

## Plot parameters not implemented or with altered functionality

The following
[`dittoSeq::dittoDotPlot()`](https://rdrr.io/pkg/dittoSeq/man/dittoDotPlot.html)
parameters are not available via UI inputs:

- `summary.fxn.size` - Always the fraction of cells with a non-zero
  value

- `min`, `max`, `mid` - Colour-scale limits are left to dittoSeq
  ("make")

- `legend.size.title` - The size legend is titled "percent expression",
  as dittoSeq titles it

- `main`, `sub`, `xlab`, `ylab`, `legend.color.title` - Plotly allows
  interactive editing

- `y.labels`, `y.reorder`, `x.labels.rotate` - Not exposed; tick angles
  are on the Axes tab

- `cells.use`, `adjustment`, `swap.rownames`, `slot`, `split.adjust`,
  `categories.*`, `groupings.drop.unused`, `do.hover`, `data.out` - Not
  exposed

## Plot parameters and defaults

The following
[`dittoSeq::dittoDotPlot()`](https://rdrr.io/pkg/dittoSeq/man/dittoDotPlot.html)
parameters can be accessed via UI inputs and/or the `defaults` argument:

- `vars` - Genes or numeric metadata, one dot column each (UI: "Genes /
  Variables", default: the first five genes)

- `group.by` - Discrete metadata giving the groups (UI: "Group By",
  default: the first discrete metadata column)

- `split.by` - Discrete metadata to facet by (UI: "Split By (facet)",
  default: none)

- `scale` - Z-score each variable's colour values across groups (UI:
  "Scale", default: TRUE)

- `vars.dir` - Direction of the variables, `"x"` or `"y"` (UI:
  "Variables Along", default: `"x"`)

- `assay` - Assay (UI: "Assay", default: dittoSeq's default, `logcounts`
  when present)

- `summary.fxn.color` - `"nonzero.mean"` (dittoSeq's default: mean of
  the cells expressing), `"mean"` or `"median"` (UI: "Colour Summary")

- `min.color`, `max.color` - Colour-scale ends (UI: "Low Color", "High
  Color"; default: "grey90", "#C51B7D")

- `mid.color` - `""` for a two-colour scale, or a dittoSeq preset
  `"ryb"`, `"rgb"`, `"rwb"` (UI: "Mid Color", default: `""`)

- `size` - Largest dot size (UI: "Max Dot Size", default: 6)

- `min.percent`, `max.percent` - Fraction expressing at which dots are
  smallest and largest; groups below `min.percent` get no dot (UI: "Min
  Fraction", "Max Fraction"; default: 0.01, NA)

## Parameters controlling additional functionality

The following parameters implementing new functionality are also
available:

- `size.legend.x` - Size legend x position, in paper coordinates (UI:
  "Size Legend X Position", default: 1.04); values just above 1 sit
  right of the plot

- `size.legend.y` - Size legend y position (UI: "Size Legend Y
  Position", default: 0.35); lower it to clear the colour bar

Hiding the legend (`legend.show`) hides the size legend too. The Legend,
Axes, Lines and Plotly tabs carry the shared VizModules inputs (see
[`VizModules::uniform_axes_inputs_ui()`](https://j-andrews7.github.io/VizModules/reference/uniform_axes_inputs_ui.html)
and siblings).

## See also

[`dittoSeq::dittoDotPlot()`](https://rdrr.io/pkg/dittoSeq/man/dittoDotPlot.html),
[`VizModules::organize_inputs()`](https://j-andrews7.github.io/VizModules/reference/organize_inputs.html),
[`dittoDotPlotOutputUI()`](https://j-andrews7.github.io/sciVizModules/reference/dittoDotPlotOutputUI.md),
[`dittoDotPlotServer()`](https://j-andrews7.github.io/sciVizModules/reference/dittoDotPlotServer.md),
[`dittoDotPlotApp()`](https://j-andrews7.github.io/sciVizModules/reference/dittoDotPlotApp.md)

## Author

Jared Andrews

## Examples

``` r
library(sciVizModules)
data(example_sce)
dittoDotPlotInputsUI("dotplot", example_sce)
#> <h3>dittoDotPlot Settings</h3>
#> <div class="tabbable vizmodules-input-tabs">
#>   <ul class="nav nav-tabs shiny-tab-input" id="dotplot-dittoDotPlotTabsetPanel" data-tabsetid="5358">
#>     <li class="active">
#>       <a href="#tab-5358-1" data-toggle="tab" data-bs-toggle="tab" data-value="Data">Data</a>
#>     </li>
#>     <li>
#>       <a href="#tab-5358-2" data-toggle="tab" data-bs-toggle="tab" data-value="Aesthetics">Aesthetics</a>
#>     </li>
#>     <li>
#>       <a href="#tab-5358-3" data-toggle="tab" data-bs-toggle="tab" data-value="Plotly">Plotly</a>
#>     </li>
#>     <li>
#>       <a href="#tab-5358-4" data-toggle="tab" data-bs-toggle="tab" data-value="Axes">Axes</a>
#>     </li>
#>     <li>
#>       <a href="#tab-5358-5" data-toggle="tab" data-bs-toggle="tab" data-value="Legend">Legend</a>
#>     </li>
#>     <li>
#>       <a href="#tab-5358-6" data-toggle="tab" data-bs-toggle="tab" data-value="Lines">Lines</a>
#>     </li>
#>   </ul>
#>   <div class="tab-content" data-tabsetid="5358">
#>     <div class="tab-pane active" data-value="Data" id="tab-5358-1">
#>       <div class="vizmodules-input-grid" style="--viz-input-columns: 2;">
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" style="width:100%;" id="tipify8517431">
#>             <label class="control-label" id="dotplot-vars-label" for="dotplot-vars">Genes / Variables</label>
#>             <div id="dotplot-vars" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="close">
#>               <script type="application/json" data-for="dotplot-vars">{"stateInput":false,"options":{"type":["transpose_group"],"choices":[{"label":["Metadata"],"options":{"label":["nCount","percent.mito"],"value":["nCount","percent.mito"]}},{"label":["Genes"],"options":{"label":["Gene1","Gene2","Gene3","Gene4","Gene5","Gene6","Gene7","Gene8","Gene9","Gene10","Gene11","Gene12","Gene13","Gene14","Gene15","Gene16","Gene17","Gene18","Gene19","Gene20","Gene21","Gene22","Gene23","Gene24","Gene25","Gene26","Gene27","Gene28","Gene29","Gene30","Gene31","Gene32","Gene33","Gene34","Gene35","Gene36","Gene37","Gene38","Gene39","Gene40"],"value":["Gene1","Gene2","Gene3","Gene4","Gene5","Gene6","Gene7","Gene8","Gene9","Gene10","Gene11","Gene12","Gene13","Gene14","Gene15","Gene16","Gene17","Gene18","Gene19","Gene20","Gene21","Gene22","Gene23","Gene24","Gene25","Gene26","Gene27","Gene28","Gene29","Gene30","Gene31","Gene32","Gene33","Gene34","Gene35","Gene36","Gene37","Gene38","Gene39","Gene40"]}}]},"config":{"multiple":true,"search":true,"selectedValue":["Gene1","Gene2","Gene3","Gene4","Gene5"],"hideClearButton":false,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":true,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":false,"disableOptionGroupCheckbox":false,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify8517431', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'String vector of gene or metadata names which selects the features to summarize and show. Example: `c("gene1","gene2","gene3")`  Alternatively, a named list of string vectors where names represent category labels, such as associated cell types, and values are the gene or metadata names that you wish to have grouped together. Example: `vars = list(&#39;Epithelial Cells&#39; = c("gene1","gene2"), Neuron = c("gene3"))`'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" style="width:100%;" id="tipify458494">
#>             <label class="control-label" id="dotplot-group.by-label" for="dotplot-group.by">Group By</label>
#>             <div id="dotplot-group.by" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="change">
#>               <script type="application/json" data-for="dotplot-group.by">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["clustering","celltype","condition","sample"],"value":["clustering","celltype","condition","sample"]}},"config":{"multiple":false,"search":false,"selectedValue":"clustering","hideClearButton":true,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":false,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":true,"disableOptionGroupCheckbox":true,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify458494', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'String representing the name of a metadata to use for separating the cells/samples into discrete groups.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" style="width:100%;" id="tipify3810569">
#>             <label class="control-label" id="dotplot-split.by-label" for="dotplot-split.by">Split By (facet)</label>
#>             <div id="dotplot-split.by" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="change">
#>               <script type="application/json" data-for="dotplot-split.by">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["(none)","clustering","celltype","condition","sample"],"value":["","clustering","celltype","condition","sample"]}},"config":{"multiple":false,"search":false,"selectedValue":"","hideClearButton":true,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":false,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":true,"disableOptionGroupCheckbox":true,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify3810569', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': '1 or 2 strings naming discrete metadata to use for splitting the cells/samples into multiple plots with ggplot faceting. itemize{ item When 2 metadata are named, c(row,col), the first is used as rows and the second is used for columns of the resulting grid. item When 1 metadata is named, shape control can be achieved with `split.nrow` and `split.ncol` item Note: When `vars` are provided in list format, to group its contents into categories, that grouping is carried out via faceting and takes up one of the `split.by` slots. }'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify1833121">
#>             <div class="material-switch">
#>               <label for="dotplot-scale" style="padding-right: 10px;">Scale</label>
#>               <input id="dotplot-scale" type="checkbox" checked="checked"/>
#>               <label class="switch label-success bg-success" for="dotplot-scale"></label>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify1833121', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'String which sets whether the values shown with color (default: mean non-zero expression) should be centered and scaled.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" style="width:100%;" id="tipify9217996">
#>             <label class="control-label" id="dotplot-vars.dir-label" for="dotplot-vars.dir">Variables Along</label>
#>             <div id="dotplot-vars.dir" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="change">
#>               <script type="application/json" data-for="dotplot-vars.dir">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["X axis","Y axis"],"value":["x","y"]}},"config":{"multiple":false,"search":false,"selectedValue":"x","hideClearButton":true,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":false,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":true,"disableOptionGroupCheckbox":true,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify9217996', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': '"x" or "y", sets the axis where `vars` will be displayed.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" style="width:100%;" id="tipify9061868">
#>             <label class="control-label" id="dotplot-assay-label" for="dotplot-assay">Assay</label>
#>             <div id="dotplot-assay" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="change">
#>               <script type="application/json" data-for="dotplot-assay">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["counts","logcounts"],"value":["counts","logcounts"]}},"config":{"multiple":false,"search":false,"selectedValue":"logcounts","hideClearButton":true,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":false,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":true,"disableOptionGroupCheckbox":true,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify9061868', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'The assay the expression values are taken from.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" style="width:100%;" id="tipify1929433">
#>             <label class="control-label" id="dotplot-summary.fxn.color-label" for="dotplot-summary.fxn.color">Colour Summary</label>
#>             <div id="dotplot-summary.fxn.color" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="change">
#>               <script type="application/json" data-for="dotplot-summary.fxn.color">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["Mean of expressing cells","Mean","Median"],"value":["nonzero.mean","mean","median"]}},"config":{"multiple":false,"search":false,"selectedValue":"nonzero.mean","hideClearButton":true,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":false,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":true,"disableOptionGroupCheckbox":true,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify1929433', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'How each group&#39;s values are summarised for the dot colour.'})}, 500)});</script>
#>         </div>
#>       </div>
#>     </div>
#>     <div class="tab-pane" data-value="Aesthetics" id="tab-5358-2">
#>       <div class="vizmodules-input-grid" style="--viz-input-columns: 2;">
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour" id="tipify8643752">
#>             <label class="control-label" for="dotplot-min.color">Low Color</label>
#>             <input id="dotplot-min.color" type="text" class="form-control shiny-colour-input" data-init-value="grey90" data-show-colour="both" data-palette="square"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify8643752', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Colour of the lowest summarised value.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour" id="tipify132727">
#>             <label class="control-label" for="dotplot-max.color">High Color</label>
#>             <input id="dotplot-max.color" type="text" class="form-control shiny-colour-input" data-init-value="#C51B7D" data-show-colour="both" data-palette="square"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify132727', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Colour of the highest summarised value.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" style="width:100%;" id="tipify8856603">
#>             <label class="control-label" id="dotplot-mid.color-label" for="dotplot-mid.color">Mid Color</label>
#>             <div id="dotplot-mid.color" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="change">
#>               <script type="application/json" data-for="dotplot-mid.color">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["(none)","Red-yellow-blue","Red-grey-blue","Red-white-blue"],"value":["","ryb","rgb","rwb"]}},"config":{"multiple":false,"search":false,"selectedValue":"","hideClearButton":true,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":false,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":true,"disableOptionGroupCheckbox":true,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify8856603', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'A dittoSeq three-colour preset, centred on zero when scaled; it replaces the low and high colours.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify3915421">
#>             <label class="control-label" id="dotplot-size-label" for="dotplot-size">Max Dot Size</label>
#>             <input id="dotplot-size" type="number" class="shiny-input-number form-control" value="6" data-update-on="change" min="0.5" step="0.5"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify3915421', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Number which sets the visual dot size associated with the highest value shown by dot size (default: percent non-zero expression).'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify761764">
#>             <label class="control-label" id="dotplot-min.percent-label" for="dotplot-min.percent">Min Fraction</label>
#>             <input id="dotplot-min.percent" type="number" class="shiny-input-number form-control" value="0.01" data-update-on="change" min="0" max="1" step="0.01"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify761764', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': ''})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify6467813">
#>             <label class="control-label" id="dotplot-max.percent-label" for="dotplot-max.percent">Max Fraction</label>
#>             <input id="dotplot-max.percent" type="number" class="shiny-input-number form-control" value="NA" data-update-on="change" min="0" max="1" step="0.05"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify6467813', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': ''})}, 500)});</script>
#>         </div>
#>       </div>
#>     </div>
#>     <div class="tab-pane" data-value="Plotly" id="tab-5358-3">
#>       <div class="vizmodules-input-grid" style="--viz-input-columns: 2;">
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" style="width:100%;">
#>             <label class="control-label" id="dotplot-download.format-label" for="dotplot-download.format">Download Format</label>
#>             <div id="dotplot-download.format" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="change">
#>               <script type="application/json" data-for="dotplot-download.format">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["svg","png","jpeg","webp"],"value":["svg","png","jpeg","webp"]}},"config":{"multiple":false,"search":false,"selectedValue":"svg","hideClearButton":true,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":false,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":true,"disableOptionGroupCheckbox":true,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>             </div>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify9166539">
#>             <label class="control-label" id="dotplot-margin.t-label" for="dotplot-margin.t">Margin Top</label>
#>             <input id="dotplot-margin.t" type="number" class="shiny-input-number form-control" value="70" data-update-on="change" min="0" step="5"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify9166539', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Top margin of the plot in pixels'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify8345086">
#>             <label class="control-label" id="dotplot-margin.b-label" for="dotplot-margin.b">Margin Bottom</label>
#>             <input id="dotplot-margin.b" type="number" class="shiny-input-number form-control" value="70" data-update-on="change" min="0" step="5"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify8345086', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Bottom margin of the plot in pixels'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify5012471">
#>             <label class="control-label" id="dotplot-margin.l-label" for="dotplot-margin.l">Margin Left</label>
#>             <input id="dotplot-margin.l" type="number" class="shiny-input-number form-control" value="70" data-update-on="change" min="0" step="5"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify5012471', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Left margin of the plot in pixels'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify6021448">
#>             <label class="control-label" id="dotplot-margin.r-label" for="dotplot-margin.r">Margin Right</label>
#>             <input id="dotplot-margin.r" type="number" class="shiny-input-number form-control" value="90" data-update-on="change" min="0" step="5"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify6021448', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Right margin of the plot in pixels'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour" id="tipify4689590">
#>             <label class="control-label" for="dotplot-shape.fill">Shape Fill</label>
#>             <input id="dotplot-shape.fill" type="text" class="form-control shiny-colour-input" data-init-value="rgba(0, 0, 0, 0)" data-show-colour="both" data-palette="square" data-allow-alpha="true"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify4689590', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Interior fill color for shapes drawn on the plot using Plotly&#39;s drawing tools'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour" id="tipify8863742">
#>             <label class="control-label" for="dotplot-shape.line.color">Shape Line Color</label>
#>             <input id="dotplot-shape.line.color" type="text" class="form-control shiny-colour-input" data-init-value="black" data-show-colour="both" data-palette="square" data-allow-alpha="true"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify8863742', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Outline color for shapes drawn on the plot using Plotly&#39;s drawing tools'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify6705485">
#>             <label class="control-label" id="dotplot-shape.line.width-label" for="dotplot-shape.line.width">Shape Line Width</label>
#>             <input id="dotplot-shape.line.width" type="number" class="shiny-input-number form-control" value="4" data-update-on="change" min="0" step="0.25"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify6705485', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Outline width for shapes drawn on the plot using Plotly&#39;s drawing tools'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" style="width:100%;" id="tipify3937777">
#>             <label class="control-label" id="dotplot-shape.linetype-label" for="dotplot-shape.linetype">Shape Linetype</label>
#>             <div id="dotplot-shape.linetype" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="change">
#>               <script type="application/json" data-for="dotplot-shape.linetype">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["solid","dot","dash","longdash","dashdot","longdashdot"],"value":["solid","dot","dash","longdash","dashdot","longdashdot"]}},"config":{"multiple":false,"search":false,"selectedValue":"solid","hideClearButton":true,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":false,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":true,"disableOptionGroupCheckbox":true,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify3937777', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Line dash style for shapes drawn on the plot using Plotly&#39;s drawing tools'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify5512907">
#>             <label class="control-label" id="dotplot-shape.opacity-label" for="dotplot-shape.opacity">Shape Opacity</label>
#>             <input id="dotplot-shape.opacity" type="number" class="shiny-input-number form-control" value="1" data-update-on="change" min="0" max="1" step="0.01"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify5512907', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Opacity of shapes drawn on the plot, where 0 is fully transparent and 1 is fully opaque'})}, 500)});</script>
#>         </div>
#>       </div>
#>     </div>
#>     <div class="tab-pane" data-value="Axes" id="tab-5358-4">
#>       <div class="vizmodules-input-grid" style="--viz-input-columns: 2;">
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" style="width:100%;">
#>             <label class="control-label" id="dotplot-title.font.family-label" for="dotplot-title.font.family">Title Font</label>
#>             <div id="dotplot-title.font.family" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="change">
#>               <script type="application/json" data-for="dotplot-title.font.family">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["Arial","Balto","Courier New","Droid Sans","Droid Serif","Droid Sans Mono","Gravitas One","Old Standard TT","Open Sans","Overpass","PT Sans Narrow","Raleway","Times New Roman","Verdana","sans-serif","serif","monospace"],"value":["Arial","Balto","Courier New","Droid Sans","Droid Serif","Droid Sans Mono","Gravitas One","Old Standard TT","Open Sans","Overpass","PT Sans Narrow","Raleway","Times New Roman","Verdana","sans-serif","serif","monospace"]}},"config":{"multiple":false,"search":true,"selectedValue":"Arial","hideClearButton":true,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":false,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":true,"disableOptionGroupCheckbox":true,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>             </div>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour">
#>             <label class="control-label" for="dotplot-title.font.color">Title Color</label>
#>             <input id="dotplot-title.font.color" type="text" class="form-control shiny-colour-input" data-init-value="#000000" data-show-colour="both" data-palette="square"/>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="dotplot-title.font.size-label" for="dotplot-title.font.size">Title Size</label>
#>             <input id="dotplot-title.font.size" type="number" class="shiny-input-number form-control" value="26" data-update-on="change" min="1" step="1"/>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="dotplot-axis.title.horizontal.position-label" for="dotplot-axis.title.horizontal.position">Title position</label>
#>             <input id="dotplot-axis.title.horizontal.position" type="number" class="shiny-input-number form-control" value="0.5" data-update-on="change" min="0" max="1" step="0.1"/>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="dotplot-axis.title.font.size-label" for="dotplot-axis.title.font.size">Axis Title Size</label>
#>             <input id="dotplot-axis.title.font.size" type="number" class="shiny-input-number form-control" value="18" data-update-on="change" min="1" step="1"/>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour">
#>             <label class="control-label" for="dotplot-axis.title.font.color">Axis Title Color</label>
#>             <input id="dotplot-axis.title.font.color" type="text" class="form-control shiny-colour-input" data-init-value="#000000" data-show-colour="both" data-palette="square"/>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" style="width:100%;">
#>             <label class="control-label" id="dotplot-axis.title.font.family-label" for="dotplot-axis.title.font.family">Axis Title Font</label>
#>             <div id="dotplot-axis.title.font.family" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="change">
#>               <script type="application/json" data-for="dotplot-axis.title.font.family">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["Arial","Balto","Courier New","Droid Sans","Droid Serif","Droid Sans Mono","Gravitas One","Old Standard TT","Open Sans","Overpass","PT Sans Narrow","Raleway","Times New Roman","Verdana","sans-serif","serif","monospace"],"value":["Arial","Balto","Courier New","Droid Sans","Droid Serif","Droid Sans Mono","Gravitas One","Old Standard TT","Open Sans","Overpass","PT Sans Narrow","Raleway","Times New Roman","Verdana","sans-serif","serif","monospace"]}},"config":{"multiple":false,"search":true,"selectedValue":"Arial","hideClearButton":true,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":false,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":true,"disableOptionGroupCheckbox":true,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>             </div>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container">
#>             <div class="checkbox">
#>               <label>
#>                 <input id="dotplot-axis.showline" type="checkbox" class="shiny-input-checkbox" checked="checked"/>
#>                 <span>Show Axis Borders</span>
#>               </label>
#>             </div>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container">
#>             <div class="checkbox">
#>               <label>
#>                 <input id="dotplot-axis.mirror" type="checkbox" class="shiny-input-checkbox" checked="checked"/>
#>                 <span>Mirror Axis Borders</span>
#>               </label>
#>             </div>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container">
#>             <div class="checkbox">
#>               <label>
#>                 <input id="dotplot-show.grid.x" type="checkbox" class="shiny-input-checkbox" checked="checked"/>
#>                 <span>Show X Gridlines</span>
#>               </label>
#>             </div>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container">
#>             <div class="checkbox">
#>               <label>
#>                 <input id="dotplot-show.grid.y" type="checkbox" class="shiny-input-checkbox" checked="checked"/>
#>                 <span>Show Y Gridlines</span>
#>               </label>
#>             </div>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour">
#>             <label class="control-label" for="dotplot-grid.color">Gridline Color</label>
#>             <input id="dotplot-grid.color" type="text" class="form-control shiny-colour-input" data-init-value="#CCCCCC" data-show-colour="both" data-palette="square"/>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour">
#>             <label class="control-label" for="dotplot-axis.linecolor">Axis Line Color</label>
#>             <input id="dotplot-axis.linecolor" type="text" class="form-control shiny-colour-input" data-init-value="black" data-show-colour="both" data-palette="square"/>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="dotplot-axis.linewidth-label" for="dotplot-axis.linewidth">Axis Line Width</label>
#>             <input id="dotplot-axis.linewidth" type="number" class="shiny-input-number form-control" value="0.5" data-update-on="change" min="0" step="0.1"/>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="dotplot-axis.tickfont.size-label" for="dotplot-axis.tickfont.size">Tick Label Size</label>
#>             <input id="dotplot-axis.tickfont.size" type="number" class="shiny-input-number form-control" value="12" data-update-on="change" min="1" step="1"/>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour">
#>             <label class="control-label" for="dotplot-axis.tickfont.color">Tick Label Color</label>
#>             <input id="dotplot-axis.tickfont.color" type="text" class="form-control shiny-colour-input" data-init-value="black" data-show-colour="both" data-palette="square"/>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" style="width:100%;">
#>             <label class="control-label" id="dotplot-axis.tickfont.family-label" for="dotplot-axis.tickfont.family">Tick Label Font</label>
#>             <div id="dotplot-axis.tickfont.family" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="change">
#>               <script type="application/json" data-for="dotplot-axis.tickfont.family">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["Arial","Balto","Courier New","Droid Sans","Droid Serif","Droid Sans Mono","Gravitas One","Old Standard TT","Open Sans","Overpass","PT Sans Narrow","Raleway","Times New Roman","Verdana","sans-serif","serif","monospace"],"value":["Arial","Balto","Courier New","Droid Sans","Droid Serif","Droid Sans Mono","Gravitas One","Old Standard TT","Open Sans","Overpass","PT Sans Narrow","Raleway","Times New Roman","Verdana","sans-serif","serif","monospace"]}},"config":{"multiple":false,"search":true,"selectedValue":"Arial","hideClearButton":true,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":false,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":true,"disableOptionGroupCheckbox":true,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>             </div>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="dotplot-axis.tickangle.x-label" for="dotplot-axis.tickangle.x">X Tick Label Angle</label>
#>             <input id="dotplot-axis.tickangle.x" type="number" class="shiny-input-number form-control" value="0" data-update-on="change" min="-180" max="180" step="15"/>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="dotplot-axis.tickangle.y-label" for="dotplot-axis.tickangle.y">Y Tick Label Angle</label>
#>             <input id="dotplot-axis.tickangle.y" type="number" class="shiny-input-number form-control" value="0" data-update-on="change" min="-180" max="180" step="15"/>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" style="width:100%;">
#>             <label class="control-label" id="dotplot-axis.ticks-label" for="dotplot-axis.ticks">Tick Position</label>
#>             <div id="dotplot-axis.ticks" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="change">
#>               <script type="application/json" data-for="dotplot-axis.ticks">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["Outside","Inside","(none)"],"value":["outside","inside",""]}},"config":{"multiple":false,"search":false,"selectedValue":"outside","hideClearButton":true,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":false,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":true,"disableOptionGroupCheckbox":true,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>             </div>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour">
#>             <label class="control-label" for="dotplot-axis.tickcolor">Tick Mark Color</label>
#>             <input id="dotplot-axis.tickcolor" type="text" class="form-control shiny-colour-input" data-init-value="black" data-show-colour="both" data-palette="square"/>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="dotplot-axis.ticklen-label" for="dotplot-axis.ticklen">Tick Mark Length</label>
#>             <input id="dotplot-axis.ticklen" type="number" class="shiny-input-number form-control" value="5" data-update-on="change" min="0" step="1"/>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="dotplot-axis.tickwidth-label" for="dotplot-axis.tickwidth">Tick Mark Width</label>
#>             <input id="dotplot-axis.tickwidth" type="number" class="shiny-input-number form-control" value="1" data-update-on="change" min="0" step="0.1"/>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="dotplot-facet.title.font.size-label" for="dotplot-facet.title.font.size">Facet Subplot Title Size</label>
#>             <input id="dotplot-facet.title.font.size" type="number" class="shiny-input-number form-control" value="18" data-update-on="change" min="1" step="1"/>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour">
#>             <label class="control-label" for="dotplot-facet.title.font.color">Facet Title Color</label>
#>             <input id="dotplot-facet.title.font.color" type="text" class="form-control shiny-colour-input" data-init-value="#000000" data-show-colour="both" data-palette="square"/>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" style="width:100%;">
#>             <label class="control-label" id="dotplot-facet.title.font.family-label" for="dotplot-facet.title.font.family">Facet Title Font</label>
#>             <div id="dotplot-facet.title.font.family" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="change">
#>               <script type="application/json" data-for="dotplot-facet.title.font.family">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["Arial","Balto","Courier New","Droid Sans","Droid Serif","Droid Sans Mono","Gravitas One","Old Standard TT","Open Sans","Overpass","PT Sans Narrow","Raleway","Times New Roman","Verdana","sans-serif","serif","monospace"],"value":["Arial","Balto","Courier New","Droid Sans","Droid Serif","Droid Sans Mono","Gravitas One","Old Standard TT","Open Sans","Overpass","PT Sans Narrow","Raleway","Times New Roman","Verdana","sans-serif","serif","monospace"]}},"config":{"multiple":false,"search":true,"selectedValue":"Arial","hideClearButton":true,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":false,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":true,"disableOptionGroupCheckbox":true,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>             </div>
#>           </div>
#>         </div>
#>       </div>
#>     </div>
#>     <div class="tab-pane" data-value="Legend" id="tab-5358-5">
#>       <div class="vizmodules-input-grid" style="--viz-input-columns: 2;">
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify2424927">
#>             <label class="control-label" id="dotplot-size.legend.x-label" for="dotplot-size.legend.x">Size Legend X Position</label>
#>             <input id="dotplot-size.legend.x" type="number" class="shiny-input-number form-control" value="1.04" data-update-on="change" step="0.02"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify2424927', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Horizontal position (paper coordinates) of the dot-size legend. Values just above 1 sit to the right of the plot; lower it to pull the legend inward on narrow plots.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify2032089">
#>             <label class="control-label" id="dotplot-size.legend.y-label" for="dotplot-size.legend.y">Size Legend Y Position</label>
#>             <input id="dotplot-size.legend.y" type="number" class="shiny-input-number form-control" value="0.35" data-update-on="change" step="0.05"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify2032089', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Vertical position (paper coordinates) of the dot-size legend. Lower it to clear the colour bar.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify683417">
#>             <div class="material-switch">
#>               <label for="dotplot-legend.show" style="padding-right: 10px;">Show Legend</label>
#>               <input id="dotplot-legend.show" type="checkbox" checked="checked"/>
#>               <label class="switch label-success bg-success" for="dotplot-legend.show"></label>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify683417', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Show the legend. Turning it off also hides colorbars and any point size legend.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" style="width:100%;" id="tipify3072738">
#>             <label class="control-label" id="dotplot-legend.font.family-label" for="dotplot-legend.font.family">Legend Font</label>
#>             <div id="dotplot-legend.font.family" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="change">
#>               <script type="application/json" data-for="dotplot-legend.font.family">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["Arial","Balto","Courier New","Droid Sans","Droid Serif","Droid Sans Mono","Gravitas One","Old Standard TT","Open Sans","Overpass","PT Sans Narrow","Raleway","Times New Roman","Verdana","sans-serif","serif","monospace"],"value":["Arial","Balto","Courier New","Droid Sans","Droid Serif","Droid Sans Mono","Gravitas One","Old Standard TT","Open Sans","Overpass","PT Sans Narrow","Raleway","Times New Roman","Verdana","sans-serif","serif","monospace"]}},"config":{"multiple":false,"search":true,"selectedValue":"Arial","hideClearButton":true,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":false,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":true,"disableOptionGroupCheckbox":true,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify3072738', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Font family of the legend title and entry labels.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour" id="tipify9931180">
#>             <label class="control-label" for="dotplot-legend.font.color">Legend Font Color</label>
#>             <input id="dotplot-legend.font.color" type="text" class="form-control shiny-colour-input" data-init-value="#000000" data-show-colour="both" data-palette="square"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify9931180', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Font color of the legend title and entry labels.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify1163092">
#>             <label class="control-label" id="dotplot-legend.title.size-label" for="dotplot-legend.title.size">Legend Title Size</label>
#>             <input id="dotplot-legend.title.size" type="number" class="shiny-input-number form-control" value="14" data-update-on="change" min="0" step="1"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify1163092', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Font size of the legend title.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify7154231">
#>             <label class="control-label" id="dotplot-legend.text.size-label" for="dotplot-legend.text.size">Legend Text Size</label>
#>             <input id="dotplot-legend.text.size" type="number" class="shiny-input-number form-control" value="12" data-update-on="change" min="0" step="1"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify7154231', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Font size of the legend entry labels.'})}, 500)});</script>
#>         </div>
#>       </div>
#>     </div>
#>     <div class="tab-pane" data-value="Lines" id="tab-5358-6">
#>       <div class="vizmodules-input-grid" style="--viz-input-columns: 2;">
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify2261088">
#>             <label class="control-label" id="dotplot-hline.intercepts-label" for="dotplot-hline.intercepts">Y-intercepts</label>
#>             <input id="dotplot-hline.intercepts" type="text" class="shiny-input-text form-control" value="" placeholder="e.g. 2, -2" data-update-on="change"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify2261088', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'For categorical or factor axes, enter the index (position) of the category rather than its name. For example, if the axis categories are &#39;Audi&#39;, &#39;Mercedes&#39;, &#39;Bugatti&#39;, enter 2 to place a line at &#39;Mercedes&#39;.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify1333486">
#>             <label class="control-label" id="dotplot-hline.colors-label" for="dotplot-hline.colors">Y Colors</label>
#>             <input id="dotplot-hline.colors" type="text" class="shiny-input-text form-control" value="#000000" data-update-on="change"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify1333486', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Color(s) for horizontal reference lines, as comma-separated hex codes or color names'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify9272817">
#>             <label class="control-label" id="dotplot-hline.widths-label" for="dotplot-hline.widths">Y Widths</label>
#>             <input id="dotplot-hline.widths" type="text" class="shiny-input-text form-control" value="1" data-update-on="change"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify9272817', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Width(s) for horizontal reference lines in pixels, as comma-separated values'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify8941226">
#>             <label class="control-label" id="dotplot-hline.linetypes-label" for="dotplot-hline.linetypes">Y Line Types</label>
#>             <input id="dotplot-hline.linetypes" type="text" class="shiny-input-text form-control" value="dashed" placeholder="solid, dashed, dotted, ..." data-update-on="change"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify8941226', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Line style(s) for horizontal reference lines (solid, dashed, dotted, dotdash, longdash, twodash)'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify2036644">
#>             <label class="control-label" id="dotplot-hline.opacities-label" for="dotplot-hline.opacities">Y Opacities (0-1)</label>
#>             <input id="dotplot-hline.opacities" type="text" class="shiny-input-text form-control" value="1" data-update-on="change"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify2036644', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Opacity of horizontal reference lines between 0 (transparent) and 1 (opaque), as comma-separated values'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify2569829">
#>             <label class="control-label" id="dotplot-vline.intercepts-label" for="dotplot-vline.intercepts">X-intercepts</label>
#>             <input id="dotplot-vline.intercepts" type="text" class="shiny-input-text form-control" value="" placeholder="e.g. 2, -2" data-update-on="change"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify2569829', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'For categorical or factor axes, enter the index (position) of the category rather than its name. For example, if the axis categories are &#39;Audi&#39;, &#39;Mercedes&#39;, &#39;Bugatti&#39;, enter 2 to place a line at &#39;Mercedes&#39;.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify6140056">
#>             <label class="control-label" id="dotplot-vline.colors-label" for="dotplot-vline.colors">X Colors</label>
#>             <input id="dotplot-vline.colors" type="text" class="shiny-input-text form-control" value="#000000" data-update-on="change"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify6140056', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Color(s) for vertical reference lines, as comma-separated hex codes or color names'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify4414992">
#>             <label class="control-label" id="dotplot-vline.widths-label" for="dotplot-vline.widths">X Widths</label>
#>             <input id="dotplot-vline.widths" type="text" class="shiny-input-text form-control" value="1" data-update-on="change"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify4414992', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Width(s) for vertical reference lines in pixels, as comma-separated values'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify3155947">
#>             <label class="control-label" id="dotplot-vline.linetypes-label" for="dotplot-vline.linetypes">X Line Types</label>
#>             <input id="dotplot-vline.linetypes" type="text" class="shiny-input-text form-control" value="dashed" placeholder="solid, dashed, dotted, ..." data-update-on="change"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify3155947', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Line style(s) for vertical reference lines (solid, dashed, dotted, dotdash, longdash, twodash)'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify1013138">
#>             <label class="control-label" id="dotplot-vline.opacities-label" for="dotplot-vline.opacities">X Opacities (0-1)</label>
#>             <input id="dotplot-vline.opacities" type="text" class="shiny-input-text form-control" value="1" data-update-on="change"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify1013138', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Opacity of vertical reference lines between 0 (transparent) and 1 (opaque), as comma-separated values'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify2726462">
#>             <label class="control-label" id="dotplot-abline.slopes-label" for="dotplot-abline.slopes">Ab Slopes</label>
#>             <input id="dotplot-abline.slopes" type="text" class="shiny-input-text form-control" value="" data-update-on="change"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify2726462', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Slope(s) of diagonal reference lines (rise/run), as comma-separated values'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify6536994">
#>             <label class="control-label" id="dotplot-abline.intercepts-label" for="dotplot-abline.intercepts">Ab Y-intercepts</label>
#>             <input id="dotplot-abline.intercepts" type="text" class="shiny-input-text form-control" value="" data-update-on="change"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify6536994', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'For categorical or factor axes, enter the index (position) of the category rather than its name. For example, if the axis categories are &#39;Audi&#39;, &#39;Mercedes&#39;, &#39;Bugatti&#39;, enter 2 to place a line at &#39;Mercedes&#39;.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify9278701">
#>             <label class="control-label" id="dotplot-abline.colors-label" for="dotplot-abline.colors">Ab Colors</label>
#>             <input id="dotplot-abline.colors" type="text" class="shiny-input-text form-control" value="#000000" data-update-on="change"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify9278701', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Color(s) for diagonal reference lines, as comma-separated hex codes or color names'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify266247">
#>             <label class="control-label" id="dotplot-abline.widths-label" for="dotplot-abline.widths">Ab Widths</label>
#>             <input id="dotplot-abline.widths" type="text" class="shiny-input-text form-control" value="1" data-update-on="change"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify266247', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Width(s) for diagonal reference lines in pixels, as comma-separated values'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify5594912">
#>             <label class="control-label" id="dotplot-abline.linetypes-label" for="dotplot-abline.linetypes">Ab Line Types</label>
#>             <input id="dotplot-abline.linetypes" type="text" class="shiny-input-text form-control" value="dashed" placeholder="solid, dashed, dotted, ..." data-update-on="change"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify5594912', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Line style(s) for diagonal reference lines (solid, dashed, dotted, dotdash, longdash, twodash)'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify8541736">
#>             <label class="control-label" id="dotplot-abline.opacities-label" for="dotplot-abline.opacities">Ab Opacities (0-1)</label>
#>             <input id="dotplot-abline.opacities" type="text" class="shiny-input-text form-control" value="1" data-update-on="change"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify8541736', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Opacity of diagonal reference lines between 0 (transparent) and 1 (opaque), as comma-separated values'})}, 500)});</script>
#>         </div>
#>       </div>
#>     </div>
#>   </div>
#> </div>
#> <div class="module-tack" style="margin-top: 12px;">
#>   <div class="module-tack-switch" style="margin-bottom: 4px;">
#>     <div class="form-group shiny-input-container">
#>       <div class="material-switch">
#>         <label for="dotplot-auto.update" style="padding-right: 10px;">Auto Update</label>
#>         <input id="dotplot-auto.update" type="checkbox" checked="checked"/>
#>         <label class="switch label-success bg-success" for="dotplot-auto.update"></label>
#>       </div>
#>     </div>
#>   </div>
#>   <div class="module-tack-buttons" style="display: flex; flex-wrap: wrap; gap: 8px;">
#>     <button class="btn btn-default action-button btn-primary" id="dotplot-update" style="flex: 1 1 45%;" type="button"><span class="action-label">Update</span></button>
#>     <button class="btn btn-default action-button btn-secondary" id="dotplot-reset" style="flex: 1 1 45%;" type="button"><span class="action-label">Reset</span></button>
#>     <a aria-disabled="true" class="btn btn-default shiny-download-link disabled btn-secondary viz-source-download" data-viz-source-ns="dotplot-" download href="" id="dotplot-download.source" style="flex: 1 1 100%;" tabindex="-1" target="_blank">
#>       <i class="far fa-file-code" role="presentation" aria-label="file-code icon"></i>
#>       Source Download
#>     </a>
#>     <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('dotplot-download.source', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Download the plot as a self-contained HTML file and as SVG and PNG images of it as it looks now, along with the plot source data and statistics (if applicable) as CSV files.'})}, 500)});</script>
#>   </div>
#> </div>
```
