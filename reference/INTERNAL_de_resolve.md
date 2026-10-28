# Split a deHeatmap input into the experiment and its results

Split a deHeatmap input into the experiment and its results

## Usage

``` r
.de_resolve(x)
```

## Arguments

- x:

  A list with the experiment (`object`, or `se`) and a results table
  (`results`), or a `SummarizedExperiment` whose `rowData` carries the
  statistics.

## Value

`list(se =, results =)`, `results` a data frame.

## Author

Jared Andrews
