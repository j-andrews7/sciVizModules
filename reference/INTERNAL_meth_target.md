# Describe a genomic region

As
[`sesame::visualizeGene()`](https://rdrr.io/pkg/sesame/man/visualizeGene.html):
`upstream` and `downstream` follow the strand of the gene's first
transcript. A gene on two chromosomes (a pseudoautosomal gene) takes the
first.

## Usage

``` r
.meth_region(chr, start, end, gene = NULL)

.meth_comma(x)

.meth_parse_region(text)

.meth_parse_probes(text)

.meth_gene_region(cohort, gene, upstream = 2000, downstream = 2000)

.meth_probe_region(cohort, ids, upstream = 2000, downstream = 2000)
```

## Arguments

- chr, start, end:

  The region.

- gene:

  A gene name.

- x:

  Numbers.

- text:

  IDs separated by commas, semicolons or white space.

- cohort:

  A `methylationCohort`.

- upstream, downstream:

  Bases to add before and after the probes.

- ids:

  Probe IDs, matched on any array, exactly or on their prefix.

## Value

A list of `chr`, `start`, `end` and `label`.

Character strings.

A region, from `.meth_region()`.

The unique IDs.

A region, from `.meth_region()`.

A region, from `.meth_region()`.

## Author

Jared Andrews
