# Smoke tests for the dose-response and Michaelis-Menten modules.
#
# The pure default helpers are covered in test-pharma-helpers.R; these exercise
# the public trio and the `*App()` factory. Anything needing the drc engine is
# skipped when that Suggested package is unavailable.

test_that("all dose-response and Michaelis-Menten functions are exported", {
    for (m in c("doseResponse", "michaelisMenten")) {
        for (suffix in c("InputsUI", "OutputUI", "Server", "App")) {
            fn <- get0(paste0(m, suffix), envir = asNamespace("sciVizModules"))
            expect_true(is.function(fn), info = paste0(m, suffix))
        }
    }
    expect_true(is.function(get0("michaelisMentenPlot", envir = asNamespace("sciVizModules"))))
})

test_that("OutputUI builds a container and honours resizable", {
    for (m in c("doseResponse", "michaelisMenten")) {
        out_fn <- get(paste0(m, "OutputUI"))
        expect_true("resizable" %in% names(formals(out_fn)), info = m)
        ui <- out_fn("test", resizable = FALSE)
        expect_true(inherits(ui, c("shiny.tag", "shiny.tag.list", "shiny.tag.function")))
    }
})

test_that("doseResponseInputsUI builds from the bundled dose_response data", {
    data(dose_response, package = "sciVizModules")
    ui <- doseResponseInputsUI("dr", dose_response)
    expect_true(inherits(ui, c("shiny.tag", "shiny.tag.list")))

    # The wrapped scatter module's mapping controls should be present.
    html <- as.character(ui)
    expect_true(grepl("dr-x.by", html, fixed = TRUE))
    expect_true(grepl("dr-y.by", html, fixed = TRUE))
})

test_that("michaelisMentenInputsUI builds from the bundled kinetics data", {
    data(mm_kinetics, package = "sciVizModules")
    ui <- michaelisMentenInputsUI("mm", mm_kinetics)
    expect_true(inherits(ui, c("shiny.tag", "shiny.tag.list")))

    html <- as.character(ui)
    for (key in c("mm-x", "mm-y", "mm-linetype")) {
        expect_true(grepl(key, html, fixed = TRUE), info = key)
    }
})

test_that("michaelisMentenPlot() builds a ggplot from the bundled data", {
    # The standalone plot function stays Shiny-free and returns a ggplot; the
    # module converts it with ggplotly() and annotates it with the fit.
    data(mm_kinetics, package = "sciVizModules")
    data(mm_kinetics_line, package = "sciVizModules")

    gg <- michaelisMentenPlot(data = mm_kinetics, model = mm_kinetics_line)
    expect_s3_class(gg, "ggplot")
})

test_that("michaelisMentenPlot() validates its two data frames", {
    data(mm_kinetics, package = "sciVizModules")
    expect_error(michaelisMentenPlot(data = "not a frame", model = mm_kinetics))
    expect_error(michaelisMentenPlot(data = mm_kinetics, model = mm_kinetics, x = "nope"))
})

test_that("the drc model backend is registered at load", {
    # .onLoad() registers it so the wrapped scatter module can fit a
    # dose-response curve. drc itself is only reached inside the backend's
    # fit(), so registration does not depend on it being installed.
    backends <- VizModules::list_model_backends()
    expect_true("drm" %in% c(as.character(backends), names(backends)))
})

test_that("*App() factories return a shiny app object", {
    skip_if_not_installed("dittoViz")
    app <- doseResponseApp()
    expect_s3_class(app, "shiny.appobj")

    app2 <- michaelisMentenApp()
    expect_s3_class(app2, "shiny.appobj")
})

test_that("michaelisMenten applies the Plotly tab's shape styling", {
    data(mm_kinetics, package = "sciVizModules")
    data(mm_kinetics_line, package = "sciVizModules")

    shiny::testServer(
        michaelisMentenServer,
        args = list(data = shiny::reactive(list(data = mm_kinetics, model = mm_kinetics_line))),
        expr = {
            do.call(session$setInputs, c(
                list(auto.update = TRUE, x = "S", y = "v", download.format = "png"),
                test_axes_inputs(), test_shape_inputs()
            ))
            newshape <- plotly::plotly_build(generate_michaelisMentenPlot())$x$layout$newshape
            expect_identical(newshape$fillcolor, "#FF0000")
            expect_identical(newshape$line$color, "#00FF00")
            expect_identical(newshape$line$dash, "dash")
            expect_identical(newshape$opacity, 0.5)
        }
    )
})
