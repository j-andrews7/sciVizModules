# Output UI components for the dittoScatterPlot module

This should be placed in the UI where the plot should be shown.

## Usage

``` r
dittoScatterPlotOutputUI(id, resizable = TRUE)
```

## Arguments

- id:

  The ID for the Shiny module.

- resizable:

  Logical; when `TRUE` (the default) the plot output is wrapped in
  [`shinyjqui::jqui_resizable()`](https://yang-tang.github.io/shinyjqui/reference/Interactions.html)
  so it can be resized by dragging.

## Value

A Shiny plotlyOutput for the scatter plot.

## Author

Jacob Martin, Jared Andrews

## Examples

``` r
dittoScatterPlotOutputUI("plot")
#> <div class="plotly html-widget html-widget-output shiny-report-size shiny-report-theme html-fill-item" id="plot-dittoScatterPlot" style="width:100%;height:400px;"></div>
#> <iframe srcdoc="&lt;p&gt;cant catch me&lt;/p&gt;" class="jqui_self_cleaning_script" style="width:0;height:0;border:none;display:none !important" onload="$(function(){$(document).one(&#10;            events   = &quot;shiny:value&quot;,&#10;            selector = &quot;[id=&#39;plot-dittoScatterPlot&#39;]&quot;,&#10;            handler  = function(e) { setTimeout(function(){shinyjqui.msgCallback({&quot;ui&quot;:&quot;[id=&#39;plot-dittoScatterPlot&#39;]&quot;,&quot;type&quot;:&quot;interaction&quot;,&quot;func&quot;:&quot;resizable&quot;,&quot;operation&quot;:&quot;enable&quot;,&quot;options&quot;:{},&quot;debug&quot;:false,&quot;_js_idx&quot;:{&quot;ui&quot;:false,&quot;type&quot;:false,&quot;func&quot;:false,&quot;operation&quot;:false,&quot;options&quot;:[],&quot;debug&quot;:false}});&#10;      $(&quot;.jqui_self_cleaning_script&quot;).remove();}, 10); }&#10;        );});"></iframe>
```
