# Tests for the gseaEnrichmentPlot module. The running score is checked against
# fgsea itself where it is installed.

test_that("all gseaEnrichmentPlot functions are exported", {
    for (name in c("gseaEnrichmentPlot", "gseaEnrichmentPlotInputsUI", "gseaEnrichmentPlotOutputUI",
        "gseaEnrichmentPlotServer", "gseaEnrichmentPlotApp")) {
        expect_true(is.function(get0(name, envir = asNamespace("sciVizModules"))), info = name)
    }
})

test_that("the running score and enrichment score match fgsea", {
    skip_if_not_installed("fgsea")
    data(example_gsea, package = "sciVizModules")
    stats <- example_gsea$stats
    ranked <- sort(stats, decreasing = TRUE)
    for (pw in names(example_gsea$pathways)[1:5]) {
        genes <- example_gsea$pathways[[pw]]
        run <- .gsea_running(stats, genes)
        idx <- sort(unique(stats::na.omit(match(genes, names(ranked)))))
        expect_equal(run$es, fgsea::calcGseaStat(abs(ranked), idx), info = pw)
        expect_equal(run$curve$es, fgsea::plotEnrichmentData(genes, stats)$curve$ES, info = pw)
        # fgsea's stored ES is computed at lower precision than calcGseaStat().
        expect_equal(run$es, example_gsea$results$ES[example_gsea$results$pathway == pw], tolerance = 1e-6,
            info = pw)
        expect_setequal(run$leading.edge,
            example_gsea$results$leadingEdge[[which(example_gsea$results$pathway == pw)]])
    }
    # A different weight exponent is passed through.
    expect_equal(.gsea_running(stats, example_gsea$pathways[[1]], gsea.param = 0)$es,
        fgsea::calcGseaStat(rep(1, length(ranked)),
            sort(unique(stats::na.omit(match(example_gsea$pathways[[1]], names(ranked)))))))
})

test_that("a depleted set has a negative score and a tail leading edge", {
    stats <- stats::setNames(seq(10, -10, length.out = 21), paste0("g", 1:21))
    run <- .gsea_running(stats, c("g19", "g20", "g21"))
    expect_lt(run$es, 0)
    expect_setequal(run$leading.edge, c("g19", "g20", "g21"))
    expect_null(.gsea_running(stats, "not_a_gene"))
})

test_that("inputs are normalised from a bundle and rejected otherwise", {
    data(example_gsea, package = "sciVizModules")
    x <- .gsea_input(example_gsea)
    expect_s3_class(x, "gsea_bundle")
    expect_true(all(c("pathway", "NES", "padj") %in% names(x$results)))
    expect_identical(.gsea_default_pathways(x, 2), example_gsea$results$pathway[order(example_gsea$results$padj)][1:2])
    expect_error(.gsea_input(list(stats = 1:3)), "gseaResult or a list")

    no_results <- .gsea_input(example_gsea[c("stats", "pathways")])
    expect_null(no_results$results)
    expect_identical(.gsea_default_pathways(no_results, 1), names(example_gsea$pathways)[1])
})

test_that("a clusterProfiler gseaResult is read through its slots", {
    skip_if_not_installed("DOSE")
    data(example_gsea, package = "sciVizModules")
    res <- example_gsea$results
    obj <- methods::new("gseaResult",
        result = data.frame(ID = res$pathway, Description = paste("Set", seq_len(nrow(res))),
            setSize = res$size, enrichmentScore = res$ES, NES = res$NES, pvalue = res$pval,
            p.adjust = res$padj, row.names = res$pathway),
        geneSets = example_gsea$pathways, geneList = example_gsea$stats
    )
    x <- .gsea_input(obj)
    expect_identical(x$labels[[res$pathway[1]]], "Set 1")
    expect_equal(x$results$NES, res$NES)
})

test_that("the plot has a running score, tick rows and the ranked metric", {
    data(example_gsea, package = "sciVizModules")
    sets <- names(example_gsea$pathways)[1:2]
    fig <- gseaEnrichmentPlot(example_gsea, pathways = sets)
    built <- plotly::plotly_build(fig)
    # Two running-score lines, two tick rows, one metric area.
    expect_length(built$x$data, 5)
    expect_match(built$x$data[[1]]$name, "NES")
    expect_length(built$x$layout$shapes, 2)
    expect_identical(built$x$layout$yaxis$title$text, "Enrichment score")

    table <- attr(fig, "table")
    expect_identical(table$pathway, sets)
    expect_equal(table$NES, example_gsea$results$NES[match(sets, example_gsea$results$pathway)])

    bare <- plotly::plotly_build(gseaEnrichmentPlot(example_gsea[c("stats", "pathways")], pathways = sets[1],
        show.ticks = FALSE, show.metric = FALSE))
    expect_length(bare$x$data, 1)
    expect_match(bare$x$data[[1]]$name, "ES")
    expect_error(gseaEnrichmentPlot(example_gsea, pathways = "nope"), "at least one")
})

test_that("the server builds, finishes and exports the gene set summary", {
    data(example_gsea, package = "sciVizModules")
    sets <- names(example_gsea$pathways)[1:3]
    shiny::testServer(
        gseaEnrichmentPlotServer,
        args = list(data = shiny::reactive(example_gsea)),
        expr = {
            do.call(session$setInputs, c(
                list(auto.update = TRUE, pathways = sets, gsea.param = 1, show.ticks = TRUE,
                    show.metric = TRUE, metric.color = "#7F7F7F", download.format = "png"),
                utils::modifyList(test_axes_inputs(), list(show.grid.y = TRUE)), test_legend_inputs()
            ))
            built <- plotly::plotly_build(generate_plot())
            expect_false(built$x$layout$showlegend)
            expect_identical(nrow(plot_source_reactive()$stats), 3L)
            # The tick strip keeps its rows free of gridlines; the others take the Axes tab's.
            expect_true(built$x$layout$yaxis$showgrid)
            expect_false(built$x$layout$yaxis2$showgrid)
            # Three ES lines and a border around each of the three panels.
            rects <- Filter(function(s) identical(s$type, "rect"), built$x$layout$shapes)
            expect_length(built$x$layout$shapes, 6)
            expect_length(rects, 3)
        }
    )
    expect_true(inherits(gseaEnrichmentPlotInputsUI("g", example_gsea), c("shiny.tag", "shiny.tag.list")))
})
