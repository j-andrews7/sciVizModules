# Input UI components for the gseaEnrichmentPlot module

This should be placed in the UI where the inputs should be shown, with
an `id` that matches the `id` used in the
[`gseaEnrichmentPlotServer()`](https://j-andrews7.github.io/sciVizModules/reference/gseaEnrichmentPlotServer.md)
and
[`gseaEnrichmentPlotOutputUI()`](https://j-andrews7.github.io/sciVizModules/reference/gseaEnrichmentPlotOutputUI.md)
functions.

## Usage

``` r
gseaEnrichmentPlotInputsUI(
  id,
  data,
  defaults = NULL,
  title = "GSEA Plot Settings",
  columns = 2
)
```

## Arguments

- id:

  The ID for the Shiny module.

- data:

  An fgsea bundle or a clusterProfiler `gseaResult`.

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
[`gseaEnrichmentPlot()`](https://j-andrews7.github.io/sciVizModules/reference/gseaEnrichmentPlot.md):
the running enrichment score of one or more gene sets over the ranked
gene list, with hit ticks and the ranked statistic below. It takes
either an fgsea bundle -
`list(stats = <named numeric>, pathways = <named list>, results = <fgsea table, optional>)`

- or a clusterProfiler `gseaResult`. The inputs are organised into tabs
  via
  [`VizModules::organize_inputs()`](https://j-andrews7.github.io/VizModules/reference/organize_inputs.html).

## Plot parameters and defaults

The following parameters can be accessed via UI inputs and/or the
`defaults` argument:

- `pathways` - Gene sets to plot (default: the three most significant)

- `gsea.param` - Weight exponent of the running score (default: 1; fgsea
  `gseaParam`)

- `show.ticks` - Draw the hit ticks (default: TRUE)

- `show.metric` - Draw the ranked statistic (default: TRUE)

- `palette.colours` - Named gene set colours (multiColorPicker)

- `metric.color` - Colour of the ranked statistic (default: "#7F7F7F")

The Legend, Axes and Plotly tabs carry the shared VizModules inputs.

## See also

[`gseaEnrichmentPlot()`](https://j-andrews7.github.io/sciVizModules/reference/gseaEnrichmentPlot.md),
[`gseaEnrichmentPlotOutputUI()`](https://j-andrews7.github.io/sciVizModules/reference/gseaEnrichmentPlotOutputUI.md),
[`gseaEnrichmentPlotServer()`](https://j-andrews7.github.io/sciVizModules/reference/gseaEnrichmentPlotServer.md),
[`gseaEnrichmentPlotApp()`](https://j-andrews7.github.io/sciVizModules/reference/gseaEnrichmentPlotApp.md)

## Author

Jared Andrews

## Examples

``` r
library(sciVizModules)
data(example_gsea)
gseaEnrichmentPlotInputsUI("gsea", example_gsea)
#> <h3>GSEA Plot Settings</h3>
#> <div class="tabbable vizmodules-input-tabs">
#>   <ul class="nav nav-tabs shiny-tab-input" id="gsea-gseaEnrichmentPlotTabsetPanel" data-tabsetid="7840">
#>     <li class="active">
#>       <a href="#tab-7840-1" data-toggle="tab" data-bs-toggle="tab" data-value="Data">Data</a>
#>     </li>
#>     <li>
#>       <a href="#tab-7840-2" data-toggle="tab" data-bs-toggle="tab" data-value="Aesthetics">Aesthetics</a>
#>     </li>
#>     <li>
#>       <a href="#tab-7840-3" data-toggle="tab" data-bs-toggle="tab" data-value="Legend">Legend</a>
#>     </li>
#>     <li>
#>       <a href="#tab-7840-4" data-toggle="tab" data-bs-toggle="tab" data-value="Axes">Axes</a>
#>     </li>
#>     <li>
#>       <a href="#tab-7840-5" data-toggle="tab" data-bs-toggle="tab" data-value="Plotly">Plotly</a>
#>     </li>
#>   </ul>
#>   <div class="tab-content" data-tabsetid="7840">
#>     <div class="tab-pane active" data-value="Data" id="tab-7840-1">
#>       <div class="vizmodules-input-grid" style="--viz-input-columns: 2;">
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" style="width:100%;" id="tipify7773061">
#>             <label class="control-label" id="gsea-pathways-label" for="gsea-pathways">Gene Sets</label>
#>             <div id="gsea-pathways" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="close">
#>               <script type="application/json" data-for="gsea-pathways">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["5990980_Cell_Cycle","5990979_Cell_Cycle,_Mitotic","5991851_Mitotic_Prometaphase","5992217_Resolution_of_Sister_Chromatid_Cohesion","5991454_M_Phase","5991502_Mitotic_Metaphase_and_Anaphase","5991599_Separation_of_Sister_Chromatids","5991757_RHO_GTPases_Activate_Formins","5991600_Mitotic_Anaphase","5990991_Mitotic_G1-G1_S_phases","5990987_Synthesis_of_DNA","5990981_DNA_Replication","5990988_S_Phase","5990990_G1_S_Transition","5991209_RHO_GTPase_Effectors","5991009_Cell_Cycle_Checkpoints","5990998_DNA_strand_elongation","5991022_Glucose_metabolism","5991023_Metabolism_of_carbohydrates","5991506_Chromosome_Maintenance","5991393_E2F_mediated_regulation_of_DNA_replication","5991017_G2_M_Checkpoints","5991078_Metabolism_of_nucleotides","5991210_Signaling_by_Rho_GTPases","5991042_Glycolysis","5991016_Activation_of_ATR_in_response_to_replication_stress","5991021_Gluconeogenesis","5990977_DNA_Replication_Pre-Initiation","5990978_M_G1_Transition","5990989_Activation_of_the_pre-replicative_complex","5991662_Cholesterol_biosynthesis","5992313_Chromatin_modifying_enzymes","5992314_Chromatin_organization","5990983_Regulation_of_DNA_replication","5990992_Removal_of_licensing_factors_from_origins","5991610_Telomere_C-strand_Lagging_Strand_Synthesis","5991504_Extension_of_Telomeres","5990999_Lagging_Strand_Synthesis","5991398_Intrinsic_Pathway_for_Apoptosis","5990993_Orc1_removal_from_chromatin"],"value":["5990980_Cell_Cycle","5990979_Cell_Cycle,_Mitotic","5991851_Mitotic_Prometaphase","5992217_Resolution_of_Sister_Chromatid_Cohesion","5991454_M_Phase","5991502_Mitotic_Metaphase_and_Anaphase","5991599_Separation_of_Sister_Chromatids","5991757_RHO_GTPases_Activate_Formins","5991600_Mitotic_Anaphase","5990991_Mitotic_G1-G1_S_phases","5990987_Synthesis_of_DNA","5990981_DNA_Replication","5990988_S_Phase","5990990_G1_S_Transition","5991209_RHO_GTPase_Effectors","5991009_Cell_Cycle_Checkpoints","5990998_DNA_strand_elongation","5991022_Glucose_metabolism","5991023_Metabolism_of_carbohydrates","5991506_Chromosome_Maintenance","5991393_E2F_mediated_regulation_of_DNA_replication","5991017_G2_M_Checkpoints","5991078_Metabolism_of_nucleotides","5991210_Signaling_by_Rho_GTPases","5991042_Glycolysis","5991016_Activation_of_ATR_in_response_to_replication_stress","5991021_Gluconeogenesis","5990977_DNA_Replication_Pre-Initiation","5990978_M_G1_Transition","5990989_Activation_of_the_pre-replicative_complex","5991662_Cholesterol_biosynthesis","5992313_Chromatin_modifying_enzymes","5992314_Chromatin_organization","5990983_Regulation_of_DNA_replication","5990992_Removal_of_licensing_factors_from_origins","5991610_Telomere_C-strand_Lagging_Strand_Synthesis","5991504_Extension_of_Telomeres","5990999_Lagging_Strand_Synthesis","5991398_Intrinsic_Pathway_for_Apoptosis","5990993_Orc1_removal_from_chromatin"]}},"config":{"multiple":true,"search":true,"selectedValue":["5990980_Cell_Cycle","5990979_Cell_Cycle,_Mitotic","5991851_Mitotic_Prometaphase"],"hideClearButton":false,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":true,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":false,"disableOptionGroupCheckbox":false,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify7773061', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Gene sets to plot; each gets its own running score and tick row.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify912010">
#>             <label class="control-label" id="gsea-gsea.param-label" for="gsea-gsea.param">Weight Exponent</label>
#>             <input id="gsea-gsea.param" type="number" class="shiny-input-number form-control" value="1" data-update-on="change" min="0" step="0.5"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify912010', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Exponent on the gene statistics when stepping up the running score (1 is standard GSEA; 0 unweighted).'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify7426239">
#>             <div class="material-switch">
#>               <label for="gsea-show.ticks" style="padding-right: 10px;">Hit Ticks</label>
#>               <input id="gsea-show.ticks" type="checkbox" checked="checked"/>
#>               <label class="switch label-success bg-success" for="gsea-show.ticks"></label>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify7426239', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Draw a tick for each gene of the set at its rank.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify3966740">
#>             <div class="material-switch">
#>               <label for="gsea-show.metric" style="padding-right: 10px;">Ranked Metric</label>
#>               <input id="gsea-show.metric" type="checkbox" checked="checked"/>
#>               <label class="switch label-success bg-success" for="gsea-show.metric"></label>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify3966740', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Draw the ranked gene statistic beneath.'})}, 500)});</script>
#>         </div>
#>       </div>
#>     </div>
#>     <div class="tab-pane" data-value="Aesthetics" id="tab-7840-2">
#>       <div class="vizmodules-input-grid" style="--viz-input-columns: 2;">
#>         <div class="vizmodules-input-cell">
#>           <div id="gsea-palette.selection" class="shiny-html-output"></div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour" id="tipify2960282">
#>             <label class="control-label" for="gsea-metric.color">Metric Color</label>
#>             <input id="gsea-metric.color" type="text" class="form-control shiny-colour-input" data-init-value="#7F7F7F" data-show-colour="both" data-palette="square"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify2960282', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Colour of the ranked statistic.'})}, 500)});</script>
#>         </div>
#>       </div>
#>     </div>
#>     <div class="tab-pane" data-value="Legend" id="tab-7840-3">
#>       <div class="vizmodules-input-grid" style="--viz-input-columns: 2;">
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify7429240">
#>             <div class="material-switch">
#>               <label for="gsea-legend.show" style="padding-right: 10px;">Show Legend</label>
#>               <input id="gsea-legend.show" type="checkbox" checked="checked"/>
#>               <label class="switch label-success bg-success" for="gsea-legend.show"></label>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify7429240', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Show the legend. Turning it off also hides colorbars and any point size legend.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" style="width:100%;" id="tipify4665094">
#>             <label class="control-label" id="gsea-legend.font.family-label" for="gsea-legend.font.family">Legend Font</label>
#>             <div id="gsea-legend.font.family" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="change">
#>               <script type="application/json" data-for="gsea-legend.font.family">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["Arial","Balto","Courier New","Droid Sans","Droid Serif","Droid Sans Mono","Gravitas One","Old Standard TT","Open Sans","Overpass","PT Sans Narrow","Raleway","Times New Roman","Verdana","sans-serif","serif","monospace"],"value":["Arial","Balto","Courier New","Droid Sans","Droid Serif","Droid Sans Mono","Gravitas One","Old Standard TT","Open Sans","Overpass","PT Sans Narrow","Raleway","Times New Roman","Verdana","sans-serif","serif","monospace"]}},"config":{"multiple":false,"search":true,"selectedValue":"Arial","hideClearButton":true,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":false,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":true,"disableOptionGroupCheckbox":true,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify4665094', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Font family of the legend title and entry labels.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour" id="tipify7730277">
#>             <label class="control-label" for="gsea-legend.font.color">Legend Font Color</label>
#>             <input id="gsea-legend.font.color" type="text" class="form-control shiny-colour-input" data-init-value="#000000" data-show-colour="both" data-palette="square"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify7730277', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Font color of the legend title and entry labels.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify221171">
#>             <label class="control-label" id="gsea-legend.title.size-label" for="gsea-legend.title.size">Legend Title Size</label>
#>             <input id="gsea-legend.title.size" type="number" class="shiny-input-number form-control" value="14" data-update-on="change" min="0" step="1"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify221171', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Font size of the legend title.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify8150232">
#>             <label class="control-label" id="gsea-legend.text.size-label" for="gsea-legend.text.size">Legend Text Size</label>
#>             <input id="gsea-legend.text.size" type="number" class="shiny-input-number form-control" value="12" data-update-on="change" min="0" step="1"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify8150232', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Font size of the legend entry labels.'})}, 500)});</script>
#>         </div>
#>       </div>
#>     </div>
#>     <div class="tab-pane" data-value="Axes" id="tab-7840-4">
#>       <div class="vizmodules-input-grid" style="--viz-input-columns: 2;">
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" style="width:100%;">
#>             <label class="control-label" id="gsea-title.font.family-label" for="gsea-title.font.family">Title Font</label>
#>             <div id="gsea-title.font.family" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="change">
#>               <script type="application/json" data-for="gsea-title.font.family">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["Arial","Balto","Courier New","Droid Sans","Droid Serif","Droid Sans Mono","Gravitas One","Old Standard TT","Open Sans","Overpass","PT Sans Narrow","Raleway","Times New Roman","Verdana","sans-serif","serif","monospace"],"value":["Arial","Balto","Courier New","Droid Sans","Droid Serif","Droid Sans Mono","Gravitas One","Old Standard TT","Open Sans","Overpass","PT Sans Narrow","Raleway","Times New Roman","Verdana","sans-serif","serif","monospace"]}},"config":{"multiple":false,"search":true,"selectedValue":"Arial","hideClearButton":true,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":false,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":true,"disableOptionGroupCheckbox":true,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>             </div>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour">
#>             <label class="control-label" for="gsea-title.font.color">Title Color</label>
#>             <input id="gsea-title.font.color" type="text" class="form-control shiny-colour-input" data-init-value="#000000" data-show-colour="both" data-palette="square"/>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="gsea-title.font.size-label" for="gsea-title.font.size">Title Size</label>
#>             <input id="gsea-title.font.size" type="number" class="shiny-input-number form-control" value="26" data-update-on="change" min="1" step="1"/>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="gsea-axis.title.horizontal.position-label" for="gsea-axis.title.horizontal.position">Title position</label>
#>             <input id="gsea-axis.title.horizontal.position" type="number" class="shiny-input-number form-control" value="0.5" data-update-on="change" min="0" max="1" step="0.1"/>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="gsea-axis.title.font.size-label" for="gsea-axis.title.font.size">Axis Title Size</label>
#>             <input id="gsea-axis.title.font.size" type="number" class="shiny-input-number form-control" value="18" data-update-on="change" min="1" step="1"/>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour">
#>             <label class="control-label" for="gsea-axis.title.font.color">Axis Title Color</label>
#>             <input id="gsea-axis.title.font.color" type="text" class="form-control shiny-colour-input" data-init-value="#000000" data-show-colour="both" data-palette="square"/>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" style="width:100%;">
#>             <label class="control-label" id="gsea-axis.title.font.family-label" for="gsea-axis.title.font.family">Axis Title Font</label>
#>             <div id="gsea-axis.title.font.family" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="change">
#>               <script type="application/json" data-for="gsea-axis.title.font.family">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["Arial","Balto","Courier New","Droid Sans","Droid Serif","Droid Sans Mono","Gravitas One","Old Standard TT","Open Sans","Overpass","PT Sans Narrow","Raleway","Times New Roman","Verdana","sans-serif","serif","monospace"],"value":["Arial","Balto","Courier New","Droid Sans","Droid Serif","Droid Sans Mono","Gravitas One","Old Standard TT","Open Sans","Overpass","PT Sans Narrow","Raleway","Times New Roman","Verdana","sans-serif","serif","monospace"]}},"config":{"multiple":false,"search":true,"selectedValue":"Arial","hideClearButton":true,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":false,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":true,"disableOptionGroupCheckbox":true,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>             </div>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container">
#>             <div class="checkbox">
#>               <label>
#>                 <input id="gsea-axis.showline" type="checkbox" class="shiny-input-checkbox" checked="checked"/>
#>                 <span>Show Axis Borders</span>
#>               </label>
#>             </div>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container">
#>             <div class="checkbox">
#>               <label>
#>                 <input id="gsea-axis.mirror" type="checkbox" class="shiny-input-checkbox" checked="checked"/>
#>                 <span>Mirror Axis Borders</span>
#>               </label>
#>             </div>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container">
#>             <div class="checkbox">
#>               <label>
#>                 <input id="gsea-show.grid.x" type="checkbox" class="shiny-input-checkbox" checked="checked"/>
#>                 <span>Show X Gridlines</span>
#>               </label>
#>             </div>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container">
#>             <div class="checkbox">
#>               <label>
#>                 <input id="gsea-show.grid.y" type="checkbox" class="shiny-input-checkbox" checked="checked"/>
#>                 <span>Show Y Gridlines</span>
#>               </label>
#>             </div>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour">
#>             <label class="control-label" for="gsea-grid.color">Gridline Color</label>
#>             <input id="gsea-grid.color" type="text" class="form-control shiny-colour-input" data-init-value="#CCCCCC" data-show-colour="both" data-palette="square"/>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour">
#>             <label class="control-label" for="gsea-axis.linecolor">Axis Line Color</label>
#>             <input id="gsea-axis.linecolor" type="text" class="form-control shiny-colour-input" data-init-value="black" data-show-colour="both" data-palette="square"/>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="gsea-axis.linewidth-label" for="gsea-axis.linewidth">Axis Line Width</label>
#>             <input id="gsea-axis.linewidth" type="number" class="shiny-input-number form-control" value="0.5" data-update-on="change" min="0" step="0.1"/>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="gsea-axis.tickfont.size-label" for="gsea-axis.tickfont.size">Tick Label Size</label>
#>             <input id="gsea-axis.tickfont.size" type="number" class="shiny-input-number form-control" value="12" data-update-on="change" min="1" step="1"/>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour">
#>             <label class="control-label" for="gsea-axis.tickfont.color">Tick Label Color</label>
#>             <input id="gsea-axis.tickfont.color" type="text" class="form-control shiny-colour-input" data-init-value="black" data-show-colour="both" data-palette="square"/>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" style="width:100%;">
#>             <label class="control-label" id="gsea-axis.tickfont.family-label" for="gsea-axis.tickfont.family">Tick Label Font</label>
#>             <div id="gsea-axis.tickfont.family" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="change">
#>               <script type="application/json" data-for="gsea-axis.tickfont.family">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["Arial","Balto","Courier New","Droid Sans","Droid Serif","Droid Sans Mono","Gravitas One","Old Standard TT","Open Sans","Overpass","PT Sans Narrow","Raleway","Times New Roman","Verdana","sans-serif","serif","monospace"],"value":["Arial","Balto","Courier New","Droid Sans","Droid Serif","Droid Sans Mono","Gravitas One","Old Standard TT","Open Sans","Overpass","PT Sans Narrow","Raleway","Times New Roman","Verdana","sans-serif","serif","monospace"]}},"config":{"multiple":false,"search":true,"selectedValue":"Arial","hideClearButton":true,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":false,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":true,"disableOptionGroupCheckbox":true,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>             </div>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="gsea-axis.tickangle.x-label" for="gsea-axis.tickangle.x">X Tick Label Angle</label>
#>             <input id="gsea-axis.tickangle.x" type="number" class="shiny-input-number form-control" value="0" data-update-on="change" min="-180" max="180" step="15"/>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="gsea-axis.tickangle.y-label" for="gsea-axis.tickangle.y">Y Tick Label Angle</label>
#>             <input id="gsea-axis.tickangle.y" type="number" class="shiny-input-number form-control" value="0" data-update-on="change" min="-180" max="180" step="15"/>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" style="width:100%;">
#>             <label class="control-label" id="gsea-axis.ticks-label" for="gsea-axis.ticks">Tick Position</label>
#>             <div id="gsea-axis.ticks" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="change">
#>               <script type="application/json" data-for="gsea-axis.ticks">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["Outside","Inside","(none)"],"value":["outside","inside",""]}},"config":{"multiple":false,"search":false,"selectedValue":"outside","hideClearButton":true,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":false,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":true,"disableOptionGroupCheckbox":true,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>             </div>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour">
#>             <label class="control-label" for="gsea-axis.tickcolor">Tick Mark Color</label>
#>             <input id="gsea-axis.tickcolor" type="text" class="form-control shiny-colour-input" data-init-value="black" data-show-colour="both" data-palette="square"/>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="gsea-axis.ticklen-label" for="gsea-axis.ticklen">Tick Mark Length</label>
#>             <input id="gsea-axis.ticklen" type="number" class="shiny-input-number form-control" value="5" data-update-on="change" min="0" step="1"/>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="gsea-axis.tickwidth-label" for="gsea-axis.tickwidth">Tick Mark Width</label>
#>             <input id="gsea-axis.tickwidth" type="number" class="shiny-input-number form-control" value="1" data-update-on="change" min="0" step="0.1"/>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="gsea-facet.title.font.size-label" for="gsea-facet.title.font.size">Facet Subplot Title Size</label>
#>             <input id="gsea-facet.title.font.size" type="number" class="shiny-input-number form-control" value="18" data-update-on="change" min="1" step="1"/>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour">
#>             <label class="control-label" for="gsea-facet.title.font.color">Facet Title Color</label>
#>             <input id="gsea-facet.title.font.color" type="text" class="form-control shiny-colour-input" data-init-value="#000000" data-show-colour="both" data-palette="square"/>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" style="width:100%;">
#>             <label class="control-label" id="gsea-facet.title.font.family-label" for="gsea-facet.title.font.family">Facet Title Font</label>
#>             <div id="gsea-facet.title.font.family" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="change">
#>               <script type="application/json" data-for="gsea-facet.title.font.family">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["Arial","Balto","Courier New","Droid Sans","Droid Serif","Droid Sans Mono","Gravitas One","Old Standard TT","Open Sans","Overpass","PT Sans Narrow","Raleway","Times New Roman","Verdana","sans-serif","serif","monospace"],"value":["Arial","Balto","Courier New","Droid Sans","Droid Serif","Droid Sans Mono","Gravitas One","Old Standard TT","Open Sans","Overpass","PT Sans Narrow","Raleway","Times New Roman","Verdana","sans-serif","serif","monospace"]}},"config":{"multiple":false,"search":true,"selectedValue":"Arial","hideClearButton":true,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":false,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":true,"disableOptionGroupCheckbox":true,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>             </div>
#>           </div>
#>         </div>
#>       </div>
#>     </div>
#>     <div class="tab-pane" data-value="Plotly" id="tab-7840-5">
#>       <div class="vizmodules-input-grid" style="--viz-input-columns: 2;">
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" style="width:100%;">
#>             <label class="control-label" id="gsea-download.format-label" for="gsea-download.format">Download Format</label>
#>             <div id="gsea-download.format" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="change">
#>               <script type="application/json" data-for="gsea-download.format">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["svg","png","jpeg","webp"],"value":["svg","png","jpeg","webp"]}},"config":{"multiple":false,"search":false,"selectedValue":"svg","hideClearButton":true,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":false,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":true,"disableOptionGroupCheckbox":true,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>             </div>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify3038334">
#>             <label class="control-label" id="gsea-margin.t-label" for="gsea-margin.t">Margin Top</label>
#>             <input id="gsea-margin.t" type="number" class="shiny-input-number form-control" value="70" data-update-on="change" min="0" step="5"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify3038334', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Top margin of the plot in pixels'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify9317958">
#>             <label class="control-label" id="gsea-margin.b-label" for="gsea-margin.b">Margin Bottom</label>
#>             <input id="gsea-margin.b" type="number" class="shiny-input-number form-control" value="70" data-update-on="change" min="0" step="5"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify9317958', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Bottom margin of the plot in pixels'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify5404310">
#>             <label class="control-label" id="gsea-margin.l-label" for="gsea-margin.l">Margin Left</label>
#>             <input id="gsea-margin.l" type="number" class="shiny-input-number form-control" value="70" data-update-on="change" min="0" step="5"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify5404310', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Left margin of the plot in pixels'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify2548184">
#>             <label class="control-label" id="gsea-margin.r-label" for="gsea-margin.r">Margin Right</label>
#>             <input id="gsea-margin.r" type="number" class="shiny-input-number form-control" value="90" data-update-on="change" min="0" step="5"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify2548184', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Right margin of the plot in pixels'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour" id="tipify4775874">
#>             <label class="control-label" for="gsea-shape.fill">Shape Fill</label>
#>             <input id="gsea-shape.fill" type="text" class="form-control shiny-colour-input" data-init-value="rgba(0, 0, 0, 0)" data-show-colour="both" data-palette="square" data-allow-alpha="true"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify4775874', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Interior fill color for shapes drawn on the plot using Plotly&#39;s drawing tools'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour" id="tipify7044640">
#>             <label class="control-label" for="gsea-shape.line.color">Shape Line Color</label>
#>             <input id="gsea-shape.line.color" type="text" class="form-control shiny-colour-input" data-init-value="black" data-show-colour="both" data-palette="square" data-allow-alpha="true"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify7044640', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Outline color for shapes drawn on the plot using Plotly&#39;s drawing tools'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify75056">
#>             <label class="control-label" id="gsea-shape.line.width-label" for="gsea-shape.line.width">Shape Line Width</label>
#>             <input id="gsea-shape.line.width" type="number" class="shiny-input-number form-control" value="4" data-update-on="change" min="0" step="0.25"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify75056', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Outline width for shapes drawn on the plot using Plotly&#39;s drawing tools'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" style="width:100%;" id="tipify7724088">
#>             <label class="control-label" id="gsea-shape.linetype-label" for="gsea-shape.linetype">Shape Linetype</label>
#>             <div id="gsea-shape.linetype" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="change">
#>               <script type="application/json" data-for="gsea-shape.linetype">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["solid","dot","dash","longdash","dashdot","longdashdot"],"value":["solid","dot","dash","longdash","dashdot","longdashdot"]}},"config":{"multiple":false,"search":false,"selectedValue":"solid","hideClearButton":true,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":false,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":true,"disableOptionGroupCheckbox":true,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify7724088', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Line dash style for shapes drawn on the plot using Plotly&#39;s drawing tools'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify2657936">
#>             <label class="control-label" id="gsea-shape.opacity-label" for="gsea-shape.opacity">Shape Opacity</label>
#>             <input id="gsea-shape.opacity" type="number" class="shiny-input-number form-control" value="1" data-update-on="change" min="0" max="1" step="0.01"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify2657936', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Opacity of shapes drawn on the plot, where 0 is fully transparent and 1 is fully opaque'})}, 500)});</script>
#>         </div>
#>       </div>
#>     </div>
#>   </div>
#> </div>
#> <div class="module-tack" style="margin-top: 12px;">
#>   <div class="module-tack-switch" style="margin-bottom: 4px;">
#>     <div class="form-group shiny-input-container">
#>       <div class="material-switch">
#>         <label for="gsea-auto.update" style="padding-right: 10px;">Auto Update</label>
#>         <input id="gsea-auto.update" type="checkbox" checked="checked"/>
#>         <label class="switch label-success bg-success" for="gsea-auto.update"></label>
#>       </div>
#>     </div>
#>   </div>
#>   <div class="module-tack-buttons" style="display: flex; flex-wrap: wrap; gap: 8px;">
#>     <button class="btn btn-default action-button btn-primary" id="gsea-update" style="flex: 1 1 45%;" type="button"><span class="action-label">Update</span></button>
#>     <button class="btn btn-default action-button btn-secondary" id="gsea-reset" style="flex: 1 1 45%;" type="button"><span class="action-label">Reset</span></button>
#>     <a aria-disabled="true" class="btn btn-default shiny-download-link disabled btn-secondary viz-source-download" data-viz-source-ns="gsea-" download href="" id="gsea-download.source" style="flex: 1 1 100%;" tabindex="-1" target="_blank">
#>       <i class="far fa-file-code" role="presentation" aria-label="file-code icon"></i>
#>       Source Download
#>     </a>
#>     <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('gsea-download.source', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Download the plot as a self-contained HTML file and as SVG and PNG images of it as it looks now, along with the plot source data and statistics (if applicable) as CSV files.'})}, 500)});</script>
#>   </div>
#> </div>
```
