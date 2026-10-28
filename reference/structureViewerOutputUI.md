# Output UI components for the structureViewer module

Output UI components for the structureViewer module

## Usage

``` r
structureViewerOutputUI(id, height = "600px")
```

## Arguments

- id:

  The ID for the Shiny module.

- height:

  Height of the viewer, as a valid CSS unit.

## Value

The viewer output.

## Author

Jared Andrews

## Examples

``` r
structureViewerOutputUI("viewer")
#> <div class="NGLVieweR html-widget html-widget-output shiny-report-size html-fill-item" id="viewer-structureViewer" style="width:100%;height:600px;"></div>
```
