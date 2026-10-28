# Output UI components for the dose-response module

Thin wrapper over
[`VizModules::dittoViz_scatterPlotOutputUI()`](https://j-andrews7.github.io/VizModules/reference/dittoViz_scatterPlotOutputUI.html).

## Usage

``` r
doseResponseOutputUI(id, resizable = TRUE)
```

## Arguments

- id:

  The ID for the Shiny module.

- resizable:

  Logical; when `TRUE` (the default) the plot output is resizable.

## Value

A Shiny plot output for the dose-response curve.

## Author

Jacob Martin

## Examples

``` r
doseResponseOutputUI("dose")
#> <div class="plotly html-widget html-widget-output shiny-report-size shiny-report-theme html-fill-item" id="dose-scatterPlot" style="width:100%;height:400px;"></div>
#> <iframe srcdoc="&lt;p&gt;cant catch me&lt;/p&gt;" class="jqui_self_cleaning_script" style="width:0;height:0;border:none;display:none !important" onload="$(function(){$(document).one(&#10;            events   = &quot;shiny:value&quot;,&#10;            selector = &quot;[id=&#39;dose-scatterPlot&#39;]&quot;,&#10;            handler  = function(e) { setTimeout(function(){shinyjqui.msgCallback({&quot;ui&quot;:&quot;[id=&#39;dose-scatterPlot&#39;]&quot;,&quot;type&quot;:&quot;interaction&quot;,&quot;func&quot;:&quot;resizable&quot;,&quot;operation&quot;:&quot;enable&quot;,&quot;options&quot;:{},&quot;debug&quot;:false,&quot;_js_idx&quot;:{&quot;ui&quot;:false,&quot;type&quot;:false,&quot;func&quot;:false,&quot;operation&quot;:false,&quot;options&quot;:[],&quot;debug&quot;:false}});&#10;      $(&quot;.jqui_self_cleaning_script&quot;).remove();}, 10); }&#10;        );});"></iframe>
```
