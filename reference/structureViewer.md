# Interactive 3D structure viewer

Renders a protein or nucleic-acid structure in an interactive 3D viewer
(NGL, through the NGLVieweR package): rotate, zoom, and hover over
residues. Unlike the other modules this is not a plotly figure - plotly
has no molecular graphics - so it has no Figure Builder support and no
plotly export; save an image with the viewer's own snapshot.

## Usage

``` r
structureViewer(
  x,
  representation = "cartoon",
  color.by = NULL,
  highlight = NULL,
  highlight.color = "#E7298A",
  highlight.representation = "ball+stick",
  show.ligands = TRUE,
  background = "#FFFFFF",
  spin = FALSE,
  quality = "medium",
  band.colors = c("#0053D6", "#65CBF3", "#FFDB13", "#FF7D45")
)
```

## Arguments

- x:

  An object from
  [`read_structure()`](https://j-andrews7.github.io/sciVizModules/reference/read_structure.md).

- representation:

  NGL representation for the polymer: `"cartoon"`, `"backbone"`,
  `"ribbon"`, `"rope"`, `"surface"`, `"ball+stick"`, `"licorice"` or
  `"spacefill"`.

- color.by:

  Colour scheme (see Details). Default: `"plddt"` for an AlphaFold
  model, else `"chainname"`.

- highlight:

  Residues to highlight, as text (see Details), or `NULL`.

- highlight.color:

  Colour of the highlighted residues.

- highlight.representation:

  Representation of the highlighted residues.

- show.ligands:

  Logical; draw ligands and ions as ball-and-stick.

- background:

  Background colour.

- spin:

  Logical; spin the structure.

- quality:

  Rendering quality: `"low"`, `"medium"` or `"high"`.

- band.colors:

  Colours of the four pLDDT bands, from very high to very low (the
  AlphaFold DB colours by default).

## Value

An `NGLVieweR` htmlwidget.

## Details

Colour schemes:

- `"plddt"`:

  AlphaFold confidence in the AlphaFold DB bands, from the B-factor
  column: very high (\> 90), confident (70-90), low (50-70) and very low
  (\< 50). Each band is drawn as its own representation, so the colours
  are exact rather than interpolated.

- `"bfactor"`:

  The B-factor column on a continuous scale.

- `"chainname"`, `"residueindex"`, `"sstruc"`, `"hydrophobicity"`,
  `"element"`:

  NGL's schemes: by chain, rainbow along the sequence, by secondary
  structure, by residue hydrophobicity, and by element.

Residues to highlight are written as a comma-separated list of residue
numbers and ranges, optionally prefixed with a chain:
`"175, 245-250, B:12"`.

## See also

[`read_structure()`](https://j-andrews7.github.io/sciVizModules/reference/read_structure.md),
[`structureViewerServer()`](https://j-andrews7.github.io/sciVizModules/reference/structureViewerServer.md)

## Author

Jared Andrews

## Examples

``` r
p53 <- read_structure(system.file("extdata", "AF-P04637-F1-model_v6.pdb.gz",
    package = "sciVizModules"))
if (interactive()) structureViewer(p53, highlight = "175, 248, 273")
```
