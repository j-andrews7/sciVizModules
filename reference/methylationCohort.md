# Assemble a DNA methylation cohort from one or more arrays

Gathers beta values from any mix of Infinium arrays (HM450, EPIC,
EPICv2, ...) with their sample information and genomic positions, for
[`methylationTrack()`](https://j-andrews7.github.io/sciVizModules/reference/methylationTrack.md)
and its module. Arrays are joined on genomic position rather than on
probe ID: the same cg ID can sit at different positions on different
arrays, and different IDs can measure the same CpG, so a join on IDs
would merge what should not be merged and split what should. Nothing is
joined up front. A region is pulled from each array when it is asked
for, so an HDF5-backed
[`SummarizedExperiment::SummarizedExperiment()`](https://rdrr.io/pkg/SummarizedExperiment/man/SummarizedExperiment-class.html)
stays out of memory, and a cohort's full union of CpGs, over a million
rows, is never built.

## Usage

``` r
methylationCohort(
  betas,
  samples = NULL,
  probes = NULL,
  genome = "hg38",
  assay = NULL,
  txns = NULL,
  cytobands = NULL
)

# S3 method for class 'methylationCohort'
print(x, ...)
```

## Arguments

- betas:

  The beta values, in one of the forms described in Details.

- samples:

  Optional data frame of sample information.

- probes:

  Optional probe positions: a `GRanges` named by probe ID, or a list of
  them named as `betas` is.

- genome:

  The genome build, such as `"hg38"`.

- assay:

  For a `SummarizedExperiment`, the assay holding beta values. By
  default one named `betas`, `beta` or `Beta`, else the first.

- txns:

  Optional transcripts as a `GRangesList` of exons, one element per
  transcript named by transcript ID, with `gene_name` in its `mcols()`.
  Its `transcript_type`, `cdsStart` and `cdsEnd` are used where present.
  The shape of `genomeInfo$txns` from
  [`sesameData::sesameData_getGenomeInfo()`](https://rdrr.io/pkg/sesameData/man/sesameData_getGenomeInfo.html).

- cytobands:

  Optional data frame of cytobands, with `chrom`, `chromStart`,
  `chromEnd` and `gieStain` columns.

- x:

  A `methylationCohort`.

- ...:

  Ignored.

## Value

A `methylationCohort` object: a list holding `arrays` (each with its
`betas`, `loci` and `rowdata`), `samples`, `genome`, `txns`, `cytobands`
and `dropped` (the rows left out).

`x`, invisibly.

## Details

**Input forms.** `betas` is one of:

- A named list with one matrix or `SummarizedExperiment` per array,
  named by platform (`list(HM450 = m1, EPIC = m2, EPICv2 = m3)`). A CpG
  is on an array when that array has a row for it.

- One matrix or `SummarizedExperiment` already merged across arrays,
  with `NA` where a sample's array lacks a probe. Sample information can
  name each sample's array in a `platform` column; a CpG is then on an
  array when any of that array's samples has a value there. Without one,
  the cohort cannot tell a probe the array lacks from one that failed,
  and both are drawn in the NA colour.

Matrices have probe IDs as row names and samples as columns.

**Positions.** Each array's positions come from the first of these it
has:

1.  `probes`, a `GRanges` named by probe ID, or a list of them named by
    platform.

2.  The `rowRanges()` of a `SummarizedExperiment`. These must be on
    `genome`.

3.  `rowData()` columns: `CpG_chrm` and `CpG_beg`, as in the Infinium
    annotation manifests, whose BED-style starts are shifted to
    one-based; or `chr` and `pos`, as in minfi's annotation packages,
    taken as they are. Check that they are on `genome`: minfi's HM450
    and EPIC annotations are often hg19.

4.  The sesameData manifest of the array, found from its platform name
    (`HM450` or `450K`, `EPIC`, `EPICv2`, `MSA` or `HM27`). These hold
    hg38 only, so another genome needs one of the above.

Probe IDs match exactly, then on the ID's prefix, so `cg00000029_TC21`
finds `cg00000029` and the reverse. In a merged matrix, an ID is looked
up on each array in turn, newest first.

Rows that cannot be placed, and SNP (`rs`), control (`ctl`) and
nucleotide variant (`nv`) probes, are left out, and counted when the
cohort is printed. So is the number of CpGs each pair of arrays shares:
a pair sharing few suggests its positions disagree, such as one on
another genome build.

**Samples.** Sample information comes from each `SummarizedExperiment`'s
`colData()` and from `samples`, whose row names or one of whose columns
must hold the column names of `betas`. Both are kept, `samples` taking
precedence. The table gains `sample` and, for a list of arrays,
`platform` columns. A sample run on two arrays stays as two samples,
with the platform added to each name.

**Annotation.** With `txns` and `cytobands` left as `NULL`, the
transcripts and cytobands of `genome` are read from sesameData when they
are first needed, and held for the session. Where neither is available
those tracks are not drawn and genes cannot be looked up.

Beta values are not adjusted between arrays. Differences between
platforms remain, so check for them by grouping samples on `platform`.

## See also

[`methylationTrack()`](https://j-andrews7.github.io/sciVizModules/reference/methylationTrack.md),
[`methylationTrackApp()`](https://j-andrews7.github.io/sciVizModules/reference/methylationTrackApp.md)

## Author

Jared Andrews

## Examples

``` r
betas <- matrix(
    c(0.1, 0.9, 0.5, 0.2, 0.8, 0.4),
    nrow = 3, dimnames = list(c("cg1", "cg2", "cg3"), c("a", "b"))
)
probes <- GenomicRanges::GRanges("chr1", IRanges::IRanges(c(100, 200, 300), width = 2))
names(probes) <- rownames(betas)
cohort <- methylationCohort(
    list(HM450 = betas), probes = probes,
    samples = data.frame(tissue = c("Blood", "Liver"), row.names = c("a", "b"))
)
cohort
#> methylationCohort: 2 samples on hg38 
#>   HM450          2 samples          3 probes
```
