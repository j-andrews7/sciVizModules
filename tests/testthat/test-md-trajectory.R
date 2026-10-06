# Tests for read_xvg() and the mdTrajectoryMetrics module.

md_file <- function(f) system.file("extdata", f, package = "sciVizModules")

test_that("all mdTrajectoryMetrics functions are exported", {
    for (name in c("read_xvg", "mdTrajectoryMetrics", "mdTrajectoryMetricsInputsUI", "mdTrajectoryMetricsOutputUI",
        "mdTrajectoryMetricsServer", "mdTrajectoryMetricsApp")) {
        expect_true(is.function(get0(name, envir = asNamespace("sciVizModules"))), info = name)
    }
})

test_that("read_xvg() keeps labels and legends and strips Grace codes", {
    rg <- read_xvg(md_file("example_gyrate.xvg.gz"))
    expect_identical(unique(rg$series), c("Rg", "RgX", "RgY", "RgZ"))
    expect_identical(nrow(rg), 4L * 1001L)
    expect_identical(unique(rg$x.label), "Time (ps)")
    expect_identical(unique(rg$y.label), "Rg (nm)")
    expect_identical(unique(rg$metric), "Radius of gyration (total and around axes)")

    rmsd <- read_xvg(md_file("example_rmsd_rep1.xvg.gz"))
    expect_identical(unique(rmsd$series), "example_rmsd_rep1")
    expect_identical(unique(read_xvg(md_file("example_rmsd_rep1.xvg.gz"), series = "rep 1")$series), "rep 1")

    bad <- tempfile(fileext = ".xvg")
    writeLines(c("# nothing", "@ title \"x\""), bad)
    expect_error(read_xvg(bad), "No data")
    expect_error(read_xvg("nope.xvg"), "File not found")
    expect_identical(.xvg_clean("Rg\\sX\\N"), "RgX")
})

test_that("units convert only when the label names the unit", {
    conv <- .md_convert(c(1000, 2000, 5), c("Time (ps)", "Time (ps)", "Residue"), "ps to ns", "time")
    expect_identical(conv$values, c(1, 2, 5))
    expect_identical(conv$labels, c("Time (ns)", "Time (ns)", "Residue"))
    expect_identical(.md_convert(1, "RMSD (nm)", "nm to A", "length")$values, 10)
    expect_identical(.md_convert(1, "RMSD (nm)", "as is", "length")$values, 1)
})

test_that("the plot draws a line per group, smooths, and panels by metric", {
    ex <- .md_example()
    fig <- mdTrajectoryMetrics(ex$trajectory, facet = "metric", smooth.window = 11, time.unit = "ps to ns")
    built <- plotly::plotly_build(fig)
    # RMSD: 3 replicas x (raw + smooth); Rg: 1 x (raw + smooth).
    expect_length(built$x$data, 8)
    expect_identical(built$x$layout$xaxis$title$text, "Time (ns)")
    expect_equal(max(unlist(built$x$data[[1]]$x)), 100)

    table <- attr(fig, "table")
    expect_identical(nrow(table), 4L)
    rmsd1 <- ex$trajectory$value[ex$trajectory$metric == "RMSD" & ex$trajectory$series == "replica 1"]
    expect_equal(table$mean[table$panel == "RMSD" & table$group == "replica 1"], mean(rmsd1))

    # The smoothed trace is the centred running mean.
    sm <- suppressWarnings(as.numeric(unlist(built$x$data[[2]]$y)))
    expect_equal(sm[!is.na(sm)][1], mean(rmsd1[1:11]))

    plain <- plotly::plotly_build(mdTrajectoryMetrics(ex$rmsf, group = NULL))
    expect_length(plain$x$data, 1)
    expect_error(mdTrajectoryMetrics(ex$rmsf, x = "nope"), "not in the data")
})

test_that("the server builds, finishes and exports the summary", {
    ex <- .md_example()
    shiny::testServer(
        mdTrajectoryMetricsServer,
        args = list(data = shiny::reactive(ex$trajectory)),
        expr = {
            do.call(session$setInputs, c(
                list(auto.update = TRUE, x.col = "x", y.col = "value", group.col = "series", facet.col = "metric",
                    smooth.window = 5, time.unit = "ps to ns", length.unit = "as is", show.raw = TRUE,
                    raw.opacity = 0.3, download.format = "png"),
                test_axes_inputs(), test_legend_inputs()
            ))
            built <- plotly::plotly_build(generate_plot())
            expect_false(built$x$layout$showlegend)
            expect_identical(nrow(plot_source_reactive()$stats), 4L)
        }
    )
    d <- .md_defaults(ex$trajectory)
    expect_identical(c(d$x.col, d$y.col, d$group.col, d$facet.col), c("x", "value", "series", "metric"))
    expect_identical(.md_defaults(ex$rmsf)$facet.col, "")
    expect_true(inherits(mdTrajectoryMetricsInputsUI("m", ex$trajectory), c("shiny.tag", "shiny.tag.list")))
})

test_that("Group By and Panel By leave out columns with too many levels", {
    df <- data.frame(
        time = seq_len(60),
        rmsd = seq_len(60) / 10,
        frame.id = paste0("f", seq_len(60)),
        series = rep(c("rep1", "rep2"), 30),
        stringsAsFactors = FALSE
    )
    choices_of <- function(html, id) {
        config <- regmatches(html, regexpr(paste0("data-for=\"", id, "\">.*?</script>"), html))
        opts <- jsonlite::fromJSON(sub("</script>$", "", sub("^data-for=\"[^\"]+\">", "", config)))$options
        unlist(opts$choices$value %||% lapply(opts$choices, function(g) g$value))
    }

    html <- as.character(mdTrajectoryMetricsInputsUI("md", df))
    for (id in c("md-group.col", "md-facet.col")) {
        expect_true("series" %in% choices_of(html, id), info = id)
        expect_false("frame.id" %in% choices_of(html, id), info = id)
    }
})
