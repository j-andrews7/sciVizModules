# Input UI components for the manhattanPlot module

This should be placed in the UI where the inputs should be shown, with
an `id` that matches the `id` used in the
[`manhattanPlotServer()`](https://j-andrews7.github.io/sciVizModules/reference/manhattanPlotServer.md)
and
[`manhattanPlotOutputUI()`](https://j-andrews7.github.io/sciVizModules/reference/manhattanPlotOutputUI.md)
functions.

## Usage

``` r
manhattanPlotInputsUI(
  id,
  data,
  defaults = NULL,
  title = "Manhattan Plot Settings",
  columns = 2
)
```

## Arguments

- id:

  The ID for the Shiny module.

- data:

  A data frame of GWAS summary statistics.

- defaults:

  A named list of default values for the inputs.

- title:

  An optional title for the UI grid.

- columns:

  Number of columns for the UI grid.

## Value

A Shiny tagList containing the UI elements

## Details

The module draws a Manhattan plot of GWAS summary statistics: each
variant's -log10(p) against its position along the genome, chromosomes
laid end to end in alternating colours, with genome-wide and suggestive
significance lines. It wraps
[`VizModules::dittoViz_scatterPlotInputsUI()`](https://j-andrews7.github.io/VizModules/reference/dittoViz_scatterPlotInputsUI.html),
so point labelling (`annotate.by` / `highlight.points`), hover data,
colours and the other scatter controls all apply; those inputs are
documented there.

Columns are detected from the usual names (qqman, PLINK, REGENIE, GWAS
Catalog harmonised): e.g. `CHR` / `chromosome`, `BP` / `POS` /
`base_pair_location`, `P` / `p_value`, `SNP` / `rsid` / `variant_id`.
Large summary statistics are thinned by default: every variant below
`thin.p` is kept, plus a reproducible `thin.fraction` of the rest; the
source-data download describes the plotted (thinned) variants.

## Plot parameters and defaults

The following parameters can be accessed via UI inputs and/or the
`defaults` argument:

- `chr.col`, `bp.col`, `p.col`, `snp.col` - Chromosome, position,
  p-value and variant columns (default: detected)

- `sig.threshold` - Genome-wide significance line (default: 5e-8)

- `suggestive.threshold` - Suggestive line (default: 1e-5)

- `thin` - Thin the non-significant variants (default: TRUE)

- `thin.p` - Variants below this p-value are always kept (default: 0.01)

- `thin.fraction` - Fraction of the other variants kept (default: 0.25)

- `color.odd`, `color.even` - The two alternating chromosome colours
  seeding the colour picker (defaults only; default: dark and light
  blue)

- All other
  [`VizModules::dittoViz_scatterPlotInputsUI()`](https://j-andrews7.github.io/VizModules/reference/dittoViz_scatterPlotInputsUI.html)
  parameters

## See also

[`manhattanPlotOutputUI()`](https://j-andrews7.github.io/sciVizModules/reference/manhattanPlotOutputUI.md),
[`manhattanPlotServer()`](https://j-andrews7.github.io/sciVizModules/reference/manhattanPlotServer.md),
[`manhattanPlotApp()`](https://j-andrews7.github.io/sciVizModules/reference/manhattanPlotApp.md),
[`gwasQQPlotInputsUI()`](https://j-andrews7.github.io/sciVizModules/reference/gwasQQPlotInputsUI.md)

## Author

Jared Andrews

## Examples

``` r
library(sciVizModules)
data(example_gwas)
manhattanPlotInputsUI("manhattan", example_gwas)
#> <div class="vizmodules-input-grid" style="--viz-input-columns: 2;">
#>   <div class="vizmodules-input-cell">
#>     <div class="form-group shiny-input-container" style="width:100%;" id="tipify5926344">
#>       <label class="control-label" id="manhattan-chr.col-label" for="manhattan-chr.col">Chromosome Column</label>
#>       <div id="manhattan-chr.col" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="change">
#>         <script type="application/json" data-for="manhattan-chr.col">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["SNP","CHR","BP","P"],"value":["SNP","CHR","BP","P"]}},"config":{"multiple":false,"search":false,"selectedValue":"CHR","hideClearButton":true,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":false,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":true,"disableOptionGroupCheckbox":true,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>       </div>
#>     </div>
#>     <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify5926344', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Column holding the chromosome (e.g. 1-22, X; a &#39;chr&#39; prefix is fine).'})}, 500)});</script>
#>   </div>
#>   <div class="vizmodules-input-cell">
#>     <div class="form-group shiny-input-container" style="width:100%;" id="tipify6062636">
#>       <label class="control-label" id="manhattan-bp.col-label" for="manhattan-bp.col">Position Column</label>
#>       <div id="manhattan-bp.col" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="change">
#>         <script type="application/json" data-for="manhattan-bp.col">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["CHR","BP","P"],"value":["CHR","BP","P"]}},"config":{"multiple":false,"search":false,"selectedValue":"BP","hideClearButton":true,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":false,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":true,"disableOptionGroupCheckbox":true,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>       </div>
#>     </div>
#>     <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify6062636', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Column holding the base-pair position.'})}, 500)});</script>
#>   </div>
#>   <div class="vizmodules-input-cell">
#>     <div class="form-group shiny-input-container" style="width:100%;" id="tipify1107686">
#>       <label class="control-label" id="manhattan-p.col-label" for="manhattan-p.col">P-value Column</label>
#>       <div id="manhattan-p.col" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="change">
#>         <script type="application/json" data-for="manhattan-p.col">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["CHR","BP","P"],"value":["CHR","BP","P"]}},"config":{"multiple":false,"search":false,"selectedValue":"P","hideClearButton":true,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":false,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":true,"disableOptionGroupCheckbox":true,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>       </div>
#>     </div>
#>     <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify1107686', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Column holding the association p-value.'})}, 500)});</script>
#>   </div>
#>   <div class="vizmodules-input-cell">
#>     <div class="form-group shiny-input-container" style="width:100%;" id="tipify1956087">
#>       <label class="control-label" id="manhattan-snp.col-label" for="manhattan-snp.col">Variant Column</label>
#>       <div id="manhattan-snp.col" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="change">
#>         <script type="application/json" data-for="manhattan-snp.col">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["(none)","SNP","CHR","BP","P"],"value":["","SNP","CHR","BP","P"]}},"config":{"multiple":false,"search":false,"selectedValue":"SNP","hideClearButton":true,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":false,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":true,"disableOptionGroupCheckbox":true,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>       </div>
#>     </div>
#>     <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify1956087', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Column holding variant ids, used for hover text and labels.'})}, 500)});</script>
#>   </div>
#>   <div class="vizmodules-input-cell">
#>     <div class="form-group shiny-input-container" id="tipify70708">
#>       <label class="control-label" id="manhattan-sig.threshold-label" for="manhattan-sig.threshold">Genome-wide Threshold</label>
#>       <input id="manhattan-sig.threshold" type="number" class="shiny-input-number form-control" value="0.00000005" data-update-on="change" min="0" max="1" step="1e-08"/>
#>     </div>
#>     <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify70708', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'p-value of the genome-wide significance line (5e-8 by convention).'})}, 500)});</script>
#>   </div>
#>   <div class="vizmodules-input-cell">
#>     <div class="form-group shiny-input-container" id="tipify9408706">
#>       <label class="control-label" id="manhattan-suggestive.threshold-label" for="manhattan-suggestive.threshold">Suggestive Threshold</label>
#>       <input id="manhattan-suggestive.threshold" type="number" class="shiny-input-number form-control" value="0.00001" data-update-on="change" min="0" max="1" step="1e-05"/>
#>     </div>
#>     <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify9408706', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'p-value of the suggestive significance line. Leave blank for none.'})}, 500)});</script>
#>   </div>
#>   <div class="vizmodules-input-cell">
#>     <div class="form-group shiny-input-container" id="tipify682094">
#>       <div class="material-switch">
#>         <label for="manhattan-thin" style="padding-right: 10px;">Thin Variants</label>
#>         <input id="manhattan-thin" type="checkbox" checked="checked"/>
#>         <label class="switch label-success bg-success" for="manhattan-thin"></label>
#>       </div>
#>     </div>
#>     <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify682094', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Keep every variant below the p-value cut-off and only a fraction of the rest, to keep large plots fast.'})}, 500)});</script>
#>   </div>
#>   <div class="vizmodules-input-cell">
#>     <div class="form-group shiny-input-container" id="tipify1369292">
#>       <label class="control-label" id="manhattan-thin.p-label" for="manhattan-thin.p">Always Keep Below p</label>
#>       <input id="manhattan-thin.p" type="number" class="shiny-input-number form-control" value="0.01" data-update-on="change" min="0" max="1" step="0.001"/>
#>     </div>
#>     <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify1369292', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Variants with a p-value below this are always plotted.'})}, 500)});</script>
#>   </div>
#>   <div class="vizmodules-input-cell">
#>     <div class="form-group shiny-input-container" id="tipify3328170">
#>       <label class="control-label" id="manhattan-thin.fraction-label" for="manhattan-thin.fraction">Fraction of Others Kept</label>
#>       <input id="manhattan-thin.fraction" type="number" class="shiny-input-number form-control" value="0.25" data-update-on="change" min="0.01" max="1" step="0.05"/>
#>     </div>
#>     <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify3328170', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Fraction of the remaining variants plotted, chosen reproducibly.'})}, 500)});</script>
#>   </div>
#> </div>
#> <h3>Manhattan Plot Settings</h3>
#> <div class="tabbable vizmodules-input-tabs">
#>   <ul class="nav nav-tabs shiny-tab-input" id="manhattan-scatterPlotTabsetPanel" data-tabsetid="6592">
#>     <li class="active">
#>       <a href="#tab-6592-1" data-toggle="tab" data-bs-toggle="tab" data-value="Data">Data</a>
#>     </li>
#>     <li>
#>       <a href="#tab-6592-2" data-toggle="tab" data-bs-toggle="tab" data-value="Adjustments">Adjustments</a>
#>     </li>
#>     <li>
#>       <a href="#tab-6592-3" data-toggle="tab" data-bs-toggle="tab" data-value="Points">Points</a>
#>     </li>
#>     <li>
#>       <a href="#tab-6592-4" data-toggle="tab" data-bs-toggle="tab" data-value="Colors">Colors</a>
#>     </li>
#>     <li>
#>       <a href="#tab-6592-5" data-toggle="tab" data-bs-toggle="tab" data-value="Facet">Facet</a>
#>     </li>
#>     <li>
#>       <a href="#tab-6592-6" data-toggle="tab" data-bs-toggle="tab" data-value="Annotations">Annotations</a>
#>     </li>
#>     <li>
#>       <a href="#tab-6592-7" data-toggle="tab" data-bs-toggle="tab" data-value="Legend">Legend</a>
#>     </li>
#>     <li>
#>       <a href="#tab-6592-8" data-toggle="tab" data-bs-toggle="tab" data-value="Trajectory">Trajectory</a>
#>     </li>
#>     <li>
#>       <a href="#tab-6592-9" data-toggle="tab" data-bs-toggle="tab" data-value="Marginals">Marginals</a>
#>     </li>
#>     <li>
#>       <a href="#tab-6592-10" data-toggle="tab" data-bs-toggle="tab" data-value="Plotly">Plotly</a>
#>     </li>
#>     <li>
#>       <a href="#tab-6592-11" data-toggle="tab" data-bs-toggle="tab" data-value="Extras">Extras</a>
#>     </li>
#>     <li>
#>       <a href="#tab-6592-12" data-toggle="tab" data-bs-toggle="tab" data-value="Lines">Lines</a>
#>     </li>
#>     <li>
#>       <a href="#tab-6592-13" data-toggle="tab" data-bs-toggle="tab" data-value="Axes">Axes</a>
#>     </li>
#>   </ul>
#>   <div class="tab-content" data-tabsetid="6592">
#>     <div class="tab-pane active" data-value="Data" id="tab-6592-1">
#>       <div class="vizmodules-input-grid" style="--viz-input-columns: 2;">
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" style="width:100%;" id="tipify4896883">
#>             <label class="control-label" id="manhattan-x.by-label" for="manhattan-x.by">X Data</label>
#>             <div id="manhattan-x.by" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="change">
#>               <script type="application/json" data-for="manhattan-x.by">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["SNP","CHR","BP","P","manhattan.chr","manhattan.x"],"value":["SNP","CHR","BP","P","manhattan.chr","manhattan.x"]}},"config":{"multiple":false,"search":false,"selectedValue":"manhattan.x","hideClearButton":true,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":false,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":true,"disableOptionGroupCheckbox":true,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify4896883', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Single strings denoting the name of a column of `data_frame` containing numeric data to use for the x- and y-axis of the scatterplot.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" style="width:100%;" id="tipify1729546">
#>             <label class="control-label" id="manhattan-y.by-label" for="manhattan-y.by">Y Data</label>
#>             <div id="manhattan-y.by" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="change">
#>               <script type="application/json" data-for="manhattan-y.by">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["SNP","CHR","BP","P","manhattan.chr","manhattan.x"],"value":["SNP","CHR","BP","P","manhattan.chr","manhattan.x"]}},"config":{"multiple":false,"search":false,"selectedValue":"P","hideClearButton":true,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":false,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":true,"disableOptionGroupCheckbox":true,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify1729546', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Single strings denoting the name of a column of `data_frame` containing numeric data to use for the x- and y-axis of the scatterplot.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" style="width:100%;" id="tipify649393">
#>             <label class="control-label" id="manhattan-color.by-label" for="manhattan-color.by">Color By</label>
#>             <div id="manhattan-color.by" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="change">
#>               <script type="application/json" data-for="manhattan-color.by">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["(none)","CHR","BP","P","manhattan.chr","manhattan.x"],"value":["","CHR","BP","P","manhattan.chr","manhattan.x"]}},"config":{"multiple":false,"search":false,"selectedValue":"manhattan.chr","hideClearButton":true,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":false,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":true,"disableOptionGroupCheckbox":true,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify649393', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Single string denoting the name of a column of `data_frame` to use for setting the color of plotted points. Alternatively, a string vector naming multiple such columns of data to plot at once.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" style="width:100%;" id="tipify4516670">
#>             <label class="control-label" id="manhattan-size.by-label" for="manhattan-size.by">Size By</label>
#>             <div id="manhattan-size.by" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="change">
#>               <script type="application/json" data-for="manhattan-size.by">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["(none)","CHR","BP","P","manhattan.x"],"value":["","CHR","BP","P","manhattan.x"]}},"config":{"multiple":false,"search":false,"selectedValue":"","hideClearButton":true,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":false,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":true,"disableOptionGroupCheckbox":true,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify4516670', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Number which sets the size of data points. Default = 1. Alternatively, a single string denoting the name of a column of `data_frame` to use for setting the size of plotted points.  NOTE: When providing a column name and using `do.hover = TRUE`, the legend will not include meaningful size encoding information.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" style="width:100%;" id="tipify3794024">
#>             <label class="control-label" id="manhattan-shape.by-label" for="manhattan-shape.by">Shape By</label>
#>             <div id="manhattan-shape.by" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="change">
#>               <script type="application/json" data-for="manhattan-shape.by">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["(none)","manhattan.chr"],"value":["","manhattan.chr"]}},"config":{"multiple":false,"search":false,"selectedValue":"","hideClearButton":true,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":false,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":true,"disableOptionGroupCheckbox":true,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify3794024', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Single string denoting the name of a column of `data_frame` containing discrete data to use for setting the shape of plotted points.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" style="width:100%;" id="tipify9092983">
#>             <label class="control-label" id="manhattan-split.by-label" for="manhattan-split.by">Split By</label>
#>             <div id="manhattan-split.by" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="close">
#>               <script type="application/json" data-for="manhattan-split.by">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["(none)","manhattan.chr"],"value":["","manhattan.chr"]}},"config":{"multiple":true,"search":false,"selectedValue":"","hideClearButton":false,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":true,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":false,"disableOptionGroupCheckbox":false,"disabled":false,"dropboxWrapper":"body","zIndex":1060,"maxValues":2}}</script>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify9092983', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': '1 or 2 strings denoting the name(s) of column(s) of `data_frame` containing discrete data to use for faceting / separating data points into separate plots.  When 2 columns are named, c(row,col), the first is used as rows and the second is used for columns of the resulting facet grid.  When 1 column is named, shape control can be achieved with `split.nrow` and `split.ncol`'})}, 500)});</script>
#>         </div>
#>       </div>
#>     </div>
#>     <div class="tab-pane" data-value="Adjustments" id="tab-6592-2">
#>       <div class="vizmodules-input-grid" style="--viz-input-columns: 2;">
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" style="width:100%;" id="tipify299465">
#>             <label class="control-label" id="manhattan-x.adjustment-label" for="manhattan-x.adjustment">X Adjustment</label>
#>             <div id="manhattan-x.adjustment" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="change">
#>               <script type="application/json" data-for="manhattan-x.adjustment">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["(none)","z-score","relative.to.max"],"value":["","z-score","relative.to.max"]}},"config":{"multiple":false,"search":false,"selectedValue":"","hideClearButton":true,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":false,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":true,"disableOptionGroupCheckbox":true,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify299465', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'A recognized string indicating whether numeric `x.by`, `y.by`, and `color.by` data should be used directly (default) or should be adjusted to be itemize{ item{"z-score": scaled with the scale() function to produce a relative-to-mean z-score representation} item{"relative.to.max": divided by the maximum value to give percent of max values between [0,1]} }  Ignored if the target data is not numeric as these known adjustments target numeric data only.  In order to leave the unedited data available for use in other features, the adjusted data are put in a new column and that new column is used for plotting. The Adjustment Function is applied first, and the X Adjustment then rescales the result (e.g. log10, then z-score).'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" style="width:100%;" id="tipify1947964">
#>             <label class="control-label" id="manhattan-y.adjustment-label" for="manhattan-y.adjustment">Y Adjustment</label>
#>             <div id="manhattan-y.adjustment" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="change">
#>               <script type="application/json" data-for="manhattan-y.adjustment">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["(none)","z-score","relative.to.max"],"value":["","z-score","relative.to.max"]}},"config":{"multiple":false,"search":false,"selectedValue":"","hideClearButton":true,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":false,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":true,"disableOptionGroupCheckbox":true,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify1947964', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'A recognized string indicating whether numeric `x.by`, `y.by`, and `color.by` data should be used directly (default) or should be adjusted to be itemize{ item{"z-score": scaled with the scale() function to produce a relative-to-mean z-score representation} item{"relative.to.max": divided by the maximum value to give percent of max values between [0,1]} }  Ignored if the target data is not numeric as these known adjustments target numeric data only.  In order to leave the unedited data available for use in other features, the adjusted data are put in a new column and that new column is used for plotting. The Adjustment Function is applied first, and the Y Adjustment then rescales the result (e.g. log10, then z-score).'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" style="width:100%;" id="tipify6794794">
#>             <label class="control-label" id="manhattan-color.adjustment-label" for="manhattan-color.adjustment">Color Adjustment</label>
#>             <div id="manhattan-color.adjustment" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="change">
#>               <script type="application/json" data-for="manhattan-color.adjustment">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["(none)","z-score","relative.to.max"],"value":["","z-score","relative.to.max"]}},"config":{"multiple":false,"search":false,"selectedValue":"","hideClearButton":true,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":false,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":true,"disableOptionGroupCheckbox":true,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify6794794', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'A recognized string indicating whether numeric `x.by`, `y.by`, and `color.by` data should be used directly (default) or should be adjusted to be itemize{ item{"z-score": scaled with the scale() function to produce a relative-to-mean z-score representation} item{"relative.to.max": divided by the maximum value to give percent of max values between [0,1]} }  Ignored if the target data is not numeric as these known adjustments target numeric data only.  In order to leave the unedited data available for use in other features, the adjusted data are put in a new column and that new column is used for plotting. The Adjustment Function is applied first, and the Color Adjustment then rescales the result (e.g. log10, then z-score).'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" style="width:100%;" id="tipify7474663">
#>             <label class="control-label" id="manhattan-x.adj.fxn-label" for="manhattan-x.adj.fxn">X Adjustment Function</label>
#>             <div id="manhattan-x.adj.fxn" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="change">
#>               <script type="application/json" data-for="manhattan-x.adj.fxn">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["(none)","log2","log","log10","neg_log10","log1p","as.factor","abs","sqrt"],"value":["","log2","log","log10","neg_log10","log1p","as.factor","abs","sqrt"]}},"config":{"multiple":false,"search":false,"selectedValue":"","hideClearButton":true,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":false,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":true,"disableOptionGroupCheckbox":true,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify7474663', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'If you wish to apply a function to edit the `x.by`, `y.by`, or `color.by` data before use, in a way not possible with the `color.adjustment` input, this input can be given a function which takes in a vector of values as input and returns a vector of values of the same length as output.  For example, `function(x) {log2(x)`} or `as.factor`.  In order to leave the unedited data available for use in other features, the adjusted data are put in a new column and that new column is used for plotting. The Adjustment Function is applied first, and the X Adjustment then rescales the result (e.g. log10, then z-score).'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" style="width:100%;" id="tipify6495377">
#>             <label class="control-label" id="manhattan-y.adj.fxn-label" for="manhattan-y.adj.fxn">Y Adjustment Function</label>
#>             <div id="manhattan-y.adj.fxn" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="change">
#>               <script type="application/json" data-for="manhattan-y.adj.fxn">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["(none)","log2","log","log10","neg_log10","log1p","as.factor","abs","sqrt"],"value":["","log2","log","log10","neg_log10","log1p","as.factor","abs","sqrt"]}},"config":{"multiple":false,"search":false,"selectedValue":"neg_log10","hideClearButton":true,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":false,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":true,"disableOptionGroupCheckbox":true,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify6495377', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'If you wish to apply a function to edit the `x.by`, `y.by`, or `color.by` data before use, in a way not possible with the `color.adjustment` input, this input can be given a function which takes in a vector of values as input and returns a vector of values of the same length as output.  For example, `function(x) {log2(x)`} or `as.factor`.  In order to leave the unedited data available for use in other features, the adjusted data are put in a new column and that new column is used for plotting. The Adjustment Function is applied first, and the Y Adjustment then rescales the result (e.g. log10, then z-score).'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" style="width:100%;" id="tipify775807">
#>             <label class="control-label" id="manhattan-color.adj.fxn-label" for="manhattan-color.adj.fxn">Color Adjustment Function</label>
#>             <div id="manhattan-color.adj.fxn" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="change">
#>               <script type="application/json" data-for="manhattan-color.adj.fxn">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["(none)","log2","log","log10","neg_log10","log1p","as.factor","abs","sqrt"],"value":["","log2","log","log10","neg_log10","log1p","as.factor","abs","sqrt"]}},"config":{"multiple":false,"search":false,"selectedValue":"","hideClearButton":true,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":false,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":true,"disableOptionGroupCheckbox":true,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify775807', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'If you wish to apply a function to edit the `x.by`, `y.by`, or `color.by` data before use, in a way not possible with the `color.adjustment` input, this input can be given a function which takes in a vector of values as input and returns a vector of values of the same length as output.  For example, `function(x) {log2(x)`} or `as.factor`.  In order to leave the unedited data available for use in other features, the adjusted data are put in a new column and that new column is used for plotting. The Adjustment Function is applied first, and the Color Adjustment then rescales the result (e.g. log10, then z-score).'})}, 500)});</script>
#>         </div>
#>       </div>
#>     </div>
#>     <div class="tab-pane" data-value="Points" id="tab-6592-3">
#>       <div class="vizmodules-input-grid" style="--viz-input-columns: 2;">
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify5996536">
#>             <label class="control-label" id="manhattan-size-label" for="manhattan-size">Point Size</label>
#>             <input id="manhattan-size" type="number" class="shiny-input-number form-control" value="1" data-update-on="change" min="0.1"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify5996536', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Number which sets the size of data points. Default = 1. Alternatively, a single string denoting the name of a column of `data_frame` to use for setting the size of plotted points.  NOTE: When providing a column name and using `do.hover = TRUE`, the legend will not include meaningful size encoding information.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify8790108">
#>             <label class="control-label" id="manhattan-size.min-label" for="manhattan-size.min">Min Point Size</label>
#>             <input id="manhattan-size.min" type="number" class="shiny-input-number form-control" value="1" data-update-on="change" min="0" step="0.5"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify8790108', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Smallest point size, drawn for the Size Scale Min value of the &#39;Size By&#39; column.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify7320371">
#>             <label class="control-label" id="manhattan-size.max-label" for="manhattan-size.max">Max Point Size</label>
#>             <input id="manhattan-size.max" type="number" class="shiny-input-number form-control" value="6" data-update-on="change" min="0" step="0.5"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify7320371', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Largest point size, drawn for the Size Scale Max value of the &#39;Size By&#39; column.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify800531">
#>             <label class="control-label" id="manhattan-size.scale.min-label" for="manhattan-size.scale.min">Size Scale Min</label>
#>             <input id="manhattan-size.scale.min" type="number" class="shiny-input-number form-control" value="NA" data-update-on="change"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify800531', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': '&#39;Size By&#39; value drawn at the Min Point Size, and where the size legend starts. Leave blank to use the column&#39;s minimum. Smaller values are drawn at the Min Point Size.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify8327498">
#>             <label class="control-label" id="manhattan-size.scale.max-label" for="manhattan-size.scale.max">Size Scale Max</label>
#>             <input id="manhattan-size.scale.max" type="number" class="shiny-input-number form-control" value="NA" data-update-on="change"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify8327498', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': '&#39;Size By&#39; value drawn at the Max Point Size, and where the size legend ends. Leave blank to use the column&#39;s maximum. Larger values are drawn at the Max Point Size.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify8647057">
#>             <label class="control-label" id="manhattan-opacity-label" for="manhattan-opacity">Point Opacity</label>
#>             <input id="manhattan-opacity" type="number" class="shiny-input-number form-control" value="1" data-update-on="change" min="0" max="1" step="0.05"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify8647057', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Number between 0 and 1. 1 = opaque. 0 = invisible. Default = 1. (In terms of typical ggplot variables, = alpha) Alternatively, a single string denoting the name of a column of `data_frame` to use for setting the opacity of plotted points.  NOTE: When providing a column name and using `do.hover = TRUE`, the legend will not include meaningful opacity encoding information.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify7129650">
#>             <div class="checkbox">
#>               <label>
#>                 <input id="manhattan-show.others" type="checkbox" class="shiny-input-checkbox" checked="checked"/>
#>                 <span>Show Others</span>
#>               </label>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify7129650', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Logical. TRUE by default, whether rows not targeted by `rows.use` should be shown in the background in light gray.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify7574071">
#>             <div class="checkbox">
#>               <label>
#>                 <input id="manhattan-split.show.all.others" type="checkbox" class="shiny-input-checkbox" checked="checked"/>
#>                 <span>Show Split Others</span>
#>               </label>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify7574071', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Logical which sets whether gray "others" points of facets should include all points of other facets (`TRUE`) versus just points left out by `rows.use` which would exist in the current facet (`FALSE`).'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" style="width:100%;" id="tipify1224340">
#>             <label class="control-label" id="manhattan-plot.order-label" for="manhattan-plot.order">Plot Order</label>
#>             <div id="manhattan-plot.order" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="change">
#>               <script type="application/json" data-for="manhattan-plot.order">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["unordered","increasing","decreasing","randomize"],"value":["unordered","increasing","decreasing","randomize"]}},"config":{"multiple":false,"search":false,"selectedValue":"unordered","hideClearButton":true,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":false,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":true,"disableOptionGroupCheckbox":true,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify1224340', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'String. If the data should be plotted based on the order of the color data, sets whether to plot in "increasing", "decreasing", or "randomize"d order.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify1936979">
#>             <label class="control-label" id="manhattan-shape.panel-label" for="manhattan-shape.panel">Shape Panel</label>
#>             <input id="manhattan-shape.panel" type="text" class="shiny-input-text form-control" value="16, 15, 17, 23, 25, 8" data-update-on="change"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify1936979', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Vector of integers, corresponding to ggplot shapes, which sets what shapes to use in conjunction with `shape.by`. When nothing is supplied to `shape.by`, only the first value is used. Default is a set of 6, `c(16,15,17,23,25,8)`, the first being a simple, solid, circle.'})}, 500)});</script>
#>         </div>
#>       </div>
#>     </div>
#>     <div class="tab-pane" data-value="Colors" id="tab-6592-4">
#>       <div class="vizmodules-input-grid" style="--viz-input-columns: 2;">
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour" id="tipify3141783">
#>             <label class="control-label" for="manhattan-min.color">Min Color</label>
#>             <input id="manhattan-min.color" type="text" class="form-control shiny-colour-input" data-init-value="#F0E442" data-show-colour="both" data-palette="square"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify3141783', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Color for `min` value of numeric `color.by`-data. Default = yellow'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour" id="tipify1375330">
#>             <label class="control-label" for="manhattan-max.color">Max Color</label>
#>             <input id="manhattan-max.color" type="text" class="form-control shiny-colour-input" data-init-value="#0072B2" data-show-colour="both" data-palette="square"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify1375330', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Color for `max` value of numeric `color.by`-data. Default = blue'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour" id="tipify8478028">
#>             <label class="control-label" for="manhattan-contour.color">Contour Color</label>
#>             <input id="manhattan-contour.color" type="text" class="form-control shiny-colour-input" data-init-value="black" data-show-colour="both" data-palette="square"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify8478028', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'String that sets the color of the `do.contour` contours.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" style="width:100%;" id="tipify4852220">
#>             <label class="control-label" id="manhattan-contour.linetype-label" for="manhattan-contour.linetype">Contour Linetype</label>
#>             <div id="manhattan-contour.linetype" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="change">
#>               <script type="application/json" data-for="manhattan-contour.linetype">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["solid","dashed","dotted","dotdash","longdash","twodash"],"value":["solid","dashed","dotted","dotdash","longdash","twodash"]}},"config":{"multiple":false,"search":false,"selectedValue":"solid","hideClearButton":true,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":false,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":true,"disableOptionGroupCheckbox":true,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify4852220', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'String or numeric which sets the type of line used for `do.contour` contours. Defaults to "solid", but see `link[ggplot2]{linetype`} for other options.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div id="manhattan-color.panel.ui" class="shiny-html-output"></div>
#>         </div>
#>       </div>
#>     </div>
#>     <div class="tab-pane" data-value="Facet" id="tab-6592-5">
#>       <div class="vizmodules-input-grid" style="--viz-input-columns: 2;">
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify4702427">
#>             <label class="control-label" id="manhattan-split.nrow-label" for="manhattan-split.nrow">Rows</label>
#>             <input id="manhattan-split.nrow" type="number" class="shiny-input-number form-control" value="NA" data-update-on="change" min="0" step="1"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify4702427', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Integers which set the dimensions of faceting/splitting when faceting by a single feature.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify7910453">
#>             <label class="control-label" id="manhattan-split.ncol-label" for="manhattan-split.ncol">Columns</label>
#>             <input id="manhattan-split.ncol" type="number" class="shiny-input-number form-control" value="NA" data-update-on="change" min="0" step="1"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify7910453', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Integers which set the dimensions of faceting/splitting when faceting by a single feature.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" style="width:100%;" id="tipify3129833">
#>             <label class="control-label" id="manhattan-multivar.split.dir-label" for="manhattan-multivar.split.dir">Multivar Split Dir</label>
#>             <div id="manhattan-multivar.split.dir" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="change">
#>               <script type="application/json" data-for="manhattan-multivar.split.dir">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["col","row"],"value":["col","row"]}},"config":{"multiple":false,"search":false,"selectedValue":"col","hideClearButton":true,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":false,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":true,"disableOptionGroupCheckbox":true,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify3129833', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': '"row" or "col", sets the direction of faceting used for &#39;var&#39; values when: itemize{ item `var` is given multiple column names item AND `split.by` is used to provide an additional feature to facet by }'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" style="width:100%;" id="tipify3087645">
#>             <label class="control-label" id="manhattan-split.adjust.scales-label" for="manhattan-split.adjust.scales">Facet Scales</label>
#>             <div id="manhattan-split.adjust.scales" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="change">
#>               <script type="application/json" data-for="manhattan-split.adjust.scales">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["fixed","free","free_x","free_y"],"value":["fixed","free","free_x","free_y"]}},"config":{"multiple":false,"search":false,"selectedValue":"fixed","hideClearButton":true,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":false,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":true,"disableOptionGroupCheckbox":true,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify3087645', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Control whether facet panels share the same axis scales or allow them to vary independently'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify3451554">
#>             <label class="control-label" id="manhattan-subplot.margin.x-label" for="manhattan-subplot.margin.x">Subplot Spacing (Horizontal)</label>
#>             <input id="manhattan-subplot.margin.x" type="number" class="shiny-input-number form-control" value="0.03" data-update-on="change" min="0" max="1" step="0.01"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify3451554', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Horizontal spacing between facet panel columns as a fraction of the plot area (e.g. 0.03). Only applies when faceting is active.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify8284433">
#>             <label class="control-label" id="manhattan-subplot.margin.y-label" for="manhattan-subplot.margin.y">Subplot Spacing (Vertical)</label>
#>             <input id="manhattan-subplot.margin.y" type="number" class="shiny-input-number form-control" value="0.1" data-update-on="change" min="0" max="1" step="0.01"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify8284433', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Vertical spacing between facet panel rows as a fraction of the plot area (e.g. 0.1). Only applies when faceting is active.'})}, 500)});</script>
#>         </div>
#>       </div>
#>     </div>
#>     <div class="tab-pane" data-value="Annotations" id="tab-6592-6">
#>       <div class="vizmodules-input-grid" style="--viz-input-columns: 2;">
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" style="width:100%;" id="tipify2739955">
#>             <label class="control-label" id="manhattan-annotate.by-label" for="manhattan-annotate.by">Annotate By</label>
#>             <div id="manhattan-annotate.by" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="change">
#>               <script type="application/json" data-for="manhattan-annotate.by">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["(none)","SNP","CHR","BP","P","manhattan.chr","manhattan.x"],"value":["","SNP","CHR","BP","P","manhattan.chr","manhattan.x"]}},"config":{"multiple":false,"search":false,"selectedValue":"SNP","hideClearButton":true,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":false,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":true,"disableOptionGroupCheckbox":true,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify2739955', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Select a column whose values will be used to identify points for highlighting and annotation'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="shiny-input-textarea form-group shiny-input-container" id="tipify4308361">
#>             <label class="control-label" id="manhattan-highlight.points-label" for="manhattan-highlight.points">Points to Highlight</label>
#>             <textarea id="manhattan-highlight.points" class="form-control" placeholder="Values from &#39;Annotate by&#39; column&#10;(comma, space, or newline delimited)" rows="3" data-update-on="change"></textarea>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify4308361', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Enter specific values from the &#39;Annotate By&#39; column to highlight those points on the plot. Separate values that contain spaces with commas or new lines.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour" id="tipify4168978">
#>             <label class="control-label" for="manhattan-highlight.color">Highlight Fill</label>
#>             <input id="manhattan-highlight.color" type="text" class="form-control shiny-colour-input" data-init-value="#00FFF7" data-show-colour="both" data-palette="square" data-allow-alpha="true"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify4168978', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Choose the fill color for highlighted points'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify1343122">
#>             <label class="control-label" id="manhattan-highlight.size-label" for="manhattan-highlight.size">Highlight Size</label>
#>             <input id="manhattan-highlight.size" type="number" class="shiny-input-number form-control" value="7" data-update-on="change" min="0.1" step="0.5"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify1343122', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Set the size of highlighted points on the plot'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour" id="tipify6863414">
#>             <label class="control-label" for="manhattan-highlight.border.color">Highlight Border Color</label>
#>             <input id="manhattan-highlight.border.color" type="text" class="form-control shiny-colour-input" data-init-value="#000000" data-show-colour="both" data-palette="square"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify6863414', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Choose the border color for highlighted points'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify1720781">
#>             <label class="control-label" id="manhattan-highlight.border.width-label" for="manhattan-highlight.border.width">Highlight Border Width</label>
#>             <input id="manhattan-highlight.border.width" type="number" class="shiny-input-number form-control" value="1" data-update-on="change" min="0" step="0.25"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify1720781', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Set the width of the border around highlighted points'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify9234934">
#>             <div class="checkbox">
#>               <label>
#>                 <input id="manhattan-highlight.auto.annotate" type="checkbox" class="shiny-input-checkbox" checked="checked"/>
#>                 <span>Auto-annotate Highlights</span>
#>               </label>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify9234934', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'When enabled, automatically adds text labels to highlighted points using their &#39;Annotate By&#39; values'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour" id="tipify6137436">
#>             <label class="control-label" for="manhattan-annotation.color">Annotation Color</label>
#>             <input id="manhattan-annotation.color" type="text" class="form-control shiny-colour-input" data-init-value="black" data-show-colour="both" data-palette="square"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify6137436', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Set the text color for annotation labels'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify3156295">
#>             <label class="control-label" id="manhattan-annotation.ax-label" for="manhattan-annotation.ax">Annotation X Offset</label>
#>             <input id="manhattan-annotation.ax" type="number" class="shiny-input-number form-control" value="20" data-update-on="change" step="1"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify3156295', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Horizontal pixel offset of annotation labels from their target points'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify8097331">
#>             <label class="control-label" id="manhattan-annotation.ay-label" for="manhattan-annotation.ay">Annotation Y Offset</label>
#>             <input id="manhattan-annotation.ay" type="number" class="shiny-input-number form-control" value="-20" data-update-on="change" step="1"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify8097331', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Vertical pixel offset of annotation labels from their target points (negative values move up)'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify9023741">
#>             <label class="control-label" id="manhattan-annotation.size-label" for="manhattan-annotation.size">Annotation Size</label>
#>             <input id="manhattan-annotation.size" type="number" class="shiny-input-number form-control" value="10" data-update-on="change" min="1" step="0.5"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify9023741', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Set the font size of annotation text labels in points'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify1252978">
#>             <div class="checkbox">
#>               <label>
#>                 <input id="manhattan-annotation.showarrow" type="checkbox" class="shiny-input-checkbox" checked="checked"/>
#>                 <span>Show Arrow</span>
#>               </label>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify1252978', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Toggle whether an arrow is drawn from the annotation label to the target point'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour" id="tipify5655572">
#>             <label class="control-label" for="manhattan-annotation.arrowcolor">Arrow Color</label>
#>             <input id="manhattan-annotation.arrowcolor" type="text" class="form-control shiny-colour-input" data-init-value="black" data-show-colour="both" data-palette="square"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify5655572', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Set the color of the annotation arrow connecting the label to the point'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify1276411">
#>             <label class="control-label" id="manhattan-annotation.arrowhead-label" for="manhattan-annotation.arrowhead">Arrowhead Style</label>
#>             <input id="manhattan-annotation.arrowhead" type="number" class="shiny-input-number form-control" value="2" data-update-on="change" min="0" max="7" step="1"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify1276411', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Choose the arrowhead style (0-7) for annotation arrows, where 0 is no arrowhead'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify6275976">
#>             <label class="control-label" id="manhattan-annotation.arrowwidth-label" for="manhattan-annotation.arrowwidth">Arrow Linewidth</label>
#>             <input id="manhattan-annotation.arrowwidth" type="number" class="shiny-input-number form-control" value="1.5" data-update-on="change" min="0.1" step="0.25"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify6275976', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Set the line width of the annotation arrow'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <button id="manhattan-annotation.clear" type="button" class="btn btn-default action-button"><span class="action-label">Clear Annotations</span></button>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('manhattan-annotation.clear', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Remove all annotation labels and arrows from the current plot'})}, 500)});</script>
#>         </div>
#>       </div>
#>     </div>
#>     <div class="tab-pane" data-value="Legend" id="tab-6592-7">
#>       <div class="vizmodules-input-grid" style="--viz-input-columns: 2;">
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify753240">
#>             <label class="control-label" id="manhattan-legend.color.title-label" for="manhattan-legend.color.title">Legend Title</label>
#>             <input id="manhattan-legend.color.title" type="text" class="shiny-input-text form-control" value="make" data-update-on="change"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify753240', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Strings which set the title for the color or shape legends.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify2854513">
#>             <div class="material-switch">
#>               <label for="manhattan-legend.show" style="padding-right: 10px;">Show Legend</label>
#>               <input id="manhattan-legend.show" type="checkbox"/>
#>               <label class="switch label-success bg-success" for="manhattan-legend.show"></label>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify2854513', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Show the legend. Turning it off also hides colorbars and any point size legend.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" style="width:100%;" id="tipify3106024">
#>             <label class="control-label" id="manhattan-legend.font.family-label" for="manhattan-legend.font.family">Legend Font</label>
#>             <div id="manhattan-legend.font.family" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="change">
#>               <script type="application/json" data-for="manhattan-legend.font.family">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["Arial","Balto","Courier New","Droid Sans","Droid Serif","Droid Sans Mono","Gravitas One","Old Standard TT","Open Sans","Overpass","PT Sans Narrow","Raleway","Times New Roman","Verdana","sans-serif","serif","monospace"],"value":["Arial","Balto","Courier New","Droid Sans","Droid Serif","Droid Sans Mono","Gravitas One","Old Standard TT","Open Sans","Overpass","PT Sans Narrow","Raleway","Times New Roman","Verdana","sans-serif","serif","monospace"]}},"config":{"multiple":false,"search":true,"selectedValue":"Arial","hideClearButton":true,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":false,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":true,"disableOptionGroupCheckbox":true,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify3106024', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Font family of the legend title and entry labels.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour" id="tipify1467276">
#>             <label class="control-label" for="manhattan-legend.font.color">Legend Font Color</label>
#>             <input id="manhattan-legend.font.color" type="text" class="form-control shiny-colour-input" data-init-value="#000000" data-show-colour="both" data-palette="square"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify1467276', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Font color of the legend title and entry labels.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify7997705">
#>             <label class="control-label" id="manhattan-legend.title.size-label" for="manhattan-legend.title.size">Legend Title Size</label>
#>             <input id="manhattan-legend.title.size" type="number" class="shiny-input-number form-control" value="14" data-update-on="change" min="0" step="1"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify7997705', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Font size of the legend title.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify1719961">
#>             <label class="control-label" id="manhattan-legend.text.size-label" for="manhattan-legend.text.size">Legend Text Size</label>
#>             <input id="manhattan-legend.text.size" type="number" class="shiny-input-number form-control" value="12" data-update-on="change" min="0" step="1"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify1719961', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Font size of the legend entry labels.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify7856838">
#>             <label class="control-label" id="manhattan-legend.color.breaks-label" for="manhattan-legend.color.breaks">Color Tick Breaks</label>
#>             <input id="manhattan-legend.color.breaks" type="text" class="shiny-input-text form-control" value="" placeholder="e.g. -3, 0, 3" data-update-on="change"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify7856838', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Numeric vector which sets the discrete values to label in the color-scale legend for `color.by`-data.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify4700358">
#>             <label class="control-label" id="manhattan-size.legend.x-label" for="manhattan-size.legend.x">Size Legend X Position</label>
#>             <input id="manhattan-size.legend.x" type="number" class="shiny-input-number form-control" value="1.03" data-update-on="change" step="0.02"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify4700358', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Horizontal position (paper coordinates) of the custom size legend drawn when &#39;Size By&#39; is set. Values just above 1 sit to the right of the plot; lower it to pull the legend inward on narrow plots or raise it to push it further out.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify4329577">
#>             <label class="control-label" id="manhattan-size.legend.y-label" for="manhattan-size.legend.y">Size Legend Y Position</label>
#>             <input id="manhattan-size.legend.y" type="number" class="shiny-input-number form-control" value="0.35" data-update-on="change" step="0.05"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify4329577', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Vertical position (paper coordinates) of the custom size legend drawn when &#39;Size By&#39; is set. Lower it to offset the size legend from an overlapping color or shape legend.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify5745329">
#>             <label class="control-label" id="manhattan-min.value-label" for="manhattan-min.value">Color Min</label>
#>             <input id="manhattan-min.value" type="number" class="shiny-input-number form-control" value="NA" data-update-on="change"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify5745329', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Number which sets the `color.by`-data value associated with the minimum or maximum colors.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify7299699">
#>             <label class="control-label" id="manhattan-max.value-label" for="manhattan-max.value">Color Max</label>
#>             <input id="manhattan-max.value" type="number" class="shiny-input-number form-control" value="NA" data-update-on="change"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify7299699', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Number which sets the `color.by`-data value associated with the minimum or maximum colors.'})}, 500)});</script>
#>         </div>
#>       </div>
#>     </div>
#>     <div class="tab-pane" data-value="Trajectory" id="tab-6592-8">
#>       <div class="vizmodules-input-grid" style="--viz-input-columns: 2;">
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" style="width:100%;" id="tipify8941871">
#>             <label class="control-label" id="manhattan-trajectory.group.by-label" for="manhattan-trajectory.group.by">Trajectory Group By</label>
#>             <div id="manhattan-trajectory.group.by" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="change">
#>               <script type="application/json" data-for="manhattan-trajectory.group.by">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["(none)","manhattan.chr"],"value":["","manhattan.chr"]}},"config":{"multiple":false,"search":false,"selectedValue":"","hideClearButton":true,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":false,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":true,"disableOptionGroupCheckbox":true,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify8941871', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'String denoting the name of a column of `data_frame` to use for generating trajectories from data point groups.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify2203064">
#>             <label class="control-label" id="manhattan-trajectory.arrow.size-label" for="manhattan-trajectory.arrow.size">Trajectory Arrow Size</label>
#>             <input id="manhattan-trajectory.arrow.size" type="number" class="shiny-input-number form-control" value="0.1" data-update-on="change" min="0" step="0.05"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify2203064', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Number representing the size of trajectory arrows, in inches.  Default = 0.15.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div id="manhattan-add.trajectory.by.groups.ui" class="shiny-html-output"></div>
#>         </div>
#>       </div>
#>     </div>
#>     <div class="tab-pane" data-value="Marginals" id="tab-6592-9">
#>       <div class="vizmodules-input-grid" style="--viz-input-columns: 2;">
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" style="width:100%;" id="tipify2915965">
#>             <label class="control-label" id="manhattan-marginal.x-label" for="manhattan-marginal.x">Top Marginal (X)</label>
#>             <div id="manhattan-marginal.x" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="close">
#>               <script type="application/json" data-for="manhattan-marginal.x">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["Density","Histogram","Rug"],"value":["density","histogram","rug"]}},"config":{"multiple":true,"search":false,"selectedValue":[],"hideClearButton":false,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":true,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":false,"disableOptionGroupCheckbox":false,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify2915965', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Distribution of the X values drawn above the plot, one per Color By group. Pick any of density, histogram and rug.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" style="width:100%;" id="tipify8128987">
#>             <label class="control-label" id="manhattan-marginal.y-label" for="manhattan-marginal.y">Right Marginal (Y)</label>
#>             <div id="manhattan-marginal.y" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="close">
#>               <script type="application/json" data-for="manhattan-marginal.y">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["Density","Histogram","Rug"],"value":["density","histogram","rug"]}},"config":{"multiple":true,"search":false,"selectedValue":[],"hideClearButton":false,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":true,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":false,"disableOptionGroupCheckbox":false,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify8128987', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Distribution of the Y values drawn to the right of the plot, one per Color By group. Pick any of density, histogram and rug.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify436024">
#>             <label class="control-label" id="manhattan-marginal.x.size-label" for="manhattan-marginal.x.size">Top Marginal Height</label>
#>             <input id="manhattan-marginal.x.size" type="number" class="shiny-input-number form-control" value="0.15" data-update-on="change" min="0.05" max="0.5" step="0.05"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify436024', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Share of the plot&#39;s height given to the top marginal.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify5052717">
#>             <label class="control-label" id="manhattan-marginal.y.size-label" for="manhattan-marginal.y.size">Right Marginal Width</label>
#>             <input id="manhattan-marginal.y.size" type="number" class="shiny-input-number form-control" value="0.15" data-update-on="change" min="0.05" max="0.5" step="0.05"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify5052717', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Share of the plot&#39;s width given to the right marginal.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify2416559">
#>             <label class="control-label" id="manhattan-marginal.opacity-label" for="manhattan-marginal.opacity">Marginal Opacity</label>
#>             <input id="manhattan-marginal.opacity" type="number" class="shiny-input-number form-control" value="0.5" data-update-on="change" min="0" max="1" step="0.05"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify2416559', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Opacity of the density and histogram fills and of the rug lines.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify5891424">
#>             <label class="control-label" id="manhattan-marginal.bins-label" for="manhattan-marginal.bins">Histogram Bins</label>
#>             <input id="manhattan-marginal.bins" type="number" class="shiny-input-number form-control" value="30" data-update-on="change" min="1" step="1"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify5891424', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Number of histogram bins, shared by every group so their bins line up.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify9711405">
#>             <label class="control-label" id="manhattan-marginal.binwidth-label" for="manhattan-marginal.binwidth">Histogram Bin Width</label>
#>             <input id="manhattan-marginal.binwidth" type="number" class="shiny-input-number form-control" value="NA" data-update-on="change" min="0"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify9711405', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Width of each histogram bin, in the axis&#39; units. Overrides Histogram Bins when set. Leave blank to use Histogram Bins.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify2327210">
#>             <label class="control-label" id="manhattan-marginal.density.adjust-label" for="manhattan-marginal.density.adjust">Density Bandwidth Adjust</label>
#>             <input id="manhattan-marginal.density.adjust" type="number" class="shiny-input-number form-control" value="1" data-update-on="change" min="0.1" step="0.1"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify2327210', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Multiplier on the density bandwidth. Larger values give smoother curves.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify8674180">
#>             <label class="control-label" id="manhattan-marginal.rug.height-label" for="manhattan-marginal.rug.height">Rug Height</label>
#>             <input id="manhattan-marginal.rug.height" type="number" class="shiny-input-number form-control" value="0.3" data-update-on="change" min="0.1" max="0.9" step="0.05"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify8674180', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Share of a marginal given to its rug when the rug sits alongside a density or histogram. A rug on its own fills the marginal.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify1107618">
#>             <label class="control-label" id="manhattan-marginal.rug.width-label" for="manhattan-marginal.rug.width">Rug Line Width</label>
#>             <input id="manhattan-marginal.rug.width" type="number" class="shiny-input-number form-control" value="1" data-update-on="change" min="0.1" step="0.5"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify1107618', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Line width of each rug tick, in pixels.'})}, 500)});</script>
#>         </div>
#>       </div>
#>     </div>
#>     <div class="tab-pane" data-value="Plotly" id="tab-6592-10">
#>       <div class="vizmodules-input-grid" style="--viz-input-columns: 2;">
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" style="width:100%;">
#>             <label class="control-label" id="manhattan-download.format-label" for="manhattan-download.format">Download Format</label>
#>             <div id="manhattan-download.format" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="change">
#>               <script type="application/json" data-for="manhattan-download.format">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["svg","png","jpeg","webp"],"value":["svg","png","jpeg","webp"]}},"config":{"multiple":false,"search":false,"selectedValue":"svg","hideClearButton":true,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":false,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":true,"disableOptionGroupCheckbox":true,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>             </div>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify8014917">
#>             <label class="control-label" id="manhattan-margin.t-label" for="manhattan-margin.t">Margin Top</label>
#>             <input id="manhattan-margin.t" type="number" class="shiny-input-number form-control" value="70" data-update-on="change" min="0" step="5"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify8014917', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Top margin of the plot in pixels'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify6579244">
#>             <label class="control-label" id="manhattan-margin.b-label" for="manhattan-margin.b">Margin Bottom</label>
#>             <input id="manhattan-margin.b" type="number" class="shiny-input-number form-control" value="70" data-update-on="change" min="0" step="5"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify6579244', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Bottom margin of the plot in pixels'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify6520543">
#>             <label class="control-label" id="manhattan-margin.l-label" for="manhattan-margin.l">Margin Left</label>
#>             <input id="manhattan-margin.l" type="number" class="shiny-input-number form-control" value="70" data-update-on="change" min="0" step="5"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify6520543', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Left margin of the plot in pixels'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify2263227">
#>             <label class="control-label" id="manhattan-margin.r-label" for="manhattan-margin.r">Margin Right</label>
#>             <input id="manhattan-margin.r" type="number" class="shiny-input-number form-control" value="90" data-update-on="change" min="0" step="5"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify2263227', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Right margin of the plot in pixels'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour" id="tipify8539796">
#>             <label class="control-label" for="manhattan-shape.fill">Shape Fill</label>
#>             <input id="manhattan-shape.fill" type="text" class="form-control shiny-colour-input" data-init-value="rgba(0, 0, 0, 0)" data-show-colour="both" data-palette="square" data-allow-alpha="true"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify8539796', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Interior fill color for shapes drawn on the plot using Plotly&#39;s drawing tools'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour" id="tipify4356070">
#>             <label class="control-label" for="manhattan-shape.line.color">Shape Line Color</label>
#>             <input id="manhattan-shape.line.color" type="text" class="form-control shiny-colour-input" data-init-value="black" data-show-colour="both" data-palette="square" data-allow-alpha="true"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify4356070', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Outline color for shapes drawn on the plot using Plotly&#39;s drawing tools'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify2892818">
#>             <label class="control-label" id="manhattan-shape.line.width-label" for="manhattan-shape.line.width">Shape Line Width</label>
#>             <input id="manhattan-shape.line.width" type="number" class="shiny-input-number form-control" value="4" data-update-on="change" min="0" step="0.25"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify2892818', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Outline width for shapes drawn on the plot using Plotly&#39;s drawing tools'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" style="width:100%;" id="tipify6375847">
#>             <label class="control-label" id="manhattan-shape.linetype-label" for="manhattan-shape.linetype">Shape Linetype</label>
#>             <div id="manhattan-shape.linetype" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="change">
#>               <script type="application/json" data-for="manhattan-shape.linetype">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["solid","dot","dash","longdash","dashdot","longdashdot"],"value":["solid","dot","dash","longdash","dashdot","longdashdot"]}},"config":{"multiple":false,"search":false,"selectedValue":"solid","hideClearButton":true,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":false,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":true,"disableOptionGroupCheckbox":true,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify6375847', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Line dash style for shapes drawn on the plot using Plotly&#39;s drawing tools'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify2645395">
#>             <label class="control-label" id="manhattan-shape.opacity-label" for="manhattan-shape.opacity">Shape Opacity</label>
#>             <input id="manhattan-shape.opacity" type="number" class="shiny-input-number form-control" value="1" data-update-on="change" min="0" max="1" step="0.01"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify2645395', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Opacity of shapes drawn on the plot, where 0 is fully transparent and 1 is fully opaque'})}, 500)});</script>
#>         </div>
#>       </div>
#>     </div>
#>     <div class="tab-pane" data-value="Extras" id="tab-6592-11">
#>       <div class="vizmodules-input-grid" style="--viz-input-columns: 2;">
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify3862684">
#>             <div class="checkbox">
#>               <label>
#>                 <input id="manhattan-webgl" type="checkbox" class="shiny-input-checkbox" checked="checked"/>
#>                 <span>Plot with webGL</span>
#>               </label>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify3862684', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Enable WebGL rendering for improved performance with large datasets at the cost of some visual features'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify6191940">
#>             <div class="checkbox">
#>               <label>
#>                 <input id="manhattan-do.ellipse" type="checkbox" class="shiny-input-checkbox"/>
#>                 <span>Enable Ellipses</span>
#>               </label>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify6191940', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Logical. Whether `color.by` groups should be surrounded by median-centered ellipses.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify5416781">
#>             <div class="checkbox">
#>               <label>
#>                 <input id="manhattan-do.contour" type="checkbox" class="shiny-input-checkbox"/>
#>                 <span>Enable Contour</span>
#>               </label>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify5416781', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Logical. Whether density-based contours should be displayed.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" style="width:100%;" id="tipify4848310">
#>             <label class="control-label" id="manhattan-hover.data-label" for="manhattan-hover.data">Hover Data</label>
#>             <div id="manhattan-hover.data" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="close">
#>               <script type="application/json" data-for="manhattan-hover.data">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["(none)","SNP","CHR","BP","P","manhattan.chr","manhattan.x"],"value":["","SNP","CHR","BP","P","manhattan.chr","manhattan.x"]}},"config":{"multiple":true,"search":false,"selectedValue":["SNP","CHR","BP","P"],"hideClearButton":false,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":true,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":false,"disableOptionGroupCheckbox":false,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify4848310', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'String vector which denotes what data to show for each data point, upon hover, when `do.hover` is set to `TRUE`. Defaults to all data expected to be useful. Only values present in the plotting data are actually used. These can be column names of `data_frame` and any column names which will be created to accommodate multivar and data adjustment functionality. You can run the function with `data.out = TRUE` and inspect the `$Target_data` output&#39;s columns to view your available options.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify7642949">
#>             <label class="control-label" id="manhattan-hover.round.digits-label" for="manhattan-hover.round.digits">Hover Round Digits</label>
#>             <input id="manhattan-hover.round.digits" type="number" class="shiny-input-number form-control" value="5" data-update-on="change" min="1" step="1"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify7642949', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Integer number specifying the number of decimal digits to round displayed numeric values to, when `do.hover` is set to `TRUE`.'})}, 500)});</script>
#>         </div>
#>       </div>
#>     </div>
#>     <div class="tab-pane" data-value="Lines" id="tab-6592-12">
#>       <div class="vizmodules-input-grid" style="--viz-input-columns: 2;">
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify9610269">
#>             <label class="control-label" id="manhattan-hline.intercepts-label" for="manhattan-hline.intercepts">Y-intercepts</label>
#>             <input id="manhattan-hline.intercepts" type="text" class="shiny-input-text form-control" value="" placeholder="e.g. 2, -2" data-update-on="change"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify9610269', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'For categorical or factor axes, enter the index (position) of the category rather than its name. For example, if the axis categories are &#39;Audi&#39;, &#39;Mercedes&#39;, &#39;Bugatti&#39;, enter 2 to place a line at &#39;Mercedes&#39;.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify2705846">
#>             <label class="control-label" id="manhattan-hline.colors-label" for="manhattan-hline.colors">Y Colors</label>
#>             <input id="manhattan-hline.colors" type="text" class="shiny-input-text form-control" value="#000000" data-update-on="change"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify2705846', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Color(s) for horizontal reference lines, as comma-separated hex codes or color names'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify7306002">
#>             <label class="control-label" id="manhattan-hline.widths-label" for="manhattan-hline.widths">Y Widths</label>
#>             <input id="manhattan-hline.widths" type="text" class="shiny-input-text form-control" value="1" data-update-on="change"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify7306002', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Width(s) for horizontal reference lines in pixels, as comma-separated values'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify1341656">
#>             <label class="control-label" id="manhattan-hline.linetypes-label" for="manhattan-hline.linetypes">Y Line Types</label>
#>             <input id="manhattan-hline.linetypes" type="text" class="shiny-input-text form-control" value="dashed" placeholder="solid, dashed, dotted, ..." data-update-on="change"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify1341656', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Line style(s) for horizontal reference lines (solid, dashed, dotted, dotdash, longdash, twodash)'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify483983">
#>             <label class="control-label" id="manhattan-hline.opacities-label" for="manhattan-hline.opacities">Y Opacities (0-1)</label>
#>             <input id="manhattan-hline.opacities" type="text" class="shiny-input-text form-control" value="1" data-update-on="change"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify483983', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Opacity of horizontal reference lines between 0 (transparent) and 1 (opaque), as comma-separated values'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify7036070">
#>             <label class="control-label" id="manhattan-vline.intercepts-label" for="manhattan-vline.intercepts">X-intercepts</label>
#>             <input id="manhattan-vline.intercepts" type="text" class="shiny-input-text form-control" value="" placeholder="e.g. 2, -2" data-update-on="change"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify7036070', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'For categorical or factor axes, enter the index (position) of the category rather than its name. For example, if the axis categories are &#39;Audi&#39;, &#39;Mercedes&#39;, &#39;Bugatti&#39;, enter 2 to place a line at &#39;Mercedes&#39;.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify1472138">
#>             <label class="control-label" id="manhattan-vline.colors-label" for="manhattan-vline.colors">X Colors</label>
#>             <input id="manhattan-vline.colors" type="text" class="shiny-input-text form-control" value="#000000" data-update-on="change"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify1472138', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Color(s) for vertical reference lines, as comma-separated hex codes or color names'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify7691553">
#>             <label class="control-label" id="manhattan-vline.widths-label" for="manhattan-vline.widths">X Widths</label>
#>             <input id="manhattan-vline.widths" type="text" class="shiny-input-text form-control" value="1" data-update-on="change"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify7691553', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Width(s) for vertical reference lines in pixels, as comma-separated values'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify1763501">
#>             <label class="control-label" id="manhattan-vline.linetypes-label" for="manhattan-vline.linetypes">X Line Types</label>
#>             <input id="manhattan-vline.linetypes" type="text" class="shiny-input-text form-control" value="dashed" placeholder="solid, dashed, dotted, ..." data-update-on="change"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify1763501', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Line style(s) for vertical reference lines (solid, dashed, dotted, dotdash, longdash, twodash)'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify1107590">
#>             <label class="control-label" id="manhattan-vline.opacities-label" for="manhattan-vline.opacities">X Opacities (0-1)</label>
#>             <input id="manhattan-vline.opacities" type="text" class="shiny-input-text form-control" value="1" data-update-on="change"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify1107590', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Opacity of vertical reference lines between 0 (transparent) and 1 (opaque), as comma-separated values'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify9383424">
#>             <label class="control-label" id="manhattan-abline.slopes-label" for="manhattan-abline.slopes">Ab Slopes</label>
#>             <input id="manhattan-abline.slopes" type="text" class="shiny-input-text form-control" value="" data-update-on="change"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify9383424', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Slope(s) of diagonal reference lines (rise/run), as comma-separated values'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify8464711">
#>             <label class="control-label" id="manhattan-abline.intercepts-label" for="manhattan-abline.intercepts">Ab Y-intercepts</label>
#>             <input id="manhattan-abline.intercepts" type="text" class="shiny-input-text form-control" value="" data-update-on="change"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify8464711', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'For categorical or factor axes, enter the index (position) of the category rather than its name. For example, if the axis categories are &#39;Audi&#39;, &#39;Mercedes&#39;, &#39;Bugatti&#39;, enter 2 to place a line at &#39;Mercedes&#39;.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify5711436">
#>             <label class="control-label" id="manhattan-abline.colors-label" for="manhattan-abline.colors">Ab Colors</label>
#>             <input id="manhattan-abline.colors" type="text" class="shiny-input-text form-control" value="#000000" data-update-on="change"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify5711436', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Color(s) for diagonal reference lines, as comma-separated hex codes or color names'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify6790934">
#>             <label class="control-label" id="manhattan-abline.widths-label" for="manhattan-abline.widths">Ab Widths</label>
#>             <input id="manhattan-abline.widths" type="text" class="shiny-input-text form-control" value="1" data-update-on="change"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify6790934', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Width(s) for diagonal reference lines in pixels, as comma-separated values'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify893223">
#>             <label class="control-label" id="manhattan-abline.linetypes-label" for="manhattan-abline.linetypes">Ab Line Types</label>
#>             <input id="manhattan-abline.linetypes" type="text" class="shiny-input-text form-control" value="dashed" placeholder="solid, dashed, dotted, ..." data-update-on="change"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify893223', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Line style(s) for diagonal reference lines (solid, dashed, dotted, dotdash, longdash, twodash)'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify7853741">
#>             <label class="control-label" id="manhattan-abline.opacities-label" for="manhattan-abline.opacities">Ab Opacities (0-1)</label>
#>             <input id="manhattan-abline.opacities" type="text" class="shiny-input-text form-control" value="1" data-update-on="change"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify7853741', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Opacity of diagonal reference lines between 0 (transparent) and 1 (opaque), as comma-separated values'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify2269575">
#>             <div class="material-switch">
#>               <label for="manhattan-best.fit" style="padding-right: 10px;">Plot Best Fit Line</label>
#>               <input id="manhattan-best.fit" type="checkbox"/>
#>               <label class="switch label-success bg-success" for="manhattan-best.fit"></label>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify2269575', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Add a LOESS smoothed curve of best fit to the scatter plot'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify4481785">
#>             <label class="control-label" id="manhattan-line.best.smoothness-label" for="manhattan-line.best.smoothness">Best Fit Line Smoothness</label>
#>             <input id="manhattan-line.best.smoothness" type="number" class="shiny-input-number form-control" value="1" data-update-on="change" min="0" max="10000"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify4481785', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Smoothing span for the LOESS curve; higher values produce a smoother, less wiggly fit'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour" id="tipify1612277">
#>             <label class="control-label" for="manhattan-line.best.colour">Best Fit Line Color</label>
#>             <input id="manhattan-line.best.colour" type="text" class="form-control shiny-colour-input" data-init-value="#000000" data-show-colour="both" data-palette="square"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify1612277', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Color for the LOESS best fit line'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify1761117">
#>             <div class="material-switch">
#>               <label for="manhattan-linear.model" style="padding-right: 10px;">Linear Model Line</label>
#>               <input id="manhattan-linear.model" type="checkbox"/>
#>               <label class="switch label-success bg-success" for="manhattan-linear.model"></label>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify1761117', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Add a linear regression line to the scatter plot'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify1982282">
#>             <div class="material-switch">
#>               <label for="manhattan-custom.model.enable" style="padding-right: 10px;">Custom Model Lines</label>
#>               <input id="manhattan-custom.model.enable" type="checkbox"/>
#>               <label class="switch label-success bg-success" for="manhattan-custom.model.enable"></label>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify1982282', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Fit one or more custom models from formulas you define below and overlay them as lines. Only data columns and basic math/transform terms are allowed.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="multi-dynamic-input shiny-input-container form-group is-plain" id="manhattan-custom.models" data-keys="[&quot;model_type&quot;,&quot;formula&quot;,&quot;line_colour&quot;,&quot;line_width&quot;,&quot;drc_fct&quot;]" data-initial="[]" data-input-id="manhattan-custom.models" data-row-prefix="models">
#>             <div class="mdi-top">
#>               <label class="control-label" for="manhattan-custom.models">Models</label>
#>               <button type="button" class="mdi-add btn btn-default btn-sm">+ Add</button>
#>             </div>
#>             <div class="mdi-rows"></div>
#>             <template class="mdi-row-template">
#>               <div class="mdi-row">
#>                 <div class="mdi-fields">
#>                   <div class="mdi-field" data-key="model_type" style="flex: 1 1 calc(25% - 8px); min-width: 120px;">
#>                     <div class="form-group shiny-input-container">
#>                       <label class="control-label" id="manhattan-custom.models-__ROWIDX__-model_type-label" for="manhattan-custom.models-__ROWIDX__-model_type">Model type</label>
#>                       <div>
#>                         <select id="manhattan-custom.models-__ROWIDX__-model_type" class="shiny-input-select"><option value="drm">drm</option>
#> <option value="glm">glm</option>
#> <option value="lm" selected>lm</option>
#> <option value="loess">loess</option></select>
#>                         <script type="application/json" data-for="manhattan-custom.models-__ROWIDX__-model_type" data-nonempty="">{"plugins":["selectize-plugin-a11y"]}</script>
#>                       </div>
#>                     </div>
#>                   </div>
#>                   <div class="mdi-field" data-key="formula" style="flex: 1 1 calc(25% - 8px); min-width: 120px;">
#>                     <div class="form-group shiny-input-container">
#>                       <label class="control-label" id="manhattan-custom.models-__ROWIDX__-formula-label" for="manhattan-custom.models-__ROWIDX__-formula">Formula</label>
#>                       <input id="manhattan-custom.models-__ROWIDX__-formula" type="text" class="shiny-input-text form-control" value="" placeholder="e.g. y ~ poly(x, 2)" data-update-on="change"/>
#>                     </div>
#>                   </div>
#>                   <div class="mdi-field" data-key="line_colour" style="flex: 1 1 calc(25% - 8px); min-width: 120px;">
#>                     <div class="form-group shiny-input-container" data-shiny-input-type="colour">
#>                       <label class="control-label" for="manhattan-custom.models-__ROWIDX__-line_colour">Line colour</label>
#>                       <input id="manhattan-custom.models-__ROWIDX__-line_colour" type="text" class="form-control shiny-colour-input" data-init-value="#000000" data-show-colour="both" data-palette="square"/>
#>                     </div>
#>                   </div>
#>                   <div class="mdi-field" data-key="line_width" style="flex: 1 1 calc(25% - 8px); min-width: 120px;">
#>                     <div class="form-group shiny-input-container">
#>                       <label class="control-label" id="manhattan-custom.models-__ROWIDX__-line_width-label" for="manhattan-custom.models-__ROWIDX__-line_width">Line width</label>
#>                       <input id="manhattan-custom.models-__ROWIDX__-line_width" type="number" class="shiny-input-number form-control" value="2" data-update-on="change" min="0.5" max="20" step="0.5"/>
#>                     </div>
#>                   </div>
#>                   <div class="mdi-field" data-key="drc_fct" data-backend="drm" style="flex: 1 1 calc(25% - 8px); min-width: 120px; display: none;">
#>                     <div class="form-group shiny-input-container">
#>                       <label class="control-label" id="manhattan-custom.models-__ROWIDX__-drc_fct-label" for="manhattan-custom.models-__ROWIDX__-drc_fct">Drc fct</label>
#>                       <div>
#>                         <select id="manhattan-custom.models-__ROWIDX__-drc_fct" class="shiny-input-select"><option value="LL.4" selected>LL.4</option>
#> <option value="LL.3">LL.3</option>
#> <option value="LL.2">LL.2</option>
#> <option value="W1.4">W1.4</option>
#> <option value="W2.4">W2.4</option></select>
#>                         <script type="application/json" data-for="manhattan-custom.models-__ROWIDX__-drc_fct" data-nonempty="">{"plugins":["selectize-plugin-a11y"]}</script>
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
#>     <div class="tab-pane" data-value="Axes" id="tab-6592-13">
#>       <div class="vizmodules-input-grid" style="--viz-input-columns: 2;">
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" style="width:100%;">
#>             <label class="control-label" id="manhattan-title.font.family-label" for="manhattan-title.font.family">Title Font</label>
#>             <div id="manhattan-title.font.family" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="change">
#>               <script type="application/json" data-for="manhattan-title.font.family">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["Arial","Balto","Courier New","Droid Sans","Droid Serif","Droid Sans Mono","Gravitas One","Old Standard TT","Open Sans","Overpass","PT Sans Narrow","Raleway","Times New Roman","Verdana","sans-serif","serif","monospace"],"value":["Arial","Balto","Courier New","Droid Sans","Droid Serif","Droid Sans Mono","Gravitas One","Old Standard TT","Open Sans","Overpass","PT Sans Narrow","Raleway","Times New Roman","Verdana","sans-serif","serif","monospace"]}},"config":{"multiple":false,"search":true,"selectedValue":"Arial","hideClearButton":true,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":false,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":true,"disableOptionGroupCheckbox":true,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>             </div>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour">
#>             <label class="control-label" for="manhattan-title.font.color">Title Color</label>
#>             <input id="manhattan-title.font.color" type="text" class="form-control shiny-colour-input" data-init-value="#000000" data-show-colour="both" data-palette="square"/>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="manhattan-title.font.size-label" for="manhattan-title.font.size">Title Size</label>
#>             <input id="manhattan-title.font.size" type="number" class="shiny-input-number form-control" value="26" data-update-on="change" min="1" step="1"/>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="manhattan-axis.title.horizontal.position-label" for="manhattan-axis.title.horizontal.position">Title position</label>
#>             <input id="manhattan-axis.title.horizontal.position" type="number" class="shiny-input-number form-control" value="0.5" data-update-on="change" min="0" max="1" step="0.1"/>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="manhattan-axis.title.font.size-label" for="manhattan-axis.title.font.size">Axis Title Size</label>
#>             <input id="manhattan-axis.title.font.size" type="number" class="shiny-input-number form-control" value="18" data-update-on="change" min="1" step="1"/>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour">
#>             <label class="control-label" for="manhattan-axis.title.font.color">Axis Title Color</label>
#>             <input id="manhattan-axis.title.font.color" type="text" class="form-control shiny-colour-input" data-init-value="#000000" data-show-colour="both" data-palette="square"/>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" style="width:100%;">
#>             <label class="control-label" id="manhattan-axis.title.font.family-label" for="manhattan-axis.title.font.family">Axis Title Font</label>
#>             <div id="manhattan-axis.title.font.family" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="change">
#>               <script type="application/json" data-for="manhattan-axis.title.font.family">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["Arial","Balto","Courier New","Droid Sans","Droid Serif","Droid Sans Mono","Gravitas One","Old Standard TT","Open Sans","Overpass","PT Sans Narrow","Raleway","Times New Roman","Verdana","sans-serif","serif","monospace"],"value":["Arial","Balto","Courier New","Droid Sans","Droid Serif","Droid Sans Mono","Gravitas One","Old Standard TT","Open Sans","Overpass","PT Sans Narrow","Raleway","Times New Roman","Verdana","sans-serif","serif","monospace"]}},"config":{"multiple":false,"search":true,"selectedValue":"Arial","hideClearButton":true,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":false,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":true,"disableOptionGroupCheckbox":true,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>             </div>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container">
#>             <div class="checkbox">
#>               <label>
#>                 <input id="manhattan-axis.showline" type="checkbox" class="shiny-input-checkbox" checked="checked"/>
#>                 <span>Show Axis Borders</span>
#>               </label>
#>             </div>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container">
#>             <div class="checkbox">
#>               <label>
#>                 <input id="manhattan-axis.mirror" type="checkbox" class="shiny-input-checkbox" checked="checked"/>
#>                 <span>Mirror Axis Borders</span>
#>               </label>
#>             </div>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container">
#>             <div class="checkbox">
#>               <label>
#>                 <input id="manhattan-show.grid.x" type="checkbox" class="shiny-input-checkbox" checked="checked"/>
#>                 <span>Show X Gridlines</span>
#>               </label>
#>             </div>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container">
#>             <div class="checkbox">
#>               <label>
#>                 <input id="manhattan-show.grid.y" type="checkbox" class="shiny-input-checkbox" checked="checked"/>
#>                 <span>Show Y Gridlines</span>
#>               </label>
#>             </div>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour">
#>             <label class="control-label" for="manhattan-grid.color">Gridline Color</label>
#>             <input id="manhattan-grid.color" type="text" class="form-control shiny-colour-input" data-init-value="#CCCCCC" data-show-colour="both" data-palette="square"/>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour">
#>             <label class="control-label" for="manhattan-axis.linecolor">Axis Line Color</label>
#>             <input id="manhattan-axis.linecolor" type="text" class="form-control shiny-colour-input" data-init-value="black" data-show-colour="both" data-palette="square"/>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="manhattan-axis.linewidth-label" for="manhattan-axis.linewidth">Axis Line Width</label>
#>             <input id="manhattan-axis.linewidth" type="number" class="shiny-input-number form-control" value="0.5" data-update-on="change" min="0" step="0.1"/>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="manhattan-axis.tickfont.size-label" for="manhattan-axis.tickfont.size">Tick Label Size</label>
#>             <input id="manhattan-axis.tickfont.size" type="number" class="shiny-input-number form-control" value="12" data-update-on="change" min="1" step="1"/>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour">
#>             <label class="control-label" for="manhattan-axis.tickfont.color">Tick Label Color</label>
#>             <input id="manhattan-axis.tickfont.color" type="text" class="form-control shiny-colour-input" data-init-value="black" data-show-colour="both" data-palette="square"/>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" style="width:100%;">
#>             <label class="control-label" id="manhattan-axis.tickfont.family-label" for="manhattan-axis.tickfont.family">Tick Label Font</label>
#>             <div id="manhattan-axis.tickfont.family" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="change">
#>               <script type="application/json" data-for="manhattan-axis.tickfont.family">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["Arial","Balto","Courier New","Droid Sans","Droid Serif","Droid Sans Mono","Gravitas One","Old Standard TT","Open Sans","Overpass","PT Sans Narrow","Raleway","Times New Roman","Verdana","sans-serif","serif","monospace"],"value":["Arial","Balto","Courier New","Droid Sans","Droid Serif","Droid Sans Mono","Gravitas One","Old Standard TT","Open Sans","Overpass","PT Sans Narrow","Raleway","Times New Roman","Verdana","sans-serif","serif","monospace"]}},"config":{"multiple":false,"search":true,"selectedValue":"Arial","hideClearButton":true,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":false,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":true,"disableOptionGroupCheckbox":true,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>             </div>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="manhattan-axis.tickangle.x-label" for="manhattan-axis.tickangle.x">X Tick Label Angle</label>
#>             <input id="manhattan-axis.tickangle.x" type="number" class="shiny-input-number form-control" value="0" data-update-on="change" min="-180" max="180" step="15"/>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="manhattan-axis.tickangle.y-label" for="manhattan-axis.tickangle.y">Y Tick Label Angle</label>
#>             <input id="manhattan-axis.tickangle.y" type="number" class="shiny-input-number form-control" value="0" data-update-on="change" min="-180" max="180" step="15"/>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" style="width:100%;">
#>             <label class="control-label" id="manhattan-axis.ticks-label" for="manhattan-axis.ticks">Tick Position</label>
#>             <div id="manhattan-axis.ticks" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="change">
#>               <script type="application/json" data-for="manhattan-axis.ticks">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["Outside","Inside","(none)"],"value":["outside","inside",""]}},"config":{"multiple":false,"search":false,"selectedValue":"outside","hideClearButton":true,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":false,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":true,"disableOptionGroupCheckbox":true,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>             </div>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour">
#>             <label class="control-label" for="manhattan-axis.tickcolor">Tick Mark Color</label>
#>             <input id="manhattan-axis.tickcolor" type="text" class="form-control shiny-colour-input" data-init-value="black" data-show-colour="both" data-palette="square"/>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="manhattan-axis.ticklen-label" for="manhattan-axis.ticklen">Tick Mark Length</label>
#>             <input id="manhattan-axis.ticklen" type="number" class="shiny-input-number form-control" value="5" data-update-on="change" min="0" step="1"/>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="manhattan-axis.tickwidth-label" for="manhattan-axis.tickwidth">Tick Mark Width</label>
#>             <input id="manhattan-axis.tickwidth" type="number" class="shiny-input-number form-control" value="1" data-update-on="change" min="0" step="0.1"/>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="manhattan-facet.title.font.size-label" for="manhattan-facet.title.font.size">Facet Subplot Title Size</label>
#>             <input id="manhattan-facet.title.font.size" type="number" class="shiny-input-number form-control" value="18" data-update-on="change" min="1" step="1"/>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour">
#>             <label class="control-label" for="manhattan-facet.title.font.color">Facet Title Color</label>
#>             <input id="manhattan-facet.title.font.color" type="text" class="form-control shiny-colour-input" data-init-value="#000000" data-show-colour="both" data-palette="square"/>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" style="width:100%;">
#>             <label class="control-label" id="manhattan-facet.title.font.family-label" for="manhattan-facet.title.font.family">Facet Title Font</label>
#>             <div id="manhattan-facet.title.font.family" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="change">
#>               <script type="application/json" data-for="manhattan-facet.title.font.family">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["Arial","Balto","Courier New","Droid Sans","Droid Serif","Droid Sans Mono","Gravitas One","Old Standard TT","Open Sans","Overpass","PT Sans Narrow","Raleway","Times New Roman","Verdana","sans-serif","serif","monospace"],"value":["Arial","Balto","Courier New","Droid Sans","Droid Serif","Droid Sans Mono","Gravitas One","Old Standard TT","Open Sans","Overpass","PT Sans Narrow","Raleway","Times New Roman","Verdana","sans-serif","serif","monospace"]}},"config":{"multiple":false,"search":true,"selectedValue":"Arial","hideClearButton":true,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":false,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":true,"disableOptionGroupCheckbox":true,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
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
#>         <label for="manhattan-auto.update" style="padding-right: 10px;">Auto Update</label>
#>         <input id="manhattan-auto.update" type="checkbox" checked="checked"/>
#>         <label class="switch label-success bg-success" for="manhattan-auto.update"></label>
#>       </div>
#>     </div>
#>   </div>
#>   <div class="module-tack-buttons" style="display: flex; flex-wrap: wrap; gap: 8px;">
#>     <button class="btn btn-default action-button btn-primary" id="manhattan-update" style="flex: 1 1 45%;" type="button"><span class="action-label">Update</span></button>
#>     <button class="btn btn-default action-button btn-secondary" id="manhattan-reset" style="flex: 1 1 45%;" type="button"><span class="action-label">Reset</span></button>
#>     <a aria-disabled="true" class="btn btn-default shiny-download-link disabled btn-secondary viz-source-download" data-viz-source-ns="manhattan-" download href="" id="manhattan-download.source" style="flex: 1 1 100%;" tabindex="-1" target="_blank">
#>       <i class="far fa-file-code" role="presentation" aria-label="file-code icon"></i>
#>       Source Download
#>     </a>
#>     <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('manhattan-download.source', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Download the plot as a self-contained HTML file and as SVG and PNG images of it as it looks now, along with the plot source data and statistics (if applicable) as CSV files.'})}, 500)});</script>
#>   </div>
#> </div>
```
