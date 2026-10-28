# Protein length and domains of a gene, from maftools

Reads maftools' bundled Pfam/SMART domain table (`protein_domains.RDs`),
using the gene's longest isoform (the first RefSeq protein on a tie), as
maftools' `lollipopPlot()` does. The table is read once per session.

## Usage

``` r
.maf_domains(gene)
```

## Arguments

- gene:

  An HGNC gene symbol.

## Value

A list with `length` (amino acids), `refseq` and `domains` (a data frame
of `start`, `end` and `label`), or `NULL` when maftools is not installed
or does not know the gene.

## Author

Jared Andrews
