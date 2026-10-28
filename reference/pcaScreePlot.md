# Scree plot of a PCAtools `pca` object

The interactive counterpart of
[`PCAtools::screeplot()`](https://rdrr.io/pkg/PCAtools/man/screeplot.html):
the percentage of variance each component explains, with the cumulative
percentage as a line. The elbow of the curve
([`PCAtools::findElbowPoint()`](https://rdrr.io/pkg/PCAtools/man/findElbowPoint.html),
when PCAtools is installed) and any other components you choose (e.g.
the number retained by
[`PCAtools::parallelPCA()`](https://rdrr.io/pkg/PCAtools/man/parallelPCA.html),
which needs the original data matrix) can be marked with vertical lines.

## Usage

``` r
pcaScreePlot(
  pcaobj,
  components = NULL,
  show.cumulative = TRUE,
  show.elbow = TRUE,
  mark.components = NULL,
  bar.color = "#1E90FF",
  line.color = "#CD2626",
  main = NULL
)
```

## Arguments

- pcaobj:

  A PCAtools `pca` object.

- components:

  Components to show, by name. Default: the first 20.

- show.cumulative:

  Logical; draw the cumulative percentage line.

- show.elbow:

  Logical; mark the elbow component.

- mark.components:

  Integer indices of further components to mark.

- bar.color, line.color:

  Colours of the bars and the cumulative line.

- main:

  Optional plot title.

## Value

A `plotly` object. The table it draws is attached as attribute
`"table"`.

## See also

[`pcaScreePlotServer()`](https://j-andrews7.github.io/sciVizModules/reference/pcaScreePlotServer.md),
[`PCAtools::screeplot()`](https://rdrr.io/pkg/PCAtools/man/screeplot.html)

## Author

Jared Andrews

## Examples

``` r
data(example_pca)
pcaScreePlot(example_pca)

{"x":{"visdat":{"192d2f3968ab":["function () ","plotlyVisDat"]},"cur_data":"192d2f3968ab","attrs":{"192d2f3968ab":{"alpha_stroke":1,"sizes":[10,100],"spans":[1,20],"x":{},"y":{},"type":"bar","name":"Explained","text":["PC1<br>Explained: 40.79%<br>Cumulative: 40.79%","PC2<br>Explained: 26.20%<br>Cumulative: 66.99%","PC3<br>Explained: 16.93%<br>Cumulative: 83.92%","PC4<br>Explained: 12.89%<br>Cumulative: 96.80%","PC5<br>Explained: 1.61%<br>Cumulative: 98.42%","PC6<br>Explained: 1.04%<br>Cumulative: 99.45%","PC7<br>Explained: 0.55%<br>Cumulative: 100.00%","PC8<br>Explained: 0.00%<br>Cumulative: 100.00%"],"hoverinfo":"text","textposition":"none","marker":{"color":"#1E90FF"},"inherit":true},"192d2f3968ab.1":{"alpha_stroke":1,"sizes":[10,100],"spans":[1,20],"x":{},"y":{},"type":"scatter","mode":"lines+markers","name":"Cumulative","text":["PC1<br>Explained: 40.79%<br>Cumulative: 40.79%","PC2<br>Explained: 26.20%<br>Cumulative: 66.99%","PC3<br>Explained: 16.93%<br>Cumulative: 83.92%","PC4<br>Explained: 12.89%<br>Cumulative: 96.80%","PC5<br>Explained: 1.61%<br>Cumulative: 98.42%","PC6<br>Explained: 1.04%<br>Cumulative: 99.45%","PC7<br>Explained: 0.55%<br>Cumulative: 100.00%","PC8<br>Explained: 0.00%<br>Cumulative: 100.00%"],"hoverinfo":"text","line":{"color":"#CD2626","width":2},"marker":{"color":"#CD2626","size":7},"inherit":true}},"layout":{"margin":{"b":40,"l":60,"t":25,"r":10},"title":{"text":""},"xaxis":{"domain":[0,1],"automargin":true,"title":{"text":"Principal component"},"type":"category","categoryorder":"array","categoryarray":["PC1","PC2","PC3","PC4","PC5","PC6","PC7","PC8"]},"yaxis":{"domain":[0,1],"automargin":true,"title":{"text":"Explained variance (%)"},"range":[0,105]},"shapes":[{"type":"line","x0":4,"x1":4,"xref":"x","y0":0,"y1":1,"yref":"paper","line":{"color":"#000000","dash":"dash","width":1}}],"annotations":[{"x":4,"xref":"x","y":1,"yref":"paper","yanchor":"bottom","text":"Elbow (PC5)","showarrow":false}],"hovermode":"closest","showlegend":true},"source":"A","config":{"modeBarButtonsToAdd":["hoverclosest","hovercompare"],"showSendToCloud":false},"data":[{"x":["PC1","PC2","PC3","PC4","PC5","PC6","PC7","PC8"],"y":[40.785520710779863,26.201884605070546,16.929464024216294,12.887891484605079,1.6107096565962917,1.035196950596678,0.54933256813521325,4.506526897320925e-29],"type":"bar","name":"Explained","text":["PC1<br>Explained: 40.79%<br>Cumulative: 40.79%","PC2<br>Explained: 26.20%<br>Cumulative: 66.99%","PC3<br>Explained: 16.93%<br>Cumulative: 83.92%","PC4<br>Explained: 12.89%<br>Cumulative: 96.80%","PC5<br>Explained: 1.61%<br>Cumulative: 98.42%","PC6<br>Explained: 1.04%<br>Cumulative: 99.45%","PC7<br>Explained: 0.55%<br>Cumulative: 100.00%","PC8<br>Explained: 0.00%<br>Cumulative: 100.00%"],"hoverinfo":["text","text","text","text","text","text","text","text"],"textposition":["none","none","none","none","none","none","none","none"],"marker":{"color":"#1E90FF","line":{"color":"rgba(31,119,180,1)"}},"error_y":{"color":"rgba(31,119,180,1)"},"error_x":{"color":"rgba(31,119,180,1)"},"xaxis":"x","yaxis":"y","frame":null},{"x":["PC1","PC2","PC3","PC4","PC5","PC6","PC7","PC8"],"y":[40.785520710779863,66.98740531585041,83.916869340066711,96.804760824671789,98.415470481268073,99.450667431864758,99.999999999999972,99.999999999999972],"type":"scatter","mode":"lines+markers","name":"Cumulative","text":["PC1<br>Explained: 40.79%<br>Cumulative: 40.79%","PC2<br>Explained: 26.20%<br>Cumulative: 66.99%","PC3<br>Explained: 16.93%<br>Cumulative: 83.92%","PC4<br>Explained: 12.89%<br>Cumulative: 96.80%","PC5<br>Explained: 1.61%<br>Cumulative: 98.42%","PC6<br>Explained: 1.04%<br>Cumulative: 99.45%","PC7<br>Explained: 0.55%<br>Cumulative: 100.00%","PC8<br>Explained: 0.00%<br>Cumulative: 100.00%"],"hoverinfo":["text","text","text","text","text","text","text","text"],"line":{"color":"#CD2626","width":2},"marker":{"color":"#CD2626","size":7,"line":{"color":"rgba(255,127,14,1)"}},"error_y":{"color":"rgba(255,127,14,1)"},"error_x":{"color":"rgba(255,127,14,1)"},"xaxis":"x","yaxis":"y","frame":null}],"highlight":{"on":"plotly_click","persistent":false,"dynamic":false,"selectize":false,"opacityDim":0.20000000000000001,"selected":{"opacity":1},"debounce":0},"shinyEvents":["plotly_hover","plotly_click","plotly_selected","plotly_relayout","plotly_brushed","plotly_brushing","plotly_clickannotation","plotly_doubleclick","plotly_deselect","plotly_afterplot","plotly_sunburstclick"],"base_url":"https://plot.ly"},"evals":[],"jsHooks":[]}
```
