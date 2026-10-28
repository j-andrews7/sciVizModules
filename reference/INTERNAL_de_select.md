# Select the top differentially expressed genes

Select the top differentially expressed genes

## Usage

``` r
.de_select(
  res,
  ids,
  id.col = "",
  padj.col,
  lfc.col,
  padj.cutoff = 0.05,
  lfc.cutoff = 1,
  top.n = 50,
  rank.by = "padj",
  direction = "both"
)
```

## Arguments

- res:

  A results data frame.

- ids:

  Gene identifiers of the experiment (its row names).

- id.col:

  Results column matching `ids`, or `""` for the row names.

- padj.col, lfc.col:

  The adjusted p-value and log2 fold change columns.

- padj.cutoff:

  Keep genes with an adjusted p-value below this.

- lfc.cutoff:

  Keep genes with an absolute log2 fold change of at least this.

- top.n:

  The most genes to keep.

- rank.by:

  `"padj"` (most significant first, ties by fold change) or `"lfc"`
  (largest absolute fold change first).

- direction:

  `"both"`, `"up"` or `"down"`.

## Value

The kept rows of `res`, ranked, with columns `.id` (the matched
identifier), `.padj` and `.lfc` added.

## Author

Jared Andrews
