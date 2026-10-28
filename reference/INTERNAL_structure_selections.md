# The named representations a structure is drawn with

Shared by
[`structureViewer()`](https://j-andrews7.github.io/sciVizModules/reference/structureViewer.md)
(initial render) and the module's proxy updates (restyling without
reloading), so both draw the same thing. Each element is
`list(type, param)` with `param$name` set, so a representation can later
be removed by name.

## Usage

``` r
.structure_selections(
  x,
  representation = "cartoon",
  color.by = NULL,
  highlight = NULL,
  highlight.color = "#E7298A",
  highlight.representation = "ball+stick",
  show.ligands = TRUE,
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

- band.colors:

  Colours of the four pLDDT bands, from very high to very low (the
  AlphaFold DB colours by default).

## Value

A list of representations.

## Author

Jared Andrews
