# Unit and smoke tests for the survivalCurve module.
#
# The pure helpers (column detection, status normalisation, default lookup) are
# exercised directly; anything needing the survminer engine is skipped when that
# Suggested package is unavailable.

test_that("all survivalCurve functions are exported", {
    for (name in c(
        "survivalCurve", "survivalCurveInputsUI", "survivalCurveOutputUI",
        "survivalCurveServer", "survivalCurveApp"
    )) {
        expect_true(is.function(get0(name, envir = asNamespace("sciVizModules"))), info = name)
    }
})

test_that(".detect_time_col prefers an exact 'time' match", {
    df <- data.frame(age = 1, time = 2, surv_months = 3)
    num <- names(df)
    expect_identical(.detect_time_col(df, num), "time")

    # No recognizable name: fall back to the first numeric column.
    df2 <- data.frame(a = 1, b = 2)
    expect_identical(.detect_time_col(df2, names(df2)), "a")

    expect_null(.detect_time_col(df2, character(0)))
})

test_that(".detect_status_col prefers an exact 'status' match", {
    df <- data.frame(time = 1, status = 1, event_free = 0)
    expect_identical(.detect_status_col(df, names(df)), "status")

    # No named candidate: a 0/1 indicator column is taken instead.
    df2 <- data.frame(time = c(10, 20, 30), flag = c(0, 1, 1))
    expect_identical(.detect_status_col(df2, names(df2)), "flag")
})

test_that(".normalize_survival_status maps every supported encoding to 0/1", {
    expect_identical(.normalize_survival_status(c(TRUE, FALSE)), c(1L, 0L))
    # survival::Surv()'s 1/2 convention: 2 is the event.
    expect_identical(.normalize_survival_status(c(1, 2, 1)), c(0, 1, 0))
    # 0/1 is already correct and passes through.
    expect_identical(.normalize_survival_status(c(0, 1, 1)), c(0, 1, 1))
    expect_identical(.normalize_survival_status(c("Dead", "Alive")), c(1, 0))
    expect_identical(.normalize_survival_status(factor(c("yes", "no"))), c(1, 0))
    expect_true(is.na(.normalize_survival_status(c(NA_character_, "dead"))[1]))
})

test_that("survival_lung has the columns the module expects", {
    data(survival_lung, package = "sciVizModules")
    expect_s3_class(survival_lung, "data.frame")
    expect_true(all(c("time", "status", "age", "sex") %in% names(survival_lung)))
    expect_true(is.numeric(survival_lung$time))
    expect_setequal(unique(as.character(survival_lung$sex)), c("Male", "Female"))
})

test_that("OutputUI builds a plotly container and honours resizable", {
    ui <- survivalCurveOutputUI("test")
    expect_true(inherits(ui, c("shiny.tag", "shiny.tag.list", "shiny.tag.function")))
    expect_true("resizable" %in% names(formals(survivalCurveOutputUI)))
    expect_true(inherits(
        survivalCurveOutputUI("test", resizable = FALSE),
        c("shiny.tag", "shiny.tag.list", "shiny.tag.function")
    ))
})

test_that("InputsUI builds from survival_lung with detected defaults", {
    data(survival_lung, package = "sciVizModules")
    ui <- survivalCurveInputsUI("surv", survival_lung)
    expect_true(inherits(ui, c("shiny.tag", "shiny.tag.list")))

    html <- as.character(ui)
    for (key in c("surv-time", "surv-status", "surv-group.by", "surv-fun")) {
        expect_true(grepl(key, html, fixed = TRUE), info = key)
    }
})

test_that("survivalCurve() errors informatively without survminer", {
    skip_if(requireNamespace("survminer", quietly = TRUE), "survminer is installed")
    data(survival_lung, package = "sciVizModules")
    expect_error(
        survivalCurve(survival_lung, time = "time", status = "status"),
        "survminer"
    )
})

test_that("survivalCurve() builds a plotly figure", {
    skip_if_not_installed("survminer")
    data(survival_lung, package = "sciVizModules")
    fig <- survivalCurve(survival_lung, time = "time", status = "status", group.by = "sex")
    expect_s3_class(fig, "plotly")
})

test_that("the server applies every Legend tab control", {
    skip_if_not_installed("survminer")
    data(survival_lung, package = "sciVizModules")

    shiny::testServer(
        survivalCurveServer,
        args = list(data = shiny::reactive(survival_lung)),
        expr = {
            do.call(session$setInputs, c(
                list(auto.update = TRUE, time = "time", status = "status", group.by = "sex",
                     download.format = "png"),
                test_axes_inputs(), test_legend_inputs()
            ))
            built <- plotly::plotly_build(generate_survivalCurve())
            expect_false(built$x$layout$showlegend)
            expect_identical(built$x$layout$legend$font$family, "Courier New")
            expect_identical(built$x$layout$legend$font$color, "#123456")
        }
    )
})

test_that("Group By leaves out columns with too many levels to draw a curve each", {
    df <- data.frame(
        time = seq_len(60),
        status = rep(c(0, 1), 30),
        patient = paste0("p", seq_len(60)),
        arm = rep(c("A", "B"), 30),
        stringsAsFactors = FALSE
    )
    choices_of <- function(html, id) {
        config <- regmatches(html, regexpr(paste0("data-for=\"", id, "\">.*?</script>"), html))
        opts <- jsonlite::fromJSON(sub("</script>$", "", sub("^data-for=\"[^\"]+\">", "", config)))$options
        unlist(opts$choices$value %||% lapply(opts$choices, function(g) g$value))
    }

    groups <- choices_of(as.character(survivalCurveInputsUI("surv", df)), "surv-group.by")
    expect_true("arm" %in% groups)
    expect_false("patient" %in% groups)
})
