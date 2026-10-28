# Input UI components for the enrichmentDotPlot module

This should be placed in the UI where the inputs should be shown, with
an `id` that matches the `id` used in the
[`enrichmentDotPlotServer()`](https://j-andrews7.github.io/sciVizModules/reference/enrichmentDotPlotServer.md)
and
[`enrichmentDotPlotOutputUI()`](https://j-andrews7.github.io/sciVizModules/reference/enrichmentDotPlotOutputUI.md)
functions.

## Usage

``` r
enrichmentDotPlotInputsUI(
  id,
  data,
  defaults = NULL,
  title = "Enrichment DotPlot Settings",
  columns = 2
)
```

## Arguments

- id:

  The ID for the Shiny module.

- data:

  The enrichment results data frame used for plot generation.

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
[`VizModules::plotthis_DotPlotInputsUI()`](https://j-andrews7.github.io/VizModules/reference/plotthis_DotPlotInputsUI.html)
and pre-configures it for functional enrichment results (e.g. the output
of `clusterProfiler::enrichGO()` or
`clusterProfiler::compareCluster()`). It is designed to interpret
enrichment tables as a dot plot where the enrichment terms are on the
y-axis, a grouping variable is on the x-axis, dot size encodes the gene
ratio, and dot color encodes significance.

The data are automatically augmented before being passed to the wrapped
DotPlot UI so that the appropriate defaults can be selected:

- A numeric `GeneRatio` column is derived when the incoming `GeneRatio`
  is a `"count/total"` fraction string.

- A `neg_log10_pvalue` column (\\-\log\_{10}(p)\\) is derived from the
  first available p-value column (`p.adjust`, `padj`, `FDR`, `qvalue`,
  `pvalue`, ...).

- A categorical grouping column is guaranteed for the x-axis (a constant
  `Group` column is added when none is detected).

## Enrichment defaults

The following defaults are selected automatically (any value supplied
via `defaults` takes precedence):

- `y.data` - The enrichment term column (e.g. `Description`)

- `x.data` - A grouping column (e.g. `Cluster`) or a constant `Group`
  column when none is present

- `size.by` - `GeneRatio` (or another detected ratio column)

- `size.scale.min` - 0 when that column is a ratio or count (never
  negative), so dot area is proportional to it and the size legend
  starts at 0; a signed score such as NES keeps its range

- `fill.by` - `neg_log10_pvalue`

All other
[`plotthis::DotPlot()`](https://pwwang.github.io/plotthis/reference/dotplot.html)
parameters remain available via the wrapped UI.

## See also

[`plotthis::DotPlot()`](https://pwwang.github.io/plotthis/reference/dotplot.html),
[`VizModules::plotthis_DotPlotInputsUI()`](https://j-andrews7.github.io/VizModules/reference/plotthis_DotPlotInputsUI.html),
[`enrichmentDotPlotOutputUI()`](https://j-andrews7.github.io/sciVizModules/reference/enrichmentDotPlotOutputUI.md),
[`enrichmentDotPlotServer()`](https://j-andrews7.github.io/sciVizModules/reference/enrichmentDotPlotServer.md),
[`enrichmentDotPlotApp()`](https://j-andrews7.github.io/sciVizModules/reference/enrichmentDotPlotApp.md)

## Author

Jacob Martin, Jared Andrews

## Examples

``` r
library(sciVizModules)
data(example_enrichment)
enrichmentDotPlotInputsUI("enrichmentDotPlot", example_enrichment)
#> <h3>Enrichment DotPlot Settings</h3>
#> <div class="tabbable vizmodules-input-tabs">
#>   <ul class="nav nav-tabs shiny-tab-input" id="enrichmentDotPlot-DotPlotTabsetPanel" data-tabsetid="6690">
#>     <li class="active">
#>       <a href="#tab-6690-1" data-toggle="tab" data-bs-toggle="tab" data-value="Data">Data</a>
#>     </li>
#>     <li>
#>       <a href="#tab-6690-2" data-toggle="tab" data-bs-toggle="tab" data-value="Facet">Facet</a>
#>     </li>
#>     <li>
#>       <a href="#tab-6690-3" data-toggle="tab" data-bs-toggle="tab" data-value="Aesthetics">Aesthetics</a>
#>     </li>
#>     <li>
#>       <a href="#tab-6690-4" data-toggle="tab" data-bs-toggle="tab" data-value="Legend">Legend</a>
#>     </li>
#>     <li>
#>       <a href="#tab-6690-5" data-toggle="tab" data-bs-toggle="tab" data-value="Plotly">Plotly</a>
#>     </li>
#>     <li>
#>       <a href="#tab-6690-6" data-toggle="tab" data-bs-toggle="tab" data-value="Axes">Axes</a>
#>     </li>
#>     <li>
#>       <a href="#tab-6690-7" data-toggle="tab" data-bs-toggle="tab" data-value="Lines">Lines</a>
#>     </li>
#>   </ul>
#>   <div class="tab-content" data-tabsetid="6690">
#>     <div class="tab-pane active" data-value="Data" id="tab-6690-1">
#>       <div class="vizmodules-input-grid" style="--viz-input-columns: 2;">
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" style="width:100%;" id="tipify1592748">
#>             <label class="control-label" id="enrichmentDotPlot-x.data-label" for="enrichmentDotPlot-x.data">X Values</label>
#>             <div id="enrichmentDotPlot-x.data" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="change">
#>               <script type="application/json" data-for="enrichmentDotPlot-x.data">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["Cluster","ONTOLOGY","ID","Description","BgRatio"],"value":["Cluster","ONTOLOGY","ID","Description","BgRatio"]}},"config":{"multiple":false,"search":false,"selectedValue":"Cluster","hideClearButton":true,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":false,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":true,"disableOptionGroupCheckbox":true,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify1592748', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'A character string naming the column for the x-axis. Must be a numeric column (bars extend from 0 to the data value).'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" style="width:100%;" id="tipify4015980">
#>             <label class="control-label" id="enrichmentDotPlot-y.data-label" for="enrichmentDotPlot-y.data">Y Values</label>
#>             <div id="enrichmentDotPlot-y.data" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="change">
#>               <script type="application/json" data-for="enrichmentDotPlot-y.data">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["Cluster","ONTOLOGY","ID","Description","BgRatio"],"value":["Cluster","ONTOLOGY","ID","Description","BgRatio"]}},"config":{"multiple":false,"search":false,"selectedValue":"Description","hideClearButton":true,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":false,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":true,"disableOptionGroupCheckbox":true,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify4015980', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'A character string naming the column for the y-axis. Must be a factor or character column (each level gets a lollipop bar).'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" style="width:100%;" id="tipify16465">
#>             <label class="control-label" id="enrichmentDotPlot-size.by-label" for="enrichmentDotPlot-size.by">Size By</label>
#>             <div id="enrichmentDotPlot-size.by" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="change">
#>               <script type="application/json" data-for="enrichmentDotPlot-size.by">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["(none)","GeneRatio","pvalue","p.adjust","qvalue","Count","neg_log10_pvalue"],"value":["","GeneRatio","pvalue","p.adjust","qvalue","Count","neg_log10_pvalue"]}},"config":{"multiple":false,"search":false,"selectedValue":"GeneRatio","hideClearButton":true,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":false,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":true,"disableOptionGroupCheckbox":true,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify16465', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'A character string naming a numeric column whose values control dot size. When `NULL` (the default), the per-combination observation count is computed automatically (via `dplyr::summarise(n =   n())`) and used as the size variable. If `fill_by` is also present, the first value of `fill_by` per combination is retained with a warning. A single numeric value is also accepted and sets a constant dot size (used by `ScatterPlot`).'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" style="width:100%;" id="tipify4179660">
#>             <label class="control-label" id="enrichmentDotPlot-fill.by-label" for="enrichmentDotPlot-fill.by">Fill By</label>
#>             <div id="enrichmentDotPlot-fill.by" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="change">
#>               <script type="application/json" data-for="enrichmentDotPlot-fill.by">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["(none)","GeneRatio","pvalue","p.adjust","qvalue","Count","neg_log10_pvalue"],"value":["","GeneRatio","pvalue","p.adjust","qvalue","Count","neg_log10_pvalue"]}},"config":{"multiple":false,"search":false,"selectedValue":"neg_log10_pvalue","hideClearButton":true,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":false,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":true,"disableOptionGroupCheckbox":true,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify4179660', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'A character string naming a numeric column whose values control the fill colour of the dots (and lollipop inner bars). A continuous gradient from `palette` is applied via `scale_fill_gradientn()`. When `NULL` (the default), all dots are filled with a single constant colour from the middle of the palette.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" style="width:100%;" id="tipify7639343">
#>             <label class="control-label" id="enrichmentDotPlot-fill.cutoff.direction-label" for="enrichmentDotPlot-fill.cutoff.direction">Fill Cutoff Direction</label>
#>             <div id="enrichmentDotPlot-fill.cutoff.direction" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="change">
#>               <script type="application/json" data-for="enrichmentDotPlot-fill.cutoff.direction">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["&lt;","&lt;=","&gt;","&gt;="],"value":["&lt;","&lt;=","&gt;","&gt;="]}},"config":{"multiple":false,"search":false,"selectedValue":"&lt;","hideClearButton":true,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":false,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":true,"disableOptionGroupCheckbox":true,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify7639343', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Direction of the fill cutoff. Values on the selected side of the cutoff (e.g. &#39;<&#39; greys out values below it) are set to NA and drawn in grey. Only applies when &#39;Fill By&#39; and &#39;Fill Cutoff&#39; are set.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify7944776">
#>             <label class="control-label" id="enrichmentDotPlot-fill.cutoff-label" for="enrichmentDotPlot-fill.cutoff">Fill Cutoff</label>
#>             <input id="enrichmentDotPlot-fill.cutoff" type="number" class="shiny-input-number form-control" value="NA" data-update-on="change"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify7944776', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'A string expression specifying which values of `fill_by` to grey out. Format: an operator followed by a number, e.g. `"< 18"`, `"<= 18"`, `"> 18"`, or `">= 18"`. Values matching the condition are set to `NA` and rendered in grey (`"grey80"`), while the rest are coloured by the fill gradient. The operator determines which side of the threshold is greyed out, independent of `palreverse`. A numeric value is also accepted as shorthand for `"<"` (e.g. `18` is equivalent to `"< 18"`). Requires `fill_by` to be set.'})}, 500)});</script>
#>         </div>
#>       </div>
#>     </div>
#>     <div class="tab-pane" data-value="Facet" id="tab-6690-2">
#>       <div class="vizmodules-input-grid" style="--viz-input-columns: 2;">
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" style="width:100%;" id="tipify2425870">
#>             <label class="control-label" id="enrichmentDotPlot-facet.by-label" for="enrichmentDotPlot-facet.by">Facet By</label>
#>             <div id="enrichmentDotPlot-facet.by" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="change">
#>               <script type="application/json" data-for="enrichmentDotPlot-facet.by">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["(none)","Cluster","ONTOLOGY","ID","Description","BgRatio"],"value":["","Cluster","ONTOLOGY","ID","Description","BgRatio"]}},"config":{"multiple":false,"search":false,"selectedValue":"","hideClearButton":true,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":false,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":true,"disableOptionGroupCheckbox":true,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify2425870', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'A character string specifying the column name of the data frame to facet the plot. Otherwise, the data will be split by `split_by` and generate multiple plots and combine them into one using `patchwork::wrap_plots`'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" style="width:100%;" id="tipify7591709">
#>             <label class="control-label" id="enrichmentDotPlot-facet.scale-label" for="enrichmentDotPlot-facet.scale">Facet Scale</label>
#>             <div id="enrichmentDotPlot-facet.scale" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="change">
#>               <script type="application/json" data-for="enrichmentDotPlot-facet.scale">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["fixed","free","free_x","free_y"],"value":["fixed","free","free_x","free_y"]}},"config":{"multiple":false,"search":false,"selectedValue":"fixed","hideClearButton":true,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":false,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":true,"disableOptionGroupCheckbox":true,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify7591709', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Whether to scale the axes of facets. Default is "fixed" Other options are "free", "free_x", "free_y". See `ggplot2::facet_wrap`'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify291042">
#>             <label class="control-label" id="enrichmentDotPlot-facet.ncol-label" for="enrichmentDotPlot-facet.ncol">Columns</label>
#>             <input id="enrichmentDotPlot-facet.ncol" type="number" class="shiny-input-number form-control" data-update-on="change" min="0" max="20"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify291042', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'A numeric value specifying the number of columns in the facet. When facet_by is a single column and facet_wrap is used.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify4373408">
#>             <label class="control-label" id="enrichmentDotPlot-facet.nrow-label" for="enrichmentDotPlot-facet.nrow">Rows</label>
#>             <input id="enrichmentDotPlot-facet.nrow" type="number" class="shiny-input-number form-control" data-update-on="change" min="0" max="20"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify4373408', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'A numeric value specifying the number of rows in the facet. When facet_by is a single column and facet_wrap is used.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify5304095">
#>             <div class="material-switch">
#>               <label for="enrichmentDotPlot-facet.by.row" style="padding-right: 10px;">Facet by Row</label>
#>               <input id="enrichmentDotPlot-facet.by.row" type="checkbox" checked="checked"/>
#>               <label class="switch label-success bg-success" for="enrichmentDotPlot-facet.by.row"></label>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify5304095', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'A logical value indicating whether to fill the plots by row. Default is TRUE.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify4298314">
#>             <label class="control-label" id="enrichmentDotPlot-subplot.margin.x-label" for="enrichmentDotPlot-subplot.margin.x">Subplot Spacing (Horizontal)</label>
#>             <input id="enrichmentDotPlot-subplot.margin.x" type="number" class="shiny-input-number form-control" value="0.03" data-update-on="change" min="0" max="1" step="0.01"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify4298314', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Horizontal spacing between facet panel columns as a fraction of the plot area (e.g. 0.03). Only applies when faceting is active.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify8092969">
#>             <label class="control-label" id="enrichmentDotPlot-subplot.margin.y-label" for="enrichmentDotPlot-subplot.margin.y">Subplot Spacing (Vertical)</label>
#>             <input id="enrichmentDotPlot-subplot.margin.y" type="number" class="shiny-input-number form-control" value="0.1" data-update-on="change" min="0" max="1" step="0.01"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify8092969', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Vertical spacing between facet panel rows as a fraction of the plot area (e.g. 0.1). Only applies when faceting is active.'})}, 500)});</script>
#>         </div>
#>       </div>
#>     </div>
#>     <div class="tab-pane" data-value="Aesthetics" id="tab-6690-3">
#>       <div class="vizmodules-input-grid" style="--viz-input-columns: 2;">
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" style="width:100%;" id="tipify9225646">
#>             <label class="control-label" id="enrichmentDotPlot-palette.name-label" for="enrichmentDotPlot-palette.name">Color Palette</label>
#>             <div id="enrichmentDotPlot-palette.name" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="change">
#>               <script type="application/json" data-for="enrichmentDotPlot-palette.name">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["dittoColors","dittoColors_full","ggplot2","viridis","magma","inferno","plasma","cividis","BrBG","PiYG","PRGn","PuOr","RdBu","RdGy","RdYlBu","RdYlGn","Spectral","Accent","Dark2","Paired","Pastel1","Pastel2","Set1","Set2","Set3","Blues","BuGn","BuPu","GnBu","Greens","Greys","Oranges","OrRd","PuBu","PuBuGn","PuRd","Purples","RdPu","Reds","YlGn","YlGnBu","YlOrBr","YlOrRd"],"value":["dittoColors","dittoColors_full","ggplot2","viridis","magma","inferno","plasma","cividis","BrBG","PiYG","PRGn","PuOr","RdBu","RdGy","RdYlBu","RdYlGn","Spectral","Accent","Dark2","Paired","Pastel1","Pastel2","Set1","Set2","Set3","Blues","BuGn","BuPu","GnBu","Greens","Greys","Oranges","OrRd","PuBu","PuBuGn","PuRd","Purples","RdPu","Reds","YlGn","YlGnBu","YlOrBr","YlOrRd"]}},"config":{"multiple":false,"search":true,"selectedValue":"Spectral","hideClearButton":true,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":false,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":true,"disableOptionGroupCheckbox":true,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify9225646', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'A character string specifying the palette to use. A named list or vector can be used to specify the palettes for different `split_by` values.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify6750235">
#>             <div class="material-switch">
#>               <label for="enrichmentDotPlot-palreverse" style="padding-right: 10px;">Reverse Palette</label>
#>               <input id="enrichmentDotPlot-palreverse" type="checkbox"/>
#>               <label class="switch label-success bg-success" for="enrichmentDotPlot-palreverse"></label>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify6750235', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'A logical value indicating whether to reverse the palette. Default is FALSE.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify939682">
#>             <label class="control-label" id="enrichmentDotPlot-alpha-label" for="enrichmentDotPlot-alpha">Alpha</label>
#>             <input id="enrichmentDotPlot-alpha" type="number" class="shiny-input-number form-control" value="1" data-update-on="change" min="0" max="1"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify939682', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'A numeric value specifying the transparency of the plot.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour" id="tipify1974633">
#>             <label class="control-label" for="enrichmentDotPlot-border.color">Border Color</label>
#>             <input id="enrichmentDotPlot-border.color" type="text" class="form-control shiny-colour-input" data-init-value="black" data-show-colour="both" data-palette="square"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify1974633', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Controls the dot border colour and lollipop outer-shadow appearance: itemize{ item `TRUE` — dot borders and lollipop inner bars follow the `fill_by` gradient via `scale_color_gradientn()`; lollipop outer shadow is black. item `"black"` (default) — constant black borders on dots and black outer shadow on lollipop bars. item A colour string (e.g. `"red"`, `"#FF0000"`) — constant colour for both dot borders and lollipop outer shadows. item `FALSE` — no dot borders and no lollipop outer shadow (the inner coloured bars remain visible in lollipop mode). }'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify4755451">
#>             <label class="control-label" id="enrichmentDotPlot-border.size-label" for="enrichmentDotPlot-border.size">Border Size</label>
#>             <input id="enrichmentDotPlot-border.size" type="number" class="shiny-input-number form-control" value="0.5" data-update-on="change" min="0" step="0.1"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify4755451', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'A numeric value for the stroke width of dot borders and the base linewidth of lollipop bars. In lollipop mode, the outer shadow uses `border_size * 4` and the inner bar uses `border_size * 2`. Default: `0.5`.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify7143716">
#>             <label class="control-label" id="enrichmentDotPlot-lower.quantile-label" for="enrichmentDotPlot-lower.quantile">Lower Quantile</label>
#>             <input id="enrichmentDotPlot-lower.quantile" type="number" class="shiny-input-number form-control" value="0" data-update-on="change" min="0" max="1" step="0.01"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify7143716', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Lower and upper quantiles for the continuous color/fill scale. The actual cutoffs are determined by these quantiles when `lower_cutoff` and `upper_cutoff` are `NULL`. Defaults: `lower_quantile = 0`, `upper_quantile = 0.99`.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify5380793">
#>             <label class="control-label" id="enrichmentDotPlot-upper.quantile-label" for="enrichmentDotPlot-upper.quantile">Upper Quantile</label>
#>             <input id="enrichmentDotPlot-upper.quantile" type="number" class="shiny-input-number form-control" value="1" data-update-on="change" min="0" max="1" step="0.01"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify5380793', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Lower and upper quantiles for the continuous color/fill scale. The actual cutoffs are determined by these quantiles when `lower_cutoff` and `upper_cutoff` are `NULL`. Defaults: `lower_quantile = 0`, `upper_quantile = 0.99`.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify8753830">
#>             <label class="control-label" id="enrichmentDotPlot-lower.cutoff-label" for="enrichmentDotPlot-lower.cutoff">Lower Cutoff</label>
#>             <input id="enrichmentDotPlot-lower.cutoff" type="number" class="shiny-input-number form-control" value="NA" data-update-on="change"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify8753830', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Explicit lower and upper cutoffs for the continuous color/fill scale. When `NULL` (the default), the cutoffs are determined by `lower_quantile` and `upper_quantile` via `link[stats]{quantile`}. Values outside the `[lower_cutoff, upper_cutoff]` range are clamped (winsorized) to the nearest cutoff value.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify2935854">
#>             <label class="control-label" id="enrichmentDotPlot-upper.cutoff-label" for="enrichmentDotPlot-upper.cutoff">Upper Cutoff</label>
#>             <input id="enrichmentDotPlot-upper.cutoff" type="number" class="shiny-input-number form-control" value="NA" data-update-on="change"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify2935854', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Explicit lower and upper cutoffs for the continuous color/fill scale. When `NULL` (the default), the cutoffs are determined by `lower_quantile` and `upper_quantile` via `link[stats]{quantile`}. Values outside the `[lower_cutoff, upper_cutoff]` range are clamped (winsorized) to the nearest cutoff value.'})}, 500)});</script>
#>         </div>
#>       </div>
#>     </div>
#>     <div class="tab-pane" data-value="Legend" id="tab-6690-4">
#>       <div class="vizmodules-input-grid" style="--viz-input-columns: 2;">
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify2247655">
#>             <label class="control-label" id="enrichmentDotPlot-size.min-label" for="enrichmentDotPlot-size.min">Min Dot Size</label>
#>             <input id="enrichmentDotPlot-size.min" type="number" class="shiny-input-number form-control" value="1" data-update-on="change" min="0" step="1"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify2247655', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'A numeric value for the smallest dot size in the `scale_size(range = c(size_min, size_max))` range. Default: `1`.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify6909178">
#>             <label class="control-label" id="enrichmentDotPlot-size.max-label" for="enrichmentDotPlot-size.max">Max Dot Size</label>
#>             <input id="enrichmentDotPlot-size.max" type="number" class="shiny-input-number form-control" value="6" data-update-on="change" min="0" step="1"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify6909178', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'A numeric value for the largest dot size in the `scale_size(range = c(size_min, size_max))` range. Default: `10`.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify3123294">
#>             <label class="control-label" id="enrichmentDotPlot-size.scale.min-label" for="enrichmentDotPlot-size.scale.min">Size Scale Min</label>
#>             <input id="enrichmentDotPlot-size.scale.min" type="number" class="shiny-input-number form-control" value="0" data-update-on="change"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify3123294', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': '&#39;Size By&#39; value drawn at the Min Dot Size, and where the size legend starts. Leave blank to use the column&#39;s minimum. Smaller values are drawn at the Min Dot Size.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify4832982">
#>             <label class="control-label" id="enrichmentDotPlot-size.scale.max-label" for="enrichmentDotPlot-size.scale.max">Size Scale Max</label>
#>             <input id="enrichmentDotPlot-size.scale.max" type="number" class="shiny-input-number form-control" value="NA" data-update-on="change"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify4832982', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': '&#39;Size By&#39; value drawn at the Max Dot Size, and where the size legend ends. Leave blank to use the column&#39;s maximum. Larger values are drawn at the Max Dot Size.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify1217967">
#>             <label class="control-label" id="enrichmentDotPlot-size.legend.x-label" for="enrichmentDotPlot-size.legend.x">Size Legend X Position</label>
#>             <input id="enrichmentDotPlot-size.legend.x" type="number" class="shiny-input-number form-control" value="1.04" data-update-on="change" step="0.02"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify1217967', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Horizontal position (paper coordinates) of the custom size legend drawn when &#39;Size By&#39; is set. Values just above 1 sit to the right of the plot; lower it to pull the legend inward on narrow plots or raise it to push it further out.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify6900072">
#>             <label class="control-label" id="enrichmentDotPlot-size.legend.y-label" for="enrichmentDotPlot-size.legend.y">Size Legend Y Position</label>
#>             <input id="enrichmentDotPlot-size.legend.y" type="number" class="shiny-input-number form-control" value="0.35" data-update-on="change" step="0.05"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify6900072', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Vertical position (paper coordinates) of the custom size legend drawn when &#39;Size By&#39; is set. Lower it to offset the size legend from an overlapping color or shape legend.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify3157314">
#>             <div class="material-switch">
#>               <label for="enrichmentDotPlot-legend.show" style="padding-right: 10px;">Show Legend</label>
#>               <input id="enrichmentDotPlot-legend.show" type="checkbox" checked="checked"/>
#>               <label class="switch label-success bg-success" for="enrichmentDotPlot-legend.show"></label>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify3157314', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Show the legend. Turning it off also hides colorbars and any point size legend.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" style="width:100%;" id="tipify8161877">
#>             <label class="control-label" id="enrichmentDotPlot-legend.font.family-label" for="enrichmentDotPlot-legend.font.family">Legend Font</label>
#>             <div id="enrichmentDotPlot-legend.font.family" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="change">
#>               <script type="application/json" data-for="enrichmentDotPlot-legend.font.family">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["Arial","Balto","Courier New","Droid Sans","Droid Serif","Droid Sans Mono","Gravitas One","Old Standard TT","Open Sans","Overpass","PT Sans Narrow","Raleway","Times New Roman","Verdana","sans-serif","serif","monospace"],"value":["Arial","Balto","Courier New","Droid Sans","Droid Serif","Droid Sans Mono","Gravitas One","Old Standard TT","Open Sans","Overpass","PT Sans Narrow","Raleway","Times New Roman","Verdana","sans-serif","serif","monospace"]}},"config":{"multiple":false,"search":true,"selectedValue":"Arial","hideClearButton":true,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":false,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":true,"disableOptionGroupCheckbox":true,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify8161877', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Font family of the legend title and entry labels.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour" id="tipify5459154">
#>             <label class="control-label" for="enrichmentDotPlot-legend.font.color">Legend Font Color</label>
#>             <input id="enrichmentDotPlot-legend.font.color" type="text" class="form-control shiny-colour-input" data-init-value="#000000" data-show-colour="both" data-palette="square"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify5459154', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Font color of the legend title and entry labels.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify9473171">
#>             <label class="control-label" id="enrichmentDotPlot-legend.title.size-label" for="enrichmentDotPlot-legend.title.size">Legend Title Size</label>
#>             <input id="enrichmentDotPlot-legend.title.size" type="number" class="shiny-input-number form-control" value="14" data-update-on="change" min="0" step="1"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify9473171', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Font size of the legend title.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify385265">
#>             <label class="control-label" id="enrichmentDotPlot-legend.text.size-label" for="enrichmentDotPlot-legend.text.size">Legend Text Size</label>
#>             <input id="enrichmentDotPlot-legend.text.size" type="number" class="shiny-input-number form-control" value="12" data-update-on="change" min="0" step="1"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify385265', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Font size of the legend entry labels.'})}, 500)});</script>
#>         </div>
#>       </div>
#>     </div>
#>     <div class="tab-pane" data-value="Plotly" id="tab-6690-5">
#>       <div class="vizmodules-input-grid" style="--viz-input-columns: 2;">
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" style="width:100%;">
#>             <label class="control-label" id="enrichmentDotPlot-download.format-label" for="enrichmentDotPlot-download.format">Download Format</label>
#>             <div id="enrichmentDotPlot-download.format" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="change">
#>               <script type="application/json" data-for="enrichmentDotPlot-download.format">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["svg","png","jpeg","webp"],"value":["svg","png","jpeg","webp"]}},"config":{"multiple":false,"search":false,"selectedValue":"svg","hideClearButton":true,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":false,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":true,"disableOptionGroupCheckbox":true,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>             </div>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify6476439">
#>             <label class="control-label" id="enrichmentDotPlot-margin.t-label" for="enrichmentDotPlot-margin.t">Margin Top</label>
#>             <input id="enrichmentDotPlot-margin.t" type="number" class="shiny-input-number form-control" value="70" data-update-on="change" min="0" step="5"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify6476439', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Top margin of the plot in pixels'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify796191">
#>             <label class="control-label" id="enrichmentDotPlot-margin.b-label" for="enrichmentDotPlot-margin.b">Margin Bottom</label>
#>             <input id="enrichmentDotPlot-margin.b" type="number" class="shiny-input-number form-control" value="70" data-update-on="change" min="0" step="5"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify796191', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Bottom margin of the plot in pixels'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify4329308">
#>             <label class="control-label" id="enrichmentDotPlot-margin.l-label" for="enrichmentDotPlot-margin.l">Margin Left</label>
#>             <input id="enrichmentDotPlot-margin.l" type="number" class="shiny-input-number form-control" value="70" data-update-on="change" min="0" step="5"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify4329308', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Left margin of the plot in pixels'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify7608931">
#>             <label class="control-label" id="enrichmentDotPlot-margin.r-label" for="enrichmentDotPlot-margin.r">Margin Right</label>
#>             <input id="enrichmentDotPlot-margin.r" type="number" class="shiny-input-number form-control" value="140" data-update-on="change" min="0" step="5"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify7608931', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Right margin of the plot in pixels'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour" id="tipify2937589">
#>             <label class="control-label" for="enrichmentDotPlot-shape.fill">Shape Fill</label>
#>             <input id="enrichmentDotPlot-shape.fill" type="text" class="form-control shiny-colour-input" data-init-value="rgba(0, 0, 0, 0)" data-show-colour="both" data-palette="square" data-allow-alpha="true"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify2937589', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Interior fill color for shapes drawn on the plot using Plotly&#39;s drawing tools'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour" id="tipify1073319">
#>             <label class="control-label" for="enrichmentDotPlot-shape.line.color">Shape Line Color</label>
#>             <input id="enrichmentDotPlot-shape.line.color" type="text" class="form-control shiny-colour-input" data-init-value="black" data-show-colour="both" data-palette="square" data-allow-alpha="true"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify1073319', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Outline color for shapes drawn on the plot using Plotly&#39;s drawing tools'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify729945">
#>             <label class="control-label" id="enrichmentDotPlot-shape.line.width-label" for="enrichmentDotPlot-shape.line.width">Shape Line Width</label>
#>             <input id="enrichmentDotPlot-shape.line.width" type="number" class="shiny-input-number form-control" value="4" data-update-on="change" min="0" step="0.25"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify729945', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Outline width for shapes drawn on the plot using Plotly&#39;s drawing tools'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" style="width:100%;" id="tipify3563146">
#>             <label class="control-label" id="enrichmentDotPlot-shape.linetype-label" for="enrichmentDotPlot-shape.linetype">Shape Linetype</label>
#>             <div id="enrichmentDotPlot-shape.linetype" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="change">
#>               <script type="application/json" data-for="enrichmentDotPlot-shape.linetype">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["solid","dot","dash","longdash","dashdot","longdashdot"],"value":["solid","dot","dash","longdash","dashdot","longdashdot"]}},"config":{"multiple":false,"search":false,"selectedValue":"solid","hideClearButton":true,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":false,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":true,"disableOptionGroupCheckbox":true,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify3563146', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Line dash style for shapes drawn on the plot using Plotly&#39;s drawing tools'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify5715608">
#>             <label class="control-label" id="enrichmentDotPlot-shape.opacity-label" for="enrichmentDotPlot-shape.opacity">Shape Opacity</label>
#>             <input id="enrichmentDotPlot-shape.opacity" type="number" class="shiny-input-number form-control" value="1" data-update-on="change" min="0" max="1" step="0.01"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify5715608', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Opacity of shapes drawn on the plot, where 0 is fully transparent and 1 is fully opaque'})}, 500)});</script>
#>         </div>
#>       </div>
#>     </div>
#>     <div class="tab-pane" data-value="Axes" id="tab-6690-6">
#>       <div class="vizmodules-input-grid" style="--viz-input-columns: 2;">
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container">
#>             <div class="material-switch">
#>               <label for="enrichmentDotPlot-rotate" style="padding-right: 10px;">Rotate (swap X/Y)</label>
#>               <input id="enrichmentDotPlot-rotate" type="checkbox"/>
#>               <label class="switch label-success bg-success" for="enrichmentDotPlot-rotate"></label>
#>             </div>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" style="width:100%;">
#>             <label class="control-label" id="enrichmentDotPlot-title.font.family-label" for="enrichmentDotPlot-title.font.family">Title Font</label>
#>             <div id="enrichmentDotPlot-title.font.family" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="change">
#>               <script type="application/json" data-for="enrichmentDotPlot-title.font.family">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["Arial","Balto","Courier New","Droid Sans","Droid Serif","Droid Sans Mono","Gravitas One","Old Standard TT","Open Sans","Overpass","PT Sans Narrow","Raleway","Times New Roman","Verdana","sans-serif","serif","monospace"],"value":["Arial","Balto","Courier New","Droid Sans","Droid Serif","Droid Sans Mono","Gravitas One","Old Standard TT","Open Sans","Overpass","PT Sans Narrow","Raleway","Times New Roman","Verdana","sans-serif","serif","monospace"]}},"config":{"multiple":false,"search":true,"selectedValue":"Arial","hideClearButton":true,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":false,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":true,"disableOptionGroupCheckbox":true,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>             </div>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour">
#>             <label class="control-label" for="enrichmentDotPlot-title.font.color">Title Color</label>
#>             <input id="enrichmentDotPlot-title.font.color" type="text" class="form-control shiny-colour-input" data-init-value="#000000" data-show-colour="both" data-palette="square"/>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="enrichmentDotPlot-title.font.size-label" for="enrichmentDotPlot-title.font.size">Title Size</label>
#>             <input id="enrichmentDotPlot-title.font.size" type="number" class="shiny-input-number form-control" value="26" data-update-on="change" min="1" step="1"/>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="enrichmentDotPlot-axis.title.horizontal.position-label" for="enrichmentDotPlot-axis.title.horizontal.position">Title position</label>
#>             <input id="enrichmentDotPlot-axis.title.horizontal.position" type="number" class="shiny-input-number form-control" value="0.5" data-update-on="change" min="0" max="1" step="0.1"/>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="enrichmentDotPlot-axis.title.font.size-label" for="enrichmentDotPlot-axis.title.font.size">Axis Title Size</label>
#>             <input id="enrichmentDotPlot-axis.title.font.size" type="number" class="shiny-input-number form-control" value="18" data-update-on="change" min="1" step="1"/>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour">
#>             <label class="control-label" for="enrichmentDotPlot-axis.title.font.color">Axis Title Color</label>
#>             <input id="enrichmentDotPlot-axis.title.font.color" type="text" class="form-control shiny-colour-input" data-init-value="#000000" data-show-colour="both" data-palette="square"/>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" style="width:100%;">
#>             <label class="control-label" id="enrichmentDotPlot-axis.title.font.family-label" for="enrichmentDotPlot-axis.title.font.family">Axis Title Font</label>
#>             <div id="enrichmentDotPlot-axis.title.font.family" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="change">
#>               <script type="application/json" data-for="enrichmentDotPlot-axis.title.font.family">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["Arial","Balto","Courier New","Droid Sans","Droid Serif","Droid Sans Mono","Gravitas One","Old Standard TT","Open Sans","Overpass","PT Sans Narrow","Raleway","Times New Roman","Verdana","sans-serif","serif","monospace"],"value":["Arial","Balto","Courier New","Droid Sans","Droid Serif","Droid Sans Mono","Gravitas One","Old Standard TT","Open Sans","Overpass","PT Sans Narrow","Raleway","Times New Roman","Verdana","sans-serif","serif","monospace"]}},"config":{"multiple":false,"search":true,"selectedValue":"Arial","hideClearButton":true,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":false,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":true,"disableOptionGroupCheckbox":true,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>             </div>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container">
#>             <div class="checkbox">
#>               <label>
#>                 <input id="enrichmentDotPlot-axis.showline" type="checkbox" class="shiny-input-checkbox" checked="checked"/>
#>                 <span>Show Axis Borders</span>
#>               </label>
#>             </div>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container">
#>             <div class="checkbox">
#>               <label>
#>                 <input id="enrichmentDotPlot-axis.mirror" type="checkbox" class="shiny-input-checkbox" checked="checked"/>
#>                 <span>Mirror Axis Borders</span>
#>               </label>
#>             </div>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container">
#>             <div class="checkbox">
#>               <label>
#>                 <input id="enrichmentDotPlot-show.grid.x" type="checkbox" class="shiny-input-checkbox" checked="checked"/>
#>                 <span>Show X Gridlines</span>
#>               </label>
#>             </div>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container">
#>             <div class="checkbox">
#>               <label>
#>                 <input id="enrichmentDotPlot-show.grid.y" type="checkbox" class="shiny-input-checkbox" checked="checked"/>
#>                 <span>Show Y Gridlines</span>
#>               </label>
#>             </div>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour">
#>             <label class="control-label" for="enrichmentDotPlot-grid.color">Gridline Color</label>
#>             <input id="enrichmentDotPlot-grid.color" type="text" class="form-control shiny-colour-input" data-init-value="#CCCCCC" data-show-colour="both" data-palette="square"/>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour">
#>             <label class="control-label" for="enrichmentDotPlot-axis.linecolor">Axis Line Color</label>
#>             <input id="enrichmentDotPlot-axis.linecolor" type="text" class="form-control shiny-colour-input" data-init-value="black" data-show-colour="both" data-palette="square"/>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="enrichmentDotPlot-axis.linewidth-label" for="enrichmentDotPlot-axis.linewidth">Axis Line Width</label>
#>             <input id="enrichmentDotPlot-axis.linewidth" type="number" class="shiny-input-number form-control" value="0.5" data-update-on="change" min="0" step="0.1"/>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="enrichmentDotPlot-axis.tickfont.size-label" for="enrichmentDotPlot-axis.tickfont.size">Tick Label Size</label>
#>             <input id="enrichmentDotPlot-axis.tickfont.size" type="number" class="shiny-input-number form-control" value="12" data-update-on="change" min="1" step="1"/>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour">
#>             <label class="control-label" for="enrichmentDotPlot-axis.tickfont.color">Tick Label Color</label>
#>             <input id="enrichmentDotPlot-axis.tickfont.color" type="text" class="form-control shiny-colour-input" data-init-value="black" data-show-colour="both" data-palette="square"/>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" style="width:100%;">
#>             <label class="control-label" id="enrichmentDotPlot-axis.tickfont.family-label" for="enrichmentDotPlot-axis.tickfont.family">Tick Label Font</label>
#>             <div id="enrichmentDotPlot-axis.tickfont.family" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="change">
#>               <script type="application/json" data-for="enrichmentDotPlot-axis.tickfont.family">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["Arial","Balto","Courier New","Droid Sans","Droid Serif","Droid Sans Mono","Gravitas One","Old Standard TT","Open Sans","Overpass","PT Sans Narrow","Raleway","Times New Roman","Verdana","sans-serif","serif","monospace"],"value":["Arial","Balto","Courier New","Droid Sans","Droid Serif","Droid Sans Mono","Gravitas One","Old Standard TT","Open Sans","Overpass","PT Sans Narrow","Raleway","Times New Roman","Verdana","sans-serif","serif","monospace"]}},"config":{"multiple":false,"search":true,"selectedValue":"Arial","hideClearButton":true,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":false,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":true,"disableOptionGroupCheckbox":true,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>             </div>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="enrichmentDotPlot-axis.tickangle.x-label" for="enrichmentDotPlot-axis.tickangle.x">X Tick Label Angle</label>
#>             <input id="enrichmentDotPlot-axis.tickangle.x" type="number" class="shiny-input-number form-control" value="0" data-update-on="change" min="-180" max="180" step="15"/>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="enrichmentDotPlot-axis.tickangle.y-label" for="enrichmentDotPlot-axis.tickangle.y">Y Tick Label Angle</label>
#>             <input id="enrichmentDotPlot-axis.tickangle.y" type="number" class="shiny-input-number form-control" value="0" data-update-on="change" min="-180" max="180" step="15"/>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" style="width:100%;">
#>             <label class="control-label" id="enrichmentDotPlot-axis.ticks-label" for="enrichmentDotPlot-axis.ticks">Tick Position</label>
#>             <div id="enrichmentDotPlot-axis.ticks" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="change">
#>               <script type="application/json" data-for="enrichmentDotPlot-axis.ticks">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["Outside","Inside","(none)"],"value":["outside","inside",""]}},"config":{"multiple":false,"search":false,"selectedValue":"outside","hideClearButton":true,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":false,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":true,"disableOptionGroupCheckbox":true,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>             </div>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour">
#>             <label class="control-label" for="enrichmentDotPlot-axis.tickcolor">Tick Mark Color</label>
#>             <input id="enrichmentDotPlot-axis.tickcolor" type="text" class="form-control shiny-colour-input" data-init-value="black" data-show-colour="both" data-palette="square"/>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="enrichmentDotPlot-axis.ticklen-label" for="enrichmentDotPlot-axis.ticklen">Tick Mark Length</label>
#>             <input id="enrichmentDotPlot-axis.ticklen" type="number" class="shiny-input-number form-control" value="5" data-update-on="change" min="0" step="1"/>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="enrichmentDotPlot-axis.tickwidth-label" for="enrichmentDotPlot-axis.tickwidth">Tick Mark Width</label>
#>             <input id="enrichmentDotPlot-axis.tickwidth" type="number" class="shiny-input-number form-control" value="1" data-update-on="change" min="0" step="0.1"/>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="enrichmentDotPlot-facet.title.font.size-label" for="enrichmentDotPlot-facet.title.font.size">Facet Subplot Title Size</label>
#>             <input id="enrichmentDotPlot-facet.title.font.size" type="number" class="shiny-input-number form-control" value="18" data-update-on="change" min="1" step="1"/>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour">
#>             <label class="control-label" for="enrichmentDotPlot-facet.title.font.color">Facet Title Color</label>
#>             <input id="enrichmentDotPlot-facet.title.font.color" type="text" class="form-control shiny-colour-input" data-init-value="#000000" data-show-colour="both" data-palette="square"/>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" style="width:100%;">
#>             <label class="control-label" id="enrichmentDotPlot-facet.title.font.family-label" for="enrichmentDotPlot-facet.title.font.family">Facet Title Font</label>
#>             <div id="enrichmentDotPlot-facet.title.font.family" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="change">
#>               <script type="application/json" data-for="enrichmentDotPlot-facet.title.font.family">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["Arial","Balto","Courier New","Droid Sans","Droid Serif","Droid Sans Mono","Gravitas One","Old Standard TT","Open Sans","Overpass","PT Sans Narrow","Raleway","Times New Roman","Verdana","sans-serif","serif","monospace"],"value":["Arial","Balto","Courier New","Droid Sans","Droid Serif","Droid Sans Mono","Gravitas One","Old Standard TT","Open Sans","Overpass","PT Sans Narrow","Raleway","Times New Roman","Verdana","sans-serif","serif","monospace"]}},"config":{"multiple":false,"search":true,"selectedValue":"Arial","hideClearButton":true,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":false,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":true,"disableOptionGroupCheckbox":true,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>             </div>
#>           </div>
#>         </div>
#>       </div>
#>     </div>
#>     <div class="tab-pane" data-value="Lines" id="tab-6690-7">
#>       <div class="vizmodules-input-grid" style="--viz-input-columns: 2;">
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify6779880">
#>             <label class="control-label" id="enrichmentDotPlot-hline.intercepts-label" for="enrichmentDotPlot-hline.intercepts">Y-intercepts</label>
#>             <input id="enrichmentDotPlot-hline.intercepts" type="text" class="shiny-input-text form-control" value="" placeholder="e.g. 2, -2" data-update-on="change"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify6779880', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'For categorical or factor axes, enter the index (position) of the category rather than its name. For example, if the axis categories are &#39;Audi&#39;, &#39;Mercedes&#39;, &#39;Bugatti&#39;, enter 2 to place a line at &#39;Mercedes&#39;.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify6907191">
#>             <label class="control-label" id="enrichmentDotPlot-hline.colors-label" for="enrichmentDotPlot-hline.colors">Y Colors</label>
#>             <input id="enrichmentDotPlot-hline.colors" type="text" class="shiny-input-text form-control" value="#000000" data-update-on="change"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify6907191', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Color(s) for horizontal reference lines, as comma-separated hex codes or color names'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify3734108">
#>             <label class="control-label" id="enrichmentDotPlot-hline.widths-label" for="enrichmentDotPlot-hline.widths">Y Widths</label>
#>             <input id="enrichmentDotPlot-hline.widths" type="text" class="shiny-input-text form-control" value="1" data-update-on="change"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify3734108', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Width(s) for horizontal reference lines in pixels, as comma-separated values'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify979781">
#>             <label class="control-label" id="enrichmentDotPlot-hline.linetypes-label" for="enrichmentDotPlot-hline.linetypes">Y Line Types</label>
#>             <input id="enrichmentDotPlot-hline.linetypes" type="text" class="shiny-input-text form-control" value="dashed" placeholder="solid, dashed, dotted, ..." data-update-on="change"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify979781', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Line style(s) for horizontal reference lines (solid, dashed, dotted, dotdash, longdash, twodash)'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify990097">
#>             <label class="control-label" id="enrichmentDotPlot-hline.opacities-label" for="enrichmentDotPlot-hline.opacities">Y Opacities (0-1)</label>
#>             <input id="enrichmentDotPlot-hline.opacities" type="text" class="shiny-input-text form-control" value="1" data-update-on="change"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify990097', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Opacity of horizontal reference lines between 0 (transparent) and 1 (opaque), as comma-separated values'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify7748016">
#>             <label class="control-label" id="enrichmentDotPlot-vline.intercepts-label" for="enrichmentDotPlot-vline.intercepts">X-intercepts</label>
#>             <input id="enrichmentDotPlot-vline.intercepts" type="text" class="shiny-input-text form-control" value="" placeholder="e.g. 2, -2" data-update-on="change"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify7748016', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'For categorical or factor axes, enter the index (position) of the category rather than its name. For example, if the axis categories are &#39;Audi&#39;, &#39;Mercedes&#39;, &#39;Bugatti&#39;, enter 2 to place a line at &#39;Mercedes&#39;.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify1514956">
#>             <label class="control-label" id="enrichmentDotPlot-vline.colors-label" for="enrichmentDotPlot-vline.colors">X Colors</label>
#>             <input id="enrichmentDotPlot-vline.colors" type="text" class="shiny-input-text form-control" value="#000000" data-update-on="change"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify1514956', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Color(s) for vertical reference lines, as comma-separated hex codes or color names'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify3946066">
#>             <label class="control-label" id="enrichmentDotPlot-vline.widths-label" for="enrichmentDotPlot-vline.widths">X Widths</label>
#>             <input id="enrichmentDotPlot-vline.widths" type="text" class="shiny-input-text form-control" value="1" data-update-on="change"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify3946066', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Width(s) for vertical reference lines in pixels, as comma-separated values'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify9349984">
#>             <label class="control-label" id="enrichmentDotPlot-vline.linetypes-label" for="enrichmentDotPlot-vline.linetypes">X Line Types</label>
#>             <input id="enrichmentDotPlot-vline.linetypes" type="text" class="shiny-input-text form-control" value="dashed" placeholder="solid, dashed, dotted, ..." data-update-on="change"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify9349984', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Line style(s) for vertical reference lines (solid, dashed, dotted, dotdash, longdash, twodash)'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify7395895">
#>             <label class="control-label" id="enrichmentDotPlot-vline.opacities-label" for="enrichmentDotPlot-vline.opacities">X Opacities (0-1)</label>
#>             <input id="enrichmentDotPlot-vline.opacities" type="text" class="shiny-input-text form-control" value="1" data-update-on="change"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify7395895', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Opacity of vertical reference lines between 0 (transparent) and 1 (opaque), as comma-separated values'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify6356681">
#>             <label class="control-label" id="enrichmentDotPlot-abline.slopes-label" for="enrichmentDotPlot-abline.slopes">Ab Slopes</label>
#>             <input id="enrichmentDotPlot-abline.slopes" type="text" class="shiny-input-text form-control" value="" data-update-on="change"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify6356681', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Slope(s) of diagonal reference lines (rise/run), as comma-separated values'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify3382199">
#>             <label class="control-label" id="enrichmentDotPlot-abline.intercepts-label" for="enrichmentDotPlot-abline.intercepts">Ab Y-intercepts</label>
#>             <input id="enrichmentDotPlot-abline.intercepts" type="text" class="shiny-input-text form-control" value="" data-update-on="change"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify3382199', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'For categorical or factor axes, enter the index (position) of the category rather than its name. For example, if the axis categories are &#39;Audi&#39;, &#39;Mercedes&#39;, &#39;Bugatti&#39;, enter 2 to place a line at &#39;Mercedes&#39;.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify9624163">
#>             <label class="control-label" id="enrichmentDotPlot-abline.colors-label" for="enrichmentDotPlot-abline.colors">Ab Colors</label>
#>             <input id="enrichmentDotPlot-abline.colors" type="text" class="shiny-input-text form-control" value="#000000" data-update-on="change"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify9624163', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Color(s) for diagonal reference lines, as comma-separated hex codes or color names'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify1117899">
#>             <label class="control-label" id="enrichmentDotPlot-abline.widths-label" for="enrichmentDotPlot-abline.widths">Ab Widths</label>
#>             <input id="enrichmentDotPlot-abline.widths" type="text" class="shiny-input-text form-control" value="1" data-update-on="change"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify1117899', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Width(s) for diagonal reference lines in pixels, as comma-separated values'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify6504853">
#>             <label class="control-label" id="enrichmentDotPlot-abline.linetypes-label" for="enrichmentDotPlot-abline.linetypes">Ab Line Types</label>
#>             <input id="enrichmentDotPlot-abline.linetypes" type="text" class="shiny-input-text form-control" value="dashed" placeholder="solid, dashed, dotted, ..." data-update-on="change"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify6504853', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Line style(s) for diagonal reference lines (solid, dashed, dotted, dotdash, longdash, twodash)'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify9835115">
#>             <label class="control-label" id="enrichmentDotPlot-abline.opacities-label" for="enrichmentDotPlot-abline.opacities">Ab Opacities (0-1)</label>
#>             <input id="enrichmentDotPlot-abline.opacities" type="text" class="shiny-input-text form-control" value="1" data-update-on="change"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify9835115', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Opacity of diagonal reference lines between 0 (transparent) and 1 (opaque), as comma-separated values'})}, 500)});</script>
#>         </div>
#>       </div>
#>     </div>
#>   </div>
#> </div>
#> <div class="module-tack" style="margin-top: 12px;">
#>   <div class="module-tack-switch" style="margin-bottom: 4px;">
#>     <div class="form-group shiny-input-container">
#>       <div class="material-switch">
#>         <label for="enrichmentDotPlot-auto.update" style="padding-right: 10px;">Auto Update</label>
#>         <input id="enrichmentDotPlot-auto.update" type="checkbox" checked="checked"/>
#>         <label class="switch label-success bg-success" for="enrichmentDotPlot-auto.update"></label>
#>       </div>
#>     </div>
#>   </div>
#>   <div class="module-tack-buttons" style="display: flex; flex-wrap: wrap; gap: 8px;">
#>     <button class="btn btn-default action-button btn-primary" id="enrichmentDotPlot-update" style="flex: 1 1 45%;" type="button"><span class="action-label">Update</span></button>
#>     <button class="btn btn-default action-button btn-secondary" id="enrichmentDotPlot-reset" style="flex: 1 1 45%;" type="button"><span class="action-label">Reset</span></button>
#>     <a aria-disabled="true" class="btn btn-default shiny-download-link disabled btn-secondary viz-source-download" data-viz-source-ns="enrichmentDotPlot-" download href="" id="enrichmentDotPlot-download.source" style="flex: 1 1 100%;" tabindex="-1" target="_blank">
#>       <i class="far fa-file-code" role="presentation" aria-label="file-code icon"></i>
#>       Source Download
#>     </a>
#>     <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('enrichmentDotPlot-download.source', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Download the plot as a self-contained HTML file and as SVG and PNG images of it as it looks now, along with the plot source data and statistics (if applicable) as CSV files.'})}, 500)});</script>
#>   </div>
#> </div>
```
