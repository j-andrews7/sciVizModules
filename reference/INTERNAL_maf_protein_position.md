# Amino-acid positions of protein changes

Parsed as maftools' `lollipopPlot()` does: the part after the last `.`,
with a trailing `Ter...`, letters and `*` stripped, and the first number
of a range taken. `"p.R882H"` gives 882, `"p.KIM2014fs"` 2014, `"p.R7*"`
7.

## Usage

``` r
.maf_protein_position(x)
```

## Arguments

- x:

  A character vector of protein changes.

## Value

A numeric vector of positions, `NA` where none can be read.

## Author

Jared Andrews
