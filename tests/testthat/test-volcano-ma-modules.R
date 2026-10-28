# Tests for the volcano and MA modules' wiring into the VizModules scatter plot
# module.
#
# Both are thin wrappers: they add threshold controls and an auto-generated
# Up/Down/n.s. grouping, then hand everything else to
# `dittoViz_scatterPlotServer()`. The group colours travel to it as a named
# `color.panel` vector in `defaults`, which is what keeps them editable on its
# Colors tab and covered by its Reset.

de_modules <- c("volcanoPlot", "maPlot")

test_that("all volcano and MA module functions are exported", {
    for (m in de_modules) {
        for (suffix in c("InputsUI", "OutputUI", "Server", "App")) {
            fn <- get0(paste0(m, suffix), envir = asNamespace("sciVizModules"))
            expect_true(is.function(fn), info = paste0(m, suffix))
        }
    }
})

test_that("every argument these modules pass is in the wrapped server's signature", {
    args <- names(formals(VizModules::dittoViz_scatterPlotServer))
    expect_true(all(c("id", "data", "hide.inputs", "hide.tabs", "defaults") %in% args))
    # Colours reach it through `defaults`; there is no colour argument of its own.
    expect_false("manual.colors" %in% args)
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

test_that("InputsUI leaves group colours to the wrapped module's picker", {
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

test_that("the servers reach the wrapped module with arguments it accepts", {
    # testServer cannot drive the plotly output, so other errors are possible
    # here; this asserts only that nothing is passed that the wrapped server
    # does not take.
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
