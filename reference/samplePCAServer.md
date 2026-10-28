# Server logic for the samplePCA module

Transforms the assay of a `SummarizedExperiment`, keeps its most
variable genes, runs the PCA
([`sample_pca()`](https://j-andrews7.github.io/sciVizModules/reference/sample_pca.md))
and draws the sample scores through
[`pcaBiplotServer()`](https://j-andrews7.github.io/sciVizModules/reference/pcaBiplotServer.md).
The transformation is kept in its own step, so changing the gene count
or the centring does not repeat it. The scatter module's Trajectory tab
draws arrowed paths through the median scores of chosen sample groups,
and its Marginals tab draws each group's distribution along each
component.

## Usage

``` r
samplePCAServer(
  id,
  data,
  hide.inputs = NULL,
  hide.tabs = NULL,
  defaults = NULL
)
```

## Arguments

- id:

  The ID for the Shiny module.

- data:

  A `reactive` returning a `SummarizedExperiment` of counts.

- hide.inputs:

  A character vector of input IDs to hide.

- hide.tabs:

  A character vector of tab names to hide. None are hidden by default.

- defaults:

  A named list of default values, typically the same list passed to
  [`samplePCAInputsUI()`](https://j-andrews7.github.io/sciVizModules/reference/samplePCAInputsUI.md).

## Value

The value returned by
[`pcaBiplotServer()`](https://j-andrews7.github.io/sciVizModules/reference/pcaBiplotServer.md).

## See also

[`sample_pca()`](https://j-andrews7.github.io/sciVizModules/reference/sample_pca.md),
[`samplePCAInputsUI()`](https://j-andrews7.github.io/sciVizModules/reference/samplePCAInputsUI.md),
[`samplePCAOutputUI()`](https://j-andrews7.github.io/sciVizModules/reference/samplePCAOutputUI.md),
[`samplePCAApp()`](https://j-andrews7.github.io/sciVizModules/reference/samplePCAApp.md)

## Author

Jared Andrews

## Examples

``` r
library(sciVizModules)
if (interactive()) samplePCAApp()
```
