# Input UI components for the dittoHeatmap module

This should be placed in the UI where the inputs should be shown, with
an `id` that matches the `id` used in the
[`dittoHeatmapServer()`](https://j-andrews7.github.io/sciVizModules/reference/dittoHeatmapServer.md)
and
[`dittoHeatmapOutputUI()`](https://j-andrews7.github.io/sciVizModules/reference/dittoHeatmapOutputUI.md)
functions.

## Usage

``` r
dittoHeatmapInputsUI(
  id,
  data,
  defaults = NULL,
  title = "dittoHeatmap Settings",
  columns = 2
)
```

## Arguments

- id:

  The ID for the Shiny module.

- data:

  A `SingleCellExperiment`, `SummarizedExperiment` or `Seurat` object
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

The module is the interactive counterpart of
[`dittoSeq::dittoHeatmap()`](https://rdrr.io/pkg/dittoSeq/man/dittoHeatmap.html):
the expression of chosen genes across the cells (or samples) of a
`SingleCellExperiment`, `SummarizedExperiment` or `Seurat` object, with
cell metadata as annotation tracks. The expression matrix is pulled with
`dittoHeatmap(data.out = TRUE)` and drawn by
[`VizModules::ComplexHeatmap_HeatmapInputsUI()`](https://j-andrews7.github.io/VizModules/reference/ComplexHeatmap_HeatmapInputsUI.html),
so its scaling, clustering, splitting, colour, label and annotation
controls all apply; those inputs are documented there. Every metadata
column is available as a column annotation; the cell identifier is the
`cell` column (the column key).

**This module is not plotly.** It renders through
InteractiveComplexHeatmap (hover, click and brush a region for a
sub-heatmap), so the shared plotly tabs (Axes, Legend, Lines, Plotly) do
not apply, and it needs ComplexHeatmap, InteractiveComplexHeatmap and
circlize. Genes that do not vary across the cells are dropped, since
they cannot be scaled or clustered.

## Plot parameters not implemented or with altered functionality

The following
[`dittoSeq::dittoHeatmap()`](https://rdrr.io/pkg/dittoSeq/man/dittoHeatmap.html)
parameters are not available via UI inputs:

- `scale`, `scaled.to.max` - Scaling is the wrapped module's `scale`
  input ("None", "Rows" for a per-gene z-score, "Columns")

- `heatmap.colors`, `heatmap.colors.max.scaled` - The wrapped module's
  `low_color`, `mid_color` and `high_color`

- `annotation_col`, `annotation_colors` - Annotation tracks and their
  colours are set on the wrapped module's Annotations tab

- `cells.use` - Use the wrapped module's Column Filter, an expression
  over the cell metadata (e.g. `celltype == "T cell"`)

- `cluster_cols`, `show_colnames`, `show_rownames`, `main` - The wrapped
  module's Clustering and Labels tabs

- `metas`, `highlight.features`, `cell.names.meta`, `swap.rownames`,
  `slot`, `complex`, `data.out` - Not exposed

## Plot parameters and defaults

The following parameters can be accessed via UI inputs and/or the
`defaults` argument:

- `dh.genes` - Genes to show (UI: "Genes", default: the 20 most variable
  genes; dittoSeq `genes`)

- `dh.assay` - Assay (UI: "Assay", default: dittoSeq's default,
  `logcounts` when present; dittoSeq `assay`)

- `dh.order.by` - Metadata column the cells are ordered by, or `""` for
  the object's order (UI: "Order Cells By", default: the first discrete
  metadata column; dittoSeq `order.by`)

- `annot.by` - Metadata columns shown as column annotations when the
  module opens (default: the first discrete metadata column; dittoSeq
  `annot.by`). Not an input: further tracks are added on the Annotations
  tab.

- Wrapped heatmap defaults set here: `scale = "Rows"`,
  `cluster_columns = FALSE`, `show_column_dend = FALSE`,
  `show_column_names` (only for 50 or fewer cells),
  `name = "Expression"`

- All other
  [`VizModules::ComplexHeatmap_HeatmapInputsUI()`](https://j-andrews7.github.io/VizModules/reference/ComplexHeatmap_HeatmapInputsUI.html)
  parameters, except `matrix.cols` and `rowname.col`, which the module
  sets

## Parameters controlling additional functionality

Annotation colours can be seeded with a `defaults` entry named after the
metadata column, e.g. `celltype = c("B cell" = "#E69F00")`; by default
they are dittoSeq's annotation colours.

## See also

[`dittoSeq::dittoHeatmap()`](https://rdrr.io/pkg/dittoSeq/man/dittoHeatmap.html),
[`VizModules::ComplexHeatmap_HeatmapInputsUI()`](https://j-andrews7.github.io/VizModules/reference/ComplexHeatmap_HeatmapInputsUI.html),
[`dittoHeatmapOutputUI()`](https://j-andrews7.github.io/sciVizModules/reference/dittoHeatmapOutputUI.md),
[`dittoHeatmapServer()`](https://j-andrews7.github.io/sciVizModules/reference/dittoHeatmapServer.md),
[`dittoHeatmapApp()`](https://j-andrews7.github.io/sciVizModules/reference/dittoHeatmapApp.md)

## Author

Jared Andrews

## Examples

``` r
library(sciVizModules)
data(example_sce)
if (requireNamespace("ComplexHeatmap", quietly = TRUE)) {
    dittoHeatmapInputsUI("heatmap", example_sce)
}
#> <div class="vizmodules-input-grid" style="--viz-input-columns: 2;">
#>   <div class="vizmodules-input-cell">
#>     <div class="form-group shiny-input-container" style="width:100%;" id="tipify7134119">
#>       <label class="control-label" id="heatmap-dh.genes-label" for="heatmap-dh.genes">Genes</label>
#>       <div id="heatmap-dh.genes" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="close">
#>         <script type="application/json" data-for="heatmap-dh.genes">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["Gene1","Gene2","Gene3","Gene4","Gene5","Gene6","Gene7","Gene8","Gene9","Gene10","Gene11","Gene12","Gene13","Gene14","Gene15","Gene16","Gene17","Gene18","Gene19","Gene20","Gene21","Gene22","Gene23","Gene24","Gene25","Gene26","Gene27","Gene28","Gene29","Gene30","Gene31","Gene32","Gene33","Gene34","Gene35","Gene36","Gene37","Gene38","Gene39","Gene40"],"value":["Gene1","Gene2","Gene3","Gene4","Gene5","Gene6","Gene7","Gene8","Gene9","Gene10","Gene11","Gene12","Gene13","Gene14","Gene15","Gene16","Gene17","Gene18","Gene19","Gene20","Gene21","Gene22","Gene23","Gene24","Gene25","Gene26","Gene27","Gene28","Gene29","Gene30","Gene31","Gene32","Gene33","Gene34","Gene35","Gene36","Gene37","Gene38","Gene39","Gene40"]}},"config":{"multiple":true,"search":true,"selectedValue":["Gene32","Gene14","Gene39","Gene34","Gene29","Gene24","Gene22","Gene20","Gene30","Gene12","Gene23","Gene15","Gene1","Gene37","Gene21","Gene28","Gene5","Gene7","Gene35","Gene36"],"hideClearButton":false,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":true,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":false,"disableOptionGroupCheckbox":false,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>       </div>
#>     </div>
#>     <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify7134119', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Genes to show, one row each. Genes that do not vary across the cells are dropped.'})}, 500)});</script>
#>   </div>
#>   <div class="vizmodules-input-cell">
#>     <div class="form-group shiny-input-container" style="width:100%;" id="tipify248861">
#>       <label class="control-label" id="heatmap-dh.assay-label" for="heatmap-dh.assay">Assay</label>
#>       <div id="heatmap-dh.assay" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="change">
#>         <script type="application/json" data-for="heatmap-dh.assay">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["counts","logcounts"],"value":["counts","logcounts"]}},"config":{"multiple":false,"search":false,"selectedValue":"logcounts","hideClearButton":true,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":false,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":true,"disableOptionGroupCheckbox":true,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>       </div>
#>     </div>
#>     <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify248861', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'The assay the expression values are taken from.'})}, 500)});</script>
#>   </div>
#>   <div class="vizmodules-input-cell">
#>     <div class="form-group shiny-input-container" style="width:100%;" id="tipify6264565">
#>       <label class="control-label" id="heatmap-dh.order.by-label" for="heatmap-dh.order.by">Order Cells By</label>
#>       <div id="heatmap-dh.order.by" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="change">
#>         <script type="application/json" data-for="heatmap-dh.order.by">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["(none)","clustering","celltype","condition","sample"],"value":["","clustering","celltype","condition","sample"]}},"config":{"multiple":false,"search":false,"selectedValue":"clustering","hideClearButton":true,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":false,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":true,"disableOptionGroupCheckbox":true,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>       </div>
#>     </div>
#>     <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify6264565', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Metadata the cells are ordered by. Turn column clustering off to keep this order.'})}, 500)});</script>
#>   </div>
#> </div>
#> <h3>dittoHeatmap Settings</h3>
#> <div class="tabbable vizmodules-input-tabs">
#>   <ul class="nav nav-tabs shiny-tab-input" id="heatmap-HeatmapTabsetPanel" data-tabsetid="2805">
#>     <li class="active">
#>       <a href="#tab-2805-1" data-toggle="tab" data-bs-toggle="tab" data-value="Matrix">Matrix</a>
#>     </li>
#>     <li>
#>       <a href="#tab-2805-2" data-toggle="tab" data-bs-toggle="tab" data-value="Filter">Filter</a>
#>     </li>
#>     <li>
#>       <a href="#tab-2805-3" data-toggle="tab" data-bs-toggle="tab" data-value="Colors">Colors</a>
#>     </li>
#>     <li>
#>       <a href="#tab-2805-4" data-toggle="tab" data-bs-toggle="tab" data-value="Clustering">Clustering</a>
#>     </li>
#>     <li>
#>       <a href="#tab-2805-5" data-toggle="tab" data-bs-toggle="tab" data-value="Labels">Labels</a>
#>     </li>
#>     <li>
#>       <a href="#tab-2805-6" data-toggle="tab" data-bs-toggle="tab" data-value="Annotations">Annotations</a>
#>     </li>
#>   </ul>
#>   <div class="tab-content" data-tabsetid="2805">
#>     <div class="tab-pane active" data-value="Matrix" id="tab-2805-1">
#>       <div class="vizmodules-input-grid" style="--viz-input-columns: 2;">
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" style="width:100%;" id="tipify8279213">
#>             <label class="control-label" id="heatmap-matrix.cols-label" for="heatmap-matrix.cols">Matrix Columns</label>
#>             <div id="heatmap-matrix.cols" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="close">
#>               <script type="application/json" data-for="heatmap-matrix.cols">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["Cell1","Cell2","Cell3","Cell4","Cell9","Cell15","Cell16","Cell23","Cell24","Cell27","Cell29","Cell30","Cell37","Cell50","Cell52","Cell60","Cell61","Cell70","Cell77","Cell78","Cell79","Cell82","Cell84","Cell85","Cell88","Cell91","Cell93","Cell97","Cell103","Cell105","Cell110","Cell112","Cell118","Cell119","Cell126","Cell127","Cell129","Cell130","Cell131","Cell134","Cell138","Cell141","Cell142","Cell144","Cell145","Cell153","Cell155","Cell156","Cell157","Cell161","Cell170","Cell172","Cell175","Cell197","Cell198","Cell203","Cell206","Cell216","Cell219","Cell221","Cell222","Cell223","Cell229","Cell230","Cell236","Cell5","Cell7","Cell8","Cell17","Cell19","Cell20","Cell32","Cell36","Cell38","Cell40","Cell43","Cell44","Cell48","Cell49","Cell54","Cell56","Cell62","Cell63","Cell64","Cell65","Cell66","Cell69","Cell71","Cell73","Cell74","Cell75","Cell83","Cell96","Cell99","Cell100","Cell101","Cell104","Cell106","Cell115","Cell116","Cell120","Cell124","Cell132","Cell135","Cell140","Cell143","Cell148","Cell150","Cell151","Cell162","Cell163","Cell165","Cell169","Cell174","Cell176","Cell178","Cell179","Cell181","Cell182","Cell183","Cell185","Cell189","Cell190","Cell193","Cell196","Cell199","Cell202","Cell207","Cell208","Cell209","Cell211","Cell215","Cell218","Cell220","Cell225","Cell226","Cell228","Cell232","Cell233","Cell239","Cell11","Cell13","Cell21","Cell22","Cell25","Cell28","Cell35","Cell41","Cell42","Cell57","Cell59","Cell68","Cell72","Cell80","Cell89","Cell90","Cell108","Cell114","Cell117","Cell121","Cell133","Cell139","Cell146","Cell149","Cell154","Cell158","Cell159","Cell164","Cell167","Cell168","Cell177","Cell184","Cell188","Cell191","Cell205","Cell212","Cell214","Cell224","Cell231","Cell234","Cell235","Cell237","Cell6","Cell10","Cell12","Cell14","Cell18","Cell26","Cell31","Cell33","Cell34","Cell39","Cell45","Cell46","Cell47","Cell51","Cell53","Cell55","Cell58","Cell67","Cell76","Cell81","Cell86","Cell87","Cell92","Cell94","Cell95","Cell98","Cell102","Cell107","Cell109","Cell111","Cell113","Cell122","Cell123","Cell125","Cell128","Cell136","Cell137","Cell147","Cell152","Cell160","Cell166","Cell171","Cell173","Cell180","Cell186","Cell187","Cell192","Cell194","Cell195","Cell200","Cell201","Cell204","Cell210","Cell213","Cell217","Cell227","Cell238","Cell240"],"value":["Cell1","Cell2","Cell3","Cell4","Cell9","Cell15","Cell16","Cell23","Cell24","Cell27","Cell29","Cell30","Cell37","Cell50","Cell52","Cell60","Cell61","Cell70","Cell77","Cell78","Cell79","Cell82","Cell84","Cell85","Cell88","Cell91","Cell93","Cell97","Cell103","Cell105","Cell110","Cell112","Cell118","Cell119","Cell126","Cell127","Cell129","Cell130","Cell131","Cell134","Cell138","Cell141","Cell142","Cell144","Cell145","Cell153","Cell155","Cell156","Cell157","Cell161","Cell170","Cell172","Cell175","Cell197","Cell198","Cell203","Cell206","Cell216","Cell219","Cell221","Cell222","Cell223","Cell229","Cell230","Cell236","Cell5","Cell7","Cell8","Cell17","Cell19","Cell20","Cell32","Cell36","Cell38","Cell40","Cell43","Cell44","Cell48","Cell49","Cell54","Cell56","Cell62","Cell63","Cell64","Cell65","Cell66","Cell69","Cell71","Cell73","Cell74","Cell75","Cell83","Cell96","Cell99","Cell100","Cell101","Cell104","Cell106","Cell115","Cell116","Cell120","Cell124","Cell132","Cell135","Cell140","Cell143","Cell148","Cell150","Cell151","Cell162","Cell163","Cell165","Cell169","Cell174","Cell176","Cell178","Cell179","Cell181","Cell182","Cell183","Cell185","Cell189","Cell190","Cell193","Cell196","Cell199","Cell202","Cell207","Cell208","Cell209","Cell211","Cell215","Cell218","Cell220","Cell225","Cell226","Cell228","Cell232","Cell233","Cell239","Cell11","Cell13","Cell21","Cell22","Cell25","Cell28","Cell35","Cell41","Cell42","Cell57","Cell59","Cell68","Cell72","Cell80","Cell89","Cell90","Cell108","Cell114","Cell117","Cell121","Cell133","Cell139","Cell146","Cell149","Cell154","Cell158","Cell159","Cell164","Cell167","Cell168","Cell177","Cell184","Cell188","Cell191","Cell205","Cell212","Cell214","Cell224","Cell231","Cell234","Cell235","Cell237","Cell6","Cell10","Cell12","Cell14","Cell18","Cell26","Cell31","Cell33","Cell34","Cell39","Cell45","Cell46","Cell47","Cell51","Cell53","Cell55","Cell58","Cell67","Cell76","Cell81","Cell86","Cell87","Cell92","Cell94","Cell95","Cell98","Cell102","Cell107","Cell109","Cell111","Cell113","Cell122","Cell123","Cell125","Cell128","Cell136","Cell137","Cell147","Cell152","Cell160","Cell166","Cell171","Cell173","Cell180","Cell186","Cell187","Cell192","Cell194","Cell195","Cell200","Cell201","Cell204","Cell210","Cell213","Cell217","Cell227","Cell238","Cell240"]}},"config":{"multiple":true,"search":true,"selectedValue":["Cell1","Cell2","Cell3","Cell4","Cell9","Cell15","Cell16","Cell23","Cell24","Cell27","Cell29","Cell30","Cell37","Cell50","Cell52","Cell60","Cell61","Cell70","Cell77","Cell78","Cell79","Cell82","Cell84","Cell85","Cell88","Cell91","Cell93","Cell97","Cell103","Cell105","Cell110","Cell112","Cell118","Cell119","Cell126","Cell127","Cell129","Cell130","Cell131","Cell134","Cell138","Cell141","Cell142","Cell144","Cell145","Cell153","Cell155","Cell156","Cell157","Cell161","Cell170","Cell172","Cell175","Cell197","Cell198","Cell203","Cell206","Cell216","Cell219","Cell221","Cell222","Cell223","Cell229","Cell230","Cell236","Cell5","Cell7","Cell8","Cell17","Cell19","Cell20","Cell32","Cell36","Cell38","Cell40","Cell43","Cell44","Cell48","Cell49","Cell54","Cell56","Cell62","Cell63","Cell64","Cell65","Cell66","Cell69","Cell71","Cell73","Cell74","Cell75","Cell83","Cell96","Cell99","Cell100","Cell101","Cell104","Cell106","Cell115","Cell116","Cell120","Cell124","Cell132","Cell135","Cell140","Cell143","Cell148","Cell150","Cell151","Cell162","Cell163","Cell165","Cell169","Cell174","Cell176","Cell178","Cell179","Cell181","Cell182","Cell183","Cell185","Cell189","Cell190","Cell193","Cell196","Cell199","Cell202","Cell207","Cell208","Cell209","Cell211","Cell215","Cell218","Cell220","Cell225","Cell226","Cell228","Cell232","Cell233","Cell239","Cell11","Cell13","Cell21","Cell22","Cell25","Cell28","Cell35","Cell41","Cell42","Cell57","Cell59","Cell68","Cell72","Cell80","Cell89","Cell90","Cell108","Cell114","Cell117","Cell121","Cell133","Cell139","Cell146","Cell149","Cell154","Cell158","Cell159","Cell164","Cell167","Cell168","Cell177","Cell184","Cell188","Cell191","Cell205","Cell212","Cell214","Cell224","Cell231","Cell234","Cell235","Cell237","Cell6","Cell10","Cell12","Cell14","Cell18","Cell26","Cell31","Cell33","Cell34","Cell39","Cell45","Cell46","Cell47","Cell51","Cell53","Cell55","Cell58","Cell67","Cell76","Cell81","Cell86","Cell87","Cell92","Cell94","Cell95","Cell98","Cell102","Cell107","Cell109","Cell111","Cell113","Cell122","Cell123","Cell125","Cell128","Cell136","Cell137","Cell147","Cell152","Cell160","Cell166","Cell171","Cell173","Cell180","Cell186","Cell187","Cell192","Cell194","Cell195","Cell200","Cell201","Cell204","Cell210","Cell213","Cell217","Cell227","Cell238","Cell240"],"hideClearButton":false,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":false,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":false,"disableOptionGroupCheckbox":false,"disabled":false,"dropboxWrapper":"body","zIndex":1060,"alwaysShowSelectedOptionsCount":true,"optionsSelectedText":"columns shown","optionSelectedText":"column shown"}}</script>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify8279213', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Numeric columns that form the heatmap matrix'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" style="width:100%;" id="tipify6430690">
#>             <label class="control-label" id="heatmap-rowname.col-label" for="heatmap-rowname.col">Row Name Column</label>
#>             <div id="heatmap-rowname.col" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="change">
#>               <script type="application/json" data-for="heatmap-rowname.col">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["(none)","gene"],"value":["","gene"]}},"config":{"multiple":false,"search":false,"selectedValue":"gene","hideClearButton":true,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":false,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":true,"disableOptionGroupCheckbox":true,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify6430690', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Optional column whose values are used as row names'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify7084842">
#>             <label class="control-label" id="heatmap-name-label" for="heatmap-name">Heatmap Name</label>
#>             <input id="heatmap-name" type="text" class="shiny-input-text form-control" value="Expression" data-update-on="change"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify7084842', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Name of the heatmap, used as the legend title'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour" id="tipify8707271">
#>             <label class="control-label" for="heatmap-na_col">NA Color</label>
#>             <input id="heatmap-na_col" type="text" class="form-control shiny-colour-input" data-init-value="grey" data-show-colour="both" data-palette="square"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify8707271', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Color used for NA cells'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" style="width:100%;" id="tipify2818126">
#>             <label class="control-label" id="heatmap-scale-label" for="heatmap-scale">Scale</label>
#>             <div id="heatmap-scale" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="change">
#>               <script type="application/json" data-for="heatmap-scale">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["None","Rows","Columns"],"value":["None","Rows","Columns"]}},"config":{"multiple":false,"search":false,"selectedValue":"Rows","hideClearButton":true,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":false,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":true,"disableOptionGroupCheckbox":true,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify2818126', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Z-score the matrix by row or column before plotting (a constant row/column becomes 0)'})}, 500)});</script>
#>         </div>
#>       </div>
#>     </div>
#>     <div class="tab-pane" data-value="Filter" id="tab-2805-2">
#>       <div class="vizmodules-input-grid" style="--viz-input-columns: 2;">
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify1732249">
#>             <label class="control-label" id="heatmap-row_filter-label" for="heatmap-row_filter">Row Filter</label>
#>             <input id="heatmap-row_filter" type="text" class="shiny-input-text form-control" value="" data-update-on="change"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify1732249', 'tooltip', {'container': 'body', 'placement': 'bottom', 'trigger': 'hover', 'title': 'Keep only the rows matching this expression, e.g. pathway == &#39;Immune&#39;, or grepl(&#39;^RP&#39;, gene). Leave blank to keep every row. Fields: gene, Cell1, Cell2, Cell3, Cell4, Cell9, Cell15, Cell16, Cell23, Cell24, Cell27, Cell29, Cell30, Cell37, Cell50, Cell52, Cell60, Cell61, Cell70, Cell77, Cell78, Cell79, Cell82, Cell84, Cell85, Cell88, Cell91, Cell93, Cell97, Cell103, Cell105, Cell110, Cell112, Cell118, Cell119, Cell126, Cell127, Cell129, Cell130, Cell131, Cell134, Cell138, Cell141, Cell142, Cell144, Cell145, Cell153, Cell155, Cell156, Cell157, Cell161, Cell170, Cell172, Cell175, Cell197, Cell198, Cell203, Cell206, Cell216, Cell219, Cell221, Cell222, Cell223, Cell229, Cell230, Cell236, Cell5, Cell7, Cell8, Cell17, Cell19, Cell20, Cell32, Cell36, Cell38, Cell40, Cell43, Cell44, Cell48, Cell49, Cell54, Cell56, Cell62, Cell63, Cell64, Cell65, Cell66, Cell69, Cell71, Cell73, Cell74, Cell75, Cell83, Cell96, Cell99, Cell100, Cell101, Cell104, Cell106, Cell115, Cell116, Cell120, Cell124, Cell132, Cell135, Cell140, Cell143, Cell148, Cell150, Cell151, Cell162, Cell163, Cell165, Cell169, Cell174, Cell176, Cell178, Cell179, Cell181, Cell182, Cell183, Cell185, Cell189, Cell190, Cell193, Cell196, Cell199, Cell202, Cell207, Cell208, Cell209, Cell211, Cell215, Cell218, Cell220, Cell225, Cell226, Cell228, Cell232, Cell233, Cell239, Cell11, Cell13, Cell21, Cell22, Cell25, Cell28, Cell35, Cell41, Cell42, Cell57, Cell59, Cell68, Cell72, Cell80, Cell89, Cell90, Cell108, Cell114, Cell117, Cell121, Cell133, Cell139, Cell146, Cell149, Cell154, Cell158, Cell159, Cell164, Cell167, Cell168, Cell177, Cell184, Cell188, Cell191, Cell205, Cell212, Cell214, Cell224, Cell231, Cell234, Cell235, Cell237, Cell6, Cell10, Cell12, Cell14, Cell18, Cell26, Cell31, Cell33, Cell34, Cell39, Cell45, Cell46, Cell47, Cell51, Cell53, Cell55, Cell58, Cell67, Cell76, Cell81, Cell86, Cell87, Cell92, Cell94, Cell95, Cell98, Cell102, Cell107, Cell109, Cell111, Cell113, Cell122, Cell123, Cell125, Cell128, Cell136, Cell137, Cell147, Cell152, Cell160, Cell166, Cell171, Cell173, Cell180, Cell186, Cell187, Cell192, Cell194, Cell195, Cell200, Cell201, Cell204, Cell210, Cell213, Cell217, Cell227, Cell238, Cell240. Available: comparisons, & | !, %in%, is.na(), arithmetic, and grepl/startsWith/endsWith/substr/nchar/toupper/tolower/trimws. Filtering happens before scaling, so a Z-score describes only what is shown.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify1096701">
#>             <label class="control-label" id="heatmap-column_filter-label" for="heatmap-column_filter">Column Filter</label>
#>             <input id="heatmap-column_filter" type="text" class="shiny-input-text form-control" value="" data-update-on="change"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify1096701', 'tooltip', {'container': 'body', 'placement': 'bottom', 'trigger': 'hover', 'title': 'Keep only the matrix columns matching this expression, e.g. condition == &#39;Disease&#39;, or startsWith(column, &#39;Healthy&#39;). Leave blank to keep every column. Fields: column, cell, clustering, celltype, condition, sample, nCount, percent.mito. Available: comparisons, & | !, %in%, is.na(), arithmetic, and grepl/startsWith/endsWith/substr/nchar/toupper/tolower/trimws. Filtering happens before scaling, so a Z-score describes only what is shown.'})}, 500)});</script>
#>         </div>
#>       </div>
#>     </div>
#>     <div class="tab-pane" data-value="Colors" id="tab-2805-3">
#>       <div class="vizmodules-input-grid" style="--viz-input-columns: 2;">
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour" id="tipify5862222">
#>             <label class="control-label" for="heatmap-low_color">Low Color</label>
#>             <input id="heatmap-low_color" type="text" class="form-control shiny-colour-input" data-init-value="#2166AC" data-show-colour="both" data-palette="square"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify5862222', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Color for the lowest (or Min Value) end of the scale'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify8507213">
#>             <label class="control-label" id="heatmap-min_value-label" for="heatmap-min_value">Min Value</label>
#>             <input id="heatmap-min_value" type="number" class="shiny-input-number form-control" value="NA" data-update-on="change"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify8507213', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Value mapped to the Low Color (blank = the matrix minimum)'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour" id="tipify9215261">
#>             <label class="control-label" for="heatmap-mid_color">Mid Color</label>
#>             <input id="heatmap-mid_color" type="text" class="form-control shiny-colour-input" data-init-value="#F7F7F7" data-show-colour="both" data-palette="square"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify9215261', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Color for the midpoint of the scale'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify6756619">
#>             <label class="control-label" id="heatmap-mid_value-label" for="heatmap-mid_value">Mid Value</label>
#>             <input id="heatmap-mid_value" type="number" class="shiny-input-number form-control" value="NA" data-update-on="change"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify6756619', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Value mapped to the Mid Color (blank = the midpoint between Min and Max Value; set to 0 to center a z-scored matrix)'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour" id="tipify3505882">
#>             <label class="control-label" for="heatmap-high_color">High Color</label>
#>             <input id="heatmap-high_color" type="text" class="form-control shiny-colour-input" data-init-value="#B2182B" data-show-colour="both" data-palette="square"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify3505882', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Color for the highest (or Max Value) end of the scale'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify86581">
#>             <label class="control-label" id="heatmap-max_value-label" for="heatmap-max_value">Max Value</label>
#>             <input id="heatmap-max_value" type="number" class="shiny-input-number form-control" value="NA" data-update-on="change"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify86581', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Value mapped to the High Color (blank = the matrix maximum)'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify4308988">
#>             <div class="checkbox">
#>               <label>
#>                 <input id="heatmap-reverse.palette" type="checkbox" class="shiny-input-checkbox"/>
#>                 <span>Reverse Palette</span>
#>               </label>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify4308988', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Reverse the direction of the color scheme'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify7249351">
#>             <div class="checkbox">
#>               <label>
#>                 <input id="heatmap-show_heatmap_legend" type="checkbox" class="shiny-input-checkbox" checked="checked"/>
#>                 <span>Show Legend</span>
#>               </label>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify7249351', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Show the heatmap color legend'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify4122564">
#>             <div class="checkbox">
#>               <label>
#>                 <input id="heatmap-border" type="checkbox" class="shiny-input-checkbox"/>
#>                 <span>Border</span>
#>               </label>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify4122564', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Draw a border around the heatmap body'})}, 500)});</script>
#>         </div>
#>       </div>
#>     </div>
#>     <div class="tab-pane" data-value="Clustering" id="tab-2805-4">
#>       <div class="vizmodules-input-grid" style="--viz-input-columns: 2;">
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify5508624">
#>             <div class="checkbox">
#>               <label>
#>                 <input id="heatmap-cluster_rows" type="checkbox" class="shiny-input-checkbox" checked="checked"/>
#>                 <span>Cluster Rows</span>
#>               </label>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify5508624', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Perform hierarchical clustering on rows'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify1563606">
#>             <div class="checkbox">
#>               <label>
#>                 <input id="heatmap-cluster_columns" type="checkbox" class="shiny-input-checkbox"/>
#>                 <span>Cluster Columns</span>
#>               </label>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify1563606', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Perform hierarchical clustering on columns'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" style="width:100%;" id="tipify430013">
#>             <label class="control-label" id="heatmap-clustering_distance_rows-label" for="heatmap-clustering_distance_rows">Row Distance</label>
#>             <div id="heatmap-clustering_distance_rows" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="change">
#>               <script type="application/json" data-for="heatmap-clustering_distance_rows">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["euclidean","maximum","manhattan","canberra","binary","minkowski","pearson","spearman","kendall"],"value":["euclidean","maximum","manhattan","canberra","binary","minkowski","pearson","spearman","kendall"]}},"config":{"multiple":false,"search":false,"selectedValue":"euclidean","hideClearButton":true,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":false,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":true,"disableOptionGroupCheckbox":true,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify430013', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Distance metric for row clustering'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" style="width:100%;" id="tipify6846441">
#>             <label class="control-label" id="heatmap-clustering_distance_columns-label" for="heatmap-clustering_distance_columns">Column Distance</label>
#>             <div id="heatmap-clustering_distance_columns" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="change">
#>               <script type="application/json" data-for="heatmap-clustering_distance_columns">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["euclidean","maximum","manhattan","canberra","binary","minkowski","pearson","spearman","kendall"],"value":["euclidean","maximum","manhattan","canberra","binary","minkowski","pearson","spearman","kendall"]}},"config":{"multiple":false,"search":false,"selectedValue":"euclidean","hideClearButton":true,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":false,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":true,"disableOptionGroupCheckbox":true,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify6846441', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Distance metric for column clustering'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" style="width:100%;" id="tipify5144025">
#>             <label class="control-label" id="heatmap-clustering_method_rows-label" for="heatmap-clustering_method_rows">Row Method</label>
#>             <div id="heatmap-clustering_method_rows" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="change">
#>               <script type="application/json" data-for="heatmap-clustering_method_rows">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["complete","average","single","ward.D","ward.D2","mcquitty","median","centroid"],"value":["complete","average","single","ward.D","ward.D2","mcquitty","median","centroid"]}},"config":{"multiple":false,"search":false,"selectedValue":"complete","hideClearButton":true,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":false,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":true,"disableOptionGroupCheckbox":true,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify5144025', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Linkage method for row clustering'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" style="width:100%;" id="tipify9456878">
#>             <label class="control-label" id="heatmap-clustering_method_columns-label" for="heatmap-clustering_method_columns">Column Method</label>
#>             <div id="heatmap-clustering_method_columns" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="change">
#>               <script type="application/json" data-for="heatmap-clustering_method_columns">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["complete","average","single","ward.D","ward.D2","mcquitty","median","centroid"],"value":["complete","average","single","ward.D","ward.D2","mcquitty","median","centroid"]}},"config":{"multiple":false,"search":false,"selectedValue":"complete","hideClearButton":true,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":false,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":true,"disableOptionGroupCheckbox":true,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify9456878', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Linkage method for column clustering'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify8430969">
#>             <div class="checkbox">
#>               <label>
#>                 <input id="heatmap-show_row_dend" type="checkbox" class="shiny-input-checkbox" checked="checked"/>
#>                 <span>Show Row Dendrogram</span>
#>               </label>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify8430969', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Show the row dendrogram'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify648831">
#>             <div class="checkbox">
#>               <label>
#>                 <input id="heatmap-show_column_dend" type="checkbox" class="shiny-input-checkbox"/>
#>                 <span>Show Column Dendrogram</span>
#>               </label>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify648831', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Show the column dendrogram'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" style="width:100%;" id="tipify7621109">
#>             <label class="control-label" id="heatmap-row_split_by-label" for="heatmap-row_split_by">Row Split Method</label>
#>             <div id="heatmap-row_split_by" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="change">
#>               <script type="application/json" data-for="heatmap-row_split_by">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["None","K-means","Hierarchical","Annotation"],"value":["None","K-means","Hierarchical","Annotation"]}},"config":{"multiple":false,"search":false,"selectedValue":"None","hideClearButton":true,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":false,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":true,"disableOptionGroupCheckbox":true,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify7621109', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'How to split rows into groups: k-means, or hierarchical (cutting the row dendrogram)'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify783843">
#>             <label class="control-label" id="heatmap-row_split_n-label" for="heatmap-row_split_n">Row Groups</label>
#>             <input id="heatmap-row_split_n" type="number" class="shiny-input-number form-control" value="NA" data-update-on="change" min="2" step="1"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify783843', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Number of row groups (used when Row Split Method is &#39;K-means&#39; or &#39;Hierarchical&#39;)'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" style="width:100%;" id="tipify1335077">
#>             <label class="control-label" id="heatmap-row_split_cols-label" for="heatmap-row_split_cols">Row Split Columns</label>
#>             <div id="heatmap-row_split_cols" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="close">
#>               <script type="application/json" data-for="heatmap-row_split_cols">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":[],"value":[]}},"config":{"multiple":true,"search":false,"selectedValue":[],"hideClearButton":false,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":true,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":false,"disableOptionGroupCheckbox":false,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify1335077', 'tooltip', {'container': 'body', 'placement': 'bottom', 'trigger': 'hover', 'title': 'Columns whose values group the rows (used when Row Split Method is &#39;Annotation&#39;). Several columns give nested slices, one per observed combination.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" style="width:100%;" id="tipify8096962">
#>             <label class="control-label" id="heatmap-column_split_by-label" for="heatmap-column_split_by">Column Split Method</label>
#>             <div id="heatmap-column_split_by" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="change">
#>               <script type="application/json" data-for="heatmap-column_split_by">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["None","K-means","Hierarchical","Annotation"],"value":["None","K-means","Hierarchical","Annotation"]}},"config":{"multiple":false,"search":false,"selectedValue":"None","hideClearButton":true,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":false,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":true,"disableOptionGroupCheckbox":true,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify8096962', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'How to split columns into groups: k-means, or hierarchical (cutting the column dendrogram)'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify5593832">
#>             <label class="control-label" id="heatmap-column_split_n-label" for="heatmap-column_split_n">Column Groups</label>
#>             <input id="heatmap-column_split_n" type="number" class="shiny-input-number form-control" value="NA" data-update-on="change" min="2" step="1"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify5593832', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Number of column groups (used when Column Split Method is &#39;K-means&#39; or &#39;Hierarchical&#39;)'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" style="width:100%;" id="tipify7337297">
#>             <label class="control-label" id="heatmap-column_split_cols-label" for="heatmap-column_split_cols">Column Split Columns</label>
#>             <div id="heatmap-column_split_cols" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="close">
#>               <script type="application/json" data-for="heatmap-column_split_cols">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["clustering","celltype","condition","sample","nCount","percent.mito"],"value":["clustering","celltype","condition","sample","nCount","percent.mito"]}},"config":{"multiple":true,"search":false,"selectedValue":[],"hideClearButton":false,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":true,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":false,"disableOptionGroupCheckbox":false,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify7337297', 'tooltip', {'container': 'body', 'placement': 'bottom', 'trigger': 'hover', 'title': 'Columns of the sample-metadata table whose values group the heatmap columns (used when Column Split Method is &#39;Annotation&#39;). Several give nested slices.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify3496955">
#>             <label class="control-label" id="heatmap-row_gap-label" for="heatmap-row_gap">Row Gap (mm)</label>
#>             <input id="heatmap-row_gap" type="number" class="shiny-input-number form-control" value="1" data-update-on="change" min="0" step="0.5"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify3496955', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Gap between row slices in millimeters (used when Row Split Method is not &#39;None&#39;)'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify9826686">
#>             <label class="control-label" id="heatmap-column_gap-label" for="heatmap-column_gap">Column Gap (mm)</label>
#>             <input id="heatmap-column_gap" type="number" class="shiny-input-number form-control" value="1" data-update-on="change" min="0" step="0.5"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify9826686', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Gap between column slices in millimeters (used when Column Split Method is not &#39;None&#39;)'})}, 500)});</script>
#>         </div>
#>       </div>
#>     </div>
#>     <div class="tab-pane" data-value="Labels" id="tab-2805-5">
#>       <div class="vizmodules-input-grid" style="--viz-input-columns: 2;">
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify4088539">
#>             <label class="control-label" id="heatmap-row_title-label" for="heatmap-row_title">Row Title</label>
#>             <input id="heatmap-row_title" type="text" class="shiny-input-text form-control" value="" data-update-on="change"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify4088539', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Title placed alongside the rows'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify3608737">
#>             <label class="control-label" id="heatmap-column_title-label" for="heatmap-column_title">Column Title</label>
#>             <input id="heatmap-column_title" type="text" class="shiny-input-text form-control" value="" data-update-on="change"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify3608737', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Title placed alongside the columns'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify6525100">
#>             <div class="checkbox">
#>               <label>
#>                 <input id="heatmap-show_row_slice_titles" type="checkbox" class="shiny-input-checkbox" checked="checked"/>
#>                 <span>Show Row Slice Titles</span>
#>               </label>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify6525100', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Title each row slice with its group name when the rows are split. Ignored if Row Title is set, which replaces the group names (use %s in it for each group&#39;s name).'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify1435593">
#>             <div class="checkbox">
#>               <label>
#>                 <input id="heatmap-show_column_slice_titles" type="checkbox" class="shiny-input-checkbox" checked="checked"/>
#>                 <span>Show Column Slice Titles</span>
#>               </label>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify1435593', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Title each column slice with its group name when the columns are split. Ignored if Column Title is set, which replaces the group names (use %s in it for each group&#39;s name).'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify6807986">
#>             <div class="checkbox">
#>               <label>
#>                 <input id="heatmap-show_row_names" type="checkbox" class="shiny-input-checkbox" checked="checked"/>
#>                 <span>Show Row Names</span>
#>               </label>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify6807986', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Show row names'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify8592859">
#>             <div class="checkbox">
#>               <label>
#>                 <input id="heatmap-show_column_names" type="checkbox" class="shiny-input-checkbox"/>
#>                 <span>Show Column Names</span>
#>               </label>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify8592859', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Show column names'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" style="width:100%;" id="tipify8386300">
#>             <label class="control-label" id="heatmap-row_names_side-label" for="heatmap-row_names_side">Row Names Side</label>
#>             <div id="heatmap-row_names_side" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="change">
#>               <script type="application/json" data-for="heatmap-row_names_side">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["right","left"],"value":["right","left"]}},"config":{"multiple":false,"search":false,"selectedValue":"right","hideClearButton":true,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":false,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":true,"disableOptionGroupCheckbox":true,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify8386300', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Which side to place row names'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" style="width:100%;" id="tipify8813129">
#>             <label class="control-label" id="heatmap-column_names_side-label" for="heatmap-column_names_side">Column Names Side</label>
#>             <div id="heatmap-column_names_side" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="change">
#>               <script type="application/json" data-for="heatmap-column_names_side">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["bottom","top"],"value":["bottom","top"]}},"config":{"multiple":false,"search":false,"selectedValue":"bottom","hideClearButton":true,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":false,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":true,"disableOptionGroupCheckbox":true,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify8813129', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Which side to place column names'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify2376978">
#>             <label class="control-label" id="heatmap-column_names_rot-label" for="heatmap-column_names_rot">Column Name Rotation</label>
#>             <input id="heatmap-column_names_rot" type="number" class="shiny-input-number form-control" value="90" data-update-on="change" step="15"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify2376978', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Rotation angle for column names'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify5786308">
#>             <label class="control-label" id="heatmap-row_names_fontsize-label" for="heatmap-row_names_fontsize">Row Name Size</label>
#>             <input id="heatmap-row_names_fontsize" type="number" class="shiny-input-number form-control" value="12" data-update-on="change" min="1" step="0.5"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify5786308', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Font size for row names'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify8979025">
#>             <label class="control-label" id="heatmap-column_names_fontsize-label" for="heatmap-column_names_fontsize">Column Name Size</label>
#>             <input id="heatmap-column_names_fontsize" type="number" class="shiny-input-number form-control" value="12" data-update-on="change" min="1" step="0.5"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify8979025', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Font size for column names'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify3444290">
#>             <label class="control-label" id="heatmap-title_fontsize-label" for="heatmap-title_fontsize">Title Size</label>
#>             <input id="heatmap-title_fontsize" type="number" class="shiny-input-number form-control" value="13.2" data-update-on="change" min="1" step="0.5"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify3444290', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Font size for row and column titles'})}, 500)});</script>
#>         </div>
#>       </div>
#>     </div>
#>     <div class="tab-pane" data-value="Annotations" id="tab-2805-6">
#>       <div class="vizmodules-input-grid" style="--viz-input-columns: 2;">
#>         <div class="vizmodules-input-cell">
#>           <div class="multi-dynamic-input shiny-input-container form-group " id="heatmap-row_annotations" data-keys="[&quot;column&quot;,&quot;side&quot;,&quot;label_side&quot;,&quot;label_size&quot;,&quot;show_legend&quot;]" data-initial="[]" data-input-id="heatmap-row_annotations" data-row-prefix="row annotations">
#>             <div class="mdi-top">
#>               <label class="control-label" for="heatmap-row_annotations">Row Annotations</label>
#>               <button type="button" class="mdi-add btn btn-default btn-sm">+ Add</button>
#>             </div>
#>             <div class="mdi-rows"></div>
#>             <template class="mdi-row-template">
#>               <div class="mdi-row">
#>                 <div class="mdi-fields">
#>                   <div class="mdi-field" data-key="column" style="flex: 1 1 calc(50% - 8px); min-width: 120px;">
#>                     <div class="form-group shiny-input-container">
#>                       <label class="control-label" id="heatmap-row_annotations-__ROWIDX__-column-label" for="heatmap-row_annotations-__ROWIDX__-column">Column</label>
#>                       <div>
#>                         <select id="heatmap-row_annotations-__ROWIDX__-column" class="shiny-input-select"></select>
#>                         <script type="application/json" data-for="heatmap-row_annotations-__ROWIDX__-column" data-nonempty="">{"plugins":["selectize-plugin-a11y"]}</script>
#>                       </div>
#>                     </div>
#>                   </div>
#>                   <div class="mdi-field" data-key="side" style="flex: 1 1 calc(50% - 8px); min-width: 120px;">
#>                     <div class="form-group shiny-input-container">
#>                       <label class="control-label" id="heatmap-row_annotations-__ROWIDX__-side-label" for="heatmap-row_annotations-__ROWIDX__-side">Side</label>
#>                       <div>
#>                         <select id="heatmap-row_annotations-__ROWIDX__-side" class="shiny-input-select"><option value="Left" selected>Left</option>
#> <option value="Right">Right</option></select>
#>                         <script type="application/json" data-for="heatmap-row_annotations-__ROWIDX__-side" data-nonempty="">{"plugins":["selectize-plugin-a11y"]}</script>
#>                       </div>
#>                     </div>
#>                   </div>
#>                   <div class="mdi-field" data-key="label_side" style="flex: 1 1 calc(50% - 8px); min-width: 120px;">
#>                     <div class="form-group shiny-input-container">
#>                       <label class="control-label" id="heatmap-row_annotations-__ROWIDX__-label_side-label" for="heatmap-row_annotations-__ROWIDX__-label_side">Label Side</label>
#>                       <div>
#>                         <select id="heatmap-row_annotations-__ROWIDX__-label_side" class="shiny-input-select"><option value="Bottom" selected>Bottom</option>
#> <option value="Top">Top</option></select>
#>                         <script type="application/json" data-for="heatmap-row_annotations-__ROWIDX__-label_side" data-nonempty="">{"plugins":["selectize-plugin-a11y"]}</script>
#>                       </div>
#>                     </div>
#>                   </div>
#>                   <div class="mdi-field" data-key="label_size" style="flex: 1 1 calc(50% - 8px); min-width: 120px;">
#>                     <div class="form-group shiny-input-container">
#>                       <label class="control-label" id="heatmap-row_annotations-__ROWIDX__-label_size-label" for="heatmap-row_annotations-__ROWIDX__-label_size">Label Size</label>
#>                       <input id="heatmap-row_annotations-__ROWIDX__-label_size" type="number" class="shiny-input-number form-control" value="10" data-update-on="change" min="1" step="0.5"/>
#>                     </div>
#>                   </div>
#>                   <div class="mdi-field" data-key="show_legend" style="flex: 1 1 calc(50% - 8px); min-width: 120px;">
#>                     <div class="form-group shiny-input-container">
#>                       <div class="checkbox">
#>                         <label>
#>                           <input id="heatmap-row_annotations-__ROWIDX__-show_legend" type="checkbox" class="shiny-input-checkbox" checked="checked"/>
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
#>           <div id="heatmap-row_annotation_colors_ui" class="shiny-html-output"></div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" style="width:100%;" id="tipify7608582">
#>             <label class="control-label" id="heatmap-column_key-label" for="heatmap-column_key">Column Key</label>
#>             <div id="heatmap-column_key" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="change">
#>               <script type="application/json" data-for="heatmap-column_key">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["cell","clustering","celltype","condition","sample","nCount","percent.mito"],"value":["cell","clustering","celltype","condition","sample","nCount","percent.mito"]}},"config":{"multiple":false,"search":false,"selectedValue":"cell","hideClearButton":true,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":false,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":true,"disableOptionGroupCheckbox":true,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify7608582', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Column in the column-annotation table that matches the heatmap&#39;s sample column names'})}, 500)});</script>
#>           <div class="multi-dynamic-input shiny-input-container form-group " id="heatmap-column_annotations" data-keys="[&quot;column&quot;,&quot;side&quot;,&quot;label_side&quot;,&quot;label_size&quot;,&quot;show_legend&quot;]" data-initial="[{&quot;fields&quot;:[{&quot;key&quot;:&quot;column&quot;,&quot;value&quot;:&quot;clustering&quot;},{&quot;key&quot;:&quot;side&quot;,&quot;value&quot;:&quot;Top&quot;},{&quot;key&quot;:&quot;label_side&quot;,&quot;value&quot;:&quot;Right&quot;},{&quot;key&quot;:&quot;label_size&quot;,&quot;value&quot;:10},{&quot;key&quot;:&quot;show_legend&quot;,&quot;value&quot;:true}]}]" data-input-id="heatmap-column_annotations" data-row-prefix="column annotations">
#>             <div class="mdi-top">
#>               <label class="control-label" for="heatmap-column_annotations">Column Annotations</label>
#>               <button type="button" class="mdi-add btn btn-default btn-sm">+ Add</button>
#>             </div>
#>             <div class="mdi-rows"></div>
#>             <template class="mdi-row-template">
#>               <div class="mdi-row">
#>                 <div class="mdi-fields">
#>                   <div class="mdi-field" data-key="column" style="flex: 1 1 calc(50% - 8px); min-width: 120px;">
#>                     <div class="form-group shiny-input-container">
#>                       <label class="control-label" id="heatmap-column_annotations-__ROWIDX__-column-label" for="heatmap-column_annotations-__ROWIDX__-column">Column</label>
#>                       <div>
#>                         <select id="heatmap-column_annotations-__ROWIDX__-column" class="shiny-input-select"><option value="clustering" selected>clustering</option>
#> <option value="celltype">celltype</option>
#> <option value="condition">condition</option>
#> <option value="sample">sample</option>
#> <option value="nCount">nCount</option>
#> <option value="percent.mito">percent.mito</option></select>
#>                         <script type="application/json" data-for="heatmap-column_annotations-__ROWIDX__-column" data-nonempty="">{"plugins":["selectize-plugin-a11y"]}</script>
#>                       </div>
#>                     </div>
#>                   </div>
#>                   <div class="mdi-field" data-key="side" style="flex: 1 1 calc(50% - 8px); min-width: 120px;">
#>                     <div class="form-group shiny-input-container">
#>                       <label class="control-label" id="heatmap-column_annotations-__ROWIDX__-side-label" for="heatmap-column_annotations-__ROWIDX__-side">Side</label>
#>                       <div>
#>                         <select id="heatmap-column_annotations-__ROWIDX__-side" class="shiny-input-select"><option value="Top" selected>Top</option>
#> <option value="Bottom">Bottom</option></select>
#>                         <script type="application/json" data-for="heatmap-column_annotations-__ROWIDX__-side" data-nonempty="">{"plugins":["selectize-plugin-a11y"]}</script>
#>                       </div>
#>                     </div>
#>                   </div>
#>                   <div class="mdi-field" data-key="label_side" style="flex: 1 1 calc(50% - 8px); min-width: 120px;">
#>                     <div class="form-group shiny-input-container">
#>                       <label class="control-label" id="heatmap-column_annotations-__ROWIDX__-label_side-label" for="heatmap-column_annotations-__ROWIDX__-label_side">Label Side</label>
#>                       <div>
#>                         <select id="heatmap-column_annotations-__ROWIDX__-label_side" class="shiny-input-select"><option value="Right" selected>Right</option>
#> <option value="Left">Left</option></select>
#>                         <script type="application/json" data-for="heatmap-column_annotations-__ROWIDX__-label_side" data-nonempty="">{"plugins":["selectize-plugin-a11y"]}</script>
#>                       </div>
#>                     </div>
#>                   </div>
#>                   <div class="mdi-field" data-key="label_size" style="flex: 1 1 calc(50% - 8px); min-width: 120px;">
#>                     <div class="form-group shiny-input-container">
#>                       <label class="control-label" id="heatmap-column_annotations-__ROWIDX__-label_size-label" for="heatmap-column_annotations-__ROWIDX__-label_size">Label Size</label>
#>                       <input id="heatmap-column_annotations-__ROWIDX__-label_size" type="number" class="shiny-input-number form-control" value="10" data-update-on="change" min="1" step="0.5"/>
#>                     </div>
#>                   </div>
#>                   <div class="mdi-field" data-key="show_legend" style="flex: 1 1 calc(50% - 8px); min-width: 120px;">
#>                     <div class="form-group shiny-input-container">
#>                       <div class="checkbox">
#>                         <label>
#>                           <input id="heatmap-column_annotations-__ROWIDX__-show_legend" type="checkbox" class="shiny-input-checkbox" checked="checked"/>
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
#>           <div id="heatmap-column_annotation_colors_ui" class="shiny-html-output"></div>
#>         </div>
#>       </div>
#>     </div>
#>   </div>
#> </div>
#> <div class="module-tack" style="margin-top: 12px;">
#>   <div class="module-tack-switch" style="margin-bottom: 4px;">
#>     <div class="form-group shiny-input-container">
#>       <div class="material-switch">
#>         <label for="heatmap-auto.update" style="padding-right: 10px;">Auto Update</label>
#>         <input id="heatmap-auto.update" type="checkbox" checked="checked"/>
#>         <label class="switch label-success bg-success" for="heatmap-auto.update"></label>
#>       </div>
#>     </div>
#>   </div>
#>   <div class="module-tack-buttons" style="display: flex; flex-wrap: wrap; gap: 8px;">
#>     <button class="btn btn-default action-button btn-primary" id="heatmap-update" style="flex: 1 1 45%;" type="button"><span class="action-label">Update</span></button>
#>     <button class="btn btn-default action-button btn-secondary" id="heatmap-reset" style="flex: 1 1 45%;" type="button"><span class="action-label">Reset</span></button>
#>     <a aria-disabled="true" class="btn btn-default shiny-download-link disabled btn-secondary viz-source-download" data-viz-source-ns="heatmap-" download href="" id="heatmap-download.source" style="flex: 1 1 100%;" tabindex="-1" target="_blank">
#>       <i class="far fa-file-code" role="presentation" aria-label="file-code icon"></i>
#>       Source Download
#>     </a>
#>     <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('heatmap-download.source', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Download the plot as a self-contained HTML file and as SVG and PNG images of it as it looks now, along with the plot source data and statistics (if applicable) as CSV files.'})}, 500)});</script>
#>   </div>
#> </div>
```
