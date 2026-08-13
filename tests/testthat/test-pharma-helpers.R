# Unit tests for the dose-response and Michaelis-Menten helpers
# (doseResponse_helpers.R and michaelisMentenPlot_helpers.R).

test_that(".dose_response_defaults maps dose and response columns", {
    data(dose_response, package = "sciVizModules")
    d <- .dose_response_defaults(dose_response)
    expect_identical(d$x.by, "dose_uM")
    expect_identical(d$y.by, "mean_response_pct")
    expect_false(d$linear.model)
    expect_true(d$custom.model.enable)
    expect_identical(d$custom.models$model1$drc_fct, "LL.4")
    expect_identical(
        d$custom.models$model1$formula,
        "mean_response_pct ~ dose_uM"
    )
})

test_that(".dose_response_defaults falls back to numeric columns by position", {
    df <- data.frame(x = c(1, 2, 3), y = c(4, 5, 6))
    d <- .dose_response_defaults(df)
    expect_identical(d$x.by, "x")
    expect_identical(d$y.by, "y")
})

test_that(".dose_response_defaults lets user defaults win", {
    data(dose_response, package = "sciVizModules")
    d <- .dose_response_defaults(
        dose_response,
        defaults = list(x.by = "dose_uM", linear.model = TRUE)
    )
    expect_true(d$linear.model)
})

test_that(".mm_params returns NULL for NULL input", {
    expect_null(.mm_params(NULL))
})

test_that(".mm_params extracts K and Vmax from a named vector", {
    p <- .mm_params(c(K = 2.5, Vm = 10))
    expect_equal(p$K, 2.5)
    expect_equal(p$Vmax, 10)
})

test_that(".mm_params is case-insensitive and handles Vmax spelling", {
    p <- .mm_params(list(k = 1, vmax = 8))
    expect_equal(p$K, 1)
    expect_equal(p$Vmax, 8)
})

test_that(".mm_params returns NA for missing coefficients", {
    p <- .mm_params(c(K = 3))
    expect_equal(p$K, 3)
    expect_true(is.na(p$Vmax))
})

test_that(".mm_params extracts coefficients from an nls fit", {
    data(mm_kinetics, package = "sciVizModules")
    fit <- stats::nls(
        v ~ Vm * S / (K + S),
        data = mm_kinetics,
        start = list(K = max(mm_kinetics$v) / 2, Vm = max(mm_kinetics$v))
    )
    p <- .mm_params(fit)
    expect_true(is.numeric(p$K) && !is.na(p$K))
    expect_true(is.numeric(p$Vmax) && !is.na(p$Vmax))
})
