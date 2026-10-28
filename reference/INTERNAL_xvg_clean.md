# Strip Grace formatting codes from an .xvg label

Removes the subscript, superscript, normal-text, font and symbol codes
Grace uses (`\\s`, `\\S`, `\\N`, `\\f{...}`, `\\x`), and turns the
angstrom symbol code into "A".

## Usage

``` r
.xvg_clean(x)
```

## Arguments

- x:

  Character vector of labels.

## Value

The cleaned labels.

## Author

Jared Andrews
