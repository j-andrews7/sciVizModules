# Prepare summary statistics for a Manhattan plot

Drops variants with a missing or out-of-range p-value or position,
orders the chromosomes naturally, and lays them end to end:
`manhattan.chr` is the chromosome as an ordered factor (with any "chr"
prefix removed) and `manhattan.x` the position along the concatenated
genome, with a gap between chromosomes.

## Usage

``` r
.gwas_prepare(data, chr, bp, p, gap = 0.01)
```

## Arguments

- data:

  A data frame of summary statistics.

- chr, bp, p:

  Column names.

- gap:

  Gap between chromosomes, as a fraction of the genome length.

## Value

`data` with `manhattan.chr` and `manhattan.x` added, sorted by them. The
chromosome centres along the axis are attached as attribute `"centres"`.

## Author

Jared Andrews
