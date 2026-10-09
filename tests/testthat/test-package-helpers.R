# Unit tests for the package-wide helpers: the example-data loader, the
# group-colour validator, and the debounced free-text reader.

test_that(".sci_example_data loads a bundled dataset without attaching it", {
    df <- .sci_example_data("airway_deseq2")
    expect_s3_class(df, "data.frame")
    expect_true("log2FoldChange" %in% names(df))

    seg <- .sci_example_data("example_cn_segment")
    expect_s3_class(seg, "CNSegment")
})

test_that(".sci_example_data errors clearly on an unknown dataset", {
    expect_error(suppressWarnings(.sci_example_data("no_such_dataset")))
})

test_that("every *App() default dataset resolves", {
    # DESCRIPTION sets no LazyData, so these are not promises in the namespace
    # and must go through .sci_example_data(). A bare reference would fail with
    # "object not found" for anyone who had not run data() first.
    for (name in c(
        "airway_deseq2", "dose_response", "example_enrichment", "example_sce",
        "example_cn_segment", "mm_kinetics", "mm_kinetics_line",
        "mm_kinetics_fit", "survival_lung", "example_sbs96"
    )) {
        expect_false(is.null(.sci_example_data(name)), info = name)
    }
})

test_that(".sci_debounced_input defaults to a 700ms delay", {
    # 700ms matches what VizModules uses for the ComplexHeatmap filter inputs.
    args <- formals(.sci_debounced_input)
    expect_identical(eval(args$millis), 700)
    expect_true(all(c("input", "key", "params", "millis") %in% names(args)))
})

test_that("the free-text inputs that feed a plot are debounced", {
    # cnSegmentPlot's gene list and title, and dittoDimHex's colour method, are
    # read through .sci_debounced_input() rather than straight off `input`.
    src <- deparse(body(cnSegmentPlotServer))
    expect_true(any(grepl(".sci_debounced_input", src, fixed = TRUE)))
    expect_false(any(grepl("isolate_fn(input$label.genes)", src, fixed = TRUE)))

    src <- deparse(body(dittoDimHexServer))
    expect_true(any(grepl(".sci_debounced_input", src, fixed = TRUE)))
    expect_false(any(grepl("isolate_fn(input$color.method)", src, fixed = TRUE)))
})

test_that("the modules that render a colour picker read a server-side store", {
    # setup_group_colors() holds the resolved mapping, so a rebuilt picker
    # echoing what the server seeded it with does not re-render the plot.
    servers <- c(
        "dittoBarPlotServer", "dittoDimPlotServer", "dittoFreqPlotServer",
        "dittoPlotServer", "dittoRidgeJitterServer", "dittoScatterPlotServer",
        "survivalCurveServer"
    )
    for (name in servers) {
        src <- deparse(body(get(name, envir = asNamespace("sciVizModules"))))
        expect_true(any(grepl("setup_group_colors", src, fixed = TRUE)), info = name)
        expect_true(any(grepl("palette_store()", src, fixed = TRUE)), info = name)
        expect_false(
            any(grepl("isolate_fn(input$palette.colours)", src, fixed = TRUE)),
            info = name
        )
        # Reset restores the picker, to the mapping in `defaults` when one is given.
        expect_true(any(grepl("reset_group_colors(session, \"palette.colours\"", src, fixed = TRUE)), info = name)
        expect_true(any(grepl("default_group_colors(defaults, \"palette.colours\")", src, fixed = TRUE)), info = name)
    }
})

test_that(".sci_discrete_cols offers the categorical columns with few enough levels", {
    df <- data.frame(
        id = paste0("gene", seq_len(60)),
        grp = rep(c("a", "b", "c"), 20),
        fct = factor(rep(c("x", "y"), 30)),
        flag = rep(c(TRUE, FALSE), 30),
        dose = rep(c(1, 10, 100), 20),
        value = seq_len(60) / 7,
        stringsAsFactors = FALSE
    )
    expect_identical(.sci_discrete_cols(df), c("grp", "fct", "flag"))
    expect_identical(.sci_discrete_cols(df, numeric = TRUE), c("grp", "fct", "flag", "dose"))
    # The cap is the caller's to move.
    expect_identical(.sci_discrete_cols(df, max.levels = 100), c("id", "grp", "fct", "flag"))
    expect_identical(.sci_discrete_cols(df, max.levels = 3), c("fct", "flag"))
    expect_identical(.sci_discrete_cols(NULL), character(0))
    expect_identical(.sci_discrete_cols(data.frame()), character(0))
})
