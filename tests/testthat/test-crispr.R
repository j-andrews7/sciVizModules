# Tests for read_mageck() and the crisprScreenRank module.

crispr_example_file <- function() {
    system.file("extdata", "example_mageck.gene_summary.txt.gz", package = "sciVizModules")
}

test_that("all crisprScreenRank functions are exported", {
    for (name in c("read_mageck", "crisprScreenRankInputsUI", "crisprScreenRankOutputUI",
        "crisprScreenRankServer", "crisprScreenRankApp")) {
        expect_true(is.function(get0(name, envir = asNamespace("sciVizModules"))), info = name)
    }
})

test_that("read_mageck() tidies an RRA gene summary", {
    screen <- read_mageck(crispr_example_file())
    expect_identical(attr(screen, "mageck_type"), "rra")
    expect_identical(nrow(screen), 2000L)
    expect_true(all(c("gene", "n.sgrna", "neg.score", "neg.p", "neg.fdr", "neg.rank", "neg.goodsgrna",
        "neg.lfc", "pos.score", "pos.p", "pos.fdr", "pos.rank", "pos.goodsgrna", "pos.lfc") %in% names(screen)))
    # Already tidy: returned unchanged.
    expect_identical(.mageck_tidy(screen), screen)

    # A raw table read with check.names = FALSE is tidied the same way.
    raw <- utils::read.delim(gzfile(crispr_example_file()), check.names = FALSE)
    expect_identical(names(.mageck_tidy(raw)), names(screen))
})

test_that("read_mageck() reads an MLE gene summary and rejects other tables", {
    mle <- tempfile(fileext = ".txt")
    writeLines(c(
        "Gene\tsgRNA\tdrug|beta\tdrug|z\tdrug|p-value\tdrug|fdr\tdrug|wald-p-value\tdrug|wald-fdr",
        "A\t4\t-1.2\t-3.1\t0.001\t0.01\t0.002\t0.02",
        "B\t4\t0.1\t0.2\t0.8\t0.9\t0.85\t0.95"
    ), mle)
    out <- read_mageck(mle)
    expect_identical(attr(out, "mageck_type"), "mle")
    expect_identical(names(out), c("gene", "n.sgrna", "drug.beta", "drug.z", "drug.p", "drug.fdr",
        "drug.wald.p", "drug.wald.fdr"))
    expect_error(.crispr_prepare(out), "mageck test")

    bad <- tempfile(fileext = ".txt")
    writeLines(c("x\ty", "1\t2"), bad)
    expect_error(read_mageck(bad), "Not a MAGeCK gene summary")
    expect_error(read_mageck("no-such-file.txt"), "File not found")
})

test_that("genes are ranked by the chosen selection and flagged by FDR", {
    screen <- read_mageck(crispr_example_file())
    neg <- .crispr_prepare(screen, "neg", "lfc", 0.05)
    expect_identical(neg$screen.rank, seq_len(nrow(screen)))
    expect_identical(neg$screen.lfc, neg$neg.lfc)
    expect_identical(sum(neg$screen.group == "Depleted"), sum(screen$neg.fdr < 0.05))
    expect_false(any(neg$screen.group == "Enriched"))

    pos <- .crispr_prepare(screen, "pos", "fdr", 0.05)
    expect_identical(pos$gene[1], screen$gene[which.min(screen$pos.rank)])
    expect_equal(pos$screen.metric, -log10(pmax(pos$pos.fdr, min(pos$pos.fdr[pos$pos.fdr > 0]))))
    expect_identical(sum(pos$screen.group == "Enriched"), sum(screen$pos.fdr < 0.05))
})

test_that("the layers label the top genes and draw the FDR line", {
    screen <- .crispr_prepare(read_mageck(crispr_example_file()), "neg", "fdr", 0.05)
    fig <- plotly::plotly_build(plotly::plot_ly(x = 1:2, y = 1:2, type = "scatter", mode = "markers"))
    input <- list(x.by = "screen.rank", y.by = "screen.metric", direction = "neg", metric = "fdr",
        fdr.threshold = 0.05, n.labels = 5, label.size = 10)
    out <- .crispr_layers(fig, screen, input, identity)
    expect_identical(vapply(out$x$layout$annotations, `[[`, "", "text"), screen$gene[1:5])
    expect_equal(out$x$layout$shapes[[1]]$y0, -log10(0.05))
    expect_identical(out$x$layout$yaxis$title$text, "-log10(FDR)")

    lfc <- .crispr_layers(fig, screen, utils::modifyList(input, list(metric = "lfc", n.labels = 0)), identity)
    expect_length(lfc$x$layout$shapes, 0)
    expect_length(lfc$x$layout$annotations, 0)
    moved <- .crispr_layers(fig, screen, utils::modifyList(input, list(y.by = "neg.p")), identity)
    expect_length(moved$x$layout$annotations, 0)
})

test_that("the server hands the scatter module the ranked table and a fig.fn hook", {
    screen <- read_mageck(crispr_example_file())
    captured <- NULL
    local_mocked_bindings(
        dittoViz_scatterPlotServer = function(id, data, hide.inputs, hide.tabs, defaults, fig.fn) {
            captured <<- list(defaults = defaults, fig.fn = fig.fn, data = data, hide.tabs = hide.tabs)
        }
    )
    shiny::testServer(crisprScreenRankServer, args = list(data = shiny::reactive(screen)), expr = {
        session$setInputs(auto.update = TRUE, direction = "pos", metric = "score", fdr.threshold = 0.1)
        prepared <- captured$data()
        expect_identical(prepared$gene[1], screen$gene[which.min(screen$pos.rank)])
    })
    expect_true(is.function(captured$fig.fn))
    expect_identical(captured$defaults$x.by, "screen.rank")
    expect_false(any(.crispr_keys %in% names(captured$defaults)))
    expect_identical(captured$hide.tabs, c("Trajectory", "Facet"))
})

test_that("a rank plot builds end to end through the scatter module", {
    screen <- .crispr_prepare(read_mageck(crispr_example_file()), "neg", "lfc", 0.05)
    built <- build_scatter_figure(screen,
        fig.fn = function(fig, input, isolate_fn) .crispr_layers(fig, screen, input, isolate_fn),
        inputs = test_scatter_inputs(x.by = "screen.rank", y.by = "screen.metric", color.by = "screen.group",
            direction = "neg", metric = "lfc", fdr.threshold = 0.05, n.labels = 3, label.size = 11, webgl = FALSE)
    )
    texts <- vapply(built$x$layout$annotations, function(a) as.character(a$text %||% ""), "")
    expect_true(all(c("Gene rank (depletion)", "Log2 fold change", screen$gene[1:3]) %in% texts))
    expect_true(inherits(crisprScreenRankInputsUI("c", read_mageck(crispr_example_file())),
        c("shiny.tag", "shiny.tag.list")))
})
