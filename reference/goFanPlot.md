# Create an interactive GO enrichment sunburst ("fan") plot

Builds a Gene Ontology (GO) enrichment sunburst plot from an enrichment
results table and returns an interactive `plotly` figure. The plot is
produced with
[`GOfan::sunburstGO()`](https://rdrr.io/pkg/GOfan/man/sunburstGO.html),
which converts the GO directed acyclic graph (DAG) into a clean,
circular (sunburst / fan) representation where each ring corresponds to
a hierarchy level and each segment represents a GO term.

## Usage

``` r
goFanPlot(
  data,
  org = "org.Hs.eg.db",
  term.id = "ID",
  fill = "qvalue",
  palette = "Viridis",
  sub_rect = NULL,
  onto = c("BP", "CC", "MF"),
  go.annotation.level.cutoff = 4,
  filter.nodes.by.edge.number = 2,
  fill.na.by.0 = TRUE,
  must.keep = NULL,
  only.keep = NULL,
  ...
)
```

## Arguments

- data:

  A data frame of enriched GO terms. Must contain the `term.id` column
  of GO identifiers and the `fill` column.

- org:

  Either an `OrgDb` object or the name of an installed organism
  annotation package (e.g. `"org.Hs.eg.db"`, `"org.Mm.eg.db"`,
  `"org.Dr.eg.db"`). Defaults to `"org.Hs.eg.db"`.

- term.id:

  The name of the column in `data` holding the GO IDs (default `"ID"`).

- fill:

  The name of the numeric column in `data` used to set the segment fill
  colours (default `"qvalue"`).

- palette:

  The colour palette used to map the `fill` column onto the segments. A
  length-one character naming a built-in plotly continuous colorscale
  (e.g. `"Viridis"`, `"Blues"`, `"RdBu"`, `"Cividis"`), or a two-column
  `[value, colour]` matrix/list accepted by plotly's `colorscale`.
  `NULL` leaves plotly's default colorscale in place. Defaults to
  `"Viridis"`.

- sub_rect:

  Optional name of a numeric column in `data` used to draw a
  proportional sub-rectangle inside each segment (a value in `[0, 1]`;
  count columns are converted to a proportion). `NULL` or `""` disables
  it.

- onto:

  The GO ontology category of the supplied IDs. One of `"BP"`
  (biological process), `"CC"` (cellular component), or `"MF"`
  (molecular function).

- go.annotation.level.cutoff:

  Numeric cutoff for the GO annotation levels passed to
  [`GOfan::sunburstGO()`](https://rdrr.io/pkg/GOfan/man/sunburstGO.html)
  as `GO_annotation_level_cutoff` (default `4`).

- filter.nodes.by.edge.number:

  Filter the sub-graphs by their edge number (passed as
  `filterNodesByEdgeNumber`, default `2`).

- fill.na.by.0:

  Logical; fill `NA` values in the colour column with `0` (passed as
  `fillNAby0`, default `TRUE`).

- must.keep:

  Optional character vector of GO terms that must be kept (passed as
  `mustkeep`).

- only.keep:

  Optional character vector of GO terms; only branches containing these
  terms are kept (passed as `onlyKeep`).

- ...:

  Further arguments passed to
  [`GOfan::sunburstGO()`](https://rdrr.io/pkg/GOfan/man/sunburstGO.html).

## Value

A [`plotly::plot_ly()`](https://rdrr.io/pkg/plotly/man/plot_ly.html)
object containing the interactive sunburst plot.

## Details

The input `data` must contain a column of GO identifiers (e.g.
`"GO:0006955"`) and at least one numeric column to map onto the segment
fill colour (for example a q-value or `-log10` p-value).
[`GOfan::sunburstGO()`](https://rdrr.io/pkg/GOfan/man/sunburstGO.html)
resolves the hierarchical relationships among the supplied GO terms
using the organism annotation database given in `org`, so the
appropriate `OrgDb` package (e.g. `org.Hs.eg.db` for human) must be
installed.

[`GOfan::sunburstGO()`](https://rdrr.io/pkg/GOfan/man/sunburstGO.html)
is rendered with `plotBy = "plotly"` so the returned figure is genuinely
interactive: hovering a segment reveals its label and clicking a segment
zooms into that GO term and its offspring.

## See also

[`GOfan::sunburstGO()`](https://rdrr.io/pkg/GOfan/man/sunburstGO.html),
[`goFanPlotInputsUI()`](https://j-andrews7.github.io/sciVizModules/reference/goFanPlotInputsUI.md),
[`goFanPlotServer()`](https://j-andrews7.github.io/sciVizModules/reference/goFanPlotServer.md),
[`goFanPlotApp()`](https://j-andrews7.github.io/sciVizModules/reference/goFanPlotApp.md)

## Author

Jacob Martin, Jared Andrews

## Examples

``` r
library(sciVizModules)
data(example_enrichment)
# Requires the 'GOfan' package and the relevant OrgDb (e.g. org.Hs.eg.db).
if (requireNamespace("GOfan", quietly = TRUE) &&
    requireNamespace("org.Hs.eg.db", quietly = TRUE)) {
    fig <- goFanPlot(example_enrichment,
        org = "org.Hs.eg.db",
        term.id = "ID", fill = "qvalue", onto = "BP"
    )
    if (interactive()) fig
}
#> 
```
