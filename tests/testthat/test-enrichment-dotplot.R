# Smoke tests for the enrichmentDotPlot module.
#
# These exercise the public trio (`InputsUI`, `OutputUI`, `Server`), the `App()`
# factory, the enrichment data preparation helpers, and the bundled
# `example_enrichment` dataset. Anything that needs the VizModules/plotthis
# engine is skipped when those dependencies are unavailable.

test_that("all enrichmentDotPlot functions are exported", {
    for (suffix in c("InputsUI", "OutputUI", "Server", "App")) {
        fn <- get0(paste0("enrichmentDotPlot", suffix), envir = asNamespace("sciVizModules"))
        expect_true(is.function(fn), info = suffix)
    }
})

test_that("example_enrichment has the expected structure", {
    data(example_enrichment, package = "sciVizModules")
    expect_s3_class(example_enrichment, "data.frame")
    expect_true(all(c("Cluster", "Description", "GeneRatio", "pvalue", "p.adjust") %in%
        names(example_enrichment)))
    expect_gt(nrow(example_enrichment), 0)
})

test_that(".prepare_enrichment augments enrichment data with sensible mappings", {
    prep <- .prepare_enrichment(example_enrichment)

    expect_true(is.numeric(prep$data$GeneRatio))
    expect_true("neg_log10_pvalue" %in% names(prep$data))
    expect_identical(prep$mapping$y, "Description")
    expect_identical(prep$mapping$x, "Cluster")
    expect_identical(prep$mapping$size, "GeneRatio")
    expect_identical(prep$mapping$fill, "neg_log10_pvalue")
})

test_that(".prepare_enrichment creates a grouping column when none exists", {
    single <- example_enrichment[
        example_enrichment$Cluster == "Upregulated",
        c("ID", "Description", "GeneRatio", "pvalue", "p.adjust", "Count")
    ]
    prep <- .prepare_enrichment(single)
    expect_true("Group" %in% names(prep$data))
    expect_identical(prep$mapping$x, "Group")
})

test_that(".parse_ratio converts fraction strings to numeric ratios", {
    expect_equal(.parse_ratio(c("8/196", "1/2")), c(8 / 196, 0.5))
    expect_equal(.parse_ratio(c(0.5, 0.25)), c(0.5, 0.25))
    expect_true(is.na(.parse_ratio("not_a_ratio")))
})

test_that("OutputUI builds a plotly output container", {
    skip_if_not_installed("VizModules")
    ui <- enrichmentDotPlotOutputUI("test")
    expect_true(inherits(ui, c("shiny.tag", "shiny.tag.list", "shiny.tag.function")))
})

test_that("InputsUI builds UI from example_enrichment", {
    skip_if_not_installed("VizModules")
    skip_if_not_installed("plotthis")
    ui <- enrichmentDotPlotInputsUI("test", example_enrichment)
    expect_true(inherits(ui, c("shiny.tag", "shiny.tag.list")))
})
