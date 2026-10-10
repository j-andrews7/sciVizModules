# Unit tests for the package-wide helpers: the example-data loader, the
# group-colour validator, and the debounced free-text reader.

test_that(".sci_example_data loads a bundled dataset without attaching it", {
    df <- .sci_example_data("airway_deseq2")
    expect_s3_class(df, "data.frame")
    expect_true("log2FoldChange" %in% names(df))

    seg <- .sci_example_data("example_cn_segment")
    expect_s3_class(seg, "CNSegment")
})

test_that(".sci_example_data errors clearly on an unknown dataset", {
    expect_error(suppressWarnings(.sci_example_data("no_such_dataset")))
})

test_that("every *App() default dataset resolves", {
    # DESCRIPTION sets no LazyData, so these are not promises in the namespace
    # and must go through .sci_example_data(). A bare reference would fail with
    # "object not found" for anyone who had not run data() first.
    for (name in c(
        "airway_deseq2", "dose_response", "example_enrichment", "example_sce",
        "example_cn_segment", "mm_kinetics", "mm_kinetics_line",
        "mm_kinetics_fit", "survival_lung", "example_sbs96"
    )) {
        expect_false(is.null(.sci_example_data(name)), info = name)
    }
})

test_that(".sci_debounced_input defaults to a 700ms delay", {
    # 700ms matches what VizModules uses for the ComplexHeatmap filter inputs.
    args <- formals(.sci_debounced_input)
    expect_identical(eval(args$millis), 700)
    expect_true(all(c("input", "key", "params", "millis") %in% names(args)))
})

test_that("the free-text inputs that feed a plot are debounced", {
    # cnSegmentPlot's gene list and title, and dittoDimHex's colour method, are
    # read through .sci_debounced_input() rather than straight off `input`.
    src <- deparse(body(cnSegmentPlotServer))
    expect_true(any(grepl(".sci_debounced_input", src, fixed = TRUE)))
    expect_false(any(grepl("isolate_fn(input$label.genes)", src, fixed = TRUE)))

    src <- deparse(body(dittoDimHexServer))
    expect_true(any(grepl(".sci_debounced_input", src, fixed = TRUE)))
    expect_false(any(grepl("isolate_fn(input$color.method)", src, fixed = TRUE)))
})

test_that("the modules that render a colour picker read a server-side store", {
    # setup_group_colors() holds the resolved mapping, so a rebuilt picker
    # echoing what the server seeded it with does not re-render the plot. The
    # .sci_plot_server() modules render theirs through .sci_palette_picker_ui().
    servers <- c(
        "dittoBarPlotServer", "dittoDimPlotServer", "dittoFreqPlotServer",
        "dittoPlotServer", "dittoRidgeJitterServer", "dittoScatterPlotServer"
    )
    for (name in servers) {
        src <- deparse(body(get(name, envir = asNamespace("sciVizModules"))))
        expect_true(any(grepl("setup_group_colors", src, fixed = TRUE)), info = name)
        expect_true(any(grepl("palette_store()", src, fixed = TRUE)), info = name)
        expect_false(
            any(grepl("isolate_fn(input$palette.colours)", src, fixed = TRUE)),
            info = name
        )
        # Reset restores the picker, to the mapping in `defaults` when one is given.
        expect_true(any(grepl("reset_group_colors(session, \"palette.colours\"", src, fixed = TRUE)), info = name)
        expect_true(any(grepl("default_group_colors(defaults, \"palette.colours\")", src, fixed = TRUE)), info = name)
    }
})

