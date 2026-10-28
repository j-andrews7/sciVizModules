# Output UI components for the cnSegmentPlot module

This should be placed in the UI where the plot should be shown.

## Usage

``` r
cnSegmentPlotOutputUI(id, resizable = TRUE, height = "400px")
```

## Arguments

- id:

  The ID for the Shiny module.

- resizable:

  Logical; when `TRUE` (the default) the plot output is wrapped in
  [`shinyjqui::jqui_resizable()`](https://yang-tang.github.io/shinyjqui/reference/Interactions.html)
  so it can be resized by dragging.

- height:

  Height of the plot container, as a valid CSS unit. Stacked
  multi-sample plots need more room than the `"400px"` default; allow
  roughly 200px per sample. The figure autosizes to the container, so it
  can still be resized by dragging when `resizable` is `TRUE`.

## Value

A Shiny plotlyOutput for the copy number segment plot.

## Author

Jared Andrews

## Examples

``` r
cnSegmentPlotOutputUI("plot")
#> <div class="plotly html-widget html-widget-output shiny-report-size shiny-report-theme html-fill-item" id="plot-cnSegmentPlot" style="width:100%;height:400px;"></div>
#> <iframe srcdoc="&lt;p&gt;cant catch me&lt;/p&gt;" class="jqui_self_cleaning_script" style="width:0;height:0;border:none;display:none !important" onload="$(function(){$(document).one(&#10;            events   = &quot;shiny:value&quot;,&#10;            selector = &quot;[id=&#39;plot-cnSegmentPlot&#39;]&quot;,&#10;            handler  = function(e) { setTimeout(function(){shinyjqui.msgCallback({&quot;ui&quot;:&quot;[id=&#39;plot-cnSegmentPlot&#39;]&quot;,&quot;type&quot;:&quot;interaction&quot;,&quot;func&quot;:&quot;resizable&quot;,&quot;operation&quot;:&quot;enable&quot;,&quot;options&quot;:{},&quot;debug&quot;:false,&quot;_js_idx&quot;:{&quot;ui&quot;:false,&quot;type&quot;:false,&quot;func&quot;:false,&quot;operation&quot;:false,&quot;options&quot;:[],&quot;debug&quot;:false}});&#10;      $(&quot;.jqui_self_cleaning_script&quot;).remove();}, 10); }&#10;        );});"></iframe>
# Room for a stack of four samples:
cnSegmentPlotOutputUI("plot", height = "800px")
#> <div class="plotly html-widget html-widget-output shiny-report-size shiny-report-theme html-fill-item" id="plot-cnSegmentPlot" style="width:100%;height:800px;"></div>
#> <iframe srcdoc="&lt;p&gt;cant catch me&lt;/p&gt;" class="jqui_self_cleaning_script" style="width:0;height:0;border:none;display:none !important" onload="$(function(){$(document).one(&#10;            events   = &quot;shiny:value&quot;,&#10;            selector = &quot;[id=&#39;plot-cnSegmentPlot&#39;]&quot;,&#10;            handler  = function(e) { setTimeout(function(){shinyjqui.msgCallback({&quot;ui&quot;:&quot;[id=&#39;plot-cnSegmentPlot&#39;]&quot;,&quot;type&quot;:&quot;interaction&quot;,&quot;func&quot;:&quot;resizable&quot;,&quot;operation&quot;:&quot;enable&quot;,&quot;options&quot;:{},&quot;debug&quot;:false,&quot;_js_idx&quot;:{&quot;ui&quot;:false,&quot;type&quot;:false,&quot;func&quot;:false,&quot;operation&quot;:false,&quot;options&quot;:[],&quot;debug&quot;:false}});&#10;      $(&quot;.jqui_self_cleaning_script&quot;).remove();}, 10); }&#10;        );});"></iframe>
```
