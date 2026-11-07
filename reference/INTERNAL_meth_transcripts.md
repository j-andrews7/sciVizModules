# Lay a region's transcripts out in rows

Full gives each transcript a row of its own, as
[`sesame::visualizeRegion()`](https://rdrr.io/pkg/sesame/man/visualizeRegion.html)
does. Collapsed overlays a gene's transcripts on one row, as IGV's
collapsed view does, and genes that overlap take separate rows.

## Usage

``` r
.meth_txn_model(txns, region, view = "full", types = NULL)

.meth_full_rows(span, exons, cds)

.meth_collapsed_rows(span, exons, cds, gene, region)

.meth_clip(features, region)
```

## Arguments

- txns:

  A `GRangesList` of exons, or `NULL`.

- region:

  A region, from
  [`.meth_region()`](https://j-andrews7.github.io/sciVizModules/reference/INTERNAL_meth_target.md).

- view:

  `"full"` or `"collapsed"`.

- types:

  Transcript types to keep; `NULL` or none keeps all.

- span:

  A data frame of transcripts.

- exons, cds:

  Data frames of `owner`, `start` and `end`.

- gene:

  Each transcript's gene.

- features:

  A data frame with `start` and `end`.

## Value

A list of `n` (the rows), and `spans`, `exons` and `cds` data frames of
`row`, `start` and `end`, clipped to the region. `spans` also holds
`label`, `strand` and `hover`.

A list of `spans`, `exons` and `cds` with a `row` column.

A list of `spans`, `exons` and `cds` with a `row` column.

The features inside the region, cut at its edges.

## Author

Jared Andrews
