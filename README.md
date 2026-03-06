# sciVizModules

<!-- badges: start -->
[![R-CMD-check](https://github.com/j-andrews7/sciVizModules/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/j-andrews7/sciVizModules/actions/workflows/R-CMD-check.yaml)
<!-- badges: end -->

sciVizModules extends [VizModules](https://github.com/j-andrews7/VizModules) with a curated
collection of domain-specific Shiny modules tailored for the biological, chemical, and physical
sciences. Built on the flexible foundations of VizModules, these modules introduce plot types
and interactive controls commonly needed in scientific research. Each module preserves the
interactivity-first philosophy of its parent package while incorporating scientifically meaningful
defaults, axis conventions, and annotation layers relevant to each domain. sciVizModules enables
researchers to rapidly deploy publication-ready, interactive visualizations with minimal code,
bridging the gap between raw experimental data and interpretable scientific figures.

Developed by [Jared Andrews](https://github.com/j-andrews7) and [Jacob Martin](https://github.com/Jacob1106)

## Install

Note that this package is in development and may break at any time.

VizModules must be installed first:

```r
devtools::install_github("j-andrews7/VizModules")
devtools::install_github("j-andrews7/sciVizModules")
```
