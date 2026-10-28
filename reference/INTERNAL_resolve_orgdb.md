# Resolve an OrgDb argument to an OrgDb object

Accepts either an `OrgDb` object (returned unchanged) or the name of an
installed organism annotation package (e.g. `"org.Hs.eg.db"`) and
returns the corresponding `OrgDb` object exported by that package.

## Usage

``` r
.resolve_orgdb(org)
```

## Arguments

- org:

  An `OrgDb` object or a length-one character naming an OrgDb package.

## Value

An `OrgDb` object.

## Author

Jacob Martin, Jared Andrews
