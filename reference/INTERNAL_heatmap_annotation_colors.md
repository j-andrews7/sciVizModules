# Annotation colours as heatmap defaults

The wrapped module seeds an annotation's colour picker from a `defaults`
entry named after the annotated column. Columns whose names are input
ids of the module are skipped.

## Usage

``` r
.heatmap_annotation_colors(colors)
```

## Arguments

- colors:

  A named list of named colour vectors, one per column.

## Value

The list, without unusable entries.

## Author

Jared Andrews
