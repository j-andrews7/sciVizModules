# Distances between the samples of a beta matrix

Pairs with nothing to compare come back `NA`. Euclidean and Manhattan
distances use the CpGs each pair shares, scaled up for those left out,
as [`stats::dist()`](https://rdrr.io/r/stats/dist.html) does.

Samples on different arrays leave many cells empty, and most distance
measures have no answer for them. So samples are compared on the CpGs
measured in all of them. With fewer than two such CpGs, as can happen
across arrays in a small region, each pair is compared on the CpGs it
shares instead, and a pair sharing none is placed apart from everything,
at 1.1 times the greatest distance.

Groups and clustering are independent: samples stay in their given
order, gather into groups, are clustered, or are clustered within each
group.

Blank rows between groups draw the gaps.

## Usage

``` r
.meth_dist(betas, method = "euclidean")

.meth_cluster(betas, dist.method = "euclidean", hclust.method = "ward.D2")

.meth_order(
  betas,
  samples,
  group.by = NULL,
  cluster = FALSE,
  dist.method = "euclidean",
  hclust.method = "ward.D2"
)

.meth_rows(n, groups = NULL, gap = 1)
```

## Arguments

- betas:

  A matrix with samples in columns.

- method:

  `"euclidean"`, `"manhattan"`, `"pearson"` or `"spearman"`, the last
  two as one minus the correlation.

- dist.method, hclust.method:

  The distance, as for `.meth_dist()`, and the linkage, passed to
  [`stats::hclust()`](https://rdrr.io/r/stats/hclust.html).

- samples:

  The samples' table.

- group.by:

  A column of `samples` to group on, or `NULL`.

- cluster:

  Logical; cluster the samples, within any groups.

- n:

  The number of samples.

- groups:

  A factor over the plotted samples, or `NULL`.

- gap:

  Blank rows between groups.

## Value

A `dist` object.

A list of `hc` and `fallback`, which is `TRUE` where pairwise distances
were needed.

A list of `index` (columns of `betas`, in plotted order), `groups` (a
factor over the plotted samples, or `NULL`), `trees` (each group's
clustering and how many samples precede it) and `fallback`.

A list of `y` (each sample's row) and `n` (the rows in all).

## Author

Jared Andrews
