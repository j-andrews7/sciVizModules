# Principal component analysis of a bulk expression experiment

Builds the object the PCAtools modules
([`pcaBiplotServer()`](https://j-andrews7.github.io/sciVizModules/reference/pcaBiplotServer.md),
[`pcaScreePlotServer()`](https://j-andrews7.github.io/sciVizModules/reference/pcaScreePlotServer.md),
[`pcaLoadingsPlotServer()`](https://j-andrews7.github.io/sciVizModules/reference/pcaLoadingsPlotServer.md),
[`pcaPairsPlotServer()`](https://j-andrews7.github.io/sciVizModules/reference/pcaPairsPlotServer.md),
[`pcaEigencorPlotServer()`](https://j-andrews7.github.io/sciVizModules/reference/pcaEigencorPlotServer.md))
take, from a `SummarizedExperiment` of counts: the assay is transformed,
the most variable genes kept, and the samples projected with
[`stats::prcomp()`](https://rdrr.io/r/stats/prcomp.html). The result has
the shape [`PCAtools::pca()`](https://rdrr.io/pkg/PCAtools/man/pca.html)
returns, with the sample metadata from `colData`, so PCAtools is not
needed.

## Usage

``` r
sample_pca(
  object,
  assay = NULL,
  transform = .se_default_transform(),
  ntop = 500,
  center = TRUE,
  scale = FALSE,
  feature.labels = NULL,
  metadata = NULL
)
```

## Arguments

- object:

  A `SummarizedExperiment` (a `DESeqDataSet` will do), or a numeric
  matrix with features in rows and samples in columns.

- assay:

  The assay to use. Default: `"counts"` when present, otherwise the
  first.

- transform:

  `"vst"` (DESeq2's variance-stabilising transformation; the default
  when DESeq2 is installed), `"log2cpm"` (log2 counts per million, as
  [`edgeR::cpm()`](https://rdrr.io/pkg/edgeR/man/cpm.html) with
  `log = TRUE`; the default otherwise), `"log2"` (`log2(x + 1)`) or
  `"none"` (an already-transformed assay).

- ntop:

  The number of most variable features to keep. `NA` keeps every feature
  with non-zero variance.

- center, scale:

  Passed to [`stats::prcomp()`](https://rdrr.io/r/stats/prcomp.html):
  centre each feature, and scale it to unit variance.

- feature.labels:

  A `rowData` column whose values name the features in the loadings
  (e.g. `"symbol"`), or `NULL` for the row names.

- metadata:

  For a matrix `object`, an optional data frame of sample metadata with
  one row per column; ignored for a `SummarizedExperiment`, whose
  `colData` is used.

## Value

A list of class `"pca"` with elements `rotated` (sample scores),
`loadings`, `variance` (percent explained), `sdev`, `metadata`, `xvars`
(features), `yvars` (samples) and `components`.

## See also

[`samplePCAServer()`](https://j-andrews7.github.io/sciVizModules/reference/samplePCAServer.md),
[`PCAtools::pca()`](https://rdrr.io/pkg/PCAtools/man/pca.html),
[`pcaBiplotServer()`](https://j-andrews7.github.io/sciVizModules/reference/pcaBiplotServer.md)

## Author

Jared Andrews

## Examples

``` r
if (requireNamespace("airway", quietly = TRUE)) {
    data("airway", package = "airway")
    p <- sample_pca(airway, transform = "log2cpm", ntop = 500, feature.labels = "symbol")
    round(p$variance, 1)
    pcaScreePlot(p)
}

{"x":{"visdat":{"312a3950aafd":["function () ","plotlyVisDat"]},"cur_data":"312a3950aafd","attrs":{"312a3950aafd":{"alpha_stroke":1,"sizes":[10,100],"spans":[1,20],"x":{},"y":{},"type":"bar","name":"Explained","text":["PC1<br>Explained: 31.42%<br>Cumulative: 31.42%","PC2<br>Explained: 30.04%<br>Cumulative: 61.46%","PC3<br>Explained: 20.23%<br>Cumulative: 81.69%","PC4<br>Explained: 14.27%<br>Cumulative: 95.96%","PC5<br>Explained: 1.67%<br>Cumulative: 97.63%","PC6<br>Explained: 1.40%<br>Cumulative: 99.03%","PC7<br>Explained: 0.97%<br>Cumulative: 100.00%","PC8<br>Explained: 0.00%<br>Cumulative: 100.00%"],"hoverinfo":"text","textposition":"none","marker":{"color":"#1E90FF"},"inherit":true},"312a3950aafd.1":{"alpha_stroke":1,"sizes":[10,100],"spans":[1,20],"x":{},"y":{},"type":"scatter","mode":"lines+markers","name":"Cumulative","text":["PC1<br>Explained: 31.42%<br>Cumulative: 31.42%","PC2<br>Explained: 30.04%<br>Cumulative: 61.46%","PC3<br>Explained: 20.23%<br>Cumulative: 81.69%","PC4<br>Explained: 14.27%<br>Cumulative: 95.96%","PC5<br>Explained: 1.67%<br>Cumulative: 97.63%","PC6<br>Explained: 1.40%<br>Cumulative: 99.03%","PC7<br>Explained: 0.97%<br>Cumulative: 100.00%","PC8<br>Explained: 0.00%<br>Cumulative: 100.00%"],"hoverinfo":"text","line":{"color":"#CD2626","width":2},"marker":{"color":"#CD2626","size":7},"inherit":true}},"layout":{"margin":{"b":40,"l":60,"t":25,"r":10},"title":{"text":""},"xaxis":{"domain":[0,1],"automargin":true,"title":{"text":"Principal component"},"type":"category","categoryorder":"array","categoryarray":["PC1","PC2","PC3","PC4","PC5","PC6","PC7","PC8"]},"yaxis":{"domain":[0,1],"automargin":true,"title":{"text":"Explained variance (%)"},"range":[0,105]},"shapes":[{"type":"line","x0":4,"x1":4,"xref":"x","y0":0,"y1":1,"yref":"paper","line":{"color":"#000000","dash":"dash","width":1}}],"annotations":[{"x":4,"xref":"x","y":1,"yref":"paper","yanchor":"bottom","text":"Elbow (PC5)","showarrow":false}],"hovermode":"closest","showlegend":true},"source":"A","config":{"modeBarButtonsToAdd":["hoverclosest","hovercompare"],"showSendToCloud":false},"data":[{"x":["PC1","PC2","PC3","PC4","PC5","PC6","PC7","PC8"],"y":[31.420212605904613,30.039294342728123,20.226108866874451,14.272172931047869,1.6724913008076574,1.4039567855510342,0.96576316708622445,6.3794793896424472e-30],"type":"bar","name":"Explained","text":["PC1<br>Explained: 31.42%<br>Cumulative: 31.42%","PC2<br>Explained: 30.04%<br>Cumulative: 61.46%","PC3<br>Explained: 20.23%<br>Cumulative: 81.69%","PC4<br>Explained: 14.27%<br>Cumulative: 95.96%","PC5<br>Explained: 1.67%<br>Cumulative: 97.63%","PC6<br>Explained: 1.40%<br>Cumulative: 99.03%","PC7<br>Explained: 0.97%<br>Cumulative: 100.00%","PC8<br>Explained: 0.00%<br>Cumulative: 100.00%"],"hoverinfo":["text","text","text","text","text","text","text","text"],"textposition":["none","none","none","none","none","none","none","none"],"marker":{"color":"#1E90FF","line":{"color":"rgba(31,119,180,1)"}},"error_y":{"color":"rgba(31,119,180,1)"},"error_x":{"color":"rgba(31,119,180,1)"},"xaxis":"x","yaxis":"y","frame":null},{"x":["PC1","PC2","PC3","PC4","PC5","PC6","PC7","PC8"],"y":[31.420212605904613,61.459506948632736,81.685615815507191,95.957788746555053,97.630280047362717,99.034236832913749,99.999999999999972,99.999999999999972],"type":"scatter","mode":"lines+markers","name":"Cumulative","text":["PC1<br>Explained: 31.42%<br>Cumulative: 31.42%","PC2<br>Explained: 30.04%<br>Cumulative: 61.46%","PC3<br>Explained: 20.23%<br>Cumulative: 81.69%","PC4<br>Explained: 14.27%<br>Cumulative: 95.96%","PC5<br>Explained: 1.67%<br>Cumulative: 97.63%","PC6<br>Explained: 1.40%<br>Cumulative: 99.03%","PC7<br>Explained: 0.97%<br>Cumulative: 100.00%","PC8<br>Explained: 0.00%<br>Cumulative: 100.00%"],"hoverinfo":["text","text","text","text","text","text","text","text"],"line":{"color":"#CD2626","width":2},"marker":{"color":"#CD2626","size":7,"line":{"color":"rgba(255,127,14,1)"}},"error_y":{"color":"rgba(255,127,14,1)"},"error_x":{"color":"rgba(255,127,14,1)"},"xaxis":"x","yaxis":"y","frame":null}],"highlight":{"on":"plotly_click","persistent":false,"dynamic":false,"selectize":false,"opacityDim":0.20000000000000001,"selected":{"opacity":1},"debounce":0},"shinyEvents":["plotly_hover","plotly_click","plotly_selected","plotly_relayout","plotly_brushed","plotly_brushing","plotly_clickannotation","plotly_doubleclick","plotly_deselect","plotly_afterplot","plotly_sunburstclick"],"base_url":"https://plot.ly"},"evals":[],"jsHooks":[]}
```
