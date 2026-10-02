# Tests for the rocCurve module. Curves, AUCs and cut-offs are checked against
# pROC where it is installed.

test_that("all rocCurve functions are exported", {
    for (name in c("rocCurve", "rocCurveInputsUI", "rocCurveOutputUI", "rocCurveServer", "rocCurveApp")) {
        expect_true(is.function(get0(name, envir = asNamespace("sciVizModules"))), info = name)
    }
})

test_that("curves, AUCs and Youden cut-offs match pROC", {
    skip_if_not_installed("pROC")
    data(example_biomarkers, package = "sciVizModules")
    d <- example_biomarkers
    case <- d$disease == "Disease"
    for (p in c("marker_strong", "marker_moderate", "marker_weak", "age")) {
        r <- pROC::roc(d$disease, d[[p]], levels = c("Healthy", "Disease"), quiet = TRUE)
        ours <- .roc_curve(case, d[[p]])
        expect_equal(ours$auc, as.numeric(pROC::auc(r)), info = p)
        expect_identical(ours$direction, r$direction, info = p)
        expect_equal(sort(ours$curve$sensitivity), sort(r$sensitivities), info = p)
        expect_equal(sort(ours$curve$specificity), sort(r$specificities), info = p)
        expect_equal(ours$youden$threshold,
            pROC::coords(r, "best", ret = "threshold", best.method = "youden")$threshold[1], info = p)
    }
    ci <- .roc_ci(case, d$marker_strong, "<")
    expect_equal(ci, as.numeric(pROC::ci.auc(pROC::roc(case, d$marker_strong, levels = c(FALSE, TRUE),
        direction = "<", quiet = TRUE)))[c(1, 3)])
})

test_that("ties count one half and direction can be forced", {
    case <- c(TRUE, TRUE, FALSE, FALSE)
    expect_equal(.roc_curve(case, c(2, 1, 1, 0))$auc, 0.875)
    lower <- .roc_curve(case, c(0, 1, 2, 3), direction = ">")
    expect_identical(lower$direction, ">")
    expect_equal(lower$auc, 1)
    # Forcing the wrong direction gives the complementary AUC.
    expect_equal(.roc_curve(case, c(0, 1, 2, 3), direction = "<")$auc, 0)
})

test_that("the outcome's case level can be chosen", {
    out <- .roc_outcome(factor(c("a", "b", "a")))
    expect_identical(out$positive, "b")
    expect_identical(.roc_outcome(c(0, 1, 1), positive = 0)$case, c(TRUE, FALSE, FALSE))
    expect_error(.roc_outcome(c("a", "b", "c")), "exactly two")
    expect_error(.roc_outcome(c("a", "b"), positive = "z"), "not a value")
})

test_that("the plot has one curve per predictor, a diagonal and the AUC in the legend", {
    data(example_biomarkers, package = "sciVizModules")
    fig <- rocCurve(example_biomarkers, "disease", c("marker_strong", "marker_weak"), ci = FALSE)
    built <- plotly::plotly_build(fig)
    lines <- Filter(function(tr) identical(tr$mode, "lines"), built$x$data)
    expect_length(lines, 2)
    expect_match(lines[[1]]$name, "AUC 0\\.9")
    expect_identical(built$x$layout$shapes[[1]]$x1, 1)
    expect_identical(built$x$layout$xaxis$title$text, "1 - Specificity")
    table <- attr(fig, "table")
    expect_identical(table$predictor, c("marker_strong", "marker_weak"))
    expect_identical(table$cases + table$controls, c(300L, 300L))
    expect_error(rocCurve(example_biomarkers, "disease", "sex"), "numeric predictor")
})

test_that("the server builds, finishes and exports the AUC table", {
    data(example_biomarkers, package = "sciVizModules")
    shiny::testServer(
        rocCurveServer,
        args = list(data = shiny::reactive(example_biomarkers)),
        expr = {
            do.call(session$setInputs, c(
                list(auto.update = TRUE, response = "disease", positive = "Disease",
                    predictors = c("marker_strong", "marker_moderate"), direction = "auto", ci = FALSE,
                    show.youden = TRUE, download.format = "png"),
                test_axes_inputs(), test_legend_inputs()
            ))
            built <- plotly::plotly_build(generate_plot())
            expect_false(built$x$layout$showlegend)
            expect_identical(nrow(plot_source_reactive()$stats), 2L)
        }
    )
    d <- .roc_defaults(example_biomarkers)
    expect_identical(c(d$response, d$positive), c("disease", "Disease"))
    expect_true(inherits(rocCurveInputsUI("r", example_biomarkers), c("shiny.tag", "shiny.tag.list")))
})