test_that(".sci_discrete_cols offers the categorical columns with few enough levels", {
    df <- data.frame(
        id = paste0("gene", seq_len(60)),
        grp = rep(c("a", "b", "c"), 20),
        fct = factor(rep(c("x", "y"), 30)),
        flag = rep(c(TRUE, FALSE), 30),
        dose = rep(c(1, 10, 100), 20),
        value = seq_len(60) / 7,
        stringsAsFactors = FALSE
    )
    expect_identical(.sci_discrete_cols(df), c("grp", "fct", "flag"))
    expect_identical(.sci_discrete_cols(df, numeric = TRUE), c("grp", "fct", "flag", "dose"))
    # The cap is the caller's to move.
    expect_identical(.sci_discrete_cols(df, max.levels = 100), c("id", "grp", "fct", "flag"))
    expect_identical(.sci_discrete_cols(df, max.levels = 3), c("fct", "flag"))
    expect_identical(.sci_discrete_cols(NULL), character(0))
    expect_identical(.sci_discrete_cols(data.frame()), character(0))
})

test_that(".sci_shared_panel_borders boxes each panel that shares an axis", {
    top <- plotly::plot_ly(x = 1:3, y = 1:3, type = "scatter", mode = "lines")
    bottom <- plotly::plot_ly(x = 1:3, y = 3:1, type = "scatter", mode = "lines")
    stacked <- plotly::plotly_build(plotly::subplot(top, bottom, nrows = 2, shareX = TRUE))
    domains <- function(lay) list(lay$yaxis$domain, lay$yaxis2$domain)

    boxed <- .sci_shared_panel_borders(stacked, showline = TRUE, mirror = TRUE)
    rects <- boxed$x$layout$shapes
    expect_length(rects, 2)
    expect_true(all(vapply(rects, function(s) identical(s$type, "rect") && identical(s$xref, "paper"), logical(1))))
    expect_setequal(lapply(rects, function(s) c(s$y0, s$y1)), domains(stacked$x$layout))
    # The borders stand in for the shared axes' own lines.
    expect_false(boxed$x$layout$xaxis$showline)
    expect_false(boxed$x$layout$yaxis2$showline)

    # Unmirrored: the left and bottom edge of each panel.
    open <- .sci_shared_panel_borders(stacked, showline = TRUE, mirror = FALSE)$x$layout$shapes
    expect_length(open, 4)
    expect_true(all(vapply(open, function(s) identical(s$type, "line"), logical(1))))
    expect_length(.sci_shared_panel_borders(stacked, showline = FALSE)$x$layout$shapes, 0)
    # Inputs that have not reported yet draw nothing.
    expect_length(.sci_shared_panel_borders(stacked, showline = NULL)$x$layout$shapes, 0)

    # Panels with axes of their own are boxed by them.
    free <- plotly::plotly_build(plotly::subplot(top, bottom, nrows = 2, shareX = FALSE))
    expect_length(.sci_shared_panel_borders(free)$x$layout$shapes, 0)

    # An empty filler holds a grid cell but is not a panel to box.
    filler <- plotly::plot_ly(type = "scatter", mode = "markers")
    grid <- plotly::plotly_build(plotly::subplot(top, filler, bottom, plotly::plot_ly(x = 1:3, y = 1:3,
        type = "scatter", mode = "lines"), nrows = 2, shareX = TRUE, shareY = TRUE))
    expect_length(.sci_shared_panel_borders(grid)$x$layout$shapes, 3)
})

test_that(".sci_finalize_plotly keeps a panel's fixed axes over the Axes tab", {
    input <- c(utils::modifyList(test_axes_inputs(), list(show.grid.x = TRUE, show.grid.y = TRUE)),
        test_legend_inputs(), list(download.format = "png"))
    top <- plotly::plot_ly(x = 1:3, y = 1:3, type = "scatter", mode = "lines")
    fig <- plotly::subplot(top, top, nrows = 2, shareX = TRUE)
    attr(fig, "fixed.axes") <- list(yaxis2 = list(showgrid = FALSE))
    lay <- plotly::plotly_build(.sci_finalize_plotly(fig, input, identity))$x$layout
    expect_true(lay$yaxis$showgrid)
    expect_false(lay$yaxis2$showgrid)
    expect_length(lay$shapes, 2)

    # A faceted figure takes its borders from its ggplot theme.
    lay <- plotly::plotly_build(.sci_finalize_plotly(fig, input, identity, faceted = TRUE))$x$layout
    expect_length(lay$shapes, 0)
})
