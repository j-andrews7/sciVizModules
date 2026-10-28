# Convert time or length units when the label names them

Convert time or length units when the label names them

## Usage

``` r
.md_convert(values, labels, unit, kind)
```

## Arguments

- values:

  Numeric values.

- labels:

  Their axis labels, e.g. `"Time (ps)"` or `"RMSD (nm)"`.

- unit:

  The requested conversion.

- kind:

  `"time"` or `"length"`.

## Value

A list of converted `values` and relabelled `labels`. Values whose label
does not name the source unit are left alone.

## Author

Jared Andrews
