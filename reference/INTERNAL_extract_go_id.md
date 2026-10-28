# Extract GO IDs from a vector of possibly-messy strings

Pulls the first `GO:[0-9]+` token out of each element and returns a
character vector of the same length. Elements with no match become `NA`.
Accepts factors and one-column tibble subsets as input.

## Usage

``` r
.extract_go_id(x)
```

## Arguments

- x:

  A vector (character, factor, or coercible) that may contain GO
  identifiers embedded in free text.

## Value

A character vector of GO IDs, with `NA` where no ID was found.

## Author

Jacob Martin,
