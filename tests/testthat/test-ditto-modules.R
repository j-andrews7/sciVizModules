# Smoke tests for the dittoSeq-based RNA-seq modules.
#
# These exercise the public trio (`*InputsUI`, `*OutputUI`, `*Server`) and the
# `*App()` factory for each module. UI construction is validated against the
# bundled `example_sce` dataset; anything that needs the dittoSeq engine is
# skipped when the (Bioconductor) dependency is unavailable.

ditto_modules <- c(
    "dittoDimPlot",
    "dittoScatterPlot",
    "dittoPlot",
    "dittoBarPlot",
    "dittoDimHex",
    "dittoFreqPlot",
    "dittoRidgeJitter"
)

test_that("all ditto module functions are exported", {
    for (m in ditto_modules) {
        for (suffix in c("InputsUI", "OutputUI", "Server", "App")) {
            fn <- get0(paste0(m, suffix), envir = asNamespace("sciVizModules"))
            expect_true(is.function(fn), info = paste0(m, suffix))
        }
    }
})

test_that("OutputUI builds a plotly output container", {
    for (m in ditto_modules) {
        out_fn <- get(paste0(m, "OutputUI"))
        ui <- out_fn("test")
        expect_true(inherits(ui, c("shiny.tag", "shiny.tag.list", "shiny.tag.function")))
    }
})

test_that("InputsUI builds UI from example_sce", {
    skip_if_not_installed("dittoSeq")
    skip_if_not_installed("SingleCellExperiment")
    data(example_sce, package = "sciVizModules")
    for (m in ditto_modules) {
        in_fn <- get(paste0(m, "InputsUI"))
        ui <- in_fn("test", example_sce)
        expect_true(inherits(ui, c("shiny.tag", "shiny.tag.list")))
    }
})

test_that("example_sce has the expected structure", {
    skip_if_not_installed("SingleCellExperiment")
    data(example_sce, package = "sciVizModules")
    expect_s4_class(example_sce, "SingleCellExperiment")
    cd <- SummarizedExperiment::colData(example_sce)
    expect_true(all(c("clustering", "condition", "sample", "nCount") %in% colnames(cd)))
    expect_true(length(SingleCellExperiment::reducedDimNames(example_sce)) >= 1)
})

test_that("every Legend tab control reaches the figure", {
    data(example_sce, package = "sciVizModules")
    for (m in ditto_modules) {
        html <- as.character(get(paste0(m, "InputsUI"))("test", example_sce))
        for (key in names(test_legend_inputs())) {
            expect_true(grepl(paste0("test-", key), html, fixed = TRUE), info = paste(m, key))
        }
    }

    gg <- ggplot2::ggplot(mtcars, ggplot2::aes(wt, mpg, colour = factor(cyl))) +
        ggplot2::geom_point()
    input <- c(test_axes_inputs(), test_legend_inputs(), list(download.format = "svg"))
    built <- plotly::plotly_build(.sci_finalize_plotly(plotly::ggplotly(gg), input, identity))

    expect_false(built$x$layout$showlegend)
    expect_identical(built$x$layout$legend$font$family, "Courier New")
    expect_identical(built$x$layout$legend$font$color, "#123456")
    expect_identical(built$x$layout$legend$font$size, 11)
    expect_identical(built$x$layout$legend$xanchor, "left")

    input$legend.show <- TRUE
    built <- plotly::plotly_build(.sci_finalize_plotly(plotly::ggplotly(gg), input, identity))
    expect_true(built$x$layout$showlegend)
})

test_that("a faceted figure styles its panel and axis titles and drops the editable main title", {
    gg <- ggplot2::ggplot(mtcars, ggplot2::aes(wt, mpg)) +
        ggplot2::geom_point() +
        ggplot2::facet_wrap(~cyl)
    input <- c(
        test_axes_inputs(), test_legend_inputs(),
        list(
            download.format = "svg", facet.title.font.size = 21,
            facet.title.font.color = "#654321", facet.title.font.family = "Courier New"
        )
    )

    built <- plotly::plotly_build(.sci_finalize_plotly(plotly::ggplotly(gg), input, identity, faceted = TRUE))
    expect_false(built$x$config$edits$titleText)
    annos <- built$x$layout$annotations
    is_axis <- vapply(annos, function(a) identical(a$annotationType, "axis"), logical(1))
    is_panel <- vapply(annos, function(a) is.null(a$annotationType) && identical(a$xanchor, "center"), logical(1))
    expect_true(any(is_axis))
    expect_true(any(is_panel))
    for (a in annos[is_axis]) expect_identical(a$font$size, 14)
    for (a in annos[is_panel]) {
        expect_identical(a$font$size, 21)
        expect_identical(a$font$color, "#654321")
        expect_identical(a$font$family, "Courier New")
    }

    built <- plotly::plotly_build(.sci_finalize_plotly(plotly::ggplotly(gg), input, identity))
    expect_true(built$x$config$edits$titleText)
})

