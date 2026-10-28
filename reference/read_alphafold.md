# Read AlphaFold confidence outputs

Reads the per-residue confidence (pLDDT) and the predicted aligned error
(PAE) of an AlphaFold prediction into one object for
[`alphafoldConfidence()`](https://j-andrews7.github.io/sciVizModules/reference/alphafoldConfidence.md)
and the alphafoldConfidence module. Files may be gzip-compressed.

## Usage

``` r
read_alphafold(pae = NULL, confidence = NULL, structure = NULL)
```

## Arguments

- pae:

  Path to a PAE JSON (AlphaFold DB or ColabFold scores), or `NULL`.

- confidence:

  Path to an AlphaFold DB confidence JSON, or `NULL`.

- structure:

  Path to a `.pdb` or `.cif` model, or `NULL`.

## Value

An object of class `"alphafold_confidence"`: a list with

- plddt:

  A data frame with `index` (position along the prediction), `chain`,
  `residue` and `plddt`, plus the AlphaFold DB `category` ("Very high"
  \> 90, "Confident" 70-90, "Low" 50-70, "Very low" \< 50).

- pae:

  The PAE matrix (Angstroms; row = aligned residue, column = scored
  residue), or `NULL`.

- max_pae:

  The maximum possible PAE reported by the file, or `NULL`.

- files:

  The files read.

## Details

Accepted inputs:

- `pae`: the AlphaFold DB `*-predicted_aligned_error_v*.json` (current
  `predicted_aligned_error` matrix, or the older `residue1` / `residue2`
  / `distance` arrays), or a ColabFold `*_scores_*.json`, which holds
  both the PAE (`pae`, `max_pae`) and the pLDDT (`plddt`).

- `confidence`: the AlphaFold DB `*-confidence_v*.json`
  (`residueNumber`, `confidenceScore`).

- `structure`: the predicted model as `.pdb` or mmCIF (`.cif`).
  AlphaFold writes the pLDDT into the B-factor column, so this gives the
  pLDDT and, for a multimer, the chain of each residue (read from the
  C-alpha atoms).

The pLDDT comes from `confidence` if given, else the ColabFold scores,
else `structure`; chain IDs come from `structure` when it is given.
AlphaFold 3 `*_full_data_*.json` output is not yet supported.

AlphaFold DB data is available under CC-BY 4.0. Please cite Jumper et
al. (2021) Nature 596:583-589 and Varadi et al. (2024) Nucleic Acids
Research 52:D368-D375 when using it.

## See also

[`alphafoldConfidence()`](https://j-andrews7.github.io/sciVizModules/reference/alphafoldConfidence.md),
[`alphafoldConfidenceServer()`](https://j-andrews7.github.io/sciVizModules/reference/alphafoldConfidenceServer.md)

## Author

Jared Andrews

## Examples

``` r
af <- read_alphafold(
    pae = system.file("extdata", "AF-P04637-F1-predicted_aligned_error_v6.json.gz",
        package = "sciVizModules"),
    confidence = system.file("extdata", "AF-P04637-F1-confidence_v6.json.gz",
        package = "sciVizModules")
)
af
#> AlphaFold confidence: 393 residues 
#>   mean pLDDT: 75.1 
#>   PAE: 393 x 393 
```
