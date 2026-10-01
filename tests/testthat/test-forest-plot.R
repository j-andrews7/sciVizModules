# Tests for the forestPlot module: the model fitting is checked against the
# fits it wraps, and the figure and server structurally.

test_that("all forestPlot functions are exported", {
    for (name in c("forestPlot", "forestPlotInputsUI", "forestPlotOutputUI", "forestPlotServer", "forestPlotApp")) {
        expect_true(is.function(get0(name, envir = asNamespace("sciVizModules"))), info = name)
    }
})

test_that("Cox estimates match coxph(), with a reference row per factor", {
    data(survival_lung, package = "sciVizModules")
    est <- .forest_estimates(survival_lung, "cox", c("age", "sex", "ph.ecog"), time = "time", status = "status")
    fit <- survival::coxph(survival::Surv(time, status) ~ age + sex + ph.ecog, data = survival_lung)
    ci <- summary(fit)$conf.int

    fitted <- est[!est$reference, ]
    expect_equal(fitted$estimate, unname(ci[, "exp(coef)"]))
    expect_equal(fitted$conf.low, unname(ci[, "lower .95"]))
    expect_equal(fitted$conf.high, unname(ci[, "upper .95"]))
    expect_equal(fitted$p.value, unname(summary(fit)$coefficients[, "Pr(>|z|)"]))

    # One reference row per factor, at the null.
    expect_identical(est$label[est$reference], c("sex: Male", "ph.ecog: Asymptomatic"))
    expect_true(all(est$estimate[est$reference] == 1))
})

test_that("univariable mode fits each covariate on its own", {
    data(survival_lung, package = "sciVizModules")
    est <- .forest_estimates(survival_lung, "cox", c("age", "sex"),
        time = "time", status = "status", multivariable = FALSE)
    age <- survival::coxph(survival::Surv(time, status) ~ age, data = survival_lung)
    expect_equal(est$estimate[est$variable == "age"], unname(exp(stats::coef(age))))
    expect_identical(nrow(est), 3L)
})

test_that("logistic estimates are odds ratios and linear ones raw coefficients", {
    data(survival_lung, package = "sciVizModules")
    lg <- .forest_estimates(survival_lung, "logistic", c("age", "sex"), outcome = "status")
    g <- stats::glm(I(status == 2) ~ age + sex, data = survival_lung, family = stats::binomial())
    expect_equal(lg$estimate[!lg$reference], unname(exp(stats::coef(g))[-1]))

    ln <- .forest_estimates(survival_lung, "linear", "sex", outcome = "age")
    l <- stats::lm(age ~ sex, data = survival_lung)
    expect_equal(ln$estimate[!ln$reference], unname(stats::coef(l)[-1]))
    expect_equal(ln$estimate[ln$reference], 0)
})

test_that("bad choices fail with a readable message", {
    data(survival_lung, package = "sciVizModules")
    expect_error(.forest_estimates(survival_lung, "cox", character(0), time = "time", status = "status"),
        "at least one covariate")
    expect_error(.forest_estimates(survival_lung, "logistic", "age", outcome = "ph.ecog"), "binary outcome")
    expect_error(.forest_estimates(survival_lung, "linear", "age", outcome = "sex"), "numeric outcome")
    expect_error(.forest_estimates(survival_lung, "cox", "age", time = "time"), "time and a status")
})

test_that("forestPlot() draws a log-scale forest with a null line and an estimate table", {
    data(survival_lung, package = "sciVizModules")
    fig <- forestPlot(survival_lung, "cox", c("age", "sex"), time = "time", status = "status")
    built <- plotly::plotly_build(fig)

    expect_identical(built$x$layout$xaxis$type, "log")
    expect_identical(built$x$layout$shapes[[1]]$x0, 1)
    expect_false(built$x$data[[1]]$error_x$symmetric)
    # One table annotation per row.
    expect_length(built$x$layout$annotations, 3)

    lin <- plotly::plotly_build(forestPlot(survival_lung, "linear", "sex", outcome = "age", show.table = FALSE))
    expect_identical(lin$x$layout$xaxis$type, "linear")
    expect_identical(lin$x$layout$shapes[[1]]$x0, 0)
    expect_length(lin$x$layout$annotations, 0)

    no_ref <- attr(forestPlot(survival_lung, "cox", "sex", time = "time", status = "status",
        show.reference = FALSE), "estimates")
    expect_false(any(no_ref$reference))
})

test_that("the defaults pick survival columns and three covariates", {
    data(survival_lung, package = "sciVizModules")
    d <- .forest_defaults(survival_lung)
    expect_identical(d$time, "time")
    expect_identical(d$status, "status")
    expect_identical(d$covariates, c("age", "sex", "ph.ecog"))
    expect_identical(.forest_defaults(survival_lung, list(model = "linear"))$model, "linear")
})

test_that("the server fits the chosen model and exports the estimates", {
    data(survival_lung, package = "sciVizModules")
    shiny::testServer(
        forestPlotServer,
        args = list(data = shiny::reactive(survival_lung)),
        expr = {
            do.call(session$setInputs, c(
                list(
                    auto.update = TRUE, model = "cox", time = "time", status = "status", outcome = "status",
                    covariates = c("age", "sex"), multivariable = TRUE, conf.level = 0.95,
                    show.reference = TRUE, show.table = TRUE, sort.by = "input", digits = 2,
                    point.color = "#000000", point.size = 10, ci.color = "#000000", ci.width = 2,
                    download.format = "png"
                ),
                test_axes_inputs()
            ))
            expect_identical(plotly::plotly_build(generate_forestPlot())$x$layout$xaxis$type, "log")
            expect_identical(nrow(plot_source_reactive()$stats), 3L)

            session$setInputs(model = "logistic")
            est <- attr(generate_forestPlot(), "estimates")
            g <- stats::glm(I(status == 2) ~ age + sex, data = survival_lung, family = stats::binomial())
            expect_equal(est$estimate[!est$reference], unname(exp(stats::coef(g))[-1]))
        }
    )
})