test_that("the title inputs follow whether split.by facets the plot", {
    skip_if_not_installed("dittoSeq")
    data(example_sce, package = "sciVizModules")

    calls <- list()
    local_mocked_bindings(
        toggle_facet_title_inputs = function(session, faceted, extra = NULL, hidden = NULL) {
            calls[[length(calls) + 1]] <<- list(faceted = faceted, hidden = hidden)
        }
    )

    shiny::testServer(
        dittoDimPlotServer,
        args = list(data = shiny::reactive(example_sce), hide.inputs = "title.font.size"),
        expr = {
            session$setInputs(split.by = "")
            session$setInputs(split.by = "condition")
        }
    )

    expect_identical(vapply(calls, function(x) x$faceted, logical(1)), c(FALSE, TRUE))
    expect_identical(calls[[2]]$hidden, "title.font.size")
})

test_that("split.by makes a dittoSeq module figure faceted", {
    skip_if_not_installed("dittoSeq")
    data(example_sce, package = "sciVizModules")

    shiny::testServer(
        dittoDimPlotServer,
        args = list(data = shiny::reactive(example_sce)),
        expr = {
            do.call(session$setInputs, c(
                list(
                    auto.update = TRUE, var = "clustering", download.format = "png",
                    reduction.use = SingleCellExperiment::reducedDimNames(example_sce)[1],
                    dim.1 = 1, dim.2 = 2, size = 1, opacity = 1, order = "unordered",
                    do.label = FALSE, do.ellipse = FALSE, do.contour = FALSE, labels.size = 5,
                    min.color = "#F0E442", max.color = "#0072B2", split.by = ""
                ),
                test_axes_inputs(), test_legend_inputs()
            ))
            expect_true(plotly::plotly_build(generate_dittoDimPlot())$x$config$edits$titleText)

            session$setInputs(split.by = "condition")
            expect_false(plotly::plotly_build(generate_dittoDimPlot())$x$config$edits$titleText)
        }
    )
})

test_that("dittoFreqPlot, which always facets by var level, finishes as a faceted figure", {
    skip_if_not_installed("dittoSeq")
    data(example_sce, package = "sciVizModules")

    shiny::testServer(
        dittoFreqPlotServer,
        args = list(data = shiny::reactive(example_sce)),
        expr = {
            do.call(session$setInputs, c(
                list(
                    auto.update = TRUE, var = "clustering", group.by = "condition", sample.by = "sample",
                    color.by = "", plots = c("boxplot", "jitter"), scale = "percent", max.normalize = FALSE,
                    jitter.size = 1, jitter.width = 0.2, jitter.color = "black", boxplot.width = 0.4,
                    vlnplot.width = 1, download.format = "png"
                ),
                test_axes_inputs(), test_legend_inputs()
            ))
            expect_false(plotly::plotly_build(generate_dittoFreqPlot())$x$config$edits$titleText)
        }
    )
})

test_that("jittered points keep their positions when the plot rebuilds", {
    skip_if_not_installed("dittoSeq")
    data(example_sce, package = "sciVizModules")

    point_x <- function(fig) {
        traces <- Filter(function(tr) identical(tr$mode, "markers"), fig$x$data)
        unlist(lapply(traces, function(tr) tr$x))
    }

    shiny::testServer(
        dittoFreqPlotServer,
        args = list(data = shiny::reactive(example_sce)),
        expr = {
            do.call(session$setInputs, c(
                list(
                    auto.update = TRUE, var = "clustering", group.by = "condition", sample.by = "sample",
                    color.by = "", plots = c("boxplot", "jitter"), scale = "percent", max.normalize = FALSE,
                    jitter.size = 1, jitter.width = 0.2, jitter.color = "black", boxplot.width = 0.4,
                    vlnplot.width = 1, download.format = "png"
                ),
                test_axes_inputs(), test_legend_inputs()
            ))
            first <- point_x(generate_dittoFreqPlot())

            # Any change rebuilds the figure, which draws the jitter afresh.
            session$setInputs(jitter.size = 2)
            expect_true(length(first) > 0)
            expect_identical(point_x(generate_dittoFreqPlot()), first)
        }
    )
})
