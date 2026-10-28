# Tidy a MAGeCK gene summary table

Renames the `selection|statistic` columns of a MAGeCK gene summary (as
read with `read.delim(check.names = FALSE)`) to `selection.statistic`.
The `check.names = TRUE` spelling (`neg.p.value`, `drug.wald.p.value`)
is renamed the same way. A table already tidied by
[`read_mageck()`](https://j-andrews7.github.io/sciVizModules/reference/read_mageck.md)
is returned unchanged.

## Usage

``` r
.mageck_tidy(df)
```

## Arguments

- df:

  The table.

## Value

The tidy table, with attribute `"mageck_type"`.

## Author

Jared Andrews
