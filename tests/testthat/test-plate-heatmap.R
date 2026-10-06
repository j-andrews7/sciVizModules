# Tests for the plateHeatmap module and its plate helpers.

test_that("all plateHeatmap functions are exported", {
    for (name in c("plateHeatmap", "plateHeatmapInputsUI", "plateHeatmapOutputUI", "plateHeatmapServer",
        "plateHeatmapApp")) {
        expect_true(is.function(get0(name, envir = asNamespace("sciVizModules"))), info = name)
    }
})

test_that("wells parse in every format and plate sizes are detected", {
    w <- .plate_parse_wells(c("A01", "a1", "H12", "P24", "AF48", " B07 "))
    expect_identical(w$row, c(1L, 1L, 8L, 16L, 32L, 2L))
    expect_identical(w$col, c(1L, 1L, 12L, 24L, 48L, 7L))
    expect_identical(.plate_row_label(c(1, 26, 27, 32)), c("A", "Z", "AA", "AF"))
    expect_error(.plate_parse_wells(c("A01", "well 3")), "Unrecognised")

    expect_identical(.plate_format(c(1, 8), c(1, 12))$wells, 96L)
    expect_identical(.plate_format(c(1, 9), c(1, 12))$wells, 384L)
    expect_identical(.plate_format(c(1, 17), c(1, 2))$wells, 1536L)
    expect_identical(.plate_format(c(1, 2), c(1, 2), 384)$nrow, 16)
    expect_error(.plate_format(c(1, 9), c(1, 2), 96), "outside")
})

test_that("normalisations follow their definitions", {
    set.seed(1)
    grid <- expand.grid(col = 1:12, row = 1:8)
    role <- ifelse(grid$col == 1, "negative", ifelse(grid$col == 12, "positive", "sample"))
    x <- ifelse(role == "positive", 100, 1000) + stats::rnorm(96, sd = 20) + 30 * grid$row
    s <- role == "sample"
    neg <- mean(x[role == "negative"])
    pos <- mean(x[role == "positive"])

    expect_identical(.plate_normalise(x, grid$row, grid$col, role, "raw"), x)
    expect_equal(.plate_normalise(x, grid$row, grid$col, role, "percent.control"), 100 * x / neg)
    pin <- .plate_normalise(x, grid$row, grid$col, role, "percent.inhibition")
    expect_equal(mean(pin[role == "negative"]), 0)
    expect_equal(mean(pin[role == "positive"]), 100)
    z <- .plate_normalise(x, grid$row, grid$col, role, "zscore")
    expect_equal(c(mean(z[s]), stats::sd(z[s])), c(0, 1))
    rz <- .plate_normalise(x, grid$row, grid$col, role, "robust.z")
    expect_equal(c(stats::median(rz[s]), stats::mad(rz[s])), c(0, 1))

    # The B-score is medpolish's residual over its MAD, and removes the row trend.
    b <- .plate_normalise(x, grid$row, grid$col, role, "bscore")
    m <- matrix(x[s], nrow = 8, byrow = TRUE)
    mp <- stats::medpolish(m, trace.iter = FALSE)
    expect_equal(b[s], as.vector(t(mp$residuals)) / stats::mad(mp$residuals))
    expect_lt(abs(stats::cor(b[s], grid$row[s])), 0.2)
    expect_gt(stats::cor(x[s], grid$row[s]), 0.5)

    expect_error(.plate_normalise(x, grid$row, grid$col, rep("sample", 96), "percent.control"), "control wells")
})

test_that("Z' follows Zhang et al.", {
    pos <- c(10, 12, 11, 9)
    neg <- c(100, 98, 103, 99)
    expect_equal(.plate_zprime(pos, neg), 1 - 3 * (stats::sd(pos) + stats::sd(neg)) / abs(mean(pos) - mean(neg)))
    expect_identical(.plate_zprime(1, neg), NA_real_)
})

