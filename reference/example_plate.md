# Example assay plates

A simulated luminescence screen on two 384-well plates, for the
[`plateHeatmap()`](https://j-andrews7.github.io/sciVizModules/reference/plateHeatmap.md)
module. Column 2 holds 16 negative (DMSO) control wells and column 23
holds 16 positive (fully inhibited) control wells on each plate. The
first plate carries a strong evaporation edge effect, which the B-score
normalisation removes, and the second a mild one; each holds a few hits.

## Usage

``` r
data(example_plate)
```

## Format

A data frame with 768 rows and 5 columns:

- plate:

  Plate identifier, `"Plate_01"` or `"Plate_02"`

- well:

  Well identifier, `"A01"` to `"P24"`

- type:

  `"sample"`, `"negative"` or `"positive"`

- compound:

  Compound identifier (simulated)

- signal:

  Luminescence readout

## Source

Simulated in `data-raw/generate_example_plate.R`.

## Author

Jared Andrews

## Examples

``` r
data(example_plate)
head(example_plate)
#>      plate well     type compound signal
#> 1 Plate_01  A01   sample CMP-0001   7878
#> 2 Plate_01  A02 negative     DMSO   8248
#> 3 Plate_01  A03   sample CMP-0002   8722
#> 4 Plate_01  A04   sample CMP-0003   8251
#> 5 Plate_01  A05   sample CMP-0004   8108
#> 6 Plate_01  A06   sample CMP-0005   7772
```
