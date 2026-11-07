# Input UI components for the methylationTrack module

This should be placed in the UI where the inputs should be shown, with
an `id` that matches the `id` used in the
[`methylationTrackServer()`](https://j-andrews7.github.io/sciVizModules/reference/methylationTrackServer.md)
and
[`methylationTrackOutputUI()`](https://j-andrews7.github.io/sciVizModules/reference/methylationTrackOutputUI.md)
functions.

## Usage

``` r
methylationTrackInputsUI(
  id,
  data,
  defaults = NULL,
  title = "Methylation Track Settings",
  columns = 2
)
```

## Arguments

- id:

  The ID for the Shiny module.

- data:

  A
  [`methylationCohort()`](https://j-andrews7.github.io/sciVizModules/reference/methylationCohort.md),
  or anything it takes.

- defaults:

  A named list of default values for the inputs.

- title:

  An optional title for the UI grid.

- columns:

  Number of columns for the UI grid.

## Value

A Shiny tagList containing the UI elements

## Details

The module draws
[`methylationTrack()`](https://j-andrews7.github.io/sciVizModules/reference/methylationTrack.md):
a heatmap of beta values, with samples as rows and CpGs as columns,
under the transcripts of a gene, region or set of probes. Its data is a
[`methylationCohort()`](https://j-andrews7.github.io/sciVizModules/reference/methylationCohort.md),
or anything that takes, which can mix Infinium arrays. Arrays are joined
on genomic position, and a CpG not on a sample's array has a colour of
its own. The inputs are organised into tabs via
[`VizModules::organize_inputs()`](https://j-andrews7.github.io/VizModules/reference/organize_inputs.html).

Choices in the Samples tab need no redraw to change the colours, and a
change of colour scale reaches the browser as a layout-only update.

## Plot parameters and defaults

The following parameters can be accessed via UI inputs and/or the
`defaults` argument:

**Data**

- `locate.by` - Look up a `"gene"`, `"region"` or `"probes"` (default:
  `"gene"`)

- `gene` - The gene (default: none)

- `region` - The region, as `chr19:10260000-10380000` (default: none)

- `probes` - Probe IDs, separated by commas or spaces, from one
  chromosome (default: none)

- `upstream`, `downstream` - Bases added around a gene or probes
  (default: 2000)

- `cpg.scope` - `"all"` CpGs on any plotted array, or those `"shared"`
  by all of them (default: `"all"`)

- `max.cpgs` - The most CpGs to draw (default: 1000)

**Samples**

- `filter.col`, `filter.levels` - Keep samples with these levels of a
  column (default: all)

- `sample.filter` - Keep samples meeting a condition, such as `age > 40`
  (default: all)

- `group.by` - Group samples on a column (default: `"platform"` for
  several arrays)

- `group.gap` - Blank rows between groups (default: 1)

- `cluster.samples` - Cluster samples, within any groups (default:
  FALSE)

- `dist.method` - Distance: `"euclidean"`, `"manhattan"`, `"pearson"` or
  `"spearman"` (default: `"euclidean"`)

- `hclust.method` - Linkage, as
  [`stats::hclust()`](https://rdrr.io/r/stats/hclust.html) (default:
  `"ward.D2"`)

- `show.dendrogram` - Draw the clustering (default: TRUE)

- `anno.left`, `anno.right` - Columns drawn as strips each side of the
  heatmap (default: none)

- `anno.colors` - Named colours of their levels, as `"column: level"`
  (multiColorPicker; default: a colour for each level in the cohort)

- `anno.low`, `anno.high` - Colours of a numeric strip (default:
  "#DEEBF7" and "#08306B")

- `show.sample.names` - Label the samples (default: TRUE)

- `sample.font.size` - Size of those labels (default: 10)

**Tracks**

- `txn.view` - `"full"`, a row per transcript, or `"collapsed"`, a row
  per gene with its transcripts overlaid (default: `"full"`)

- `txn.types` - Transcript types to draw (default: `"protein_coding"`)

- `txn.labels` - Label the transcripts (default: TRUE)

- `txn.font.size` - Size of those labels (default: 8)

- `exon.color`, `cds.color`, `intron.color` - Transcript colours
  (default: "#1A1A1A", "#D7191C" and "#444444")

- `show.cytoband` - Draw the ideogram (default: TRUE)

- `show.map.lines` - Draw the lines from position to column (default:
  TRUE)

- `show.coverage` - Draw which array has which CpG (default: TRUE)

- `cpg.tracks` - `rowData()` columns drawn as strips under the heatmap
  (default: none)

- `cpg.labels` - Label columns with `"none"`, `"probe"` or `"locus"`
  (default: `"none"`)

**Aesthetics**

- The colour scale inputs of
  [`VizModules::uniform_colorscale_inputs_ui()`](https://j-andrews7.github.io/VizModules/reference/uniform_colorscale_inputs_ui.html),
  from 0 to 1 and titled "Beta value" by default

- `absent.color` - Colour of a cell whose array lacks the CpG (default:
  "#BDBDBD")

- `na.color` - Colour of a cell with no value on an array that has the
  CpG (default: "#FFFFFF")

The Legend, Axes and Plotly tabs carry the shared VizModules inputs.
Only the sample and column labels follow the Axes tab, with its axis
lines boxing the heatmap, and gridlines are not offered, as they would
run across cells. There is no Lines tab.

## See also

[`methylationTrack()`](https://j-andrews7.github.io/sciVizModules/reference/methylationTrack.md),
[`methylationCohort()`](https://j-andrews7.github.io/sciVizModules/reference/methylationCohort.md),
[`methylationTrackOutputUI()`](https://j-andrews7.github.io/sciVizModules/reference/methylationTrackOutputUI.md),
[`methylationTrackServer()`](https://j-andrews7.github.io/sciVizModules/reference/methylationTrackServer.md),
[`methylationTrackApp()`](https://j-andrews7.github.io/sciVizModules/reference/methylationTrackApp.md)

## Author

Jared Andrews

## Examples

``` r
library(sciVizModules)
data(example_methylation)
methylationTrackInputsUI("track", example_methylation)
#> <h3>Methylation Track Settings</h3>
#> <div class="tabbable vizmodules-input-tabs">
#>   <ul class="nav nav-tabs shiny-tab-input" id="track-methylationTrackTabsetPanel" data-tabsetid="8723">
#>     <li class="active">
#>       <a href="#tab-8723-1" data-toggle="tab" data-bs-toggle="tab" data-value="Data">Data</a>
#>     </li>
#>     <li>
#>       <a href="#tab-8723-2" data-toggle="tab" data-bs-toggle="tab" data-value="Samples">Samples</a>
#>     </li>
#>     <li>
#>       <a href="#tab-8723-3" data-toggle="tab" data-bs-toggle="tab" data-value="Tracks">Tracks</a>
#>     </li>
#>     <li>
#>       <a href="#tab-8723-4" data-toggle="tab" data-bs-toggle="tab" data-value="Aesthetics">Aesthetics</a>
#>     </li>
#>     <li>
#>       <a href="#tab-8723-5" data-toggle="tab" data-bs-toggle="tab" data-value="Legend">Legend</a>
#>     </li>
#>     <li>
#>       <a href="#tab-8723-6" data-toggle="tab" data-bs-toggle="tab" data-value="Axes">Axes</a>
#>     </li>
#>     <li>
#>       <a href="#tab-8723-7" data-toggle="tab" data-bs-toggle="tab" data-value="Plotly">Plotly</a>
#>     </li>
#>   </ul>
#>   <div class="tab-content" data-tabsetid="8723">
#>     <div class="tab-pane active" data-value="Data" id="tab-8723-1">
#>       <div class="vizmodules-input-grid" style="--viz-input-columns: 2;">
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" style="width:100%;" id="tipify9884855">
#>             <label class="control-label" id="track-locate.by-label" for="track-locate.by">Look Up</label>
#>             <div id="track-locate.by" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="change">
#>               <script type="application/json" data-for="track-locate.by">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["Gene","Region","Probes"],"value":["gene","region","probes"]}},"config":{"multiple":false,"search":false,"selectedValue":"gene","hideClearButton":true,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":false,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":true,"disableOptionGroupCheckbox":true,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify9884855', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'What to plot: a gene, a region, or the region around some probes.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" style="width:100%;" id="tipify2822755">
#>             <label class="control-label" id="track-gene-label" for="track-gene">Gene</label>
#>             <div id="track-gene" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="change">
#>               <script type="application/json" data-for="track-gene">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["(none)","AC060780.1","AC060780.2","AC135721.1","AC135721.2","ADA","AL109840.2","AL121917.1","AL121917.2","AL132655.1","AL132655.4","AL132655.5","AL132655.6","AL132655.7","AL139352.1","ATP1B2","BRCA1","BRCA1P1","DNMT1","EPM2AIP1","GNAS","GNAS-AS1","LINC01260","LRRFIP2","MIR4322","MLH1","NBR1","NBR2","PKIG","RPL21P4","RPL29P11","S1PR2","TP53","WRAP53"],"value":["","AC060780.1","AC060780.2","AC135721.1","AC135721.2","ADA","AL109840.2","AL121917.1","AL121917.2","AL132655.1","AL132655.4","AL132655.5","AL132655.6","AL132655.7","AL139352.1","ATP1B2","BRCA1","BRCA1P1","DNMT1","EPM2AIP1","GNAS","GNAS-AS1","LINC01260","LRRFIP2","MIR4322","MLH1","NBR1","NBR2","PKIG","RPL21P4","RPL29P11","S1PR2","TP53","WRAP53"]}},"config":{"multiple":false,"search":true,"selectedValue":"","hideClearButton":true,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":false,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":true,"disableOptionGroupCheckbox":true,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify2822755', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'All of the gene&#39;s transcripts are spanned, plus the bases set below.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify5541124">
#>             <label class="control-label" id="track-region-label" for="track-region">Region</label>
#>             <input id="track-region" type="text" class="shiny-input-text form-control" value="" placeholder="chr19:10260000-10380000" data-update-on="change"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify5541124', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'A chromosome, start and end.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="shiny-input-textarea form-group shiny-input-container" id="tipify8900840">
#>             <label class="control-label" id="track-probes-label" for="track-probes">Probes</label>
#>             <textarea id="track-probes" class="form-control" placeholder="cg02382400, cg03738669" rows="2" data-update-on="change"></textarea>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify8900840', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Probe IDs on one chromosome, on any of the arrays. The plot covers the region around them.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify228021">
#>             <label class="control-label" id="track-upstream-label" for="track-upstream">Upstream (bp)</label>
#>             <input id="track-upstream" type="number" class="shiny-input-number form-control" value="2000" data-update-on="change" min="0" step="500"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify228021', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Bases added before a gene, following its strand, or before the probes.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify6776884">
#>             <label class="control-label" id="track-downstream-label" for="track-downstream">Downstream (bp)</label>
#>             <input id="track-downstream" type="number" class="shiny-input-number form-control" value="2000" data-update-on="change" min="0" step="500"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify6776884', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Bases added after a gene, following its strand, or after the probes.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" style="width:100%;" id="tipify3370598">
#>             <label class="control-label" id="track-cpg.scope-label" for="track-cpg.scope">CpGs</label>
#>             <div id="track-cpg.scope" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="change">
#>               <script type="application/json" data-for="track-cpg.scope">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["All, on any array","Shared by all arrays"],"value":["all","shared"]}},"config":{"multiple":false,"search":false,"selectedValue":"all","hideClearButton":true,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":false,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":true,"disableOptionGroupCheckbox":true,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify3370598', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Every CpG on any plotted array, or only those on all of them. Nothing is imputed.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify1411961">
#>             <label class="control-label" id="track-max.cpgs-label" for="track-max.cpgs">Max CpGs</label>
#>             <input id="track-max.cpgs" type="number" class="shiny-input-number form-control" value="1000" data-update-on="change" min="1" step="100"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify1411961', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'The most CpGs to draw. Larger regions ask to be shrunk.'})}, 500)});</script>
#>         </div>
#>       </div>
#>     </div>
#>     <div class="tab-pane" data-value="Samples" id="tab-8723-2">
#>       <div class="vizmodules-input-grid" style="--viz-input-columns: 2;">
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" style="width:100%;" id="tipify3525640">
#>             <label class="control-label" id="track-filter.col-label" for="track-filter.col">Filter By</label>
#>             <div id="track-filter.col" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="change">
#>               <script type="application/json" data-for="track-filter.col">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["(none)","platform","cell.type","category"],"value":["","platform","cell.type","category"]}},"config":{"multiple":false,"search":false,"selectedValue":"","hideClearButton":true,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":false,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":true,"disableOptionGroupCheckbox":true,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify3525640', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'A sample information column to choose samples on.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" style="width:100%;" id="tipify4014449">
#>             <label class="control-label" id="track-filter.levels-label" for="track-filter.levels">Keep Levels</label>
#>             <div id="track-filter.levels" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="close">
#>               <script type="application/json" data-for="track-filter.levels">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":[],"value":[]}},"config":{"multiple":true,"search":false,"selectedValue":[],"hideClearButton":false,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":true,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":false,"disableOptionGroupCheckbox":false,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify4014449', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'The levels of that column to keep. None selected keeps every sample.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify8889143">
#>             <label class="control-label" id="track-sample.filter-label" for="track-sample.filter">Sample Filter</label>
#>             <input id="track-sample.filter" type="text" class="shiny-input-text form-control" value="" placeholder="age &gt; 40" data-update-on="change"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify8889143', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'A condition on the sample information columns, applied as well as Filter By.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div id="track-sample.status" class="shiny-text-output"></div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" style="width:100%;" id="tipify3126142">
#>             <label class="control-label" id="track-group.by-label" for="track-group.by">Group By</label>
#>             <div id="track-group.by" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="change">
#>               <script type="application/json" data-for="track-group.by">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["(none)","platform","cell.type","category"],"value":["","platform","cell.type","category"]}},"config":{"multiple":false,"search":false,"selectedValue":"platform","hideClearButton":true,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":false,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":true,"disableOptionGroupCheckbox":true,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify3126142', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Gather samples into groups, set apart by a gap. Clustering then runs within each group.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify616548">
#>             <label class="control-label" id="track-group.gap-label" for="track-group.gap">Group Gap</label>
#>             <input id="track-group.gap" type="number" class="shiny-input-number form-control" value="1" data-update-on="change" min="0" step="1"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify616548', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Blank rows between groups.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify6794862">
#>             <div class="material-switch">
#>               <label for="track-cluster.samples" style="padding-right: 10px;">Cluster Samples</label>
#>               <input id="track-cluster.samples" type="checkbox"/>
#>               <label class="switch label-success bg-success" for="track-cluster.samples"></label>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify6794862', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Hierarchical clustering on the CpGs measured in all of the samples being clustered.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" style="width:100%;" id="tipify3781626">
#>             <label class="control-label" id="track-dist.method-label" for="track-dist.method">Distance</label>
#>             <div id="track-dist.method" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="change">
#>               <script type="application/json" data-for="track-dist.method">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["Euclidean","Manhattan","1 - Pearson","1 - Spearman"],"value":["euclidean","manhattan","pearson","spearman"]}},"config":{"multiple":false,"search":false,"selectedValue":"euclidean","hideClearButton":true,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":false,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":true,"disableOptionGroupCheckbox":true,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify3781626', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'How samples are compared.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" style="width:100%;" id="tipify5883703">
#>             <label class="control-label" id="track-hclust.method-label" for="track-hclust.method">Linkage</label>
#>             <div id="track-hclust.method" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="change">
#>               <script type="application/json" data-for="track-hclust.method">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["Ward (ward.D2)","Average","Complete","Single","McQuitty"],"value":["ward.D2","average","complete","single","mcquitty"]}},"config":{"multiple":false,"search":false,"selectedValue":"ward.D2","hideClearButton":true,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":false,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":true,"disableOptionGroupCheckbox":true,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify5883703', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'How clusters are joined.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify4919785">
#>             <div class="material-switch">
#>               <label for="track-show.dendrogram" style="padding-right: 10px;">Dendrogram</label>
#>               <input id="track-show.dendrogram" type="checkbox" checked="checked"/>
#>               <label class="switch label-success bg-success" for="track-show.dendrogram"></label>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify4919785', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Draw the clustering beside the heatmap.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" style="width:100%;" id="tipify2857770">
#>             <label class="control-label" id="track-anno.left-label" for="track-anno.left">Left Annotations</label>
#>             <div id="track-anno.left" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="close">
#>               <script type="application/json" data-for="track-anno.left">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["platform","cell.type","category","global.beta"],"value":["platform","cell.type","category","global.beta"]}},"config":{"multiple":true,"search":false,"selectedValue":[],"hideClearButton":false,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":true,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":false,"disableOptionGroupCheckbox":false,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify2857770', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Sample information to draw as strips left of the heatmap.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" style="width:100%;" id="tipify84196">
#>             <label class="control-label" id="track-anno.right-label" for="track-anno.right">Right Annotations</label>
#>             <div id="track-anno.right" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="close">
#>               <script type="application/json" data-for="track-anno.right">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["platform","cell.type","category","global.beta"],"value":["platform","cell.type","category","global.beta"]}},"config":{"multiple":true,"search":false,"selectedValue":[],"hideClearButton":false,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":true,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":false,"disableOptionGroupCheckbox":false,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify84196', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Sample information to draw as strips right of the heatmap.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div id="track-palette.selection" class="shiny-html-output"></div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour" id="tipify5507743">
#>             <label class="control-label" for="track-anno.low">Numeric Low</label>
#>             <input id="track-anno.low" type="text" class="form-control shiny-colour-input" data-init-value="#DEEBF7" data-show-colour="both" data-palette="square"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify5507743', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Lowest colour of a numeric strip.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour" id="tipify8132309">
#>             <label class="control-label" for="track-anno.high">Numeric High</label>
#>             <input id="track-anno.high" type="text" class="form-control shiny-colour-input" data-init-value="#08306B" data-show-colour="both" data-palette="square"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify8132309', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Highest colour of a numeric strip.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify6435746">
#>             <div class="material-switch">
#>               <label for="track-show.sample.names" style="padding-right: 10px;">Sample Names</label>
#>               <input id="track-show.sample.names" type="checkbox" checked="checked"/>
#>               <label class="switch label-success bg-success" for="track-show.sample.names"></label>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify6435746', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Label the samples.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify690620">
#>             <label class="control-label" id="track-sample.font.size-label" for="track-sample.font.size">Sample Font Size</label>
#>             <input id="track-sample.font.size" type="number" class="shiny-input-number form-control" value="10" data-update-on="change" min="1" step="1"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify690620', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Size of the sample labels.'})}, 500)});</script>
#>         </div>
#>       </div>
#>     </div>
#>     <div class="tab-pane" data-value="Tracks" id="tab-8723-3">
#>       <div class="vizmodules-input-grid" style="--viz-input-columns: 2;">
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" style="width:100%;" id="tipify7287162">
#>             <label class="control-label" id="track-txn.view-label" for="track-txn.view">Transcripts</label>
#>             <div id="track-txn.view" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="change">
#>               <script type="application/json" data-for="track-txn.view">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["Full","Collapsed"],"value":["full","collapsed"]}},"config":{"multiple":false,"search":false,"selectedValue":"full","hideClearButton":true,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":false,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":true,"disableOptionGroupCheckbox":true,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify7287162', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'A row per transcript, or a row per gene with its transcripts overlaid, as in IGV.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" style="width:100%;" id="tipify6721112">
#>             <label class="control-label" id="track-txn.types-label" for="track-txn.types">Transcript Types</label>
#>             <div id="track-txn.types" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="close">
#>               <script type="application/json" data-for="track-txn.types">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["lncRNA","miRNA","misc_RNA","non_stop_decay","nonsense_mediated_decay","processed_pseudogene","processed_transcript","protein_coding","retained_intron","transcribed_processed_pseudogene","transcribed_unprocessed_pseudogene","unprocessed_pseudogene"],"value":["lncRNA","miRNA","misc_RNA","non_stop_decay","nonsense_mediated_decay","processed_pseudogene","processed_transcript","protein_coding","retained_intron","transcribed_processed_pseudogene","transcribed_unprocessed_pseudogene","unprocessed_pseudogene"]}},"config":{"multiple":true,"search":true,"selectedValue":"protein_coding","hideClearButton":false,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":true,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":false,"disableOptionGroupCheckbox":false,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify6721112', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'The transcript types to draw. None selected draws them all.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify8198010">
#>             <div class="material-switch">
#>               <label for="track-txn.labels" style="padding-right: 10px;">Transcript Labels</label>
#>               <input id="track-txn.labels" type="checkbox" checked="checked"/>
#>               <label class="switch label-success bg-success" for="track-txn.labels"></label>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify8198010', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Name each transcript or gene.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify9146215">
#>             <label class="control-label" id="track-txn.font.size-label" for="track-txn.font.size">Label Font Size</label>
#>             <input id="track-txn.font.size" type="number" class="shiny-input-number form-control" value="8" data-update-on="change" min="1" step="1"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify9146215', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Size of those names.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour" id="tipify6899707">
#>             <label class="control-label" for="track-exon.color">Exon Color</label>
#>             <input id="track-exon.color" type="text" class="form-control shiny-colour-input" data-init-value="#1A1A1A" data-show-colour="both" data-palette="square"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify6899707', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Colour of the exons.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour" id="tipify4919778">
#>             <label class="control-label" for="track-cds.color">CDS Color</label>
#>             <input id="track-cds.color" type="text" class="form-control shiny-colour-input" data-init-value="#D7191C" data-show-colour="both" data-palette="square"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify4919778', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Colour of the coding sequence.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour" id="tipify6469286">
#>             <label class="control-label" for="track-intron.color">Intron Color</label>
#>             <input id="track-intron.color" type="text" class="form-control shiny-colour-input" data-init-value="#444444" data-show-colour="both" data-palette="square"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify6469286', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Colour of the transcript lines, arrowheads and labels.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify4565150">
#>             <div class="material-switch">
#>               <label for="track-show.cytoband" style="padding-right: 10px;">Ideogram</label>
#>               <input id="track-show.cytoband" type="checkbox" checked="checked"/>
#>               <label class="switch label-success bg-success" for="track-show.cytoband"></label>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify4565150', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Show where the region sits on its chromosome.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify1254467">
#>             <div class="material-switch">
#>               <label for="track-show.map.lines" style="padding-right: 10px;">Map Lines</label>
#>               <input id="track-show.map.lines" type="checkbox" checked="checked"/>
#>               <label class="switch label-success bg-success" for="track-show.map.lines"></label>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify1254467', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Link each CpG&#39;s position to its heatmap column.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify6043650">
#>             <div class="material-switch">
#>               <label for="track-show.coverage" style="padding-right: 10px;">Array Coverage</label>
#>               <input id="track-show.coverage" type="checkbox" checked="checked"/>
#>               <label class="switch label-success bg-success" for="track-show.coverage"></label>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify6043650', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Mark which array has which CpG.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" style="width:100%;" id="tipify8268267">
#>             <label class="control-label" id="track-cpg.tracks-label" for="track-cpg.tracks">CpG Annotations</label>
#>             <div id="track-cpg.tracks" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="close">
#>               <script type="application/json" data-for="track-cpg.tracks">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":[],"value":[]}},"config":{"multiple":true,"search":false,"selectedValue":[],"hideClearButton":false,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":true,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":false,"disableOptionGroupCheckbox":false,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify8268267', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'rowData columns to draw as strips under the heatmap.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" style="width:100%;" id="tipify6193782">
#>             <label class="control-label" id="track-cpg.labels-label" for="track-cpg.labels">CpG Labels</label>
#>             <div id="track-cpg.labels" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="change">
#>               <script type="application/json" data-for="track-cpg.labels">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["None","Probe ID","Position"],"value":["none","probe","locus"]}},"config":{"multiple":false,"search":false,"selectedValue":"none","hideClearButton":true,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":false,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":true,"disableOptionGroupCheckbox":true,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify6193782', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Label the heatmap&#39;s columns.'})}, 500)});</script>
#>         </div>
#>       </div>
#>     </div>
#>     <div class="tab-pane" data-value="Aesthetics" id="tab-8723-4">
#>       <div class="vizmodules-input-grid" style="--viz-input-columns: 2;">
#>         <div class="vizmodules-input-cell">
#>           <div class="multi-color-picker shiny-input-container form-group is-compact " id="track-colorscale.colors" data-palettes="{&quot;RdYlBu&quot;:[&quot;#2C7BB6&quot;,&quot;#ABD9E9&quot;,&quot;#FFFFBF&quot;,&quot;#FDAE61&quot;,&quot;#D7191C&quot;],&quot;Jet&quot;:[&quot;#0000FF&quot;,&quot;#00FFFF&quot;,&quot;#80FF80&quot;,&quot;#FFFF00&quot;,&quot;#FF0000&quot;],&quot;Blue-White-Red&quot;:[&quot;#2166AC&quot;,&quot;#92C5DE&quot;,&quot;#F7F7F7&quot;,&quot;#F4A582&quot;,&quot;#B2182B&quot;],&quot;Viridis&quot;:[&quot;#440154&quot;,&quot;#3B528B&quot;,&quot;#21908C&quot;,&quot;#5DC863&quot;,&quot;#FDE725&quot;],&quot;Magma&quot;:[&quot;#000004&quot;,&quot;#51127C&quot;,&quot;#B63679&quot;,&quot;#FB8861&quot;,&quot;#FCFDBF&quot;],&quot;Cividis&quot;:[&quot;#00224E&quot;,&quot;#434E6C&quot;,&quot;#7D7C78&quot;,&quot;#BCAF6F&quot;,&quot;#FEE838&quot;]}" data-initial="{&quot;Lowest&quot;:&quot;#2C7BB6&quot;,&quot;Low&quot;:&quot;#ABD9E9&quot;,&quot;Middle&quot;:&quot;#FFFFBF&quot;,&quot;High&quot;:&quot;#FDAE61&quot;,&quot;Highest&quot;:&quot;#D7191C&quot;}" data-groups="[&quot;Lowest&quot;,&quot;Low&quot;,&quot;Middle&quot;,&quot;High&quot;,&quot;Highest&quot;]" data-default-palette="RdYlBu" data-compact="true">
#>             <div class="mc-top">
#>               <label class="control-label" for="track-colorscale.colors">Color Scale</label>
#>               <div class="mc-actions">
#>                 <select class="mc-palette-select form-control input-sm" aria-label="Palette">
#>                   <option value="RdYlBu" selected="selected">RdYlBu</option>
#>                   <option value="Jet">Jet</option>
#>                   <option value="Blue-White-Red">Blue-White-Red</option>
#>                   <option value="Viridis">Viridis</option>
#>                   <option value="Magma">Magma</option>
#>                   <option value="Cividis">Cividis</option>
#>                 </select>
#>                 <div class="mc-button-group">
#>                   <button type="button" class="mc-button mc-apply-palette">Apply</button>
#>                   <button type="button" class="mc-button mc-reset-palette">Reset</button>
#>                 </div>
#>               </div>
#>             </div>
#>             <div class="mc-swatch-row" role="list"></div>
#>             <div class="mc-color-rows">
#>               <div class="mc-color-row is-active" data-group="Lowest">
#>                 <span class="mc-group-label">Lowest</span>
#>                 <input type="color" class="mc-color-input" value="#2C7BB6" aria-label="Lowest color"/>
#>                 <input type="text" class="mc-text-input form-control input-sm" value="#2C7BB6" aria-label="Lowest hex code"/>
#>               </div>
#>               <div class="mc-color-row " data-group="Low">
#>                 <span class="mc-group-label">Low</span>
#>                 <input type="color" class="mc-color-input" value="#ABD9E9" aria-label="Low color"/>
#>                 <input type="text" class="mc-text-input form-control input-sm" value="#ABD9E9" aria-label="Low hex code"/>
#>               </div>
#>               <div class="mc-color-row " data-group="Middle">
#>                 <span class="mc-group-label">Middle</span>
#>                 <input type="color" class="mc-color-input" value="#FFFFBF" aria-label="Middle color"/>
#>                 <input type="text" class="mc-text-input form-control input-sm" value="#FFFFBF" aria-label="Middle hex code"/>
#>               </div>
#>               <div class="mc-color-row " data-group="High">
#>                 <span class="mc-group-label">High</span>
#>                 <input type="color" class="mc-color-input" value="#FDAE61" aria-label="High color"/>
#>                 <input type="text" class="mc-text-input form-control input-sm" value="#FDAE61" aria-label="High hex code"/>
#>               </div>
#>               <div class="mc-color-row " data-group="Highest">
#>                 <span class="mc-group-label">Highest</span>
#>                 <input type="color" class="mc-color-input" value="#D7191C" aria-label="Highest color"/>
#>                 <input type="text" class="mc-text-input form-control input-sm" value="#D7191C" aria-label="Highest hex code"/>
#>               </div>
#>             </div>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify8410537">
#>             <div class="material-switch">
#>               <label for="track-colorscale.reverse" style="padding-right: 10px;">Reverse Colors</label>
#>               <input id="track-colorscale.reverse" type="checkbox"/>
#>               <label class="switch label-success bg-success" for="track-colorscale.reverse"></label>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify8410537', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Run the colors from the highest value to the lowest.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify4272466">
#>             <label class="control-label" id="track-colorscale.min-label" for="track-colorscale.min">Scale Min</label>
#>             <input id="track-colorscale.min" type="number" class="shiny-input-number form-control" value="0" data-update-on="change"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify4272466', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Value at the lowest color. Empty for the minimum of the data.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify7692867">
#>             <label class="control-label" id="track-colorscale.mid-label" for="track-colorscale.mid">Scale Mid</label>
#>             <input id="track-colorscale.mid" type="number" class="shiny-input-number form-control" value="NA" data-update-on="change"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify7692867', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Value at the middle color. Empty for the center of the limits.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify7121408">
#>             <label class="control-label" id="track-colorscale.max-label" for="track-colorscale.max">Scale Max</label>
#>             <input id="track-colorscale.max" type="number" class="shiny-input-number form-control" value="1" data-update-on="change"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify7121408', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Value at the highest color. Empty for the maximum of the data.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify633673">
#>             <label class="control-label" id="track-colorbar.title-label" for="track-colorbar.title">Colorbar Title</label>
#>             <input id="track-colorbar.title" type="text" class="shiny-input-text form-control" value="Beta value" data-update-on="change"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify633673', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Title of the colorbar.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour" id="tipify4260052">
#>             <label class="control-label" for="track-absent.color">Not On Array</label>
#>             <input id="track-absent.color" type="text" class="form-control shiny-colour-input" data-init-value="#BDBDBD" data-show-colour="both" data-palette="square"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify4260052', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Colour of a cell whose array lacks the CpG.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour" id="tipify882777">
#>             <label class="control-label" for="track-na.color">No Value</label>
#>             <input id="track-na.color" type="text" class="form-control shiny-colour-input" data-init-value="#FFFFFF" data-show-colour="both" data-palette="square"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify882777', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Colour of a cell with no value on an array that has the CpG, such as a masked probe.'})}, 500)});</script>
#>         </div>
#>       </div>
#>     </div>
#>     <div class="tab-pane" data-value="Legend" id="tab-8723-5">
#>       <div class="vizmodules-input-grid" style="--viz-input-columns: 2;">
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify2083168">
#>             <div class="material-switch">
#>               <label for="track-legend.show" style="padding-right: 10px;">Show Legend</label>
#>               <input id="track-legend.show" type="checkbox" checked="checked"/>
#>               <label class="switch label-success bg-success" for="track-legend.show"></label>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify2083168', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Show the legend. Turning it off also hides colorbars and any point size legend.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" style="width:100%;" id="tipify2282609">
#>             <label class="control-label" id="track-legend.font.family-label" for="track-legend.font.family">Legend Font</label>
#>             <div id="track-legend.font.family" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="change">
#>               <script type="application/json" data-for="track-legend.font.family">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["Arial","Balto","Courier New","Droid Sans","Droid Serif","Droid Sans Mono","Gravitas One","Old Standard TT","Open Sans","Overpass","PT Sans Narrow","Raleway","Times New Roman","Verdana","sans-serif","serif","monospace"],"value":["Arial","Balto","Courier New","Droid Sans","Droid Serif","Droid Sans Mono","Gravitas One","Old Standard TT","Open Sans","Overpass","PT Sans Narrow","Raleway","Times New Roman","Verdana","sans-serif","serif","monospace"]}},"config":{"multiple":false,"search":true,"selectedValue":"Arial","hideClearButton":true,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":false,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":true,"disableOptionGroupCheckbox":true,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify2282609', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Font family of the legend title and entry labels.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour" id="tipify504422">
#>             <label class="control-label" for="track-legend.font.color">Legend Font Color</label>
#>             <input id="track-legend.font.color" type="text" class="form-control shiny-colour-input" data-init-value="#000000" data-show-colour="both" data-palette="square"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify504422', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Font color of the legend title and entry labels.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify5618212">
#>             <label class="control-label" id="track-legend.title.size-label" for="track-legend.title.size">Legend Title Size</label>
#>             <input id="track-legend.title.size" type="number" class="shiny-input-number form-control" value="14" data-update-on="change" min="0" step="1"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify5618212', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Font size of the legend title.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify6942461">
#>             <label class="control-label" id="track-legend.text.size-label" for="track-legend.text.size">Legend Text Size</label>
#>             <input id="track-legend.text.size" type="number" class="shiny-input-number form-control" value="12" data-update-on="change" min="0" step="1"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify6942461', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Font size of the legend entry labels.'})}, 500)});</script>
#>         </div>
#>       </div>
#>     </div>
#>     <div class="tab-pane" data-value="Axes" id="tab-8723-6">
#>       <div class="vizmodules-input-grid" style="--viz-input-columns: 2;">
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" style="width:100%;">
#>             <label class="control-label" id="track-title.font.family-label" for="track-title.font.family">Title Font</label>
#>             <div id="track-title.font.family" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="change">
#>               <script type="application/json" data-for="track-title.font.family">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["Arial","Balto","Courier New","Droid Sans","Droid Serif","Droid Sans Mono","Gravitas One","Old Standard TT","Open Sans","Overpass","PT Sans Narrow","Raleway","Times New Roman","Verdana","sans-serif","serif","monospace"],"value":["Arial","Balto","Courier New","Droid Sans","Droid Serif","Droid Sans Mono","Gravitas One","Old Standard TT","Open Sans","Overpass","PT Sans Narrow","Raleway","Times New Roman","Verdana","sans-serif","serif","monospace"]}},"config":{"multiple":false,"search":true,"selectedValue":"Arial","hideClearButton":true,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":false,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":true,"disableOptionGroupCheckbox":true,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>             </div>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour">
#>             <label class="control-label" for="track-title.font.color">Title Color</label>
#>             <input id="track-title.font.color" type="text" class="form-control shiny-colour-input" data-init-value="#000000" data-show-colour="both" data-palette="square"/>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="track-title.font.size-label" for="track-title.font.size">Title Size</label>
#>             <input id="track-title.font.size" type="number" class="shiny-input-number form-control" value="26" data-update-on="change" min="1" step="1"/>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="track-axis.title.horizontal.position-label" for="track-axis.title.horizontal.position">Title position</label>
#>             <input id="track-axis.title.horizontal.position" type="number" class="shiny-input-number form-control" value="0.5" data-update-on="change" min="0" max="1" step="0.1"/>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="track-axis.title.font.size-label" for="track-axis.title.font.size">Axis Title Size</label>
#>             <input id="track-axis.title.font.size" type="number" class="shiny-input-number form-control" value="18" data-update-on="change" min="1" step="1"/>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour">
#>             <label class="control-label" for="track-axis.title.font.color">Axis Title Color</label>
#>             <input id="track-axis.title.font.color" type="text" class="form-control shiny-colour-input" data-init-value="#000000" data-show-colour="both" data-palette="square"/>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" style="width:100%;">
#>             <label class="control-label" id="track-axis.title.font.family-label" for="track-axis.title.font.family">Axis Title Font</label>
#>             <div id="track-axis.title.font.family" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="change">
#>               <script type="application/json" data-for="track-axis.title.font.family">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["Arial","Balto","Courier New","Droid Sans","Droid Serif","Droid Sans Mono","Gravitas One","Old Standard TT","Open Sans","Overpass","PT Sans Narrow","Raleway","Times New Roman","Verdana","sans-serif","serif","monospace"],"value":["Arial","Balto","Courier New","Droid Sans","Droid Serif","Droid Sans Mono","Gravitas One","Old Standard TT","Open Sans","Overpass","PT Sans Narrow","Raleway","Times New Roman","Verdana","sans-serif","serif","monospace"]}},"config":{"multiple":false,"search":true,"selectedValue":"Arial","hideClearButton":true,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":false,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":true,"disableOptionGroupCheckbox":true,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>             </div>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container">
#>             <div class="checkbox">
#>               <label>
#>                 <input id="track-axis.showline" type="checkbox" class="shiny-input-checkbox"/>
#>                 <span>Show Axis Borders</span>
#>               </label>
#>             </div>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container">
#>             <div class="checkbox">
#>               <label>
#>                 <input id="track-axis.mirror" type="checkbox" class="shiny-input-checkbox" checked="checked"/>
#>                 <span>Mirror Axis Borders</span>
#>               </label>
#>             </div>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container">
#>             <div class="checkbox">
#>               <label>
#>                 <input id="track-show.grid.x" type="checkbox" class="shiny-input-checkbox"/>
#>                 <span>Show X Gridlines</span>
#>               </label>
#>             </div>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container">
#>             <div class="checkbox">
#>               <label>
#>                 <input id="track-show.grid.y" type="checkbox" class="shiny-input-checkbox"/>
#>                 <span>Show Y Gridlines</span>
#>               </label>
#>             </div>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour">
#>             <label class="control-label" for="track-grid.color">Gridline Color</label>
#>             <input id="track-grid.color" type="text" class="form-control shiny-colour-input" data-init-value="#CCCCCC" data-show-colour="both" data-palette="square"/>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour">
#>             <label class="control-label" for="track-axis.linecolor">Axis Line Color</label>
#>             <input id="track-axis.linecolor" type="text" class="form-control shiny-colour-input" data-init-value="black" data-show-colour="both" data-palette="square"/>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="track-axis.linewidth-label" for="track-axis.linewidth">Axis Line Width</label>
#>             <input id="track-axis.linewidth" type="number" class="shiny-input-number form-control" value="0.5" data-update-on="change" min="0" step="0.1"/>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="track-axis.tickfont.size-label" for="track-axis.tickfont.size">Tick Label Size</label>
#>             <input id="track-axis.tickfont.size" type="number" class="shiny-input-number form-control" value="12" data-update-on="change" min="1" step="1"/>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour">
#>             <label class="control-label" for="track-axis.tickfont.color">Tick Label Color</label>
#>             <input id="track-axis.tickfont.color" type="text" class="form-control shiny-colour-input" data-init-value="black" data-show-colour="both" data-palette="square"/>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" style="width:100%;">
#>             <label class="control-label" id="track-axis.tickfont.family-label" for="track-axis.tickfont.family">Tick Label Font</label>
#>             <div id="track-axis.tickfont.family" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="change">
#>               <script type="application/json" data-for="track-axis.tickfont.family">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["Arial","Balto","Courier New","Droid Sans","Droid Serif","Droid Sans Mono","Gravitas One","Old Standard TT","Open Sans","Overpass","PT Sans Narrow","Raleway","Times New Roman","Verdana","sans-serif","serif","monospace"],"value":["Arial","Balto","Courier New","Droid Sans","Droid Serif","Droid Sans Mono","Gravitas One","Old Standard TT","Open Sans","Overpass","PT Sans Narrow","Raleway","Times New Roman","Verdana","sans-serif","serif","monospace"]}},"config":{"multiple":false,"search":true,"selectedValue":"Arial","hideClearButton":true,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":false,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":true,"disableOptionGroupCheckbox":true,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>             </div>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="track-axis.tickangle.x-label" for="track-axis.tickangle.x">X Tick Label Angle</label>
#>             <input id="track-axis.tickangle.x" type="number" class="shiny-input-number form-control" value="-90" data-update-on="change" min="-180" max="180" step="15"/>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="track-axis.tickangle.y-label" for="track-axis.tickangle.y">Y Tick Label Angle</label>
#>             <input id="track-axis.tickangle.y" type="number" class="shiny-input-number form-control" value="0" data-update-on="change" min="-180" max="180" step="15"/>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" style="width:100%;">
#>             <label class="control-label" id="track-axis.ticks-label" for="track-axis.ticks">Tick Position</label>
#>             <div id="track-axis.ticks" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="change">
#>               <script type="application/json" data-for="track-axis.ticks">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["Outside","Inside","(none)"],"value":["outside","inside",""]}},"config":{"multiple":false,"search":false,"selectedValue":"outside","hideClearButton":true,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":false,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":true,"disableOptionGroupCheckbox":true,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>             </div>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour">
#>             <label class="control-label" for="track-axis.tickcolor">Tick Mark Color</label>
#>             <input id="track-axis.tickcolor" type="text" class="form-control shiny-colour-input" data-init-value="black" data-show-colour="both" data-palette="square"/>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="track-axis.ticklen-label" for="track-axis.ticklen">Tick Mark Length</label>
#>             <input id="track-axis.ticklen" type="number" class="shiny-input-number form-control" value="5" data-update-on="change" min="0" step="1"/>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="track-axis.tickwidth-label" for="track-axis.tickwidth">Tick Mark Width</label>
#>             <input id="track-axis.tickwidth" type="number" class="shiny-input-number form-control" value="1" data-update-on="change" min="0" step="0.1"/>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="track-facet.title.font.size-label" for="track-facet.title.font.size">Facet Subplot Title Size</label>
#>             <input id="track-facet.title.font.size" type="number" class="shiny-input-number form-control" value="18" data-update-on="change" min="1" step="1"/>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour">
#>             <label class="control-label" for="track-facet.title.font.color">Facet Title Color</label>
#>             <input id="track-facet.title.font.color" type="text" class="form-control shiny-colour-input" data-init-value="#000000" data-show-colour="both" data-palette="square"/>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" style="width:100%;">
#>             <label class="control-label" id="track-facet.title.font.family-label" for="track-facet.title.font.family">Facet Title Font</label>
#>             <div id="track-facet.title.font.family" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="change">
#>               <script type="application/json" data-for="track-facet.title.font.family">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["Arial","Balto","Courier New","Droid Sans","Droid Serif","Droid Sans Mono","Gravitas One","Old Standard TT","Open Sans","Overpass","PT Sans Narrow","Raleway","Times New Roman","Verdana","sans-serif","serif","monospace"],"value":["Arial","Balto","Courier New","Droid Sans","Droid Serif","Droid Sans Mono","Gravitas One","Old Standard TT","Open Sans","Overpass","PT Sans Narrow","Raleway","Times New Roman","Verdana","sans-serif","serif","monospace"]}},"config":{"multiple":false,"search":true,"selectedValue":"Arial","hideClearButton":true,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":false,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":true,"disableOptionGroupCheckbox":true,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>             </div>
#>           </div>
#>         </div>
#>       </div>
#>     </div>
#>     <div class="tab-pane" data-value="Plotly" id="tab-8723-7">
#>       <div class="vizmodules-input-grid" style="--viz-input-columns: 2;">
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" style="width:100%;">
#>             <label class="control-label" id="track-download.format-label" for="track-download.format">Download Format</label>
#>             <div id="track-download.format" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="change">
#>               <script type="application/json" data-for="track-download.format">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["svg","png","jpeg","webp"],"value":["svg","png","jpeg","webp"]}},"config":{"multiple":false,"search":false,"selectedValue":"svg","hideClearButton":true,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":false,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":true,"disableOptionGroupCheckbox":true,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>             </div>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify2279427">
#>             <label class="control-label" id="track-margin.t-label" for="track-margin.t">Margin Top</label>
#>             <input id="track-margin.t" type="number" class="shiny-input-number form-control" value="70" data-update-on="change" min="0" step="5"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify2279427', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Top margin of the plot in pixels'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify9603136">
#>             <label class="control-label" id="track-margin.b-label" for="track-margin.b">Margin Bottom</label>
#>             <input id="track-margin.b" type="number" class="shiny-input-number form-control" value="70" data-update-on="change" min="0" step="5"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify9603136', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Bottom margin of the plot in pixels'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify4928372">
#>             <label class="control-label" id="track-margin.l-label" for="track-margin.l">Margin Left</label>
#>             <input id="track-margin.l" type="number" class="shiny-input-number form-control" value="70" data-update-on="change" min="0" step="5"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify4928372', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Left margin of the plot in pixels'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify7232087">
#>             <label class="control-label" id="track-margin.r-label" for="track-margin.r">Margin Right</label>
#>             <input id="track-margin.r" type="number" class="shiny-input-number form-control" value="90" data-update-on="change" min="0" step="5"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify7232087', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Right margin of the plot in pixels'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour" id="tipify4913631">
#>             <label class="control-label" for="track-shape.fill">Shape Fill</label>
#>             <input id="track-shape.fill" type="text" class="form-control shiny-colour-input" data-init-value="rgba(0, 0, 0, 0)" data-show-colour="both" data-palette="square" data-allow-alpha="true"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify4913631', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Interior fill color for shapes drawn on the plot using Plotly&#39;s drawing tools'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour" id="tipify8453550">
#>             <label class="control-label" for="track-shape.line.color">Shape Line Color</label>
#>             <input id="track-shape.line.color" type="text" class="form-control shiny-colour-input" data-init-value="black" data-show-colour="both" data-palette="square" data-allow-alpha="true"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify8453550', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Outline color for shapes drawn on the plot using Plotly&#39;s drawing tools'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify251097">
#>             <label class="control-label" id="track-shape.line.width-label" for="track-shape.line.width">Shape Line Width</label>
#>             <input id="track-shape.line.width" type="number" class="shiny-input-number form-control" value="4" data-update-on="change" min="0" step="0.25"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify251097', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Outline width for shapes drawn on the plot using Plotly&#39;s drawing tools'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" style="width:100%;" id="tipify5484002">
#>             <label class="control-label" id="track-shape.linetype-label" for="track-shape.linetype">Shape Linetype</label>
#>             <div id="track-shape.linetype" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="change">
#>               <script type="application/json" data-for="track-shape.linetype">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["solid","dot","dash","longdash","dashdot","longdashdot"],"value":["solid","dot","dash","longdash","dashdot","longdashdot"]}},"config":{"multiple":false,"search":false,"selectedValue":"solid","hideClearButton":true,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":false,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":true,"disableOptionGroupCheckbox":true,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify5484002', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Line dash style for shapes drawn on the plot using Plotly&#39;s drawing tools'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify9554548">
#>             <label class="control-label" id="track-shape.opacity-label" for="track-shape.opacity">Shape Opacity</label>
#>             <input id="track-shape.opacity" type="number" class="shiny-input-number form-control" value="1" data-update-on="change" min="0" max="1" step="0.01"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify9554548', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Opacity of shapes drawn on the plot, where 0 is fully transparent and 1 is fully opaque'})}, 500)});</script>
#>         </div>
#>       </div>
#>     </div>
#>   </div>
#> </div>
#> <div class="module-tack" style="margin-top: 12px;">
#>   <div class="module-tack-switch" style="margin-bottom: 4px;">
#>     <div class="form-group shiny-input-container">
#>       <div class="material-switch">
#>         <label for="track-auto.update" style="padding-right: 10px;">Auto Update</label>
#>         <input id="track-auto.update" type="checkbox" checked="checked"/>
#>         <label class="switch label-success bg-success" for="track-auto.update"></label>
#>       </div>
#>     </div>
#>   </div>
#>   <div class="module-tack-buttons" style="display: flex; flex-wrap: wrap; gap: 8px;">
#>     <button class="btn btn-default action-button btn-primary" id="track-update" style="flex: 1 1 45%;" type="button"><span class="action-label">Update</span></button>
#>     <button class="btn btn-default action-button btn-secondary" id="track-reset" style="flex: 1 1 45%;" type="button"><span class="action-label">Reset</span></button>
#>     <a aria-disabled="true" class="btn btn-default shiny-download-link disabled btn-secondary viz-source-download" data-viz-source-ns="track-" download href="" id="track-download.source" style="flex: 1 1 100%;" tabindex="-1" target="_blank">
#>       <i class="far fa-file-code" role="presentation" aria-label="file-code icon"></i>
#>       Source Download
#>     </a>
#>     <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('track-download.source', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Download the plot as a self-contained HTML file and as SVG and PNG images of it as it looks now, along with the plot source data and statistics (if applicable) as CSV files.'})}, 500)});</script>
#>   </div>
#> </div>
```
