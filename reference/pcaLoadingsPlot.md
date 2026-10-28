# Loadings plot of a PCAtools `pca` object

The interactive counterpart of
[`PCAtools::plotloadings()`](https://rdrr.io/pkg/PCAtools/man/plotloadings.html).
For each chosen component, the variables whose loading lies within
`range.retain` of either end of that component's loading range are
retained (PCAtools' `rangeRetain` rule), and every retained variable's
loading is drawn on every chosen component, coloured by its value.

## Usage

``` r
pcaLoadingsPlot(
  pcaobj,
  components = NULL,
  range.retain = 0.05,
  absolute = FALSE,
  low.color = "#FFD700",
  mid.color = "#FFFFFF",
  high.color = "#4169E1",
  point.size = 12,
  show.labels = TRUE,
  label.size = 10,
  main = NULL
)
```

## Arguments

- pcaobj:

  A PCAtools `pca` object.

- components:

  Components to show, by name. Default: the first 5.

- range.retain:

  Fraction of each component's loading range, at either end, within
  which variables are retained.

- absolute:

  Logical; plot absolute loadings.

- low.color, mid.color, high.color:

  Colour scale for negative, zero and positive loadings.

- point.size:

  Marker size.

- show.labels:

  Logical; label each point with its variable name.

- label.size:

  Label font size.

- main:

  Optional plot title.

## Value

A `plotly` object, with the long table it draws as attribute `"table"`.

## See also

[`pcaLoadingsPlotServer()`](https://j-andrews7.github.io/sciVizModules/reference/pcaLoadingsPlotServer.md),
[`PCAtools::plotloadings()`](https://rdrr.io/pkg/PCAtools/man/plotloadings.html)

## Author

Jared Andrews

## Examples

``` r
data(example_pca)
pcaLoadingsPlot(example_pca, components = c("PC1", "PC2"))

{"x":{"visdat":{"312a14abba5e":["function () ","plotlyVisDat"]},"cur_data":"312a14abba5e","attrs":{"312a14abba5e":{"x":{},"y":{},"mode":"markers+text","text":{},"textposition":"middle right","textfont":{"size":10},"hovertext":["ZBTB16<br>PC1 loading: 0.1368","VCAM1<br>PC1 loading: -0.0962","RPS4Y1<br>PC1 loading: -0.0242","XIST<br>PC1 loading: 0.0213","ZBTB16<br>PC2 loading: -0.0058","VCAM1<br>PC2 loading: 0.0080","RPS4Y1<br>PC2 loading: 0.1602","XIST<br>PC2 loading: -0.1643"],"hoverinfo":"text","showlegend":false,"marker":{"color":[0.13676452394991029,-0.096200047576618236,-0.024151653300179429,0.021348631886772607,-0.0057591561644829278,0.0080138508309003063,0.16019496837537486,-0.16430599899925805],"size":12,"colorscale":[["0","#FFD700"],["0.5","#FFFFFF"],["1","#4169E1"]],"cmin":-0.16430599899925805,"cmax":0.16430599899925805,"line":{"color":"#000000","width":1},"showscale":true,"colorbar":{"title":{"text":"Loading"}}},"alpha_stroke":1,"sizes":[10,100],"spans":[1,20],"type":"scatter"}},"layout":{"margin":{"b":40,"l":60,"t":25,"r":10},"title":{"text":""},"xaxis":{"domain":[0,1],"automargin":true,"title":{"text":"Principal component"},"type":"category","categoryorder":"array","categoryarray":["PC1","PC2"]},"yaxis":{"domain":[0,1],"automargin":true,"title":{"text":"Component loading"}},"shapes":[{"type":"line","x0":0,"x1":1,"xref":"paper","y0":0,"y1":0,"yref":"y","line":{"color":"#000000","dash":"dash","width":1}}],"hovermode":"closest","showlegend":false},"source":"A","config":{"modeBarButtonsToAdd":["hoverclosest","hovercompare"],"showSendToCloud":false},"data":[{"x":["PC1","PC1","PC1","PC1","PC2","PC2","PC2","PC2"],"y":[0.13676452394991029,-0.096200047576618236,-0.024151653300179429,0.021348631886772607,-0.0057591561644829278,0.0080138508309003063,0.16019496837537486,-0.16430599899925805],"mode":"markers+text","text":["ZBTB16","VCAM1","RPS4Y1","XIST","ZBTB16","VCAM1","RPS4Y1","XIST"],"textposition":["middle right","middle right","middle right","middle right","middle right","middle right","middle right","middle right"],"textfont":{"size":10},"hovertext":["ZBTB16<br>PC1 loading: 0.1368","VCAM1<br>PC1 loading: -0.0962","RPS4Y1<br>PC1 loading: -0.0242","XIST<br>PC1 loading: 0.0213","ZBTB16<br>PC2 loading: -0.0058","VCAM1<br>PC2 loading: 0.0080","RPS4Y1<br>PC2 loading: 0.1602","XIST<br>PC2 loading: -0.1643"],"hoverinfo":["text","text","text","text","text","text","text","text"],"showlegend":false,"marker":{"color":[0.13676452394991029,-0.096200047576618236,-0.024151653300179429,0.021348631886772607,-0.0057591561644829278,0.0080138508309003063,0.16019496837537486,-0.16430599899925805],"size":12,"colorscale":[["0","#FFD700"],["0.5","#FFFFFF"],["1","#4169E1"]],"cmin":-0.16430599899925805,"cmax":0.16430599899925805,"line":{"color":"#000000","width":1},"showscale":true,"colorbar":{"title":{"text":"Loading"}}},"type":"scatter","error_y":{"color":"rgba(31,119,180,1)"},"error_x":{"color":"rgba(31,119,180,1)"},"line":{"color":"rgba(31,119,180,1)"},"xaxis":"x","yaxis":"y","frame":null}],"highlight":{"on":"plotly_click","persistent":false,"dynamic":false,"selectize":false,"opacityDim":0.20000000000000001,"selected":{"opacity":1},"debounce":0},"shinyEvents":["plotly_hover","plotly_click","plotly_selected","plotly_relayout","plotly_brushed","plotly_brushing","plotly_clickannotation","plotly_doubleclick","plotly_deselect","plotly_afterplot","plotly_sunburstclick"],"base_url":"https://plot.ly"},"evals":[],"jsHooks":[]}
```
