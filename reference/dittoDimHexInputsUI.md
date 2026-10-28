# Input UI components for the dittoDimHex module

This should be placed in the UI where the inputs should be shown, with
an `id` that matches the `id` used in the
[`dittoDimHexServer()`](https://j-andrews7.github.io/sciVizModules/reference/dittoDimHexServer.md)
and
[`dittoDimHexOutputUI()`](https://j-andrews7.github.io/sciVizModules/reference/dittoDimHexOutputUI.md)
functions.

## Usage

``` r
dittoDimHexInputsUI(
  id,
  data,
  defaults = NULL,
  title = "DimHex Settings",
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
[`dittoSeq::dittoDimHex()`](https://rdrr.io/pkg/dittoSeq/man/dittoHex.html),
which bins the cells/samples of a dimensionality reduction embedding
into hexagons and (optionally) summarizes a gene/metadata within each
bin. The resulting `ggplot` is converted to an interactive `plotly`
figure.

## Plot parameters and defaults

The following parameters can be accessed via UI inputs and/or the
`defaults` argument:

- `color.var` - Gene or metadata summarized within each hex (default:
  density only)

- `reduction.use` - Dimensionality reduction to plot (default:
  auto-detected)

- `dim.1`, `dim.2` - Which dimensions to plot on x/y (default: 1 and 2)

- `bins` - Number of hexagonal bins (default: 30)

- `color.method` - Summary method for discrete `color.var` ("max.prop"
  or a metadata level) or for continuous data ("median", "mean", etc.)

- `split.by` - Discrete metadata to facet by (default: none)

- `min.color`, `max.color` - Colors for the continuous color scale

- `do.contour` - Overlay kernel-density contour lines (default: FALSE)

- `do.label` - Draw group labels for a discrete `color.var` (default:
  FALSE)

- `labels.size` - Text size of the group labels (default: 5)

- `do.ellipse` - Draw ellipses for a discrete `color.var` (default:
  FALSE)

## See also

[`dittoSeq::dittoDimHex()`](https://rdrr.io/pkg/dittoSeq/man/dittoHex.html),
[`VizModules::organize_inputs()`](https://j-andrews7.github.io/VizModules/reference/organize_inputs.html),
[`dittoDimHexOutputUI()`](https://j-andrews7.github.io/sciVizModules/reference/dittoDimHexOutputUI.md),
[`dittoDimHexServer()`](https://j-andrews7.github.io/sciVizModules/reference/dittoDimHexServer.md),
[`dittoDimHexApp()`](https://j-andrews7.github.io/sciVizModules/reference/dittoDimHexApp.md)

## Author

Jacob Martin

## Examples

``` r
library(sciVizModules)
data(example_sce)
dittoDimHexInputsUI("dittoDimHex", example_sce)
#> <h3>DimHex Settings</h3>
#> <div class="tabbable vizmodules-input-tabs">
#>   <ul class="nav nav-tabs shiny-tab-input" id="dittoDimHex-dittoDimHexTabsetPanel" data-tabsetid="9173">
#>     <li class="active">
#>       <a href="#tab-9173-1" data-toggle="tab" data-bs-toggle="tab" data-value="Data">Data</a>
#>     </li>
#>     <li>
#>       <a href="#tab-9173-2" data-toggle="tab" data-bs-toggle="tab" data-value="Aesthetics">Aesthetics</a>
#>     </li>
#>     <li>
#>       <a href="#tab-9173-3" data-toggle="tab" data-bs-toggle="tab" data-value="Plotly">Plotly</a>
#>     </li>
#>     <li>
#>       <a href="#tab-9173-4" data-toggle="tab" data-bs-toggle="tab" data-value="Axes">Axes</a>
#>     </li>
#>     <li>
#>       <a href="#tab-9173-5" data-toggle="tab" data-bs-toggle="tab" data-value="Legend">Legend</a>
#>     </li>
#>     <li>
#>       <a href="#tab-9173-6" data-toggle="tab" data-bs-toggle="tab" data-value="Lines">Lines</a>
#>     </li>
#>   </ul>
#>   <div class="tab-content" data-tabsetid="9173">
#>     <div class="tab-pane active" data-value="Data" id="tab-9173-1">
#>       <div class="vizmodules-input-grid" style="--viz-input-columns: 2;">
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" style="width:100%;" id="tipify8809342">
#>             <label class="control-label" id="dittoDimHex-color.var-label" for="dittoDimHex-color.var">Color By (gene / metadata)</label>
#>             <div id="dittoDimHex-color.var" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="change">
#>               <script type="application/json" data-for="dittoDimHex-color.var">{"stateInput":false,"options":{"type":["transpose_group"],"choices":[{"label":[" "],"options":{"label":[""],"value":[""]}},{"label":["Metadata"],"options":{"label":["clustering","celltype","condition","sample","nCount","percent.mito"],"value":["clustering","celltype","condition","sample","nCount","percent.mito"]}},{"label":["Genes"],"options":{"label":["Gene1","Gene2","Gene3","Gene4","Gene5","Gene6","Gene7","Gene8","Gene9","Gene10","Gene11","Gene12","Gene13","Gene14","Gene15","Gene16","Gene17","Gene18","Gene19","Gene20","Gene21","Gene22","Gene23","Gene24","Gene25","Gene26","Gene27","Gene28","Gene29","Gene30","Gene31","Gene32","Gene33","Gene34","Gene35","Gene36","Gene37","Gene38","Gene39","Gene40"],"value":["Gene1","Gene2","Gene3","Gene4","Gene5","Gene6","Gene7","Gene8","Gene9","Gene10","Gene11","Gene12","Gene13","Gene14","Gene15","Gene16","Gene17","Gene18","Gene19","Gene20","Gene21","Gene22","Gene23","Gene24","Gene25","Gene26","Gene27","Gene28","Gene29","Gene30","Gene31","Gene32","Gene33","Gene34","Gene35","Gene36","Gene37","Gene38","Gene39","Gene40"]}}]},"config":{"multiple":false,"search":true,"selectedValue":"","hideClearButton":true,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":false,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":true,"disableOptionGroupCheckbox":true,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify8809342', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Single string giving a gene or metadata that will set the color of cells/samples in the plot.  Alternatively, can be a directly supplied numeric or string vector or a factor of length equal to the total number of cells/samples in `object`.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" style="width:100%;" id="tipify9611162">
#>             <label class="control-label" id="dittoDimHex-reduction.use-label" for="dittoDimHex-reduction.use">Reduction</label>
#>             <div id="dittoDimHex-reduction.use" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="change">
#>               <script type="application/json" data-for="dittoDimHex-reduction.use">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["PCA","TSNE","UMAP"],"value":["PCA","TSNE","UMAP"]}},"config":{"multiple":false,"search":false,"selectedValue":"PCA","hideClearButton":true,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":false,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":true,"disableOptionGroupCheckbox":true,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify9611162', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'String, such as "pca", "tsne", "umap", or "PCA", etc, which is the name of a dimensionality reduction slot within the object, and which sets what dimensionality reduction space within the object to use.  Default = the first dimensionality reduction slot inside the object with "umap", "tsne", or "pca" within its name, (priority: UMAP > t-SNE > PCA) or the first dimensionality reduction slot if none of those exist.  Alternatively, a matrix (or data.frame) containing the dimensionality reduction embeddings themselves. The matrix should have as many rows as there are cells/samples in the `object`. Note that `dim.1` and `dim.2` will still be used to select which columns to pull from, and column names will serve as the default `xlab` & `ylab`.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify40185">
#>             <label class="control-label" id="dittoDimHex-dim.1-label" for="dittoDimHex-dim.1">X Dimension</label>
#>             <input id="dittoDimHex-dim.1" type="number" class="shiny-input-number form-control" value="1" data-update-on="change" min="1" step="1"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify40185', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': ''})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify5529002">
#>             <label class="control-label" id="dittoDimHex-dim.2-label" for="dittoDimHex-dim.2">Y Dimension</label>
#>             <input id="dittoDimHex-dim.2" type="number" class="shiny-input-number form-control" value="2" data-update-on="change" min="1" step="1"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify5529002', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': ''})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify2192360">
#>             <label class="control-label" id="dittoDimHex-bins-label" for="dittoDimHex-bins">Hex Bins</label>
#>             <input id="dittoDimHex-bins" type="number" class="shiny-input-number form-control" value="30" data-update-on="change" min="2" step="1"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify2192360', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Numeric or numeric vector giving the number of haxagonal bins in the x and y directions. Set to 30 by default.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify6467271">
#>             <label class="control-label" id="dittoDimHex-color.method-label" for="dittoDimHex-color.method">Color Method</label>
#>             <input id="dittoDimHex-color.method" type="text" class="shiny-input-text form-control" value="" data-update-on="change"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify6467271', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Works differently depending on whether the `color.var`-data is continuous versus discrete:  strong{Continuous}: String naming a function for how target data should be summarized for each bin. Can be any function that summarizes a numeric vector input with a single numeric output value. Default is `median`. Other useful options are `sum`, `mean`, `sd`, or `mad`. You can also use a previously assigned function; e.g. first run `pNonZero <- function(x) { sum(x!=0)/length(x)`}, then you give `color.method = "pNonZero"`  strong{Discrete}: A string signifying whether the color should (default) be simply based on the "max" grouping of the bin, based on "prop.<value>" the proportion of a specific value (e.g. "prop.A" or "prop.TRUE"), or based on the "max.prop"ortion of cells/samples belonging to any grouping.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" style="width:100%;" id="tipify7277020">
#>             <label class="control-label" id="dittoDimHex-split.by-label" for="dittoDimHex-split.by">Split By (facet)</label>
#>             <div id="dittoDimHex-split.by" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="change">
#>               <script type="application/json" data-for="dittoDimHex-split.by">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["(none)","clustering","celltype","condition","sample"],"value":["","clustering","celltype","condition","sample"]}},"config":{"multiple":false,"search":false,"selectedValue":"","hideClearButton":true,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":false,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":true,"disableOptionGroupCheckbox":true,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify7277020', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': '1 or 2 strings naming discrete metadata to use for splitting the cells/samples into multiple plots with ggplot faceting.  When 2 metadatas are named, c(row,col), the first is used as rows and the second is used for columns of the resulting grid.  When 1 metadata is named, shape control can be achieved with `split.nrow` and `split.ncol`'})}, 500)});</script>
#>         </div>
#>       </div>
#>     </div>
#>     <div class="tab-pane" data-value="Aesthetics" id="tab-9173-2">
#>       <div class="vizmodules-input-grid" style="--viz-input-columns: 2;">
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour" id="tipify8725874">
#>             <label class="control-label" for="dittoDimHex-min.color">Min Color</label>
#>             <input id="dittoDimHex-min.color" type="text" class="form-control shiny-colour-input" data-init-value="#F0E442" data-show-colour="both" data-palette="square"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify8725874', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': ''})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour" id="tipify3819816">
#>             <label class="control-label" for="dittoDimHex-max.color">Max Color</label>
#>             <input id="dittoDimHex-max.color" type="text" class="form-control shiny-colour-input" data-init-value="#0072B2" data-show-colour="both" data-palette="square"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify3819816', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': ''})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify8927457">
#>             <label class="control-label" id="dittoDimHex-min.opacity-label" for="dittoDimHex-min.opacity">Min Opacity</label>
#>             <input id="dittoDimHex-min.opacity" type="number" class="shiny-input-number form-control" value="0.2" data-update-on="change" min="0" max="1" step="0.05"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify8927457', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Scalar between [0,1] which sets the minimum or maximum opacity used for the density legend (when color is used for `color.var` data and density is shown via opacity).'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify8438703">
#>             <label class="control-label" id="dittoDimHex-max.opacity-label" for="dittoDimHex-max.opacity">Max Opacity</label>
#>             <input id="dittoDimHex-max.opacity" type="number" class="shiny-input-number form-control" value="1" data-update-on="change" min="0" max="1" step="0.05"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify8438703', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Scalar between [0,1] which sets the minimum or maximum opacity used for the density legend (when color is used for `color.var` data and density is shown via opacity).'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify7297612">
#>             <div class="material-switch">
#>               <label for="dittoDimHex-do.contour" style="padding-right: 10px;">Density Contours</label>
#>               <input id="dittoDimHex-do.contour" type="checkbox"/>
#>               <label class="switch label-success bg-success" for="dittoDimHex-do.contour"></label>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify7297612', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Logical. Whether density-based contours should be displayed.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify384150">
#>             <div class="material-switch">
#>               <label for="dittoDimHex-do.label" style="padding-right: 10px;">Label Groups</label>
#>               <input id="dittoDimHex-do.label" type="checkbox"/>
#>               <label class="switch label-success bg-success" for="dittoDimHex-do.label"></label>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify384150', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Logical. Whether to add text labels near the center (median) of clusters for grouping vars.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify3338233">
#>             <label class="control-label" id="dittoDimHex-labels.size-label" for="dittoDimHex-labels.size">Label Size</label>
#>             <input id="dittoDimHex-labels.size" type="number" class="shiny-input-number form-control" value="5" data-update-on="change" min="1" step="0.5"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify3338233', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Size of the the labels text'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify7492726">
#>             <div class="material-switch">
#>               <label for="dittoDimHex-do.ellipse" style="padding-right: 10px;">Group Ellipses</label>
#>               <input id="dittoDimHex-do.ellipse" type="checkbox"/>
#>               <label class="switch label-success bg-success" for="dittoDimHex-do.ellipse"></label>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify7492726', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Logical. Whether the groups should be surrounded by median-centered ellipses.'})}, 500)});</script>
#>         </div>
#>       </div>
#>     </div>
#>     <div class="tab-pane" data-value="Plotly" id="tab-9173-3">
#>       <div class="vizmodules-input-grid" style="--viz-input-columns: 2;">
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" style="width:100%;">
#>             <label class="control-label" id="dittoDimHex-download.format-label" for="dittoDimHex-download.format">Download Format</label>
#>             <div id="dittoDimHex-download.format" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="change">
#>               <script type="application/json" data-for="dittoDimHex-download.format">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["svg","png","jpeg","webp"],"value":["svg","png","jpeg","webp"]}},"config":{"multiple":false,"search":false,"selectedValue":"svg","hideClearButton":true,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":false,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":true,"disableOptionGroupCheckbox":true,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>             </div>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify9131580">
#>             <label class="control-label" id="dittoDimHex-margin.t-label" for="dittoDimHex-margin.t">Margin Top</label>
#>             <input id="dittoDimHex-margin.t" type="number" class="shiny-input-number form-control" value="70" data-update-on="change" min="0" step="5"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify9131580', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Top margin of the plot in pixels'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify2043291">
#>             <label class="control-label" id="dittoDimHex-margin.b-label" for="dittoDimHex-margin.b">Margin Bottom</label>
#>             <input id="dittoDimHex-margin.b" type="number" class="shiny-input-number form-control" value="70" data-update-on="change" min="0" step="5"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify2043291', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Bottom margin of the plot in pixels'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify4717556">
#>             <label class="control-label" id="dittoDimHex-margin.l-label" for="dittoDimHex-margin.l">Margin Left</label>
#>             <input id="dittoDimHex-margin.l" type="number" class="shiny-input-number form-control" value="70" data-update-on="change" min="0" step="5"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify4717556', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Left margin of the plot in pixels'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify3851831">
#>             <label class="control-label" id="dittoDimHex-margin.r-label" for="dittoDimHex-margin.r">Margin Right</label>
#>             <input id="dittoDimHex-margin.r" type="number" class="shiny-input-number form-control" value="90" data-update-on="change" min="0" step="5"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify3851831', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Right margin of the plot in pixels'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour" id="tipify3927519">
#>             <label class="control-label" for="dittoDimHex-shape.fill">Shape Fill</label>
#>             <input id="dittoDimHex-shape.fill" type="text" class="form-control shiny-colour-input" data-init-value="rgba(0, 0, 0, 0)" data-show-colour="both" data-palette="square" data-allow-alpha="true"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify3927519', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Interior fill color for shapes drawn on the plot using Plotly&#39;s drawing tools'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour" id="tipify2183385">
#>             <label class="control-label" for="dittoDimHex-shape.line.color">Shape Line Color</label>
#>             <input id="dittoDimHex-shape.line.color" type="text" class="form-control shiny-colour-input" data-init-value="black" data-show-colour="both" data-palette="square" data-allow-alpha="true"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify2183385', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Outline color for shapes drawn on the plot using Plotly&#39;s drawing tools'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify72090">
#>             <label class="control-label" id="dittoDimHex-shape.line.width-label" for="dittoDimHex-shape.line.width">Shape Line Width</label>
#>             <input id="dittoDimHex-shape.line.width" type="number" class="shiny-input-number form-control" value="4" data-update-on="change" min="0" step="0.25"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify72090', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Outline width for shapes drawn on the plot using Plotly&#39;s drawing tools'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" style="width:100%;" id="tipify3637122">
#>             <label class="control-label" id="dittoDimHex-shape.linetype-label" for="dittoDimHex-shape.linetype">Shape Linetype</label>
#>             <div id="dittoDimHex-shape.linetype" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="change">
#>               <script type="application/json" data-for="dittoDimHex-shape.linetype">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["solid","dot","dash","longdash","dashdot","longdashdot"],"value":["solid","dot","dash","longdash","dashdot","longdashdot"]}},"config":{"multiple":false,"search":false,"selectedValue":"solid","hideClearButton":true,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":false,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":true,"disableOptionGroupCheckbox":true,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify3637122', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Line dash style for shapes drawn on the plot using Plotly&#39;s drawing tools'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify5261067">
#>             <label class="control-label" id="dittoDimHex-shape.opacity-label" for="dittoDimHex-shape.opacity">Shape Opacity</label>
#>             <input id="dittoDimHex-shape.opacity" type="number" class="shiny-input-number form-control" value="1" data-update-on="change" min="0" max="1" step="0.01"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify5261067', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Opacity of shapes drawn on the plot, where 0 is fully transparent and 1 is fully opaque'})}, 500)});</script>
#>         </div>
#>       </div>
#>     </div>
#>     <div class="tab-pane" data-value="Axes" id="tab-9173-4">
#>       <div class="vizmodules-input-grid" style="--viz-input-columns: 2;">
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" style="width:100%;">
#>             <label class="control-label" id="dittoDimHex-title.font.family-label" for="dittoDimHex-title.font.family">Title Font</label>
#>             <div id="dittoDimHex-title.font.family" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="change">
#>               <script type="application/json" data-for="dittoDimHex-title.font.family">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["Arial","Balto","Courier New","Droid Sans","Droid Serif","Droid Sans Mono","Gravitas One","Old Standard TT","Open Sans","Overpass","PT Sans Narrow","Raleway","Times New Roman","Verdana","sans-serif","serif","monospace"],"value":["Arial","Balto","Courier New","Droid Sans","Droid Serif","Droid Sans Mono","Gravitas One","Old Standard TT","Open Sans","Overpass","PT Sans Narrow","Raleway","Times New Roman","Verdana","sans-serif","serif","monospace"]}},"config":{"multiple":false,"search":true,"selectedValue":"Arial","hideClearButton":true,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":false,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":true,"disableOptionGroupCheckbox":true,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>             </div>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour">
#>             <label class="control-label" for="dittoDimHex-title.font.color">Title Color</label>
#>             <input id="dittoDimHex-title.font.color" type="text" class="form-control shiny-colour-input" data-init-value="#000000" data-show-colour="both" data-palette="square"/>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="dittoDimHex-title.font.size-label" for="dittoDimHex-title.font.size">Title Size</label>
#>             <input id="dittoDimHex-title.font.size" type="number" class="shiny-input-number form-control" value="26" data-update-on="change" min="1" step="1"/>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="dittoDimHex-axis.title.horizontal.position-label" for="dittoDimHex-axis.title.horizontal.position">Title position</label>
#>             <input id="dittoDimHex-axis.title.horizontal.position" type="number" class="shiny-input-number form-control" value="0.5" data-update-on="change" min="0" max="1" step="0.1"/>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="dittoDimHex-axis.title.font.size-label" for="dittoDimHex-axis.title.font.size">Axis Title Size</label>
#>             <input id="dittoDimHex-axis.title.font.size" type="number" class="shiny-input-number form-control" value="18" data-update-on="change" min="1" step="1"/>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour">
#>             <label class="control-label" for="dittoDimHex-axis.title.font.color">Axis Title Color</label>
#>             <input id="dittoDimHex-axis.title.font.color" type="text" class="form-control shiny-colour-input" data-init-value="#000000" data-show-colour="both" data-palette="square"/>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" style="width:100%;">
#>             <label class="control-label" id="dittoDimHex-axis.title.font.family-label" for="dittoDimHex-axis.title.font.family">Axis Title Font</label>
#>             <div id="dittoDimHex-axis.title.font.family" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="change">
#>               <script type="application/json" data-for="dittoDimHex-axis.title.font.family">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["Arial","Balto","Courier New","Droid Sans","Droid Serif","Droid Sans Mono","Gravitas One","Old Standard TT","Open Sans","Overpass","PT Sans Narrow","Raleway","Times New Roman","Verdana","sans-serif","serif","monospace"],"value":["Arial","Balto","Courier New","Droid Sans","Droid Serif","Droid Sans Mono","Gravitas One","Old Standard TT","Open Sans","Overpass","PT Sans Narrow","Raleway","Times New Roman","Verdana","sans-serif","serif","monospace"]}},"config":{"multiple":false,"search":true,"selectedValue":"Arial","hideClearButton":true,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":false,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":true,"disableOptionGroupCheckbox":true,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>             </div>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container">
#>             <div class="checkbox">
#>               <label>
#>                 <input id="dittoDimHex-axis.showline" type="checkbox" class="shiny-input-checkbox" checked="checked"/>
#>                 <span>Show Axis Borders</span>
#>               </label>
#>             </div>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container">
#>             <div class="checkbox">
#>               <label>
#>                 <input id="dittoDimHex-axis.mirror" type="checkbox" class="shiny-input-checkbox" checked="checked"/>
#>                 <span>Mirror Axis Borders</span>
#>               </label>
#>             </div>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container">
#>             <div class="checkbox">
#>               <label>
#>                 <input id="dittoDimHex-show.grid.x" type="checkbox" class="shiny-input-checkbox" checked="checked"/>
#>                 <span>Show X Gridlines</span>
#>               </label>
#>             </div>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container">
#>             <div class="checkbox">
#>               <label>
#>                 <input id="dittoDimHex-show.grid.y" type="checkbox" class="shiny-input-checkbox" checked="checked"/>
#>                 <span>Show Y Gridlines</span>
#>               </label>
#>             </div>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour">
#>             <label class="control-label" for="dittoDimHex-grid.color">Gridline Color</label>
#>             <input id="dittoDimHex-grid.color" type="text" class="form-control shiny-colour-input" data-init-value="#CCCCCC" data-show-colour="both" data-palette="square"/>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour">
#>             <label class="control-label" for="dittoDimHex-axis.linecolor">Axis Line Color</label>
#>             <input id="dittoDimHex-axis.linecolor" type="text" class="form-control shiny-colour-input" data-init-value="black" data-show-colour="both" data-palette="square"/>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="dittoDimHex-axis.linewidth-label" for="dittoDimHex-axis.linewidth">Axis Line Width</label>
#>             <input id="dittoDimHex-axis.linewidth" type="number" class="shiny-input-number form-control" value="0.5" data-update-on="change" min="0" step="0.1"/>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="dittoDimHex-axis.tickfont.size-label" for="dittoDimHex-axis.tickfont.size">Tick Label Size</label>
#>             <input id="dittoDimHex-axis.tickfont.size" type="number" class="shiny-input-number form-control" value="12" data-update-on="change" min="1" step="1"/>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour">
#>             <label class="control-label" for="dittoDimHex-axis.tickfont.color">Tick Label Color</label>
#>             <input id="dittoDimHex-axis.tickfont.color" type="text" class="form-control shiny-colour-input" data-init-value="black" data-show-colour="both" data-palette="square"/>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" style="width:100%;">
#>             <label class="control-label" id="dittoDimHex-axis.tickfont.family-label" for="dittoDimHex-axis.tickfont.family">Tick Label Font</label>
#>             <div id="dittoDimHex-axis.tickfont.family" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="change">
#>               <script type="application/json" data-for="dittoDimHex-axis.tickfont.family">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["Arial","Balto","Courier New","Droid Sans","Droid Serif","Droid Sans Mono","Gravitas One","Old Standard TT","Open Sans","Overpass","PT Sans Narrow","Raleway","Times New Roman","Verdana","sans-serif","serif","monospace"],"value":["Arial","Balto","Courier New","Droid Sans","Droid Serif","Droid Sans Mono","Gravitas One","Old Standard TT","Open Sans","Overpass","PT Sans Narrow","Raleway","Times New Roman","Verdana","sans-serif","serif","monospace"]}},"config":{"multiple":false,"search":true,"selectedValue":"Arial","hideClearButton":true,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":false,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":true,"disableOptionGroupCheckbox":true,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>             </div>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="dittoDimHex-axis.tickangle.x-label" for="dittoDimHex-axis.tickangle.x">X Tick Label Angle</label>
#>             <input id="dittoDimHex-axis.tickangle.x" type="number" class="shiny-input-number form-control" value="0" data-update-on="change" min="-180" max="180" step="15"/>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="dittoDimHex-axis.tickangle.y-label" for="dittoDimHex-axis.tickangle.y">Y Tick Label Angle</label>
#>             <input id="dittoDimHex-axis.tickangle.y" type="number" class="shiny-input-number form-control" value="0" data-update-on="change" min="-180" max="180" step="15"/>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" style="width:100%;">
#>             <label class="control-label" id="dittoDimHex-axis.ticks-label" for="dittoDimHex-axis.ticks">Tick Position</label>
#>             <div id="dittoDimHex-axis.ticks" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="change">
#>               <script type="application/json" data-for="dittoDimHex-axis.ticks">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["Outside","Inside","(none)"],"value":["outside","inside",""]}},"config":{"multiple":false,"search":false,"selectedValue":"outside","hideClearButton":true,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":false,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":true,"disableOptionGroupCheckbox":true,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>             </div>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour">
#>             <label class="control-label" for="dittoDimHex-axis.tickcolor">Tick Mark Color</label>
#>             <input id="dittoDimHex-axis.tickcolor" type="text" class="form-control shiny-colour-input" data-init-value="black" data-show-colour="both" data-palette="square"/>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="dittoDimHex-axis.ticklen-label" for="dittoDimHex-axis.ticklen">Tick Mark Length</label>
#>             <input id="dittoDimHex-axis.ticklen" type="number" class="shiny-input-number form-control" value="5" data-update-on="change" min="0" step="1"/>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="dittoDimHex-axis.tickwidth-label" for="dittoDimHex-axis.tickwidth">Tick Mark Width</label>
#>             <input id="dittoDimHex-axis.tickwidth" type="number" class="shiny-input-number form-control" value="1" data-update-on="change" min="0" step="0.1"/>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="dittoDimHex-facet.title.font.size-label" for="dittoDimHex-facet.title.font.size">Facet Subplot Title Size</label>
#>             <input id="dittoDimHex-facet.title.font.size" type="number" class="shiny-input-number form-control" value="18" data-update-on="change" min="1" step="1"/>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour">
#>             <label class="control-label" for="dittoDimHex-facet.title.font.color">Facet Title Color</label>
#>             <input id="dittoDimHex-facet.title.font.color" type="text" class="form-control shiny-colour-input" data-init-value="#000000" data-show-colour="both" data-palette="square"/>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" style="width:100%;">
#>             <label class="control-label" id="dittoDimHex-facet.title.font.family-label" for="dittoDimHex-facet.title.font.family">Facet Title Font</label>
#>             <div id="dittoDimHex-facet.title.font.family" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="change">
#>               <script type="application/json" data-for="dittoDimHex-facet.title.font.family">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["Arial","Balto","Courier New","Droid Sans","Droid Serif","Droid Sans Mono","Gravitas One","Old Standard TT","Open Sans","Overpass","PT Sans Narrow","Raleway","Times New Roman","Verdana","sans-serif","serif","monospace"],"value":["Arial","Balto","Courier New","Droid Sans","Droid Serif","Droid Sans Mono","Gravitas One","Old Standard TT","Open Sans","Overpass","PT Sans Narrow","Raleway","Times New Roman","Verdana","sans-serif","serif","monospace"]}},"config":{"multiple":false,"search":true,"selectedValue":"Arial","hideClearButton":true,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":false,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":true,"disableOptionGroupCheckbox":true,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>             </div>
#>           </div>
#>         </div>
#>       </div>
#>     </div>
#>     <div class="tab-pane" data-value="Legend" id="tab-9173-5">
#>       <div class="vizmodules-input-grid" style="--viz-input-columns: 2;">
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify8441634">
#>             <div class="material-switch">
#>               <label for="dittoDimHex-legend.show" style="padding-right: 10px;">Show Legend</label>
#>               <input id="dittoDimHex-legend.show" type="checkbox" checked="checked"/>
#>               <label class="switch label-success bg-success" for="dittoDimHex-legend.show"></label>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify8441634', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Show the legend. Turning it off also hides colorbars and any point size legend.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" style="width:100%;" id="tipify1359912">
#>             <label class="control-label" id="dittoDimHex-legend.font.family-label" for="dittoDimHex-legend.font.family">Legend Font</label>
#>             <div id="dittoDimHex-legend.font.family" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="change">
#>               <script type="application/json" data-for="dittoDimHex-legend.font.family">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["Arial","Balto","Courier New","Droid Sans","Droid Serif","Droid Sans Mono","Gravitas One","Old Standard TT","Open Sans","Overpass","PT Sans Narrow","Raleway","Times New Roman","Verdana","sans-serif","serif","monospace"],"value":["Arial","Balto","Courier New","Droid Sans","Droid Serif","Droid Sans Mono","Gravitas One","Old Standard TT","Open Sans","Overpass","PT Sans Narrow","Raleway","Times New Roman","Verdana","sans-serif","serif","monospace"]}},"config":{"multiple":false,"search":true,"selectedValue":"Arial","hideClearButton":true,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":false,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":true,"disableOptionGroupCheckbox":true,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify1359912', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Font family of the legend title and entry labels.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour" id="tipify3764673">
#>             <label class="control-label" for="dittoDimHex-legend.font.color">Legend Font Color</label>
#>             <input id="dittoDimHex-legend.font.color" type="text" class="form-control shiny-colour-input" data-init-value="#000000" data-show-colour="both" data-palette="square"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify3764673', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Font color of the legend title and entry labels.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify2633087">
#>             <label class="control-label" id="dittoDimHex-legend.title.size-label" for="dittoDimHex-legend.title.size">Legend Title Size</label>
#>             <input id="dittoDimHex-legend.title.size" type="number" class="shiny-input-number form-control" value="14" data-update-on="change" min="0" step="1"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify2633087', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Font size of the legend title.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify4978530">
#>             <label class="control-label" id="dittoDimHex-legend.text.size-label" for="dittoDimHex-legend.text.size">Legend Text Size</label>
#>             <input id="dittoDimHex-legend.text.size" type="number" class="shiny-input-number form-control" value="12" data-update-on="change" min="0" step="1"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify4978530', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Font size of the legend entry labels.'})}, 500)});</script>
#>         </div>
#>       </div>
#>     </div>
#>     <div class="tab-pane" data-value="Lines" id="tab-9173-6">
#>       <div class="vizmodules-input-grid" style="--viz-input-columns: 2;">
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify195253">
#>             <label class="control-label" id="dittoDimHex-hline.intercepts-label" for="dittoDimHex-hline.intercepts">Y-intercepts</label>
#>             <input id="dittoDimHex-hline.intercepts" type="text" class="shiny-input-text form-control" value="" placeholder="e.g. 2, -2" data-update-on="change"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify195253', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'For categorical or factor axes, enter the index (position) of the category rather than its name. For example, if the axis categories are &#39;Audi&#39;, &#39;Mercedes&#39;, &#39;Bugatti&#39;, enter 2 to place a line at &#39;Mercedes&#39;.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify871839">
#>             <label class="control-label" id="dittoDimHex-hline.colors-label" for="dittoDimHex-hline.colors">Y Colors</label>
#>             <input id="dittoDimHex-hline.colors" type="text" class="shiny-input-text form-control" value="#000000" data-update-on="change"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify871839', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Color(s) for horizontal reference lines, as comma-separated hex codes or color names'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify9959626">
#>             <label class="control-label" id="dittoDimHex-hline.widths-label" for="dittoDimHex-hline.widths">Y Widths</label>
#>             <input id="dittoDimHex-hline.widths" type="text" class="shiny-input-text form-control" value="1" data-update-on="change"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify9959626', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Width(s) for horizontal reference lines in pixels, as comma-separated values'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify9421322">
#>             <label class="control-label" id="dittoDimHex-hline.linetypes-label" for="dittoDimHex-hline.linetypes">Y Line Types</label>
#>             <input id="dittoDimHex-hline.linetypes" type="text" class="shiny-input-text form-control" value="dashed" placeholder="solid, dashed, dotted, ..." data-update-on="change"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify9421322', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Line style(s) for horizontal reference lines (solid, dashed, dotted, dotdash, longdash, twodash)'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify1243735">
#>             <label class="control-label" id="dittoDimHex-hline.opacities-label" for="dittoDimHex-hline.opacities">Y Opacities (0-1)</label>
#>             <input id="dittoDimHex-hline.opacities" type="text" class="shiny-input-text form-control" value="1" data-update-on="change"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify1243735', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Opacity of horizontal reference lines between 0 (transparent) and 1 (opaque), as comma-separated values'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify1151893">
#>             <label class="control-label" id="dittoDimHex-vline.intercepts-label" for="dittoDimHex-vline.intercepts">X-intercepts</label>
#>             <input id="dittoDimHex-vline.intercepts" type="text" class="shiny-input-text form-control" value="" placeholder="e.g. 2, -2" data-update-on="change"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify1151893', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'For categorical or factor axes, enter the index (position) of the category rather than its name. For example, if the axis categories are &#39;Audi&#39;, &#39;Mercedes&#39;, &#39;Bugatti&#39;, enter 2 to place a line at &#39;Mercedes&#39;.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify3666881">
#>             <label class="control-label" id="dittoDimHex-vline.colors-label" for="dittoDimHex-vline.colors">X Colors</label>
#>             <input id="dittoDimHex-vline.colors" type="text" class="shiny-input-text form-control" value="#000000" data-update-on="change"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify3666881', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Color(s) for vertical reference lines, as comma-separated hex codes or color names'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify4710400">
#>             <label class="control-label" id="dittoDimHex-vline.widths-label" for="dittoDimHex-vline.widths">X Widths</label>
#>             <input id="dittoDimHex-vline.widths" type="text" class="shiny-input-text form-control" value="1" data-update-on="change"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify4710400', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Width(s) for vertical reference lines in pixels, as comma-separated values'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify7841724">
#>             <label class="control-label" id="dittoDimHex-vline.linetypes-label" for="dittoDimHex-vline.linetypes">X Line Types</label>
#>             <input id="dittoDimHex-vline.linetypes" type="text" class="shiny-input-text form-control" value="dashed" placeholder="solid, dashed, dotted, ..." data-update-on="change"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify7841724', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Line style(s) for vertical reference lines (solid, dashed, dotted, dotdash, longdash, twodash)'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify4903928">
#>             <label class="control-label" id="dittoDimHex-vline.opacities-label" for="dittoDimHex-vline.opacities">X Opacities (0-1)</label>
#>             <input id="dittoDimHex-vline.opacities" type="text" class="shiny-input-text form-control" value="1" data-update-on="change"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify4903928', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Opacity of vertical reference lines between 0 (transparent) and 1 (opaque), as comma-separated values'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify1019510">
#>             <label class="control-label" id="dittoDimHex-abline.slopes-label" for="dittoDimHex-abline.slopes">Ab Slopes</label>
#>             <input id="dittoDimHex-abline.slopes" type="text" class="shiny-input-text form-control" value="" data-update-on="change"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify1019510', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Slope(s) of diagonal reference lines (rise/run), as comma-separated values'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify9434597">
#>             <label class="control-label" id="dittoDimHex-abline.intercepts-label" for="dittoDimHex-abline.intercepts">Ab Y-intercepts</label>
#>             <input id="dittoDimHex-abline.intercepts" type="text" class="shiny-input-text form-control" value="" data-update-on="change"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify9434597', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'For categorical or factor axes, enter the index (position) of the category rather than its name. For example, if the axis categories are &#39;Audi&#39;, &#39;Mercedes&#39;, &#39;Bugatti&#39;, enter 2 to place a line at &#39;Mercedes&#39;.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify7061395">
#>             <label class="control-label" id="dittoDimHex-abline.colors-label" for="dittoDimHex-abline.colors">Ab Colors</label>
#>             <input id="dittoDimHex-abline.colors" type="text" class="shiny-input-text form-control" value="#000000" data-update-on="change"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify7061395', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Color(s) for diagonal reference lines, as comma-separated hex codes or color names'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify5022642">
#>             <label class="control-label" id="dittoDimHex-abline.widths-label" for="dittoDimHex-abline.widths">Ab Widths</label>
#>             <input id="dittoDimHex-abline.widths" type="text" class="shiny-input-text form-control" value="1" data-update-on="change"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify5022642', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Width(s) for diagonal reference lines in pixels, as comma-separated values'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify5299348">
#>             <label class="control-label" id="dittoDimHex-abline.linetypes-label" for="dittoDimHex-abline.linetypes">Ab Line Types</label>
#>             <input id="dittoDimHex-abline.linetypes" type="text" class="shiny-input-text form-control" value="dashed" placeholder="solid, dashed, dotted, ..." data-update-on="change"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify5299348', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Line style(s) for diagonal reference lines (solid, dashed, dotted, dotdash, longdash, twodash)'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify2584264">
#>             <label class="control-label" id="dittoDimHex-abline.opacities-label" for="dittoDimHex-abline.opacities">Ab Opacities (0-1)</label>
#>             <input id="dittoDimHex-abline.opacities" type="text" class="shiny-input-text form-control" value="1" data-update-on="change"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify2584264', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Opacity of diagonal reference lines between 0 (transparent) and 1 (opaque), as comma-separated values'})}, 500)});</script>
#>         </div>
#>       </div>
#>     </div>
#>   </div>
#> </div>
#> <div class="module-tack" style="margin-top: 12px;">
#>   <div class="module-tack-switch" style="margin-bottom: 4px;">
#>     <div class="form-group shiny-input-container">
#>       <div class="material-switch">
#>         <label for="dittoDimHex-auto.update" style="padding-right: 10px;">Auto Update</label>
#>         <input id="dittoDimHex-auto.update" type="checkbox" checked="checked"/>
#>         <label class="switch label-success bg-success" for="dittoDimHex-auto.update"></label>
#>       </div>
#>     </div>
#>   </div>
#>   <div class="module-tack-buttons" style="display: flex; flex-wrap: wrap; gap: 8px;">
#>     <button class="btn btn-default action-button btn-primary" id="dittoDimHex-update" style="flex: 1 1 45%;" type="button"><span class="action-label">Update</span></button>
#>     <button class="btn btn-default action-button btn-secondary" id="dittoDimHex-reset" style="flex: 1 1 45%;" type="button"><span class="action-label">Reset</span></button>
#>     <a aria-disabled="true" class="btn btn-default shiny-download-link disabled btn-secondary viz-source-download" data-viz-source-ns="dittoDimHex-" download href="" id="dittoDimHex-download.source" style="flex: 1 1 100%;" tabindex="-1" target="_blank">
#>       <i class="far fa-file-code" role="presentation" aria-label="file-code icon"></i>
#>       Source Download
#>     </a>
#>     <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('dittoDimHex-download.source', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Download the plot as a self-contained HTML file and as SVG and PNG images of it as it looks now, along with the plot source data and statistics (if applicable) as CSV files.'})}, 500)});</script>
#>   </div>
#> </div>
```
