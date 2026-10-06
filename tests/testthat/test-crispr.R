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

test_that("RRA genes take their better side, signed, with hits flagged by that side's FDR", {
    screen <- read_mageck(crispr_example_file())
    lfc <- .crispr_prepare(screen, "lfc", 0.05)
    expect_identical(lfc$screen.rank, seq_len(nrow(screen)))
    expect_identical(lfc$screen.lfc, lfc$neg.lfc)
    expect_identical(lfc$screen.metric, lfc$neg.lfc)

    # Each gene's side is the one with the smaller RRA score.
    depleted <- lfc$neg.score <= lfc$pos.score
    expect_identical(lfc$screen.fdr, ifelse(depleted, lfc$neg.fdr, lfc$pos.fdr))
    expect_identical(sum(lfc$screen.group == "Depleted"), sum(depleted & lfc$neg.fdr < 0.05))
    expect_identical(sum(lfc$screen.group == "Enriched"), sum(!depleted & lfc$pos.fdr < 0.05))
    # Both directions are on the one plot.
    expect_gt(sum(lfc$screen.group == "Depleted"), 0)
    expect_gt(sum(lfc$screen.group == "Enriched"), 0)

    fdr <- .crispr_prepare(screen, "fdr", 0.05)
    neglog <- function(v) -log10(pmax(v, min(v[v > 0])))
    expect_equal(fdr$screen.metric, ifelse(fdr$neg.score <= fdr$pos.score, -1, 1) * neglog(fdr$screen.fdr))
    expect_true(all(fdr$screen.metric[fdr$screen.group == "Depleted"] < 0))
    expect_true(all(fdr$screen.metric[fdr$screen.group == "Enriched"] > 0))
    # The hits do not depend on the statistic plotted.
    expect_identical(sort(fdr$gene[fdr$screen.group != "n.s."]), sort(lfc$gene[lfc$screen.group != "n.s."]))
})

test_that("genes are ranked by the plotted statistic, depleted first and enriched last", {
    screen <- read_mageck(crispr_example_file())
    for (metric in c("lfc", "score", "fdr")) {
        p <- .crispr_prepare(screen, metric, 0.05)
        expect_false(is.unsorted(p$screen.metric), label = metric)
        expect_identical(as.character(p$screen.group[1]), "Depleted", label = metric)
        expect_identical(as.character(p$screen.group[nrow(p)]), "Enriched", label = metric)
    }
    # The signed score ranks each side by its RRA score, as MAGeCK does.
    score <- .crispr_prepare(screen, "score")
    side <- score$neg.score <= score$pos.score
    expect_false(is.unsorted(score$neg.score[side]))
    expect_false(is.unsorted(rev(score$pos.score[!side])))
})

test_that("an MLE summary is ranked within one condition, its FDR signed by the beta", {
    mle <- read_mageck(crispr_mle_file())
    expect_identical(attr(mle, "mageck_type"), "mle")
    expect_identical(.mageck_conditions(mle), c("dmso", "drug"))
    # The default check.names = TRUE spelling is read the same way.
    uploaded <- utils::read.delim(gzfile(crispr_mle_file()), stringsAsFactors = TRUE)
    expect_identical(names(.mageck_tidy(uploaded)), names(mle))

    beta <- .crispr_prepare(mle, "lfc", 0.05)
    expect_identical(attr(beta, "mageck_condition"), "dmso")
    expect_identical(beta$screen.lfc, beta$dmso.beta)
    expect_false(is.unsorted(beta$screen.metric))
    expect_identical(sum(beta$screen.group == "Depleted"), sum(mle$dmso.fdr < 0.05 & mle$dmso.beta < 0))
    expect_identical(sum(beta$screen.group == "Enriched"), sum(mle$dmso.fdr < 0.05 & mle$dmso.beta >= 0))

    fdr <- .crispr_prepare(mle, "fdr", 0.05, condition = "drug")
    expect_identical(attr(fdr, "mageck_condition"), "drug")
    expect_false(is.unsorted(fdr$screen.metric))
    expect_identical(sign(fdr$screen.metric[fdr$screen.metric != 0]),
        ifelse(fdr$drug.beta < 0, -1, 1)[fdr$screen.metric != 0])
    expect_true(all(fdr$drug.beta[fdr$screen.group == "Depleted"] < 0))
    expect_true(all(fdr$drug.beta[fdr$screen.group == "Enriched"] > 0))
    expect_gt(sum(fdr$screen.group == "Enriched"), 0)

    z <- .crispr_prepare(mle, "score", 0.05, condition = "drug")
    expect_identical(z$screen.metric, z$drug.z)
    expect_false(is.unsorted(z$screen.metric))
    # An unknown condition falls back to the first.
    expect_identical(attr(.crispr_prepare(mle, condition = "nope"), "mageck_condition"), "dmso")
})

