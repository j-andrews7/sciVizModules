# Tests for the mutationalProfile module: reading 96-channel substitution
# matrices in the layouts the common tools write, and its wrapping of the
# VizModules bar module.

test_that("the 96 channels are named and ordered as MutationalPatterns and maftools name them", {
    ch <- .sbs96_channels()
    expect_length(ch, 96)
    expect_identical(ch[1:5], c("A[C>A]A", "A[C>A]C", "A[C>A]G", "A[C>A]T", "C[C>A]A"))
    expect_identical(ch[96], "T[T>G]T")
    expect_identical(unique(substr(ch, 3, 5)), .sbs_classes)
})

test_that("every layout reads to the same long table", {
    data(example_sbs96, package = "sciVizModules")
    long <- .sbs96_long(example_sbs96)
    expect_identical(nrow(long), 96L * 6L)
    expect_identical(levels(long$context), .sbs96_channels())
    expect_identical(levels(long$sample), paste0("Tumour_", 1:6))
    expect_equal(as.vector(tapply(long$fraction, long$sample, sum)), rep(1, 6))

    m <- .sbs96_matrix(example_sbs96)
    expect_equal(.sbs96_long(m), long)                     # MutationalPatterns: 96 x samples
    expect_equal(.sbs96_long(t(m)), long)                  # maftools nmf_matrix: samples x 96
    expect_equal(.sbs96_long(example_sbs96[sample(96), ]), long) # rows reordered by a data table
})

test_that("missing channels count zero and unknown rows are ignored", {
    data(example_sbs96, package = "sciVizModules")
    part <- example_sbs96[-(1:10), ]
    part <- rbind(part, data.frame(context = "total", Tumour_1 = 1, Tumour_2 = 1, Tumour_3 = 1, Tumour_4 = 1,
        Tumour_5 = 1, Tumour_6 = 1))
    m <- .sbs96_matrix(part)
    expect_identical(dim(m), c(96L, 6L))
    expect_true(all(m[1:10, ] == 0))
    expect_error(.sbs96_matrix(data.frame(x = c("a", "b"), y = 1:2)), "No 96-channel")
})

test_that("the spectrum defaults are keys the bar module reads, and users win", {
    d <- .sbs96_defaults()
    expect_identical(d[c("x.data", "y.data", "fill.by", "facet.by", "facet.scale")],
        list(x.data = "context", y.data = "fraction", fill.by = "substitution", facet.by = "sample",
            facet.scale = "free_y"))
    expect_identical(names(d$palette.colours), .sbs_classes)
    expect_identical(.sbs96_defaults(list(y.data = "count"))$y.data, "count")
})

test_that("mutationalProfile wraps the bar module on the long table", {
    data(example_sbs96, package = "sciVizModules")
    html <- as.character(mutationalProfileInputsUI("sbs", example_sbs96))
    expect_true(grepl("sbs-x.data", html, fixed = TRUE))
    # The output renders to the bar module's output id.
    expect_true(grepl("sbs-BarPlot", as.character(VizModules::plotthis_BarPlotOutputUI("sbs")), fixed = TRUE))
    expect_true(grepl("sbs-BarPlot", as.character(mutationalProfileOutputUI("sbs")), fixed = TRUE))

    captured <- NULL
    local_mocked_bindings(
        plotthis_BarPlotServer = function(id, data, hide.inputs, hide.tabs, defaults) {
            captured <<- list(data = shiny::isolate(data()), defaults = defaults)
        }
    )
    mutationalProfileServer("sbs", shiny::reactive(example_sbs96))
    expect_identical(names(captured$data), c("context", "substitution", "sample", "count", "fraction"))
    expect_identical(captured$defaults$fill.by, "substitution")
})

test_that("mutationalProfile is registered with the Figure Builder", {
    reg <- sci_figure_builder_registry()
    expect_true("mutational" %in% names(reg))
    expect_identical(reg$mutational$dataset, "example_sbs96")
})
