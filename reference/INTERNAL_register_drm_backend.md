# Register the **drc** dose-response model backend

Adds a `"drm"` backend to the VizModules model registry so the scatter
plot modelling machinery can fit dose-response curves with
[`drc::drm()`](https://rdrr.io/pkg/drc/man/drm.html). The backend
exposes a `drc_fct` select field for choosing the dose-response family
(log-logistic and Weibull models). Registration runs once when the
package namespace is loaded.

## Usage

``` r
.register_drm_backend()
```

## Value

Invisibly `NULL`; called for its side effect of registering the backend.

## Author

Jacob Martin
