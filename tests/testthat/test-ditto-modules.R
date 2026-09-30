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
    built <- plotly::plotly_build(.ditto_finalize_plotly(plotly::ggplotly(gg), input, identity))

    expect_false(built$x$layout$showlegend)
    expect_identical(built$x$layout$legend$font$family, "Courier New")
    expect_identical(built$x$layout$legend$font$color, "#123456")
    expect_identical(built$x$layout$legend$font$size, 11)
    expect_identical(built$x$layout$legend$xanchor, "left")

    input$legend.show <- TRUE
    built <- plotly::plotly_build(.ditto_finalize_plotly(plotly::ggplotly(gg), input, identity))
    expect_true(built$x$layout$showlegend)
})
