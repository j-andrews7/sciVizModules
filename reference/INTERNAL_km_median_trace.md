# Median survival lines of a survival curve

As survminer draws them: `"h"` a horizontal line at the median level
from 0 to the longest median, `"v"` a vertical line from 0 up to each
stratum's median, and `"hv"` both. A stratum whose curve never reaches
the median gets none.

## Usage

``` r
.km_median_trace(fit, levels, type = "none", y = 0.5)
```

## Arguments

- fit:

  The `survfit` object.

- levels:

  The strata, in the fit's order.

- type:

  `"none"`, `"h"`, `"v"` or `"hv"`.

- y:

  The median level on the plotted scale (0.5, or 50 for a percentage).

## Value

A plotly trace list, or `NULL` if there is nothing to draw.

## Author

Jared Andrews
