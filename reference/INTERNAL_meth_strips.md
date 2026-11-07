# Work out how to draw one annotation strip

One map for the whole cohort, walking along the palette from one
annotation to the next, so two annotations drawn together never start
from the same colour and a level keeps its colour however the strips on
show change.

## Usage

``` r
.meth_strip(
  values,
  column,
  colors = NULL,
  low = .meth_colors$anno.low,
  high = .meth_colors$anno.high
)

.meth_steps(colors)

.meth_palette(n)

.meth_annotation_levels(cohort)

.meth_level_colors(cohort)

.meth_group_cols(samples)

.meth_strip_cols(samples)

.meth_cpg_cols(cohort)
```

## Arguments

- values:

  The annotation's values.

- column:

  The annotation's name.

- colors:

  Colours, one per integer value.

- low, high:

  Colours of a numeric annotation.

- n:

  How many, recycled past the end of the palette.

- cohort:

  A `methylationCohort`.

- samples:

  A cohort's sample table.

## Value

A list of `z`, `zmin`, `zmax`, `colorscale`, and `legend`, a data frame
of the `name` and `color` of each legend entry.

A plotly colourscale.

Hex colours.

A named list of levels, one element per discrete sample or CpG
annotation.

A named colour vector, keyed `"column: level"`.

Column names.

Column names: the discrete ones, then the numeric.

Column names, without those giving probe positions.

## Author

Jared Andrews
