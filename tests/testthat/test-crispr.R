# Tests for read_mageck() and the crisprScreenRank module.

crispr_example_file <- function() {
    system.file("extdata", "example_mageck.gene_summary.txt.gz", package = "sciVizModules")
}

crispr_mle_file <- function() {
    system.file("extdata", "example_mageck_mle.gene_summary.txt.gz", package = "sciVizModules")
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
    # So is one read with the default check.names = TRUE, as a Shiny upload reads it.
    uploaded <- utils::read.delim(gzfile(crispr_example_file()), stringsAsFactors = TRUE)
    expect_identical(names(.mageck_tidy(uploaded)), names(screen))
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
    expect_identical(.mageck_conditions(out), "drug")
    expect_identical(.mageck_conditions(read_mageck(crispr_example_file())), character(0))

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
    # Ranked by FDR, with MAGeCK's rank breaking the ties.
    best <- screen[screen$pos.fdr == min(screen$pos.fdr), ]
    expect_identical(pos$gene[1], best$gene[which.min(best$pos.rank)])
    expect_equal(pos$screen.metric, -log10(pmax(pos$pos.fdr, min(pos$pos.fdr[pos$pos.fdr > 0]))))
    expect_identical(sum(pos$screen.group == "Enriched"), sum(screen$pos.fdr < 0.05))
})

test_that("genes are ranked by the plotted statistic, so the curve is monotone", {
    screen <- read_mageck(crispr_example_file())
    for (metric in c("lfc", "score", "fdr")) {
        neg <- .crispr_prepare(screen, "neg", metric, 0.05)
        pos <- .crispr_prepare(screen, "pos", metric, 0.05)
        if (metric == "lfc") {
            expect_false(is.unsorted(neg$screen.metric), label = metric)
        } else {
            expect_false(is.unsorted(rev(neg$screen.metric)), label = metric)
        }
        expect_false(is.unsorted(rev(pos$screen.metric)), label = metric)
    }
    # The RRA score keeps MAGeCK's own rank.
    expect_identical(.crispr_prepare(screen, "pos", "score")$pos.rank, seq_len(nrow(screen)))
})

test_that("an MLE summary is ranked within one condition, with hits in the chosen direction", {
    mle <- read_mageck(crispr_mle_file())
    expect_identical(attr(mle, "mageck_type"), "mle")
    expect_identical(.mageck_conditions(mle), c("dmso", "drug"))
    # The default check.names = TRUE spelling is read the same way.
    uploaded <- utils::read.delim(gzfile(crispr_mle_file()), stringsAsFactors = TRUE)
    expect_identical(names(.mageck_tidy(uploaded)), names(mle))

    neg <- .crispr_prepare(mle, "neg", "lfc", 0.05)
    expect_identical(attr(neg, "mageck_condition"), "dmso")
    expect_identical(neg$screen.lfc, neg$dmso.beta)
    expect_false(is.unsorted(neg$screen.metric))
    expect_true(all(neg$dmso.beta[neg$screen.group == "Depleted"] < 0))
    expect_identical(sum(neg$screen.group == "Depleted"), sum(mle$dmso.fdr < 0.05 & mle$dmso.beta < 0))

    pos <- .crispr_prepare(mle, "pos", "fdr", 0.05, condition = "drug")
    expect_identical(attr(pos, "mageck_condition"), "drug")
    expect_identical(sum(pos$screen.group == "Enriched"), sum(mle$drug.fdr < 0.05 & mle$drug.beta > 0))
    # Genes whose beta points the chosen way rank first, by FDR.
    up <- pos$drug.beta > 0
    expect_false(is.unsorted(!up))
    expect_false(is.unsorted(rev(pos$screen.metric[up])))

    z <- .crispr_prepare(mle, "pos", "score", 0.05, condition = "drug")
    expect_identical(z$screen.metric, z$drug.z)
    expect_false(is.unsorted(rev(z$screen.metric)))
    # An unknown condition falls back to the first.
    expect_identical(attr(.crispr_prepare(mle, condition = "nope"), "mageck_condition"), "dmso")
})

test_that("factor gene columns, as the data filter delivers them, label as text", {
    screen <- read_mageck(crispr_example_file())
    screen$gene <- factor(screen$gene)
    prepared <- .crispr_prepare(screen, "neg", "lfc", 0.05)
    expect_type(prepared$gene, "character")

    fig <- plotly::plotly_build(plotly::plot_ly(x = 1:2, y = 1:2, type = "scatter", mode = "markers"))
    input <- list(x.by = "screen.rank", y.by = "screen.metric", direction = "neg", metric = "lfc",
        fdr.threshold = 0.05, n.labels = 3, label.size = 10)
    out <- .crispr_layers(fig, prepared, input, identity)
    texts <- lapply(out$x$layout$annotations, `[[`, "text")
    expect_true(all(vapply(texts, is.character, logical(1))))
    # The manual-edit capture keys annotations by their text; it must not error on these.
    expect_silent(keys <- VizModules:::.annotation_edit_keys(out$x$layout$annotations))
    expect_false(anyNA(keys))
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

    # An MLE table titles the y-axis with its own statistic.
    mle <- .crispr_prepare(read_mageck(crispr_mle_file()), "neg", "lfc", 0.05)
    beta <- .crispr_layers(fig, mle, utils::modifyList(input, list(metric = "lfc", n.labels = 0)), identity)
    expect_identical(beta$x$layout$yaxis$title$text, "Beta")
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

test_that("the inputs offer a condition and MLE labels only for an MLE summary", {
    rra <- as.character(crisprScreenRankInputsUI("c", read_mageck(crispr_example_file())))
    expect_false(grepl("c-condition", rra, fixed = TRUE))
    expect_true(grepl("-log10(RRA score)", rra, fixed = TRUE))

    mle <- as.character(crisprScreenRankInputsUI("c", read_mageck(crispr_mle_file()),
        defaults = list(condition = "drug")))
    expect_true(grepl("c-condition", mle, fixed = TRUE))
    expect_true(grepl("z-score", mle, fixed = TRUE))
    expect_true(grepl('"selectedValue":"drug"', mle, fixed = TRUE))
    expect_identical(.crispr_defaults(read_mageck(crispr_mle_file()))$condition, "dmso")
    expect_null(.crispr_defaults(read_mageck(crispr_example_file()))$condition)
})

test_that("the server plots the chosen MLE condition", {
    mle <- read_mageck(crispr_mle_file())
    captured <- NULL
    local_mocked_bindings(
        dittoViz_scatterPlotServer = function(id, data, hide.inputs, hide.tabs, defaults, fig.fn) {
            captured <<- list(data = data)
        }
    )
    shiny::testServer(crisprScreenRankServer, args = list(data = shiny::reactive(mle)), expr = {
        session$setInputs(auto.update = TRUE, direction = "pos", metric = "lfc", fdr.threshold = 0.05,
            condition = "drug")
        prepared <- captured$data()
        expect_identical(attr(prepared, "mageck_condition"), "drug")
        expect_identical(prepared$gene[1], mle$gene[which.max(mle$drug.beta)])
    })
})

test_that("the app bundles both MAGeCK examples", {
    expect_s3_class(crisprScreenRankApp(), "shiny.appobj")
    expect_identical(attr(.crispr_example("mle"), "mageck_type"), "mle")
})
