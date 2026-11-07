# Values for the uniform Axes tab, which the shared plotly finishing stack
# (VizModules::create_axis_styles()) needs before it can style a figure.
test_axes_inputs <- function() {
    list(
        axis.showline = TRUE, axis.mirror = TRUE, axis.linecolor = "#000000", axis.linewidth = 1,
        axis.ticks = "outside", axis.ticklen = 5, axis.tickwidth = 1, axis.tickcolor = "#000000",
        axis.tickangle.x = 0, axis.tickangle.y = 0, axis.tickfont.size = 12,
        axis.tickfont.color = "#000000", axis.tickfont.family = "Arial",
        axis.title.font.size = 14, axis.title.font.color = "#000000", axis.title.font.family = "Arial",
        show.grid.x = FALSE, show.grid.y = FALSE, grid.color = "#EEEEEE"
    )
}

# Values for the uniform Legend tab, all set away from their defaults.
test_legend_inputs <- function() {
    list(
        legend.show = FALSE, legend.font.family = "Courier New", legend.font.color = "#123456",
        legend.title.size = 16, legend.text.size = 11
    )
}

# Values for the shape-styling controls on the uniform Plotly tab.
test_shape_inputs <- function() {
    list(
        shape.fill = "#FF0000", shape.line.color = "#00FF00", shape.line.width = 3,
        shape.linetype = "dash", shape.opacity = 0.5
    )
}

# Values for the uniform Annotations tab, with any given here replacing them.
test_annotation_inputs <- function(...) {
    utils::modifyList(list(
        annotate.by = "", highlight.points = "", highlight.color = "#00FFF7", highlight.size = 7,
        highlight.border.color = "#000000", highlight.border.width = 1, highlight.auto.annotate = TRUE,
        annotation.color = "black", annotation.ax = 20, annotation.ay = -20, annotation.size = 10,
        annotation.showarrow = TRUE, annotation.arrowcolor = "black", annotation.arrowhead = 2,
        annotation.arrowwidth = 1.5
    ), list(...))
}
