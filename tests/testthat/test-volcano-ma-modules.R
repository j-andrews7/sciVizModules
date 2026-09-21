# Regression tests for the volcano and MA modules' wiring into the VizModules
# scatter plot module.
#
# VizModules 0.4.0 removed `manual.colors` from `dittoViz_scatterPlotServer()`.
# Both modules still passed it, so either server failed with an unused-argument
# error the moment it ran. The group colours now travel as a named `color.panel`
# vector in the `defaults` handed to the wrapped module.

de_modules <- c("volcanoPlot", "maPlot")

test_that("all volcano and MA module functions are exported", {
    for (m in de_modules) {
        for (suffix in c("InputsUI", "OutputUI", "Server", "App")) {
            fn <- get0(paste0(m, suffix), envir = asNamespace("sciVizModules"))
            expect_true(is.function(fn), info = paste0(m, suffix))
        }
    }
})

test_that("the wrapped scatter server no longer takes manual.colors", {
    # The reason these modules changed. If it ever comes back, the defaults
    # route below is redundant rather than wrong, but this should be revisited.
    expect_false(
        "manual.colors" %in% names(formals(VizModules::dittoViz_scatterPlotServer))
    )
})

test_that("DE defaults carry a color.panel mapping for the wrapped module", {
    data(airway_deseq2, package = "sciVizModules")

    for (fn in list(.volcano_defaults, .ma_defaults)) {
        d <- fn(airway_deseq2)
        expect_true("color.panel" %in% names(d))
        expect_type(d$color.panel, "character")
        expect_setequal(names(d$color.panel), c("Up", "Down", "n.s."))
        expect_identical(unname(d$color.panel[["Up"]]), "red")
        expect_identical(unname(d$color.panel[["n.s."]]), "lightgray")
    }
})

test_that("a caller-supplied color.panel wins over the scalar colour keys", {
    data(airway_deseq2, package = "sciVizModules")
    mapping <- c(Up = "#FF00FF", Down = "#00FF00", "n.s." = "#CCCCCC")

    d <- .volcano_defaults(airway_deseq2, list(color.panel = mapping))
    expect_identical(d$color.panel, mapping)

    # ... and the scalar keys still drive it when it is not supplied.
    d2 <- .volcano_defaults(airway_deseq2, list(color.up = "#123456"))
    expect_identical(unname(d2$color.panel[["Up"]]), "#123456")
})

test_that("InputsUI no longer renders a module-local group colour picker", {
    data(airway_deseq2, package = "sciVizModules")

    ui <- volcanoPlotInputsUI("de", airway_deseq2)
    html <- as.character(ui)
    expect_false(grepl("volcano.colors", html, fixed = TRUE))
    # The thresholds it does own are still there.
    expect_true(grepl("de-sig.thresh", html, fixed = TRUE))

    ui <- maPlotInputsUI("ma", airway_deseq2)
    html <- as.character(ui)
    expect_false(grepl("ma.colors", html, fixed = TRUE))
    expect_true(grepl("ma-sig.thresh", html, fixed = TRUE))
})

test_that("OutputUI accepts resizable, as the Figure Builder requires", {
    for (m in de_modules) {
        out_fn <- get(paste0(m, "OutputUI"))
        expect_true("resizable" %in% names(formals(out_fn)), info = m)
        ui <- out_fn("test", resizable = FALSE)
        expect_true(inherits(ui, c("shiny.tag", "shiny.tag.list", "shiny.tag.function")))
    }
})

test_that("the servers reach the wrapped module without an unused argument", {
    # The specific regression: `manual.colors = ` reaching a server that no
    # longer accepts it. testServer cannot drive the plotly output, so other
    # errors are possible here and are not what this asserts.
    skip_if_not_installed("dittoViz")
    data(airway_deseq2, package = "sciVizModules")

    for (m in de_modules) {
        server_fn <- get(paste0(m, "Server"))
        msg <- tryCatch(
            {
                shiny::testServer(
                    server_fn,
                    args = list(data = shiny::reactive(airway_deseq2)),
                    expr = {
                        session$setInputs(sig.thresh = 0.05, fc.thresh = 1)
                    }
                )
                ""
            },
            error = function(e) conditionMessage(e)
        )
        expect_false(grepl("unused argument", msg, fixed = TRUE), info = paste(m, msg))
    }
})
