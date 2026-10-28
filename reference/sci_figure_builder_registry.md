# Module registry for the VizModules Figure Builder

Describes this package's data-frame modules in the shape
[`VizModules::figureBuilderServer()`](https://j-andrews7.github.io/VizModules/reference/figureBuilderServer.html)
expects, so sciVizModules plots can be arranged into a multi-panel
figure alongside the VizModules ones.

## Usage

``` r
sci_figure_builder_registry()
```

## Value

A named list of Figure Builder module registry entries.

## Details

Each entry is a list with `label` (shown in the builder's "Add Plot"
picker), `dataset` (the dataset name its `defaults` were written for),
`inputs_ui` / `output_ui` / `server_fn` (the module's trio), and
`defaults`.

The entries are those of the registry behind the module gallery
([`sciModuleGalleryApp()`](https://j-andrews7.github.io/sciVizModules/reference/sciModuleGalleryApp.md))
and every module's `*App()`, so a panel opens on the same settings as
the module's gallery tab when its example dataset is the one chosen.

Only the modules that take a plain data frame can be registered. The
builder's dataset catalogue holds data frames, so the `dittoSeq` modules
(which take a `SingleCellExperiment`, `Seurat` or
`SummarizedExperiment`), the bulk expression modules (`samplePCA`,
`sampleDistanceHeatmap`, `deHeatmap`), `cnSegmentPlot` (a `CNSegment`
object) and `michaelisMenten` (a bundle whose `stats` element is a model
fit) have no place in it. Run their `*App()` functions instead.

A module is included only when the packages it needs are installed
(`goFanPlot` needs `GOfan` plus an `OrgDb`, `doseResponse` needs `drc`),
so the picker never offers a panel that cannot draw.

Every registered module renders a plotly graph, so the builder's SVG
figure export and its source-data archive photograph them in the
browser; none of them needs the `vector_svg` / `raster_png` hooks that a
non-plotly module would supply.

## See also

[`sciFigureBuilderApp()`](https://j-andrews7.github.io/sciVizModules/reference/sciFigureBuilderApp.md),
[`sciModuleGalleryApp()`](https://j-andrews7.github.io/sciVizModules/reference/sciModuleGalleryApp.md),
[`VizModules::figureBuilderServer()`](https://j-andrews7.github.io/VizModules/reference/figureBuilderServer.html),
[`VizModules::figureBuilderApp()`](https://j-andrews7.github.io/VizModules/reference/figureBuilderApp.html)

## Author

Jared Andrews

## Examples

``` r
registry <- sci_figure_builder_registry()
names(registry)
#> [1] "volcano"    "ma"         "enrichment" "gofan"      "mutational"
#> [6] "survival"   "dose"      
```