test_that("factor gene columns, as the data filter delivers them, label as text", {
    screen <- read_mageck(crispr_example_file())
    screen$gene <- factor(screen$gene)
    prepared <- .crispr_prepare(screen, "lfc", 0.05)
    expect_type(prepared$gene, "character")

    # Genes are labelled through the scatter module's Annotations controls.
    genes <- prepared$gene[1:3]
    built <- build_scatter_figure(prepared,
        fig.fn = function(fig, input, isolate_fn) .crispr_layers(fig, prepared, input, isolate_fn),
        inputs = test_scatter_inputs(x.by = "screen.rank", y.by = "screen.metric", color.by = "screen.group",
            metric = "lfc", fdr.threshold = 0.05, annotate.by = "gene",
            highlight.points = paste(genes, collapse = ", "), webgl = FALSE)
    )
    anns <- built$x$layout$annotations
    texts <- vapply(anns, function(a) as.character(a$text %||% ""), "")
    expect_true(all(genes %in% texts))
    # The manual-edit capture keys annotations by their text; it must not error on these.
    expect_silent(keys <- VizModules:::.annotation_edit_keys(anns))
    expect_false(anyNA(keys[texts %in% genes]))
})

test_that("the layers title the axes and draw both FDR lines, and add no labels", {
    screen <- .crispr_prepare(read_mageck(crispr_example_file()), "fdr", 0.05)
    fig <- plotly::plotly_build(plotly::plot_ly(x = 1:2, y = 1:2, type = "scatter", mode = "markers"))
    input <- list(x.by = "screen.rank", y.by = "screen.metric", metric = "fdr", fdr.threshold = 0.05)
    out <- .crispr_layers(fig, screen, input, identity)
    expect_length(out$x$layout$annotations, 0)
    expect_equal(vapply(out$x$layout$shapes, `[[`, 0, "y0"), c(log10(0.05), -log10(0.05)))
    expect_identical(out$x$layout$yaxis$title$text, "Signed -log10(FDR)")
    expect_identical(out$x$layout$xaxis$title$text, "Gene rank")

    lfc <- .crispr_layers(fig, screen, utils::modifyList(input, list(metric = "lfc")), identity)
    expect_length(lfc$x$layout$shapes, 0)
    moved <- .crispr_layers(fig, screen, utils::modifyList(input, list(y.by = "neg.p")), identity)
    expect_length(moved$x$layout$shapes, 0)
    expect_null(moved$x$layout$yaxis$title$text)

    # An MLE table titles the y-axis with its own statistic.
    mle <- .crispr_prepare(read_mageck(crispr_mle_file()), "lfc", 0.05)
    beta <- .crispr_layers(fig, mle, utils::modifyList(input, list(metric = "lfc")), identity)
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
        session$setInputs(auto.update = TRUE, metric = "score", fdr.threshold = 0.1)
        prepared <- captured$data()
        expect_identical(prepared$gene[1], screen$gene[which.min(screen$neg.score)])
        expect_identical(prepared$gene[nrow(prepared)], screen$gene[which.min(screen$pos.score)])
    })
    expect_true(is.function(captured$fig.fn))
    expect_identical(captured$defaults$x.by, "screen.rank")
    expect_false(any(.crispr_keys %in% names(captured$defaults)))
    expect_identical(captured$hide.tabs, c("Trajectory", "Facet"))
})

test_that("a rank plot builds end to end through the scatter module", {
    screen <- .crispr_prepare(read_mageck(crispr_example_file()), "lfc", 0.05)
    built <- build_scatter_figure(screen,
        fig.fn = function(fig, input, isolate_fn) .crispr_layers(fig, screen, input, isolate_fn),
        inputs = test_scatter_inputs(x.by = "screen.rank", y.by = "screen.metric", color.by = "screen.group",
            metric = "lfc", fdr.threshold = 0.05, webgl = FALSE)
    )
    texts <- vapply(built$x$layout$annotations, function(a) as.character(a$text %||% ""), "")
    expect_true(all(c("Gene rank", "Log2 fold change") %in% texts))
    # No gene is labelled until one is asked for in the Annotations tab.
    expect_false(any(screen$gene %in% texts))
    expect_true(inherits(crisprScreenRankInputsUI("c", read_mageck(crispr_example_file())),
        c("shiny.tag", "shiny.tag.list")))
})

test_that("the inputs offer a condition and MLE labels only for an MLE summary", {
    rra <- as.character(crisprScreenRankInputsUI("c", read_mageck(crispr_example_file())))
    expect_false(grepl("c-condition", rra, fixed = TRUE))
    expect_false(grepl("c-direction", rra, fixed = TRUE))
    expect_true(grepl("Signed -log10(RRA score)", rra, fixed = TRUE))

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
        session$setInputs(auto.update = TRUE, metric = "lfc", fdr.threshold = 0.05, condition = "drug")
        prepared <- captured$data()
        expect_identical(attr(prepared, "mageck_condition"), "drug")
        expect_identical(prepared$gene[nrow(prepared)], mle$gene[which.max(mle$drug.beta)])
    })
})

test_that("the app bundles both MAGeCK examples", {
    expect_s3_class(crisprScreenRankApp(), "shiny.appobj")
    expect_identical(attr(.crispr_example("mle"), "mageck_type"), "mle")
})
