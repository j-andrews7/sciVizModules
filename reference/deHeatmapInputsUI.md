# Input UI components for the deHeatmap module

This should be placed in the UI where the inputs should be shown, with
an `id` that matches the `id` used in the
[`deHeatmapServer()`](https://j-andrews7.github.io/sciVizModules/reference/deHeatmapServer.md)
and
[`deHeatmapOutputUI()`](https://j-andrews7.github.io/sciVizModules/reference/deHeatmapOutputUI.md)
functions.

## Usage

``` r
deHeatmapInputsUI(
  id,
  data,
  defaults = NULL,
  title = "DE Heatmap Settings",
  columns = 2
)
```

## Arguments

- id:

  The ID for the Shiny module.

- data:

  `list(object = <SummarizedExperiment>, results = <data frame>)`, or a
  `SummarizedExperiment` whose `rowData` holds the results.

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

The module draws the heatmap of the top differentially expressed genes
of a bulk experiment: genes passing adjusted p-value and fold-change
cut-offs are ranked, the top ones taken from the transformed counts, and
shown as per-gene z-scores across the samples, split into up- and
down-regulated blocks with the sample metadata as annotations.

`data` is a list holding the experiment and its results,
`list(object = <SummarizedExperiment>, results = <data frame>)`, where
the results are a DESeq2 `results()` table (a `DataFrame` will do), an
edgeR `topTags()` table, a limma `topTable()` or any table with an
adjusted p-value and a log2 fold change per gene; or a
`SummarizedExperiment` whose `rowData` carries those columns. Results
are matched to the experiment's genes through its row names, by the
results' row names or an identifier column.

The heatmap is drawn by
[`VizModules::ComplexHeatmap_HeatmapInputsUI()`](https://j-andrews7.github.io/VizModules/reference/ComplexHeatmap_HeatmapInputsUI.html),
so its scaling, clustering, colour, label and annotation controls all
apply; those inputs are documented there. The rows carry `direction`
("Up"/"Down") and `log2FC` as row annotations; every `colData` column is
available as a column annotation, keyed by the `sample` column.

**This module is not plotly.** It renders through
InteractiveComplexHeatmap, so the shared plotly tabs do not apply, and
it needs ComplexHeatmap, InteractiveComplexHeatmap and circlize.

## Plot parameters and defaults

The following parameters can be accessed via UI inputs and/or the
`defaults` argument:

- `de.id.col` - Results column matching the experiment's row names, or
  `""` for the results' row names (UI: "Gene ID Column", default:
  whichever matches best)

- `de.label.col` - Results column labelling the rows, or `""` for the
  identifier (UI: "Gene Label Column", default: `symbol` or similar when
  present)

- `de.padj.col`, `de.lfc.col` - Adjusted p-value and log2 fold change
  columns (UI: "Adj. P-value Column", "Log2 FC Column"; default:
  recognised DESeq2, edgeR, limma or Seurat names)

- `de.padj.cutoff` - Keep genes with an adjusted p-value below this (UI:
  "Adj. P-value Cut-off", default: 0.05)

- `de.lfc.cutoff` - Keep genes with an absolute log2 fold change of at
  least this (UI: "\|Log2 FC\| Cut-off", default: 1)

- `de.top.n` - The most genes to show (UI: "Top Genes", default: 50)

- `de.rank.by` - `"padj"` (most significant first) or `"lfc"` (largest
  fold change first) (UI: "Rank By", default: `"padj"`)

- `de.direction` - `"both"`, `"up"` or `"down"` (UI: "Direction",
  default: `"both"`)

- `de.assay`, `de.transform` - Assay and transformation, as for
  [`sampleDistanceHeatmapInputsUI()`](https://j-andrews7.github.io/sciVizModules/reference/sampleDistanceHeatmapInputsUI.md)
  (default: `"counts"`, and `"vst"` when DESeq2 is installed, otherwise
  `"log2cpm"`)

- Wrapped heatmap defaults set here: `scale = "Rows"` (per-gene
  z-scores), the `direction` row annotation on the left with the rows
  split by it, the first two `colData` columns that group samples as
  column annotations, row labels at size 8, and `direction` colours
  `c(Up = "#B2182B", Down = "#2166AC")`

- All other
  [`VizModules::ComplexHeatmap_HeatmapInputsUI()`](https://j-andrews7.github.io/VizModules/reference/ComplexHeatmap_HeatmapInputsUI.html)
  parameters, except `matrix.cols` and `rowname.col`, which the module
  sets

## See also

[`VizModules::ComplexHeatmap_HeatmapInputsUI()`](https://j-andrews7.github.io/VizModules/reference/ComplexHeatmap_HeatmapInputsUI.html),
[`deHeatmapOutputUI()`](https://j-andrews7.github.io/sciVizModules/reference/deHeatmapOutputUI.md),
[`deHeatmapServer()`](https://j-andrews7.github.io/sciVizModules/reference/deHeatmapServer.md),
[`deHeatmapApp()`](https://j-andrews7.github.io/sciVizModules/reference/deHeatmapApp.md)

## Author

Jared Andrews

## Examples

``` r
library(sciVizModules)
data(airway_deseq2)
if (requireNamespace("ComplexHeatmap", quietly = TRUE) &&
    requireNamespace("airway", quietly = TRUE)) {
    data("airway", package = "airway")
    deHeatmapInputsUI("de", list(object = airway, results = airway_deseq2),
        defaults = list(de.transform = "log2cpm"))
}
#> <div class="vizmodules-input-grid" style="--viz-input-columns: 2;">
#>   <div class="vizmodules-input-cell">
#>     <div class="form-group shiny-input-container" style="width:100%;" id="tipify940304">
#>       <label class="control-label" id="de-de.id.col-label" for="de-de.id.col">Gene ID Column</label>
#>       <div id="de-de.id.col" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="change">
#>         <script type="application/json" data-for="de-de.id.col">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["(none)","ensembl","symbol"],"value":["","ensembl","symbol"]}},"config":{"multiple":false,"search":false,"selectedValue":"","hideClearButton":true,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":false,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":true,"disableOptionGroupCheckbox":true,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>       </div>
#>     </div>
#>     <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify940304', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Results column whose values match the experiment&#39;s row names.'})}, 500)});</script>
#>   </div>
#>   <div class="vizmodules-input-cell">
#>     <div class="form-group shiny-input-container" style="width:100%;" id="tipify6965836">
#>       <label class="control-label" id="de-de.label.col-label" for="de-de.label.col">Gene Label Column</label>
#>       <div id="de-de.label.col" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="change">
#>         <script type="application/json" data-for="de-de.label.col">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["(none)","ensembl","symbol"],"value":["","ensembl","symbol"]}},"config":{"multiple":false,"search":false,"selectedValue":"symbol","hideClearButton":true,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":false,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":true,"disableOptionGroupCheckbox":true,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>       </div>
#>     </div>
#>     <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify6965836', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Results column used to label the rows, e.g. gene symbols.'})}, 500)});</script>
#>   </div>
#>   <div class="vizmodules-input-cell">
#>     <div class="form-group shiny-input-container" style="width:100%;" id="tipify4057287">
#>       <label class="control-label" id="de-de.padj.col-label" for="de-de.padj.col">Adj. P-value Column</label>
#>       <div id="de-de.padj.col" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="change">
#>         <script type="application/json" data-for="de-de.padj.col">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["baseMean","log2FoldChange","lfcSE","stat","pvalue","padj"],"value":["baseMean","log2FoldChange","lfcSE","stat","pvalue","padj"]}},"config":{"multiple":false,"search":false,"selectedValue":"padj","hideClearButton":true,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":false,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":true,"disableOptionGroupCheckbox":true,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>       </div>
#>     </div>
#>     <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify4057287', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Adjusted p-value (FDR) column of the results.'})}, 500)});</script>
#>   </div>
#>   <div class="vizmodules-input-cell">
#>     <div class="form-group shiny-input-container" style="width:100%;" id="tipify656367">
#>       <label class="control-label" id="de-de.lfc.col-label" for="de-de.lfc.col">Log2 FC Column</label>
#>       <div id="de-de.lfc.col" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="change">
#>         <script type="application/json" data-for="de-de.lfc.col">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["baseMean","log2FoldChange","lfcSE","stat","pvalue","padj"],"value":["baseMean","log2FoldChange","lfcSE","stat","pvalue","padj"]}},"config":{"multiple":false,"search":false,"selectedValue":"log2FoldChange","hideClearButton":true,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":false,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":true,"disableOptionGroupCheckbox":true,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>       </div>
#>     </div>
#>     <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify656367', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Log2 fold change column of the results.'})}, 500)});</script>
#>   </div>
#>   <div class="vizmodules-input-cell">
#>     <div class="form-group shiny-input-container" id="tipify1264927">
#>       <label class="control-label" id="de-de.padj.cutoff-label" for="de-de.padj.cutoff">Adj. P-value Cut-off</label>
#>       <input id="de-de.padj.cutoff" type="number" class="shiny-input-number form-control" value="0.05" data-update-on="change" min="0" max="1" step="0.01"/>
#>     </div>
#>     <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify1264927', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Keep genes with an adjusted p-value below this.'})}, 500)});</script>
#>   </div>
#>   <div class="vizmodules-input-cell">
#>     <div class="form-group shiny-input-container" id="tipify9373302">
#>       <label class="control-label" id="de-de.lfc.cutoff-label" for="de-de.lfc.cutoff">|Log2 FC| Cut-off</label>
#>       <input id="de-de.lfc.cutoff" type="number" class="shiny-input-number form-control" value="1" data-update-on="change" min="0" step="0.25"/>
#>     </div>
#>     <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify9373302', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Keep genes with an absolute log2 fold change of at least this.'})}, 500)});</script>
#>   </div>
#>   <div class="vizmodules-input-cell">
#>     <div class="form-group shiny-input-container" id="tipify2163803">
#>       <label class="control-label" id="de-de.top.n-label" for="de-de.top.n">Top Genes</label>
#>       <input id="de-de.top.n" type="number" class="shiny-input-number form-control" value="50" data-update-on="change" min="2" step="5"/>
#>     </div>
#>     <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify2163803', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'The most genes to show.'})}, 500)});</script>
#>   </div>
#>   <div class="vizmodules-input-cell">
#>     <div class="form-group shiny-input-container" style="width:100%;" id="tipify6660920">
#>       <label class="control-label" id="de-de.rank.by-label" for="de-de.rank.by">Rank By</label>
#>       <div id="de-de.rank.by" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="change">
#>         <script type="application/json" data-for="de-de.rank.by">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["Adjusted p-value","|Log2 fold change|"],"value":["padj","lfc"]}},"config":{"multiple":false,"search":false,"selectedValue":"padj","hideClearButton":true,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":false,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":true,"disableOptionGroupCheckbox":true,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>       </div>
#>     </div>
#>     <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify6660920', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Which genes count as the top ones.'})}, 500)});</script>
#>   </div>
#>   <div class="vizmodules-input-cell">
#>     <div class="form-group shiny-input-container" style="width:100%;" id="tipify2039007">
#>       <label class="control-label" id="de-de.direction-label" for="de-de.direction">Direction</label>
#>       <div id="de-de.direction" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="change">
#>         <script type="application/json" data-for="de-de.direction">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["Up and down","Up only","Down only"],"value":["both","up","down"]}},"config":{"multiple":false,"search":false,"selectedValue":"both","hideClearButton":true,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":false,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":true,"disableOptionGroupCheckbox":true,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>       </div>
#>     </div>
#>     <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify2039007', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Show up-regulated genes, down-regulated genes, or both.'})}, 500)});</script>
#>   </div>
#>   <div class="vizmodules-input-cell">
#>     <div class="form-group shiny-input-container" style="width:100%;" id="tipify5485914">
#>       <label class="control-label" id="de-de.assay-label" for="de-de.assay">Assay</label>
#>       <div id="de-de.assay" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="change">
#>         <script type="application/json" data-for="de-de.assay">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["counts"],"value":["counts"]}},"config":{"multiple":false,"search":false,"selectedValue":"counts","hideClearButton":true,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":false,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":true,"disableOptionGroupCheckbox":true,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>       </div>
#>     </div>
#>     <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify5485914', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'The assay the expression values are taken from.'})}, 500)});</script>
#>   </div>
#>   <div class="vizmodules-input-cell">
#>     <div class="form-group shiny-input-container" style="width:100%;" id="tipify8275014">
#>       <label class="control-label" id="de-de.transform-label" for="de-de.transform">Transformation</label>
#>       <div id="de-de.transform" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="change">
#>         <script type="application/json" data-for="de-de.transform">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["Variance stabilised (DESeq2)","log2 CPM","log2(x + 1)","None (assay as is)"],"value":["vst","log2cpm","log2","none"]}},"config":{"multiple":false,"search":false,"selectedValue":"log2cpm","hideClearButton":true,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":false,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":true,"disableOptionGroupCheckbox":true,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>       </div>
#>     </div>
#>     <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify8275014', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'How counts are transformed before the rows are scaled.'})}, 500)});</script>
#>   </div>
#> </div>
#> <h3>DE Heatmap Settings</h3>
#> <div class="tabbable vizmodules-input-tabs">
#>   <ul class="nav nav-tabs shiny-tab-input" id="de-HeatmapTabsetPanel" data-tabsetid="9147">
#>     <li class="active">
#>       <a href="#tab-9147-1" data-toggle="tab" data-bs-toggle="tab" data-value="Matrix">Matrix</a>
#>     </li>
#>     <li>
#>       <a href="#tab-9147-2" data-toggle="tab" data-bs-toggle="tab" data-value="Filter">Filter</a>
#>     </li>
#>     <li>
#>       <a href="#tab-9147-3" data-toggle="tab" data-bs-toggle="tab" data-value="Colors">Colors</a>
#>     </li>
#>     <li>
#>       <a href="#tab-9147-4" data-toggle="tab" data-bs-toggle="tab" data-value="Clustering">Clustering</a>
#>     </li>
#>     <li>
#>       <a href="#tab-9147-5" data-toggle="tab" data-bs-toggle="tab" data-value="Labels">Labels</a>
#>     </li>
#>     <li>
#>       <a href="#tab-9147-6" data-toggle="tab" data-bs-toggle="tab" data-value="Annotations">Annotations</a>
#>     </li>
#>   </ul>
#>   <div class="tab-content" data-tabsetid="9147">
#>     <div class="tab-pane active" data-value="Matrix" id="tab-9147-1">
#>       <div class="vizmodules-input-grid" style="--viz-input-columns: 2;">
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" style="width:100%;" id="tipify1275577">
#>             <label class="control-label" id="de-matrix.cols-label" for="de-matrix.cols">Matrix Columns</label>
#>             <div id="de-matrix.cols" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="close">
#>               <script type="application/json" data-for="de-matrix.cols">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["log2FC","SRR1039508","SRR1039509","SRR1039512","SRR1039513","SRR1039516","SRR1039517","SRR1039520","SRR1039521"],"value":["log2FC","SRR1039508","SRR1039509","SRR1039512","SRR1039513","SRR1039516","SRR1039517","SRR1039520","SRR1039521"]}},"config":{"multiple":true,"search":false,"selectedValue":["SRR1039508","SRR1039509","SRR1039512","SRR1039513","SRR1039516","SRR1039517","SRR1039520","SRR1039521"],"hideClearButton":false,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":false,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":false,"disableOptionGroupCheckbox":false,"disabled":false,"dropboxWrapper":"body","zIndex":1060,"alwaysShowSelectedOptionsCount":true,"optionsSelectedText":"columns shown","optionSelectedText":"column shown"}}</script>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify1275577', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Numeric columns that form the heatmap matrix'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" style="width:100%;" id="tipify2611861">
#>             <label class="control-label" id="de-rowname.col-label" for="de-rowname.col">Row Name Column</label>
#>             <div id="de-rowname.col" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="change">
#>               <script type="application/json" data-for="de-rowname.col">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["(none)","gene","direction"],"value":["","gene","direction"]}},"config":{"multiple":false,"search":false,"selectedValue":"gene","hideClearButton":true,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":false,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":true,"disableOptionGroupCheckbox":true,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify2611861', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Optional column whose values are used as row names'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify2884170">
#>             <label class="control-label" id="de-name-label" for="de-name">Heatmap Name</label>
#>             <input id="de-name" type="text" class="shiny-input-text form-control" value="Expression" data-update-on="change"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify2884170', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Name of the heatmap, used as the legend title'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour" id="tipify147691">
#>             <label class="control-label" for="de-na_col">NA Color</label>
#>             <input id="de-na_col" type="text" class="form-control shiny-colour-input" data-init-value="grey" data-show-colour="both" data-palette="square"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify147691', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Color used for NA cells'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" style="width:100%;" id="tipify8537237">
#>             <label class="control-label" id="de-scale-label" for="de-scale">Scale</label>
#>             <div id="de-scale" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="change">
#>               <script type="application/json" data-for="de-scale">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["None","Rows","Columns"],"value":["None","Rows","Columns"]}},"config":{"multiple":false,"search":false,"selectedValue":"Rows","hideClearButton":true,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":false,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":true,"disableOptionGroupCheckbox":true,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify8537237', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Z-score the matrix by row or column before plotting (a constant row/column becomes 0)'})}, 500)});</script>
#>         </div>
#>       </div>
#>     </div>
#>     <div class="tab-pane" data-value="Filter" id="tab-9147-2">
#>       <div class="vizmodules-input-grid" style="--viz-input-columns: 2;">
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify4140478">
#>             <label class="control-label" id="de-row_filter-label" for="de-row_filter">Row Filter</label>
#>             <input id="de-row_filter" type="text" class="shiny-input-text form-control" value="" data-update-on="change"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify4140478', 'tooltip', {'container': 'body', 'placement': 'bottom', 'trigger': 'hover', 'title': 'Keep only the rows matching this expression, e.g. pathway == &#39;Immune&#39;, or grepl(&#39;^RP&#39;, gene). Leave blank to keep every row. Fields: gene, direction, log2FC, SRR1039508, SRR1039509, SRR1039512, SRR1039513, SRR1039516, SRR1039517, SRR1039520, SRR1039521. Available: comparisons, & | !, %in%, is.na(), arithmetic, and grepl/startsWith/endsWith/substr/nchar/toupper/tolower/trimws. Filtering happens before scaling, so a Z-score describes only what is shown.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify7510138">
#>             <label class="control-label" id="de-column_filter-label" for="de-column_filter">Column Filter</label>
#>             <input id="de-column_filter" type="text" class="shiny-input-text form-control" value="" data-update-on="change"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify7510138', 'tooltip', {'container': 'body', 'placement': 'bottom', 'trigger': 'hover', 'title': 'Keep only the matrix columns matching this expression, e.g. condition == &#39;Disease&#39;, or startsWith(column, &#39;Healthy&#39;). Leave blank to keep every column. Fields: column, sample, SampleName, cell, dex, albut, Run, avgLength, Experiment, Sample, BioSample. Available: comparisons, & | !, %in%, is.na(), arithmetic, and grepl/startsWith/endsWith/substr/nchar/toupper/tolower/trimws. Filtering happens before scaling, so a Z-score describes only what is shown.'})}, 500)});</script>
#>         </div>
#>       </div>
#>     </div>
#>     <div class="tab-pane" data-value="Colors" id="tab-9147-3">
#>       <div class="vizmodules-input-grid" style="--viz-input-columns: 2;">
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour" id="tipify7190139">
#>             <label class="control-label" for="de-low_color">Low Color</label>
#>             <input id="de-low_color" type="text" class="form-control shiny-colour-input" data-init-value="#2166AC" data-show-colour="both" data-palette="square"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify7190139', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Color for the lowest (or Min Value) end of the scale'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify5153553">
#>             <label class="control-label" id="de-min_value-label" for="de-min_value">Min Value</label>
#>             <input id="de-min_value" type="number" class="shiny-input-number form-control" value="NA" data-update-on="change"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify5153553', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Value mapped to the Low Color (blank = the matrix minimum)'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour" id="tipify9748362">
#>             <label class="control-label" for="de-mid_color">Mid Color</label>
#>             <input id="de-mid_color" type="text" class="form-control shiny-colour-input" data-init-value="#F7F7F7" data-show-colour="both" data-palette="square"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify9748362', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Color for the midpoint of the scale'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify3607776">
#>             <label class="control-label" id="de-mid_value-label" for="de-mid_value">Mid Value</label>
#>             <input id="de-mid_value" type="number" class="shiny-input-number form-control" value="NA" data-update-on="change"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify3607776', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Value mapped to the Mid Color (blank = the midpoint between Min and Max Value; set to 0 to center a z-scored matrix)'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour" id="tipify1703955">
#>             <label class="control-label" for="de-high_color">High Color</label>
#>             <input id="de-high_color" type="text" class="form-control shiny-colour-input" data-init-value="#B2182B" data-show-colour="both" data-palette="square"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify1703955', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Color for the highest (or Max Value) end of the scale'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify7831406">
#>             <label class="control-label" id="de-max_value-label" for="de-max_value">Max Value</label>
#>             <input id="de-max_value" type="number" class="shiny-input-number form-control" value="NA" data-update-on="change"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify7831406', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Value mapped to the High Color (blank = the matrix maximum)'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify309239">
#>             <div class="checkbox">
#>               <label>
#>                 <input id="de-reverse.palette" type="checkbox" class="shiny-input-checkbox"/>
#>                 <span>Reverse Palette</span>
#>               </label>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify309239', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Reverse the direction of the color scheme'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify7894203">
#>             <div class="checkbox">
#>               <label>
#>                 <input id="de-show_heatmap_legend" type="checkbox" class="shiny-input-checkbox" checked="checked"/>
#>                 <span>Show Legend</span>
#>               </label>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify7894203', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Show the heatmap color legend'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify1666037">
#>             <div class="checkbox">
#>               <label>
#>                 <input id="de-border" type="checkbox" class="shiny-input-checkbox"/>
#>                 <span>Border</span>
#>               </label>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify1666037', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Draw a border around the heatmap body'})}, 500)});</script>
#>         </div>
#>       </div>
#>     </div>
#>     <div class="tab-pane" data-value="Clustering" id="tab-9147-4">
#>       <div class="vizmodules-input-grid" style="--viz-input-columns: 2;">
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify287126">
#>             <div class="checkbox">
#>               <label>
#>                 <input id="de-cluster_rows" type="checkbox" class="shiny-input-checkbox" checked="checked"/>
#>                 <span>Cluster Rows</span>
#>               </label>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify287126', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Perform hierarchical clustering on rows'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify7859511">
#>             <div class="checkbox">
#>               <label>
#>                 <input id="de-cluster_columns" type="checkbox" class="shiny-input-checkbox" checked="checked"/>
#>                 <span>Cluster Columns</span>
#>               </label>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify7859511', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Perform hierarchical clustering on columns'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" style="width:100%;" id="tipify8253078">
#>             <label class="control-label" id="de-clustering_distance_rows-label" for="de-clustering_distance_rows">Row Distance</label>
#>             <div id="de-clustering_distance_rows" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="change">
#>               <script type="application/json" data-for="de-clustering_distance_rows">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["euclidean","maximum","manhattan","canberra","binary","minkowski","pearson","spearman","kendall"],"value":["euclidean","maximum","manhattan","canberra","binary","minkowski","pearson","spearman","kendall"]}},"config":{"multiple":false,"search":false,"selectedValue":"euclidean","hideClearButton":true,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":false,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":true,"disableOptionGroupCheckbox":true,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify8253078', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Distance metric for row clustering'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" style="width:100%;" id="tipify9652404">
#>             <label class="control-label" id="de-clustering_distance_columns-label" for="de-clustering_distance_columns">Column Distance</label>
#>             <div id="de-clustering_distance_columns" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="change">
#>               <script type="application/json" data-for="de-clustering_distance_columns">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["euclidean","maximum","manhattan","canberra","binary","minkowski","pearson","spearman","kendall"],"value":["euclidean","maximum","manhattan","canberra","binary","minkowski","pearson","spearman","kendall"]}},"config":{"multiple":false,"search":false,"selectedValue":"euclidean","hideClearButton":true,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":false,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":true,"disableOptionGroupCheckbox":true,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify9652404', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Distance metric for column clustering'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" style="width:100%;" id="tipify3786412">
#>             <label class="control-label" id="de-clustering_method_rows-label" for="de-clustering_method_rows">Row Method</label>
#>             <div id="de-clustering_method_rows" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="change">
#>               <script type="application/json" data-for="de-clustering_method_rows">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["complete","average","single","ward.D","ward.D2","mcquitty","median","centroid"],"value":["complete","average","single","ward.D","ward.D2","mcquitty","median","centroid"]}},"config":{"multiple":false,"search":false,"selectedValue":"complete","hideClearButton":true,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":false,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":true,"disableOptionGroupCheckbox":true,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify3786412', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Linkage method for row clustering'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" style="width:100%;" id="tipify1743864">
#>             <label class="control-label" id="de-clustering_method_columns-label" for="de-clustering_method_columns">Column Method</label>
#>             <div id="de-clustering_method_columns" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="change">
#>               <script type="application/json" data-for="de-clustering_method_columns">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["complete","average","single","ward.D","ward.D2","mcquitty","median","centroid"],"value":["complete","average","single","ward.D","ward.D2","mcquitty","median","centroid"]}},"config":{"multiple":false,"search":false,"selectedValue":"complete","hideClearButton":true,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":false,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":true,"disableOptionGroupCheckbox":true,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify1743864', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Linkage method for column clustering'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify6037504">
#>             <div class="checkbox">
#>               <label>
#>                 <input id="de-show_row_dend" type="checkbox" class="shiny-input-checkbox" checked="checked"/>
#>                 <span>Show Row Dendrogram</span>
#>               </label>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify6037504', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Show the row dendrogram'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify8054637">
#>             <div class="checkbox">
#>               <label>
#>                 <input id="de-show_column_dend" type="checkbox" class="shiny-input-checkbox" checked="checked"/>
#>                 <span>Show Column Dendrogram</span>
#>               </label>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify8054637', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Show the column dendrogram'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" style="width:100%;" id="tipify366795">
#>             <label class="control-label" id="de-row_split_by-label" for="de-row_split_by">Row Split Method</label>
#>             <div id="de-row_split_by" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="change">
#>               <script type="application/json" data-for="de-row_split_by">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["None","K-means","Hierarchical","Annotation"],"value":["None","K-means","Hierarchical","Annotation"]}},"config":{"multiple":false,"search":false,"selectedValue":"Annotation","hideClearButton":true,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":false,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":true,"disableOptionGroupCheckbox":true,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify366795', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'How to split rows into groups: k-means, or hierarchical (cutting the row dendrogram)'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify7329106">
#>             <label class="control-label" id="de-row_split_n-label" for="de-row_split_n">Row Groups</label>
#>             <input id="de-row_split_n" type="number" class="shiny-input-number form-control" value="NA" data-update-on="change" min="2" step="1"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify7329106', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Number of row groups (used when Row Split Method is &#39;K-means&#39; or &#39;Hierarchical&#39;)'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" style="width:100%;" id="tipify2152727">
#>             <label class="control-label" id="de-row_split_cols-label" for="de-row_split_cols">Row Split Columns</label>
#>             <div id="de-row_split_cols" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="close">
#>               <script type="application/json" data-for="de-row_split_cols">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["direction","log2FC"],"value":["direction","log2FC"]}},"config":{"multiple":true,"search":false,"selectedValue":"direction","hideClearButton":false,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":true,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":false,"disableOptionGroupCheckbox":false,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify2152727', 'tooltip', {'container': 'body', 'placement': 'bottom', 'trigger': 'hover', 'title': 'Columns whose values group the rows (used when Row Split Method is &#39;Annotation&#39;). Several columns give nested slices, one per observed combination.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" style="width:100%;" id="tipify160032">
#>             <label class="control-label" id="de-column_split_by-label" for="de-column_split_by">Column Split Method</label>
#>             <div id="de-column_split_by" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="change">
#>               <script type="application/json" data-for="de-column_split_by">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["None","K-means","Hierarchical","Annotation"],"value":["None","K-means","Hierarchical","Annotation"]}},"config":{"multiple":false,"search":false,"selectedValue":"None","hideClearButton":true,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":false,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":true,"disableOptionGroupCheckbox":true,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify160032', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'How to split columns into groups: k-means, or hierarchical (cutting the column dendrogram)'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify1286026">
#>             <label class="control-label" id="de-column_split_n-label" for="de-column_split_n">Column Groups</label>
#>             <input id="de-column_split_n" type="number" class="shiny-input-number form-control" value="NA" data-update-on="change" min="2" step="1"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify1286026', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Number of column groups (used when Column Split Method is &#39;K-means&#39; or &#39;Hierarchical&#39;)'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" style="width:100%;" id="tipify6860631">
#>             <label class="control-label" id="de-column_split_cols-label" for="de-column_split_cols">Column Split Columns</label>
#>             <div id="de-column_split_cols" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="close">
#>               <script type="application/json" data-for="de-column_split_cols">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["SampleName","cell","dex","albut","Run","avgLength","Experiment","Sample","BioSample"],"value":["SampleName","cell","dex","albut","Run","avgLength","Experiment","Sample","BioSample"]}},"config":{"multiple":true,"search":false,"selectedValue":[],"hideClearButton":false,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":true,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":false,"disableOptionGroupCheckbox":false,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify6860631', 'tooltip', {'container': 'body', 'placement': 'bottom', 'trigger': 'hover', 'title': 'Columns of the sample-metadata table whose values group the heatmap columns (used when Column Split Method is &#39;Annotation&#39;). Several give nested slices.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify6419413">
#>             <label class="control-label" id="de-row_gap-label" for="de-row_gap">Row Gap (mm)</label>
#>             <input id="de-row_gap" type="number" class="shiny-input-number form-control" value="1" data-update-on="change" min="0" step="0.5"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify6419413', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Gap between row slices in millimeters (used when Row Split Method is not &#39;None&#39;)'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify3273385">
#>             <label class="control-label" id="de-column_gap-label" for="de-column_gap">Column Gap (mm)</label>
#>             <input id="de-column_gap" type="number" class="shiny-input-number form-control" value="1" data-update-on="change" min="0" step="0.5"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify3273385', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Gap between column slices in millimeters (used when Column Split Method is not &#39;None&#39;)'})}, 500)});</script>
#>         </div>
#>       </div>
#>     </div>
#>     <div class="tab-pane" data-value="Labels" id="tab-9147-5">
#>       <div class="vizmodules-input-grid" style="--viz-input-columns: 2;">
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify3874820">
#>             <label class="control-label" id="de-row_title-label" for="de-row_title">Row Title</label>
#>             <input id="de-row_title" type="text" class="shiny-input-text form-control" value="" data-update-on="change"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify3874820', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Title placed alongside the rows'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify7075004">
#>             <label class="control-label" id="de-column_title-label" for="de-column_title">Column Title</label>
#>             <input id="de-column_title" type="text" class="shiny-input-text form-control" value="" data-update-on="change"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify7075004', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Title placed alongside the columns'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify6976554">
#>             <div class="checkbox">
#>               <label>
#>                 <input id="de-show_row_slice_titles" type="checkbox" class="shiny-input-checkbox"/>
#>                 <span>Show Row Slice Titles</span>
#>               </label>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify6976554', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Title each row slice with its group name when the rows are split. Ignored if Row Title is set, which replaces the group names (use %s in it for each group&#39;s name).'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify9256567">
#>             <div class="checkbox">
#>               <label>
#>                 <input id="de-show_column_slice_titles" type="checkbox" class="shiny-input-checkbox" checked="checked"/>
#>                 <span>Show Column Slice Titles</span>
#>               </label>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify9256567', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Title each column slice with its group name when the columns are split. Ignored if Column Title is set, which replaces the group names (use %s in it for each group&#39;s name).'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify4590177">
#>             <div class="checkbox">
#>               <label>
#>                 <input id="de-show_row_names" type="checkbox" class="shiny-input-checkbox" checked="checked"/>
#>                 <span>Show Row Names</span>
#>               </label>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify4590177', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Show row names'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify5959542">
#>             <div class="checkbox">
#>               <label>
#>                 <input id="de-show_column_names" type="checkbox" class="shiny-input-checkbox" checked="checked"/>
#>                 <span>Show Column Names</span>
#>               </label>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify5959542', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Show column names'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" style="width:100%;" id="tipify1650110">
#>             <label class="control-label" id="de-row_names_side-label" for="de-row_names_side">Row Names Side</label>
#>             <div id="de-row_names_side" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="change">
#>               <script type="application/json" data-for="de-row_names_side">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["right","left"],"value":["right","left"]}},"config":{"multiple":false,"search":false,"selectedValue":"right","hideClearButton":true,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":false,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":true,"disableOptionGroupCheckbox":true,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify1650110', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Which side to place row names'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" style="width:100%;" id="tipify5669098">
#>             <label class="control-label" id="de-column_names_side-label" for="de-column_names_side">Column Names Side</label>
#>             <div id="de-column_names_side" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="change">
#>               <script type="application/json" data-for="de-column_names_side">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["bottom","top"],"value":["bottom","top"]}},"config":{"multiple":false,"search":false,"selectedValue":"bottom","hideClearButton":true,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":false,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":true,"disableOptionGroupCheckbox":true,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify5669098', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Which side to place column names'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify8980773">
#>             <label class="control-label" id="de-column_names_rot-label" for="de-column_names_rot">Column Name Rotation</label>
#>             <input id="de-column_names_rot" type="number" class="shiny-input-number form-control" value="90" data-update-on="change" step="15"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify8980773', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Rotation angle for column names'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify5944723">
#>             <label class="control-label" id="de-row_names_fontsize-label" for="de-row_names_fontsize">Row Name Size</label>
#>             <input id="de-row_names_fontsize" type="number" class="shiny-input-number form-control" value="8" data-update-on="change" min="1" step="0.5"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify5944723', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Font size for row names'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify8316899">
#>             <label class="control-label" id="de-column_names_fontsize-label" for="de-column_names_fontsize">Column Name Size</label>
#>             <input id="de-column_names_fontsize" type="number" class="shiny-input-number form-control" value="12" data-update-on="change" min="1" step="0.5"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify8316899', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Font size for column names'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify5934084">
#>             <label class="control-label" id="de-title_fontsize-label" for="de-title_fontsize">Title Size</label>
#>             <input id="de-title_fontsize" type="number" class="shiny-input-number form-control" value="13.2" data-update-on="change" min="1" step="0.5"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify5934084', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Font size for row and column titles'})}, 500)});</script>
#>         </div>
#>       </div>
#>     </div>
#>     <div class="tab-pane" data-value="Annotations" id="tab-9147-6">
#>       <div class="vizmodules-input-grid" style="--viz-input-columns: 2;">
#>         <div class="vizmodules-input-cell">
#>           <div class="multi-dynamic-input shiny-input-container form-group " id="de-row_annotations" data-keys="[&quot;column&quot;,&quot;side&quot;,&quot;label_side&quot;,&quot;label_size&quot;,&quot;show_legend&quot;]" data-initial="[{&quot;fields&quot;:[{&quot;key&quot;:&quot;column&quot;,&quot;value&quot;:&quot;direction&quot;},{&quot;key&quot;:&quot;side&quot;,&quot;value&quot;:&quot;Left&quot;},{&quot;key&quot;:&quot;label_side&quot;,&quot;value&quot;:&quot;Bottom&quot;},{&quot;key&quot;:&quot;label_size&quot;,&quot;value&quot;:10},{&quot;key&quot;:&quot;show_legend&quot;,&quot;value&quot;:true}]}]" data-input-id="de-row_annotations" data-row-prefix="row annotations">
#>             <div class="mdi-top">
#>               <label class="control-label" for="de-row_annotations">Row Annotations</label>
#>               <button type="button" class="mdi-add btn btn-default btn-sm">+ Add</button>
#>             </div>
#>             <div class="mdi-rows"></div>
#>             <template class="mdi-row-template">
#>               <div class="mdi-row">
#>                 <div class="mdi-fields">
#>                   <div class="mdi-field" data-key="column" style="flex: 1 1 calc(50% - 8px); min-width: 120px;">
#>                     <div class="form-group shiny-input-container">
#>                       <label class="control-label" id="de-row_annotations-__ROWIDX__-column-label" for="de-row_annotations-__ROWIDX__-column">Column</label>
#>                       <div>
#>                         <select id="de-row_annotations-__ROWIDX__-column" class="shiny-input-select"><option value="direction" selected>direction</option>
#> <option value="log2FC">log2FC</option></select>
#>                         <script type="application/json" data-for="de-row_annotations-__ROWIDX__-column" data-nonempty="">{"plugins":["selectize-plugin-a11y"]}</script>
#>                       </div>
#>                     </div>
#>                   </div>
#>                   <div class="mdi-field" data-key="side" style="flex: 1 1 calc(50% - 8px); min-width: 120px;">
#>                     <div class="form-group shiny-input-container">
#>                       <label class="control-label" id="de-row_annotations-__ROWIDX__-side-label" for="de-row_annotations-__ROWIDX__-side">Side</label>
#>                       <div>
#>                         <select id="de-row_annotations-__ROWIDX__-side" class="shiny-input-select"><option value="Left" selected>Left</option>
#> <option value="Right">Right</option></select>
#>                         <script type="application/json" data-for="de-row_annotations-__ROWIDX__-side" data-nonempty="">{"plugins":["selectize-plugin-a11y"]}</script>
#>                       </div>
#>                     </div>
#>                   </div>
#>                   <div class="mdi-field" data-key="label_side" style="flex: 1 1 calc(50% - 8px); min-width: 120px;">
#>                     <div class="form-group shiny-input-container">
#>                       <label class="control-label" id="de-row_annotations-__ROWIDX__-label_side-label" for="de-row_annotations-__ROWIDX__-label_side">Label Side</label>
#>                       <div>
#>                         <select id="de-row_annotations-__ROWIDX__-label_side" class="shiny-input-select"><option value="Bottom" selected>Bottom</option>
#> <option value="Top">Top</option></select>
#>                         <script type="application/json" data-for="de-row_annotations-__ROWIDX__-label_side" data-nonempty="">{"plugins":["selectize-plugin-a11y"]}</script>
#>                       </div>
#>                     </div>
#>                   </div>
#>                   <div class="mdi-field" data-key="label_size" style="flex: 1 1 calc(50% - 8px); min-width: 120px;">
#>                     <div class="form-group shiny-input-container">
#>                       <label class="control-label" id="de-row_annotations-__ROWIDX__-label_size-label" for="de-row_annotations-__ROWIDX__-label_size">Label Size</label>
#>                       <input id="de-row_annotations-__ROWIDX__-label_size" type="number" class="shiny-input-number form-control" value="10" data-update-on="change" min="1" step="0.5"/>
#>                     </div>
#>                   </div>
#>                   <div class="mdi-field" data-key="show_legend" style="flex: 1 1 calc(50% - 8px); min-width: 120px;">
#>                     <div class="form-group shiny-input-container">
#>                       <div class="checkbox">
#>                         <label>
#>                           <input id="de-row_annotations-__ROWIDX__-show_legend" type="checkbox" class="shiny-input-checkbox" checked="checked"/>
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
#>           <div id="de-row_annotation_colors_ui" class="shiny-html-output"></div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" style="width:100%;" id="tipify7789706">
#>             <label class="control-label" id="de-column_key-label" for="de-column_key">Column Key</label>
#>             <div id="de-column_key" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="change">
#>               <script type="application/json" data-for="de-column_key">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["sample","SampleName","cell","dex","albut","Run","avgLength","Experiment","Sample","BioSample"],"value":["sample","SampleName","cell","dex","albut","Run","avgLength","Experiment","Sample","BioSample"]}},"config":{"multiple":false,"search":false,"selectedValue":"sample","hideClearButton":true,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":false,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":true,"disableOptionGroupCheckbox":true,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify7789706', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Column in the column-annotation table that matches the heatmap&#39;s sample column names'})}, 500)});</script>
#>           <div class="multi-dynamic-input shiny-input-container form-group " id="de-column_annotations" data-keys="[&quot;column&quot;,&quot;side&quot;,&quot;label_side&quot;,&quot;label_size&quot;,&quot;show_legend&quot;]" data-initial="[{&quot;fields&quot;:[{&quot;key&quot;:&quot;column&quot;,&quot;value&quot;:&quot;cell&quot;},{&quot;key&quot;:&quot;side&quot;,&quot;value&quot;:&quot;Top&quot;},{&quot;key&quot;:&quot;label_side&quot;,&quot;value&quot;:&quot;Right&quot;},{&quot;key&quot;:&quot;label_size&quot;,&quot;value&quot;:10},{&quot;key&quot;:&quot;show_legend&quot;,&quot;value&quot;:true}]},{&quot;fields&quot;:[{&quot;key&quot;:&quot;column&quot;,&quot;value&quot;:&quot;dex&quot;},{&quot;key&quot;:&quot;side&quot;,&quot;value&quot;:&quot;Top&quot;},{&quot;key&quot;:&quot;label_side&quot;,&quot;value&quot;:&quot;Right&quot;},{&quot;key&quot;:&quot;label_size&quot;,&quot;value&quot;:10},{&quot;key&quot;:&quot;show_legend&quot;,&quot;value&quot;:true}]}]" data-input-id="de-column_annotations" data-row-prefix="column annotations">
#>             <div class="mdi-top">
#>               <label class="control-label" for="de-column_annotations">Column Annotations</label>
#>               <button type="button" class="mdi-add btn btn-default btn-sm">+ Add</button>
#>             </div>
#>             <div class="mdi-rows"></div>
#>             <template class="mdi-row-template">
#>               <div class="mdi-row">
#>                 <div class="mdi-fields">
#>                   <div class="mdi-field" data-key="column" style="flex: 1 1 calc(50% - 8px); min-width: 120px;">
#>                     <div class="form-group shiny-input-container">
#>                       <label class="control-label" id="de-column_annotations-__ROWIDX__-column-label" for="de-column_annotations-__ROWIDX__-column">Column</label>
#>                       <div>
#>                         <select id="de-column_annotations-__ROWIDX__-column" class="shiny-input-select"><option value="SampleName" selected>SampleName</option>
#> <option value="cell">cell</option>
#> <option value="dex">dex</option>
#> <option value="albut">albut</option>
#> <option value="Run">Run</option>
#> <option value="avgLength">avgLength</option>
#> <option value="Experiment">Experiment</option>
#> <option value="Sample">Sample</option>
#> <option value="BioSample">BioSample</option></select>
#>                         <script type="application/json" data-for="de-column_annotations-__ROWIDX__-column" data-nonempty="">{"plugins":["selectize-plugin-a11y"]}</script>
#>                       </div>
#>                     </div>
#>                   </div>
#>                   <div class="mdi-field" data-key="side" style="flex: 1 1 calc(50% - 8px); min-width: 120px;">
#>                     <div class="form-group shiny-input-container">
#>                       <label class="control-label" id="de-column_annotations-__ROWIDX__-side-label" for="de-column_annotations-__ROWIDX__-side">Side</label>
#>                       <div>
#>                         <select id="de-column_annotations-__ROWIDX__-side" class="shiny-input-select"><option value="Top" selected>Top</option>
#> <option value="Bottom">Bottom</option></select>
#>                         <script type="application/json" data-for="de-column_annotations-__ROWIDX__-side" data-nonempty="">{"plugins":["selectize-plugin-a11y"]}</script>
#>                       </div>
#>                     </div>
#>                   </div>
#>                   <div class="mdi-field" data-key="label_side" style="flex: 1 1 calc(50% - 8px); min-width: 120px;">
#>                     <div class="form-group shiny-input-container">
#>                       <label class="control-label" id="de-column_annotations-__ROWIDX__-label_side-label" for="de-column_annotations-__ROWIDX__-label_side">Label Side</label>
#>                       <div>
#>                         <select id="de-column_annotations-__ROWIDX__-label_side" class="shiny-input-select"><option value="Right" selected>Right</option>
#> <option value="Left">Left</option></select>
#>                         <script type="application/json" data-for="de-column_annotations-__ROWIDX__-label_side" data-nonempty="">{"plugins":["selectize-plugin-a11y"]}</script>
#>                       </div>
#>                     </div>
#>                   </div>
#>                   <div class="mdi-field" data-key="label_size" style="flex: 1 1 calc(50% - 8px); min-width: 120px;">
#>                     <div class="form-group shiny-input-container">
#>                       <label class="control-label" id="de-column_annotations-__ROWIDX__-label_size-label" for="de-column_annotations-__ROWIDX__-label_size">Label Size</label>
#>                       <input id="de-column_annotations-__ROWIDX__-label_size" type="number" class="shiny-input-number form-control" value="10" data-update-on="change" min="1" step="0.5"/>
#>                     </div>
#>                   </div>
#>                   <div class="mdi-field" data-key="show_legend" style="flex: 1 1 calc(50% - 8px); min-width: 120px;">
#>                     <div class="form-group shiny-input-container">
#>                       <div class="checkbox">
#>                         <label>
#>                           <input id="de-column_annotations-__ROWIDX__-show_legend" type="checkbox" class="shiny-input-checkbox" checked="checked"/>
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
#>           <div id="de-column_annotation_colors_ui" class="shiny-html-output"></div>
#>         </div>
#>       </div>
#>     </div>
#>   </div>
#> </div>
#> <div class="module-tack" style="margin-top: 12px;">
#>   <div class="module-tack-switch" style="margin-bottom: 4px;">
#>     <div class="form-group shiny-input-container">
#>       <div class="material-switch">
#>         <label for="de-auto.update" style="padding-right: 10px;">Auto Update</label>
#>         <input id="de-auto.update" type="checkbox" checked="checked"/>
#>         <label class="switch label-success bg-success" for="de-auto.update"></label>
#>       </div>
#>     </div>
#>   </div>
#>   <div class="module-tack-buttons" style="display: flex; flex-wrap: wrap; gap: 8px;">
#>     <button class="btn btn-default action-button btn-primary" id="de-update" style="flex: 1 1 45%;" type="button"><span class="action-label">Update</span></button>
#>     <button class="btn btn-default action-button btn-secondary" id="de-reset" style="flex: 1 1 45%;" type="button"><span class="action-label">Reset</span></button>
#>     <a aria-disabled="true" class="btn btn-default shiny-download-link disabled btn-secondary viz-source-download" data-viz-source-ns="de-" download href="" id="de-download.source" style="flex: 1 1 100%;" tabindex="-1" target="_blank">
#>       <i class="far fa-file-code" role="presentation" aria-label="file-code icon"></i>
#>       Source Download
#>     </a>
#>     <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('de-download.source', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Download the plot as a self-contained HTML file and as SVG and PNG images of it as it looks now, along with the plot source data and statistics (if applicable) as CSV files.'})}, 500)});</script>
#>   </div>
#> </div>
```
