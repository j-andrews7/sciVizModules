# Coerce a module's data to a methylationCohort

EPICv2 and MSA suffix their IDs (`cg00000029_TC21`), and a table
collapsed to prefixes does not, so each side's prefix is tried for what
is left unmatched.

Tries each array in turn, on exact IDs and then on prefixes, and stops
once every ID is placed, so a matrix from one array loads only that
array's manifest.

Loaded once per session.

Read from sesameData once per session. Anything that stops them being
read (the package missing, or no network for a first download) leaves
them `NULL`, so the module carries on without those tracks.

## Usage

``` r
.meth_as_cohort(x)

.meth_parts(x, assay = NULL, genome = "hg38")

.meth_assay(se, assay = NULL)

.meth_row_ranges(se, genome = "hg38")

.meth_match_ids(ids, table)

.meth_prefix(ids)

.meth_no_places(n)

.meth_fill_places(place, rows, ranges)

.meth_from_ranges(ids, ranges)

.meth_from_rowdata(rowdata)

.meth_from_manifests(ids, platforms, genome)

.meth_platform_code(x)

.meth_manifest(platform, genome)

.meth_points(loci)

.meth_array_probes(probes, name)

.meth_build_array(part, name, merged, platforms, probes, genome)

.meth_sample_table(part, platform, samples)

.meth_match_samples(ids, samples)

.meth_bind_samples(tables, order = NULL)

.meth_sample_platforms(samples)

.meth_genome_info(genome)

.meth_txns(cohort)

.meth_cytobands(cohort)
```

## Arguments

- x:

  Platform names.

- assay:

  The assay asked for, or `NULL`.

- genome:

  The genome build.

- se:

  A `SummarizedExperiment`.

- ids:

  Sample names.

- table:

  Probe IDs to find them in.

- n:

  The number of rows.

- place:

  A table from `.meth_no_places()`.

- rows:

  The rows of `place` to fill.

- ranges:

  A `GRanges` named by probe ID.

- rowdata:

  The `rowData` of an array, as a data frame.

- platforms:

  The platforms it holds, for finding its manifests.

- platform:

  The array's name, or `NULL` for a merged matrix.

- loci:

  A `GRanges`.

- probes:

  Positions given by the caller, or `NULL`.

- name:

  The array's name.

- part:

  The array's parts, from `.meth_parts()`.

- merged:

  Logical; whether it is a matrix merged across arrays.

- samples:

  A cohort's sample table.

- tables:

  One sample table per array.

- order:

  The array names, in the order to keep, or `NULL`.

- cohort:

  A `methylationCohort`.

## Value

A `methylationCohort`.

A list of `betas`, `coldata`, `rowdata` and `ranges`.

An assay name.

A `GRanges` parallel to the rows, or `NULL`.

Indices into `table`, `NA` where not found.

The IDs without any suffix.

A data frame of `chr`, `start` and `end`, all `NA`.

`place`, with `chr` left `NA` for ranges on no chromosome.

A table of positions.

A table of positions, or `NULL` where it has no position columns.

A table of positions.

The sesameData codes, `NA` for names it does not know.

A `GRanges` named by probe ID.

The ranges, one base wide.

A `GRanges`, or `NULL`.

A list of `betas`, `loci`, `rowdata`, `merged`, and `dropped` counts.

A data frame with a `sample` column, one row per column of `betas`.

The rows of `samples` for `ids`, or `NULL`.

One table, with unique `sample` names as its row names and `platform` as
a factor in the arrays' order.

The platform names, or `NULL` where it has none.

The `genomeInfo` list, or `NULL`.

A `GRangesList`, or `NULL`.

A data frame, or `NULL`.

## Author

Jared Andrews
