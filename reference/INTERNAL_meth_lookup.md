# Resolve what is being looked up to a region

Resolve what is being looked up to a region

## Usage

``` r
.meth_target(
  cohort,
  locate.by = "gene",
  gene = NULL,
  region = NULL,
  probes = NULL,
  upstream = 2000,
  downstream = 2000
)
```

## Arguments

- cohort:

  A `methylationCohort`.

- locate.by:

  `"gene"`, `"region"` or `"probes"`.

- gene, region, probes:

  The lookup of that kind.

- upstream, downstream:

  Bases to add around a gene or probes.

## Value

A region, from
[`.meth_region()`](https://j-andrews7.github.io/sciVizModules/reference/INTERNAL_meth_target.md).

## Author

Jared Andrews
