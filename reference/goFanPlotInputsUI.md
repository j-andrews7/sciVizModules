# Input UI components for the goFanPlot module

This should be placed in the UI where the inputs should be shown, with
an `id` that matches the `id` used in the
[`goFanPlotServer()`](https://j-andrews7.github.io/sciVizModules/reference/goFanPlotServer.md)
and
[`goFanPlotOutputUI()`](https://j-andrews7.github.io/sciVizModules/reference/goFanPlotOutputUI.md)
functions.

## Usage

``` r
goFanPlotInputsUI(
  id,
  data,
  defaults = NULL,
  title = "GO Sunburst Settings",
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
[`GOfan::sunburstGO()`](https://rdrr.io/pkg/GOfan/man/sunburstGO.html)
to draw a Gene Ontology (GO) enrichment **sunburst** ("fan") plot: the
GO directed acyclic graph is converted into a circular layout where each
ring is a hierarchy level and each segment is a GO term. The figure is
rendered with `plotBy = "plotly"` so it is interactive (hover to read
labels, click a segment to zoom into its offspring).

The input data are inspected to pick sensible defaults: the GO-ID
column, the ontology category (from a `ONTOLOGY` column when present), a
numeric fill column (preferring `qvalue`), and an optional proportional
sub-rectangle column (preferring `Count`).

## Plot parameters and defaults

The following parameters can be accessed via UI inputs and/or the
`defaults` argument:

- `term.id` - GO identifier column (auto-detected)

- `onto` - GO ontology category: BP, CC, or MF (auto-detected)

- `org` - Organism annotation package (e.g. `org.Hs.eg.db`)

- `fill` - Numeric column mapped to segment colour (default `qvalue`)

- `sub_rect` - Optional numeric column drawn as a proportional
  sub-rectangle (default: none)

- `go.annotation.level.cutoff` - GO annotation level cutoff (default 4)

- `filter.nodes.by.edge.number` - Filter sub-graphs by edge number
  (default 2)

- `fill.na.by.0` - Fill missing colour values with 0 (default TRUE)

## See also

[`GOfan::sunburstGO()`](https://rdrr.io/pkg/GOfan/man/sunburstGO.html),
[`VizModules::organize_inputs()`](https://j-andrews7.github.io/VizModules/reference/organize_inputs.html),
[`goFanPlotOutputUI()`](https://j-andrews7.github.io/sciVizModules/reference/goFanPlotOutputUI.md),
[`goFanPlotServer()`](https://j-andrews7.github.io/sciVizModules/reference/goFanPlotServer.md),
[`goFanPlotApp()`](https://j-andrews7.github.io/sciVizModules/reference/goFanPlotApp.md)

## Author

Jacob Martin, Jared Andrews

## Examples

``` r
library(sciVizModules)
data(example_enrichment)
goFanPlotInputsUI("goFanPlot", example_enrichment)
#> <h3>GO Sunburst Settings</h3>
#> <div class="tabbable vizmodules-input-tabs">
#>   <ul class="nav nav-tabs shiny-tab-input" id="goFanPlot-goFanPlotTabsetPanel" data-tabsetid="2274">
#>     <li class="active">
#>       <a href="#tab-2274-1" data-toggle="tab" data-bs-toggle="tab" data-value="Data">Data</a>
#>     </li>
#>     <li>
#>       <a href="#tab-2274-2" data-toggle="tab" data-bs-toggle="tab" data-value="Filtering">Filtering</a>
#>     </li>
#>     <li>
#>       <a href="#tab-2274-3" data-toggle="tab" data-bs-toggle="tab" data-value="Plotly">Plotly</a>
#>     </li>
#>   </ul>
#>   <div class="tab-content" data-tabsetid="2274">
#>     <div class="tab-pane active" data-value="Data" id="tab-2274-1">
#>       <div class="vizmodules-input-grid" style="--viz-input-columns: 2;">
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" style="width:100%;" id="tipify1947595">
#>             <label class="control-label" id="goFanPlot-term.id-label" for="goFanPlot-term.id">GO ID Column</label>
#>             <div id="goFanPlot-term.id" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="change">
#>               <script type="application/json" data-for="goFanPlot-term.id">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["Cluster","ONTOLOGY","ID","Description","GeneRatio","BgRatio"],"value":["Cluster","ONTOLOGY","ID","Description","GeneRatio","BgRatio"]}},"config":{"multiple":false,"search":false,"selectedValue":"ID","hideClearButton":true,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":false,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":true,"disableOptionGroupCheckbox":true,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify1947595', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Column holding the GO identifiers (e.g. GO:0006955).'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" style="width:100%;" id="tipify7821541">
#>             <label class="control-label" id="goFanPlot-onto-label" for="goFanPlot-onto">Ontology</label>
#>             <div id="goFanPlot-onto" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="change">
#>               <script type="application/json" data-for="goFanPlot-onto">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["Biological Process","Cellular Component","Molecular Function"],"value":["BP","CC","MF"]}},"config":{"multiple":false,"search":false,"selectedValue":"BP","hideClearButton":true,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":false,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":true,"disableOptionGroupCheckbox":true,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify7821541', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'GO ontology category of the supplied IDs.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" style="width:100%;" id="tipify150323">
#>             <label class="control-label" id="goFanPlot-org-label" for="goFanPlot-org">Organism</label>
#>             <div id="goFanPlot-org" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="change">
#>               <script type="application/json" data-for="goFanPlot-org">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["Human (org.Hs.eg.db)","Mouse (org.Mm.eg.db)","Rat (org.Rn.eg.db)","Zebrafish (org.Dr.eg.db)","Fly (org.Dm.eg.db)","Worm (org.Ce.eg.db)","Yeast (org.Sc.sgd.db)"],"value":["org.Hs.eg.db","org.Mm.eg.db","org.Rn.eg.db","org.Dr.eg.db","org.Dm.eg.db","org.Ce.eg.db","org.Sc.sgd.db"]}},"config":{"multiple":false,"search":false,"selectedValue":"org.Hs.eg.db","hideClearButton":true,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":false,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":true,"disableOptionGroupCheckbox":true,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify150323', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Organism annotation package used to resolve the GO hierarchy. The corresponding OrgDb package must be installed.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" style="width:100%;" id="tipify9341725">
#>             <label class="control-label" id="goFanPlot-fill-label" for="goFanPlot-fill">Colour By</label>
#>             <div id="goFanPlot-fill" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="change">
#>               <script type="application/json" data-for="goFanPlot-fill">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["pvalue","p.adjust","qvalue","Count"],"value":["pvalue","p.adjust","qvalue","Count"]}},"config":{"multiple":false,"search":false,"selectedValue":"qvalue","hideClearButton":true,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":false,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":true,"disableOptionGroupCheckbox":true,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify9341725', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Numeric column mapped onto the segment fill colour (e.g. qvalue).'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" style="width:100%;" id="tipify844362">
#>             <label class="control-label" id="goFanPlot-palette-label" for="goFanPlot-palette">Palette</label>
#>             <div id="goFanPlot-palette" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="change">
#>               <script type="application/json" data-for="goFanPlot-palette">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["Viridis","Cividis","Blues","Greens","Reds","YlOrRd","YlGnBu","Hot","Blackbody","Electric","Jet","Portland","Picnic (diverging)","RdBu (diverging)","Earth (diverging)"],"value":["Viridis","Cividis","Blues","Greens","Reds","YlOrRd","YlGnBu","Hot","Blackbody","Electric","Jet","Portland","Picnic","RdBu","Earth"]}},"config":{"multiple":false,"search":true,"selectedValue":"Viridis","hideClearButton":true,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":false,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":true,"disableOptionGroupCheckbox":true,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify844362', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Colour palette used to map the &#39;Colour By&#39; column onto the segments.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" style="width:100%;" id="tipify340523">
#>             <label class="control-label" id="goFanPlot-sub_rect-label" for="goFanPlot-sub_rect">Sub-rectangle (area)</label>
#>             <div id="goFanPlot-sub_rect" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="change">
#>               <script type="application/json" data-for="goFanPlot-sub_rect">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["(none)","pvalue","p.adjust","qvalue","Count"],"value":["","pvalue","p.adjust","qvalue","Count"]}},"config":{"multiple":false,"search":false,"selectedValue":"","hideClearButton":true,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":false,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":true,"disableOptionGroupCheckbox":true,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify340523', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Optional numeric column drawn as a proportional sub-rectangle inside each segment (a count is converted to a proportion).'})}, 500)});</script>
#>         </div>
#>       </div>
#>     </div>
#>     <div class="tab-pane" data-value="Filtering" id="tab-2274-2">
#>       <div class="vizmodules-input-grid" style="--viz-input-columns: 2;">
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify3109595">
#>             <label class="control-label" id="goFanPlot-go.annotation.level.cutoff-label" for="goFanPlot-go.annotation.level.cutoff">GO Level Cutoff</label>
#>             <input id="goFanPlot-go.annotation.level.cutoff" type="number" class="shiny-input-number form-control" value="4" data-update-on="change" min="1" step="1"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify3109595', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Cutoff of the GO annotation levels to display.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify7847097">
#>             <label class="control-label" id="goFanPlot-filter.nodes.by.edge.number-label" for="goFanPlot-filter.nodes.by.edge.number">Min Edges per Sub-graph</label>
#>             <input id="goFanPlot-filter.nodes.by.edge.number" type="number" class="shiny-input-number form-control" value="2" data-update-on="change" min="0" step="1"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify7847097', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Filter the sub-graphs by their edge number.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify2804006">
#>             <div class="material-switch">
#>               <label for="goFanPlot-fill.na.by.0" style="padding-right: 10px;">Fill NA colours with 0</label>
#>               <input id="goFanPlot-fill.na.by.0" type="checkbox" checked="checked"/>
#>               <label class="switch label-success bg-success" for="goFanPlot-fill.na.by.0"></label>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify2804006', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Replace missing values in the colour column with 0.'})}, 500)});</script>
#>         </div>
#>       </div>
#>     </div>
#>     <div class="tab-pane" data-value="Plotly" id="tab-2274-3">
#>       <div class="vizmodules-input-grid" style="--viz-input-columns: 2;">
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" style="width:100%;">
#>             <label class="control-label" id="goFanPlot-download.format-label" for="goFanPlot-download.format">Download Format</label>
#>             <div id="goFanPlot-download.format" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="change">
#>               <script type="application/json" data-for="goFanPlot-download.format">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["svg","png","jpeg","webp"],"value":["svg","png","jpeg","webp"]}},"config":{"multiple":false,"search":false,"selectedValue":"svg","hideClearButton":true,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":false,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":true,"disableOptionGroupCheckbox":true,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>             </div>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify1652838">
#>             <label class="control-label" id="goFanPlot-margin.t-label" for="goFanPlot-margin.t">Margin Top</label>
#>             <input id="goFanPlot-margin.t" type="number" class="shiny-input-number form-control" value="70" data-update-on="change" min="0" step="5"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify1652838', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Top margin of the plot in pixels'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify4335948">
#>             <label class="control-label" id="goFanPlot-margin.b-label" for="goFanPlot-margin.b">Margin Bottom</label>
#>             <input id="goFanPlot-margin.b" type="number" class="shiny-input-number form-control" value="70" data-update-on="change" min="0" step="5"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify4335948', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Bottom margin of the plot in pixels'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify8140452">
#>             <label class="control-label" id="goFanPlot-margin.l-label" for="goFanPlot-margin.l">Margin Left</label>
#>             <input id="goFanPlot-margin.l" type="number" class="shiny-input-number form-control" value="70" data-update-on="change" min="0" step="5"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify8140452', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Left margin of the plot in pixels'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify6865140">
#>             <label class="control-label" id="goFanPlot-margin.r-label" for="goFanPlot-margin.r">Margin Right</label>
#>             <input id="goFanPlot-margin.r" type="number" class="shiny-input-number form-control" value="90" data-update-on="change" min="0" step="5"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify6865140', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Right margin of the plot in pixels'})}, 500)});</script>
#>         </div>
#>       </div>
#>     </div>
#>   </div>
#> </div>
#> <div class="module-tack" style="margin-top: 12px;">
#>   <div class="module-tack-switch" style="margin-bottom: 4px;">
#>     <div class="form-group shiny-input-container">
#>       <div class="material-switch">
#>         <label for="goFanPlot-auto.update" style="padding-right: 10px;">Auto Update</label>
#>         <input id="goFanPlot-auto.update" type="checkbox" checked="checked"/>
#>         <label class="switch label-success bg-success" for="goFanPlot-auto.update"></label>
#>       </div>
#>     </div>
#>   </div>
#>   <div class="module-tack-buttons" style="display: flex; flex-wrap: wrap; gap: 8px;">
#>     <button class="btn btn-default action-button btn-primary" id="goFanPlot-update" style="flex: 1 1 45%;" type="button"><span class="action-label">Update</span></button>
#>     <button class="btn btn-default action-button btn-secondary" id="goFanPlot-reset" style="flex: 1 1 45%;" type="button"><span class="action-label">Reset</span></button>
#>     <a aria-disabled="true" class="btn btn-default shiny-download-link disabled btn-secondary viz-source-download" data-viz-source-ns="goFanPlot-" download href="" id="goFanPlot-download.source" style="flex: 1 1 100%;" tabindex="-1" target="_blank">
#>       <i class="far fa-file-code" role="presentation" aria-label="file-code icon"></i>
#>       Source Download
#>     </a>
#>     <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('goFanPlot-download.source', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Download the plot as a self-contained HTML file and as SVG and PNG images of it as it looks now, along with the plot source data and statistics (if applicable) as CSV files.'})}, 500)});</script>
#>   </div>
#> </div>
```
