# Input UI components for the sampleDistanceHeatmap module

This should be placed in the UI where the inputs should be shown, with
an `id` that matches the `id` used in the
[`sampleDistanceHeatmapServer()`](https://j-andrews7.github.io/sciVizModules/reference/sampleDistanceHeatmapServer.md)
and
[`sampleDistanceHeatmapOutputUI()`](https://j-andrews7.github.io/sciVizModules/reference/sampleDistanceHeatmapOutputUI.md)
functions.

## Usage

``` r
sampleDistanceHeatmapInputsUI(
  id,
  data,
  defaults = NULL,
  title = "Sample Distance Settings",
  columns = 2
)
```

## Arguments

- id:

  The ID for the Shiny module.

- data:

  A `SummarizedExperiment` of counts (a `DESeqDataSet` will do).

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

The module draws the sample-to-sample distance heatmap of a bulk
expression experiment, the quality check of the DESeq2 vignette: the
counts of a `SummarizedExperiment` are transformed, the most variable
genes kept, and the Euclidean distances (or Pearson or Spearman
correlations) between samples drawn, with the samples ordered by
hierarchical clustering (complete linkage) of those distances.
Replicates should sit together; an outlier stands apart.

The heatmap is drawn by
[`VizModules::ComplexHeatmap_HeatmapInputsUI()`](https://j-andrews7.github.io/VizModules/reference/ComplexHeatmap_HeatmapInputsUI.html),
so its colour, label and annotation controls all apply; those inputs are
documented there. Every `colData` column is available as a row and a
column annotation; the sample identifier is the `sample` column (the
column key). The base module's own clustering is off, since it would
re-cluster the rows of the distance matrix by their Euclidean distance
rather than use the distances themselves.

**This module is not plotly.** It renders through
InteractiveComplexHeatmap, so the shared plotly tabs do not apply, and
it needs ComplexHeatmap, InteractiveComplexHeatmap and circlize.

## Plot parameters and defaults

The following parameters can be accessed via UI inputs and/or the
`defaults` argument:

- `sd.assay` - Assay (UI: "Assay", default: `"counts"` when present)

- `sd.transform` - Transformation (UI: "Transformation", default:
  `"vst"`, DESeq2's variance-stabilising transformation, when DESeq2 is
  installed, otherwise `"log2cpm"`; also `"log2"` and `"none"`)

- `sd.ntop` - Most variable genes used (UI: "Top Variable Genes",
  default: 500)

- `sd.method` - `"euclidean"`, `"pearson"` or `"spearman"` (UI:
  "Measure", default: `"euclidean"`)

- `sd.order` - `"cluster"` (hierarchical clustering of the distances) or
  `"data"` (the object's order) (UI: "Sample Order", default:
  `"cluster"`)

- Wrapped heatmap defaults set here: `scale = "None"`, clustering off,
  the first two `colData` columns that group samples as column
  annotations, and a blue ramp, dark where samples are close
  (`low_color`, `mid_color`, `high_color`), with the legend titled by
  the measure (`name`). The legend title and ramp follow the measure.

- All other
  [`VizModules::ComplexHeatmap_HeatmapInputsUI()`](https://j-andrews7.github.io/VizModules/reference/ComplexHeatmap_HeatmapInputsUI.html)
  parameters, except `matrix.cols` and `rowname.col`, which the module
  sets

## See also

[`sample_pca()`](https://j-andrews7.github.io/sciVizModules/reference/sample_pca.md),
[`VizModules::ComplexHeatmap_HeatmapInputsUI()`](https://j-andrews7.github.io/VizModules/reference/ComplexHeatmap_HeatmapInputsUI.html),
[`sampleDistanceHeatmapOutputUI()`](https://j-andrews7.github.io/sciVizModules/reference/sampleDistanceHeatmapOutputUI.md),
[`sampleDistanceHeatmapServer()`](https://j-andrews7.github.io/sciVizModules/reference/sampleDistanceHeatmapServer.md),
[`sampleDistanceHeatmapApp()`](https://j-andrews7.github.io/sciVizModules/reference/sampleDistanceHeatmapApp.md)

## Author

Jared Andrews

## Examples

``` r
library(sciVizModules)
if (requireNamespace("ComplexHeatmap", quietly = TRUE) &&
    requireNamespace("airway", quietly = TRUE)) {
    data("airway", package = "airway")
    sampleDistanceHeatmapInputsUI("dist", airway, defaults = list(sd.transform = "log2cpm"))
}
#> <div class="vizmodules-input-grid" style="--viz-input-columns: 2;">
#>   <div class="vizmodules-input-cell">
#>     <div class="form-group shiny-input-container" style="width:100%;" id="tipify6294073">
#>       <label class="control-label" id="dist-sd.assay-label" for="dist-sd.assay">Assay</label>
#>       <div id="dist-sd.assay" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="change">
#>         <script type="application/json" data-for="dist-sd.assay">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["counts"],"value":["counts"]}},"config":{"multiple":false,"search":false,"selectedValue":"counts","hideClearButton":true,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":false,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":true,"disableOptionGroupCheckbox":true,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>       </div>
#>     </div>
#>     <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify6294073', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'The assay the distances are computed from.'})}, 500)});</script>
#>   </div>
#>   <div class="vizmodules-input-cell">
#>     <div class="form-group shiny-input-container" style="width:100%;" id="tipify5232697">
#>       <label class="control-label" id="dist-sd.transform-label" for="dist-sd.transform">Transformation</label>
#>       <div id="dist-sd.transform" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="change">
#>         <script type="application/json" data-for="dist-sd.transform">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["Variance stabilised (DESeq2)","log2 CPM","log2(x + 1)","None (assay as is)"],"value":["vst","log2cpm","log2","none"]}},"config":{"multiple":false,"search":false,"selectedValue":"log2cpm","hideClearButton":true,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":false,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":true,"disableOptionGroupCheckbox":true,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>       </div>
#>     </div>
#>     <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify5232697', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'How counts are transformed first. Variance stabilisation (DESeq2) or log2 CPM for raw counts; None for an assay that is already on a log scale.'})}, 500)});</script>
#>   </div>
#>   <div class="vizmodules-input-cell">
#>     <div class="form-group shiny-input-container" id="tipify3931054">
#>       <label class="control-label" id="dist-sd.ntop-label" for="dist-sd.ntop">Top Variable Genes</label>
#>       <input id="dist-sd.ntop" type="number" class="shiny-input-number form-control" value="500" data-update-on="change" min="2" step="50"/>
#>     </div>
#>     <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify3931054', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'The most variable genes the distances are computed from.'})}, 500)});</script>
#>   </div>
#>   <div class="vizmodules-input-cell">
#>     <div class="form-group shiny-input-container" style="width:100%;" id="tipify8778933">
#>       <label class="control-label" id="dist-sd.method-label" for="dist-sd.method">Measure</label>
#>       <div id="dist-sd.method" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="change">
#>         <script type="application/json" data-for="dist-sd.method">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["Euclidean distance","Pearson correlation","Spearman correlation"],"value":["euclidean","pearson","spearman"]}},"config":{"multiple":false,"search":false,"selectedValue":"euclidean","hideClearButton":true,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":false,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":true,"disableOptionGroupCheckbox":true,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>       </div>
#>     </div>
#>     <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify8778933', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Euclidean distance, or the Pearson or Spearman correlation, between samples.'})}, 500)});</script>
#>   </div>
#>   <div class="vizmodules-input-cell">
#>     <div class="form-group shiny-input-container" style="width:100%;" id="tipify2882499">
#>       <label class="control-label" id="dist-sd.order-label" for="dist-sd.order">Sample Order</label>
#>       <div id="dist-sd.order" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="change">
#>         <script type="application/json" data-for="dist-sd.order">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["Clustered","As in the data"],"value":["cluster","data"]}},"config":{"multiple":false,"search":false,"selectedValue":"cluster","hideClearButton":true,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":false,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":true,"disableOptionGroupCheckbox":true,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>       </div>
#>     </div>
#>     <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify2882499', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Order the samples by hierarchical clustering (complete linkage) of the distances, or keep their order.'})}, 500)});</script>
#>   </div>
#> </div>
#> <h3>Sample Distance Settings</h3>
#> <div class="tabbable vizmodules-input-tabs">
#>   <ul class="nav nav-tabs shiny-tab-input" id="dist-HeatmapTabsetPanel" data-tabsetid="9759">
#>     <li class="active">
#>       <a href="#tab-9759-1" data-toggle="tab" data-bs-toggle="tab" data-value="Matrix">Matrix</a>
#>     </li>
#>     <li>
#>       <a href="#tab-9759-2" data-toggle="tab" data-bs-toggle="tab" data-value="Filter">Filter</a>
#>     </li>
#>     <li>
#>       <a href="#tab-9759-3" data-toggle="tab" data-bs-toggle="tab" data-value="Colors">Colors</a>
#>     </li>
#>     <li>
#>       <a href="#tab-9759-4" data-toggle="tab" data-bs-toggle="tab" data-value="Clustering">Clustering</a>
#>     </li>
#>     <li>
#>       <a href="#tab-9759-5" data-toggle="tab" data-bs-toggle="tab" data-value="Labels">Labels</a>
#>     </li>
#>     <li>
#>       <a href="#tab-9759-6" data-toggle="tab" data-bs-toggle="tab" data-value="Annotations">Annotations</a>
#>     </li>
#>   </ul>
#>   <div class="tab-content" data-tabsetid="9759">
#>     <div class="tab-pane active" data-value="Matrix" id="tab-9759-1">
#>       <div class="vizmodules-input-grid" style="--viz-input-columns: 2;">
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" style="width:100%;" id="tipify6321782">
#>             <label class="control-label" id="dist-matrix.cols-label" for="dist-matrix.cols">Matrix Columns</label>
#>             <div id="dist-matrix.cols" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="close">
#>               <script type="application/json" data-for="dist-matrix.cols">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["avgLength","SRR1039516","SRR1039517","SRR1039520","SRR1039521","SRR1039508","SRR1039512","SRR1039509","SRR1039513"],"value":["avgLength","SRR1039516","SRR1039517","SRR1039520","SRR1039521","SRR1039508","SRR1039512","SRR1039509","SRR1039513"]}},"config":{"multiple":true,"search":false,"selectedValue":["SRR1039516","SRR1039517","SRR1039520","SRR1039521","SRR1039508","SRR1039512","SRR1039509","SRR1039513"],"hideClearButton":false,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":false,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":false,"disableOptionGroupCheckbox":false,"disabled":false,"dropboxWrapper":"body","zIndex":1060,"alwaysShowSelectedOptionsCount":true,"optionsSelectedText":"columns shown","optionSelectedText":"column shown"}}</script>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify6321782', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Numeric columns that form the heatmap matrix'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" style="width:100%;" id="tipify3130251">
#>             <label class="control-label" id="dist-rowname.col-label" for="dist-rowname.col">Row Name Column</label>
#>             <div id="dist-rowname.col" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="change">
#>               <script type="application/json" data-for="dist-rowname.col">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["(none)","sample","SampleName","cell","dex","albut","Run","Experiment","Sample","BioSample"],"value":["","sample","SampleName","cell","dex","albut","Run","Experiment","Sample","BioSample"]}},"config":{"multiple":false,"search":false,"selectedValue":"sample","hideClearButton":true,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":false,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":true,"disableOptionGroupCheckbox":true,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify3130251', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Optional column whose values are used as row names'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify1458228">
#>             <label class="control-label" id="dist-name-label" for="dist-name">Heatmap Name</label>
#>             <input id="dist-name" type="text" class="shiny-input-text form-control" value="Distance" data-update-on="change"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify1458228', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Name of the heatmap, used as the legend title'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour" id="tipify8205009">
#>             <label class="control-label" for="dist-na_col">NA Color</label>
#>             <input id="dist-na_col" type="text" class="form-control shiny-colour-input" data-init-value="grey" data-show-colour="both" data-palette="square"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify8205009', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Color used for NA cells'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" style="width:100%;" id="tipify7456198">
#>             <label class="control-label" id="dist-scale-label" for="dist-scale">Scale</label>
#>             <div id="dist-scale" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="change">
#>               <script type="application/json" data-for="dist-scale">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["None","Rows","Columns"],"value":["None","Rows","Columns"]}},"config":{"multiple":false,"search":false,"selectedValue":"None","hideClearButton":true,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":false,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":true,"disableOptionGroupCheckbox":true,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify7456198', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Z-score the matrix by row or column before plotting (a constant row/column becomes 0)'})}, 500)});</script>
#>         </div>
#>       </div>
#>     </div>
#>     <div class="tab-pane" data-value="Filter" id="tab-9759-2">
#>       <div class="vizmodules-input-grid" style="--viz-input-columns: 2;">
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify6778734">
#>             <label class="control-label" id="dist-row_filter-label" for="dist-row_filter">Row Filter</label>
#>             <input id="dist-row_filter" type="text" class="shiny-input-text form-control" value="" data-update-on="change"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify6778734', 'tooltip', {'container': 'body', 'placement': 'bottom', 'trigger': 'hover', 'title': 'Keep only the rows matching this expression, e.g. pathway == &#39;Immune&#39;, or grepl(&#39;^RP&#39;, gene). Leave blank to keep every row. Fields: sample, SampleName, cell, dex, albut, Run, avgLength, Experiment, Sample, BioSample, SRR1039516, SRR1039517, SRR1039520, SRR1039521, SRR1039508, SRR1039512, SRR1039509, SRR1039513. Available: comparisons, & | !, %in%, is.na(), arithmetic, and grepl/startsWith/endsWith/substr/nchar/toupper/tolower/trimws. Filtering happens before scaling, so a Z-score describes only what is shown.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify2051377">
#>             <label class="control-label" id="dist-column_filter-label" for="dist-column_filter">Column Filter</label>
#>             <input id="dist-column_filter" type="text" class="shiny-input-text form-control" value="" data-update-on="change"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify2051377', 'tooltip', {'container': 'body', 'placement': 'bottom', 'trigger': 'hover', 'title': 'Keep only the matrix columns matching this expression, e.g. condition == &#39;Disease&#39;, or startsWith(column, &#39;Healthy&#39;). Leave blank to keep every column. Fields: column, sample, SampleName, cell, dex, albut, Run, avgLength, Experiment, Sample, BioSample. Available: comparisons, & | !, %in%, is.na(), arithmetic, and grepl/startsWith/endsWith/substr/nchar/toupper/tolower/trimws. Filtering happens before scaling, so a Z-score describes only what is shown.'})}, 500)});</script>
#>         </div>
#>       </div>
#>     </div>
#>     <div class="tab-pane" data-value="Colors" id="tab-9759-3">
#>       <div class="vizmodules-input-grid" style="--viz-input-columns: 2;">
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour" id="tipify9919730">
#>             <label class="control-label" for="dist-low_color">Low Color</label>
#>             <input id="dist-low_color" type="text" class="form-control shiny-colour-input" data-init-value="#08306B" data-show-colour="both" data-palette="square"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify9919730', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Color for the lowest (or Min Value) end of the scale'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify6689565">
#>             <label class="control-label" id="dist-min_value-label" for="dist-min_value">Min Value</label>
#>             <input id="dist-min_value" type="number" class="shiny-input-number form-control" value="NA" data-update-on="change"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify6689565', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Value mapped to the Low Color (blank = the matrix minimum)'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour" id="tipify7538819">
#>             <label class="control-label" for="dist-mid_color">Mid Color</label>
#>             <input id="dist-mid_color" type="text" class="form-control shiny-colour-input" data-init-value="#6BAED6" data-show-colour="both" data-palette="square"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify7538819', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Color for the midpoint of the scale'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify6451980">
#>             <label class="control-label" id="dist-mid_value-label" for="dist-mid_value">Mid Value</label>
#>             <input id="dist-mid_value" type="number" class="shiny-input-number form-control" value="NA" data-update-on="change"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify6451980', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Value mapped to the Mid Color (blank = the midpoint between Min and Max Value; set to 0 to center a z-scored matrix)'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour" id="tipify1051662">
#>             <label class="control-label" for="dist-high_color">High Color</label>
#>             <input id="dist-high_color" type="text" class="form-control shiny-colour-input" data-init-value="#F7FBFF" data-show-colour="both" data-palette="square"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify1051662', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Color for the highest (or Max Value) end of the scale'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify498049">
#>             <label class="control-label" id="dist-max_value-label" for="dist-max_value">Max Value</label>
#>             <input id="dist-max_value" type="number" class="shiny-input-number form-control" value="NA" data-update-on="change"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify498049', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Value mapped to the High Color (blank = the matrix maximum)'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify5507951">
#>             <div class="checkbox">
#>               <label>
#>                 <input id="dist-reverse.palette" type="checkbox" class="shiny-input-checkbox"/>
#>                 <span>Reverse Palette</span>
#>               </label>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify5507951', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Reverse the direction of the color scheme'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify272054">
#>             <div class="checkbox">
#>               <label>
#>                 <input id="dist-show_heatmap_legend" type="checkbox" class="shiny-input-checkbox" checked="checked"/>
#>                 <span>Show Legend</span>
#>               </label>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify272054', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Show the heatmap color legend'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify1872581">
#>             <div class="checkbox">
#>               <label>
#>                 <input id="dist-border" type="checkbox" class="shiny-input-checkbox"/>
#>                 <span>Border</span>
#>               </label>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify1872581', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Draw a border around the heatmap body'})}, 500)});</script>
#>         </div>
#>       </div>
#>     </div>
#>     <div class="tab-pane" data-value="Clustering" id="tab-9759-4">
#>       <div class="vizmodules-input-grid" style="--viz-input-columns: 2;">
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify6483364">
#>             <div class="checkbox">
#>               <label>
#>                 <input id="dist-cluster_rows" type="checkbox" class="shiny-input-checkbox"/>
#>                 <span>Cluster Rows</span>
#>               </label>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify6483364', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Perform hierarchical clustering on rows'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify8247190">
#>             <div class="checkbox">
#>               <label>
#>                 <input id="dist-cluster_columns" type="checkbox" class="shiny-input-checkbox"/>
#>                 <span>Cluster Columns</span>
#>               </label>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify8247190', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Perform hierarchical clustering on columns'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" style="width:100%;" id="tipify9155435">
#>             <label class="control-label" id="dist-clustering_distance_rows-label" for="dist-clustering_distance_rows">Row Distance</label>
#>             <div id="dist-clustering_distance_rows" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="change">
#>               <script type="application/json" data-for="dist-clustering_distance_rows">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["euclidean","maximum","manhattan","canberra","binary","minkowski","pearson","spearman","kendall"],"value":["euclidean","maximum","manhattan","canberra","binary","minkowski","pearson","spearman","kendall"]}},"config":{"multiple":false,"search":false,"selectedValue":"euclidean","hideClearButton":true,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":false,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":true,"disableOptionGroupCheckbox":true,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify9155435', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Distance metric for row clustering'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" style="width:100%;" id="tipify8255570">
#>             <label class="control-label" id="dist-clustering_distance_columns-label" for="dist-clustering_distance_columns">Column Distance</label>
#>             <div id="dist-clustering_distance_columns" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="change">
#>               <script type="application/json" data-for="dist-clustering_distance_columns">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["euclidean","maximum","manhattan","canberra","binary","minkowski","pearson","spearman","kendall"],"value":["euclidean","maximum","manhattan","canberra","binary","minkowski","pearson","spearman","kendall"]}},"config":{"multiple":false,"search":false,"selectedValue":"euclidean","hideClearButton":true,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":false,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":true,"disableOptionGroupCheckbox":true,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify8255570', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Distance metric for column clustering'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" style="width:100%;" id="tipify7955550">
#>             <label class="control-label" id="dist-clustering_method_rows-label" for="dist-clustering_method_rows">Row Method</label>
#>             <div id="dist-clustering_method_rows" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="change">
#>               <script type="application/json" data-for="dist-clustering_method_rows">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["complete","average","single","ward.D","ward.D2","mcquitty","median","centroid"],"value":["complete","average","single","ward.D","ward.D2","mcquitty","median","centroid"]}},"config":{"multiple":false,"search":false,"selectedValue":"complete","hideClearButton":true,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":false,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":true,"disableOptionGroupCheckbox":true,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify7955550', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Linkage method for row clustering'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" style="width:100%;" id="tipify6881147">
#>             <label class="control-label" id="dist-clustering_method_columns-label" for="dist-clustering_method_columns">Column Method</label>
#>             <div id="dist-clustering_method_columns" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="change">
#>               <script type="application/json" data-for="dist-clustering_method_columns">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["complete","average","single","ward.D","ward.D2","mcquitty","median","centroid"],"value":["complete","average","single","ward.D","ward.D2","mcquitty","median","centroid"]}},"config":{"multiple":false,"search":false,"selectedValue":"complete","hideClearButton":true,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":false,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":true,"disableOptionGroupCheckbox":true,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify6881147', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Linkage method for column clustering'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify3386629">
#>             <div class="checkbox">
#>               <label>
#>                 <input id="dist-show_row_dend" type="checkbox" class="shiny-input-checkbox"/>
#>                 <span>Show Row Dendrogram</span>
#>               </label>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify3386629', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Show the row dendrogram'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify4683029">
#>             <div class="checkbox">
#>               <label>
#>                 <input id="dist-show_column_dend" type="checkbox" class="shiny-input-checkbox"/>
#>                 <span>Show Column Dendrogram</span>
#>               </label>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify4683029', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Show the column dendrogram'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" style="width:100%;" id="tipify8369869">
#>             <label class="control-label" id="dist-row_split_by-label" for="dist-row_split_by">Row Split Method</label>
#>             <div id="dist-row_split_by" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="change">
#>               <script type="application/json" data-for="dist-row_split_by">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["None","K-means","Hierarchical","Annotation"],"value":["None","K-means","Hierarchical","Annotation"]}},"config":{"multiple":false,"search":false,"selectedValue":"None","hideClearButton":true,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":false,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":true,"disableOptionGroupCheckbox":true,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify8369869', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'How to split rows into groups: k-means, or hierarchical (cutting the row dendrogram)'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify7704877">
#>             <label class="control-label" id="dist-row_split_n-label" for="dist-row_split_n">Row Groups</label>
#>             <input id="dist-row_split_n" type="number" class="shiny-input-number form-control" value="NA" data-update-on="change" min="2" step="1"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify7704877', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Number of row groups (used when Row Split Method is &#39;K-means&#39; or &#39;Hierarchical&#39;)'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" style="width:100%;" id="tipify5956799">
#>             <label class="control-label" id="dist-row_split_cols-label" for="dist-row_split_cols">Row Split Columns</label>
#>             <div id="dist-row_split_cols" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="close">
#>               <script type="application/json" data-for="dist-row_split_cols">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["SampleName","cell","dex","albut","Run","avgLength","Experiment","Sample","BioSample"],"value":["SampleName","cell","dex","albut","Run","avgLength","Experiment","Sample","BioSample"]}},"config":{"multiple":true,"search":false,"selectedValue":[],"hideClearButton":false,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":true,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":false,"disableOptionGroupCheckbox":false,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify5956799', 'tooltip', {'container': 'body', 'placement': 'bottom', 'trigger': 'hover', 'title': 'Columns whose values group the rows (used when Row Split Method is &#39;Annotation&#39;). Several columns give nested slices, one per observed combination.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" style="width:100%;" id="tipify5965282">
#>             <label class="control-label" id="dist-column_split_by-label" for="dist-column_split_by">Column Split Method</label>
#>             <div id="dist-column_split_by" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="change">
#>               <script type="application/json" data-for="dist-column_split_by">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["None","K-means","Hierarchical","Annotation"],"value":["None","K-means","Hierarchical","Annotation"]}},"config":{"multiple":false,"search":false,"selectedValue":"None","hideClearButton":true,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":false,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":true,"disableOptionGroupCheckbox":true,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify5965282', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'How to split columns into groups: k-means, or hierarchical (cutting the column dendrogram)'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify1741410">
#>             <label class="control-label" id="dist-column_split_n-label" for="dist-column_split_n">Column Groups</label>
#>             <input id="dist-column_split_n" type="number" class="shiny-input-number form-control" value="NA" data-update-on="change" min="2" step="1"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify1741410', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Number of column groups (used when Column Split Method is &#39;K-means&#39; or &#39;Hierarchical&#39;)'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" style="width:100%;" id="tipify4756676">
#>             <label class="control-label" id="dist-column_split_cols-label" for="dist-column_split_cols">Column Split Columns</label>
#>             <div id="dist-column_split_cols" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="close">
#>               <script type="application/json" data-for="dist-column_split_cols">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["SampleName","cell","dex","albut","Run","avgLength","Experiment","Sample","BioSample"],"value":["SampleName","cell","dex","albut","Run","avgLength","Experiment","Sample","BioSample"]}},"config":{"multiple":true,"search":false,"selectedValue":[],"hideClearButton":false,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":true,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":false,"disableOptionGroupCheckbox":false,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify4756676', 'tooltip', {'container': 'body', 'placement': 'bottom', 'trigger': 'hover', 'title': 'Columns of the sample-metadata table whose values group the heatmap columns (used when Column Split Method is &#39;Annotation&#39;). Several give nested slices.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify9339482">
#>             <label class="control-label" id="dist-row_gap-label" for="dist-row_gap">Row Gap (mm)</label>
#>             <input id="dist-row_gap" type="number" class="shiny-input-number form-control" value="1" data-update-on="change" min="0" step="0.5"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify9339482', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Gap between row slices in millimeters (used when Row Split Method is not &#39;None&#39;)'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify595375">
#>             <label class="control-label" id="dist-column_gap-label" for="dist-column_gap">Column Gap (mm)</label>
#>             <input id="dist-column_gap" type="number" class="shiny-input-number form-control" value="1" data-update-on="change" min="0" step="0.5"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify595375', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Gap between column slices in millimeters (used when Column Split Method is not &#39;None&#39;)'})}, 500)});</script>
#>         </div>
#>       </div>
#>     </div>
#>     <div class="tab-pane" data-value="Labels" id="tab-9759-5">
#>       <div class="vizmodules-input-grid" style="--viz-input-columns: 2;">
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify1432455">
#>             <label class="control-label" id="dist-row_title-label" for="dist-row_title">Row Title</label>
#>             <input id="dist-row_title" type="text" class="shiny-input-text form-control" value="" data-update-on="change"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify1432455', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Title placed alongside the rows'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify4267803">
#>             <label class="control-label" id="dist-column_title-label" for="dist-column_title">Column Title</label>
#>             <input id="dist-column_title" type="text" class="shiny-input-text form-control" value="" data-update-on="change"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify4267803', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Title placed alongside the columns'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify5644536">
#>             <div class="checkbox">
#>               <label>
#>                 <input id="dist-show_row_slice_titles" type="checkbox" class="shiny-input-checkbox" checked="checked"/>
#>                 <span>Show Row Slice Titles</span>
#>               </label>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify5644536', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Title each row slice with its group name when the rows are split. Ignored if Row Title is set, which replaces the group names (use %s in it for each group&#39;s name).'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify1872995">
#>             <div class="checkbox">
#>               <label>
#>                 <input id="dist-show_column_slice_titles" type="checkbox" class="shiny-input-checkbox" checked="checked"/>
#>                 <span>Show Column Slice Titles</span>
#>               </label>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify1872995', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Title each column slice with its group name when the columns are split. Ignored if Column Title is set, which replaces the group names (use %s in it for each group&#39;s name).'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify6027495">
#>             <div class="checkbox">
#>               <label>
#>                 <input id="dist-show_row_names" type="checkbox" class="shiny-input-checkbox" checked="checked"/>
#>                 <span>Show Row Names</span>
#>               </label>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify6027495', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Show row names'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify7348783">
#>             <div class="checkbox">
#>               <label>
#>                 <input id="dist-show_column_names" type="checkbox" class="shiny-input-checkbox" checked="checked"/>
#>                 <span>Show Column Names</span>
#>               </label>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify7348783', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Show column names'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" style="width:100%;" id="tipify683489">
#>             <label class="control-label" id="dist-row_names_side-label" for="dist-row_names_side">Row Names Side</label>
#>             <div id="dist-row_names_side" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="change">
#>               <script type="application/json" data-for="dist-row_names_side">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["right","left"],"value":["right","left"]}},"config":{"multiple":false,"search":false,"selectedValue":"right","hideClearButton":true,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":false,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":true,"disableOptionGroupCheckbox":true,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify683489', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Which side to place row names'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" style="width:100%;" id="tipify7829179">
#>             <label class="control-label" id="dist-column_names_side-label" for="dist-column_names_side">Column Names Side</label>
#>             <div id="dist-column_names_side" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="change">
#>               <script type="application/json" data-for="dist-column_names_side">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["bottom","top"],"value":["bottom","top"]}},"config":{"multiple":false,"search":false,"selectedValue":"bottom","hideClearButton":true,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":false,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":true,"disableOptionGroupCheckbox":true,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify7829179', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Which side to place column names'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify9214927">
#>             <label class="control-label" id="dist-column_names_rot-label" for="dist-column_names_rot">Column Name Rotation</label>
#>             <input id="dist-column_names_rot" type="number" class="shiny-input-number form-control" value="90" data-update-on="change" step="15"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify9214927', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Rotation angle for column names'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify442822">
#>             <label class="control-label" id="dist-row_names_fontsize-label" for="dist-row_names_fontsize">Row Name Size</label>
#>             <input id="dist-row_names_fontsize" type="number" class="shiny-input-number form-control" value="12" data-update-on="change" min="1" step="0.5"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify442822', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Font size for row names'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify7131148">
#>             <label class="control-label" id="dist-column_names_fontsize-label" for="dist-column_names_fontsize">Column Name Size</label>
#>             <input id="dist-column_names_fontsize" type="number" class="shiny-input-number form-control" value="12" data-update-on="change" min="1" step="0.5"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify7131148', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Font size for column names'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify9038860">
#>             <label class="control-label" id="dist-title_fontsize-label" for="dist-title_fontsize">Title Size</label>
#>             <input id="dist-title_fontsize" type="number" class="shiny-input-number form-control" value="13.2" data-update-on="change" min="1" step="0.5"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify9038860', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Font size for row and column titles'})}, 500)});</script>
#>         </div>
#>       </div>
#>     </div>
#>     <div class="tab-pane" data-value="Annotations" id="tab-9759-6">
#>       <div class="vizmodules-input-grid" style="--viz-input-columns: 2;">
#>         <div class="vizmodules-input-cell">
#>           <div class="multi-dynamic-input shiny-input-container form-group " id="dist-row_annotations" data-keys="[&quot;column&quot;,&quot;side&quot;,&quot;label_side&quot;,&quot;label_size&quot;,&quot;show_legend&quot;]" data-initial="[]" data-input-id="dist-row_annotations" data-row-prefix="row annotations">
#>             <div class="mdi-top">
#>               <label class="control-label" for="dist-row_annotations">Row Annotations</label>
#>               <button type="button" class="mdi-add btn btn-default btn-sm">+ Add</button>
#>             </div>
#>             <div class="mdi-rows"></div>
#>             <template class="mdi-row-template">
#>               <div class="mdi-row">
#>                 <div class="mdi-fields">
#>                   <div class="mdi-field" data-key="column" style="flex: 1 1 calc(50% - 8px); min-width: 120px;">
#>                     <div class="form-group shiny-input-container">
#>                       <label class="control-label" id="dist-row_annotations-__ROWIDX__-column-label" for="dist-row_annotations-__ROWIDX__-column">Column</label>
#>                       <div>
#>                         <select id="dist-row_annotations-__ROWIDX__-column" class="shiny-input-select"><option value="SampleName" selected>SampleName</option>
#> <option value="cell">cell</option>
#> <option value="dex">dex</option>
#> <option value="albut">albut</option>
#> <option value="Run">Run</option>
#> <option value="avgLength">avgLength</option>
#> <option value="Experiment">Experiment</option>
#> <option value="Sample">Sample</option>
#> <option value="BioSample">BioSample</option></select>
#>                         <script type="application/json" data-for="dist-row_annotations-__ROWIDX__-column" data-nonempty="">{"plugins":["selectize-plugin-a11y"]}</script>
#>                       </div>
#>                     </div>
#>                   </div>
#>                   <div class="mdi-field" data-key="side" style="flex: 1 1 calc(50% - 8px); min-width: 120px;">
#>                     <div class="form-group shiny-input-container">
#>                       <label class="control-label" id="dist-row_annotations-__ROWIDX__-side-label" for="dist-row_annotations-__ROWIDX__-side">Side</label>
#>                       <div>
#>                         <select id="dist-row_annotations-__ROWIDX__-side" class="shiny-input-select"><option value="Left" selected>Left</option>
#> <option value="Right">Right</option></select>
#>                         <script type="application/json" data-for="dist-row_annotations-__ROWIDX__-side" data-nonempty="">{"plugins":["selectize-plugin-a11y"]}</script>
#>                       </div>
#>                     </div>
#>                   </div>
#>                   <div class="mdi-field" data-key="label_side" style="flex: 1 1 calc(50% - 8px); min-width: 120px;">
#>                     <div class="form-group shiny-input-container">
#>                       <label class="control-label" id="dist-row_annotations-__ROWIDX__-label_side-label" for="dist-row_annotations-__ROWIDX__-label_side">Label Side</label>
#>                       <div>
#>                         <select id="dist-row_annotations-__ROWIDX__-label_side" class="shiny-input-select"><option value="Bottom" selected>Bottom</option>
#> <option value="Top">Top</option></select>
#>                         <script type="application/json" data-for="dist-row_annotations-__ROWIDX__-label_side" data-nonempty="">{"plugins":["selectize-plugin-a11y"]}</script>
#>                       </div>
#>                     </div>
#>                   </div>
#>                   <div class="mdi-field" data-key="label_size" style="flex: 1 1 calc(50% - 8px); min-width: 120px;">
#>                     <div class="form-group shiny-input-container">
#>                       <label class="control-label" id="dist-row_annotations-__ROWIDX__-label_size-label" for="dist-row_annotations-__ROWIDX__-label_size">Label Size</label>
#>                       <input id="dist-row_annotations-__ROWIDX__-label_size" type="number" class="shiny-input-number form-control" value="10" data-update-on="change" min="1" step="0.5"/>
#>                     </div>
#>                   </div>
#>                   <div class="mdi-field" data-key="show_legend" style="flex: 1 1 calc(50% - 8px); min-width: 120px;">
#>                     <div class="form-group shiny-input-container">
#>                       <div class="checkbox">
#>                         <label>
#>                           <input id="dist-row_annotations-__ROWIDX__-show_legend" type="checkbox" class="shiny-input-checkbox" checked="checked"/>
#>                           <span>Show Legend</span>
#>                         </label>
#>                       </div>
#>                     </div>
#>                   </div>
#>                 </div>
#>                 <button type="button" class="mdi-delete" title="Delete this row" aria-label="Delete this row">&times;</button>
#>               </div>
#>             </template>
#>           </div>
#>           <div id="dist-row_annotation_colors_ui" class="shiny-html-output"></div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" style="width:100%;" id="tipify7395815">
#>             <label class="control-label" id="dist-column_key-label" for="dist-column_key">Column Key</label>
#>             <div id="dist-column_key" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="change">
#>               <script type="application/json" data-for="dist-column_key">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["sample","SampleName","cell","dex","albut","Run","avgLength","Experiment","Sample","BioSample"],"value":["sample","SampleName","cell","dex","albut","Run","avgLength","Experiment","Sample","BioSample"]}},"config":{"multiple":false,"search":false,"selectedValue":"sample","hideClearButton":true,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":false,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":true,"disableOptionGroupCheckbox":true,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify7395815', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Column in the column-annotation table that matches the heatmap&#39;s sample column names'})}, 500)});</script>
#>           <div class="multi-dynamic-input shiny-input-container form-group " id="dist-column_annotations" data-keys="[&quot;column&quot;,&quot;side&quot;,&quot;label_side&quot;,&quot;label_size&quot;,&quot;show_legend&quot;]" data-initial="[{&quot;fields&quot;:[{&quot;key&quot;:&quot;column&quot;,&quot;value&quot;:&quot;cell&quot;},{&quot;key&quot;:&quot;side&quot;,&quot;value&quot;:&quot;Top&quot;},{&quot;key&quot;:&quot;label_side&quot;,&quot;value&quot;:&quot;Right&quot;},{&quot;key&quot;:&quot;label_size&quot;,&quot;value&quot;:10},{&quot;key&quot;:&quot;show_legend&quot;,&quot;value&quot;:true}]},{&quot;fields&quot;:[{&quot;key&quot;:&quot;column&quot;,&quot;value&quot;:&quot;dex&quot;},{&quot;key&quot;:&quot;side&quot;,&quot;value&quot;:&quot;Top&quot;},{&quot;key&quot;:&quot;label_side&quot;,&quot;value&quot;:&quot;Right&quot;},{&quot;key&quot;:&quot;label_size&quot;,&quot;value&quot;:10},{&quot;key&quot;:&quot;show_legend&quot;,&quot;value&quot;:true}]}]" data-input-id="dist-column_annotations" data-row-prefix="column annotations">
#>             <div class="mdi-top">
#>               <label class="control-label" for="dist-column_annotations">Column Annotations</label>
#>               <button type="button" class="mdi-add btn btn-default btn-sm">+ Add</button>
#>             </div>
#>             <div class="mdi-rows"></div>
#>             <template class="mdi-row-template">
#>               <div class="mdi-row">
#>                 <div class="mdi-fields">
#>                   <div class="mdi-field" data-key="column" style="flex: 1 1 calc(50% - 8px); min-width: 120px;">
#>                     <div class="form-group shiny-input-container">
#>                       <label class="control-label" id="dist-column_annotations-__ROWIDX__-column-label" for="dist-column_annotations-__ROWIDX__-column">Column</label>
#>                       <div>
#>                         <select id="dist-column_annotations-__ROWIDX__-column" class="shiny-input-select"><option value="SampleName" selected>SampleName</option>
#> <option value="cell">cell</option>
#> <option value="dex">dex</option>
#> <option value="albut">albut</option>
#> <option value="Run">Run</option>
#> <option value="avgLength">avgLength</option>
#> <option value="Experiment">Experiment</option>
#> <option value="Sample">Sample</option>
#> <option value="BioSample">BioSample</option></select>
#>                         <script type="application/json" data-for="dist-column_annotations-__ROWIDX__-column" data-nonempty="">{"plugins":["selectize-plugin-a11y"]}</script>
#>                       </div>
#>                     </div>
#>                   </div>
#>                   <div class="mdi-field" data-key="side" style="flex: 1 1 calc(50% - 8px); min-width: 120px;">
#>                     <div class="form-group shiny-input-container">
#>                       <label class="control-label" id="dist-column_annotations-__ROWIDX__-side-label" for="dist-column_annotations-__ROWIDX__-side">Side</label>
#>                       <div>
#>                         <select id="dist-column_annotations-__ROWIDX__-side" class="shiny-input-select"><option value="Top" selected>Top</option>
#> <option value="Bottom">Bottom</option></select>
#>                         <script type="application/json" data-for="dist-column_annotations-__ROWIDX__-side" data-nonempty="">{"plugins":["selectize-plugin-a11y"]}</script>
#>                       </div>
#>                     </div>
#>                   </div>
#>                   <div class="mdi-field" data-key="label_side" style="flex: 1 1 calc(50% - 8px); min-width: 120px;">
#>                     <div class="form-group shiny-input-container">
#>                       <label class="control-label" id="dist-column_annotations-__ROWIDX__-label_side-label" for="dist-column_annotations-__ROWIDX__-label_side">Label Side</label>
#>                       <div>
#>                         <select id="dist-column_annotations-__ROWIDX__-label_side" class="shiny-input-select"><option value="Right" selected>Right</option>
#> <option value="Left">Left</option></select>
#>                         <script type="application/json" data-for="dist-column_annotations-__ROWIDX__-label_side" data-nonempty="">{"plugins":["selectize-plugin-a11y"]}</script>
#>                       </div>
#>                     </div>
#>                   </div>
#>                   <div class="mdi-field" data-key="label_size" style="flex: 1 1 calc(50% - 8px); min-width: 120px;">
#>                     <div class="form-group shiny-input-container">
#>                       <label class="control-label" id="dist-column_annotations-__ROWIDX__-label_size-label" for="dist-column_annotations-__ROWIDX__-label_size">Label Size</label>
#>                       <input id="dist-column_annotations-__ROWIDX__-label_size" type="number" class="shiny-input-number form-control" value="10" data-update-on="change" min="1" step="0.5"/>
#>                     </div>
#>                   </div>
#>                   <div class="mdi-field" data-key="show_legend" style="flex: 1 1 calc(50% - 8px); min-width: 120px;">
#>                     <div class="form-group shiny-input-container">
#>                       <div class="checkbox">
#>                         <label>
#>                           <input id="dist-column_annotations-__ROWIDX__-show_legend" type="checkbox" class="shiny-input-checkbox" checked="checked"/>
#>                           <span>Show Legend</span>
#>                         </label>
#>                       </div>
#>                     </div>
#>                   </div>
#>                 </div>
#>                 <button type="button" class="mdi-delete" title="Delete this row" aria-label="Delete this row">&times;</button>
#>               </div>
#>             </template>
#>           </div>
#>           <div id="dist-column_annotation_colors_ui" class="shiny-html-output"></div>
#>         </div>
#>       </div>
#>     </div>
#>   </div>
#> </div>
#> <div class="module-tack" style="margin-top: 12px;">
#>   <div class="module-tack-switch" style="margin-bottom: 4px;">
#>     <div class="form-group shiny-input-container">
#>       <div class="material-switch">
#>         <label for="dist-auto.update" style="padding-right: 10px;">Auto Update</label>
#>         <input id="dist-auto.update" type="checkbox" checked="checked"/>
#>         <label class="switch label-success bg-success" for="dist-auto.update"></label>
#>       </div>
#>     </div>
#>   </div>
#>   <div class="module-tack-buttons" style="display: flex; flex-wrap: wrap; gap: 8px;">
#>     <button class="btn btn-default action-button btn-primary" id="dist-update" style="flex: 1 1 45%;" type="button"><span class="action-label">Update</span></button>
#>     <button class="btn btn-default action-button btn-secondary" id="dist-reset" style="flex: 1 1 45%;" type="button"><span class="action-label">Reset</span></button>
#>     <a aria-disabled="true" class="btn btn-default shiny-download-link disabled btn-secondary viz-source-download" data-viz-source-ns="dist-" download href="" id="dist-download.source" style="flex: 1 1 100%;" tabindex="-1" target="_blank">
#>       <i class="far fa-file-code" role="presentation" aria-label="file-code icon"></i>
#>       Source Download
#>     </a>
#>     <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('dist-download.source', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Download the plot as a self-contained HTML file and as SVG and PNG images of it as it looks now, along with the plot source data and statistics (if applicable) as CSV files.'})}, 500)});</script>
#>   </div>
#> </div>
```