test_that("the example screen is detected and drawn one heatmap per plate", {
    data("example_plate", package = "sciVizModules", envir = environment())
    cols <- .plate_columns(example_plate)
    expect_identical(unlist(cols, use.names = FALSE),
        c("well", "signal", "plate", "type", "positive", "negative"))

    fig <- plateHeatmap(example_plate, "well", "signal", "plate", "type", "positive", "negative")
    built <- plotly::plotly_build(fig)
    heats <- Filter(function(tr) identical(tr$type, "heatmap"), built$x$data)
    expect_length(heats, 2)
    expect_identical(dim(heats[[1]]$z), c(16L, 24L))
    # Row A is drawn at the top.
    expect_identical(heats[[1]]$z[16, 1], example_plate$signal[example_plate$plate == "Plate_01" &
        example_plate$well == "A01"])
    # 32 controls per plate are outlined on that plate's axes.
    expect_length(built$x$layout$shapes, 64)
    expect_identical(built$x$layout$shapes[[64]]$xref, heats[[2]]$xaxis)
    titles <- vapply(built$x$layout$annotations, function(a) a$text, character(1))
    expect_true(all(grepl("Z' = 0[.][67]", titles)))

    stats <- attr(fig, "table")
    expect_identical(stats$plate, c("Plate_01", "Plate_02"))
    expect_true(all(stats$positive.n == 16 & stats$negative.n == 16))
    # The first plate's edge effect is the stronger.
    expect_lt(stats$edge.ratio[1], stats$edge.ratio[2])

    marg <- plotly::plotly_build(plateHeatmap(example_plate, "well", "signal", "plate", "type", "positive",
        "negative", normalise = "bscore", marginals = TRUE, show.controls = FALSE))
    bars <- Filter(function(tr) identical(tr$type, "bar"), marg$x$data)
    expect_length(bars, 4)
    expect_length(marg$x$layout$shapes, 0)
    # The row and column means are hover text only; the thin margins have no room to print them.
    expect_true(all(unlist(lapply(bars, `[[`, "textposition")) == "none"))
    expect_true(all(unlist(lapply(bars, `[[`, "hoverinfo")) == "text"))

    expect_error(plateHeatmap(rbind(example_plate, example_plate), "well", "signal", "plate"), "Duplicate")
})

test_that("the server builds, follows the control column, and exports the plate stats", {
    data("example_plate", package = "sciVizModules", envir = environment())
    shiny::testServer(
        plateHeatmapServer,
        args = list(data = shiny::reactive(example_plate)),
        expr = {
            do.call(session$setInputs, c(
                list(auto.update = TRUE, well.col = "well", value.col = "signal", plate.col = "plate",
                    control.col = "type", positive = "positive", negative = "negative", normalise = "robust.z",
                    plate.format = "auto", marginals = FALSE, show.controls = TRUE, ncols = 1,
                    color.low = "#2166AC", color.mid = "#F7F7F7", color.high = "#B2182B", midpoint = NA,
                    positive.color = "#E7298A", negative.color = "#000000", download.format = "png"),
                test_axes_inputs()
            ))
            built <- plotly::plotly_build(generate_plot())
            expect_length(Filter(function(tr) identical(tr$type, "heatmap"), built$x$data), 2)
            expect_false(isTRUE(built$x$layout$showlegend))
            expect_identical(nrow(plot_source_reactive()$stats), 2L)

            # The browser answers the frozen label updates; testServer has no browser.
            session$setInputs(control.col = "")
            session$setInputs(positive = "", negative = "")
            built <- plotly::plotly_build(generate_plot())
            expect_length(built$x$layout$shapes, 0)
        }
    )
    expect_true(inherits(plateHeatmapInputsUI("p", example_plate), c("shiny.tag", "shiny.tag.list")))
})

test_that("gridlines are off by default and a caller can turn them back on", {
    data("example_plate", package = "sciVizModules", envir = environment())
    d <- .plate_axes_defaults(NULL)
    expect_false(d$show.grid.x)
    expect_false(d$show.grid.y)
    d <- .plate_axes_defaults(list(show.grid.x = TRUE, normalise = "zscore"))
    expect_true(d$show.grid.x)
    expect_false(d$show.grid.y)
    expect_identical(d$normalise, "zscore")

    checked <- function(html, id) {
        tag <- regmatches(html, regexpr(paste0("<input id=\"p-", id, "\"[^>]*>"), html))
        grepl("checked", tag, fixed = TRUE)
    }
    html <- as.character(plateHeatmapInputsUI("p", example_plate))
    expect_false(checked(html, "show.grid.x"))
    expect_false(checked(html, "show.grid.y"))
    html <- as.character(plateHeatmapInputsUI("p", example_plate, defaults = list(show.grid.y = TRUE)))
    expect_true(checked(html, "show.grid.y"))
})

test_that("the server hides the gridline inputs along with the caller's", {
    data("example_plate", package = "sciVizModules", envir = environment())
    hidden <- NULL
    local_mocked_bindings(hide_input = function(session, ids) hidden <<- c(hidden, ids))
    shiny::testServer(
        plateHeatmapServer,
        args = list(data = shiny::reactive(example_plate), hide.inputs = "ncols"),
        expr = NULL
    )
    expect_true(all(c("ncols", "show.grid.x", "show.grid.y", "grid.color") %in% hidden))
})
