#' Apply the shared VizModules plotly styling stack to a module figure
#'
#' The styling step of the sciVizModules modules that build their own figure
#' (the dittoSeq wrappers and the native plotly modules):
#' [VizModules::apply_uniform_styling()] with the panel handling those figures
#' need, so the figure respects the module's Axes, Legend, Lines and Plotly tab
#' controls. It reads only inputs that style the figure, so it belongs after the
#' module's [VizModules::cached_structure()] step.
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
    fig <- apply_uniform_styling(
        fig, input, isolate_fn,
        facet.by = isTRUE(faceted), title_y = 0.95,
        ggplot.axis.styling = FALSE, legend.position = c(1.02, "left")
    )

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
