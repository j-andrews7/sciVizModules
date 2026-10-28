# Input UI components for the structureViewer module

This should be placed in the UI where the inputs should be shown, with
an `id` that matches the `id` used in the
[`structureViewerServer()`](https://j-andrews7.github.io/sciVizModules/reference/structureViewerServer.md)
and
[`structureViewerOutputUI()`](https://j-andrews7.github.io/sciVizModules/reference/structureViewerOutputUI.md)
functions.

## Usage

``` r
structureViewerInputsUI(
  id,
  data,
  defaults = NULL,
  title = "Structure Viewer Settings",
  columns = 2
)
```

## Arguments

- id:

  The ID for the Shiny module.

- data:

  An object from
  [`read_structure()`](https://j-andrews7.github.io/sciVizModules/reference/read_structure.md).

- defaults:

  A named list of default values for the inputs.

- title:

  An optional title for the UI grid.

- columns:

  Number of columns for the UI grid.

## Value

A Shiny tagList containing the UI elements

## Details

The module shows a protein or nucleic-acid structure from
[`read_structure()`](https://j-andrews7.github.io/sciVizModules/reference/read_structure.md)
in an interactive 3D viewer (see
[`structureViewer()`](https://j-andrews7.github.io/sciVizModules/reference/structureViewer.md)).
Changing the style, colours or highlighted residues restyles the
structure in place, so the view you have rotated to is kept.

This module is **not a plotly figure**: plotly has no molecular
graphics, so it uses the NGL viewer (NGLVieweR) instead. It therefore
has no Figure Builder support and no plotly export, and its control
strip carries its own buttons: **Snapshot (PNG)** saves the current
view, and **Download Structure** saves the structure file.

## Plot parameters and defaults

The following parameters can be accessed via UI inputs and/or the
`defaults` argument:

- `representation` - Polymer representation (default: `"cartoon"`)

- `color.by` - Colour scheme: `"plddt"` (AlphaFold DB bands),
  `"bfactor"`, `"chainname"`, `"residueindex"`, `"sstruc"`,
  `"hydrophobicity"` or `"element"` (default: `"plddt"` for an AlphaFold
  model, else `"chainname"`)

- `background` - Background colour (default: "#FFFFFF")

- `quality` - Rendering quality (default: `"medium"`)

- `highlight.residues` - Residues to highlight, e.g.
  `"175, 245-250, B:12"` (default: none)

- `highlight.color` - Highlight colour (default: "#E7298A")

- `highlight.representation` - Highlight representation (default:
  `"ball+stick"`)

- `show.ligands` - Draw ligands and ions (default: TRUE)

- `spin` - Spin the structure (default: FALSE)

## See also

[`structureViewer()`](https://j-andrews7.github.io/sciVizModules/reference/structureViewer.md),
[`read_structure()`](https://j-andrews7.github.io/sciVizModules/reference/read_structure.md),
[`structureViewerOutputUI()`](https://j-andrews7.github.io/sciVizModules/reference/structureViewerOutputUI.md),
[`structureViewerServer()`](https://j-andrews7.github.io/sciVizModules/reference/structureViewerServer.md),
[`structureViewerApp()`](https://j-andrews7.github.io/sciVizModules/reference/structureViewerApp.md)

## Author

Jared Andrews

## Examples

``` r
library(sciVizModules)
p53 <- read_structure(system.file("extdata", "AF-P04637-F1-model_v6.pdb.gz",
    package = "sciVizModules"))
structureViewerInputsUI("viewer", p53)
#> <h3>Structure Viewer Settings</h3>
#> <div class="tabbable vizmodules-input-tabs">
#>   <ul class="nav nav-tabs shiny-tab-input" id="viewer-structureViewerTabsetPanel" data-tabsetid="9440">
#>     <li class="active">
#>       <a href="#tab-9440-1" data-toggle="tab" data-bs-toggle="tab" data-value="Style">Style</a>
#>     </li>
#>     <li>
#>       <a href="#tab-9440-2" data-toggle="tab" data-bs-toggle="tab" data-value="Highlight">Highlight</a>
#>     </li>
#>     <li>
#>       <a href="#tab-9440-3" data-toggle="tab" data-bs-toggle="tab" data-value="View">View</a>
#>     </li>
#>   </ul>
#>   <div class="tab-content" data-tabsetid="9440">
#>     <div class="tab-pane active" data-value="Style" id="tab-9440-1">
#>       <div class="vizmodules-input-grid" style="--viz-input-columns: 2;">
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" style="width:100%;" id="tipify3682134">
#>             <label class="control-label" id="viewer-representation-label" for="viewer-representation">Representation</label>
#>             <div id="viewer-representation" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="change">
#>               <script type="application/json" data-for="viewer-representation">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["Cartoon","Backbone","Ribbon","Rope","Surface","Ball and stick","Licorice","Spacefill"],"value":["cartoon","backbone","ribbon","rope","surface","ball+stick","licorice","spacefill"]}},"config":{"multiple":false,"search":false,"selectedValue":"cartoon","hideClearButton":true,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":false,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":true,"disableOptionGroupCheckbox":true,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify3682134', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'How the polymer is drawn.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" style="width:100%;" id="tipify6049454">
#>             <label class="control-label" id="viewer-color.by-label" for="viewer-color.by">Color By</label>
#>             <div id="viewer-color.by" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="change">
#>               <script type="application/json" data-for="viewer-color.by">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["pLDDT (AlphaFold)","B-factor","Chain","Rainbow (N to C)","Secondary structure","Hydrophobicity","Element"],"value":["plddt","bfactor","chainname","residueindex","sstruc","hydrophobicity","element"]}},"config":{"multiple":false,"search":false,"selectedValue":"plddt","hideClearButton":true,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":false,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":true,"disableOptionGroupCheckbox":true,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify6049454', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Colour scheme. pLDDT uses the AlphaFold DB confidence bands from the B-factor column (very high > 90, confident 70-90, low 50-70, very low < 50).'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour" id="tipify8440193">
#>             <label class="control-label" for="viewer-background">Background</label>
#>             <input id="viewer-background" type="text" class="form-control shiny-colour-input" data-init-value="#FFFFFF" data-show-colour="both" data-palette="square"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify8440193', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Background colour.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" style="width:100%;" id="tipify7013902">
#>             <label class="control-label" id="viewer-quality-label" for="viewer-quality">Quality</label>
#>             <div id="viewer-quality" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="change">
#>               <script type="application/json" data-for="viewer-quality">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["Low","Medium","High"],"value":["low","medium","high"]}},"config":{"multiple":false,"search":false,"selectedValue":"medium","hideClearButton":true,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":false,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":true,"disableOptionGroupCheckbox":true,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify7013902', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Rendering quality; lower is faster for large structures.'})}, 500)});</script>
#>         </div>
#>       </div>
#>     </div>
#>     <div class="tab-pane" data-value="Highlight" id="tab-9440-2">
#>       <div class="vizmodules-input-grid" style="--viz-input-columns: 2;">
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify6458006">
#>             <label class="control-label" id="viewer-highlight.residues-label" for="viewer-highlight.residues">Residues</label>
#>             <input id="viewer-highlight.residues" type="text" class="shiny-input-text form-control" value="" placeholder="175, 245-250, B:12" data-update-on="change"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify6458006', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Residue numbers and ranges to highlight, optionally prefixed with a chain and a colon.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour" id="tipify2811637">
#>             <label class="control-label" for="viewer-highlight.color">Highlight Color</label>
#>             <input id="viewer-highlight.color" type="text" class="form-control shiny-colour-input" data-init-value="#E7298A" data-show-colour="both" data-palette="square"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify2811637', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Colour of the highlighted residues.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" style="width:100%;" id="tipify7462186">
#>             <label class="control-label" id="viewer-highlight.representation-label" for="viewer-highlight.representation">Highlight Style</label>
#>             <div id="viewer-highlight.representation" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="change">
#>               <script type="application/json" data-for="viewer-highlight.representation">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["Ball and stick","Licorice","Spacefill","Surface"],"value":["ball+stick","licorice","spacefill","surface"]}},"config":{"multiple":false,"search":false,"selectedValue":"ball+stick","hideClearButton":true,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":false,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":true,"disableOptionGroupCheckbox":true,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify7462186', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'How the highlighted residues are drawn.'})}, 500)});</script>
#>         </div>
#>       </div>
#>     </div>
#>     <div class="tab-pane" data-value="View" id="tab-9440-3">
#>       <div class="vizmodules-input-grid" style="--viz-input-columns: 2;">
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify8269547">
#>             <div class="material-switch">
#>               <label for="viewer-show.ligands" style="padding-right: 10px;">Ligands and Ions</label>
#>               <input id="viewer-show.ligands" type="checkbox" checked="checked"/>
#>               <label class="switch label-success bg-success" for="viewer-show.ligands"></label>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify8269547', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Draw ligands and ions as ball-and-stick.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify7042313">
#>             <div class="material-switch">
#>               <label for="viewer-spin" style="padding-right: 10px;">Spin</label>
#>               <input id="viewer-spin" type="checkbox"/>
#>               <label class="switch label-success bg-success" for="viewer-spin"></label>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify7042313', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Spin the structure about its vertical axis.'})}, 500)});</script>
#>         </div>
#>       </div>
#>     </div>
#>   </div>
#> </div>
#> <div class="sci-structure-viewer-tack">
#>   <button class="btn btn-default action-button btn-sm" id="viewer-reset" type="button"><span class="action-label">Reset</span></button>
#>   <button class="btn btn-default action-button btn-sm" id="viewer-snapshot" type="button"><span class="action-label">Snapshot (PNG)</span></button>
#>   <a aria-disabled="true" class="btn btn-default shiny-download-link disabled btn-sm btn-secondary" download href="" id="viewer-download.structure" tabindex="-1" target="_blank">
#>     <i class="fas fa-download" role="presentation" aria-label="download icon"></i>
#>     Download Structure
#>   </a>
#> </div>
```
