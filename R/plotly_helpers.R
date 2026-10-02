#' Apply the shared VizModules plotly styling stack to a module figure
#'
#' Applies the title, axis, legend, reference-line, config, and annotation
#' post-processing shared by the sciVizModules modules that build their own
#' figure (the dittoSeq wrappers and the native plotly modules), so the figure
#' respects the module's Axes, Legend, Lines and Plotly tab controls.
#'
#' @param fig A `plotly` figure.
#' @param input The Shiny module `input` object.
#' @param isolate_fn The isolation helper returned by
#'   [VizModules::setup_auto_update_logic()].
#' @param faceted Logical, whether the figure is split into panels (`split.by`
#'   is set, or the plot always facets). A faceted figure titles each panel, so
#'   its main title is not editable in place, and its shared axis titles and
#'   panel titles are annotations styled from the Axes tab.
#' @return The styled `plotly` figure.
#'
#' @import plotly
#' @author Jacob Martin, Jared Andrews
#' @rdname INTERNAL_sci_finalize_plotly
#' @keywords internal
.sci_finalize_plotly <- function(fig, input, isolate_fn, faceted = FALSE) {
    fig <- VizModules::apply_title_layout(
        fig, input, isolate_fn,
        title_y = 0.95,
        title_x = isolate_fn(input$axis.title.horizontal.position)
    )
    xaxis_style <- VizModules::create_axis_styles(
        input,
        axis_side = "x", isolate_fn = isolate_fn, ggplot.axis.styling = FALSE
    )
    yaxis_style <- VizModules::create_axis_styles(
        input,
        axis_side = "y", isolate_fn = isolate_fn, ggplot.axis.styling = FALSE
    )
    fig <- VizModules::apply_subplot_axis_styling(fig, xaxis_style, yaxis_style)
    if (isTRUE(faceted)) {
        fig <- apply_axis_title_to_annotations(fig, input, isolate_fn)
    }

    fig <- VizModules::add_reference_lines(fig,
        hline.intercepts = isolate_fn(input$hline.intercepts),
        hline.colors = isolate_fn(input$hline.colors),
        hline.widths = isolate_fn(input$hline.widths),
        hline.linetypes = isolate_fn(input$hline.linetypes),
        hline.opacities = isolate_fn(input$hline.opacities),
        vline.intercepts = isolate_fn(input$vline.intercepts),
        vline.colors = isolate_fn(input$vline.colors),
        vline.widths = isolate_fn(input$vline.widths),
        vline.linetypes = isolate_fn(input$vline.linetypes),
        vline.opacities = isolate_fn(input$vline.opacities),
        abline.slopes = isolate_fn(input$abline.slopes),
        abline.intercepts = isolate_fn(input$abline.intercepts),
        abline.colors = isolate_fn(input$abline.colors),
        abline.widths = isolate_fn(input$abline.widths),
        abline.linetypes = isolate_fn(input$abline.linetypes),
        abline.opacities = isolate_fn(input$abline.opacities)
    )

    config_list <- add_plot_config(
        download.format = isolate_fn(input$download.format),
        include.modebar.buttons = TRUE, facet.by = isTRUE(faceted)
    )
    fig <- do.call(config, c(list(p = fig), config_list))
    fig <- apply_plotly_newshape(fig, input, isolate_fn)

    fig <- apply_legend_styling(
        fig,
        title.size = isolate_fn(input$legend.title.size),
        text.size = isolate_fn(input$legend.text.size),
        position = c(1.02, "left"),
        font.family = isolate_fn(input$legend.font.family),
        font.color = isolate_fn(input$legend.font.color),
        show = isolate_fn(input$legend.show)
    )
    fig <- axis_titles_as_annotations(fig)
    fig
}
