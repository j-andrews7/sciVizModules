# Default UI values for the dose-response module

Produces the `defaults` list handed to the scatter plot module so the
dose-response module opens with sensible mappings: the dose column on
the x-axis (log10-adjusted), the response column on the y-axis, and a
**drc** log-logistic (`LL.4`) custom model enabled and drawn as the
fitted curve.

## Usage

``` r
.dose_response_defaults(data, defaults = NULL)
```

## Arguments

- data:

  A dose-response data frame.

- defaults:

  An optional named list of user overrides.

## Value

A named list of scatter plot module defaults.

## Details

User-supplied `defaults` take precedence over these auto-detected
values.

## Author

Jacob Martin
