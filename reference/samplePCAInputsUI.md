# Input UI components for the samplePCA module

This should be placed in the UI where the inputs should be shown, with
an `id` that matches the `id` used in the
[`samplePCAServer()`](https://j-andrews7.github.io/sciVizModules/reference/samplePCAServer.md)
and
[`samplePCAOutputUI()`](https://j-andrews7.github.io/sciVizModules/reference/samplePCAOutputUI.md)
functions.

## Usage

``` r
samplePCAInputsUI(
  id,
  data,
  defaults = NULL,
  title = "Sample PCA Settings",
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

The module draws the sample PCA of a bulk expression experiment, the
first plot of most RNA-seq analyses: the counts of a
`SummarizedExperiment` are transformed, the most variable genes kept,
and the samples projected onto their principal components
([`sample_pca()`](https://j-andrews7.github.io/sciVizModules/reference/sample_pca.md)).
The scores are drawn by the
[`pcaBiplotInputsUI()`](https://j-andrews7.github.io/sciVizModules/reference/pcaBiplotInputsUI.md)
module, so the component axes (titled with the variance each explains),
the loading arrows and every scatter control apply; those inputs are
documented there. Colour and shape choices come from `colData`.

To see the scree, loadings, pairs or PC-metadata correlation views of
the same PCA, build it with
[`sample_pca()`](https://j-andrews7.github.io/sciVizModules/reference/sample_pca.md)
and pass it to
[`pcaScreePlotServer()`](https://j-andrews7.github.io/sciVizModules/reference/pcaScreePlotServer.md)
and friends.

## Plot parameters and defaults

The following parameters can be accessed via UI inputs and/or the
`defaults` argument:

- `pca.assay` - Assay (UI: "Assay", default: `"counts"` when present)

- `pca.transform` - Transformation (UI: "Transformation", default:
  `"vst"`, DESeq2's variance-stabilising transformation, when DESeq2 is
  installed, otherwise `"log2cpm"`; also `"log2"` and `"none"`)

- `pca.ntop` - Most variable genes kept (UI: "Top Variable Genes",
  default: 500, as DESeq2's `plotPCA()`)

- `pca.center`, `pca.scale` - Centre and scale each gene before the PCA
  (UI: "Center Genes", "Scale Genes"; default: TRUE, FALSE)

- `pca.labels` - `rowData` column naming the genes in the loading
  arrows, or `""` for the row names (UI: "Gene Labels", default:
  `symbol` when present)

- `x.by`, `y.by`, `color.by` - Components on the axes and the colour
  column (default: `"PC1"`, `"PC2"`, the first `colData` column that
  groups samples, skipping sample IDs)

- All other
  [`pcaBiplotInputsUI()`](https://j-andrews7.github.io/sciVizModules/reference/pcaBiplotInputsUI.md)
  parameters

## See also

[`sample_pca()`](https://j-andrews7.github.io/sciVizModules/reference/sample_pca.md),
[`pcaBiplotInputsUI()`](https://j-andrews7.github.io/sciVizModules/reference/pcaBiplotInputsUI.md),
[`samplePCAOutputUI()`](https://j-andrews7.github.io/sciVizModules/reference/samplePCAOutputUI.md),
[`samplePCAServer()`](https://j-andrews7.github.io/sciVizModules/reference/samplePCAServer.md),
[`samplePCAApp()`](https://j-andrews7.github.io/sciVizModules/reference/samplePCAApp.md)

## Author

Jared Andrews

## Examples

``` r
library(sciVizModules)
if (requireNamespace("airway", quietly = TRUE)) {
    data("airway", package = "airway")
    samplePCAInputsUI("pca", airway, defaults = list(pca.transform = "log2cpm"))
}
#> <div class="vizmodules-input-grid" style="--viz-input-columns: 2;">
#>   <div class="vizmodules-input-cell">
#>     <div class="form-group shiny-input-container" style="width:100%;" id="tipify1721757">
#>       <label class="control-label" id="pca-pca.assay-label" for="pca-pca.assay">Assay</label>
#>       <div id="pca-pca.assay" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="change">
#>         <script type="application/json" data-for="pca-pca.assay">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["counts"],"value":["counts"]}},"config":{"multiple":false,"search":false,"selectedValue":"counts","hideClearButton":true,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":false,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":true,"disableOptionGroupCheckbox":true,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>       </div>
#>     </div>
#>     <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify1721757', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'The assay the PCA is computed from.'})}, 500)});</script>
#>   </div>
#>   <div class="vizmodules-input-cell">
#>     <div class="form-group shiny-input-container" style="width:100%;" id="tipify1865900">
#>       <label class="control-label" id="pca-pca.transform-label" for="pca-pca.transform">Transformation</label>
#>       <div id="pca-pca.transform" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="change">
#>         <script type="application/json" data-for="pca-pca.transform">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["Variance stabilised (DESeq2)","log2 CPM","log2(x + 1)","None (assay as is)"],"value":["vst","log2cpm","log2","none"]}},"config":{"multiple":false,"search":false,"selectedValue":"log2cpm","hideClearButton":true,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":false,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":true,"disableOptionGroupCheckbox":true,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>       </div>
#>     </div>
#>     <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify1865900', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'How counts are transformed first. Variance stabilisation (DESeq2) or log2 CPM for raw counts; None for an assay that is already on a log scale.'})}, 500)});</script>
#>   </div>
#>   <div class="vizmodules-input-cell">
#>     <div class="form-group shiny-input-container" id="tipify3824884">
#>       <label class="control-label" id="pca-pca.ntop-label" for="pca-pca.ntop">Top Variable Genes</label>
#>       <input id="pca-pca.ntop" type="number" class="shiny-input-number form-control" value="500" data-update-on="change" min="2" step="50"/>
#>     </div>
#>     <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify3824884', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'The most variable genes the PCA uses (DESeq2&#39;s plotPCA() uses 500).'})}, 500)});</script>
#>   </div>
#>   <div class="vizmodules-input-cell">
#>     <div class="form-group shiny-input-container" style="width:100%;" id="tipify4536133">
#>       <label class="control-label" id="pca-pca.labels-label" for="pca-pca.labels">Gene Labels</label>
#>       <div id="pca-pca.labels" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="change">
#>         <script type="application/json" data-for="pca-pca.labels">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["(none)","gene_id","gene_name","gene_biotype","seq_name","symbol"],"value":["","gene_id","gene_name","gene_biotype","seq_name","symbol"]}},"config":{"multiple":false,"search":false,"selectedValue":"symbol","hideClearButton":true,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":false,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":true,"disableOptionGroupCheckbox":true,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>       </div>
#>     </div>
#>     <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify4536133', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'rowData column naming the genes in the loading arrows.'})}, 500)});</script>
#>   </div>
#>   <div class="vizmodules-input-cell">
#>     <div class="form-group shiny-input-container" id="tipify4551315">
#>       <div class="material-switch">
#>         <label for="pca-pca.center" style="padding-right: 10px;">Center Genes</label>
#>         <input id="pca-pca.center" type="checkbox" checked="checked"/>
#>         <label class="switch label-success bg-success" for="pca-pca.center"></label>
#>       </div>
#>     </div>
#>     <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify4551315', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Centre each gene on its mean before the PCA.'})}, 500)});</script>
#>   </div>
#>   <div class="vizmodules-input-cell">
#>     <div class="form-group shiny-input-container" id="tipify1731028">
#>       <div class="material-switch">
#>         <label for="pca-pca.scale" style="padding-right: 10px;">Scale Genes</label>
#>         <input id="pca-pca.scale" type="checkbox"/>
#>         <label class="switch label-success bg-success" for="pca-pca.scale"></label>
#>       </div>
#>     </div>
#>     <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify1731028', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Scale each gene to unit variance, so every gene weighs the same.'})}, 500)});</script>
#>   </div>
#> </div>
#> <div class="vizmodules-input-grid" style="--viz-input-columns: 2;">
#>   <div class="vizmodules-input-cell">
#>     <div class="form-group shiny-input-container" id="tipify3054173">
#>       <div class="material-switch">
#>         <label for="pca-show.loadings" style="padding-right: 10px;">Loading Arrows</label>
#>         <input id="pca-show.loadings" type="checkbox"/>
#>         <label class="switch label-success bg-success" for="pca-show.loadings"></label>
#>       </div>
#>     </div>
#>     <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify3054173', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Draw arrows for the variables loading most strongly on the two components. Shown when both axes are components and no axis adjustment is set.'})}, 500)});</script>
#>   </div>
#>   <div class="vizmodules-input-cell">
#>     <div class="form-group shiny-input-container" id="tipify8677521">
#>       <label class="control-label" id="pca-n.top.loadings-label" for="pca-n.top.loadings">Top Loadings per Axis</label>
#>       <input id="pca-n.top.loadings" type="number" class="shiny-input-number form-control" value="5" data-update-on="change" min="1" step="1"/>
#>     </div>
#>     <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify8677521', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Number of variables with the largest absolute loading on each axis to draw.'})}, 500)});</script>
#>   </div>
#>   <div class="vizmodules-input-cell">
#>     <div class="form-group shiny-input-container" id="tipify2602323">
#>       <label class="control-label" id="pca-loadings.length.factor-label" for="pca-loadings.length.factor">Arrow Length Factor</label>
#>       <input id="pca-loadings.length.factor" type="number" class="shiny-input-number form-control" value="0.5" data-update-on="change" min="0.1" step="0.1"/>
#>     </div>
#>     <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify2602323', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Multiplier on the arrow lengths after scaling the loadings to the scores.'})}, 500)});</script>
#>   </div>
#>   <div class="vizmodules-input-cell">
#>     <div class="form-group shiny-input-container" data-shiny-input-type="colour" id="tipify6808707">
#>       <label class="control-label" for="pca-loadings.color">Arrow Color</label>
#>       <input id="pca-loadings.color" type="text" class="form-control shiny-colour-input" data-init-value="#000000" data-show-colour="both" data-palette="square"/>
#>     </div>
#>     <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify6808707', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Colour of the loading arrows and their labels.'})}, 500)});</script>
#>   </div>
#>   <div class="vizmodules-input-cell">
#>     <div class="form-group shiny-input-container" id="tipify8535765">
#>       <label class="control-label" id="pca-loadings.label.size-label" for="pca-loadings.label.size">Arrow Label Size</label>
#>       <input id="pca-loadings.label.size" type="number" class="shiny-input-number form-control" value="12" data-update-on="change" min="4" step="1"/>
#>     </div>
#>     <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify8535765', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Font size of the loading arrow labels.'})}, 500)});</script>
#>   </div>
#> </div>
#> <h3>Sample PCA Settings</h3>
#> <div class="tabbable vizmodules-input-tabs">
#>   <ul class="nav nav-tabs shiny-tab-input" id="pca-scatterPlotTabsetPanel" data-tabsetid="5623">
#>     <li class="active">
#>       <a href="#tab-5623-1" data-toggle="tab" data-bs-toggle="tab" data-value="Data">Data</a>
#>     </li>
#>     <li>
#>       <a href="#tab-5623-2" data-toggle="tab" data-bs-toggle="tab" data-value="Adjustments">Adjustments</a>
#>     </li>
#>     <li>
#>       <a href="#tab-5623-3" data-toggle="tab" data-bs-toggle="tab" data-value="Points">Points</a>
#>     </li>
#>     <li>
#>       <a href="#tab-5623-4" data-toggle="tab" data-bs-toggle="tab" data-value="Colors">Colors</a>
#>     </li>
#>     <li>
#>       <a href="#tab-5623-5" data-toggle="tab" data-bs-toggle="tab" data-value="Facet">Facet</a>
#>     </li>
#>     <li>
#>       <a href="#tab-5623-6" data-toggle="tab" data-bs-toggle="tab" data-value="Annotations">Annotations</a>
#>     </li>
#>     <li>
#>       <a href="#tab-5623-7" data-toggle="tab" data-bs-toggle="tab" data-value="Legend">Legend</a>
#>     </li>
#>     <li>
#>       <a href="#tab-5623-8" data-toggle="tab" data-bs-toggle="tab" data-value="Trajectory">Trajectory</a>
#>     </li>
#>     <li>
#>       <a href="#tab-5623-9" data-toggle="tab" data-bs-toggle="tab" data-value="Marginals">Marginals</a>
#>     </li>
#>     <li>
#>       <a href="#tab-5623-10" data-toggle="tab" data-bs-toggle="tab" data-value="Plotly">Plotly</a>
#>     </li>
#>     <li>
#>       <a href="#tab-5623-11" data-toggle="tab" data-bs-toggle="tab" data-value="Extras">Extras</a>
#>     </li>
#>     <li>
#>       <a href="#tab-5623-12" data-toggle="tab" data-bs-toggle="tab" data-value="Lines">Lines</a>
#>     </li>
#>     <li>
#>       <a href="#tab-5623-13" data-toggle="tab" data-bs-toggle="tab" data-value="Axes">Axes</a>
#>     </li>
#>   </ul>
#>   <div class="tab-content" data-tabsetid="5623">
#>     <div class="tab-pane active" data-value="Data" id="tab-5623-1">
#>       <div class="vizmodules-input-grid" style="--viz-input-columns: 2;">
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" style="width:100%;" id="tipify8052743">
#>             <label class="control-label" id="pca-x.by-label" for="pca-x.by">X Data</label>
#>             <div id="pca-x.by" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="change">
#>               <script type="application/json" data-for="pca-x.by">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["sample","PC1","PC2","PC3","PC4","PC5","PC6","PC7","PC8","SampleName","cell","dex","albut","Run","avgLength","Experiment","Sample","BioSample"],"value":["sample","PC1","PC2","PC3","PC4","PC5","PC6","PC7","PC8","SampleName","cell","dex","albut","Run","avgLength","Experiment","Sample","BioSample"]}},"config":{"multiple":false,"search":true,"selectedValue":"PC1","hideClearButton":true,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":false,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":true,"disableOptionGroupCheckbox":true,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify8052743', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Single strings denoting the name of a column of `data_frame` containing numeric data to use for the x- and y-axis of the scatterplot.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" style="width:100%;" id="tipify1635164">
#>             <label class="control-label" id="pca-y.by-label" for="pca-y.by">Y Data</label>
#>             <div id="pca-y.by" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="change">
#>               <script type="application/json" data-for="pca-y.by">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["sample","PC1","PC2","PC3","PC4","PC5","PC6","PC7","PC8","SampleName","cell","dex","albut","Run","avgLength","Experiment","Sample","BioSample"],"value":["sample","PC1","PC2","PC3","PC4","PC5","PC6","PC7","PC8","SampleName","cell","dex","albut","Run","avgLength","Experiment","Sample","BioSample"]}},"config":{"multiple":false,"search":true,"selectedValue":"PC2","hideClearButton":true,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":false,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":true,"disableOptionGroupCheckbox":true,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify1635164', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Single strings denoting the name of a column of `data_frame` containing numeric data to use for the x- and y-axis of the scatterplot.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" style="width:100%;" id="tipify4719390">
#>             <label class="control-label" id="pca-color.by-label" for="pca-color.by">Color By</label>
#>             <div id="pca-color.by" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="change">
#>               <script type="application/json" data-for="pca-color.by">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["(none)","sample","PC1","PC2","PC3","PC4","PC5","PC6","PC7","PC8","SampleName","cell","dex","albut","Run","avgLength","Experiment","Sample","BioSample"],"value":["","sample","PC1","PC2","PC3","PC4","PC5","PC6","PC7","PC8","SampleName","cell","dex","albut","Run","avgLength","Experiment","Sample","BioSample"]}},"config":{"multiple":false,"search":true,"selectedValue":"cell","hideClearButton":true,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":false,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":true,"disableOptionGroupCheckbox":true,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify4719390', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Single string denoting the name of a column of `data_frame` to use for setting the color of plotted points. Alternatively, a string vector naming multiple such columns of data to plot at once.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" style="width:100%;" id="tipify7183186">
#>             <label class="control-label" id="pca-size.by-label" for="pca-size.by">Size By</label>
#>             <div id="pca-size.by" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="change">
#>               <script type="application/json" data-for="pca-size.by">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["(none)","PC1","PC2","PC3","PC4","PC5","PC6","PC7","PC8","avgLength"],"value":["","PC1","PC2","PC3","PC4","PC5","PC6","PC7","PC8","avgLength"]}},"config":{"multiple":false,"search":false,"selectedValue":"","hideClearButton":true,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":false,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":true,"disableOptionGroupCheckbox":true,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify7183186', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Number which sets the size of data points. Default = 1. Alternatively, a single string denoting the name of a column of `data_frame` to use for setting the size of plotted points.  NOTE: When providing a column name and using `do.hover = TRUE`, the legend will not include meaningful size encoding information.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" style="width:100%;" id="tipify2698786">
#>             <label class="control-label" id="pca-shape.by-label" for="pca-shape.by">Shape By</label>
#>             <div id="pca-shape.by" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="change">
#>               <script type="application/json" data-for="pca-shape.by">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["(none)","sample","SampleName","cell","dex","albut","Run","Experiment","Sample","BioSample"],"value":["","sample","SampleName","cell","dex","albut","Run","Experiment","Sample","BioSample"]}},"config":{"multiple":false,"search":false,"selectedValue":"","hideClearButton":true,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":false,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":true,"disableOptionGroupCheckbox":true,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify2698786', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Single string denoting the name of a column of `data_frame` containing discrete data to use for setting the shape of plotted points.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" style="width:100%;" id="tipify6082372">
#>             <label class="control-label" id="pca-split.by-label" for="pca-split.by">Split By</label>
#>             <div id="pca-split.by" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="close">
#>               <script type="application/json" data-for="pca-split.by">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["(none)","sample","SampleName","cell","dex","albut","Run","Experiment","Sample","BioSample"],"value":["","sample","SampleName","cell","dex","albut","Run","Experiment","Sample","BioSample"]}},"config":{"multiple":true,"search":false,"selectedValue":"","hideClearButton":false,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":true,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":false,"disableOptionGroupCheckbox":false,"disabled":false,"dropboxWrapper":"body","zIndex":1060,"maxValues":2}}</script>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify6082372', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': '1 or 2 strings denoting the name(s) of column(s) of `data_frame` containing discrete data to use for faceting / separating data points into separate plots.  When 2 columns are named, c(row,col), the first is used as rows and the second is used for columns of the resulting facet grid.  When 1 column is named, shape control can be achieved with `split.nrow` and `split.ncol`'})}, 500)});</script>
#>         </div>
#>       </div>
#>     </div>
#>     <div class="tab-pane" data-value="Adjustments" id="tab-5623-2">
#>       <div class="vizmodules-input-grid" style="--viz-input-columns: 2;">
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" style="width:100%;" id="tipify3681659">
#>             <label class="control-label" id="pca-x.adjustment-label" for="pca-x.adjustment">X Adjustment</label>
#>             <div id="pca-x.adjustment" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="change">
#>               <script type="application/json" data-for="pca-x.adjustment">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["(none)","z-score","relative.to.max"],"value":["","z-score","relative.to.max"]}},"config":{"multiple":false,"search":false,"selectedValue":"","hideClearButton":true,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":false,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":true,"disableOptionGroupCheckbox":true,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify3681659', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'A recognized string indicating whether numeric `x.by`, `y.by`, and `color.by` data should be used directly (default) or should be adjusted to be itemize{ item{"z-score": scaled with the scale() function to produce a relative-to-mean z-score representation} item{"relative.to.max": divided by the maximum value to give percent of max values between [0,1]} }  Ignored if the target data is not numeric as these known adjustments target numeric data only.  In order to leave the unedited data available for use in other features, the adjusted data are put in a new column and that new column is used for plotting. The Adjustment Function is applied first, and the X Adjustment then rescales the result (e.g. log10, then z-score).'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" style="width:100%;" id="tipify6117696">
#>             <label class="control-label" id="pca-y.adjustment-label" for="pca-y.adjustment">Y Adjustment</label>
#>             <div id="pca-y.adjustment" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="change">
#>               <script type="application/json" data-for="pca-y.adjustment">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["(none)","z-score","relative.to.max"],"value":["","z-score","relative.to.max"]}},"config":{"multiple":false,"search":false,"selectedValue":"","hideClearButton":true,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":false,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":true,"disableOptionGroupCheckbox":true,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify6117696', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'A recognized string indicating whether numeric `x.by`, `y.by`, and `color.by` data should be used directly (default) or should be adjusted to be itemize{ item{"z-score": scaled with the scale() function to produce a relative-to-mean z-score representation} item{"relative.to.max": divided by the maximum value to give percent of max values between [0,1]} }  Ignored if the target data is not numeric as these known adjustments target numeric data only.  In order to leave the unedited data available for use in other features, the adjusted data are put in a new column and that new column is used for plotting. The Adjustment Function is applied first, and the Y Adjustment then rescales the result (e.g. log10, then z-score).'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" style="width:100%;" id="tipify4145562">
#>             <label class="control-label" id="pca-color.adjustment-label" for="pca-color.adjustment">Color Adjustment</label>
#>             <div id="pca-color.adjustment" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="change">
#>               <script type="application/json" data-for="pca-color.adjustment">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["(none)","z-score","relative.to.max"],"value":["","z-score","relative.to.max"]}},"config":{"multiple":false,"search":false,"selectedValue":"","hideClearButton":true,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":false,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":true,"disableOptionGroupCheckbox":true,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify4145562', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'A recognized string indicating whether numeric `x.by`, `y.by`, and `color.by` data should be used directly (default) or should be adjusted to be itemize{ item{"z-score": scaled with the scale() function to produce a relative-to-mean z-score representation} item{"relative.to.max": divided by the maximum value to give percent of max values between [0,1]} }  Ignored if the target data is not numeric as these known adjustments target numeric data only.  In order to leave the unedited data available for use in other features, the adjusted data are put in a new column and that new column is used for plotting. The Adjustment Function is applied first, and the Color Adjustment then rescales the result (e.g. log10, then z-score).'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" style="width:100%;" id="tipify2123919">
#>             <label class="control-label" id="pca-x.adj.fxn-label" for="pca-x.adj.fxn">X Adjustment Function</label>
#>             <div id="pca-x.adj.fxn" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="change">
#>               <script type="application/json" data-for="pca-x.adj.fxn">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["(none)","log2","log","log10","neg_log10","log1p","as.factor","abs","sqrt"],"value":["","log2","log","log10","neg_log10","log1p","as.factor","abs","sqrt"]}},"config":{"multiple":false,"search":false,"selectedValue":"","hideClearButton":true,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":false,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":true,"disableOptionGroupCheckbox":true,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify2123919', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'If you wish to apply a function to edit the `x.by`, `y.by`, or `color.by` data before use, in a way not possible with the `color.adjustment` input, this input can be given a function which takes in a vector of values as input and returns a vector of values of the same length as output.  For example, `function(x) {log2(x)`} or `as.factor`.  In order to leave the unedited data available for use in other features, the adjusted data are put in a new column and that new column is used for plotting. The Adjustment Function is applied first, and the X Adjustment then rescales the result (e.g. log10, then z-score).'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" style="width:100%;" id="tipify7327437">
#>             <label class="control-label" id="pca-y.adj.fxn-label" for="pca-y.adj.fxn">Y Adjustment Function</label>
#>             <div id="pca-y.adj.fxn" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="change">
#>               <script type="application/json" data-for="pca-y.adj.fxn">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["(none)","log2","log","log10","neg_log10","log1p","as.factor","abs","sqrt"],"value":["","log2","log","log10","neg_log10","log1p","as.factor","abs","sqrt"]}},"config":{"multiple":false,"search":false,"selectedValue":"","hideClearButton":true,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":false,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":true,"disableOptionGroupCheckbox":true,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify7327437', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'If you wish to apply a function to edit the `x.by`, `y.by`, or `color.by` data before use, in a way not possible with the `color.adjustment` input, this input can be given a function which takes in a vector of values as input and returns a vector of values of the same length as output.  For example, `function(x) {log2(x)`} or `as.factor`.  In order to leave the unedited data available for use in other features, the adjusted data are put in a new column and that new column is used for plotting. The Adjustment Function is applied first, and the Y Adjustment then rescales the result (e.g. log10, then z-score).'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" style="width:100%;" id="tipify4595849">
#>             <label class="control-label" id="pca-color.adj.fxn-label" for="pca-color.adj.fxn">Color Adjustment Function</label>
#>             <div id="pca-color.adj.fxn" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="change">
#>               <script type="application/json" data-for="pca-color.adj.fxn">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["(none)","log2","log","log10","neg_log10","log1p","as.factor","abs","sqrt"],"value":["","log2","log","log10","neg_log10","log1p","as.factor","abs","sqrt"]}},"config":{"multiple":false,"search":false,"selectedValue":"","hideClearButton":true,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":false,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":true,"disableOptionGroupCheckbox":true,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify4595849', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'If you wish to apply a function to edit the `x.by`, `y.by`, or `color.by` data before use, in a way not possible with the `color.adjustment` input, this input can be given a function which takes in a vector of values as input and returns a vector of values of the same length as output.  For example, `function(x) {log2(x)`} or `as.factor`.  In order to leave the unedited data available for use in other features, the adjusted data are put in a new column and that new column is used for plotting. The Adjustment Function is applied first, and the Color Adjustment then rescales the result (e.g. log10, then z-score).'})}, 500)});</script>
#>         </div>
#>       </div>
#>     </div>
#>     <div class="tab-pane" data-value="Points" id="tab-5623-3">
#>       <div class="vizmodules-input-grid" style="--viz-input-columns: 2;">
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify995664">
#>             <label class="control-label" id="pca-size-label" for="pca-size">Point Size</label>
#>             <input id="pca-size" type="number" class="shiny-input-number form-control" value="1" data-update-on="change" min="0.1"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify995664', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Number which sets the size of data points. Default = 1. Alternatively, a single string denoting the name of a column of `data_frame` to use for setting the size of plotted points.  NOTE: When providing a column name and using `do.hover = TRUE`, the legend will not include meaningful size encoding information.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify7701585">
#>             <label class="control-label" id="pca-size.min-label" for="pca-size.min">Min Point Size</label>
#>             <input id="pca-size.min" type="number" class="shiny-input-number form-control" value="1" data-update-on="change" min="0" step="0.5"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify7701585', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Smallest point size, drawn for the Size Scale Min value of the &#39;Size By&#39; column.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify967847">
#>             <label class="control-label" id="pca-size.max-label" for="pca-size.max">Max Point Size</label>
#>             <input id="pca-size.max" type="number" class="shiny-input-number form-control" value="6" data-update-on="change" min="0" step="0.5"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify967847', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Largest point size, drawn for the Size Scale Max value of the &#39;Size By&#39; column.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify258403">
#>             <label class="control-label" id="pca-size.scale.min-label" for="pca-size.scale.min">Size Scale Min</label>
#>             <input id="pca-size.scale.min" type="number" class="shiny-input-number form-control" value="NA" data-update-on="change"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify258403', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': '&#39;Size By&#39; value drawn at the Min Point Size, and where the size legend starts. Leave blank to use the column&#39;s minimum. Smaller values are drawn at the Min Point Size.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify3531725">
#>             <label class="control-label" id="pca-size.scale.max-label" for="pca-size.scale.max">Size Scale Max</label>
#>             <input id="pca-size.scale.max" type="number" class="shiny-input-number form-control" value="NA" data-update-on="change"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify3531725', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': '&#39;Size By&#39; value drawn at the Max Point Size, and where the size legend ends. Leave blank to use the column&#39;s maximum. Larger values are drawn at the Max Point Size.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify3267946">
#>             <label class="control-label" id="pca-opacity-label" for="pca-opacity">Point Opacity</label>
#>             <input id="pca-opacity" type="number" class="shiny-input-number form-control" value="1" data-update-on="change" min="0" max="1" step="0.05"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify3267946', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Number between 0 and 1. 1 = opaque. 0 = invisible. Default = 1. (In terms of typical ggplot variables, = alpha) Alternatively, a single string denoting the name of a column of `data_frame` to use for setting the opacity of plotted points.  NOTE: When providing a column name and using `do.hover = TRUE`, the legend will not include meaningful opacity encoding information.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify5413156">
#>             <div class="checkbox">
#>               <label>
#>                 <input id="pca-show.others" type="checkbox" class="shiny-input-checkbox" checked="checked"/>
#>                 <span>Show Others</span>
#>               </label>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify5413156', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Logical. TRUE by default, whether rows not targeted by `rows.use` should be shown in the background in light gray.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify5754043">
#>             <div class="checkbox">
#>               <label>
#>                 <input id="pca-split.show.all.others" type="checkbox" class="shiny-input-checkbox" checked="checked"/>
#>                 <span>Show Split Others</span>
#>               </label>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify5754043', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Logical which sets whether gray "others" points of facets should include all points of other facets (`TRUE`) versus just points left out by `rows.use` which would exist in the current facet (`FALSE`).'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" style="width:100%;" id="tipify2408527">
#>             <label class="control-label" id="pca-plot.order-label" for="pca-plot.order">Plot Order</label>
#>             <div id="pca-plot.order" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="change">
#>               <script type="application/json" data-for="pca-plot.order">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["unordered","increasing","decreasing","randomize"],"value":["unordered","increasing","decreasing","randomize"]}},"config":{"multiple":false,"search":false,"selectedValue":"unordered","hideClearButton":true,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":false,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":true,"disableOptionGroupCheckbox":true,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify2408527', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'String. If the data should be plotted based on the order of the color data, sets whether to plot in "increasing", "decreasing", or "randomize"d order.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify686919">
#>             <label class="control-label" id="pca-shape.panel-label" for="pca-shape.panel">Shape Panel</label>
#>             <input id="pca-shape.panel" type="text" class="shiny-input-text form-control" value="16, 15, 17, 23, 25, 8" data-update-on="change"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify686919', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Vector of integers, corresponding to ggplot shapes, which sets what shapes to use in conjunction with `shape.by`. When nothing is supplied to `shape.by`, only the first value is used. Default is a set of 6, `c(16,15,17,23,25,8)`, the first being a simple, solid, circle.'})}, 500)});</script>
#>         </div>
#>       </div>
#>     </div>
#>     <div class="tab-pane" data-value="Colors" id="tab-5623-4">
#>       <div class="vizmodules-input-grid" style="--viz-input-columns: 2;">
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour" id="tipify9328572">
#>             <label class="control-label" for="pca-min.color">Min Color</label>
#>             <input id="pca-min.color" type="text" class="form-control shiny-colour-input" data-init-value="#F0E442" data-show-colour="both" data-palette="square"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify9328572', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Color for `min` value of numeric `color.by`-data. Default = yellow'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour" id="tipify627373">
#>             <label class="control-label" for="pca-max.color">Max Color</label>
#>             <input id="pca-max.color" type="text" class="form-control shiny-colour-input" data-init-value="#0072B2" data-show-colour="both" data-palette="square"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify627373', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Color for `max` value of numeric `color.by`-data. Default = blue'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour" id="tipify3810109">
#>             <label class="control-label" for="pca-contour.color">Contour Color</label>
#>             <input id="pca-contour.color" type="text" class="form-control shiny-colour-input" data-init-value="black" data-show-colour="both" data-palette="square"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify3810109', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'String that sets the color of the `do.contour` contours.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" style="width:100%;" id="tipify2907716">
#>             <label class="control-label" id="pca-contour.linetype-label" for="pca-contour.linetype">Contour Linetype</label>
#>             <div id="pca-contour.linetype" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="change">
#>               <script type="application/json" data-for="pca-contour.linetype">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["solid","dashed","dotted","dotdash","longdash","twodash"],"value":["solid","dashed","dotted","dotdash","longdash","twodash"]}},"config":{"multiple":false,"search":false,"selectedValue":"solid","hideClearButton":true,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":false,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":true,"disableOptionGroupCheckbox":true,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify2907716', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'String or numeric which sets the type of line used for `do.contour` contours. Defaults to "solid", but see `link[ggplot2]{linetype`} for other options.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div id="pca-color.panel.ui" class="shiny-html-output"></div>
#>         </div>
#>       </div>
#>     </div>
#>     <div class="tab-pane" data-value="Facet" id="tab-5623-5">
#>       <div class="vizmodules-input-grid" style="--viz-input-columns: 2;">
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify842822">
#>             <label class="control-label" id="pca-split.nrow-label" for="pca-split.nrow">Rows</label>
#>             <input id="pca-split.nrow" type="number" class="shiny-input-number form-control" value="NA" data-update-on="change" min="0" step="1"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify842822', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Integers which set the dimensions of faceting/splitting when faceting by a single feature.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify4344531">
#>             <label class="control-label" id="pca-split.ncol-label" for="pca-split.ncol">Columns</label>
#>             <input id="pca-split.ncol" type="number" class="shiny-input-number form-control" value="NA" data-update-on="change" min="0" step="1"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify4344531', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Integers which set the dimensions of faceting/splitting when faceting by a single feature.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" style="width:100%;" id="tipify8114278">
#>             <label class="control-label" id="pca-multivar.split.dir-label" for="pca-multivar.split.dir">Multivar Split Dir</label>
#>             <div id="pca-multivar.split.dir" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="change">
#>               <script type="application/json" data-for="pca-multivar.split.dir">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["col","row"],"value":["col","row"]}},"config":{"multiple":false,"search":false,"selectedValue":"col","hideClearButton":true,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":false,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":true,"disableOptionGroupCheckbox":true,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify8114278', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': '"row" or "col", sets the direction of faceting used for &#39;var&#39; values when: itemize{ item `var` is given multiple column names item AND `split.by` is used to provide an additional feature to facet by }'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" style="width:100%;" id="tipify2123529">
#>             <label class="control-label" id="pca-split.adjust.scales-label" for="pca-split.adjust.scales">Facet Scales</label>
#>             <div id="pca-split.adjust.scales" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="change">
#>               <script type="application/json" data-for="pca-split.adjust.scales">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["fixed","free","free_x","free_y"],"value":["fixed","free","free_x","free_y"]}},"config":{"multiple":false,"search":false,"selectedValue":"fixed","hideClearButton":true,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":false,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":true,"disableOptionGroupCheckbox":true,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify2123529', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Control whether facet panels share the same axis scales or allow them to vary independently'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify7490236">
#>             <label class="control-label" id="pca-subplot.margin.x-label" for="pca-subplot.margin.x">Subplot Spacing (Horizontal)</label>
#>             <input id="pca-subplot.margin.x" type="number" class="shiny-input-number form-control" value="0.03" data-update-on="change" min="0" max="1" step="0.01"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify7490236', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Horizontal spacing between facet panel columns as a fraction of the plot area (e.g. 0.03). Only applies when faceting is active.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify8229459">
#>             <label class="control-label" id="pca-subplot.margin.y-label" for="pca-subplot.margin.y">Subplot Spacing (Vertical)</label>
#>             <input id="pca-subplot.margin.y" type="number" class="shiny-input-number form-control" value="0.1" data-update-on="change" min="0" max="1" step="0.01"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify8229459', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Vertical spacing between facet panel rows as a fraction of the plot area (e.g. 0.1). Only applies when faceting is active.'})}, 500)});</script>
#>         </div>
#>       </div>
#>     </div>
#>     <div class="tab-pane" data-value="Annotations" id="tab-5623-6">
#>       <div class="vizmodules-input-grid" style="--viz-input-columns: 2;">
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" style="width:100%;" id="tipify8906556">
#>             <label class="control-label" id="pca-annotate.by-label" for="pca-annotate.by">Annotate By</label>
#>             <div id="pca-annotate.by" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="change">
#>               <script type="application/json" data-for="pca-annotate.by">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["(none)","sample","PC1","PC2","PC3","PC4","PC5","PC6","PC7","PC8","SampleName","cell","dex","albut","Run","avgLength","Experiment","Sample","BioSample"],"value":["","sample","PC1","PC2","PC3","PC4","PC5","PC6","PC7","PC8","SampleName","cell","dex","albut","Run","avgLength","Experiment","Sample","BioSample"]}},"config":{"multiple":false,"search":true,"selectedValue":"","hideClearButton":true,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":false,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":true,"disableOptionGroupCheckbox":true,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify8906556', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Select a column whose values will be used to identify points for highlighting and annotation'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="shiny-input-textarea form-group shiny-input-container" id="tipify171618">
#>             <label class="control-label" id="pca-highlight.points-label" for="pca-highlight.points">Points to Highlight</label>
#>             <textarea id="pca-highlight.points" class="form-control" placeholder="Values from &#39;Annotate by&#39; column&#10;(comma, space, or newline delimited)" rows="3" data-update-on="change"></textarea>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify171618', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Enter specific values from the &#39;Annotate By&#39; column to highlight those points on the plot. Separate values that contain spaces with commas or new lines.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour" id="tipify9500633">
#>             <label class="control-label" for="pca-highlight.color">Highlight Fill</label>
#>             <input id="pca-highlight.color" type="text" class="form-control shiny-colour-input" data-init-value="#00FFF7" data-show-colour="both" data-palette="square" data-allow-alpha="true"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify9500633', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Choose the fill color for highlighted points'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify1643405">
#>             <label class="control-label" id="pca-highlight.size-label" for="pca-highlight.size">Highlight Size</label>
#>             <input id="pca-highlight.size" type="number" class="shiny-input-number form-control" value="7" data-update-on="change" min="0.1" step="0.5"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify1643405', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Set the size of highlighted points on the plot'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour" id="tipify4274280">
#>             <label class="control-label" for="pca-highlight.border.color">Highlight Border Color</label>
#>             <input id="pca-highlight.border.color" type="text" class="form-control shiny-colour-input" data-init-value="#000000" data-show-colour="both" data-palette="square"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify4274280', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Choose the border color for highlighted points'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify5136861">
#>             <label class="control-label" id="pca-highlight.border.width-label" for="pca-highlight.border.width">Highlight Border Width</label>
#>             <input id="pca-highlight.border.width" type="number" class="shiny-input-number form-control" value="1" data-update-on="change" min="0" step="0.25"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify5136861', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Set the width of the border around highlighted points'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify839077">
#>             <div class="checkbox">
#>               <label>
#>                 <input id="pca-highlight.auto.annotate" type="checkbox" class="shiny-input-checkbox" checked="checked"/>
#>                 <span>Auto-annotate Highlights</span>
#>               </label>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify839077', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'When enabled, automatically adds text labels to highlighted points using their &#39;Annotate By&#39; values'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour" id="tipify6759110">
#>             <label class="control-label" for="pca-annotation.color">Annotation Color</label>
#>             <input id="pca-annotation.color" type="text" class="form-control shiny-colour-input" data-init-value="black" data-show-colour="both" data-palette="square"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify6759110', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Set the text color for annotation labels'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify8944598">
#>             <label class="control-label" id="pca-annotation.ax-label" for="pca-annotation.ax">Annotation X Offset</label>
#>             <input id="pca-annotation.ax" type="number" class="shiny-input-number form-control" value="20" data-update-on="change" step="1"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify8944598', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Horizontal pixel offset of annotation labels from their target points'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify4628729">
#>             <label class="control-label" id="pca-annotation.ay-label" for="pca-annotation.ay">Annotation Y Offset</label>
#>             <input id="pca-annotation.ay" type="number" class="shiny-input-number form-control" value="-20" data-update-on="change" step="1"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify4628729', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Vertical pixel offset of annotation labels from their target points (negative values move up)'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify303114">
#>             <label class="control-label" id="pca-annotation.size-label" for="pca-annotation.size">Annotation Size</label>
#>             <input id="pca-annotation.size" type="number" class="shiny-input-number form-control" value="10" data-update-on="change" min="1" step="0.5"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify303114', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Set the font size of annotation text labels in points'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify5244011">
#>             <div class="checkbox">
#>               <label>
#>                 <input id="pca-annotation.showarrow" type="checkbox" class="shiny-input-checkbox" checked="checked"/>
#>                 <span>Show Arrow</span>
#>               </label>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify5244011', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Toggle whether an arrow is drawn from the annotation label to the target point'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour" id="tipify3561431">
#>             <label class="control-label" for="pca-annotation.arrowcolor">Arrow Color</label>
#>             <input id="pca-annotation.arrowcolor" type="text" class="form-control shiny-colour-input" data-init-value="black" data-show-colour="both" data-palette="square"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify3561431', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Set the color of the annotation arrow connecting the label to the point'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify1105088">
#>             <label class="control-label" id="pca-annotation.arrowhead-label" for="pca-annotation.arrowhead">Arrowhead Style</label>
#>             <input id="pca-annotation.arrowhead" type="number" class="shiny-input-number form-control" value="2" data-update-on="change" min="0" max="7" step="1"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify1105088', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Choose the arrowhead style (0-7) for annotation arrows, where 0 is no arrowhead'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify166149">
#>             <label class="control-label" id="pca-annotation.arrowwidth-label" for="pca-annotation.arrowwidth">Arrow Linewidth</label>
#>             <input id="pca-annotation.arrowwidth" type="number" class="shiny-input-number form-control" value="1.5" data-update-on="change" min="0.1" step="0.25"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify166149', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Set the line width of the annotation arrow'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <button id="pca-annotation.clear" type="button" class="btn btn-default action-button"><span class="action-label">Clear Annotations</span></button>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('pca-annotation.clear', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Remove all annotation labels and arrows from the current plot'})}, 500)});</script>
#>         </div>
#>       </div>
#>     </div>
#>     <div class="tab-pane" data-value="Legend" id="tab-5623-7">
#>       <div class="vizmodules-input-grid" style="--viz-input-columns: 2;">
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify4297519">
#>             <label class="control-label" id="pca-legend.color.title-label" for="pca-legend.color.title">Legend Title</label>
#>             <input id="pca-legend.color.title" type="text" class="shiny-input-text form-control" value="make" data-update-on="change"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify4297519', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Strings which set the title for the color or shape legends.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify6321850">
#>             <div class="material-switch">
#>               <label for="pca-legend.show" style="padding-right: 10px;">Show Legend</label>
#>               <input id="pca-legend.show" type="checkbox" checked="checked"/>
#>               <label class="switch label-success bg-success" for="pca-legend.show"></label>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify6321850', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Show the legend. Turning it off also hides colorbars and any point size legend.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" style="width:100%;" id="tipify5630118">
#>             <label class="control-label" id="pca-legend.font.family-label" for="pca-legend.font.family">Legend Font</label>
#>             <div id="pca-legend.font.family" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="change">
#>               <script type="application/json" data-for="pca-legend.font.family">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["Arial","Balto","Courier New","Droid Sans","Droid Serif","Droid Sans Mono","Gravitas One","Old Standard TT","Open Sans","Overpass","PT Sans Narrow","Raleway","Times New Roman","Verdana","sans-serif","serif","monospace"],"value":["Arial","Balto","Courier New","Droid Sans","Droid Serif","Droid Sans Mono","Gravitas One","Old Standard TT","Open Sans","Overpass","PT Sans Narrow","Raleway","Times New Roman","Verdana","sans-serif","serif","monospace"]}},"config":{"multiple":false,"search":true,"selectedValue":"Arial","hideClearButton":true,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":false,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":true,"disableOptionGroupCheckbox":true,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify5630118', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Font family of the legend title and entry labels.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour" id="tipify576773">
#>             <label class="control-label" for="pca-legend.font.color">Legend Font Color</label>
#>             <input id="pca-legend.font.color" type="text" class="form-control shiny-colour-input" data-init-value="#000000" data-show-colour="both" data-palette="square"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify576773', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Font color of the legend title and entry labels.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify9959624">
#>             <label class="control-label" id="pca-legend.title.size-label" for="pca-legend.title.size">Legend Title Size</label>
#>             <input id="pca-legend.title.size" type="number" class="shiny-input-number form-control" value="14" data-update-on="change" min="0" step="1"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify9959624', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Font size of the legend title.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify4221801">
#>             <label class="control-label" id="pca-legend.text.size-label" for="pca-legend.text.size">Legend Text Size</label>
#>             <input id="pca-legend.text.size" type="number" class="shiny-input-number form-control" value="12" data-update-on="change" min="0" step="1"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify4221801', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Font size of the legend entry labels.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify5614104">
#>             <label class="control-label" id="pca-legend.color.breaks-label" for="pca-legend.color.breaks">Color Tick Breaks</label>
#>             <input id="pca-legend.color.breaks" type="text" class="shiny-input-text form-control" value="" placeholder="e.g. -3, 0, 3" data-update-on="change"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify5614104', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Numeric vector which sets the discrete values to label in the color-scale legend for `color.by`-data.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify8199199">
#>             <label class="control-label" id="pca-size.legend.x-label" for="pca-size.legend.x">Size Legend X Position</label>
#>             <input id="pca-size.legend.x" type="number" class="shiny-input-number form-control" value="1.03" data-update-on="change" step="0.02"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify8199199', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Horizontal position (paper coordinates) of the custom size legend drawn when &#39;Size By&#39; is set. Values just above 1 sit to the right of the plot; lower it to pull the legend inward on narrow plots or raise it to push it further out.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify4500197">
#>             <label class="control-label" id="pca-size.legend.y-label" for="pca-size.legend.y">Size Legend Y Position</label>
#>             <input id="pca-size.legend.y" type="number" class="shiny-input-number form-control" value="0.35" data-update-on="change" step="0.05"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify4500197', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Vertical position (paper coordinates) of the custom size legend drawn when &#39;Size By&#39; is set. Lower it to offset the size legend from an overlapping color or shape legend.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify8596251">
#>             <label class="control-label" id="pca-min.value-label" for="pca-min.value">Color Min</label>
#>             <input id="pca-min.value" type="number" class="shiny-input-number form-control" value="NA" data-update-on="change"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify8596251', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Number which sets the `color.by`-data value associated with the minimum or maximum colors.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify7576211">
#>             <label class="control-label" id="pca-max.value-label" for="pca-max.value">Color Max</label>
#>             <input id="pca-max.value" type="number" class="shiny-input-number form-control" value="NA" data-update-on="change"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify7576211', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Number which sets the `color.by`-data value associated with the minimum or maximum colors.'})}, 500)});</script>
#>         </div>
#>       </div>
#>     </div>
#>     <div class="tab-pane" data-value="Trajectory" id="tab-5623-8">
#>       <div class="vizmodules-input-grid" style="--viz-input-columns: 2;">
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" style="width:100%;" id="tipify9268607">
#>             <label class="control-label" id="pca-trajectory.group.by-label" for="pca-trajectory.group.by">Trajectory Group By</label>
#>             <div id="pca-trajectory.group.by" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="change">
#>               <script type="application/json" data-for="pca-trajectory.group.by">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["(none)","sample","SampleName","cell","dex","albut","Run","Experiment","Sample","BioSample"],"value":["","sample","SampleName","cell","dex","albut","Run","Experiment","Sample","BioSample"]}},"config":{"multiple":false,"search":false,"selectedValue":"","hideClearButton":true,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":false,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":true,"disableOptionGroupCheckbox":true,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify9268607', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'String denoting the name of a column of `data_frame` to use for generating trajectories from data point groups.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify815888">
#>             <label class="control-label" id="pca-trajectory.arrow.size-label" for="pca-trajectory.arrow.size">Trajectory Arrow Size</label>
#>             <input id="pca-trajectory.arrow.size" type="number" class="shiny-input-number form-control" value="0.1" data-update-on="change" min="0" step="0.05"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify815888', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Number representing the size of trajectory arrows, in inches.  Default = 0.15.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div id="pca-add.trajectory.by.groups.ui" class="shiny-html-output"></div>
#>         </div>
#>       </div>
#>     </div>
#>     <div class="tab-pane" data-value="Marginals" id="tab-5623-9">
#>       <div class="vizmodules-input-grid" style="--viz-input-columns: 2;">
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" style="width:100%;" id="tipify491369">
#>             <label class="control-label" id="pca-marginal.x-label" for="pca-marginal.x">Top Marginal (X)</label>
#>             <div id="pca-marginal.x" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="close">
#>               <script type="application/json" data-for="pca-marginal.x">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["Density","Histogram","Rug"],"value":["density","histogram","rug"]}},"config":{"multiple":true,"search":false,"selectedValue":[],"hideClearButton":false,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":true,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":false,"disableOptionGroupCheckbox":false,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify491369', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Distribution of the X values drawn above the plot, one per Color By group. Pick any of density, histogram and rug.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" style="width:100%;" id="tipify3451422">
#>             <label class="control-label" id="pca-marginal.y-label" for="pca-marginal.y">Right Marginal (Y)</label>
#>             <div id="pca-marginal.y" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="close">
#>               <script type="application/json" data-for="pca-marginal.y">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["Density","Histogram","Rug"],"value":["density","histogram","rug"]}},"config":{"multiple":true,"search":false,"selectedValue":[],"hideClearButton":false,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":true,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":false,"disableOptionGroupCheckbox":false,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify3451422', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Distribution of the Y values drawn to the right of the plot, one per Color By group. Pick any of density, histogram and rug.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify28736">
#>             <label class="control-label" id="pca-marginal.x.size-label" for="pca-marginal.x.size">Top Marginal Height</label>
#>             <input id="pca-marginal.x.size" type="number" class="shiny-input-number form-control" value="0.15" data-update-on="change" min="0.05" max="0.5" step="0.05"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify28736', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Share of the plot&#39;s height given to the top marginal.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify6781008">
#>             <label class="control-label" id="pca-marginal.y.size-label" for="pca-marginal.y.size">Right Marginal Width</label>
#>             <input id="pca-marginal.y.size" type="number" class="shiny-input-number form-control" value="0.15" data-update-on="change" min="0.05" max="0.5" step="0.05"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify6781008', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Share of the plot&#39;s width given to the right marginal.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify6042523">
#>             <label class="control-label" id="pca-marginal.opacity-label" for="pca-marginal.opacity">Marginal Opacity</label>
#>             <input id="pca-marginal.opacity" type="number" class="shiny-input-number form-control" value="0.5" data-update-on="change" min="0" max="1" step="0.05"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify6042523', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Opacity of the density and histogram fills and of the rug lines.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify1191094">
#>             <label class="control-label" id="pca-marginal.bins-label" for="pca-marginal.bins">Histogram Bins</label>
#>             <input id="pca-marginal.bins" type="number" class="shiny-input-number form-control" value="30" data-update-on="change" min="1" step="1"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify1191094', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Number of histogram bins, shared by every group so their bins line up.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify8472173">
#>             <label class="control-label" id="pca-marginal.binwidth-label" for="pca-marginal.binwidth">Histogram Bin Width</label>
#>             <input id="pca-marginal.binwidth" type="number" class="shiny-input-number form-control" value="NA" data-update-on="change" min="0"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify8472173', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Width of each histogram bin, in the axis&#39; units. Overrides Histogram Bins when set. Leave blank to use Histogram Bins.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify9178706">
#>             <label class="control-label" id="pca-marginal.density.adjust-label" for="pca-marginal.density.adjust">Density Bandwidth Adjust</label>
#>             <input id="pca-marginal.density.adjust" type="number" class="shiny-input-number form-control" value="1" data-update-on="change" min="0.1" step="0.1"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify9178706', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Multiplier on the density bandwidth. Larger values give smoother curves.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify2548883">
#>             <label class="control-label" id="pca-marginal.rug.height-label" for="pca-marginal.rug.height">Rug Height</label>
#>             <input id="pca-marginal.rug.height" type="number" class="shiny-input-number form-control" value="0.3" data-update-on="change" min="0.1" max="0.9" step="0.05"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify2548883', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Share of a marginal given to its rug when the rug sits alongside a density or histogram. A rug on its own fills the marginal.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify2730494">
#>             <label class="control-label" id="pca-marginal.rug.width-label" for="pca-marginal.rug.width">Rug Line Width</label>
#>             <input id="pca-marginal.rug.width" type="number" class="shiny-input-number form-control" value="1" data-update-on="change" min="0.1" step="0.5"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify2730494', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Line width of each rug tick, in pixels.'})}, 500)});</script>
#>         </div>
#>       </div>
#>     </div>
#>     <div class="tab-pane" data-value="Plotly" id="tab-5623-10">
#>       <div class="vizmodules-input-grid" style="--viz-input-columns: 2;">
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" style="width:100%;">
#>             <label class="control-label" id="pca-download.format-label" for="pca-download.format">Download Format</label>
#>             <div id="pca-download.format" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="change">
#>               <script type="application/json" data-for="pca-download.format">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["svg","png","jpeg","webp"],"value":["svg","png","jpeg","webp"]}},"config":{"multiple":false,"search":false,"selectedValue":"svg","hideClearButton":true,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":false,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":true,"disableOptionGroupCheckbox":true,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>             </div>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify3496356">
#>             <label class="control-label" id="pca-margin.t-label" for="pca-margin.t">Margin Top</label>
#>             <input id="pca-margin.t" type="number" class="shiny-input-number form-control" value="70" data-update-on="change" min="0" step="5"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify3496356', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Top margin of the plot in pixels'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify7610533">
#>             <label class="control-label" id="pca-margin.b-label" for="pca-margin.b">Margin Bottom</label>
#>             <input id="pca-margin.b" type="number" class="shiny-input-number form-control" value="70" data-update-on="change" min="0" step="5"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify7610533', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Bottom margin of the plot in pixels'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify4041968">
#>             <label class="control-label" id="pca-margin.l-label" for="pca-margin.l">Margin Left</label>
#>             <input id="pca-margin.l" type="number" class="shiny-input-number form-control" value="70" data-update-on="change" min="0" step="5"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify4041968', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Left margin of the plot in pixels'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify2053978">
#>             <label class="control-label" id="pca-margin.r-label" for="pca-margin.r">Margin Right</label>
#>             <input id="pca-margin.r" type="number" class="shiny-input-number form-control" value="90" data-update-on="change" min="0" step="5"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify2053978', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Right margin of the plot in pixels'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour" id="tipify5872954">
#>             <label class="control-label" for="pca-shape.fill">Shape Fill</label>
#>             <input id="pca-shape.fill" type="text" class="form-control shiny-colour-input" data-init-value="rgba(0, 0, 0, 0)" data-show-colour="both" data-palette="square" data-allow-alpha="true"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify5872954', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Interior fill color for shapes drawn on the plot using Plotly&#39;s drawing tools'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour" id="tipify5982019">
#>             <label class="control-label" for="pca-shape.line.color">Shape Line Color</label>
#>             <input id="pca-shape.line.color" type="text" class="form-control shiny-colour-input" data-init-value="black" data-show-colour="both" data-palette="square" data-allow-alpha="true"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify5982019', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Outline color for shapes drawn on the plot using Plotly&#39;s drawing tools'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify692913">
#>             <label class="control-label" id="pca-shape.line.width-label" for="pca-shape.line.width">Shape Line Width</label>
#>             <input id="pca-shape.line.width" type="number" class="shiny-input-number form-control" value="4" data-update-on="change" min="0" step="0.25"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify692913', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Outline width for shapes drawn on the plot using Plotly&#39;s drawing tools'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" style="width:100%;" id="tipify7970514">
#>             <label class="control-label" id="pca-shape.linetype-label" for="pca-shape.linetype">Shape Linetype</label>
#>             <div id="pca-shape.linetype" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="change">
#>               <script type="application/json" data-for="pca-shape.linetype">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["solid","dot","dash","longdash","dashdot","longdashdot"],"value":["solid","dot","dash","longdash","dashdot","longdashdot"]}},"config":{"multiple":false,"search":false,"selectedValue":"solid","hideClearButton":true,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":false,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":true,"disableOptionGroupCheckbox":true,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify7970514', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Line dash style for shapes drawn on the plot using Plotly&#39;s drawing tools'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify7656792">
#>             <label class="control-label" id="pca-shape.opacity-label" for="pca-shape.opacity">Shape Opacity</label>
#>             <input id="pca-shape.opacity" type="number" class="shiny-input-number form-control" value="1" data-update-on="change" min="0" max="1" step="0.01"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify7656792', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Opacity of shapes drawn on the plot, where 0 is fully transparent and 1 is fully opaque'})}, 500)});</script>
#>         </div>
#>       </div>
#>     </div>
#>     <div class="tab-pane" data-value="Extras" id="tab-5623-11">
#>       <div class="vizmodules-input-grid" style="--viz-input-columns: 2;">
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify8335777">
#>             <div class="checkbox">
#>               <label>
#>                 <input id="pca-webgl" type="checkbox" class="shiny-input-checkbox" checked="checked"/>
#>                 <span>Plot with webGL</span>
#>               </label>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify8335777', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Enable WebGL rendering for improved performance with large datasets at the cost of some visual features'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify87149">
#>             <div class="checkbox">
#>               <label>
#>                 <input id="pca-do.ellipse" type="checkbox" class="shiny-input-checkbox"/>
#>                 <span>Enable Ellipses</span>
#>               </label>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify87149', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Logical. Whether `color.by` groups should be surrounded by median-centered ellipses.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify5998696">
#>             <div class="checkbox">
#>               <label>
#>                 <input id="pca-do.contour" type="checkbox" class="shiny-input-checkbox"/>
#>                 <span>Enable Contour</span>
#>               </label>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify5998696', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Logical. Whether density-based contours should be displayed.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" style="width:100%;" id="tipify4739241">
#>             <label class="control-label" id="pca-hover.data-label" for="pca-hover.data">Hover Data</label>
#>             <div id="pca-hover.data" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="close">
#>               <script type="application/json" data-for="pca-hover.data">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["(none)","sample","PC1","PC2","PC3","PC4","PC5","PC6","PC7","PC8","SampleName","cell","dex","albut","Run","avgLength","Experiment","Sample","BioSample"],"value":["","sample","PC1","PC2","PC3","PC4","PC5","PC6","PC7","PC8","SampleName","cell","dex","albut","Run","avgLength","Experiment","Sample","BioSample"]}},"config":{"multiple":true,"search":true,"selectedValue":"sample","hideClearButton":false,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":true,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":false,"disableOptionGroupCheckbox":false,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify4739241', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'String vector which denotes what data to show for each data point, upon hover, when `do.hover` is set to `TRUE`. Defaults to all data expected to be useful. Only values present in the plotting data are actually used. These can be column names of `data_frame` and any column names which will be created to accommodate multivar and data adjustment functionality. You can run the function with `data.out = TRUE` and inspect the `$Target_data` output&#39;s columns to view your available options.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify3909496">
#>             <label class="control-label" id="pca-hover.round.digits-label" for="pca-hover.round.digits">Hover Round Digits</label>
#>             <input id="pca-hover.round.digits" type="number" class="shiny-input-number form-control" value="5" data-update-on="change" min="1" step="1"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify3909496', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Integer number specifying the number of decimal digits to round displayed numeric values to, when `do.hover` is set to `TRUE`.'})}, 500)});</script>
#>         </div>
#>       </div>
#>     </div>
#>     <div class="tab-pane" data-value="Lines" id="tab-5623-12">
#>       <div class="vizmodules-input-grid" style="--viz-input-columns: 2;">
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify3192830">
#>             <label class="control-label" id="pca-hline.intercepts-label" for="pca-hline.intercepts">Y-intercepts</label>
#>             <input id="pca-hline.intercepts" type="text" class="shiny-input-text form-control" value="" placeholder="e.g. 2, -2" data-update-on="change"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify3192830', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'For categorical or factor axes, enter the index (position) of the category rather than its name. For example, if the axis categories are &#39;Audi&#39;, &#39;Mercedes&#39;, &#39;Bugatti&#39;, enter 2 to place a line at &#39;Mercedes&#39;.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify612198">
#>             <label class="control-label" id="pca-hline.colors-label" for="pca-hline.colors">Y Colors</label>
#>             <input id="pca-hline.colors" type="text" class="shiny-input-text form-control" value="#000000" data-update-on="change"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify612198', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Color(s) for horizontal reference lines, as comma-separated hex codes or color names'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify3895407">
#>             <label class="control-label" id="pca-hline.widths-label" for="pca-hline.widths">Y Widths</label>
#>             <input id="pca-hline.widths" type="text" class="shiny-input-text form-control" value="1" data-update-on="change"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify3895407', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Width(s) for horizontal reference lines in pixels, as comma-separated values'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify7866776">
#>             <label class="control-label" id="pca-hline.linetypes-label" for="pca-hline.linetypes">Y Line Types</label>
#>             <input id="pca-hline.linetypes" type="text" class="shiny-input-text form-control" value="dashed" placeholder="solid, dashed, dotted, ..." data-update-on="change"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify7866776', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Line style(s) for horizontal reference lines (solid, dashed, dotted, dotdash, longdash, twodash)'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify7172991">
#>             <label class="control-label" id="pca-hline.opacities-label" for="pca-hline.opacities">Y Opacities (0-1)</label>
#>             <input id="pca-hline.opacities" type="text" class="shiny-input-text form-control" value="1" data-update-on="change"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify7172991', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Opacity of horizontal reference lines between 0 (transparent) and 1 (opaque), as comma-separated values'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify804277">
#>             <label class="control-label" id="pca-vline.intercepts-label" for="pca-vline.intercepts">X-intercepts</label>
#>             <input id="pca-vline.intercepts" type="text" class="shiny-input-text form-control" value="" placeholder="e.g. 2, -2" data-update-on="change"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify804277', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'For categorical or factor axes, enter the index (position) of the category rather than its name. For example, if the axis categories are &#39;Audi&#39;, &#39;Mercedes&#39;, &#39;Bugatti&#39;, enter 2 to place a line at &#39;Mercedes&#39;.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify4185217">
#>             <label class="control-label" id="pca-vline.colors-label" for="pca-vline.colors">X Colors</label>
#>             <input id="pca-vline.colors" type="text" class="shiny-input-text form-control" value="#000000" data-update-on="change"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify4185217', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Color(s) for vertical reference lines, as comma-separated hex codes or color names'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify710567">
#>             <label class="control-label" id="pca-vline.widths-label" for="pca-vline.widths">X Widths</label>
#>             <input id="pca-vline.widths" type="text" class="shiny-input-text form-control" value="1" data-update-on="change"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify710567', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Width(s) for vertical reference lines in pixels, as comma-separated values'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify5928493">
#>             <label class="control-label" id="pca-vline.linetypes-label" for="pca-vline.linetypes">X Line Types</label>
#>             <input id="pca-vline.linetypes" type="text" class="shiny-input-text form-control" value="dashed" placeholder="solid, dashed, dotted, ..." data-update-on="change"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify5928493', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Line style(s) for vertical reference lines (solid, dashed, dotted, dotdash, longdash, twodash)'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify6632329">
#>             <label class="control-label" id="pca-vline.opacities-label" for="pca-vline.opacities">X Opacities (0-1)</label>
#>             <input id="pca-vline.opacities" type="text" class="shiny-input-text form-control" value="1" data-update-on="change"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify6632329', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Opacity of vertical reference lines between 0 (transparent) and 1 (opaque), as comma-separated values'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify5440445">
#>             <label class="control-label" id="pca-abline.slopes-label" for="pca-abline.slopes">Ab Slopes</label>
#>             <input id="pca-abline.slopes" type="text" class="shiny-input-text form-control" value="" data-update-on="change"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify5440445', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Slope(s) of diagonal reference lines (rise/run), as comma-separated values'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify7820210">
#>             <label class="control-label" id="pca-abline.intercepts-label" for="pca-abline.intercepts">Ab Y-intercepts</label>
#>             <input id="pca-abline.intercepts" type="text" class="shiny-input-text form-control" value="" data-update-on="change"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify7820210', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'For categorical or factor axes, enter the index (position) of the category rather than its name. For example, if the axis categories are &#39;Audi&#39;, &#39;Mercedes&#39;, &#39;Bugatti&#39;, enter 2 to place a line at &#39;Mercedes&#39;.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify6080354">
#>             <label class="control-label" id="pca-abline.colors-label" for="pca-abline.colors">Ab Colors</label>
#>             <input id="pca-abline.colors" type="text" class="shiny-input-text form-control" value="#000000" data-update-on="change"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify6080354', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Color(s) for diagonal reference lines, as comma-separated hex codes or color names'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify891744">
#>             <label class="control-label" id="pca-abline.widths-label" for="pca-abline.widths">Ab Widths</label>
#>             <input id="pca-abline.widths" type="text" class="shiny-input-text form-control" value="1" data-update-on="change"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify891744', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Width(s) for diagonal reference lines in pixels, as comma-separated values'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify9423625">
#>             <label class="control-label" id="pca-abline.linetypes-label" for="pca-abline.linetypes">Ab Line Types</label>
#>             <input id="pca-abline.linetypes" type="text" class="shiny-input-text form-control" value="dashed" placeholder="solid, dashed, dotted, ..." data-update-on="change"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify9423625', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Line style(s) for diagonal reference lines (solid, dashed, dotted, dotdash, longdash, twodash)'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify9064601">
#>             <label class="control-label" id="pca-abline.opacities-label" for="pca-abline.opacities">Ab Opacities (0-1)</label>
#>             <input id="pca-abline.opacities" type="text" class="shiny-input-text form-control" value="1" data-update-on="change"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify9064601', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Opacity of diagonal reference lines between 0 (transparent) and 1 (opaque), as comma-separated values'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify7149037">
#>             <div class="material-switch">
#>               <label for="pca-best.fit" style="padding-right: 10px;">Plot Best Fit Line</label>
#>               <input id="pca-best.fit" type="checkbox"/>
#>               <label class="switch label-success bg-success" for="pca-best.fit"></label>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify7149037', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Add a LOESS smoothed curve of best fit to the scatter plot'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify6405922">
#>             <label class="control-label" id="pca-line.best.smoothness-label" for="pca-line.best.smoothness">Best Fit Line Smoothness</label>
#>             <input id="pca-line.best.smoothness" type="number" class="shiny-input-number form-control" value="1" data-update-on="change" min="0" max="10000"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify6405922', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Smoothing span for the LOESS curve; higher values produce a smoother, less wiggly fit'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour" id="tipify4762322">
#>             <label class="control-label" for="pca-line.best.colour">Best Fit Line Color</label>
#>             <input id="pca-line.best.colour" type="text" class="form-control shiny-colour-input" data-init-value="#000000" data-show-colour="both" data-palette="square"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify4762322', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Color for the LOESS best fit line'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify271145">
#>             <div class="material-switch">
#>               <label for="pca-linear.model" style="padding-right: 10px;">Linear Model Line</label>
#>               <input id="pca-linear.model" type="checkbox"/>
#>               <label class="switch label-success bg-success" for="pca-linear.model"></label>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify271145', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Add a linear regression line to the scatter plot'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify4405450">
#>             <div class="material-switch">
#>               <label for="pca-custom.model.enable" style="padding-right: 10px;">Custom Model Lines</label>
#>               <input id="pca-custom.model.enable" type="checkbox"/>
#>               <label class="switch label-success bg-success" for="pca-custom.model.enable"></label>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify4405450', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Fit one or more custom models from formulas you define below and overlay them as lines. Only data columns and basic math/transform terms are allowed.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="multi-dynamic-input shiny-input-container form-group is-plain" id="pca-custom.models" data-keys="[&quot;model_type&quot;,&quot;formula&quot;,&quot;line_colour&quot;,&quot;line_width&quot;,&quot;drc_fct&quot;]" data-initial="[]" data-input-id="pca-custom.models" data-row-prefix="models">
#>             <div class="mdi-top">
#>               <label class="control-label" for="pca-custom.models">Models</label>
#>               <button type="button" class="mdi-add btn btn-default btn-sm">+ Add</button>
#>             </div>
#>             <div class="mdi-rows"></div>
#>             <template class="mdi-row-template">
#>               <div class="mdi-row">
#>                 <div class="mdi-fields">
#>                   <div class="mdi-field" data-key="model_type" style="flex: 1 1 calc(25% - 8px); min-width: 120px;">
#>                     <div class="form-group shiny-input-container">
#>                       <label class="control-label" id="pca-custom.models-__ROWIDX__-model_type-label" for="pca-custom.models-__ROWIDX__-model_type">Model type</label>
#>                       <div>
#>                         <select id="pca-custom.models-__ROWIDX__-model_type" class="shiny-input-select"><option value="drm">drm</option>
#> <option value="glm">glm</option>
#> <option value="lm" selected>lm</option>
#> <option value="loess">loess</option></select>
#>                         <script type="application/json" data-for="pca-custom.models-__ROWIDX__-model_type" data-nonempty="">{"plugins":["selectize-plugin-a11y"]}</script>
#>                       </div>
#>                     </div>
#>                   </div>
#>                   <div class="mdi-field" data-key="formula" style="flex: 1 1 calc(25% - 8px); min-width: 120px;">
#>                     <div class="form-group shiny-input-container">
#>                       <label class="control-label" id="pca-custom.models-__ROWIDX__-formula-label" for="pca-custom.models-__ROWIDX__-formula">Formula</label>
#>                       <input id="pca-custom.models-__ROWIDX__-formula" type="text" class="shiny-input-text form-control" value="" placeholder="e.g. y ~ poly(x, 2)" data-update-on="change"/>
#>                     </div>
#>                   </div>
#>                   <div class="mdi-field" data-key="line_colour" style="flex: 1 1 calc(25% - 8px); min-width: 120px;">
#>                     <div class="form-group shiny-input-container" data-shiny-input-type="colour">
#>                       <label class="control-label" for="pca-custom.models-__ROWIDX__-line_colour">Line colour</label>
#>                       <input id="pca-custom.models-__ROWIDX__-line_colour" type="text" class="form-control shiny-colour-input" data-init-value="#000000" data-show-colour="both" data-palette="square"/>
#>                     </div>
#>                   </div>
#>                   <div class="mdi-field" data-key="line_width" style="flex: 1 1 calc(25% - 8px); min-width: 120px;">
#>                     <div class="form-group shiny-input-container">
#>                       <label class="control-label" id="pca-custom.models-__ROWIDX__-line_width-label" for="pca-custom.models-__ROWIDX__-line_width">Line width</label>
#>                       <input id="pca-custom.models-__ROWIDX__-line_width" type="number" class="shiny-input-number form-control" value="2" data-update-on="change" min="0.5" max="20" step="0.5"/>
#>                     </div>
#>                   </div>
#>                   <div class="mdi-field" data-key="drc_fct" data-backend="drm" style="flex: 1 1 calc(25% - 8px); min-width: 120px; display: none;">
#>                     <div class="form-group shiny-input-container">
#>                       <label class="control-label" id="pca-custom.models-__ROWIDX__-drc_fct-label" for="pca-custom.models-__ROWIDX__-drc_fct">Drc fct</label>
#>                       <div>
#>                         <select id="pca-custom.models-__ROWIDX__-drc_fct" class="shiny-input-select"><option value="LL.4" selected>LL.4</option>
#> <option value="LL.3">LL.3</option>
#> <option value="LL.2">LL.2</option>
#> <option value="W1.4">W1.4</option>
#> <option value="W2.4">W2.4</option></select>
#>                         <script type="application/json" data-for="pca-custom.models-__ROWIDX__-drc_fct" data-nonempty="">{"plugins":["selectize-plugin-a11y"]}</script>
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
#>     <div class="tab-pane" data-value="Axes" id="tab-5623-13">
#>       <div class="vizmodules-input-grid" style="--viz-input-columns: 2;">
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" style="width:100%;">
#>             <label class="control-label" id="pca-title.font.family-label" for="pca-title.font.family">Title Font</label>
#>             <div id="pca-title.font.family" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="change">
#>               <script type="application/json" data-for="pca-title.font.family">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["Arial","Balto","Courier New","Droid Sans","Droid Serif","Droid Sans Mono","Gravitas One","Old Standard TT","Open Sans","Overpass","PT Sans Narrow","Raleway","Times New Roman","Verdana","sans-serif","serif","monospace"],"value":["Arial","Balto","Courier New","Droid Sans","Droid Serif","Droid Sans Mono","Gravitas One","Old Standard TT","Open Sans","Overpass","PT Sans Narrow","Raleway","Times New Roman","Verdana","sans-serif","serif","monospace"]}},"config":{"multiple":false,"search":true,"selectedValue":"Arial","hideClearButton":true,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":false,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":true,"disableOptionGroupCheckbox":true,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>             </div>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour">
#>             <label class="control-label" for="pca-title.font.color">Title Color</label>
#>             <input id="pca-title.font.color" type="text" class="form-control shiny-colour-input" data-init-value="#000000" data-show-colour="both" data-palette="square"/>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="pca-title.font.size-label" for="pca-title.font.size">Title Size</label>
#>             <input id="pca-title.font.size" type="number" class="shiny-input-number form-control" value="26" data-update-on="change" min="1" step="1"/>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="pca-axis.title.horizontal.position-label" for="pca-axis.title.horizontal.position">Title position</label>
#>             <input id="pca-axis.title.horizontal.position" type="number" class="shiny-input-number form-control" value="0.5" data-update-on="change" min="0" max="1" step="0.1"/>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="pca-axis.title.font.size-label" for="pca-axis.title.font.size">Axis Title Size</label>
#>             <input id="pca-axis.title.font.size" type="number" class="shiny-input-number form-control" value="18" data-update-on="change" min="1" step="1"/>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour">
#>             <label class="control-label" for="pca-axis.title.font.color">Axis Title Color</label>
#>             <input id="pca-axis.title.font.color" type="text" class="form-control shiny-colour-input" data-init-value="#000000" data-show-colour="both" data-palette="square"/>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" style="width:100%;">
#>             <label class="control-label" id="pca-axis.title.font.family-label" for="pca-axis.title.font.family">Axis Title Font</label>
#>             <div id="pca-axis.title.font.family" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="change">
#>               <script type="application/json" data-for="pca-axis.title.font.family">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["Arial","Balto","Courier New","Droid Sans","Droid Serif","Droid Sans Mono","Gravitas One","Old Standard TT","Open Sans","Overpass","PT Sans Narrow","Raleway","Times New Roman","Verdana","sans-serif","serif","monospace"],"value":["Arial","Balto","Courier New","Droid Sans","Droid Serif","Droid Sans Mono","Gravitas One","Old Standard TT","Open Sans","Overpass","PT Sans Narrow","Raleway","Times New Roman","Verdana","sans-serif","serif","monospace"]}},"config":{"multiple":false,"search":true,"selectedValue":"Arial","hideClearButton":true,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":false,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":true,"disableOptionGroupCheckbox":true,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>             </div>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container">
#>             <div class="checkbox">
#>               <label>
#>                 <input id="pca-axis.showline" type="checkbox" class="shiny-input-checkbox" checked="checked"/>
#>                 <span>Show Axis Borders</span>
#>               </label>
#>             </div>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container">
#>             <div class="checkbox">
#>               <label>
#>                 <input id="pca-axis.mirror" type="checkbox" class="shiny-input-checkbox" checked="checked"/>
#>                 <span>Mirror Axis Borders</span>
#>               </label>
#>             </div>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container">
#>             <div class="checkbox">
#>               <label>
#>                 <input id="pca-show.grid.x" type="checkbox" class="shiny-input-checkbox" checked="checked"/>
#>                 <span>Show X Gridlines</span>
#>               </label>
#>             </div>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container">
#>             <div class="checkbox">
#>               <label>
#>                 <input id="pca-show.grid.y" type="checkbox" class="shiny-input-checkbox" checked="checked"/>
#>                 <span>Show Y Gridlines</span>
#>               </label>
#>             </div>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour">
#>             <label class="control-label" for="pca-grid.color">Gridline Color</label>
#>             <input id="pca-grid.color" type="text" class="form-control shiny-colour-input" data-init-value="#CCCCCC" data-show-colour="both" data-palette="square"/>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour">
#>             <label class="control-label" for="pca-axis.linecolor">Axis Line Color</label>
#>             <input id="pca-axis.linecolor" type="text" class="form-control shiny-colour-input" data-init-value="black" data-show-colour="both" data-palette="square"/>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="pca-axis.linewidth-label" for="pca-axis.linewidth">Axis Line Width</label>
#>             <input id="pca-axis.linewidth" type="number" class="shiny-input-number form-control" value="0.5" data-update-on="change" min="0" step="0.1"/>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="pca-axis.tickfont.size-label" for="pca-axis.tickfont.size">Tick Label Size</label>
#>             <input id="pca-axis.tickfont.size" type="number" class="shiny-input-number form-control" value="12" data-update-on="change" min="1" step="1"/>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour">
#>             <label class="control-label" for="pca-axis.tickfont.color">Tick Label Color</label>
#>             <input id="pca-axis.tickfont.color" type="text" class="form-control shiny-colour-input" data-init-value="black" data-show-colour="both" data-palette="square"/>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" style="width:100%;">
#>             <label class="control-label" id="pca-axis.tickfont.family-label" for="pca-axis.tickfont.family">Tick Label Font</label>
#>             <div id="pca-axis.tickfont.family" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="change">
#>               <script type="application/json" data-for="pca-axis.tickfont.family">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["Arial","Balto","Courier New","Droid Sans","Droid Serif","Droid Sans Mono","Gravitas One","Old Standard TT","Open Sans","Overpass","PT Sans Narrow","Raleway","Times New Roman","Verdana","sans-serif","serif","monospace"],"value":["Arial","Balto","Courier New","Droid Sans","Droid Serif","Droid Sans Mono","Gravitas One","Old Standard TT","Open Sans","Overpass","PT Sans Narrow","Raleway","Times New Roman","Verdana","sans-serif","serif","monospace"]}},"config":{"multiple":false,"search":true,"selectedValue":"Arial","hideClearButton":true,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":false,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":true,"disableOptionGroupCheckbox":true,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>             </div>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="pca-axis.tickangle.x-label" for="pca-axis.tickangle.x">X Tick Label Angle</label>
#>             <input id="pca-axis.tickangle.x" type="number" class="shiny-input-number form-control" value="0" data-update-on="change" min="-180" max="180" step="15"/>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="pca-axis.tickangle.y-label" for="pca-axis.tickangle.y">Y Tick Label Angle</label>
#>             <input id="pca-axis.tickangle.y" type="number" class="shiny-input-number form-control" value="0" data-update-on="change" min="-180" max="180" step="15"/>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" style="width:100%;">
#>             <label class="control-label" id="pca-axis.ticks-label" for="pca-axis.ticks">Tick Position</label>
#>             <div id="pca-axis.ticks" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="change">
#>               <script type="application/json" data-for="pca-axis.ticks">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["Outside","Inside","(none)"],"value":["outside","inside",""]}},"config":{"multiple":false,"search":false,"selectedValue":"outside","hideClearButton":true,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":false,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":true,"disableOptionGroupCheckbox":true,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>             </div>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour">
#>             <label class="control-label" for="pca-axis.tickcolor">Tick Mark Color</label>
#>             <input id="pca-axis.tickcolor" type="text" class="form-control shiny-colour-input" data-init-value="black" data-show-colour="both" data-palette="square"/>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="pca-axis.ticklen-label" for="pca-axis.ticklen">Tick Mark Length</label>
#>             <input id="pca-axis.ticklen" type="number" class="shiny-input-number form-control" value="5" data-update-on="change" min="0" step="1"/>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="pca-axis.tickwidth-label" for="pca-axis.tickwidth">Tick Mark Width</label>
#>             <input id="pca-axis.tickwidth" type="number" class="shiny-input-number form-control" value="1" data-update-on="change" min="0" step="0.1"/>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="pca-facet.title.font.size-label" for="pca-facet.title.font.size">Facet Subplot Title Size</label>
#>             <input id="pca-facet.title.font.size" type="number" class="shiny-input-number form-control" value="18" data-update-on="change" min="1" step="1"/>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour">
#>             <label class="control-label" for="pca-facet.title.font.color">Facet Title Color</label>
#>             <input id="pca-facet.title.font.color" type="text" class="form-control shiny-colour-input" data-init-value="#000000" data-show-colour="both" data-palette="square"/>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" style="width:100%;">
#>             <label class="control-label" id="pca-facet.title.font.family-label" for="pca-facet.title.font.family">Facet Title Font</label>
#>             <div id="pca-facet.title.font.family" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="change">
#>               <script type="application/json" data-for="pca-facet.title.font.family">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["Arial","Balto","Courier New","Droid Sans","Droid Serif","Droid Sans Mono","Gravitas One","Old Standard TT","Open Sans","Overpass","PT Sans Narrow","Raleway","Times New Roman","Verdana","sans-serif","serif","monospace"],"value":["Arial","Balto","Courier New","Droid Sans","Droid Serif","Droid Sans Mono","Gravitas One","Old Standard TT","Open Sans","Overpass","PT Sans Narrow","Raleway","Times New Roman","Verdana","sans-serif","serif","monospace"]}},"config":{"multiple":false,"search":true,"selectedValue":"Arial","hideClearButton":true,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":false,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":true,"disableOptionGroupCheckbox":true,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
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
#>         <label for="pca-auto.update" style="padding-right: 10px;">Auto Update</label>
#>         <input id="pca-auto.update" type="checkbox" checked="checked"/>
#>         <label class="switch label-success bg-success" for="pca-auto.update"></label>
#>       </div>
#>     </div>
#>   </div>
#>   <div class="module-tack-buttons" style="display: flex; flex-wrap: wrap; gap: 8px;">
#>     <button class="btn btn-default action-button btn-primary" id="pca-update" style="flex: 1 1 45%;" type="button"><span class="action-label">Update</span></button>
#>     <button class="btn btn-default action-button btn-secondary" id="pca-reset" style="flex: 1 1 45%;" type="button"><span class="action-label">Reset</span></button>
#>     <a aria-disabled="true" class="btn btn-default shiny-download-link disabled btn-secondary viz-source-download" data-viz-source-ns="pca-" download href="" id="pca-download.source" style="flex: 1 1 100%;" tabindex="-1" target="_blank">
#>       <i class="far fa-file-code" role="presentation" aria-label="file-code icon"></i>
#>       Source Download
#>     </a>
#>     <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('pca-download.source', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Download the plot as a self-contained HTML file and as SVG and PNG images of it as it looks now, along with the plot source data and statistics (if applicable) as CSV files.'})}, 500)});</script>
#>   </div>
#> </div>
```
