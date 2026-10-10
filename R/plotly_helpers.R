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
#' @details The Axes tab styles every axis of the figure. A panel whose axes
#' must keep their own settings whatever the Axes tab says (a risk table's or a
#' tick strip's gridlines) names them in the figure's `"fixed.axes"` attribute,
#' a named list of axis properties (`list(yaxis2 = list(showgrid = FALSE))`),
#' which is applied last.
#'
#' The panels of a figure stacked with shared axes are boxed by
#' [.sci_shared_panel_borders()], since plotly draws a shared axis's lines on
#' one panel only. A faceted figure takes its panel borders from its ggplot
#' theme instead.
#'
#' @import plotly
#' @author Jacob Martin, Jared Andrews
#' @rdname INTERNAL_sci_finalize_plotly
#' @keywords internal
.sci_finalize_plotly <- function(fig, input, isolate_fn, faceted = FALSE) {
    fixed <- attr(fig, "fixed.axes")
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

    # The figure is built by now, so these direct writes are not undone by the
    # styling queued above.
    if (!isTRUE(faceted)) {
        fig <- .sci_shared_panel_borders(fig,
            showline = isolate_fn(input$axis.showline),
            mirror = isolate_fn(input$axis.mirror),
            linecolor = isolate_fn(input$axis.linecolor),
            linewidth = isolate_fn(input$axis.linewidth)
        )
    }
    for (ax in names(fixed)) {
        fig$x$layout[[ax]] <- utils::modifyList(fig$x$layout[[ax]] %||% list(), fixed[[ax]])
    }
    fig
}


#' Box each panel of a figure stacked with shared axes
#'
#' `subplot()` with `shareX` or `shareY` gives each column (or row) one axis,
#' anchored to a single panel, so plotly draws that axis's line, and its mirror,
#' on that panel only: a curve stacked over a risk table loses its top and
#' bottom border. This adds paper-anchored borders around every panel that
#' shares an axis, drawn as [build_facet_panel_borders()] draws a facet's (a
#' rectangle when mirrored, the left and bottom edges when not), and turns off
#' those panels' axis lines so no edge is drawn twice. A panel with axes of its
#' own is boxed by its axis lines and gets none.
#'
#' The panels are found from the traces that carry data, so an empty filler
#' trace (a grid's blank corner) is not boxed.
#'
#' @param fig A built `plotly` figure.
#' @param showline,mirror Logical; the Axes tab's border settings.
#' @param linecolor,linewidth Colour and width of the borders.
#' @return The figure, with the borders appended to its shapes.
#'
#' @author Jared Andrews
#' @rdname INTERNAL_sci_shared_panel_borders
#' @keywords internal
.sci_shared_panel_borders <- function(fig, showline = TRUE, mirror = TRUE, linecolor = "black", linewidth = 0.5) {
    if (!isTRUE(showline) || is.null(fig$x$layout)) {
        return(fig)
    }
    # [[ ]], not $: a trace without `x` would otherwise partially match `xaxis`.
    has_data <- function(tr) {
        !is.null(tr[["z"]]) || any(!is.na(unlist(tr[["x"]]))) || any(!is.na(unlist(tr[["y"]])))
    }
    traces <- Filter(has_data, fig$x$data)
    panels <- unique(lapply(traces, function(tr) c(tr$xaxis %||% "x", tr$yaxis %||% "y")))
    if (length(panels) < 2) {
        return(fig)
    }
    x_used <- table(vapply(panels, `[[`, "", 1))
    y_used <- table(vapply(panels, `[[`, "", 2))
    shared <- Filter(function(p) x_used[[p[1]]] > 1 || y_used[[p[2]]] > 1, panels)

    domain_of <- function(ref) fig$x$layout[[sub("^([xy])", "\\1axis", ref)]]$domain %||% c(0, 1)
    borders <- lapply(shared, function(p) {
        # Each panel is passed alone: a stack or a triangle of panels is not
        # the full row-major grid the helper maps facets onto.
        axes <- list(xaxis = list(domain = domain_of(p[1])), yaxis = list(domain = domain_of(p[2])))
        panel <- list(x = list(layout = axes))
        build_facet_panel_borders(panel, 1L,
            showline = TRUE, mirror = isTRUE(mirror),
            linecolor = linecolor %||% "black", linewidth = linewidth %||% 0.5
        )
    })
    fig$x$layout$shapes <- c(fig$x$layout$shapes, unlist(borders, recursive = FALSE))
    # The borders replace these axes' own lines, which would double the edges
    # of the panel each axis is anchored to.
    for (ref in unique(unlist(shared))) {
        fig$x$layout[[sub("^([xy])", "\\1axis", ref)]]$showline <- FALSE
    }
    fig
}
