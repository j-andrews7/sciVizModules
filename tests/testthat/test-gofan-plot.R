# Smoke tests for the goFanPlot (GO enrichment sunburst) module.
#
# These exercise the public trio (`InputsUI`, `OutputUI`, `Server`), the `App()`
# factory, the core `goFanPlot()` function, and the column-detection helpers on
# the bundled `example_enrichment` dataset. Anything that needs the GOfan engine
# or an OrgDb annotation package is skipped/expected to error informatively when
# those dependencies are unavailable.

test_that("all goFanPlot functions are exported", {
    for (nm in c(
        "goFanPlot", "goFanPlotInputsUI", "goFanPlotOutputUI",
        "goFanPlotServer", "goFanPlotApp"
    )) {
        fn <- get0(nm, envir = asNamespace("sciVizModules"))
        expect_true(is.function(fn), info = nm)
    }
})

test_that("column-detection helpers pick sensible defaults from example_enrichment", {
    data(example_enrichment, package = "sciVizModules")

    expect_identical(sciVizModules:::.gofan_id_col(example_enrichment), "ID")
    expect_identical(sciVizModules:::.gofan_onto(example_enrichment), "BP")
    expect_identical(sciVizModules:::.gofan_fill_col(example_enrichment), "qvalue")
    expect_identical(sciVizModules:::.gofan_subrect_col(example_enrichment), "Count")
})

test_that(".gofan_id_col detects GO-like values in non-ID columns", {
    df <- data.frame(
        term = c("GO:0006955", "GO:0002250"),
        score = c(1, 2),
        stringsAsFactors = FALSE
    )
    expect_identical(sciVizModules:::.gofan_id_col(df), "term")
})

test_that(".gofan_onto defaults to BP when no ontology column is present", {
    df <- data.frame(ID = "GO:0006955", qvalue = 0.01, stringsAsFactors = FALSE)
    expect_identical(sciVizModules:::.gofan_onto(df), "BP")
})

test_that(".resolve_orgdb errors informatively for a missing package", {
    expect_error(
        sciVizModules:::.resolve_orgdb("org.NotAReal.eg.db"),
        "org.NotAReal.eg.db"
    )
})

test_that("goFanPlot validates its inputs", {
    data(example_enrichment, package = "sciVizModules")

    # Missing columns are reported before any GOfan work is attempted.
    if (requireNamespace("GOfan", quietly = TRUE)) {
        expect_error(goFanPlot(example_enrichment, term.id = "not_a_col"), "not_a_col")
    } else {
        # Without GOfan the function should fail with a clear installation hint.
        expect_error(goFanPlot(example_enrichment), "GOfan")
    }
})

test_that("OutputUI builds a plotly output container", {
    skip_if_not_installed("VizModules")
    ui <- goFanPlotOutputUI("test")
    expect_true(inherits(ui, c("shiny.tag", "shiny.tag.list", "shiny.tag.function")))
})

test_that("InputsUI builds UI from example_enrichment", {
    skip_if_not_installed("VizModules")
    data(example_enrichment, package = "sciVizModules")
    ui <- goFanPlotInputsUI("test", example_enrichment)
    expect_true(inherits(ui, c("shiny.tag", "shiny.tag.list")))
})
