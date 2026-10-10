# A complete set of inputs for VizModules::dittoViz_scatterPlotServer(), so a
# wrapper module's figure can be built end to end in testServer(). Mirrors
# .scatter_inputs() in the VizModules scatter tests.
test_scatter_inputs <- function(...) {
    base <- list(
        x.by = "units", y.by = "revenue", color.by = "", shape.by = "", size.by = "", split.by = "",
        x.adjustment = "", y.adjustment = "", color.adjustment = "",
        x.adj.fxn = "", y.adj.fxn = "", color.adj.fxn = "",
        size = 1, size.min = 1, size.max = 6, size.scale.min = NA, size.scale.max = NA,
        opacity = 1, show.others = FALSE, split.show.all.others = FALSE,
        plot.order = "unordered", shape.panel = "16, 15, 17, 23, 25, 8",
        min.color = "#F0E442", max.color = "#0072B2", min.value = NA, max.value = NA,
        do.contour = FALSE, contour.color = "black", contour.linetype = "solid", do.ellipse = FALSE,
        trajectory.group.by = "", add.trajectory.by.groups = "", trajectory.arrow.size = 0.15,
        split.nrow = NA, split.ncol = NA, split.adjust.scales = "fixed", multivar.split.dir = "col",
        subplot.margin.x = 0.03, subplot.margin.y = 0.1,
        legend.show = TRUE, legend.color.title = "make", legend.color.breaks = "",
        legend.title.size = 14, legend.text.size = 12, size.legend.x = 1.03, size.legend.y = 0.35,
        hover.data = "", hover.round.digits = 5, webgl = FALSE, single.point.color = "#000000",
        linear.model = FALSE, best.fit = FALSE, line.best.smoothness = 1, line.best.colour = "#000000",
        custom.model.enable = FALSE, custom.models = NULL,
        annotate.by = "", highlight.points = "", highlight.auto.annotate = TRUE,
        highlight.color = "#00FFF7", highlight.size = 7,
        highlight.border.color = "#000000", highlight.border.width = 1,
        annotation.color = "black", annotation.ax = 20, annotation.ay = -20,
        annotation.size = 10, annotation.showarrow = TRUE,
        annotation.arrowcolor = "black", annotation.arrowhead = 2, annotation.arrowwidth = 1.5,
        download.format = "png", auto.update = TRUE, update = 0,
        title.font.size = 26, title.font.family = "Arial", title.font.color = "#000000",
        axis.title.font.size = 18, axis.title.font.color = "#000000",
        axis.title.font.family = "Arial", axis.title.horizontal.position = 0.5,
        axis.showline = TRUE, axis.mirror = TRUE, show.grid.x = TRUE, show.grid.y = TRUE,
        grid.color = "#CCCCCC", axis.linecolor = "black", axis.linewidth = 0.5,
        axis.tickfont.size = 12, axis.tickfont.color = "black",
        axis.tickfont.family = "Arial", axis.tickangle.x = 0, axis.tickangle.y = 0,
        axis.ticks = "outside", axis.tickcolor = "black", axis.ticklen = 5,
        axis.tickwidth = 1, facet.title.font.size = 14,
        facet.title.font.color = "black", facet.title.font.family = "Arial",
        hline.intercepts = "", vline.intercepts = "", abline.slopes = "", abline.intercepts = "",
        shape.fill = "rgba(0, 0, 0, 0)", shape.line.color = "black", shape.line.width = 4,
        shape.linetype = "solid", shape.opacity = 1,
        margin.l = 80, margin.r = 80, margin.t = 80, margin.b = 80
    )
    utils::modifyList(base, list(...))
}

# Build a scatter-wrapper figure end to end: the real scatter server, the given
# data, fig.fn hook and defaults, and `inputs` (completed by test_scatter_inputs()).
build_scatter_figure <- function(df, fig.fn, inputs, defaults = NULL) {
    fig <- NULL
    shiny::testServer(
        VizModules::dittoViz_scatterPlotServer,
        args = list(id = "wrapped", data = shiny::reactive(df), fig.fn = fig.fn, defaults = defaults),
        {
            suppressWarnings({
                do.call(session$setInputs, inputs)
                session$flushReact()
            })
            fig <<- suppressWarnings(generate_scatterPlot())
        }
    )
    plotly::plotly_build(fig)
}
