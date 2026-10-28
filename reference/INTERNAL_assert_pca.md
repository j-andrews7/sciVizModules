# Check that an object is a PCAtools `pca` object

The PCAtools modules read the object's fields directly (it is a plain
list), so this only checks the fields they use are present.

## Usage

``` r
.assert_pca(x, arg = "data")
```

## Arguments

- x:

  The object to check.

- arg:

  Argument name for the error message.

## Value

`x`, invisibly.

## Author

Jared Andrews
