# Read a macromolecular structure

Reads a protein or nucleic-acid structure in PDB or mmCIF format
(optionally gzip-compressed) for
[`structureViewer()`](https://j-andrews7.github.io/sciVizModules/reference/structureViewer.md)
and the structureViewer module. The file text is kept as is for the
viewer, and a per-residue table is taken from its C-alpha atoms.

## Usage

``` r
read_structure(file)
```

## Arguments

- file:

  Path to a `.pdb`, `.ent` or `.cif` / `.mmcif` file, optionally ending
  in `.gz`.

## Value

An object of class `"sci_structure"`: a list with `text` (the file
contents), `format` (`"pdb"` or `"cif"`), `residues` (a data frame of
`chain`, `residue`, `bfactor` and the pLDDT band `category`),
`alphafold` (logical) and `file`.

## Details

AlphaFold and ColabFold models store the per-residue confidence (pLDDT)
in the B-factor column. When the file identifies itself as an AlphaFold
model, the result is flagged so the viewer colours by the AlphaFold DB
pLDDT bands by default; any structure can still be coloured that way.

## See also

[`structureViewer()`](https://j-andrews7.github.io/sciVizModules/reference/structureViewer.md),
[`read_alphafold()`](https://j-andrews7.github.io/sciVizModules/reference/read_alphafold.md)

## Author

Jared Andrews

## Examples

``` r
p53 <- read_structure(system.file("extdata", "AF-P04637-F1-model_v6.pdb.gz",
    package = "sciVizModules"))
p53
#> Structure (pdb): 393 residues in 1 chain (A)
#>   AlphaFold model; mean pLDDT 75.1 
```
