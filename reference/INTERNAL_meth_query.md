# Average the probes that measure one CpG

The mean of each CpG's values, skipping missing ones, as
[`sesame::betasCollapseToPfx()`](https://rdrr.io/pkg/sesame/man/betasCollapseToPfx.html)
does for replicate probes. Here the replicates are those at one
position, so probes with different IDs are averaged too, and replicates
at different positions are not.

A row in an array's own matrix shows the array has the CpG. In a matrix
merged across arrays there are no such rows to go on, so any value from
one of the array's samples shows it.

Only here are the arrays joined, and only for the CpGs of this region.

Where arrays disagree over a CpG, the first array's value stands.

By the span of a transcript, so one with only an intron in the region is
kept.

## Usage

``` r
.meth_collapse(betas, pos)

.meth_array_region(a, reg)

.meth_coverage(hits, pos, betas, table, merged = FALSE)

.meth_query(cohort, region, samples = NULL, scope = "all", max.cpgs = 1000)

.meth_join_rowdata(hits, pos)

.meth_region_txns(cohort, reg, region)

.meth_region_bands(cohort, chr)
```

## Arguments

- betas:

  The joined matrix, CpGs in rows, over all the cohort's samples.

- pos:

  The positions, in order.

- a:

  An array of a `methylationCohort`.

- reg:

  The region as a `GRanges`.

- hits:

  The regions from `.meth_array_region()`.

- table:

  The cohort's sample table.

- merged:

  Logical; whether the cohort is one matrix merged across arrays.

- cohort:

  A `methylationCohort`.

- region:

  The region, from
  [`.meth_region()`](https://j-andrews7.github.io/sciVizModules/reference/INTERNAL_meth_target.md).

- samples:

  The names of the samples to keep, or `NULL` for all.

- scope:

  `"all"` for every CpG on any plotted array, `"shared"` for those on
  all of them.

- max.cpgs:

  The most CpGs to draw. A larger region is an error, as in
  [`sesame::visualizeRegion()`](https://rdrr.io/pkg/sesame/man/visualizeRegion.html).

- chr:

  A chromosome.

## Value

A matrix with one row per position, in position order.

A list of `pos`, `betas`, `probes` and `rowdata`, one row per position,
or `NULL` where the array has nothing there.

A logical matrix with a column per platform, or `NULL` where the cohort
names no platforms.

A list of `region`, `betas` (CpGs in rows), `absent` (cells whose array
lacks the CpG), `coverage`, `cpgs`, `rowdata`, `samples`, `txns` and
`cytobands`.

A data frame with one row per position.

A `GRangesList`, or `NULL`.

A data frame, or `NULL` where there are none.

## Author

Jared Andrews
