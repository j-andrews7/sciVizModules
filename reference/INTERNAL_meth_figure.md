# Set a track figure's colour scales

The colours live on `layout.coloraxis`, so changing them needs no
redraw.

The Axes tab's lines would otherwise fall on the strips that carry the
figure's main axes, so they are moved onto the heatmap here. Passed
through `fixed.axes`, which
[`.sci_finalize_plotly()`](https://j-andrews7.github.io/sciVizModules/reference/INTERNAL_sci_finalize_plotly.md)
applies after the shared styling.

Each panel has axes of its own, linked to the others by `matches`, so a
shared axis never makes one panel of several. The first axis on each
side goes to the outermost panel, where its labels belong: the columns'
under the bottom strips, the samples' beside the right-hand strips.
Those are the two axes the Axes tab styles.

The draw step of
[`methylationTrack()`](https://j-andrews7.github.io/sciVizModules/reference/methylationTrack.md)
and its module. Colours come afterwards, from `.meth_apply_scale()`.

## Usage

``` r
.meth_apply_scale(
  fig,
  colors = NULL,
  min = NA,
  mid = NA,
  max = NA,
  reverse = FALSE,
  title = "Beta value",
  absent.color = .meth_colors$absent,
  na.color = .meth_colors$na
)

.meth_apply_frame(
  fig,
  font.size = NULL,
  showline = FALSE,
  mirror = FALSE,
  linecolor = NULL,
  linewidth = NULL
)

.meth_empty_cells(betas, absent)

.meth_hover(q, index, y, ny)

.meth_axis_numbers(panels)

.meth_axis_ref(side, number)

.meth_axis_name(side, number)

.meth_add_transcripts(
  fig,
  model,
  to_x,
  xaxis,
  yaxis,
  labels = TRUE,
  font.size = 8,
  exon.color = .meth_colors$exon,
  cds.color = .meth_colors$cds,
  intron.color = .meth_colors$intron
)

.meth_add_dendrogram(fig, trees, rows, xaxis, yaxis)

.meth_add_ideogram(fig, bands, region, xaxis, yaxis)

.meth_axes(
  panels,
  numbers,
  n,
  ny,
  rows,
  sample.names,
  left,
  right,
  bottom,
  column.labels,
  ticks,
  txn.rows,
  height,
  chrom.end
)

.meth_figure(
  q,
  group.by = NULL,
  group.gap = 1,
  cluster.samples = FALSE,
  dist.method = "euclidean",
  hclust.method = "ward.D2",
  show.dendrogram = TRUE,
  anno.left = NULL,
  anno.right = NULL,
  anno.colors = NULL,
  anno.low = .meth_colors$anno.low,
  anno.high = .meth_colors$anno.high,
  show.sample.names = TRUE,
  txn.view = "full",
  txn.types = "protein_coding",
  txn.labels = TRUE,
  txn.font.size = 8,
  exon.color = .meth_colors$exon,
  cds.color = .meth_colors$cds,
  intron.color = .meth_colors$intron,
  show.cytoband = TRUE,
  show.map.lines = TRUE,
  show.coverage = TRUE,
  cpg.tracks = NULL,
  cpg.labels = "none"
)
```

## Arguments

- fig:

  The figure so far.

- colors, min, mid, max, reverse:

  Passed to
  [`VizModules::resolve_colorscale()`](https://j-andrews7.github.io/VizModules/reference/resolve_colorscale.html).

- title:

  The colorbar's title.

- absent.color, na.color:

  Colours of the two kinds of empty cell.

- font.size:

  The labels' size.

- showline, mirror, linecolor, linewidth:

  The Axes tab's axis lines.

- betas, absent:

  Matrices with rows for samples, as plotted.

- q:

  A query, from
  [`.meth_query()`](https://j-andrews7.github.io/sciVizModules/reference/INTERNAL_meth_query.md).

- index:

  The plotted order of the samples.

- y:

  Each plotted sample's heatmap row.

- ny:

  The heatmap's rows.

- panels:

  The panel domains, from
  [`.meth_domains()`](https://j-andrews7.github.io/sciVizModules/reference/INTERNAL_meth_domains.md).

- side:

  `"x"` or `"y"`.

- number:

  The axis number.

- model:

  The transcripts, from
  [`.meth_txn_model()`](https://j-andrews7.github.io/sciVizModules/reference/INTERNAL_meth_transcripts.md).

- to_x:

  A function from genomic position to the x axis.

- xaxis, yaxis:

  The panel's axis references.

- labels:

  Logical; label the transcripts.

- exon.color, cds.color, intron.color:

  See
  [`methylationTrack()`](https://j-andrews7.github.io/sciVizModules/reference/methylationTrack.md).

- trees:

  The trees from
  [`.meth_order()`](https://j-andrews7.github.io/sciVizModules/reference/INTERNAL_meth_order.md).

- rows:

  Each plotted sample's heatmap row.

- bands:

  The chromosome's cytobands.

- region:

  A region, from
  [`.meth_region()`](https://j-andrews7.github.io/sciVizModules/reference/INTERNAL_meth_target.md).

- numbers:

  The axis numbers, from `.meth_axis_numbers()`.

- n:

  The heatmap's columns.

- sample.names:

  Sample names, or `NULL` to leave them off.

- left, right:

  The strips' column names.

- bottom:

  The bottom strips' row names.

- column.labels:

  The heatmap's column labels, or `NULL`.

- ticks:

  Genomic position ticks, a list of `at` and `label`, or `NULL`.

- txn.rows:

  The transcript rows.

- height:

  The tallest dendrogram.

- chrom.end:

  The length of the chromosome.

- group.by, group.gap, cluster.samples, dist.method, hclust.method:

  See
  [`methylationTrack()`](https://j-andrews7.github.io/sciVizModules/reference/methylationTrack.md).

- show.dendrogram, anno.left, anno.right, anno.colors, anno.low,
  anno.high:

  See
  [`methylationTrack()`](https://j-andrews7.github.io/sciVizModules/reference/methylationTrack.md).

- show.sample.names, txn.view, txn.types, txn.labels, txn.font.size:

  See
  [`methylationTrack()`](https://j-andrews7.github.io/sciVizModules/reference/methylationTrack.md).

- show.cytoband, show.map.lines, show.coverage, cpg.tracks, cpg.labels:

  See
  [`methylationTrack()`](https://j-andrews7.github.io/sciVizModules/reference/methylationTrack.md).

## Value

The figure.

The figure.

A matrix: 1 where the array lacks the CpG, 2 for a value that is
missing, and `NA` over a value.

A list of `values` and `empty`, character matrices over the heatmap's
cells, or `NULL` for a heatmap too large to carry them (see
`.meth_hover_limit`).

A named list of `x` and `y` axis numbers per panel.

A string such as `"x2"`, or `"xaxis2"`.

The figure.

The figure.

The figure.

A named list of axes for `plotly::layout()`.

A built `plotly` figure, with attributes `table`, `fixed.axes`,
`heat.axes` and `beta.range`.

## Author

Jared Andrews
