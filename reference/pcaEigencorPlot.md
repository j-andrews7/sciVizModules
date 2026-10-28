# PC-metadata correlation plot of a PCAtools `pca` object

The interactive counterpart of
[`PCAtools::eigencorplot()`](https://rdrr.io/pkg/PCAtools/man/eigencorplot.html):
the correlation of each component's sample scores with each metadata
variable, as a heatmap with the coefficient and its significance in
every cell. Non-numeric metadata are converted to integer codes (factor
level order), as PCAtools requires numeric variables; their labels say
so.

## Usage

``` r
pcaEigencorPlot(
  pcaobj,
  components = NULL,
  metavars = NULL,
  cor.method = "pearson",
  p.adjust.method = "none",
  plot.rsquared = FALSE,
  low.color = "#00008B",
  mid.color = "#FFFFFF",
  high.color = "#8B0000",
  show.values = TRUE,
  digits = 2,
  main = NULL
)
```

## Arguments

- pcaobj:

  A PCAtools `pca` object.

- components:

  Components to correlate, by name. Default: the first 10.

- metavars:

  Metadata columns to correlate. Default: all of them.

- cor.method:

  `"pearson"`, `"spearman"` or `"kendall"`.

- p.adjust.method:

  A [`stats::p.adjust()`](https://rdrr.io/r/stats/p.adjust.html) method,
  applied across every cell.

- plot.rsquared:

  Logical; show R-squared instead of the signed coefficient.

- low.color, mid.color, high.color:

  Colour scale. For R-squared, the scale runs from `mid.color` to
  `high.color`.

- show.values:

  Logical; print the value and significance stars in each cell.

- digits:

  Decimal places of the printed values.

- main:

  Optional plot title.

## Value

A `plotly` object, with the long correlation table (coefficient,
p-value, adjusted p-value) as attribute `"table"`.

## See also

[`pcaEigencorPlotServer()`](https://j-andrews7.github.io/sciVizModules/reference/pcaEigencorPlotServer.md),
[`PCAtools::eigencorplot()`](https://rdrr.io/pkg/PCAtools/man/eigencorplot.html)

## Author

Jared Andrews

## Examples

``` r
data(example_pca)
pcaEigencorPlot(example_pca, components = paste0("PC", 1:5))

{"x":{"visdat":{"192d36576c2e":["function () ","plotlyVisDat"]},"cur_data":"192d36576c2e","attrs":{"192d36576c2e":{"x":["PC1","PC2","PC3","PC4","PC5"],"y":["dex (coded)","cell (coded)","avgLength","lib.size","size.factor"],"z":[[0.96450738996315943,0.13552834594395119,0.13173528199915632,-0.17122820301731526,-0.050851771094598534],[-0.24868547913592201,0.32665447604237163,0.42214301994329229,-0.80423633273968198,-0.066223671077910384],[-0.48308145105440808,0.49257499299378482,0.39007136457465708,-0.22043814432508038,-0.19733024554664302],[-0.1657343246962116,0.68029150432388341,-0.32173997290621115,-0.012944489585734064,-0.33869760752496259],[-0.32132968342793161,0.67252567157268406,-0.27089059435326357,-0.068568494625396145,-0.31877677727723264]],"colorscale":[["0","#00008B"],["0.5","#FFFFFF"],["1","#8B0000"]],"zmin":-1,"zmax":1,"text":[["0.96***","0.14","0.13","-0.17","-0.05"],["-0.25","0.33","0.42","-0.80*","-0.07"],["-0.48","0.49","0.39","-0.22","-0.20"],["-0.17","0.68","-0.32","-0.01","-0.34"],["-0.32","0.67","-0.27","-0.07","-0.32"]],"texttemplate":"%{text}","customdata":[["dex (coded) vs PC1<br>r = 0.965<br>p = 0.00011<br>adj. p = 0.00011","dex (coded) vs PC2<br>r = 0.136<br>p = 0.74898<br>adj. p = 0.74898","dex (coded) vs PC3<br>r = 0.132<br>p = 0.75584<br>adj. p = 0.75584","dex (coded) vs PC4<br>r = -0.171<br>p = 0.68517<br>adj. p = 0.68517","dex (coded) vs PC5<br>r = -0.051<br>p = 0.90482<br>adj. p = 0.90482"],["cell (coded) vs PC1<br>r = -0.249<br>p = 0.55258<br>adj. p = 0.55258","cell (coded) vs PC2<br>r = 0.327<br>p = 0.42970<br>adj. p = 0.42970","cell (coded) vs PC3<br>r = 0.422<br>p = 0.29749<br>adj. p = 0.29749","cell (coded) vs PC4<br>r = -0.804<br>p = 0.01611<br>adj. p = 0.01611","cell (coded) vs PC5<br>r = -0.066<br>p = 0.87619<br>adj. p = 0.87619"],["avgLength vs PC1<br>r = -0.483<br>p = 0.22528<br>adj. p = 0.22528","avgLength vs PC2<br>r = 0.493<br>p = 0.21494<br>adj. p = 0.21494","avgLength vs PC3<br>r = 0.390<br>p = 0.33942<br>adj. p = 0.33942","avgLength vs PC4<br>r = -0.220<br>p = 0.59987<br>adj. p = 0.59987","avgLength vs PC5<br>r = -0.197<br>p = 0.63950<br>adj. p = 0.63950"],["lib.size vs PC1<br>r = -0.166<br>p = 0.69489<br>adj. p = 0.69489","lib.size vs PC2<br>r = 0.680<br>p = 0.06336<br>adj. p = 0.06336","lib.size vs PC3<br>r = -0.322<br>p = 0.43708<br>adj. p = 0.43708","lib.size vs PC4<br>r = -0.013<br>p = 0.97573<br>adj. p = 0.97573","lib.size vs PC5<br>r = -0.339<br>p = 0.41184<br>adj. p = 0.41184"],["size.factor vs PC1<br>r = -0.321<br>p = 0.43769<br>adj. p = 0.43769","size.factor vs PC2<br>r = 0.673<br>p = 0.06764<br>adj. p = 0.06764","size.factor vs PC3<br>r = -0.271<br>p = 0.51638<br>adj. p = 0.51638","size.factor vs PC4<br>r = -0.069<br>p = 0.87184<br>adj. p = 0.87184","size.factor vs PC5<br>r = -0.319<br>p = 0.44155<br>adj. p = 0.44155"]],"hovertemplate":"%{customdata}<extra><\/extra>","colorbar":{"title":{"text":"r"}},"alpha_stroke":1,"sizes":[10,100],"spans":[1,20],"type":"heatmap"}},"layout":{"margin":{"b":40,"l":60,"t":25,"r":10},"title":{"text":""},"xaxis":{"domain":[0,1],"automargin":true,"title":{"text":"Principal component"},"type":"category"},"yaxis":{"domain":[0,1],"automargin":true,"title":{"text":""},"type":"category","autorange":"reversed"},"scene":{"zaxis":{"title":[]}},"hovermode":"closest","showlegend":false,"legend":{"yanchor":"top","y":0.5}},"source":"A","config":{"modeBarButtonsToAdd":["hoverclosest","hovercompare"],"showSendToCloud":false},"data":[{"colorbar":{"title":{"text":"r"},"ticklen":2,"len":0.5,"lenmode":"fraction","y":1,"yanchor":"top"},"colorscale":[["0","#00008B"],["0.5","#FFFFFF"],["1","#8B0000"]],"showscale":true,"x":["PC1","PC2","PC3","PC4","PC5"],"y":["dex (coded)","cell (coded)","avgLength","lib.size","size.factor"],"z":[[0.96450738996315943,0.13552834594395119,0.13173528199915632,-0.17122820301731526,-0.050851771094598534],[-0.24868547913592201,0.32665447604237163,0.42214301994329229,-0.80423633273968198,-0.066223671077910384],[-0.48308145105440808,0.49257499299378482,0.39007136457465708,-0.22043814432508038,-0.19733024554664302],[-0.1657343246962116,0.68029150432388341,-0.32173997290621115,-0.012944489585734064,-0.33869760752496259],[-0.32132968342793161,0.67252567157268406,-0.27089059435326357,-0.068568494625396145,-0.31877677727723264]],"zmin":-1,"zmax":1,"text":[["0.96***","0.14","0.13","-0.17","-0.05"],["-0.25","0.33","0.42","-0.80*","-0.07"],["-0.48","0.49","0.39","-0.22","-0.20"],["-0.17","0.68","-0.32","-0.01","-0.34"],["-0.32","0.67","-0.27","-0.07","-0.32"]],"texttemplate":"%{text}","hovertemplate":"%{customdata}<extra><\/extra>","type":"heatmap","xaxis":"x","yaxis":"y","frame":null}],"highlight":{"on":"plotly_click","persistent":false,"dynamic":false,"selectize":false,"opacityDim":0.20000000000000001,"selected":{"opacity":1},"debounce":0},"shinyEvents":["plotly_hover","plotly_click","plotly_selected","plotly_relayout","plotly_brushed","plotly_brushing","plotly_clickannotation","plotly_doubleclick","plotly_deselect","plotly_afterplot","plotly_sunburstclick"],"base_url":"https://plot.ly"},"evals":[],"jsHooks":[]}
```
