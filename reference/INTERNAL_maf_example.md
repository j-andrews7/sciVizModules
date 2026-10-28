# The example MAF: TCGA LAML, as maftools ships it

The somatic mutations of 193 acute myeloid leukaemia tumours (The Cancer
Genome Atlas Research Network, NEJM 2013;368:2059-74) that maftools
ships in `inst/extdata`, read as a data frame (silent and non-silent
variants alike) with each sample's clinical annotations merged in. Read
directly rather than with
[`maftools::read.maf()`](https://rdrr.io/pkg/maftools/man/read.maf.html),
which needs R.utils for a gzipped file.

## Usage

``` r
.maf_example()
```

## Value

A data frame in MAF columns.

## Author

Jared Andrews
