# Guard for the viz_select_input() migration.
#
# VizModules replaced its own module selects with `viz_select_input()`, built on
# a virtualised dropdown, so a select fed by a high-cardinality column (every
# gene in a SingleCellExperiment, say) stays responsive. Two VizModules 0.5.0
# fixes also land only there: the length-zero guards for an input that has not
# reported yet, and multi-selects no longer dropping a deselection made from a
# value tag's x.
#
# Module UI and server functions must therefore use it rather than
# `shiny::selectInput()` / `updateSelectInput()`. The demo-app dataset pickers
# are deliberately exempt -- they are app chrome over a handful of names.

module_prefixes <- c(
    "cnSegmentPlot", "dittoBarPlot", "dittoDimHex", "dittoDimPlot",
    "dittoFreqPlot", "dittoPlot", "dittoRidgeJitter", "dittoScatterPlot",
    "doseResponse", "enrichmentDotPlot", "goFanPlot", "maPlot",
    "michaelisMenten", "survivalCurve", "volcanoPlot"
)

module_functions <- function() {
    ns <- asNamespace("sciVizModules")
    out <- list()
    for (p in module_prefixes) {
        for (suffix in c("InputsUI", "OutputUI", "Server")) {
            name <- paste0(p, suffix)
            fn <- get0(name, envir = ns)
            if (is.function(fn)) out[[name]] <- fn
        }
    }
    out
}

test_that("no module UI or server calls shiny::selectInput()", {
    for (name in names(module_functions())) {
        src <- deparse(body(module_functions()[[name]]))
        expect_false(
            any(grepl("(^|[^a-zA-Z0-9._])selectInput\\(", src)),
            info = name
        )
    }
})

test_that("no module UI or server calls updateSelectInput()", {
    for (name in names(module_functions())) {
        src <- deparse(body(module_functions()[[name]]))
        expect_false(any(grepl("updateSelectInput\\(", src)), info = name)
    }
})

test_that("the modules do call viz_select_input() / update_viz_select()", {
    # The inverse assertion, so the two tests above cannot pass vacuously if the
    # selects were simply deleted.
    fns <- module_functions()
    ui_hits <- vapply(
        names(fns)[grepl("InputsUI$", names(fns))],
        function(n) any(grepl("viz_select_input\\(", deparse(body(fns[[n]])))),
        logical(1)
    )
    expect_gte(sum(ui_hits), 10)

    server_hits <- vapply(
        names(fns)[grepl("Server$", names(fns))],
        function(n) any(grepl("update_viz_select\\(", deparse(body(fns[[n]])))),
        logical(1)
    )
    expect_gte(sum(server_hits), 10)
})

test_that("no module select still passes selectize=", {
    # viz_select_input() forwards `...` to shinyWidgets::virtualSelectInput(),
    # which has no `selectize` argument.
    for (name in names(module_functions())) {
        src <- deparse(body(module_functions()[[name]]))
        expect_false(any(grepl("selectize *=", src)), info = name)
    }
})
