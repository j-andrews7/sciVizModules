# Parse typed residues into an NGL selection

Accepts residue numbers and ranges separated by commas or spaces, each
optionally prefixed with a chain and a colon: `"175, 245-250, B:12"`.

## Usage

``` r
.structure_parse_highlight(text)
```

## Arguments

- text:

  The typed residues, or `NULL`.

## Value

An NGL selection string, or `NULL` when nothing valid was given.

## Author

Jared Andrews
