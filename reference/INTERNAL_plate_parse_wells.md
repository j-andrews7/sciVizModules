# Parse well identifiers into plate rows and columns

Accepts `"A01"`, `"A1"`, `"a1"` and, for 1536-well plates, two-letter
rows (`"AF48"`). Rows run A = 1 ... Z = 26, AA = 27 ...

## Usage

``` r
.plate_parse_wells(well)

.plate_row_label(i)
```

## Arguments

- well:

  Character vector of well identifiers.

- i:

  Integer row indices.

## Value

A data frame with integer `row` and `col`.

Character labels (`1` gives `"A"`, `27` gives `"AA"`).

## Author

Jared Andrews
