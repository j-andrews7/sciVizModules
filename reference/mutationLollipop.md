# Interactive lollipop plot of the mutations in a protein

The interactive counterpart of
[`maftools::lollipopPlot()`](https://rdrr.io/pkg/maftools/man/lollipopPlot.html):
the non-synonymous mutations of one gene along its protein, one stem per
amino-acid position, with a point per distinct protein change at the
height of its count, coloured by variant class, over the protein's
domains. The most frequent positions are labelled. Hovering gives the
change, its class and count, or the domain.

## Usage

``` r
mutationLollipop(
  maf,
  gene = NULL,
  domains = NULL,
  protein.length = NULL,
  colors = NULL,
  label.top = 3,
  point.size = 10,
  show.domains = TRUE,
  main = NULL
)
```

## Arguments

- maf:

  A maftools `MAF` object or a data frame in MAF columns (see
  [`oncoPlot()`](https://j-andrews7.github.io/sciVizModules/reference/oncoPlot.md)),
  with a protein-change column (`HGVSp_Short`, `Protein_Change` or
  `AAChange`).

- gene:

  The gene (HGNC symbol) to draw. Default: the most often mutated.

- domains:

  Optional data frame of domains, with columns `start`, `end` and
  `label` (any case); overrides maftools' table.

- protein.length:

  Optional protein length in amino acids.

- colors:

  A named vector of variant-class colours, overriding maftools' palette
  for the classes it names.

- label.top:

  The number of most mutated positions to label.

- point.size:

  Marker size.

- show.domains:

  Logical; draw the domains.

- main:

  Optional plot title. Default: the gene, with the isoform and length
  when known.

## Value

A `plotly` object. The plotted counts (one row per position, change and
class) are attached as attribute `"table"`.

## Details

Positions are read from the protein-change column as maftools reads them
(`"p.R882H"` is position 882). Domains and the protein length come from
maftools' bundled Pfam/SMART table when maftools is installed (the
longest isoform, as `lollipopPlot()` chooses), or from `domains` and
`protein.length`; without either the protein runs to the last mutated
position and no domains are drawn.

## See also

[`mutationLollipopServer()`](https://j-andrews7.github.io/sciVizModules/reference/mutationLollipopServer.md),
[`maftools::lollipopPlot()`](https://rdrr.io/pkg/maftools/man/lollipopPlot.html)

## Author

Jared Andrews

## Examples

``` r
if (requireNamespace("maftools", quietly = TRUE)) {
    # The TCGA LAML cohort maftools ships, with its clinical annotations.
    laml <- read.delim(system.file("extdata", "tcga_laml.maf.gz", package = "maftools"),
        comment.char = "#")
    clinical <- read.delim(system.file("extdata", "tcga_laml_annot.tsv", package = "maftools"))
    laml <- merge(laml, clinical, by = "Tumor_Sample_Barcode")
    mutationLollipop(laml, gene = "DNMT3A")
}

{"x":{"visdat":{"312a6d0dac95":["function () ","plotlyVisDat"]},"cur_data":"312a6d0dac95","attrs":{"312a6d0dac95":{"alpha_stroke":1,"sizes":[10,100],"spans":[1,20],"type":"scatter","mode":"lines","x":[0,912,912,0,0],"y":[-1.52,-1.52,0,0,-1.52],"fill":"toself","fillcolor":"#D9D9D9","line":{"color":"#BDBDBD","width":1},"hoverinfo":"text","text":"DNMT3A: 912 aa","hoveron":"fills","showlegend":false,"inherit":true},"312a6d0dac95.1":{"alpha_stroke":1,"sizes":[10,100],"spans":[1,20],"type":"scatter","mode":"lines","x":[290,376,376,290,290],"y":[-2.2800000000000002,-2.2800000000000002,0.76000000000000001,0.76000000000000001,-2.2800000000000002],"fill":"toself","fillcolor":"#F3A683","line":{"color":"#F3A683","width":1},"name":"Dnmt3b_related","legendgroup":"domain:Dnmt3b_related","showlegend":true,"hoveron":"fills","hoverinfo":"text","text":"Dnmt3b_related (290-376)","inherit":true},"312a6d0dac95.2":{"alpha_stroke":1,"sizes":[10,100],"spans":[1,20],"type":"scatter","mode":"lines","x":[478,614,614,478,478],"y":[-2.2800000000000002,-2.2800000000000002,0.76000000000000001,0.76000000000000001,-2.2800000000000002],"fill":"toself","fillcolor":"#F7D794","line":{"color":"#F7D794","width":1},"name":"ADDz_Dnmt3a","legendgroup":"domain:ADDz_Dnmt3a","showlegend":true,"hoveron":"fills","hoverinfo":"text","text":"ADDz_Dnmt3a (478-614)","inherit":true},"312a6d0dac95.3":{"alpha_stroke":1,"sizes":[10,100],"spans":[1,20],"type":"scatter","mode":"lines","x":[632,795,795,632,632],"y":[-2.2800000000000002,-2.2800000000000002,0.76000000000000001,0.76000000000000001,-2.2800000000000002],"fill":"toself","fillcolor":"#778BEB","line":{"color":"#778BEB","width":1},"name":"Dcm","legendgroup":"domain:Dcm","showlegend":true,"hoveron":"fills","hoverinfo":"text","text":"Dcm (632-795)","inherit":true},"312a6d0dac95.4":{"alpha_stroke":1,"sizes":[10,100],"spans":[1,20],"type":"scatter","mode":"lines","x":[634,907,907,634,634],"y":[-2.2800000000000002,-2.2800000000000002,0.76000000000000001,0.76000000000000001,-2.2800000000000002],"fill":"toself","fillcolor":"#E77F67","line":{"color":"#E77F67","width":1},"name":"AdoMet_MTases","legendgroup":"domain:AdoMet_MTases","showlegend":true,"hoveron":"fills","hoverinfo":"text","text":"AdoMet_MTases (634-907)","inherit":true},"312a6d0dac95.5":{"alpha_stroke":1,"sizes":[10,100],"spans":[1,20],"type":"scatter","mode":"lines","x":[315,315,null,320,320,null,468,468,null,477,477,null,485,485,null,497,497,null,505,505,null,515,515,null,590,590,null,615,615,null,646,646,null,718,718,null,723,723,null,729,729,null,736,736,null,741,741,null,781,781,null,792,792,null,803,803,null,829,829,null,882,882,null,909,909,null],"y":[0,1,null,0,1,null,0,1,null,0,1,null,0,1,null,0,1,null,0,1,null,0,1,null,0,1,null,0,1,null,0,1,null,0,1,null,0,1,null,0,1,null,0,2,null,0,1,null,0,1,null,0,1,null,0,1,null,0,1,null,0,19,null,0,1,null],"line":{"color":"#7F7F7F","width":1},"hoverinfo":"skip","showlegend":false,"inherit":true},"312a6d0dac95.6":{"alpha_stroke":1,"sizes":[10,100],"spans":[1,20],"type":"scatter","mode":"markers","x":[315,590,615,723],"y":[1,1,1,1],"name":"Frame Shift Del","marker":{"color":"#1F78B4","size":10,"line":{"color":"#FFFFFF","width":1}},"hoverinfo":"text","text":["p.M315fs<br>Frame Shift Del<br>1 sample","p.G590fs<br>Frame Shift Del<br>1 sample","p.Q615fs<br>Frame Shift Del<br>1 sample","p.L723fs<br>Frame Shift Del<br>1 sample"],"inherit":true},"312a6d0dac95.7":{"alpha_stroke":1,"sizes":[10,100],"spans":[1,20],"type":"scatter","mode":"markers","x":[468,497,718,729,729,736,741,781,792,829,882,882,882,909],"y":[1,1,1,1,1,2,1,1,1,1,19,7,1,1],"name":"Missense Mutation","marker":{"color":"#33A02C","size":10,"line":{"color":"#FFFFFF","width":1}},"hoverinfo":"text","text":["p.K468R<br>Missense Mutation<br>1 sample","p.C497Y<br>Missense Mutation<br>1 sample","p.P718L<br>Missense Mutation<br>1 sample","p.R729Q<br>Missense Mutation<br>1 sample","p.R729W<br>Missense Mutation<br>1 sample","p.R736H<br>Missense Mutation<br>2 samples","p.A741V<br>Missense Mutation<br>1 sample","p.D781G<br>Missense Mutation<br>1 sample","p.R792H<br>Missense Mutation<br>1 sample","p.K829R<br>Missense Mutation<br>1 sample","p.R882H<br>Missense Mutation<br>19 samples","p.R882C<br>Missense Mutation<br>7 samples","p.R882P<br>Missense Mutation<br>1 sample","p.F909C<br>Missense Mutation<br>1 sample"],"inherit":true},"312a6d0dac95.8":{"alpha_stroke":1,"sizes":[10,100],"spans":[1,20],"type":"scatter","mode":"markers","x":[320,485,505,515,615],"y":[1,1,1,1,1],"name":"Nonsense Mutation","marker":{"color":"#E31A1C","size":10,"line":{"color":"#FFFFFF","width":1}},"hoverinfo":"text","text":["p.R320*<br>Nonsense Mutation<br>1 sample","p.Q485*<br>Nonsense Mutation<br>1 sample","p.E505*<br>Nonsense Mutation<br>1 sample","p.Q515*<br>Nonsense Mutation<br>1 sample","p.Q615*<br>Nonsense Mutation<br>1 sample"],"inherit":true},"312a6d0dac95.9":{"alpha_stroke":1,"sizes":[10,100],"spans":[1,20],"type":"scatter","mode":"markers","x":[477,646,803],"y":[1,1,1],"name":"Splice Site","marker":{"color":"#FF7F00","size":10,"line":{"color":"#FFFFFF","width":1}},"hoverinfo":"text","text":["p.E477*<br>Splice Site<br>1 sample","p.G646V<br>Splice Site<br>1 sample","p.R803S<br>Splice Site<br>1 sample"],"inherit":true}},"layout":{"margin":{"b":40,"l":60,"t":25,"r":10},"annotations":[{"x":1,"y":1,"xref":"paper","yref":"paper","xanchor":"right","yanchor":"top","showarrow":false,"text":"3 variants without a protein position not shown","font":{"size":10,"color":"#7F7F7F"}},{"x":882,"y":19,"text":"R882H","showarrow":false,"yanchor":"bottom","yshift":7,"xref":"x","yref":"y","font":{"size":11}},{"x":615,"y":1,"text":"Q615fs","showarrow":false,"yanchor":"bottom","yshift":7,"xref":"x","yref":"y","font":{"size":11}},{"x":729,"y":1,"text":"R729Q","showarrow":false,"yanchor":"bottom","yshift":7,"xref":"x","yref":"y","font":{"size":11}}],"title":{"text":"DNMT3A (NM_022552, 912 aa)"},"xaxis":{"domain":[0,1],"automargin":true,"title":{"text":"Amino acid position"},"range":[-9.120000000000001,921.12],"showgrid":false,"zeroline":false},"yaxis":{"domain":[0,1],"automargin":true,"title":{"text":"Mutations"},"range":[-3.04,24.25],"tickvals":[0,5,10,15,20],"showgrid":false,"zeroline":false},"hovermode":"closest","showlegend":true},"source":"A","config":{"modeBarButtonsToAdd":["hoverclosest","hovercompare"],"showSendToCloud":false},"data":[{"fillcolor":"#D9D9D9","type":"scatter","mode":"lines","x":[0,912,912,0,0],"y":[-1.52,-1.52,0,0,-1.52],"fill":"toself","line":{"color":"#BDBDBD","width":1},"hoverinfo":["text","text","text","text","text"],"text":"DNMT3A: 912 aa","hoveron":"fills","showlegend":false,"name":"#D9D9D9","marker":{"color":"rgba(31,119,180,1)","line":{"color":"rgba(31,119,180,1)"}},"error_y":{"color":"rgba(31,119,180,1)"},"error_x":{"color":"rgba(31,119,180,1)"},"xaxis":"x","yaxis":"y","frame":null},{"fillcolor":"#F3A683","type":"scatter","mode":"lines","x":[290,376,376,290,290],"y":[-2.2800000000000002,-2.2800000000000002,0.76000000000000001,0.76000000000000001,-2.2800000000000002],"fill":"toself","line":{"color":"#F3A683","width":1},"name":"Dnmt3b_related","legendgroup":"domain:Dnmt3b_related","showlegend":true,"hoveron":"fills","hoverinfo":["text","text","text","text","text"],"text":"Dnmt3b_related (290-376)","marker":{"color":"rgba(255,127,14,1)","line":{"color":"rgba(255,127,14,1)"}},"error_y":{"color":"rgba(255,127,14,1)"},"error_x":{"color":"rgba(255,127,14,1)"},"xaxis":"x","yaxis":"y","frame":null},{"fillcolor":"#F7D794","type":"scatter","mode":"lines","x":[478,614,614,478,478],"y":[-2.2800000000000002,-2.2800000000000002,0.76000000000000001,0.76000000000000001,-2.2800000000000002],"fill":"toself","line":{"color":"#F7D794","width":1},"name":"ADDz_Dnmt3a","legendgroup":"domain:ADDz_Dnmt3a","showlegend":true,"hoveron":"fills","hoverinfo":["text","text","text","text","text"],"text":"ADDz_Dnmt3a (478-614)","marker":{"color":"rgba(44,160,44,1)","line":{"color":"rgba(44,160,44,1)"}},"error_y":{"color":"rgba(44,160,44,1)"},"error_x":{"color":"rgba(44,160,44,1)"},"xaxis":"x","yaxis":"y","frame":null},{"fillcolor":"#778BEB","type":"scatter","mode":"lines","x":[632,795,795,632,632],"y":[-2.2800000000000002,-2.2800000000000002,0.76000000000000001,0.76000000000000001,-2.2800000000000002],"fill":"toself","line":{"color":"#778BEB","width":1},"name":"Dcm","legendgroup":"domain:Dcm","showlegend":true,"hoveron":"fills","hoverinfo":["text","text","text","text","text"],"text":"Dcm (632-795)","marker":{"color":"rgba(214,39,40,1)","line":{"color":"rgba(214,39,40,1)"}},"error_y":{"color":"rgba(214,39,40,1)"},"error_x":{"color":"rgba(214,39,40,1)"},"xaxis":"x","yaxis":"y","frame":null},{"fillcolor":"#E77F67","type":"scatter","mode":"lines","x":[634,907,907,634,634],"y":[-2.2800000000000002,-2.2800000000000002,0.76000000000000001,0.76000000000000001,-2.2800000000000002],"fill":"toself","line":{"color":"#E77F67","width":1},"name":"AdoMet_MTases","legendgroup":"domain:AdoMet_MTases","showlegend":true,"hoveron":"fills","hoverinfo":["text","text","text","text","text"],"text":"AdoMet_MTases (634-907)","marker":{"color":"rgba(148,103,189,1)","line":{"color":"rgba(148,103,189,1)"}},"error_y":{"color":"rgba(148,103,189,1)"},"error_x":{"color":"rgba(148,103,189,1)"},"xaxis":"x","yaxis":"y","frame":null},{"type":"scatter","mode":"lines","x":[315,315,null,320,320,null,468,468,null,477,477,null,485,485,null,497,497,null,505,505,null,515,515,null,590,590,null,615,615,null,646,646,null,718,718,null,723,723,null,729,729,null,736,736,null,741,741,null,781,781,null,792,792,null,803,803,null,829,829,null,882,882,null,909,909],"y":[0,1,null,0,1,null,0,1,null,0,1,null,0,1,null,0,1,null,0,1,null,0,1,null,0,1,null,0,1,null,0,1,null,0,1,null,0,1,null,0,1,null,0,2,null,0,1,null,0,1,null,0,1,null,0,1,null,0,1,null,0,19,null,0,1],"line":{"color":"#7F7F7F","width":1},"hoverinfo":["skip","skip",null,"skip","skip",null,"skip","skip",null,"skip","skip",null,"skip","skip",null,"skip","skip",null,"skip","skip",null,"skip","skip",null,"skip","skip",null,"skip","skip",null,"skip","skip",null,"skip","skip",null,"skip","skip",null,"skip","skip",null,"skip","skip",null,"skip","skip",null,"skip","skip",null,"skip","skip",null,"skip","skip",null,"skip","skip",null,"skip","skip",null,"skip","skip"],"showlegend":false,"marker":{"color":"rgba(140,86,75,1)","line":{"color":"rgba(140,86,75,1)"}},"error_y":{"color":"rgba(140,86,75,1)"},"error_x":{"color":"rgba(140,86,75,1)"},"xaxis":"x","yaxis":"y","frame":null},{"type":"scatter","mode":"markers","x":[315,590,615,723],"y":[1,1,1,1],"name":"Frame Shift Del","marker":{"color":"#1F78B4","size":10,"line":{"color":"#FFFFFF","width":1}},"hoverinfo":["text","text","text","text"],"text":["p.M315fs<br>Frame Shift Del<br>1 sample","p.G590fs<br>Frame Shift Del<br>1 sample","p.Q615fs<br>Frame Shift Del<br>1 sample","p.L723fs<br>Frame Shift Del<br>1 sample"],"error_y":{"color":"rgba(227,119,194,1)"},"error_x":{"color":"rgba(227,119,194,1)"},"line":{"color":"rgba(227,119,194,1)"},"xaxis":"x","yaxis":"y","frame":null},{"type":"scatter","mode":"markers","x":[468,497,718,729,729,736,741,781,792,829,882,882,882,909],"y":[1,1,1,1,1,2,1,1,1,1,19,7,1,1],"name":"Missense Mutation","marker":{"color":"#33A02C","size":10,"line":{"color":"#FFFFFF","width":1}},"hoverinfo":["text","text","text","text","text","text","text","text","text","text","text","text","text","text"],"text":["p.K468R<br>Missense Mutation<br>1 sample","p.C497Y<br>Missense Mutation<br>1 sample","p.P718L<br>Missense Mutation<br>1 sample","p.R729Q<br>Missense Mutation<br>1 sample","p.R729W<br>Missense Mutation<br>1 sample","p.R736H<br>Missense Mutation<br>2 samples","p.A741V<br>Missense Mutation<br>1 sample","p.D781G<br>Missense Mutation<br>1 sample","p.R792H<br>Missense Mutation<br>1 sample","p.K829R<br>Missense Mutation<br>1 sample","p.R882H<br>Missense Mutation<br>19 samples","p.R882C<br>Missense Mutation<br>7 samples","p.R882P<br>Missense Mutation<br>1 sample","p.F909C<br>Missense Mutation<br>1 sample"],"error_y":{"color":"rgba(127,127,127,1)"},"error_x":{"color":"rgba(127,127,127,1)"},"line":{"color":"rgba(127,127,127,1)"},"xaxis":"x","yaxis":"y","frame":null},{"type":"scatter","mode":"markers","x":[320,485,505,515,615],"y":[1,1,1,1,1],"name":"Nonsense Mutation","marker":{"color":"#E31A1C","size":10,"line":{"color":"#FFFFFF","width":1}},"hoverinfo":["text","text","text","text","text"],"text":["p.R320*<br>Nonsense Mutation<br>1 sample","p.Q485*<br>Nonsense Mutation<br>1 sample","p.E505*<br>Nonsense Mutation<br>1 sample","p.Q515*<br>Nonsense Mutation<br>1 sample","p.Q615*<br>Nonsense Mutation<br>1 sample"],"error_y":{"color":"rgba(188,189,34,1)"},"error_x":{"color":"rgba(188,189,34,1)"},"line":{"color":"rgba(188,189,34,1)"},"xaxis":"x","yaxis":"y","frame":null},{"type":"scatter","mode":"markers","x":[477,646,803],"y":[1,1,1],"name":"Splice Site","marker":{"color":"#FF7F00","size":10,"line":{"color":"#FFFFFF","width":1}},"hoverinfo":["text","text","text"],"text":["p.E477*<br>Splice Site<br>1 sample","p.G646V<br>Splice Site<br>1 sample","p.R803S<br>Splice Site<br>1 sample"],"error_y":{"color":"rgba(23,190,207,1)"},"error_x":{"color":"rgba(23,190,207,1)"},"line":{"color":"rgba(23,190,207,1)"},"xaxis":"x","yaxis":"y","frame":null}],"highlight":{"on":"plotly_click","persistent":false,"dynamic":false,"selectize":false,"opacityDim":0.20000000000000001,"selected":{"opacity":1},"debounce":0},"shinyEvents":["plotly_hover","plotly_click","plotly_selected","plotly_relayout","plotly_brushed","plotly_brushing","plotly_clickannotation","plotly_doubleclick","plotly_deselect","plotly_afterplot","plotly_sunburstclick"],"base_url":"https://plot.ly"},"evals":[],"jsHooks":[]}
```
